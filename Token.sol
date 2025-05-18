// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/// @title Chainlink Bootcamp Token
/// @notice Simple ERC20 token with custom decimals and minting controlled by the owner
contract Token is ERC20, Ownable {
    uint8 private constant CUSTOM_DECIMALS = 2;

    constructor() ERC20("Chainlink Bootcamp ES Token", "CBT") {}

    /// @notice Override decimals to return the custom value of 2
    function decimals() public pure override returns (uint8) {
        return CUSTOM_DECIMALS;
    }

    /// @notice Mint new tokens. Only the owner can call this function
    /// @param account Address to receive the minted tokens
    /// @param amount Amount of tokens to mint
    /// @return Success flag
    function mint(address account, uint256 amount) external onlyOwner returns (bool) {
        _mint(account, amount);
        return true;
    }
}
