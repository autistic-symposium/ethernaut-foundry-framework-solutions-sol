// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.12;

import "forge-std/Test.sol";
import {PuzzleWallet} from "src/24/PuzzleWallet.sol";

contract PuzzleWalletTest is Test {

    PuzzleWallet public level;

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
    }

    function testPuzzleWalletHack() public {

        vm.startPrank(hacker);

        vm.stopPrank();
        
    }
}
