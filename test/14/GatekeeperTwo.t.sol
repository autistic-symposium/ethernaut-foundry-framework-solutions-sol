// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {GatekeeperTwo} from "src/14/GatekeeperTwo.sol";

contract GatekeeperTwoTest is Test {

    GatekeeperTwo public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testPrivacyHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
