// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Shop} from "src/21/Shop.sol";

contract Exploit is Script {

        address instance;// = ;
        Shop level = Shop(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            
            vm.stopBroadcast();
    }
}