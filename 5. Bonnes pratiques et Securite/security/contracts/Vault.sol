// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

// You can store ETH in this contract and redeem them.
contract Vault {
    mapping(address => uint) public balances;

    event stored(address _address, uint amount);
    event reddem(address _address, uint amount);

    /// @dev Store ETH in the contract.
    function store() public payable {
        balances[msg.sender]+=msg.value;
        emit stored(msg.sender, msg.value);
    }

    /// @dev Redeem your ETH.
    function redeem() public payable {
        emit stored(msg.sender, msg.value);
        msg.sender.call{ value: balances[msg.sender] }("");
        balances[msg.sender]=0;
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}