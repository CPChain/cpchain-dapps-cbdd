pragma solidity ^0.4.24;


interface IActionYieldFarming {
    /**
     * The event emitted after trigger an action
     * @param recipient1 the address should be rewarded
     * @param recipient2 The address should be rewarded if this action is a BILATERAL action
     * @param action_id the action ID
     * @param reward reward amount
     */
    event ActionYieldEvent(address recipient1, address recipient2, uint action_id, uint256 reward);

    /**
     * Yield to an action
     * 如果是单边行为，则 recipient2 会被忽略；如果是双边行为，则奖励双方
     * 双边行为奖励保持一致，这是体现双赢策略，否则主动方可能因为觉得“吃亏”不再主动
     * Emits {ActionYieldEvent}
     * @param recipient1 The address should be rewarded
     * @param recipient2 The address should be rewarded if this action is a BILATERAL action
     * @param action_id The action of the action, definit in ../lib/Actions.sol Action
     * @return the amount of rewards
     */
    function actionYield(address recipient1, address recipient2, uint action_id) external returns (uint256);
}
