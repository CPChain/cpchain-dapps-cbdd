pragma solidity ^0.4.24;


interface IActionYieldFarming {
    /**
     * The event emitted after trigger an action
     * @param address the address should be rewarded
     * @param uint the action ID
     * @param uint256 reward amount
     */
    event ActionYieldEvent(address recipient, uint action_id, uint256 reward);

    /**
     * Yield to an action
     * @param address The address should be rewarded
     * @param uint The action of the action, definit in ../lib/Actions.sol Action
     * @return the amount of rewards
     * Emits {ActionYieldEvent}
     */
    function actionYield(address, uint) external returns (uint256);
}
