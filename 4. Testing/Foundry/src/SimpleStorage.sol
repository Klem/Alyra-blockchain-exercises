// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.28;
error NumberOutOfRange();

contract SimpleStorage {

    event NumberChanged(address indexed by, uint256 number);

    mapping(address => uint) private addressToNumber;

    function set(uint256 number) external {if (number >= 10) {revert NumberOutOfRange();}
        addressToNumber[msg.sender] = number;
        emit NumberChanged(msg.sender, number);}

    function get() external view returns (uint) {return addressToNumber[msg.sender];}}