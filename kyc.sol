pragma solidity ^0.8.0;

contract KYCVerification {
    address public admin;

    struct User {
        string name;
        bool isVerified;
    }

    mapping(address => User) public users;

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function registerUser(address userAddress, string memory name) public onlyAdmin {
        users[userAddress] = User(name, false);
    }

    function verifyUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length > 0, "User not registered.");
        users[userAddress].isVerified = true;
    }

    function isUserVerified(address userAddress) public view returns (bool) {
        return users[userAddress].isVerified;
    }
}
