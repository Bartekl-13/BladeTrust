// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {CollateralManager} from "./CollateralManager.sol";

contract BToken is ERC20 {
    address internal underlyingAsset;

    constructor(CollateralManager collateralManager) ERC20("BToken", "BLD") {}

    

    function getThisAddress() public view returns (address) {
        return address(this);
    }
}
