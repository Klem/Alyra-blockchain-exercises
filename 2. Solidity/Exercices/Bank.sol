// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Bank{
    mapping (address => int) balances;

    modifier checkBalance(int _amount) {
        require(balances[msg.sender] >= _amount, "You have unsufficient funds");
        _;
    }

    modifier checkAmount(int _amount) {
        require( _amount > 0, "Amount must be positive and non zero");
        _;
    }

modifier checkAddress(address _to) {
       require(_to != address(0), "You cannot burn tokens");
        _;
    }


    function deposit(int _amount) checkAmount(_amount) public {
        balances[msg.sender] += _amount;
    }

    function transfer(address _to, int _amount) checkAmount(_amount)  checkBalance(_amount) checkAddress(_to) public  {
        
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function balanceOf(address _account) public view returns (int) {
            return balances[_account];
    }
}