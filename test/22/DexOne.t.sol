// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {Dex} from "src/22/DexOne.sol";

contract DexOneTest is Test {

    Dex public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testDexOneHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
