// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {DoublyEntryPoint} from "src/26/DoubleEntryPoint.sol";

contract DoubleEntryPointTest is Test {

    DoublyEntryPoint public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testDoubleEntryPointHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
