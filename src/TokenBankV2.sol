// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ITokenBank.sol";
import "./IERC20.sol";

contract TokenBankV2 is ITokenBank {
    IERC20 public token;
    mapping(address => uint) public balances;

    constructor(address _token) {
        token = IERC20(_token);
    }

    event Deposited(address indexed user, uint256 amount);

    function deposit(uint _amount) public {
        require(_amount > 0, "Deposit amount must be greater than 0");
        token.transferFrom(msg.sender, address(this), _amount);
        balances[msg.sender] += _amount;
    }

    function withdraw(uint _amount) public {
        require(
            balances[msg.sender] >= _amount,
            "Insufficient balance to withdraw"
        );
        balances[msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);
    }

    function tokensReceived(address _from, uint256 _amount) external {
        require(msg.sender == address(token), 'not token');
        balances[_from] += _amount;

        emit Deposited(msg.sender, _amount);
    }
}
