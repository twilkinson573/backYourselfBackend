# Back Yourself web3 Wager Dapp

An EVM dapp where a user can challenge a friend to a wagers via their on-chain address

Betting on who will win in Fifa 1v1 will never be the same again 😈

### Wager Flow

1. User a creates a wager by supplying an opponent, wager size (in $), and a description
2. The opponent can either accept or decline the wager
3. The wager is now live and both users can declare their verdict on who won once the deed is done
4. If both participants are in agreement & truthful on the outcome, the winner is paid out minus a 1% protocol fee
5. If the participants are not in agreement on the truthful outcome (ie. a dispute), then a form of slashing occrs and the protocol takes the stakes as a deterrent

### Nickname Support

The dapp supports nicknames that users can set to provide friendly human-readable confirmation in the UI and prevent incorrect addresses

Normally in a production-focussed dapp I would handle these (and probably the description metadata of wagers too) offchain either in browser localStorage or a small persistant hosted database

They are implemented directly into the smart contract here to give more practice in the smart-contract<->frontend feature development cycle

### Trapped funds

There is currently a known issue of sorts where if your opponent never responds to your wager, then your staked funds will be trapped in the contract
To counter this, we could either:
- Have a timelock that auto-declines stale wagers and releases funds
- Have a lock that prevents users interacting if they have unresponded to wagers in their inbox
- Take funds from both sides at the point where the wager is accepted, rather than taking the initial stake upon wager creation

This will be addressed in a v2

~~~~~~~~~~

Note. Reentrancy
Slither flagged functions createWager & provideWagerResponse as potential reentrancy vulnerabilities
I see why it is flagged (external call before setting a state variable), however assessing the actual use case I don't think it's at danger to reentrancy as the external contract (the wantToken - ie. the USDC contract) that is called is specified directly by the deployer
I need to research this to be sure
