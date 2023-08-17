## 🧑🏻‍🚀 my ethernaut write-ups and solution in foundry

<br>

##### 🔋 this project contains solutions for **[openzeppelin's ethernaut wargames](https://ethernaut.openzeppelin.com/)**. leveraging **foundry**, each level has a test set (`.t.sol`), a script set (`.s.sol`), and a write-up. some levels also have an exploit `src/.sol`.
##### 🔋 do you remember overthewire? **[here is my WeChall profile from playing it in 2014](https://www.wechall.net/profile/bt3gl)**.

<br>

<p align="center">
<img width="400" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/32fb029d-852e-493b-8f79-939fe39d5455">
</p>


---

### levels

<br>

##### ✅ 01. Fallback: 
- **[solidity exploit + foundry test + write-up](test/01)**
- **[submission foundry script](script/01/)**
##### ✅ 02. Fallout: 
- **[solidity exploit + foundry test + write-up](test/02)**
- **[submission foundry script](script/02/)**
##### ✅ 03. Coin Flip: 
- **[solidity exploit + foundry test + write-up](test/03)**
- **[submission foundry script](script/03/)**
##### ✅ 04. Telephone: 
- **[solidity exploit + foundry test + write-up](test/04)**
- **[submission foundry script](script/04/)**
##### ✅ 05. Token: 
- **[solidity exploit + foundry test + write-up](test/05)**
- **[submission foundry script](script/05/)**
##### ✅ 06. Delegation: 
- **[solidity exploit + foundry test + write-up](test/06)**
- **[submission foundry script](script/06/)**
##### 07. Force: 
- **[solidity exploit + foundry test + write-up](test/07)**
- **[submission foundry script](script/07/)**
##### 08. Vault: 
- **[solidity exploit + foundry test + write-up](test/08)**
- **[submission foundry script](script/08/)**
##### 09. King: 
- **[solidity exploit + foundry test + write-up](test/09)**
- **[submission foundry script](script/09/)**
##### 10. Reentrancy: 
- **[solidity exploit + foundry test + write-up](test/10)**
- **[submission foundry script](script/10/)**
##### 11. Elevator: 
- **[solidity exploit + foundry test + write-up](test/11)**
- **[submission foundry script](script/11/)**
##### 12. Privacy: 
- **[solidity exploit + foundry test + write-up](test/12)**
- **[submission foundry script](script/12/)**
##### 13. Gatekeeper One: 
- **[solidity exploit + foundry test + write-up](test/13)**
- **[submission foundry script](script/13/)**
##### 14. Gatekeeper Two: 
- **[solidity exploit + foundry test + write-up](test/14)**
- **[submission foundry script](script/14/)**
##### 15. Naught Coin: 
- **[solidity exploit + foundry test + write-up](test/15)**
- **[submission foundry script](script/15/)**
##### 16. Preservation: 
- **[solidity exploit + foundry test + write-up](test/16)**
- **[submission foundry script](script/16/)**
##### 17. Recovery: 
- **[solidity exploit + foundry test + write-up](test/17)**
- **[submission foundry script](script/17/)**
##### 18. Magic Number: 
- **[solidity exploit + foundry test + write-up](test/18)**
- **[submission foundry script](script/18/)**
##### 19. Alien Code: 
- **[solidity exploit + foundry test + write-up](test/19)**
- **[submission foundry script](script/19/)**
##### 20. Denial: 
- **[solidity exploit + foundry test + write-up](test/20)**
- **[submission foundry script](script/20/)**
##### 21. Shop: 
- **[solidity exploit + foundry test + write-up](test/21)**
- **[submission foundry script](script/21/)**
##### 22. Dex: 
- **[solidity exploit + foundry test + write-up](test/22)**
- **[submission foundry script](script/22/)**
##### 23. Dex Two: 
- **[solidity exploit + foundry test + write-up](test/23)**
- **[submission foundry script](script/23/)**
##### 24. Puzzle Wallet: 
- **[solidity exploit + foundry test + write-up](test/24)**
- **[submission foundry script](script/24/)**
##### 25. Motorbike: 
- **[solidity exploit + foundry test + write-up](test/25)**
- **[submission foundry script](script/25/)**
##### 26. Doubly Entry Point: 
- **[solidity exploit + foundry test + write-up](test/26)**
- **[submission foundry script](script/26/)**
##### 27. Good Samaritan: 
- **[solidity exploit + foundry test + write-up](test/27)**
- **[submission foundry script](script/27/)**
##### 28. Gatekeeper Three: 
- **[solidity exploit + foundry test + write-up](test/28)**
- **[submission foundry script](script/28/)**
##### 29. Switch: 
- **[solidity exploit + foundry test + write-up](test/29)**
- **[submission foundry script](script/29/)**


<br>


----

### installing 

<br>

* install **[foundry](https://github.com/foundry-rs/foundry)**

* create a `.env` (from `.env.example`) and add your private and private keys

* add a sepolia rpc url to `foundry.toml`

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

