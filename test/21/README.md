## Shop

<br>


### tl; dr

<br>

* 

<br>
  
<p align="center">
<img width="300" src="">
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

* 

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



