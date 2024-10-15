// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {GatekeeperThree} from "src/28/GatekeeperThree.sol";

contract GatekeeperThreeTest is Test {

    GatekeeperThree public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testGatekeeperThreeHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
