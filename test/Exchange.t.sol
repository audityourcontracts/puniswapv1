// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";

contract ExchangeTest is Test {
    Exchange exchange;
    Token token;

    function setUp() public  {
       token = new Token("Nuts", "NUTS", 18, 10 ether);
       exchange = new Exchange(address(token)); 
    }

    function testAddLiquidity(uint amount) public  {
        vm.assume(amount > 0);
        vm.assume(amount < 10 ether);
        token.approve(address(exchange), amount);
        uint256 balanceBefore = address(exchange).balance;

        exchange.addLiquidity{value: amount}(amount);
        uint256 balanceAfter = address(exchange).balance;

        assertEq(exchange.getReserve(), amount);
        assertEq(balanceAfter - balanceBefore, amount);
    }
}