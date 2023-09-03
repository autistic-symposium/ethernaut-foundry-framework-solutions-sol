## 👾 09. King

<br>


### tl; dr

<br>





<br>
  
<p align="center">
<img width="300" src="">
</p>


<br>

```solidity
contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
```


<br>

---

### discussion

<br>

* the `King` contract starts with three state variables that are set in the constructor:

```solidity
  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }
```

<br>

* `king` is initially the person who deployed the contract and sets `prize` (the current value to be bet to become `king`).
<br>

* following we have the `receive()` function and a getter for `king`. to become a `king` we need to either be `owner` or to send `prize` larger than the current value. since we didn't deploy the contract, the first option is not available:

```solidity
  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
```

<br>

* our goal is to take control of `king` and not allow anyone else change its value by hacking `receive()`. looking at `receive()` we see that after we send an enough `prize`, a `payable` function is triggered to pay the previous `king` prior to `king` and `prize` being set to our values.
    - note that this contract has no error handling.



<br>


----

### solution

<br>

* check `test/09/King.t.sol`:

<br>

```solidity

```

<br>

* run the test with:

<br>

```shell
> forge test --match-contract KingTest -vvvv    
```



<br>

* then submit the solution with `script/09/King.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/09/King.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### solution using `cast`

<br>

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>


