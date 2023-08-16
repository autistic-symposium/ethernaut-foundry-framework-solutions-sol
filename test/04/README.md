## 04. Telephone

<br>


  
<p align="center">
<img width="200" src=""">
</p>

<br>
### tl; dr

<br>

* in this challenge we exploit a vulnerability caused by confusing `tx.origin` and `msg.sender` to become `owner`.
    - `tx.origin` refers to the EOA that initiated the transaction (which can be many calls ago), while `msg.sender` is the immediate caller.

<br>

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Telephone {

  address public owner;

  constructor() {
    owner = msg.sender;
  }

  function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
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

* check `test/04/Telephone.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract TelephoneTest -vvvv    
```



<br>

* submit with `script/04/Telephone.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/04/Telephone.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



