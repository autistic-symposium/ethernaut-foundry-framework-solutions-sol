// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.6.12;

import "forge-std/Script.sol";
//import {ReentrancyExploit} from "src/10/ReentrancyExploit.sol";

contract Exploit is Script {

        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL10"));  
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));     
          
        function run() external {

            vm.startBroadcast(hacker);
            

            vm.stopBroadcast();
    }
}

