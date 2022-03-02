pragma solidity ^0.4.24;


interface IActionYieldFarming {
    /**
     * The event emitted after trigger an action
     * @param recipient the address should be rewarded
     * @param action_id the action ID
     * @param reward reward amount
     */
    event ActionYieldEvent(address recipient, uint action_id, uint256 reward);

    /**
     * Yield to an action
     * Emits {ActionYieldEvent}
     * @param recipient The address should be rewarded
     * @param action_id The action of the action, definit in ../lib/Actions.sol Action
     * @return the amount of rewards
     */
    function actionYield(address recipient, uint action_id) external returns (uint256);
}
