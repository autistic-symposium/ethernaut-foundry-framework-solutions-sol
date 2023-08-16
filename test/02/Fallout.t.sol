// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/02/Fallout.sol";

contract FalloutTest is Test {

    Fallout public level;

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);
        level = new Fallout();
    
    }

    function testFallbackHack() public {

        vm.startPrank(hacker);
        level.Fal1out();
        vm.stopPrank();
        
      }
}