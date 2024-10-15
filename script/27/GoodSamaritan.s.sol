// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GoodSamaritan} from "src/27/GoodSamaritan.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL27");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        GoodSamaritan level = GoodSamaritan(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}