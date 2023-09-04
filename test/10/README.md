## 👾 10. Reentrancy

<br>


### tl; dr

<br>

* contracts may call other contracts by function calls or transferring ether. they can also call back contracts that called them (*i.e.*, reentering) or any other contract in the call stack.
    - a **reentrancy attack** can happen when a contract is reentered in an invalid state. this can happen if the contract calls other untrusted contracts or transfers funds to untrusted accounts.
    - state in the blockchain is considered valid when the contract-specific invariants hold true. contract invariants are properties of the program state that are expected always to be true. for instance, the value of owner state variable, the total token supply, etc., should always remain the same.

- in its simplest version, an attacking contract exploits vulnerable code in another contract to seize the flow of operation or funds.
    - for example, an attacker could repeatedly call a `withdraw()` or `receive()` function (or similar balance updating function) before a vulnerable contract’s balance is updated.

* **[for a detailed review on reentrancy attacks, check my mirror post](https://mirror.xyz/go-outside.eth/7Q5DK8cZNZ5CP6ThJjEithPvjgckA24D2wb-j0Ps5-I)**.

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

* the `Reentrance` contract starts with a state variable for `balances` (note that `SafeMath` is not needed anymore after solidity `0.8`):

<br>

```solidity
contract Reentrance {
  using SafeMath for uint256;
  mapping(address => uint) public balances;
```

<br>

* then we have a getter and a setter function for `donate()` (whoever donates some value becomes part of `balances`) and `balanceOf()` (which uses `SafeMath`'s `add()`). 

<br>

```solidity
  function donate(address _to) public payable {
    balances[_to] = balances[_to].add(msg.value);
  }

  function balanceOf(address _who) public view returns (uint balance) {
    return balances[_who];
  }
```

<br>

* then, we have the `withdraw(amount)` function, which is the source of our reentrancy attack. 
    - for instance, note how it already breaks the **[`checks -> effects -> interactions` pattern](https://docs.soliditylang.org/en/v0.8.21/security-considerations.html#use-the-checks-effects-interactions-pattern)**.
    - in other words, if `msg.sender` is a (attacker) contract and since `balances` deduction is made after the call, the contract can call `fallback()` to cause a recursion that sends the value multiple times before reducing the sender's balance.

<br>

```solidity
  function withdraw(uint _amount) public {
    if(balances[msg.sender] >= _amount) {
      (bool result,) = msg.sender.call{value:_amount}("");
      if(result) {
        _amount;
      }
      balances[msg.sender] -= _amount;
    }
  }
```
<br>

<p align="center">
<img src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/bed1dd0f-707c-408a-88d8-ee04693667b9" width="50%" align="center" style="padding:1px;border:1px solid black;"/>


<br><br>

* finally, we see a blank `receive()` function, which receives any `ether` sent to the contract without specifically calling `donate()`.
    - `receive()` is a new keyword in solidity 0.6.x, and it is used as a `fallback()` function for empty calldata (or any value) that is only able to receive ether. 
    - remember that solidity’s `fallback()` function is executed if none of the other functions match the function identifier or no data was provided with the function call (and it can be optionally `payable`). 

<br>

```solidity
receive() external payable {}
```



<br>


----

### solution


<br>

* we write the following exploit, located at  `src/10/ReentrancyExploit.sol`:

<br>

```solidity

```

<br>

* which can be tested with `test/10/Reentrancy.t.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge test --match-contract ReentrancyTest -vvvv    
```



<br>

* the solution can be submitted with `script/10/Reentrancy.s.sol`:

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

### alternative  solution using `cast`

<br>

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>


