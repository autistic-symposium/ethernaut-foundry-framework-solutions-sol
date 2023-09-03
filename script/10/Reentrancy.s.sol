// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import {Reentrance} from "src/10/Reentrancy.sol";

/*
contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL10");
        Reentrance level = Reentrance(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            
            vm.stopBroadcast();
    }
}
*/