// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Groups {
    struct Group {
        uint id;
        string name;
        address owner; // changed from uint to address
        mapping(address => bool) admins;
        mapping(address => bool) members;
        mapping(address => uint) roles;
        bytes32 groupKey;
        bool inviteOnly;
    }
    
    mapping(uint => Group) public groups;
    uint public groupIdCounter;
    
    mapping(address => uint) public userReputation;
    uint public reputationThreshold = 100;
    
    function createGroup(string memory name, bool inviteOnly) public {
        require(userReputation[msg.sender] >= reputationThreshold, "Not enough reputation points to create group."); // removed unnecessary parentheses
        
        Group storage newGroup = groups[groupIdCounter];
        newGroup.id = groupIdCounter;
        newGroup.name = name;
        newGroup.owner = msg.sender;
        newGroup.admins[msg.sender] = true;
        newGroup.roles[msg.sender] = 2; // Owner
        newGroup.groupKey = keccak256(abi.encodePacked(name, block.timestamp, msg.sender));
        newGroup.inviteOnly = inviteOnly;
        
        groupIdCounter++;
    }
    function addUser(uint groupId, address userAddress) public { // changed userId to userAddress
        require(groups[groupId].roles[msg.sender] >= 1, "Not authorized to add user.");
        require(!groups[groupId].members[userAddress], "User is already a member of the group."); // changed userId to userAddress

        groups[groupId].members[userAddress] = true; // changed userId to userAddress
        groups[groupId].roles[userAddress] = 0; // Member
    }
    
    function addAdmin(uint groupId, address userAddress) public { // changed userId to userAddress
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to add admin.");
        require(groups[groupId].members[userAddress], "User is not a member of the group."); // changed userId to userAddress
        
        groups[groupId].admins[userAddress] = true; // changed userId to userAddress
        groups[groupId].roles[userAddress] = 1; // Admin
    }
    
    function removeAdmin(uint groupId, address userAddress) public { // changed userId to userAddress
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to remove admin.");
        require(groups[groupId].admins[userAddress], "User is not an admin of the group."); // changed userId to userAddress
        
        groups[groupId].admins[userAddress] = false; // changed userId to userAddress
        groups[groupId].roles[userAddress] = 0; // Member
    }
    
    function joinGroup(uint groupId) public {
        require(!groups[groupId].inviteOnly || groups[groupId].roles[msg.sender] >= 1, "Group is invite-only and user does not have an invite.");
        
        groups[groupId].members[msg.sender] = true;
        groups[groupId].roles[msg.sender] = 0; // Member
    }
    
    function leaveGroup(uint groupId) public {
        require(groups[groupId].members[msg.sender], "User is not a member of the group.");
        
        groups[groupId].members[msg.sender] = false;
        groups[groupId].roles[msg.sender] = 4; // Not a member
    }
    
    function kickUser(uint groupId, address userAddress) public { // changed userId to userAddress
        

        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to kick user.");
        require(groups[groupId].members[userAddress], "User is not a member of the group.");
        
        groups[groupId].members[userAddress] = false;
        groups[groupId].roles[userAddress] = 4; // Not a member
    }
    
    function banUser(uint groupId, address userAddress) public {
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to ban user.");
        require(groups[groupId].roles[userAddress] != 4, "User is already banned from the group.");
    
        groups[groupId].members[userAddress] = false;
        groups[groupId].roles[userAddress] = 5; // Banned
    }

}
