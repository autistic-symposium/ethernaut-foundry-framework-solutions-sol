## Privacy

<br>


### tl; dr

<br>





<br>
  
<p align="center">
<img width="300" src="">
</p>


<br>

```solidity
contract Privacy {

  bool public locked = true;
  uint256 public ID = block.timestamp;
  uint8 private flattening = 10;
  uint8 private denomination = 255;
  uint16 private awkwardness = uint16(block.timestamp);
  bytes32[3] private data;

  constructor(bytes32[3] memory _data) {
    data = _data;
  }
  
  function unlock(bytes16 _key) public {
    require(_key == bytes16(data[2]));
    locked = false;
  }

  /*
    A bunch of super advanced solidity algorithms...

      ,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`
      .,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,
      *.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^         ,---/V\
      `*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.    ~|__(o.o)
      ^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'^`*.,*'  UU  UU
  */
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

* check `test/12/Privacy.t.sol`:

<br>

```solidity

```

<br>

* run the test with:

<br>

```shell
> forge test --match-contract PrivacyTest -vvvv    
```



<br>

* then submit the solution with `script/12/Privacy.s.sol`:

<br>

```solidity

```

<br>

* by running:

<br>

```shell
> forge script ./script/12/Privacy.s.sol --broadcast -vvvv --rpc-url sepolia
```

<br>


---

### solution using `cast`

<br>

<br>

----

### pwned...


<br>

  
<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/ba3f82a3-00c0-43f9-a423-588d7f6e4c70">
</p>



<br>


