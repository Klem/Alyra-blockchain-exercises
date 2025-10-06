// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Bank{
    mapping (address => uint) balances;

    
    constructor() {

    }

    function deposit(uint _amount) public {
        balances[msg.sender] += _amount;
    }

    function transfer(address _to, uint _amount) public  {
        require(balances[msg.sender] >= _amount, "You have unsufficient funds");
        require(_to != address(0), "You cannot burn tokens");
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function balanceOf(address _account) public view returns (uint) {
            return balances[_account];
    }
}