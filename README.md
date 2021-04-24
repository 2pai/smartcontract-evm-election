##  Smart Contract Election based on (EVM)
Run your election with smart contract on blockchain (EVM).

### Prerequisites
- EVM Node (Ganache)
- Truffle
- Web3.js

### How To Use ?
**Example** 
Assuming we want to run an election on our college, and we have 3 candidate for it. We want to all of our faculty members to vote the right candidate to become chairman. 

##### Candidate : 
- Iqbal
- Bob
- Alice

#### Deploy
Before deploying the contract, if you're still in development mode, don't forget to run the `EVM` 

_Recommended: use Ganache_

Step: 
1. Set list of candidate on `CANDIDATE` in `migrations/constant.js` (index of array will be represent the candidate)

```js
const CANDIDATE = ['Alice','Bob','Iqbal']
```
2. Setup your network config
Assuming we want to deploy the contract on our local network, make sure you run `ganache` & edit the configuration on `truffle-config.js`
```

  networks: {
    development: {
     host: "127.0.0.1",     // Localhost (default: none)
     port: 8545,            // Standard Ethereum port (default: none)
     network_id: "*",       // Any network (default: none)
    },
```
3. Run `truffle compile` to compile the contract
4. Run `truffle migrate --network development`

Now the contract is deployed, you will se the contract address on the console.

#### Interacting with smart-contract
![voting smart contract diagram](./assets/SmartContract%20election.png)

##### Explanation:
Example: 
Vitalik (Faculty member) want to vote `Iqbal` on the election. So, Vitalik will regist their address to the Commite of election.

After receiving the address / list of addreses, the commite will call the `delegateVote()` or `massDelegateVote()` to grant faculty member to vote.

After Vitalik (Faculty Members) getting granted to vote, they can call `vote()` to vote the candidate, it will require `index of candidate` in this case Vitalik will vote `Iqbal` at index `2` so the function calling will be like this `vote(2)`

After 3 Days of voting period, the commite can call the `endVoting` function to end the voting & announce the winner of the election

##### Notes
Furthermore, the commite of election can be replaced by multisig contract to avoid centralized (single point of failure).
