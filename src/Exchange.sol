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

    function getPrice(uint256 inputReserve, uint256 outputReserve) public pure returns (uint256) {
        require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
        return (inputReserve * 1000) / outputReserve;
    }

    function getTokenAmount(
        uint256 _ethSold) public view returns (uint256) {
            require(_ethSold > 0, "invalid input");
            uint256 tokenReserve = getReserve();
            return _getAmount(_ethSold, address(this).balance, tokenReserve);
    }

    function getEthAmount(uint256 _tokenSold) public view returns (uint256){
       require(_tokenSold> 0, "invalid input"); 
       uint256 tokenReserve = getReserve(); 
       return _getAmount(_tokenSold, tokenReserve, address(this).balance);
    }
    function _getAmount(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve) private pure returns (uint256) {
            require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
            return (inputAmount * outputReserve) / (inputReserve + inputAmount);
        }
}