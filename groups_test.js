const Web3 = require("web3");
const fs = require("fs");
const path = require("path");
const solc = require("solc");

// Load contract
const groupsContractData = fs.readFileSync(path.join(__dirname, "../contracts/Groups.sol"), "utf-8");

// Create web3 instance
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

// Set default account to deploy contract
web3.eth.defaultAccount = web3.eth.accounts[0];

// Compile contract
const input = {
  language: "Solidity",
  sources: {
    "Groups.sol": {
      content: groupsContractData,
    },
  },
  settings: {
    outputSelection: {
      "*": {
        "*": ["*"],
      },
    },
  },
};

const compiledContracts = JSON.parse(solc.compile(JSON.stringify(input)));

const compiledGroupsContract = compiledContracts.contracts["Groups.sol"]["Groups"];

// Deploy contract
const groupsAbiDefinition = compiledGroupsContract.abi;
const groupsContract = new web3.eth.Contract(groupsAbiDefinition);

const usersContractAddress = "<address-of-users-contract>"; // Replace with actual address of Users contract

const groupsContractInstance = groupsContract.deploy({
    data: "0x" + compiledGroupsContract.evm.bytecode.object,
    arguments: [usersContractAddress]
  })
  .send({
    from: web3.eth.accounts[0],
    gas: 1000000
  }, function (error, transactionHash) {
    if (error) {
      console.error(error);
    } else {
      console.log("Transaction hash:", transactionHash);
    }
  })
  .then(function (newContractInstance) {
    console.log(`Groups contract deployed at ${newContractInstance.options.address}`);
    // Call contract function to create a new group
    newContractInstance.methods.createGroup("My New Group").send({ from: web3.eth.defaultAccount }, function (error, transactionHash) {
      if (error) {
        console.error(error);
      } else {
        console.log("Transaction hash:", transactionHash);
      }
    });
  });
