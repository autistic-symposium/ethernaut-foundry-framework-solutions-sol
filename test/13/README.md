## GatekeeperOne

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
contract GatekeeperOne {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    require(gasleft() % 8191 == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
      require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
      require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
      require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
    _;
  }

  function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
    entrant = tx.origin;
    return true;
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

* check `test/13/GatekeeperOne.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract GatekeeperOneTest -vvvv    


```



<br>

* submit with `script/13/GatekeeperOne.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/13/GatekeeperOne.s.sol --broadcast -vvvv --rpc-url sepolia


```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



