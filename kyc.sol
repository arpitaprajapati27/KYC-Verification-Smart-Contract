pragma solidity ^0.8.0;

contract KYCVerification {
    address public admin;

    struct User {
        string name;
        bool isVerified;
    }

    mapping(address => User) public users;

    event UserRegistered(address indexed userAddress, string name);
    event UserVerified(address indexed userAddress);
    event UserDeactivated(address indexed userAddress);
    event UserUpdated(address indexed userAddress, string newName);
    event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    function registerUser(address userAddress, string memory name) public onlyAdmin {
        users[userAddress] = User(name, false);
        emit UserRegistered(userAddress, name);
    }

    function verifyUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length > 0, "User not registered.");
        users[userAddress].isVerified = true;
        emit UserVerified(userAddress);
    }

    function deactivateUser(address userAddress) public onlyAdmin {
        require(bytes(users[userAddress].name).length > 0, "User not registered.");
        users[userAddress].isVerified = false;
        emit UserDeactivated(userAddress);
    }

    function updateUserName(string memory newName) public {
        require(bytes(users[msg.sender].name).length > 0, "User not registered.");
        users[msg.sender].name = newName;
        emit UserUpdated(msg.sender, newName);
    }

    function isUserVerified(address userAddress) public view returns (bool) {
        return users[userAddress].isVerified;
    }

    function getUser(address userAddress) public view returns (string memory name, bool isVerified) {
        User memory user = users[userAddress];
        return (user.name, user.isVerified);
    }

    function transferAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "Invalid address.");
        emit AdminTransferred(admin, newAdmin);
        admin = newAdmin;
    }
}
