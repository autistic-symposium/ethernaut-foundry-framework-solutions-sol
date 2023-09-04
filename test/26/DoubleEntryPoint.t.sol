// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {DoubleEntryPoint} from "src/26/DoubleEntryPoint.sol";

contract DoubleEntryPointTest is Test {

    DoubleEntryPoint public level;

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
