// SDPX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {console} from "forge-std/console.sol";
import {Test} from "forge-std/Test.sol";
import {DeployCollateral} from "../script/DeployCollateral.s.sol";
import {CollateralManager} from "../src/contracts/CollateralManager.sol";
import {BToken} from "../src/contracts/BToken.sol";
import {CollateralToken} from "../src/contracts/CollateralToken.sol";
import {BorrowToken} from "../src/contracts/BorrowToken.sol";

contract CollateralManagerTest is Test {
    CollateralManager public collateralManager;
    CollateralToken public collateralToken;
    BorrowToken public borrowToken;
    BToken public bToken;

    DeployCollateral public deployer;

    address anon1 = makeAddr("anon1");
    address anon2 = makeAddr("anon2");
    address anon3 = makeAddr("anon3");

    uint256 STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployCollateral();
        (collateralManager, collateralToken, borrowToken, bToken) = deployer
            .run();

        vm.prank(address(collateralManager));
        collateralToken.transfer(anon1, STARTING_BALANCE);
    }

    function testCollateralBalance() public {
        assertEq(collateralToken.balanceOf(anon1), STARTING_BALANCE);
    }

    function testTransferFromRevertsWithoutAllowanceForCollateralToken()
        public
    {
        vm.expectRevert();
        vm.prank(address(collateralManager));
        collateralToken.transferFrom(
            anon1,
            address(collateralToken),
            STARTING_BALANCE
        );
    }

    function testAllowanceWorksForCollateralToken() public {
        uint256 allowance = 10;
        uint256 initialManagerBalance = collateralToken.balanceOf(
            address(collateralManager)
        );

        vm.prank(address(anon1));
        collateralToken.approve(address(collateralManager), allowance);

        uint256 transferAmount = 10;

        vm.prank(address(collateralManager));
        collateralToken.transferFrom(
            anon1,
            address(collateralManager),
            transferAmount
        );

        assertEq(
            collateralToken.balanceOf(address(collateralManager)),
            initialManagerBalance + transferAmount
        );
        assertEq(
            collateralToken.balanceOf(anon1),
            STARTING_BALANCE - transferAmount
        );
    }

    function testAllowanceDecreasesAfterTransfer() public {
        uint256 allowance = 10;
        uint256 transferAmount = 5;

        vm.prank(address(anon1));
        collateralToken.approve(address(collateralManager), allowance);

        uint256 initialAllowance = collateralToken.allowance(
            anon1,
            address(collateralManager)
        );
        vm.prank(address(collateralManager));
        collateralToken.transferFrom(
            anon1,
            address(collateralManager),
            transferAmount
        );

        assertEq(
            collateralToken.allowance(anon1, address(collateralManager)),
            initialAllowance - transferAmount,
            "Allowance not updated properly after transfer"
        );
    }

    function testTransferIncreasesRecipientBalance() public {
        uint256 transferAmount = 5;
        uint256 initialRecipientBalance = collateralToken.balanceOf(anon2);

        vm.prank(address(anon1));
        collateralToken.transfer(anon2, transferAmount);

        assertEq(
            collateralToken.balanceOf(anon2),
            initialRecipientBalance + transferAmount,
            "Recipient balance not updated properly after transfer"
        );
    }

    function testTransferDecreasesSenderBalance() public {
        uint256 transferAmount = 5;
        uint256 initialSenderBalance = collateralToken.balanceOf(anon1);

        vm.prank(address(anon1));
        collateralToken.transfer(anon2, transferAmount);

        assertEq(
            collateralToken.balanceOf(anon1),
            initialSenderBalance - transferAmount,
            "Sender balance not updated properly after transfer"
        );
    }
}
