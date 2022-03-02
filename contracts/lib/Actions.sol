pragma solidity ^0.4.24;

library Actions {
    /**
     * 单方需激励行为与双方需激励行为
     * unilateral, bilateral
     */
    enum Type {
        UNILATERAL,
        BILATERAL
    }
    enum Action {
        CREATE_DATA_SOURCE,
        CREATE_DATA_CHART,
        CREATE_DATA_DASHBOARD,
        UPDATE_DATA_SOURCE,
        UPDATE_DATA_CHART,
        UPDATE_DATA_DASHBOARD,
        DELETE_DATA_SOURCE,
        DELETE_DATA_CHART,
        DELETE_DATA_DASHBOARD,
        LIKE_DATA_SOURCE,
        LIKE_DATA_CHART,
        LIKE_DATA_DASHBOARD,
        CANCEL_LIKE_DATA_SOURCE,
        CANCEL_LIKE_DATA_CHART,
        CANCEL_LIKE_DATADASHBOARD,
        DISLIKE_DATA_SOURCE,
        DISLIKE_DATA_CHART,
        DISLIKE_DATA_DASHBOARD,
        CANCEL_DISLIKE_DATA_SOURCE,
        CANCEL_DISLIKE_DATA_CHART,
        CANCEL_DISLIKE_DATA_DASHBOARD,
        ADD_COMMENT_ON_DATA_SOURCE,
        ADD_COMMENT_ON_DATA_CHART,
        ADD_COMMENT_ON_DATA_DASHBOARD,
        UPDATE_COMMENT,
        DELETE_COMMENT,
        REPLY_COMMENT,
        LIKE_COMMENT,
        CANCEL_LIKE_COMMENT,
        DISLIKE_COMMENT,
        CANCEL_DISLIKE_COMMENT,
        ADD_TAG_FOR_DATA_SOURCE,
        REMOVE_TAG_FOR_DATA_SOURCE,
        ADD_TAG_FOR_DATA_CHART,
        REMOVE_TAG_FOR_DATA_CHART,
        ADD_TAG_FOR_DATA_DASHBOARD,
        REMOVE_TAG_FOR_DATA_DASHBOARD
    }

    function getID(Action a) public pure returns (uint) {
        return uint(a);
    }
}
