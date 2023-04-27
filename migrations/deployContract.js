const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Load contracts
const usersContractData = fs.readFileSync(path.join(__dirname, "contracts/Users.sol"), "utf-8");
const groupsContractData = fs.readFileSync(path.join(__dirname, "contracts/Groups.sol"), "utf-8");

// Create web3 instance
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

// Set default account to deploy contracts
web3.eth.defaultAccount = web3.eth.accounts[0];

// Compile contracts
const compiledUsersContract = web3.eth.compile.solidity(usersContractData).Users;
const compiledGroupsContract = web3.eth.compile.solidity(groupsContractData).Groups;

// Deploy contracts
const usersContract = web3.eth.contract(compiledUsersContract.info.abiDefinition);
const groupsContract = web3.eth.contract(compiledGroupsContract.info.abiDefinition);

const usersContractInstance = usersContract.new(
  {
    from: web3.eth.accounts[0],
    data: compiledUsersContract.code,
    gas: 1000000
  },
  (err, contract) => {
    if (err) {
      console.error(err);
      return;
    }
    if (!contract.address) {
      console.log("Contract transaction sent, waiting for confirmation...");
    } else {
      console.log(`Users contract deployed at ${contract.address}`);
      const groupsContractInstance = groupsContract.new(
        {
          from: web3.eth.accounts[0],
          data: compiledGroupsContract.code,
          gas: 1000000,
          arguments: [contract.address]
        },
        (err, contract) => {
          if (err) {
            console.error(err);
            return;
          }
          if (!contract.address) {
            console.log("Contract transaction sent, waiting for confirmation...");
          } else {
            console.log(`Groups contract deployed at ${contract.address}`);
          }
        }
      );
    }
  }
);
const Web3 = require("web3");
const fs = require("fs");
const path = require("path");

// Load contracts
const usersContractData = fs.readFileSync(path.join(__dirname, "contracts/Users.sol"), "utf-8");
const groupsContractData = fs.readFileSync(path.join(__dirname, "contracts/Groups.sol"), "utf-8");

// Create web3 instance
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

// Set default account to deploy contracts
web3.eth.defaultAccount = web3.eth.accounts[0];

// Compile contracts
const compiledUsersContract = web3.eth.compile.solidity(usersContractData).Users;
const compiledGroupsContract = web3.eth.compile.solidity(groupsContractData).Groups;

// Deploy contracts
const usersContract = web3.eth.contract(compiledUsersContract.info.abiDefinition);
const groupsContract = web3.eth.contract(compiledGroupsContract.info.abiDefinition);

const usersContractInstance = usersContract.new(
  {
    from: web3.eth.accounts[0],
    data: compiledUsersContract.code,
    gas: 1000000
  },
  (err, contract) => {
    if (err) {
      console.error(err);
      return;
    }
    if (!contract.address) {
      console.log("Contract transaction sent, waiting for confirmation...");
    } else {
      console.log(`Users contract deployed at ${contract.address}`);
      const groupsContractInstance = groupsContract.new(
        {
          from: web3.eth.accounts[0],
          data: compiledGroupsContract.code,
          gas: 1000000,
          arguments: [contract.address]
        },
        (err, contract) => {
          if (err) {
            console.error(err);
            return;
          }
          if (!contract.address) {
            console.log("Contract transaction sent, waiting for confirmation...");
          } else {
            console.log(`Groups contract deployed at ${contract.address}`);
          }
        }
      );
    }
  }
);
