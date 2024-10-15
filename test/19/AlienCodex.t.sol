// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {AlienCodex} from "src/19/AlienCodex.sol";

contract AlienCodexTest is Test {

    AlienCodex public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testAlienCodexHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
