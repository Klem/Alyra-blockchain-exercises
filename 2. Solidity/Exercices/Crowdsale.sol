// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;
import "./Token.sol";

contract Crowdsale{

uint public rate = 20000;
Token public token;

    event distributed(uint256 amount);

    modifier minAmount() {
        require(msg.value >= 0.1 ether, "Minimum amount: 0.1 Eth");
        _;
    }

    constructor(uint initialSupply) {
        token = new Token(initialSupply);
    }
    

    receive() minAmount external payable{
        distribue(msg.value);
    }

    function distribue(uint256 amount) internal {
        uint256 tokens = amount * rate;
        token.transfer(msg.sender, tokens);

        emit distributed(tokens);
    }
}