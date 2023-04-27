const Web3 = require('web3');
const { abi: usersABI } = require('./build/Users.json');
const { abi: groupsABI } = require('./build/Groups.json');

const web3 = new Web3('http://localhost:8545'); // replace with your local node endpoint

const usersContractAddress = '0x123456...'; // replace with your deployed contract address
const groupsContractAddress = '0x789abc...'; // replace with your deployed contract address

const usersContract = new web3.eth.Contract(usersABI, usersContractAddress);
const groupsContract = new web3.eth.Contract(groupsABI, groupsContractAddress);

// Example function that uses both contracts
async function example() {
  const accounts = await web3.eth.getAccounts();

  // Use the Users contract
  const username = 'alice';
  await usersContract.methods.createUser(username).send({ from: accounts[0] });
  const user = await usersContract.methods.getUserByUsername(username).call();
  console.log(`User ${username} created with ID ${user.id}`);

  // Use the Groups contract
  const groupName = 'test group';
  await groupsContract.methods.createGroup(groupName, true).send({ from: accounts[0] });
  const group = await groupsContract.methods.getGroupByName(groupName).call();
  console.log(`Group ${groupName} created with ID ${group.id}`);
}

example().catch(console.error);
