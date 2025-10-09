// SPDX-License-Identifier: MIT
pragma solidity 0.8.28;

abstract contract Ownable {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }
}

contract Gouvernement is Ownable {
    uint256 nukeCode;

    function updateNukodeCode(uint256 _nukeCode) external onlyOwner {
        nukeCode = _nukeCode;
    }
}

library Calcul {
    function calcul() external pure returns(uint256) {
        return 2+2;
    }
}

contract Bank {

    event Deposited(address indexed _by, uint256 _amount);

    uint256 amountDeposited;

    function deposit() external payable {
        //msg.value
        amountDeposited += msg.value;
        emit Deposited(msg.sender, msg.value);
    }
}