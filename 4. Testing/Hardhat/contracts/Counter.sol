// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import "hardhat/console.sol";

contract Counter {
    uint public x;

    event Increment(uint by);

    function inc() public {
        console.log("x = %s", x);
        x++;
        emit Increment(1);
    }

    function incBy(uint by) public {
        require(by > 0, "Cannot increment by 0");
        x += by;
        emit Increment(by);
    }
}
