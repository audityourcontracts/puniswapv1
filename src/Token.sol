// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "solmate/tokens/ERC20.sol";

contract Token is ERC20 {
    constructor(
            string memory name,
            string memory symbol,
            uint8 decimals,
            uint256 initialSupply
    ) ERC20(name, symbol, decimals) {
            _mint(msg.sender, initialSupply);
    }

    function mint(address to, uint256 amount) external virtual {
        totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }
}
