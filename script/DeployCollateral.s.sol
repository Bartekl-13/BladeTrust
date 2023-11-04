// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {BToken} from "../src/contracts/BToken.sol";
import {CollateralToken} from "../src/contracts/CollateralToken.sol";
import {BorrowToken} from "../src/contracts/BorrowToken.sol";
import {CollateralManager} from "../src/contracts/CollateralManager.sol";

contract DeployCollateral is Script {
    uint256 private immutable INITIAL_SUPPLY = 1000000 ether;

    function run()
        external
        returns (CollateralManager, CollateralToken, BorrowToken, BToken)
    {
        vm.startBroadcast();
        CollateralManager collateralManager = new CollateralManager();

        CollateralToken col = new CollateralToken(
            collateralManager,
            INITIAL_SUPPLY
        );
        BorrowToken bor = new BorrowToken(collateralManager, INITIAL_SUPPLY);

        BToken b = new BToken(collateralManager);

        collateralManager.depositReserveData(
            col.getThisAddress(),
            bor.getThisAddress(),
            b.getThisAddress()
        );

        vm.stopBroadcast();
        return (collateralManager, col, bor, b);
    }
}
