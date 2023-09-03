// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Force} from "src/07/Force.sol";

contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL7");
        Force level = Force(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            
            vm.stopBroadcast();
    }
}