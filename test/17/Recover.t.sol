// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {Recovery} from "src/17/Recovery.sol";

contract RecoveryTest is Test {

    Recovery public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testRecoveryHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
