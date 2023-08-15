## 🧑🏻‍🚀 my ethernaut write-ups in foundry

<br>

##### 🔋 this project contains my write-ups on **[openzeppelin's ethernaut wargames](https://ethernaut.openzeppelin.com/)**.

##### 🔋 to respect the challenge, i am not sharing explicit solutions (only for the first problem). instead, i provide: *i)* a discussion of the research i did or routes i took while solving them, and *ii)* their setup and boilerplates. this should give you enough tooling to come up with your own answers. you may check my 1337 progress at the **[ethernaut's leaderboard](https://ethernaut.openzeppelin.com/leaderboard)**.
##### 🔋 probably out of context, but **[here is my wechat profile from playing overthewire in 2014](https://www.wechall.net/profile/bt3gl)**.

<br>
<br>

<p align="center">
<img width="450" src="https://github.com/go-outside-labs/ethernaut-foundry-writeups-sol/assets/138340846/32fb029d-852e-493b-8f79-939fe39d5455">
</p>


<br>

---

### levels

<br>

##### 01. Fallback: [exploit test + write-up](test/01) and [submission script](script/01/)
#####  02. Fallout: [exploit test + write-up](test/02) and [submission script](script/02/)
##### 03. Coin Flip: [exploit test + write-up](test/03) and [submission script](script/03/)
##### 04. Telephone: [exploit test + write-up](test/04) and [submission script](script/04/)
##### 05. Token: [exploit test + write-up](test/05) and [submission script](script/05/)
##### 06. Delegation: [exploit test + write-up](test/06) and [submission script](script/06/)
##### 07. Force: [exploit test + write-up](test/07) and [submission script](script/07/)
##### 08. Vault: [exploit test + write-up](test/08) and [submission script](script/08/)
##### 09. King: [exploit test + write-up](test/09) and [submission script](script/09/)
##### 10. Reentrancy: [exploit test + write-up](test/10) and [submission script](script/10/)
##### 11. Elevator: [exploit test + write-up](test/11) and [submission script](script/11/)
##### 12. Privacy: [exploit test + write-up](test/12) and [submission script](script/12/)
##### 13. Gatekeeper One: [exploit test + write-up](test/13) and [submission script](script/13/)
##### 14. Gatekeeper Two: [exploit test + write-up](test/14) and [submission script](script/14/)
##### 15. Naught Coin: [exploit test + write-up](test/15) and [submission script](script/15/)
##### 16. Preservation: [exploit test + write-up](test/16) and [submission script](script/16/)
##### 17. Recovery: [exploit test + write-up](test/17) and [submission script](script/17/)
##### 18. Magic Number: [exploit test + write-up](test/18) and [submission script](script/18/)
##### 19. Alien Code: [exploit test + write-up](test/19) and [submission script](script/19/)
##### 20. Denial: [exploit test + write-up](test/20) and [submission script](script/20/)
##### 21. Shop: [exploit test + write-up](test/21) and [submission script](script/21/)
##### 22. Dex: [exploit test + write-up](test/22) and [submission script](script/22/)
##### 23. Dex Two: [exploit test + write-up](test/23) and [submission script](script/23/)
##### 24. Puzzle Wallet: [exploit test + write-up](test/24) and [submission script](script/24/)
##### 25. Motorbike: [exploit test + write-up](test/25) and [submission script](script/25/)
##### 26. Doubly Entry Point: [exploit test + write-up](test/26) and [submission script](script/26/)
##### 27. Good Samaritan: [exploit test + write-up](test/27) and [submission script](script/27/)
##### 28. Gatekeeper Three: [exploit test + write-up](test/28) and [submission script](script/28/)
##### 29. Switch: [exploit test + write-up](test/29) and [submission script](script/29/)


<br>


----

### installing 

<br>

* install **[foundry](https://github.com/foundry-rs/foundry)**

* create a `.env` (from `.env.example`) and add your private and private keys

* add an sepolia rpc url to `foundry.toml`

<br>

---

### running

<br>

* run tests with:
    - `forge test -vvvv`, or, for example,
    - `forge test -vvvv --match-path ./test/01/Fallback.t.sol`


* submit scripts with, for example, 
    - `forge script ./script/01/Fallback.s.sol  --broadcast -vvvv --rpc-url sepolia`

<br>

