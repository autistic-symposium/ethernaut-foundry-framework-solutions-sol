## Vault

<br>


### tl; dr

<br>


* in this challenge, we explore the fact that even if a solidity's state variables may be declared private (hidden from other contracts), their values are still recorded and open on the blockchain.

<br>
  
<p align="center">
<img width="500" src=""">
</p>


<br>

```solidity
contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```


<br>

---

### discussion

<br>


<br>



----

### solution

<br>

* check `test/.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract Test -vvvv    


```



<br>

* submit with `script/.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/0.s.sol --broadcast -vvvv --rpc-url sepolia


```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



