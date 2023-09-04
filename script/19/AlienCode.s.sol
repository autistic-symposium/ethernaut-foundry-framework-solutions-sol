// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import {AlienCode} from "src/19/AlienCode.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL19");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        AlienCode level = AlienCode(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}