pragma solidity ^0.4.24;

interface IActionYieldFarmingAdmin {
    /**
     * setActionRewardEvent
     * @param owner address
     * @param uint action ID
     * @param uint256 reward per actions
     */
    event SetActionRewardEvent(address, uint, uint256);

    /**
     * setActionMaxYieldTimesEvent
     * @param owner address
     * @param uint action ID
     * @param uint max yield times
     */
    event SetActionMaxYieldTimesEvent(address, uint, uint);

    /**
     * Set the reward per actions
     * 设置行为的单次激励数量
     * @param uint action ID
     * @param uint256 rewards
     * Emits {SetActionRewardEvent}
     */
    function setActionReward(uint, uint256) external;

    /**
     * Set the max reward times per actions
     * 设置行为的总激励次数
     * @param uint action ID
     * @param uint max reward times
     * Emits {SetActionMaxYieldTimesEvent}
     */
    function setActionMaxYieldTimes(uint, uint) external;

    /**
     * Get current reward times of an action
     * 获取某行为当前已激励次数
     * @param uint action ID
     * @return times
     */
    function getCurrentYieldTimesOfAction(uint) external view returns (uint);

    /**
     * Get reward of an action
     * 获取某行为奖励一次的金额
     * @param uint action ID
     * @return reward
     */
    function getActionReward(uint) external view returns (uint256);

    /**
     * Get the max reward times of an action
     * 获取某行为最大激励次数
     * @param uint action ID
     * @return times
     */
    function getMaxYieldTimesOfAction(uint) external view returns (uint);

    /**
     * Get all yield rewards of an action now
     * 获取某行为当前发出的总激励
     * @param uint action ID
     */
    function getCurrentYieldRewardsOfAction(uint) external view returns (uint256);

    /**
     * Get all rewards of all action now
     * 获取所有行为的已激励总额
     * @return all rewards now
     */
    function getCurrentRewardsOfAllAction() external view returns (uint256);

    /**
     * Get max yield rewards of an action
     * 获取某行为可发出的总激励
     * @param uint action ID
     * @return rewards
     */
    function getMaxYieldRewardsOfAction(uint) external view returns (uint256);

    /**
     * Get max rewards of all action
     * 获取所有行为可发出的总激励
     * @return max rewards
     */
    function getMaxRewardsOfAllAction() external view returns (uint256);
}
