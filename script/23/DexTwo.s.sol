// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {DexTwo} from "src/23/DexTwo.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL23");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        DexTwo level = DexTwo(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}