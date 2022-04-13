// declares main function 
// async - able to stand idle, suspends execution until promise (await) is fulfilled or rejected
const main = async () => {
    // compile contract, generate files required to deploy
    // HRE - hardhat runtime environment - "npx hardhat" in terminal builds the import
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    
    // create local ETH network just for this contract - "refreshing" on each deploy
    // funds the contract here w/ parseEther on deployment
    const waveContract = await waveContractFactory.deploy({
        value: hre.ethers.utils.parseEther("0.001"),
    });
 
    // wait until contract is deployed to local blockchain - constructor runs when deployed
    await waveContract.deployed();

    // gives address of deployed contract
    console.log("WavePortal address: ", waveContract.address);

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