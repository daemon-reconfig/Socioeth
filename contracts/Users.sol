// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;


contract Users {
    struct User {
        string username;
        address userAddress;
        address[] friends;
        uint256 lastKeyGen;
        uint256 icon;
    }

    mapping(address => User) public users;

    event NewUser(address userAddress, string username);
    event NewFriend(address userAddress, address friendAddress);
    event NewMessage(address from, address to, bytes encryptedMessage);
    event JoinGroup(address userAddress, uint256 groupId);
    event LeaveGroup(address userAddress, uint256 groupId);
    event BlockFriend(address userAddress, address friendAddress);
    event UnblockFriend(address userAddress, address friendAddress);
    event NewIcon(address userAddress, uint256 icon);

    modifier onlyExistingUser(address userAddress) {
        require(
            bytes(users[userAddress].username).length > 0,
            "User does not exist"
        );
        _;
    }

    function register(string memory username, uint256 icon) public {
        require(
            bytes(username).length > 0,
            "Username cannot be empty"
        );
        require(
            users[msg.sender].userAddress == address(0),
            "User already exists"
        );

        users[msg.sender] = User({
            username: username,
            userAddress: msg.sender,
            friends: new address[](0),
            lastKeyGen: block.timestamp,
            icon: icon
        });

        emit NewUser(msg.sender, username);
    }

    function addFriend(address friendAddress) public onlyExistingUser(friendAddress) {
        require(
            msg.sender != friendAddress,
            "You cannot add yourself as a friend"
        );
        for (uint256 i = 0; i < users[msg.sender].friends.length; i++) {
            if (users[msg.sender].friends[i] == friendAddress) {
                revert("Friend already added");
            }
        }
        users[msg.sender].friends.push(friendAddress);
        emit NewFriend(msg.sender, friendAddress);
    }

    function sendMessage(address to, bytes memory encryptedMessage) public onlyExistingUser(to) {
        emit NewMessage(msg.sender, to, encryptedMessage);
    }

    function joinGroup(uint256 groupId) public {
        emit JoinGroup(msg.sender, groupId);
    }

    function leaveGroup(uint256 groupId) public {
        emit LeaveGroup(msg.sender, groupId);
    }

    function deleteFriend(address friendAddress) public {
        for (uint256 i = 0; i < users[msg.sender].friends.length; i++) {
            if (users[msg.sender].friends[i] == friendAddress) {
                delete users[msg.sender].friends[i];
                emit BlockFriend(msg.sender, friendAddress);
                return;
            }
        }
        revert("Friend not found");
    }

    function unblockFriend(address friendAddress) public {
        for (uint256 i = 0; i < users[msg.sender].friends.length; i++) {
            if (users[msg.sender].friends[i] == friendAddress) {
                emit UnblockFriend(msg.sender, friendAddress);
                return;
            }
        }
        revert("Friend not found");
    }

    function newIcon(uint256 icon) public {
        users[msg.sender].icon = icon;
        emit NewIcon(msg.sender, icon);
    }

    function generateNewKeys() public {
        require(
            block.timestamp > users[msg.sender].lastKeyGen + 86400,
            "Cannot generate new keys yet"
        );
        users[msg.sender].lastKeyGen = block.timestamp;
        // code to generate new key pair goes here
    }
}