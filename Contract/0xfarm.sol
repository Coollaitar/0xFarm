// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// PUSH Comm Contract Interface
interface IPUSHCommInterface {
    function sendNotification(address _channel, address _recipient, bytes calldata _identity) external;
}

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract farm {
    struct Asset {
        uint256 id;
        address owner;
        uint256 value;
        bool isTokenized;
    }

    struct Loan {
        uint256 id;
        uint256 assetId;
        address borrower;
        uint256 amount;
        uint256 interestRate;
        uint256 lendingPeriod;
        uint256 startTime;
        bool isActive;
    }

      
    mapping (uint256 => Asset) public assets;
    mapping (address => uint256[]) public ownerToAssetIds;
    mapping (uint256 => uint256) public tokenIdToAssetId;
    mapping (uint256 => bool) public approvedTokens;
    mapping (uint256 => address) public tokenToOwner;
    mapping (uint256 => Loan) public loans;
    mapping (address => uint256[]) public borrowerToLoanIds;

    uint256 public totalAssets;
    uint256 public totalTokens;
    uint256 public totalLoans;
    IERC20 public tokenContract;

    event AssetTokenized(uint256 assetId, uint256 tokenId, uint256 value, address owner);
    event LoanRequested(uint256 loanId, uint256 assetId, uint256 amount, uint256 interestRate, uint256 lendingPeriod, address borrower);
    event LoanFunded(uint256 loanId, uint256 amount, address lender);
    event LoanRepaid(uint256 loanId, uint256 amount, address borrower);
    event TokenPurchased(uint256 tokenId, uint256 value, address owner);

    constructor(IERC20 _tokenContract) {
        tokenContract = _tokenContract;
    }
    function addAsset(uint _id, address _owner, uint256 _value, bool _isTokenized)public{
            Asset memory Assets = Asset(_id, _owner, _value, _isTokenized);
            // added to mapping
            assets[_id] = Assets;
            totalAssets++;
    }

    function tokenizeAsset(uint256 assetId, uint256 value) public  {
        require(assets[assetId].owner == msg.sender, "Only asset owner can tokenize it");
        require(!assets[assetId].isTokenized, "Asset already tokenized");
        
        assets[assetId].owner = address(this);
        
        uint256 tokenId = totalTokens;
        totalTokens++;
        tokenIdToAssetId[tokenId] = assetId;
        approvedTokens[tokenId] = true;
        tokenToOwner[tokenId] = msg.sender;
        
        assets[assetId].isTokenized = true;
        assets[assetId].value = value;
        
        ownerToAssetIds[msg.sender].push(assetId);
        
        tokenContract.transferFrom(msg.sender, address(this), value);
    
        // tokenContract.transfer(tokenToOwner[tokenId], value);
        tokenContract.transfer(tokenToOwner[tokenId], value);
        
        emit AssetTokenized(assetId, tokenId, value, msg.sender);
    }

       
  function requestLoan(uint256 assetId, uint256 amount, uint256 interestRate, uint256 lendingPeriod) public {
        require(assets[assetId].owner == msg.sender, "Only asset owner can request loan");
        require(assets[assetId].isTokenized, "Asset not tokenized");
        require(amount > 0, "Loan amount must be greater than zero");
        require(interestRate > 0, "Interest rate must be greater than zero");
        require(lendingPeriod > 0, "Lending period must be greater than zero");
        
        uint256 loanId = totalLoans;
        totalLoans++;

        IPUSHCommInterface(0x87da9Af1899ad477C67FeA31ce89c1d2435c77DC).sendNotification(
    0x60E7c5F82744fEEcDE75B9771F0235CA8b9E4Bf0, // from channel - recommended to set channel via dApp and put it's value -> then once contract is deployed, go back and add the contract address as delegate for your channel
    address(this), // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
    bytes(
        string(
            // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
            abi.encodePacked(
                "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                "+", // segregator
                "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                "+", // segregator
                "0xFarm Alert", // this is notificaiton title
                "+", // segregator
                "This is to inform you that you have requested loan for amount",amount // notification body
            )
        )
    )
);

        
        loans[loanId] = Loan({
            id: loanId,
            assetId: assetId,
            borrower: address(0),
            amount: amount,
            interestRate: interestRate,
            lendingPeriod: lendingPeriod,
            startTime: 0,
            isActive: false
        });
        
        emit LoanRequested(loanId, assetId, amount, interestRate, lendingPeriod, msg.sender);
    }

     function fundLoan(uint256 loanId) public {
        require(loans[loanId].isActive == false, "Loan already funded");
        require(tokenContract.balanceOf(msg.sender) >= loans[loanId].amount, "Insufficient funds");
        require(approvedTokens[tokenIdToAssetId[loans[loanId].assetId]], "Asset token not approved");
        
        loans[loanId].borrower = msg.sender;
        loans[loanId].startTime = block.timestamp;
        loans[loanId].isActive = true;
        
        borrowerToLoanIds[msg.sender].push(loanId);
        
        tokenContract.transferFrom(msg.sender, address(this), loans[loanId].amount);
        tokenContract.transfer(assets[loans[loanId].assetId].owner, loans[loanId].amount);

               IPUSHCommInterface(0x87da9Af1899ad477C67FeA31ce89c1d2435c77DC).sendNotification(
    0x60E7c5F82744fEEcDE75B9771F0235CA8b9E4Bf0, // from channel - recommended to set channel via dApp and put it's value -> then once contract is deployed, go back and add the contract address as delegate for your channel
    address(this), // to recipient, put address(this) in case you want Broadcast or Subset. For Targetted put the address to which you want to send
    bytes(
        string(
            // We are passing identity here: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
            abi.encodePacked(
                "0", // this is notification identity: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/identity/payload-identity-implementations
                "+", // segregator
                "3", // this is payload type: https://docs.epns.io/developers/developer-guides/sending-notifications/advanced/notification-payload-types/payload (1, 3 or 4) = (Broadcast, targetted or subset)
                "+", // segregator
                "0xFarm Alert", // this is notificaiton title
                "+", // segregator
                "This is to inform you that you are trying to fun loan with ",loanId // notification body
            )
        )
    )
);
        
        emit LoanFunded(loanId, loans[loanId].amount, msg.sender);
    }

     function repayLoan(uint256 loanId, uint256 amount) public {
        require(loans[loanId].borrower == msg.sender, "Only borrower can repay loan");
        require(loans[loanId].isActive == true, "Loan not active");
        
        uint256 interest = (amount * loans[loanId].interestRate * (block.timestamp - loans[loanId].startTime)) / (365 days * 100);
        uint256 totalAmount = amount + interest;
        require(tokenContract.balanceOf(msg.sender) >= totalAmount, "Insufficient funds");
        
        loans[loanId].isActive = false;
        
        tokenContract.transferFrom(msg.sender, address(this), totalAmount);
        tokenContract.transfer(tokenToOwner[tokenIdToAssetId[loans[loanId].assetId]], totalAmount);
        
        emit LoanRepaid(loanId, amount, msg.sender);
    }
    
    function purchaseToken(uint256 tokenId) public {
        require(approvedTokens[tokenIdToAssetId[tokenId]], "Asset token not approved");
        
        uint256 value = assets[tokenIdToAssetId[tokenId]].value;
        require(tokenContract.balanceOf(msg.sender) >= value, "Insufficient funds");
        
        tokenContract.transferFrom(msg.sender, address(this), value);
        tokenContract.transfer(tokenToOwner[tokenId], value);
        
        emit TokenPurchased(tokenId, value, msg.sender);
    }


}