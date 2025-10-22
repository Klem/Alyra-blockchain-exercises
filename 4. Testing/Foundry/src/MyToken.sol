// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.28;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MyToken is ERC20 {

    constructor(uint initialSupply) ERC20("Klem", "KLM"){
        _mint(msg.sender, initialSupply);
    }
}