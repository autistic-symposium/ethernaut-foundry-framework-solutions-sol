## 03. Coin Flip

<br>


### tl; dr

<br>


* in this challenge we exploit the determinism of a pseudo-random function compose of a global accessible variable, `blockhash`, and no added entropy.

<br>
  
<p align="center">
<img width="500" src=""">
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


* the EVM is a deterministic Turing machine. since there is no inherent randomness on the EVM and as everything in the contracts are publicly visible (`block.timestamp` or `block.number`), generating random numbers in solidity is tricky  projects resource to external oracles or to Ethereum validator's **[RANDAO](https://github.com/randao/randao)** algorithm.

<br>

* the `CoinFlip` contract uses the current `blockhash` to determine if the coin is head or tail, through the variable `coinFlip`:

<br>

```solidity
    uint256 coinFlip = blockValue / FACTOR;
    bool side = coinFlip == 1 ? true : false;
```

<br>

* which is derived from the variable `blockValue`, a `uint156` generated from the previous block number (block's number minus 1):

<br>

```solidity
    uint256 blockValue = uint256(blockhash(block.number - 1));
```

<br>

* this `FACTOR` variable is useless. first, it does not introduce any randomness entropy to `coinFlip` at all. Second, even if is private, we could just look at the contract at etherscan or decompile the bytecode (if the contract is not verified).

<br>

* the "randomness" of this function is derived from on-chain deterministic data (global accessible variables such as `blockhash`, with no entropy), so to hack it we need to get `blockhash` before we submit a guess. we iterate by simulating the result, skipping the blocks when the result is not favorable.

<br>

* **[foundry's `vm.roll(uint256)`](https://book.getfoundry.sh/cheatcodes/roll?highlight=vm.roll#examples)simulate the `block.number` given by the `uint256`.

<br>



<br>


----

### solution

<br>

* check `test/03/Coinflip.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract CoinFlipTest -vvvv    


```



<br>

* submit with `script/03/CoinFlip.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/03/CoinFlip.s.sol --broadcast -vvvv --rpc-url sepolia


```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



