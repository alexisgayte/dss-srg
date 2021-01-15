pragma solidity ^0.6.7;

import "dss-interfaces/ERC/GemAbstract.sol";

contract StaticReserve {

    // --- Auth ---
    mapping (address => uint256) public wards;
    function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
    function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
    modifier auth { require(wards[msg.sender] == 1); _; }

    // --- Lock ---
    uint private unlocked = 1;
    modifier lock() {require(unlocked == 1, 'StaticReserve/re-entrance');unlocked = 0;_;unlocked = 1;}

    // --- Events ---
    event Rely(address indexed user);
    event Deny(address indexed user);
    event Withdraw(address indexed user, address assert, address recipient, uint amount);

    constructor() public {
        wards[msg.sender] = 1;
        emit Rely(msg.sender);
    }

    // Admin method

    function withdraw(address asset_, address recipient_, uint256 amount_) external lock auth returns (uint256) {

        emit Withdraw(msg.sender, asset_, recipient_, amount_);

        require(GemAbstract(asset_).approve(recipient_, amount_), "StaticReserve/failed-approve");
        require(GemAbstract(asset_).transfer(recipient_, amount_), "StaticReserve/failed-transfer");

        return amount_;
    }

}