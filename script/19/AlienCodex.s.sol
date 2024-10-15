// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {AlienCodex} from "src/19/AlienCodex.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL19");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        AlienCodex level = AlienCodex(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}