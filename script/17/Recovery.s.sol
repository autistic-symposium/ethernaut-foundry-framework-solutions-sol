// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Recovery} from "src/17/Recovery.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL17");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Recovery level = Recovery(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}