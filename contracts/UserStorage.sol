// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserStorage {
    enum UserType { Individual, Issuer }

    struct UserData {
        address userAddress;
        UserType userType;
        string email;
        string phoneNumber;
        string password;
        uint256 resetCode;
        uint256 resetCodeExpiry;
        string organizationName; 
        string websiteUrl; 
        string organizationType; 
    }

    mapping(address => UserData) public users;

    function individualSignUp(
        string memory _email,
        string memory _phoneNumber,
        string memory _password,
        string memory _confirmPassword
    ) public {
        signUp(UserType.Individual, _email, _phoneNumber, _password, _confirmPassword, "", "", "");
    }

    function issuerSignUp(
        string memory _organizationName,
        string memory _email,
        string memory _phoneNumber,
        string memory _password,
        string memory _confirmPassword,
        string memory _websiteUrl,
        string memory _organizationType
    ) public {
        signUp(UserType.Issuer, _email, _phoneNumber, _password, _confirmPassword, _organizationName, _websiteUrl, _organizationType);
    }

    function signUp(
        UserType _userType,
        string memory _email,
        string memory _phoneNumber,
        string memory _password,
        string memory _confirmPassword,
        string memory _organizationName,
        string memory _websiteUrl,
        string memory _organizationType
    ) internal {
        require(
            bytes(users[msg.sender].email).length == 0,
            "User already signed up"
        );
        require(bytes(_password).length > 0 && bytes(_confirmPassword).length > 0, "Password fields must not be empty");
        require(
            keccak256(bytes(_password)) == keccak256(bytes(_confirmPassword)),
            "Passwords do not match"
        );

        users[msg.sender] = UserData({
            userAddress: msg.sender,
            userType: _userType,
            email: _email,
            phoneNumber: _phoneNumber,
            password: _password,
            resetCode: 0,
            resetCodeExpiry: 0,
            organizationName: _organizationName,
            websiteUrl: _websiteUrl,
            organizationType: _organizationType
        });
    }

    function resetPasswordRequest() public {
        UserData storage user = users[msg.sender];
        require(bytes(user.email).length > 0, "User not signed up");

        uint256 seed = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        ) % 1000000;
        user.resetCode = seed;
        user.resetCodeExpiry = block.timestamp + 3600;
    }

    function signIn(string memory _email, string memory _password) public view {
        UserData memory user = getUserData(msg.sender);

        require(
            keccak256(bytes(user.email)) == keccak256(bytes(_email)),
            "Invalid email"
        );
        require(bytes(user.email).length > 0, "User not signed up");
        require(
            keccak256(bytes(user.password)) == keccak256(bytes(_password)),
            "Invalid password"
        );
    }

    function resetPassword(uint256 _resetCode, string memory _newPassword) public {
        UserData storage user = users[msg.sender];
        require(user.resetCode == _resetCode, "Invalid reset code");
        require(user.resetCodeExpiry >= block.timestamp, "Reset code expired");

        user.password = _newPassword;
        user.resetCode = 0; 
        user.resetCodeExpiry = 0; 
    }

    function getResetCode() public view returns (uint256) {
        return users[msg.sender].resetCode;
    }

    function getUserData(address _userAddress) public view returns (UserData memory) {
        return users[_userAddress];
    }
}
