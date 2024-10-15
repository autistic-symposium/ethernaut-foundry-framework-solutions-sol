// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Privacy} from "src/12/Privacy.sol";

contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL12");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        Privacy level = Privacy(instance); 
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}

