// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

contract Auction {

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) bidsToRefund;

    // if the bidder is a contract without
    // fallback or receive
    // the contract hangs
    function vulnerableBid() public payable {
        require(msg.value > highestBid, "You are not the higest bidder");

        // refund previous highestBidder
        (bool ok,) = highestBidder.call{value: highestBid}("");
         require(ok, "refund of previous bidder failed");

        highestBid = msg.value;
        highestBidder = payable(msg.sender);
    }

    // we do not refund the older bidder
    // we offer the bidder to withdraw
    function safeBid() public payable {
        require(msg.value > highestBid, "You are not the higest bidder");

        bidsToRefund[highestBidder] += highestBid;

        highestBid = msg.value;
        highestBidder = payable(msg.sender);
    }

}