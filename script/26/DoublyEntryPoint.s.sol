// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {DoublyEntryPoint} from "src/26/DoubleEntryPoint.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL26");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        DoublyEntryPoint level = DoublyEntryPoint(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}