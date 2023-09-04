## Switch

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
contract Switch {
    bool public switchOn; // switch is off
    bytes4 public offSelector = bytes4(keccak256("turnSwitchOff()"));

     modifier onlyThis() {
        require(msg.sender == address(this), "Only the contract can call this");
        _;
    }

    modifier onlyOff() {
        // we use a complex data type to put in memory
        bytes32[1] memory selector;
        // check that the calldata at position 68 (location of _data)
        assembly {
            calldatacopy(selector, 68, 4) // grab function selector from calldata
        }
        require(
            selector[0] == offSelector,
            "Can only call the turnOffSwitch function"
        );
        _;
    }

    function flipSwitch(bytes memory _data) public onlyOff {
        (bool success, ) = address(this).call(_data);
        require(success, "call failed :(");
    }

    function turnSwitchOn() public onlyThis {
        switchOn = true;
    }

    function turnSwitchOff() public onlyThis {
        switchOn = false;
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

* check `test/.t.sol`:

<br>

```solidity

```

<br>

* run:

<br>

```shell
> forge test --match-contract Test -vvvv    


```



<br>

* submit with `script/.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/0.s.sol --broadcast -vvvv --rpc-url sepolia


```

<br>

----

<br>

#### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



