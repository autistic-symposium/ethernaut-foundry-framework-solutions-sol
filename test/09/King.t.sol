// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {King} from "src/09/King.sol";
import {KingExploit} from "src/09/KingExploit.sol";

contract KingTest is Test {

    King public king;
    KingExploit public exploit;
    uint256 public prize;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
        vm.deal(instance, 0.1 ether); 
        king = new King{value: 0.1 ether}();
        prize = king.prize();
    }

    function testKingtHack() public {

        vm.startPrank(hacker);

        assertEq(king.owner(), instance);
        assertEq(king._king(), instance);
        assertEq(king.prize(), prize);

        vm.deal(hacker, prize + 1); 
        exploit = new KingExploit{value: prize + 1}(address(king));

        assertEq(king._king(), address(exploit));
        assertEq(king.prize(), prize + 1);

        vm.stopPrank();
        
    }
}
