// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Whitelist {
    mapping (address => bool) private whitelist;

    event authorized(address _address);

   // Contract deployer is always whitelisted
    constructor() {
        whitelist[msg.sender]= true;
    }

    modifier isAuthorized() {
        require(check(), "Unauthorized access");
        _;
    }

    // add another whitelisted address if requester
    // is authorized
    function authorize(address _address) public isAuthorized() {
        whitelist[_address] = true;
        emit authorized(_address);
    }

    // check if requester is whitelisted
    function check() private view returns (bool) {
        return whitelist[msg.sender];
    }
}
