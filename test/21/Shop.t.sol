// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Shop} from "src/21/Shop.sol";


contract ShopTest is Test {

    Shop public level = new Shop();

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);
        
    }

    function testShopnHack() public {

        vm.startPrank(hacker);


        vm.stopPrank();
        
    }
}