// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Elevator} from "src/11/Elevator.sol";

contract ElevatorTest is Test {

    Elevator public level;

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);    
    
    }

    function testElevatortHack() public {

        vm.startPrank(hacker);
        
        
        vm.stopPrank();
        
    }
}
