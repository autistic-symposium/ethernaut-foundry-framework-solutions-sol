// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Dex} from "src/22/DexOne.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL22");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Dex level = Dex(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}