pragma solidity ^0.8.13;

import "forge-std/interfaces/IERC20.sol";

contract Exchange {
    address public tokenAddress;

    error TokenZeroAddress();

    constructor(address _token) {
        require(_token != address(0), "token cannot be zero address");
        tokenAddress = _token;
    }

    function addLiquidity(uint256 _tokenAmount) public payable {
        IERC20 token = IERC20(tokenAddress);
        token.transferFrom(msg.sender, address(this), _tokenAmount);
    }

    function getReserve() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
}