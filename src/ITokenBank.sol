// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ITokenBank {
    function tokensReceived(address from, uint256 value) external;
}