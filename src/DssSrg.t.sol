pragma solidity ^0.6.7;

import "ds-test/test.sol";
import "ds-token/token.sol";
import {Dai} from "dss/dai.sol";

import "./DssSrg.sol";

contract Governance {

    StaticReserve reserve;

    constructor (StaticReserve reserve_) public {
        reserve = reserve_;
    }
    function withdraw(address asset_, address recipient_, uint amount_) public {
        reserve.withdraw(asset_, recipient_, amount_);
    }

}

contract DssSrgTest is DSTest {
    address me;

    DSToken token;
    Dai dai;

    StaticReserve srg;
    Governance gov;

    function setUp() public {

        me = address(this);

        token = new DSToken("MKR");
        token.mint(10000 );

        dai = new Dai(0);

        srg = new StaticReserve();

        gov = new Governance(srg);
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }

    function test_withdraw_token() public {

        assertEq(token.balanceOf(address(srg)), 0);
        assertEq(token.balanceOf(address(me)), 10000);

        token.transfer(address(srg), 10000);

        assertEq(token.balanceOf(address(srg)), 10000);
        assertEq(token.balanceOf(address(me)), 0);

        srg.withdraw(address(token), address(me), 10000);

        assertEq(token.balanceOf(address(srg)), 0);
        assertEq(token.balanceOf(address(me)), 10000);
    }

    function test_withdraw_dai() public {
        dai.mint(me, 10000);

        assertEq(dai.balanceOf(address(srg)), 0);
        assertEq(dai.balanceOf(address(me)), 10000);

        dai.transfer(address(srg), 10000);

        assertEq(dai.balanceOf(address(srg)), 10000);
        assertEq(dai.balanceOf(address(me)), 0);

        srg.withdraw(address(dai), address(me), 10000);

        assertEq(dai.balanceOf(address(srg)), 0);
        assertEq(dai.balanceOf(address(me)), 10000);
    }

    function testFail_withdraw_no_auth() public {

        srg.deny(me);
        token.transfer(address(srg), 10000);

        assertEq(token.balanceOf(address(srg)), 10000);
        assertEq(token.balanceOf(address(me)), 0);

        srg.withdraw(address(token), address(me), 10000);
    }

    function test_withdraw_token_after_re_auth() public {
        srg.rely(address(gov));
        srg.deny(me);

        assertEq(token.balanceOf(address(srg)), 0);
        assertEq(token.balanceOf(address(gov)), 0);
        assertEq(token.balanceOf(address(me)), 10000);

        token.transfer(address(srg), 10000);

        assertEq(token.balanceOf(address(srg)), 10000);
        assertEq(token.balanceOf(address(gov)), 0);
        assertEq(token.balanceOf(address(me)), 0);

        gov.withdraw(address(token), address(me), 10000);

        assertEq(token.balanceOf(address(srg)), 0);
        assertEq(token.balanceOf(address(gov)), 0);
        assertEq(token.balanceOf(address(me)), 10000);
    }
}
