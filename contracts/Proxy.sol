// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address private implementation;
    address private owner;

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this");
        _;
    }

    receive() external payable {
        // Handle received ether here if needed
    }

    fallback() external payable {
        address _impl = implementation;
        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)
            let size := returndatasize()
            returndatacopy(ptr, 0, size)

            switch result
            case 0 {
                revert(ptr, size)
            }
            default {
                return(ptr, size)
            }
        }
    }

    function changeImplementation(address _newImplementation) public onlyOwner {
        implementation = _newImplementation;
    }
}
