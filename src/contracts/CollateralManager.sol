// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

contract CollateralManager {
    struct ReserveData {
        address lendToken;
        address borrowToken;
        address stakeToken;
        uint256 totalCollateral;
        address bladeTokenAddress;
    }

    ReserveData public reserveData;

    // How much collateral a user has
    mapping(address => uint256) public collaterals;

    function deposit(uint256 amount) external {
        // ...
    }

    function withdraw(uint256 amount) external {
        // ...
    }

    function depositReserveData(
        address lendToken,
        address borrowToken,
        address stakeToken
    ) external {
        reserveData.lendToken = lendToken;
        reserveData.borrowToken = borrowToken;
        reserveData.stakeToken = stakeToken;
    }

    function getThisAddress() public view returns (address) {
        return address(this);
    }
}
