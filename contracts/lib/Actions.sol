pragma solidity ^0.4.24;

library Actions {
    enum Action {
        CREATE_DATA_SOURCE,
        CREATE_DATA_CHART,
        CREATE_DATA_DASHBOARD
    }

    function getID(Action a) public pure returns (uint) {
        return uint(a);
    }
}
