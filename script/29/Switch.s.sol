// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Switch} from "src/29/Switch.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL29");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Switch level = Switch(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}