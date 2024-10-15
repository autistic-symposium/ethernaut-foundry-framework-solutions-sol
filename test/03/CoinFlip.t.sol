// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {CoinFlip} from "src/03/CoinFlip.sol";
import {CoinFlipExploit} from "src/03/CoinFlipExploit.sol";


contract CoinFlipTest is Test {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 private immutable FIRST_BLOCK = 137;
    uint8 consecutiveWins = 10;
    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 
    CoinFlip public level;

    function setUp() public {
        vm.prank(instance);
        level = new CoinFlip();
        assertEq(level.consecutiveWins(), 0);
    }

    function testCoinFlipHack() public {
        vm.startPrank(hacker);
        vm.roll(FIRST_BLOCK);

        CoinFlipExploit exploit = new CoinFlipExploit();
        for (uint256 i = FIRST_BLOCK; i < FIRST_BLOCK + consecutiveWins; i++) {
            vm.roll(i + 1); 
            exploit.run(level);
        }

        assert(level.consecutiveWins() == consecutiveWins);
        vm.stopPrank();
      }
}