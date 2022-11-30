// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";

contract ExchangeTest is Test {
    Exchange exchange;
    Token token;

    function setUp() public  {
       token = new Token("Nuts", "NUTS", 18, 2000);
       exchange = new Exchange(address(token)); 
       vm.deal(address(this), 1000 ether);
    }

    function testInitialBalances() public {
        assertEq(token.balanceOf(address(this)), 2000);
        assertEq(address(this).balance, 1000 ether);
    }

    function testAddLiquidity(uint amount) public  {
        vm.assume(amount > 0);
        vm.assume(amount < 2000 );
        token.approve(address(exchange), amount);
        uint256 balanceBefore = address(exchange).balance;

        exchange.addLiquidity{value: amount}(amount);
        uint256 balanceAfter = address(exchange).balance;

        assertEq(exchange.getReserve(), amount);
        assertEq(balanceAfter - balanceBefore, amount);
    }

        function addLiquidity(uint256 _etherAmount, uint256 _tokenAmount) public {
            token.approve(address(exchange), _tokenAmount);
            exchange.addLiquidity{value: _etherAmount}(_tokenAmount);
            
        }
    function testPriceisRight() public  {
        addLiquidity(1000, 2000); 

        uint256 priceEthToToken = exchange.getPrice(address(exchange).balance, token.balanceOf(address(exchange)));
        assertEq(priceEthToToken, 500);

        uint256 priceTokenToEth = exchange.getPrice(token.balanceOf(address(exchange)), address(exchange).balance);
        assertEq(priceTokenToEth, 2000);
    }

    function testGetTokenAmount() public  {
        uint256 tokenAmount = 2000;
        uint256 etherAmount = 1000;
        addLiquidity(etherAmount, tokenAmount);

        uint256 tokensOut = exchange.getTokenAmount(1 ether);
        assertEq(tokensOut, 1999);
    }

    function testGetEthAmount() public  {
        uint256 tokenAmount = 2000;
        uint256 etherAmount = 1000;
        addLiquidity(etherAmount, tokenAmount);

        uint256 ethOut = exchange.getEthAmount(200);
        assertEq(ethOut, 90);
    }
}