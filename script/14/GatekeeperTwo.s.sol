// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GatekeeperTwo} from "src/14/GatekeeperTwo.sol";

contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL14");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        GatekeeperTwo level = GatekeeperTwo(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}