const Web3 = require("web3");
const fs = require("fs");
const path = require("path");
const solc = require("solc");

// Load contract
const usersContractData = fs.readFileSync(path.join(__dirname, "../contracts/Users.sol"), "utf-8");

// Create web3 instance
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

// Set default account to deploy contract
web3.eth.defaultAccount = web3.eth.accounts[0];

// Compile contract
const input = {
  language: "Solidity",
  sources: {
    "Users.sol": {
      content: usersContractData,
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

const compiledUsersContract = compiledContracts.contracts["Users.sol"]["Users"];

// Deploy contract
const usersAbiDefinition = compiledUsersContract.abi;
const usersContract = new web3.eth.Contract(usersAbiDefinition);

const usersContractInstance = usersContract.deploy({
    data: "0x" + compiledUsersContract.evm.bytecode.object,
    arguments: []
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
    console.log(`Users contract deployed at ${newContractInstance.options.address}`);
  });
