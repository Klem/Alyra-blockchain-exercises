// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.28;


import "../src/MyToken.sol";
import "forge-std/Test.sol";

contract MyTokenTest is Test {
    string _name = "Klem";
    string _symbol = "KLM";
    uint _initialSupply = 10000 * 10 ** 18; // 10000 tokens with 18 decimals
    address _owner = makeAddr("owner");
    address _recipient = makeAddr("recipient");
    uint _decimals = 18;

    MyToken _myToken;

    function setUp() public {
        vm.prank(_owner); // next call is by this user
        _myToken = new MyToken(_initialSupply); // ctrated by _owner
    }

    function test_nameIsKlem() public view {
        string memory expected = _myToken.name();
        assertEq(expected, _name);
    }

    function test_symbolIsKlm() public view {
        string memory expected = _myToken.symbol();
        assertEq(expected, _symbol);
    }

    // owner has the total supply after creation
    function test_CheckFirstBalance() public {
        uint256 balanceOfOwner = _myToken.balanceOf(_owner);
        assertEq(balanceOfOwner, _initialSupply);
    }

    function test_decimals() public view {
        uint expected = _myToken.decimals();
        assertEq(expected, _decimals);
    }

    function testTransfer() public {
        uint256 amount = 100;
        // Get the balance of the owner and the recipient before the transfer
        uint256 ownerBeforeTransfer = _myToken.balanceOf(_owner);
        uint256 recipientBeforeTransfer = _myToken.balanceOf(_recipient);
        assertEq(recipientBeforeTransfer, 0);

        // Owner transfers 100 to the recipient
        vm.prank(_owner);
        _myToken.transfer(_recipient, 100);


        uint256 ownerAfterTransfer = _myToken.balanceOf(_owner);
        uint256 recipientAfterTransfer = _myToken.balanceOf(_recipient);
        console.log(ownerAfterTransfer); //9999999999999999999900
        console.log(recipientAfterTransfer); //100

        uint256 expectedOwnerAfterTransfer = ownerBeforeTransfer - amount;
        uint256 expectedRecipientAfterTransfer = recipientBeforeTransfer + amount;
        console.log(expectedOwnerAfterTransfer); //9999999999999999999900
        console.log(expectedRecipientAfterTransfer); //100

        assertEq(ownerAfterTransfer, expectedOwnerAfterTransfer);
        assertEq(recipientAfterTransfer, expectedRecipientAfterTransfer);
    }

    function test_CheckIfApprovalDone() public {
        uint256 amount = 100;
        uint256 allowanceBeforeApproval = _myToken.allowance(_owner, _recipient); //0
        assertEq(allowanceBeforeApproval, 0);

        vm.prank(_owner);
        _myToken.approve(_recipient, amount);

        uint256 allowanceAfterApproval = _myToken.allowance(_owner, _recipient);
        console.log(allowanceAfterApproval);
        assertEq(allowanceAfterApproval, 100);
    }

    function test_CheckIfTransferFromDone() public {
        uint256 amount = 100;
        vm.prank(_owner);
        _myToken.approve(_recipient, amount);

        uint256 balanceOwnerBeforeTransfer  = _myToken.balanceOf(_owner);
        uint256 balanceRecipientBeforeTransfer  = _myToken.balanceOf(_recipient);

        assertEq(balanceOwnerBeforeTransfer, _initialSupply);
        assertEq(balanceRecipientBeforeTransfer, 0);

        uint256 expectedAllowance = _myToken.allowance(_owner, _recipient);
        console.log('ok');
        console.log(expectedAllowance);

        vm.prank(_recipient);
        _myToken.transferFrom(_owner, _recipient, amount);

        uint256 balanceOwnerAfterTransfer = _myToken.balanceOf(_owner);
        uint256 balanceRecipientAfterTransfer = _myToken.balanceOf(_recipient);

        uint256 expectedBalanceOwnerAfterTransfer = balanceOwnerBeforeTransfer - amount;
        uint256 expectedBalanceRecipientAfterTransfer = balanceRecipientBeforeTransfer + amount;

        assertEq(expectedBalanceOwnerAfterTransfer, balanceOwnerAfterTransfer);
        assertEq(expectedBalanceRecipientAfterTransfer, balanceRecipientAfterTransfer);
    }

}