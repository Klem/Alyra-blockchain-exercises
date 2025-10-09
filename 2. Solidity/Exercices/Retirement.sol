// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Epargne is Ownable {

    uint256 time;
    uint256 depositId;

    mapping(uint256 => uint256) deposits;
    // 0 => 3 wei
    // 1 => 2 ether
    // 2 => 55 wei
    // 3 => 45 ether

    constructor(address initialOwner) Ownable(initialOwner) {}

    function deposit() external payable onlyOwner() {
        require(msg.value > 0, "Not enough funds provided");
        deposits[depositId] = msg.value;
        depositId++;
        if(time == 0) {
            time = block.timestamp + 12 weeks;
        }
    }

    function withdraw() external onlyOwner {
        require(block.timestamp >= time, "Wait 3 months after the first deposit to withdraw");
        //(bool sent,) = msg.sender.call{value: address(this).balance}("");
        payable(msg.sender).transfer(address(this).balance);
        // bool sent = payable(msg.sender).send(address(this).balance);
    }
}