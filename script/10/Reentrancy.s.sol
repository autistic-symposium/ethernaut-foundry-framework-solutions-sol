// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.6.0;

import "forge-std/Script.sol";
import {Reentrance} from "src/10/Reentrancy.sol";

/*
contract Exploit is Script {

        address instance = 0xcE198E8D4476Cb296cDb12e12757F1A505105Bf9;
        Reentrance level = Reentrance(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            
            vm.stopBroadcast();
    }
}
*/