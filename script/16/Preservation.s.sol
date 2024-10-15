// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Preservation} from "src/16/Preservation.sol";

contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL16");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Preservation level = Preservation(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}