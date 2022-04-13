
// declares main function 
// async - able to stand idle, suspends execution until promise (await) is fulfilled or rejected
const main = async () => {
  
    // compile contract, generate files required to deploy
    // HRE - hardhat runtime environment - "npx hardhat" in terminal builds the import
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    
    // create local ETH network just for this contract - "refreshing" on each deploy
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.01"), //DEPLOY CONTRACT AND FUND WITH 0.1 ETH (from wallet!)
    });

    // wait until contract is deployed to local blockchain - constructor runs when deployed
    await waveContract.deployed();

    // gives address of deployed contract
    console.log("Contract address:", waveContract.address);

    // Gets contract balance here
    let contractBalance = await hre.ethers.provider.getBalance(
        waveContract.address
    );
    console.log(
        "Contract balance:",
        hre.ethers.utils.formatEther(contractBalance) //see if contract has 0.1 balance
    );

    // SEND A WAVE
    // declare wave Txn function - call wave on the contract (changes state variable)
    const waveTxn = await waveContract.wave("INCOMING MESSAGE #1"); //passes a mesage to wave
    await waveTxn.wait(); // wait for the transaction to be mined

    // SEND ANOTHER WAVE
    const waveTxn2 = await waveContract.wave("INCOMING MESSAGE #2"); //passes a mesage to wave
    await waveTxn2.wait(); // wait for the transaction to be mined


    // get the contract balance and see what changed
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
        "Updated contract balance:",
        hre.ethers.utils.formatEther(contractBalance) //makes sure it worked
    );

    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();