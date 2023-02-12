//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract insurance{
    address public owner;
    
    struct Person{
        uint256 id;
        string name;
        uint256 premiumAmount;
        uint256 startTime;
        uint256 expiryDate;
        uint256 landArea;
        string cropType;
    }

    struct buyPremium{
        uint time;
        Person person;
    }

    constructor(){
        owner = msg.sender;

    }

// add insurance means basically buy insurance for the first time 
// so check whether the whether the person have bought the insurance earlier or not
// then if it is first time then calculate the premium amount of the person according to his land area
    function addInsurance (
        string memory _name,
        uint256 _premiumAmount,
        uint256 _startTime,
        uint256 _expiryDate,
        uint256 _landArea,
        string memory _cropType

    )onlyOwner public {
        require(msg.sender == owner);
    }
    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }

// enter id as parameter and pay for premium and then multiply the paid amount into the expiry date of next payment
// basically extend the next payment date 
// so while paying premium just enter your id and you can pay premium cost which is calculated depending on his land area
// if already paid then return the remaining time for paying next premium and if the user wants to pay premium even there is no due date
// then extend the time
    function payPremium() public {

    }


    function avail() public {
        require(msg.sender == owner,"You are not owner");
        //chat 

    }

    function deleteInsurance() public{

    }





}