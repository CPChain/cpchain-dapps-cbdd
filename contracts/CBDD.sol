pragma solidity ^0.4.24;

import "./lib/MyERC20.sol";
import "./interfaces/IActionYieldFarming.sol";
import "./interfaces/IActionYieldFarmingAdmin.sol";
import "./lib/Actions.sol";

contract CBDD is MyERC20, IActionYieldFarming, IActionYieldFarmingAdmin {

    struct ActionReward {
        Actions.Action action;
        uint256 reward;
        uint max_times;
        uint current_reward_times;
        uint256 current_rewards;
    }

    mapping(uint => ActionReward) private action_rewards;
    uint[] public actions;

    constructor() public MyERC20("CPChain Big Data Dashboard", "CPC", uint8(18)) {
        _init_actions_reward();
    }

    function _init_actions_reward() private {
        uint256 reward = 1 * 10 ** uint256(decimals());
        uint max_times = 10000;
        _add_action_reward(Actions.Action.CREATE_DATA_SOURCE, 2 * reward, max_times);
        _add_action_reward(Actions.Action.CREATE_DATA_CHART, 2 * reward, max_times);
        _add_action_reward(Actions.Action.CREATE_DATA_DASHBOARD, 2 * reward, max_times);
        _add_action_reward(Actions.Action.UPDATE_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.UPDATE_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.UPDATE_DATA_DASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.DELETE_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.DELETE_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.DELETE_DATA_DASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.LIKE_DATA_SOURCE, reward, 10 * max_times);
        _add_action_reward(Actions.Action.LIKE_DATA_CHART, reward, 10 * max_times);
        _add_action_reward(Actions.Action.LIKE_DATA_DASHBOARD, reward, 10 * max_times);
        _add_action_reward(Actions.Action.CANCEL_LIKE_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_LIKE_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_LIKE_DATADASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.DISLIKE_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.DISLIKE_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.DISLIKE_DATA_DASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_DISLIKE_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_DISLIKE_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_DISLIKE_DATA_DASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.ADD_COMMENT_ON_DATA_SOURCE, 2 * reward, 5 * max_times);
        _add_action_reward(Actions.Action.ADD_COMMENT_ON_DATA_CHART, 2 * reward, 5 * max_times);
        _add_action_reward(Actions.Action.ADD_COMMENT_ON_DATA_DASHBOARD, 2 * reward, 5 * max_times);
        _add_action_reward(Actions.Action.UPDATE_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.DELETE_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.REPLY_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.LIKE_COMMENT, reward, 50 * max_times);
        _add_action_reward(Actions.Action.CANCEL_LIKE_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.DISLIKE_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.CANCEL_DISLIKE_COMMENT, 0, 0);
        _add_action_reward(Actions.Action.ADD_TAG_FOR_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.REMOVE_TAG_FOR_DATA_SOURCE, 0, 0);
        _add_action_reward(Actions.Action.ADD_TAG_FOR_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.REMOVE_TAG_FOR_DATA_CHART, 0, 0);
        _add_action_reward(Actions.Action.ADD_TAG_FOR_DATA_DASHBOARD, 0, 0);
        _add_action_reward(Actions.Action.REMOVE_TAG_FOR_DATA_DASHBOARD, 0, 0);
    }

    function _add_action_reward(Actions.Action action, uint256 reward, uint max_times) private {
        action_rewards[uint(action)] = ActionReward({
            action: action,
            reward: reward,
            max_times: max_times,
            current_reward_times: 0,
            current_rewards: 0
        });
        actions.push(uint(action));
    }
    
    // Mint CBDD by controller contract (only can be called by controller contract)
    function actionYield(address recipient, uint action_id) external returns (uint256) {
        return 0;
    }

    function setActionReward(uint action_id, uint256 reward) external {

    }

    function setActionMaxYieldTimes(uint action_id, uint max_times) external {

    }

    function getCurrentYieldTimesOfAction(uint action_id) external view returns (uint) {
        return 0;
    }

    function getActionReward(uint action_id) external view returns (uint256) {
        return 0;
    }

    function getMaxYieldTimesOfAction(uint action_id) external view returns (uint) {
        return 0;
    }

    function getCurrentYieldRewardsOfAction(uint action_id) external view returns (uint256) {
        return 0;
    }

    function getCurrentRewardsOfAllAction() external view returns (uint256) {
        return 0;
    }

    function getType(uint a) public pure returns (uint) {
        if (a == uint(Actions.Action.LIKE_DATA_SOURCE) || a == uint(Actions.Action.LIKE_DATA_CHART) ||
            a == uint(Actions.Action.LIKE_DATA_DASHBOARD) || a == uint(Actions.Action.LIKE_COMMENT) ||
            a == uint(Actions.Action.ADD_COMMENT_ON_DATA_SOURCE) || a == uint(Actions.Action.ADD_COMMENT_ON_DATA_CHART) ||
            a == uint(Actions.Action.ADD_COMMENT_ON_DATA_DASHBOARD)) {
            return uint(Actions.Type.BILATERAL);
        }
        return uint(Actions.Type.UNILATERAL);
    }

    function getMaxYieldRewardsOfAction(uint action_id) public view returns (uint256) {
        uint t = getType(action_id);
        uint times = 1;
        if (t == uint(Actions.Type.BILATERAL)) {
            times = 2;
        }
        return times * (action_rewards[action_id].max_times - action_rewards[action_id].current_reward_times) * action_rewards[action_id].reward
                + action_rewards[action_id].current_rewards;
    }

    function getMaxRewardsOfAllAction() external view returns (uint256) {
        // iterator all actions
        uint256 total = 0;
        for(uint i = 0; i < actions.length; i++) {
            total += getMaxYieldRewardsOfAction(i);
        }
        return total;
    }
}
