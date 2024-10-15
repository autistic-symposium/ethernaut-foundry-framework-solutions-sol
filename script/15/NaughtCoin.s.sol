// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {NaughtCoin} from "src/15/NaughtCoin.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL15");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        NaughtCoin level = NaughtCoin(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}