pragma solidity ^0.4.24;

interface IControllerIniter {
    /**
     * Whether inited the controller
     */
    function isInitedController() external view returns (bool);

    /**
     * Init the controller
     */
    function initController(address) external returns (bool);
}
