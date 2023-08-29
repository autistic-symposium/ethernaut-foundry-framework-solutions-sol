## Elevator

<br>


### tl; dr

<br>


* 

<br>
  
<p align="center">
<img width="300" src="">
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


<br>



----

### solution

<br>

* check `test/11/Elevator.t.sol`:

<br>

```solidity



```

<br>

* run:

<br>

```shell
> forge test --match-contract ElevatorTest -vvvv    
```



<br>

* submit with `script/11/Elevator.s.sol`:

<br>

```solidity




```

<br>

* by running:

<br>

```shell
> forge script ./script/11/Elevator.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>

----


### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



