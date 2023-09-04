## GatekeeperTwo

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
contract GatekeeperTwo {

  address public entrant;

  modifier gateOne() {
    require(msg.sender != tx.origin);
    _;
  }

  modifier gateTwo() {
    uint x;
    assembly { x := extcodesize(caller()) }
    require(x == 0);
    _;
  }

  modifier gateThree(bytes8 _gateKey) {
    require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
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

* check `test/14/GatekeeperTwo.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract GatekeeperTwoTest -vvvv    


```



<br>

* submit with `script/14/GatekeeperTwo.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/14/GatekeeperTwo.s.sol --broadcast -vvvv --rpc-url sepolia


```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



