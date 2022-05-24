# Buildspace Smart Contract Intro Lesson

Thanks for checking out my GitHub! 

This was a project that was built alongside the BuildSpace Intro to Solidity lesson. 

The WavePortal.sol contract is designed to recieve "waves" from users that visit the webpage.

To wave, the user will connect their web3 wallet (I used Metamask for this example), jot down a message in the front end, confirm the transaction and send it on to the deployed contract.

Wave is a struct that holds the userId (wallet address), the message, and its timestamp. 

We also implemented a lottery whereby the message sender has a chance to win some (test) ETH when they submit their message. To keep someone from spamming the contract, we included a 30-second time lag feature.

This was a lot of fun - my front end design admittedly isn't that pretty and is part of the to-do list for cleaning things up.

Thanks again for checking it out!

Some to-dos for later:

- include a prompt to approve wallet connection
- fix textboxes so they are a little cleaner
- play around with the overall background color and page design

# buildspace_web3-solidity
