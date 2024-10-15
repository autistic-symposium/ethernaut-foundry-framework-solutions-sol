// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GatekeeperOne} from "src/13/GatekeeperOne.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL13");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        GatekeeperOne level = GatekeeperOne(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}

