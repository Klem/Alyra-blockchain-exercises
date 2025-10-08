// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

// https://rareskills.io/learn-solidity/payable-functions
contract EthSender {

    // require ether at instanciation time
    constructor() payable {
        require(msg.value >= 1 ether, "Must send at least 1 ETH during deployment");
    }

    function sendEtherToContract(address receiverContract) public payable {
            (bool _success, ) = receiverContract.call {value: amIRich()}(abi.encodeWithSignature("receiveEthersFromContract()"));
            require(_success, "sendEtherTocontract");
    }

     function amIRich() view public returns (uint) {
        return address(this).balance;
    }        
}