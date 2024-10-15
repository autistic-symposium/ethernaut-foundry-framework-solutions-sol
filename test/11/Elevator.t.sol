// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Elevator} from "src/11/Elevator.sol";
import {ElevatorExploit} from "src/11/ElevatorExploit.sol";

contract ElevatorTest is Test {

    Elevator public level = new Elevator();
    address hacker = vm.addr(0x1337); 

    function testElevatorHack() public {

        vm.startPrank(hacker);

        ElevatorExploit exploit = new ElevatorExploit();
        exploit.run(level);
        assert(level.top());

        vm.stopPrank();
        
    }
}