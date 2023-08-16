// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Telephone} from "src/04/Telephone.sol";

contract TelephoneTest is Test {

    Telephone public level;

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);
        level = new Telephone();
    
    }

    function testTelephoneHack() public {

        vm.startPrank(hacker);
        
        /// here

        vm.stopPrank();
        
    }
}