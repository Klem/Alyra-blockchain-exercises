// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.28;

import {Voting} from "../contracts/Voting.sol";
import {Test} from "forge-std/Test.sol";

// Solidity tests are compatible with foundry, so they
// use the same syntax and offer the same functionality.

contract VotingTest is Test {
    Voting voting;

    function setUp() public {
        voting = new Voting();
    }

}