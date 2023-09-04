## 👾 10. Reentrancy

<br>


### tl; dr

<br>





<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/c07d1819-ecbd-4a82-9a6c-aaded440da1b">
</p>



<br>

```solidity
contract Reentrance {
  
  using SafeMath for uint256;
  mapping(address => uint) public balances;

  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }

  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }

  receive() external payable {}
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

* check `test/10/Reentrancy.t.sol`:

<br>

```solidity

```

<br>

* run the test with:

<br>

```shell
> forge test --match-contract ReentrancyTest -vvvv    
```



<br>

* then submit the solution with `script/10/Reentrancy.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/10/Reentrancy.s.sol --broadcast -vvvv --rpc-url sepolia
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


