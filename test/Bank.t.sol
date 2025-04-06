// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/Bank.sol";

contract BankTest is Test {
    Bank private bank;
    address private admin;
    address private user1;
    address private user2;
    address private user3;
    address private user4;

    function setUp() public {
        admin = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
        user3 = address(0x3);
        user4 = address(0x4);

        bank = new Bank();
    }

    function testDepositAndTopThree() public {
        vm.deal(user1, 10 ether);
        vm.deal(user2, 20 ether);
        vm.deal(user3, 30 ether);
        vm.deal(user4, 40 ether);

        vm.prank(user1);
        bank.deposit{value: 10 ether}();

        vm.prank(user2);
        bank.deposit{value: 20 ether}();

        vm.prank(user3);
        bank.deposit{value: 30 ether}();

        vm.prank(user4);
        bank.deposit{value: 40 ether}();

        address[3] memory topThree = bank.getTopThree();
        assertEq(topThree[0], user4);
        assertEq(topThree[1], user3);
        assertEq(topThree[2], user2);
    }

    function testWithdrawByAdmin() public {
        vm.deal(admin, 50 ether);
        bank.deposit{value: 50 ether}();

        uint256 initialBalance = admin.balance;

        bank.withdraw(10 ether);

        assertEq(admin.balance, initialBalance + 10 ether);
    }

    function testWithdrawByNonAdmin() public {
        vm.deal(user1, 10 ether);
        vm.prank(user1);
        vm.expectRevert(Bank.NotAdmin.selector);
        bank.withdraw(1 ether);
    }

    function testNotEnoughBalance() public {
        vm.deal(admin, 1 ether);
        bank.deposit{value: 1 ether}();

        vm.expectRevert(Bank.NotEnoughBalance.selector);
        bank.withdraw(2 ether);
    }
}