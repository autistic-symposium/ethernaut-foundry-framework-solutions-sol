// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Shop} from "src/21/Shop.sol";
import {ShopExploit} from "src/21/ShopExploit.sol";

contract ShopTest is Test {

    Shop public level = new Shop();
    address instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);
    }

    function testShopHack() public {

        vm.startPrank(hacker);

        console.log(level.isSold());
        ShopExploit exploit = new ShopExploit();
        exploit.run(level);
        assert(level.isSold());

        vm.stopPrank();
        
    }
}