//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract insurance{
    address public owner;

    struct person{
        
        uint256 startTime;


    }

    function addInsurance(
        uint256 _startTime,
        uint256 _premium,
        uint256 _durationInYears,
        string  memory _landArea,
        string memory  _crop

    ) public {

    }


    function payPremium() public {

    }


    function avail() public {
        require(msg.sender == owner,"You are not owner");
        //chat 

    }

    function deleteInsurance() public{

    }





}