// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {GatekeeperThree} from "src/28/GatekeeperThree.sol";


contract Exploit is Script {

        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL28"));
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        GatekeeperThree level = GatekeeperThree(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}