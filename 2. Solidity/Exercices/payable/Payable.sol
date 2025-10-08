// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

// https://rareskills.io/learn-solidity/payable-functions
contract Payable {

    function sendEtherToContract() payable public {

    }

    function sendViaTransfert(address payable _to) payable external {
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) payable external {
        bool ok =  _to.send(msg.value);
        require(ok, "Transfert failed");
    }

    function amIRich() view public returns (uint) {
        return address(this).balance;
    }
}
