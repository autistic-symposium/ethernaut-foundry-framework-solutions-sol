// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Telephone} from "src/04/Telephone.sol";
import {TelephoneExploit} from "src/04/TelephoneExploit.sol";


contract TelephoneTest is Test {

    Telephone public level = new Telephone();

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);

    }

    function testTelephoneHack() public {

        vm.startPrank(hacker);

        assertNotEq(level.owner(), hacker);

        TelephoneExploit exploit = new TelephoneExploit();
        exploit.run(level);

        assertEq(level.owner(), hacker);
        
        vm.stopPrank();
        
    }
}