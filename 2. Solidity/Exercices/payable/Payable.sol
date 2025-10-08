// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

// https://rareskills.io/learn-solidity/payable-functions
contract Payable {

    function sendEther() payable public {

    }

    function amIRich() view public returns (uint) {
        return address(this).balance;
    }
}
