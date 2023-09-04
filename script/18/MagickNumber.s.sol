// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {MagicNum} from "src/18/MagicNumber.sol";


contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL18");
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
        MagicNum level = MagicNum(instance);  
              
        function run() external {

            vm.startBroadcast(hacker);

            
            vm.stopBroadcast();
    }
}