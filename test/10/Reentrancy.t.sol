// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;


import "forge-std/Test.sol";
import {Reentrance} from "src/10/Reentrancy.sol";
import {ReentrancyExploit} from "src/10/ReentrancyExploit.sol";

contract ReentrancyTest is Test {

    Reentrance public level;
    ReentrancyExploit public exploit;

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
        vm.deal(instance, 10 ether);
        vm.deal(hacker, 1 ether);
        level = new Reentrance();
        level.donate{value: 1 ether }(instance);
    }

    function testReentrancyHack() public {

        vm.startPrank(hacker);
        assert(instance.balance > 0);

        exploit = new ReentrancyExploit();
        (bool success) = exploit.run{value: 0.1 ether}(level);
        
        //assert(success);
        //assert(instance.balance == 0);
        vm.stopPrank();
        
    }
}
