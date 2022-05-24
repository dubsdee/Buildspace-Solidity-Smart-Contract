// SPDX-License-Identifier: UNLICENSED

// Version of solidity compiler we are running
pragma solidity ^0.8.0;

//importing the console.sol file from hardhart
import "hardhat/console.sol";

// declares the contract, titled "WavePortal". Similar to a class declaration
contract WavePortal {
    uint256 totalWaves;

    //this is used to help generate a random number
    uint256 private seed;
    
    // new event declaration - event arguements are passed to the blockchain when called
    event NewWave(address indexed from, uint256 timestamp, string message);
   
    // create a new struct called Wave
    // custom datatype where we can customize what gets held inside
    struct Wave {
        address waver; //address of user who waved
        string message; // message the user sent
        uint256 timestamp; // timestamp when user waved
    }
   
    // declare a variable "waves" that lets me store an array of structs
    // holds the waves that everyone sends to the contract

    Wave[] waves;

    // Address => uint mapping - associate an address with a number
    // here, storing address with the last time user waved at us

    mapping(address => uint256) public lastWavedAt;


    // added the payable keyword
    constructor() payable {
        console.log("Beep, boop - Smart Contract Constructed!");
        //set the initial seed for random number generation
        // difficulty and timestamp used to create the seed 
        // difficulty based on how hard it is to mine the block
        // timestamp is when the block is processed

        seed = (block.timestamp + block.difficulty) % 100;
    }

    // added wave function here as it now requires string input (_message)
    // message is passed from user to the contract on the front end site

    function wave(string memory _message) public {
        // creating a time lag feature as to prevent spamming - 30 second cool down
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Please wait 30 seconds before calling again."
        );

        // update the current timestamp for the user to check if they can call again
        lastWavedAt[msg.sender] = block.timestamp;
        
        
        totalWaves += 1;
        console.log("%s just waved! They said %s", msg.sender, _message);
    

        // this is where the wave data gets pushed to the array

        waves.push(Wave(msg.sender, _message, block.timestamp));

        // generate a new seed to pair with next user that sends a wave
        // variable seed is changed everytime a new wave is sent - makes it more 
        // difficult by bad actors to bypass the random generation
        // mod 100 to make sure the number is 0-99
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);

        // if block to give a 50/50 chance user wins the ETH
        if (seed <=10) {
            console.log("%s won!", msg.sender);

            // same code used before to send the prize to user
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more ETH than available."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        //this emits the results of the NewWave event that was logged to the blockchain
        // events are messages the SC throw that can capture on client in real time
        emit NewWave(msg.sender, block.timestamp, _message);
    }

// added function called getAllWaves which returns the struct array, waves, to us
// makes it easier to retrieve waves from website? 

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        //adding this to see contract print the value (of total waves I think?)
        console.log("We are currently at %d totalWaves", totalWaves);
        return totalWaves;
    }
}