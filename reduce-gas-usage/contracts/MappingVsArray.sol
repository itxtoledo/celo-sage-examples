// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

contract MappingVsArrayBad {
    address[] private allowedUsers;

    function findIndex(address user) private view returns (int256) {
        for (uint256 i = 0; i < allowedUsers.length; i++) {
            if (allowedUsers[i] == user) {
                return int256(i);
            }
        }

        return -1;
    }

    function allowUser(address user) public {
        if (findIndex(user) == -1) {
            allowedUsers.push(user);
        }
    }

    // 43780 gas
    function disallowUser(address user) public {
        int256 index = findIndex(user);
        if (index != -1) {
            allowedUsers[uint256(index)] = allowedUsers[
                allowedUsers.length - 1
            ];
            allowedUsers.pop();
        }
    }

    function isAllowed(address user) public view returns (bool) {
        return findIndex(user) > -1;
    }
}

contract MappingVsArrayGood {
    mapping(address => bool) private allowedUsers;

    function allowUser(address user) public {
        allowedUsers[user] = true;
    }

    // 27082 gas
    function disallowUser(address user) public {
        allowedUsers[user] = false;
    }

    function isAllowed(address user) public view returns (bool) {
        return allowedUsers[user];
    }
}
