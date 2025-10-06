// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Crowsale is ERC20 {

    constructor() ERC20("Klem", "KLM") {
    }
}