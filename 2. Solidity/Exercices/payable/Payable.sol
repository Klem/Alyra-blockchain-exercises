// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

// https://rareskills.io/learn-solidity/payable-functions
contract Payable {

    modifier minAmount() {
        require(msg.value > 1 wei, "Unsufficient funds provided");
        _;
    }

    function sendViaTransfert(address payable _to) payable external minAmount {
        _to.transfer(msg.value);
        // transfer auto reverts when failed
    }

    function sendViaSend(address payable _to) payable external minAmount{
        bool ok =  _to.send(msg.value);
        require(ok, "Transfert failed");
    }

    function sendViaCall(address payable _to) payable external minAmount{
      (bool ok, ) = _to.call {value: amIRich()}("");
      require(ok, "Transfert failed");
    }

    function sendIfEnoughEthers(address payable _to, uint minBalance) payable external {
        if(amIRich() <= minBalance) {
            revert("Transfert failed");
        } else {
            this.sendViaSend(_to);
        }
    }

    function amIRich() view public returns (uint) {
        return address(this).balance;
    }



    //  is msg.data empty?
    //          /   \
    //         yes  no
    //         /     \
    //    receive()?  fallback()
    //     /   \
    //   yes   no
    //  /        \
    //receive()  fallback()
    //               yes   no
    //                /     \
    //           fallback()  revert

    // mandatory if ether is transferred with
    // VALUE directly to contract address
    // instead of calling a payable function
    receive() external payable {

    }

     // called when CALLDATA is provided
     // eg a function is msg.data = keccak(functionName)
    fallback() external payable {

    }
}