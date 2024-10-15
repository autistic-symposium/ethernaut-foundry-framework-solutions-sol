## 🧑🏻‍🚀 my foundry framework to solve ethernaut: write-ups + solutions 

<br>

##### 🔋 this project contains solutions for **[openzeppelin's ethernaut wargames](https://ethernaut.openzeppelin.com/)**. leveraging **foundry**, each level has a test set (`test/*.t.sol`), a script set (`script/*.s.sol`), and a write-up. some levels also have an exploit at `src/*.sol`. 

##### 🔋 to read the full notes about this work, check out my mirror publication: **[on hacking systematically with foundry](https://mirror.xyz/go-outside.eth)**. you are welcome to submit solutions and pull requests.


##### 🔋 by the way, do you remember overthewire? **[here is my WeChall profile from playing it in 2014](https://www.wechall.net/profile/bt3gl)**.



<br>

<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/32fb029d-852e-493b-8f79-939fe39d5455">
</p>


---

### levels

<br>

##### ✅ 01. Fallback - exploiting `fallback()`:
- **[write-up + foundry test](test/01)**
- **[submission foundry script](script/01/)**


##### ✅ 02. Fallout - exploiting `constructor()`:
- **[write-up + foundry test](test/02)**
- **[submission foundry script](script/02/)**


##### ✅ 03. Coin Flip - exploiting pseudo-randomness:
- **[write-up + foundry test](test/03)**
- **[solidity exploit](src/03)**
- **[submission foundry script](script/03/)**


##### ✅ 04. Telephone - exploiting `tx.origin`:
- **[write-up + foundry test](test/04)**
- **[solidity exploit](src/04)**
- **[submission foundry script](script/04/)**


##### ✅ 05. Token - exploiting integer overflows:
- **[write-up + foundry test](test/05)**
- **[submission foundry script](script/05/)**


##### ✅ 06. Delegation - exploiting `delegatecall`:
- **[write-up + foundry test](test/06)**
- **[submission foundry script](script/06/)**


##### ✅ 07. Force - exploiting payable contracts:
- **[write-up + foundry test](test/07)**
- **[solidity exploit](src/07)**
- **[submission foundry script](script/07/)**


##### ✅ 08. Vault - exploiting private functions:
- **[write-up + foundry test](test/08)**
- **[submission foundry script](script/08/)**

##### ✅ 09. King - exploiting `transfer(msg.value)`:
- **[write-up + foundry test](test/09)**
- **[solidity exploit](src/09)**
- **[submission foundry script](script/09/)**

##### ✅ 10. Reentrancy - exploiting reentrancy:
- **[write-up + foundry test](test/10)**
- **[solidity exploit](src/10)**
- **[submission foundry script](script/10/)**

  
##### ✅ 11. Elevator - exploiting interfaces:
- **[write-up + foundry test](test/11)**
- **[solidity exploit](src/11/)**
- **[submission foundry script](script/11/)**


##### 🔜 12. Privacy: 
- **[write-up + foundry test](test/12)**
- **[submission foundry script](script/12/)**


##### 🔜 13. Gatekeeper One: 
- **[write-up + foundry test](test/13)**
- **[submission foundry script](script/13/)**


##### 🔜 14. Gatekeeper Two: 
- **[write-up + foundry test](test/14)**
- **[submission foundry script](script/14/)**


##### 🔜 15. Naught Coin: 
- **[write-up + foundry test](test/15)**
- **[submission foundry script](script/15/)**


##### 🔜 16. Preservation: 
- **[write-up + foundry test](test/16)**
- **[submission foundry script](script/16/)**


##### 🔜 17. Recovery: 
- **[write-up + foundry test](test/17)**
- **[submission foundry script](script/17/)**


##### 🔜 18. Magic Number: 
- **[write-up + foundry test](test/18)**
- **[submission foundry script](script/18/)**


##### 🔜 19. Alien Code: 
- **[write-up + foundry test](test/19)**
- **[submission foundry script](script/19/)**


##### 🔜 20. Denial: 
- **[write-up + foundry test](test/20)**
- **[submission foundry script](script/20/)**


##### ✅ 21. Shop - exploiting interfaces II:
- **[write-up + foundry test](test/21)**
- **[solidity exploit](src/21)**
- **[submission foundry script](script/21/)**


##### 🔜 22. Dex: 
- **[write-up + foundry test](test/22)**
- **[solidity exploit](src/22/)**
- **[submission foundry script](script/22/)**


##### 🔜 23. Dex Two: 
- **[write-up + foundry test](test/23)**
- **[submission foundry script](script/23/)**


##### 🔜 24. Puzzle Wallet: 
- **[write-up + foundry test](test/24)**
- **[submission foundry script](script/24/)**


##### 🔜 25. Motorbike: 
- **[write-up + foundry test](test/25)**
- **[submission foundry script](script/25/)**


##### 🔜 26. Doubly Entry Point: 
- **[write-up + foundry test](test/26)**
- **[submission foundry script](script/26/)**


##### 🔜 27. Good Samaritan: 
- **[write-up + foundry test](test/27)**
- **[submission foundry script](script/27/)**


##### 🔜 28. Gatekeeper Three: 
- **[write-up + foundry test](test/28)**
- **[submission foundry script](script/28/)**


##### 🔜 29. Switch: 
- **[write-up + foundry test](test/29)**
- **[submission foundry script](script/29/)**


<br>


----

### installing 

<br>

* install **[foundry](https://github.com/foundry-rs/foundry)**

* create a test wallet (*e.g.*, with metamask)

* create a `.env` (copying from `.env.example`) and add keys and the addresses of each instance.

* add a sepolia rpc url to `foundry.toml` (*e.g.*, from **[alchemy](https://www.alchemy.com/)** or **[infura](https://www.infura.io/)**)

<br>

---

### running each level

<br>

* you will find detailed instructions in each write-up, but as a general rule:

<br>

* run tests with, for example,
    - `forge test -vvvv`, or, for example,
    - `forge test -vvvv --match-path ./test/01/Fallback.t.sol`


<br>

* submit scripts with, for example, 
    - `forge script ./script/01/Fallback.s.sol --broadcast -vvvv --rpc-url sepolia`

<br>

<br>

----

<br>


###### (like solving these types of problems? perhaps you are [autistic cypherpunk](https://github.com/autistic-symposium/ethernaut-systematic-solutions-foundry-sol), then?)

