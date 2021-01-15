pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./DssSrg.sol";

contract DssSrgTest is DSTest {
    DssSrg srg;

    function setUp() public {
        srg = new DssSrg();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
