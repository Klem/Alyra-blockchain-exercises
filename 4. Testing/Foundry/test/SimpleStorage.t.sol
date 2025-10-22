// SPDX-License-Identifier: GPL-3
pragma solidity ^0.8.28;

import "../src/SimpleStorage.sol";
import "forge-std/Test.sol";


contract SimpleStorageTest is Test {

    address user1 = makeAddr("user1");
    address user2 = makeAddr("user2");

    SimpleStorage _simpleStorage;

    function setUp() public {
        _simpleStorage = new SimpleStorage();
    }

    function test_NumberIs0() public view {
        uint expected = _simpleStorage.get();
        assertEq(expected, 0);
    }

    function test_Revert_WhenOutOfRange() public {
        vm.expectRevert(NumberOutOfRange.selector);
        _simpleStorage.set(99);
    }

    function test_setNumberTo7() public {
        _simpleStorage.set(7);
        uint expected = _simpleStorage.get();
        assertEq(expected, 7);
    }

    function test_setNumberWithDifferentUsers() public {
        vm.startPrank(user1);
        _simpleStorage.set(6);
        uint expectecUser1Number = _simpleStorage.get();
        assertEq(expectecUser1Number, 6);
        vm.stopPrank();
        uint expectecUser2Number = _simpleStorage.get();
        assertEq(expectecUser2Number, 0);
    }

    event NumberChanged(address indexed by, uint256 number);

    // ✅ YOUR TEST - Testing EVENT EMISSION
    function test_expectEmit() public {
        // ===========================================
        // STEP 1: SETUP EXPECTATION FOR EVENT
        // ===========================================
        // vm.expectEmit(CHECK_TOPIC0, CHECK_TOPIC1, CHECK_TOPIC2, CHECK_DATA)
        // 4 BOOLEAN PARAMETERS control what to verify:
        vm.expectEmit(true, false, false, true);

        // BREAKDOWN OF THE 4 BOoleans:
        // 1. true  → CHECK topic0 (event signature) ✅ REQUIRED
        // 2. false → DON'T check topic1 (indexed param 1)
        // 3. false → DON'T check topic2 (indexed param 2)
        // 4. true  → CHECK non-indexed data (uint256 number) ✅ REQUIRED

        // ===========================================
        // STEP 2: EMIT THE EXPECTED EVENT
        // ===========================================
        // This tells Foundry: "I EXPECT this exact event to be emitted"
        emit NumberChanged(address(user2), 5);
        //                ↑ indexed address    ↑ uint256 number
        // Event signature: NumberChanged(address,uint256)

        // ===========================================
        // STEP 3: EXECUTE THE TRANSACTION
        // ===========================================
        // Pretend to be 'user2' for this transaction
        vm.startPrank(user2);      // Start impersonating user2
        _simpleStorage.set(5);     // CALL: This should emit NumberChanged(user2, 5)
        vm.stopPrank();            // Stop impersonating

        // ===========================================
        // STEP 4: VERIFICATION (AUTOMATIC)
        // ===========================================
        // Foundry AUTOMATICALLY compares:
        // EXPECTED: NumberChanged(user2, 5)
        // ACTUAL:   NumberChanged(user2, 5)  ← From set(5)
        // RESULT:   ✅ PASS!
    }
}
