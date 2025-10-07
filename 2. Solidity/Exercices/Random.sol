// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract Random {
    uint private nonce = 0;
    uint private limit = 100;

    event randomized(uint _nonce, uint _timestamp, address _address);

    function random() public returns (uint) {
        bytes memory value = abi.encodePacked(nonce, block.timestamp, msg.sender);
        uint rnd = uint(keccak256(value)) % limit;
        nonce++;

        emit randomized(nonce, block.timestamp, msg.sender);

        return rnd;
    
    }

    function getNonce() public view returns (uint) {
        return nonce;
    }
}