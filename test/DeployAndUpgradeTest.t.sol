// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("owner");
    address public proxy;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.run();
    }

    function testProxyStartsAsBoxV1() public view {
        uint256 expectedValue = 1;
        assertEq(expectedValue,BoxV1(proxy).version());
    }

    function testUpgrades() public {
        BoxV2 box2 = new BoxV2();
        upgrader.upgradeBox(proxy,address(box2));

        uint256 expectedValue = 2;
        assertEq(expectedValue,BoxV2(proxy).version());

        BoxV2(proxy).setNumber(7);
        assertEq(BoxV2(proxy).getNumber(),7);
    }
}