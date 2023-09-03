// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {KingExploit} from "src/09/KingExploit.sol";

contract KingTest is Test {

    KingExploit public exploit;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);    
    }

    function testKingtHack() public {

        vm.startPrank(hacker);
        exploit = new KingExploit();
        exploit.run(instance);
        vm.stopPrank();
        
    }
}
