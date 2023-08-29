## Shop

<br>


### tl; dr

<br>

* in this challenge we explore restrictions of `view` functions through an `interface`. 




<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/fe25b506-a655-47dc-8c9a-4557a7bc3d63">
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

* the first bit of this contract is the `interface Buyer` that defines as `external view` function, `price()`:

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

* and a `public` function `buy()`, where the fact that `price()` is being called twice is our vulnerability:

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

----

### solution

<br>

* we craft the following exploit:

<br>

```solidity

```


<br>

* which can be submitted with `script/21/Shop.s.sol`:

<br>

```solidity

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



