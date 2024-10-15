// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Denial} from "src/20/Denial.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL20");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Denial level = Denial(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}