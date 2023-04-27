// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./Users.sol";
import "./Groups.sol";

contract Main {
    Users private usersContract;
    Groups private groupsContract;

    constructor() {
        usersContract = new Users();
        groupsContract = new Groups();
    }

    // Users contract functions
    function addUser(string memory _username, string memory _publicKey) public {
        usersContract.addUser(_username, _publicKey);
    }

    function addFriend(address _friendAddress) public {
        usersContract.addFriend(_friendAddress);
    }

    function deleteFriend(address _friendAddress) public {
        usersContract.deleteFriend(_friendAddress);
    }

    function getFriends() public view returns (address[] memory) {
        return usersContract.getFriends();
    }

    function getPublicKey(address _userAddress) public view returns (string memory) {
        return usersContract.getPublicKey(_userAddress);
    }

    function generateNewKeyPair() public {
        usersContract.generateNewKeyPair();
    }

    function setIcon(string memory _iconUrl) public {
        usersContract.setIcon(_iconUrl);
    }

    // Groups contract functions
    function createGroup(string memory _groupName) public {
        groupsContract.createGroup(_groupName);
    }

    function inviteUser(address _userAddress, uint256 _groupId, uint8 _role) public {
        groupsContract.inviteUser(_userAddress, _groupId, _role);
    }

    function joinGroup(uint256 _groupId, uint8 _role) public {
        groupsContract.joinGroup(_groupId, _role);
    }

    function leaveGroup(uint256 _groupId) public {
        groupsContract.leaveGroup(_groupId);
    }

    function kickUser(address _userAddress, uint256 _groupId) public {
        groupsContract.kickUser(_userAddress, _groupId);
    }

    function banUser(address _userAddress, uint256 _groupId) public {
        groupsContract.banUser(_userAddress, _groupId);
    }

    function getGroupInfo(uint256 _groupId) public view returns (string memory, uint8, address[] memory) {
        return groupsContract.getGroupInfo(_groupId);
    }

    function getGroups() public view returns (uint256[] memory) {
        return groupsContract.getGroups();
    }

    function getGroupUsers(uint256 _groupId) public view returns (address[] memory) {
        return groupsContract.getGroupUsers(_groupId);
    }
}
