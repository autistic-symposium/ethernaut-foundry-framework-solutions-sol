## 🧑🏻‍🚀 my ethernaut write-ups and solution in foundry

<br>

##### 🔋 this project contains solutions for **[openzeppelin's ethernaut wargames](https://ethernaut.openzeppelin.com/)**. leveraging **foundry**, each level has a test set (`.t.sol`), a script set (`.s.sol`), and write-up. some levels also have a exploit `src/.sol`.
##### 🔋 do you remember overthewire? **[here is my WeChall profile from playing it in 2014](https://www.wechall.net/profile/bt3gl)**.

<br>
<br>

<p align="center">
<img width="450" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/32fb029d-852e-493b-8f79-939fe39d5455">
</p>


<br>

---

### levels

<br>

##### ✅ 01. Fallback: [exploit + foundry test + write-up](test/01) and [submission foundry script](script/01/)
##### ✅ 02. Fallout: [exploit + foundry test + write-up](test/02) and [submission foundry script](script/02/)
##### ✅ 03. Coin Flip: [exploit + foundry test + write-up](test/03) and [submission foundry script](script/03/)
##### ✅ 04. Telephone: [exploit + foundry test + write-up](test/04) and [submission foundry script](script/04/)
##### 05. Token: [exploit + foundry test + write-up](test/05) and [submission foundry script](script/05/)
##### 06. Delegation: [exploit + foundry test + write-up](test/06) and [submission foundry script](script/06/)
##### 07. Force: [exploit + foundry test + write-up](test/07) and [submission foundry script](script/07/)
##### 08. Vault: [exploit + foundry test + write-up](test/08) and [submission foundry script](script/08/)
##### 09. King: [exploit + foundry test + write-up](test/09) and [submission foundry script](script/09/)
##### 10. Reentrancy: [exploit + foundry test + write-up](test/10) and [submission foundry script](script/10/)
##### 11. Elevator: [exploit + foundry test + write-up](test/11) and [submission foundry script](script/11/)
##### 12. Privacy: [exploit + foundry test + write-up](test/12) and [submission foundry script](script/12/)
##### 13. Gatekeeper One: [exploit + foundry test + write-up](test/13) and [submission foundry script](script/13/)
##### 14. Gatekeeper Two: [exploit + foundry test + write-up](test/14) and [submission foundry script](script/14/)
##### 15. Naught Coin: [exploit + foundry test + write-up](test/15) and [submission foundry script](script/15/)
##### 16. Preservation: [exploit + foundry test + write-up](test/16) and [submission foundry script](script/16/)
##### 17. Recovery: [exploit + foundry test + write-up](test/17) and [submission foundry script](script/17/)
##### 18. Magic Number: [exploit + foundry test + write-up](test/18) and [submission foundry script](script/18/)
##### 19. Alien Code: [exploit + foundry test + write-up](test/19) and [submission foundry script](script/19/)
##### 20. Denial: [exploit + foundry test + write-up](test/20) and [submission foundry script](script/20/)
##### 21. Shop: [exploit + foundry test + write-up](test/21) and [submission foundry script](script/21/)
##### 22. Dex: [exploit + foundry test + write-up](test/22) and [submission foundry script](script/22/)
##### 23. Dex Two: [exploit + foundry test + write-up](test/23) and [submission foundry script](script/23/)
##### 24. Puzzle Wallet: [exploit + foundry test + write-up](test/24) and [submission foundry script](script/24/)
##### 25. Motorbike: [exploit + foundry test + write-up](test/25) and [submission foundry script](script/25/)
##### 26. Doubly Entry Point: [exploit + foundry test + write-up](test/26) and [submission foundry script](script/26/)
##### 27. Good Samaritan: [exploit + foundry test + write-up](test/27) and [submission foundry script](script/27/)
##### 28. Gatekeeper Three: [exploit + foundry test + write-up](test/28) and [submission foundry script](script/28/)
##### 29. Switch: [exploit + foundry test + write-up](test/29) and [submission foundry script](script/29/)


<br>


----

### installing 

<br>

* install **[foundry](https://github.com/foundry-rs/foundry)**

* create a `.env` (from `.env.example`) and add your private and private keys

* add an sepolia rpc url to `foundry.toml`

<br>

---

### running each level

<br>

* run tests with:
    - `forge test -vvvv`, or, for example,
    - `forge test -vvvv --match-path ./test/01/Fallback.t.sol`


* submit scripts with, for example, 
    - `forge script ./script/01/Fallback.s.sol --broadcast -vvvv --rpc-url sepolia`

<br>

