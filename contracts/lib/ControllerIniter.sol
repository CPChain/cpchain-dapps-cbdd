pragma solidity ^0.4.24;

import "../interfaces/IControllerIniter.sol";

contract ControllerIniter is IControllerIniter {
    bool inited = false;
    address controller;

    modifier onlyInited() { require(inited, "Only inited controller"); _;}
    modifier onlyController() { require(msg.sender == controller, "Only controller"); _; }

    /**
     * Whether inited the controller
     */
    function isInitedController() external view returns (bool) {
        return inited;
    }

    /**
     * Init the controller
     */
    function initController(address c) external returns (bool) {
        require(!inited, "Contract can only be inited once");
        controller = c;
        return true;
    }
}
