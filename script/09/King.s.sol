// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {King} from "src/09/King.sol";

/*
contract Exploit is Script {

        address instance = 0xcE198E8D4476Cb296cDb12e12757F1A505105Bf9;
        King level = King(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            
            vm.stopBroadcast();
    }
}
*/