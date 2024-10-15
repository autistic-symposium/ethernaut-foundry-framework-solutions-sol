// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {PuzzleWallet} from "src/24/PuzzleWallet.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL24");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        PuzzleWallet level = PuzzleWallet(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}