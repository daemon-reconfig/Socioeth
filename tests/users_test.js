const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Load contract
const usersContractData = fs.readFileSync(path.join(__dirname, "../contracts/Users.sol"), "utf-8");

// Create web3 instance
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

// Set default account
web3.eth.defaultAccount = web3.eth.accounts[0];

// Get contract ABI and address
const compiledUsersContract = require(path.join(__dirname, "../build/contracts/Users.json"));
const usersContractAddress = compiledUsersContract.networks[Object.keys(compiledUsersContract.networks)[0]].address;
const usersAbiDefinition = compiledUsersContract.abi;

// Create contract instance
const usersContractInstance = new web3.eth.Contract(usersAbiDefinition, usersContractAddress);

// Test contract methods
usersContractInstance.methods.createUser("Alice").send({from: web3.eth.defaultAccount})
.then((result) => {
    console.log("createUser transaction hash:", result.transactionHash);
    return usersContractInstance.methods.getUser(0).call();
})
.then((result) => {
    console.log("getUser result:", result);
})
.catch((error) => {
    console.error(error);
});
