// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Test.sol";
import "../src/ERC20.sol";

contract BaseERC20Test is Test {
    BaseERC20 private token;
    address private user1;
    address private user2;

    function setUp() public {
        token = new BaseERC20();
        user1 = address(0x1);
        user2 = address(0x2);
        vm.deal(user1, 1 ether);
        vm.deal(user2, 1 ether);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), 100000000 * (10 ** 18));
        assertEq(token.balanceOf(address(this)), 100000000 * (10 ** 18));
    }

    function testTransfer() public {
        uint256 amount = 1000 * (10 ** 18);
        token.transfer(user1, amount);
        assertEq(token.balanceOf(user1), amount);
        assertEq(token.balanceOf(address(this)), token.totalSupply() - amount);
    }

    function testApproveAndTransferFrom() public {
        uint256 amount = 500 * (10 ** 18);
        token.approve(user1, amount);
        vm.prank(user1);
        token.transferFrom(address(this), user2, amount);
        assertEq(token.balanceOf(user2), amount);
        assertEq(token.allowance(address(this), user1), 0);
    }

    function testTransferExceedsBalance() public {
        uint256 amount = token.totalSupply() + 1;
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        token.transfer(user1, amount);
    }

    function testTransferFromExceedsAllowance() public {
        uint256 amount = 1000 * (10 ** 18);
        token.approve(user1, amount - 1);
        vm.prank(user1);
        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        token.transferFrom(address(this), user2, amount);
    }
}