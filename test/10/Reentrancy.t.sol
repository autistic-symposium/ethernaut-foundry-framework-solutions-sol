// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import {Reentrance} from "src/10/Reentrancy.sol";

contract ReentrancyTest is Test {

    Reentrance public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
        vm.deal(hacker, 1 ether);
    }

    function testReentrancyHack() public {

        vm.startPrank(hacker);

        level = new Reentrance();
        level.donate{value: 0.0001 ether}(address(this));
        level.withdraw(0.0001 ether);

        vm.stopPrank();
        
    }
}
