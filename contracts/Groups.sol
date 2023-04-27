// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

contract Groups {
    struct Group {
        uint id;
        string name;
        uint owner;
        mapping(uint => bool) admins;
        mapping(uint => bool) members;
        mapping(address => uint) roles;
        bytes32 groupKey;
        bool inviteOnly;
    }
    
    mapping(uint => Group) public groups;
    uint public groupIdCounter;
    
    mapping(address => uint) public userReputation;
    uint public reputationThreshold = 100;
    
    function createGroup(string memory name, bool inviteOnly) public {
        require(userReputation[(msg.sender)] >= reputationThreshold, "Not enough reputation points to create group.");
        
        Group storage newGroup = groups[groupIdCounter];
        newGroup.id = groupIdCounter;
        newGroup.name = name;
        newGroup.owner = uint256(msg.sender);
        newGroup.admins[msg.sender] = true;
        newGroup.roles[msg.sender] = 2; // Owner
        newGroup.groupKey = keccak256(abi.encodePacked(name, block.timestamp, msg.sender));
        newGroup.inviteOnly = inviteOnly;
        
        groupIdCounter++;
    }
    
    function addAdmin(uint groupId, uint userId) public {
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to add admin.");
        require(groups[groupId].members[userId], "User is not a member of the group.");
        
        groups[groupId].admins[userId] = true;
        groups[groupId].roles[userId] = 1; // Admin
    }
    
    function removeAdmin(uint groupId, uint userId) public {
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to remove admin.");
        require(groups[groupId].admins[userId], "User is not an admin of the group.");
        
        groups[groupId].admins[userId] = false;
        groups[groupId].roles[userId] = 0; // Member
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
    
    function kickUser(uint groupId, uint userId) public {
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to kick user.");
        require(groups[groupId].members[userId], "User is not a member of the group.");
        userId=uint(userId);
        groups[groupId].members[userId] = false;
        groups[groupId].roles[userId] = 4; // Not a member
    }
    
    function banUser(uint groupId, uint userId) public {
        require(groups[groupId].roles[msg.sender] >= 2, "Not authorized to ban user.");
        require(groups[groupId].members[userId], "User is not a member of the group.");
        
        groups[groupId].members[userId] = false;
        groups[groupId].roles[userId]=5;
    }
}
