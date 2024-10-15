// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {GatekeeperOne} from "src/13/GatekeeperOne.sol";

contract GatekeeperOneTest is Test {

    GatekeeperOne public level;

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
