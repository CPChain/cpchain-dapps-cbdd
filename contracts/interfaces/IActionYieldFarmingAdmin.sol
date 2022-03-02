pragma solidity ^0.4.24;

interface IActionYieldFarmingAdmin {
    /**
     * setActionRewardEvent
     * @param owner address
     * @param action_id action ID
     * @param reward reward per actions
     */
    event SetActionRewardEvent(address owner, uint action_id, uint256 reward);

    /**
     * setActionMaxYieldTimesEvent
     * @param owner address
     * @param action_id action ID
     * @param max_times max yield times
     */
    event SetActionMaxYieldTimesEvent(address owner, uint action_id, uint max_times);

    /**
     * Set the reward per actions
     * 设置行为的单次激励数量
     * Emits {SetActionRewardEvent}
     * @param action_id action ID
     * @param reward rewards
     */
    function setActionReward(uint action_id, uint256 reward) external;

    /**
     * Set the max reward times per actions
     * 设置行为的总激励次数
     * Emits {SetActionMaxYieldTimesEvent}
     * @param action_id action ID
     * @param max_times max reward times
     */
    function setActionMaxYieldTimes(uint action_id, uint max_times) external;

    /**
     * Get current reward times of an action
     * 获取某行为当前已激励次数
     * @param action_id action ID
     * @return times
     */
    function getCurrentYieldTimesOfAction(uint action_id) external view returns (uint);

    /**
     * Get reward of an action
     * 获取某行为奖励一次的金额
     * @param action_id action ID
     * @return reward
     */
    function getActionReward(uint action_id) external view returns (uint256);

    /**
     * Get the max reward times of an action
     * 获取某行为最大激励次数
     * @param action_id action ID
     * @return times
     */
    function getMaxYieldTimesOfAction(uint action_id) external view returns (uint);

    /**
     * Get all yield rewards of an action now
     * 获取某行为当前发出的总激励
     * @param action_id action ID
     */
    function getCurrentYieldRewardsOfAction(uint action_id) external view returns (uint256);

    /**
     * Get all rewards of all action now
     * 获取所有行为的已激励总额
     * @return all rewards now
     */
    function getCurrentRewardsOfAllAction() external view returns (uint256);

    /**
     * Get max yield rewards of an action
     * 获取某行为可发出的总激励
     * @param action_id action ID
     * @return rewards
     */
    function getMaxYieldRewardsOfAction(uint action_id) external view returns (uint256);

    /**
     * Get max rewards of all action
     * 获取所有行为可发出的总激励
     * @return max rewards
     */
    function getMaxRewardsOfAllAction() external view returns (uint256);
}
