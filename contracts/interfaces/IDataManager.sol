pragma solidity ^0.4.24;

interface IDataManager {

    /**
     * Triggered when user create a new data dashboard
     * @param dashboard_id dashboard ID
     * @param sender address
     * @param name unique name
     * @param charts id of the data source
     * @param desc description
     * @param data params
     */
    event CreateDataDashboardEvent(uint dashboard_id, address sender, string name,
        uint[] charts, string desc, string data);

    /**
     * Triggered when user update a data dashboard
     * @param dashboard_id dashboard ID
     * @param name unique name
     * @param charts id of the data source
     * @param desc description
     * @param data params
     */
    event UpdateDataDashboardEvent(uint dashboard_id, string name, uint[] charts,
        string desc, string data);

    /**
     * Triggered when user delete a data dashboard
     * @param dashboard_id dashboard ID
     */
    event DeleteDataDashboardEvent(uint dashboard_id);

    /**
     * @param sender sender
     * @param dashboard_id dashboard ID
     */
    event LikeDataDashboardEvent(address sender, uint dashboard_id);

    /**
     * @param sender sender
     * @param dashboard_id dashboard ID
     */
    event CancelLikeDataDashboardEvent(address sender, uint dashboard_id);

    /**
     * @param sender sender
     * @param dashboard_id dashboard ID
     */
    event DislikeDataDashboardEvent(address sender, uint dashboard_id);

    /**
     * @param sender sender
     * @param dashboard_id dashboard ID
     */
    event CancelDislikeDataDashboardEvent(address sender, uint dashboard_id);

    /**
     * @param dashboard_id dashboard ID
     */
    event EnableDataDashboardEvent(uint dashboard_id);

    /**
     * @param dashboard_id dashboard ID
     */
    event DisableDataDashboardEvent(uint dashboard_id);

    /**
     * @param version version
     * @param contract_addr contract address
     */
    event RegisterDataDashboardValidatorEvent(uint version, address contract_addr);

    /**
     * Create data dashboard
     * Emits {CreateDataDashboardEvent}
     * @param name unique name
     * @param charts charts
     * @param desc description
     * @param data params
     * @return sequence ID
     */
    function createDataDashboard(string name, uint[] charts, string desc, string data) external returns (uint);

    /**
     * Update name
     * Emits {UpdateDataDashboardEvent}
     * @param id ID
     * @param name name
     * @return ID
     */
    function updateNameOfDataDashboard(uint id, string name) external returns (uint);

    /**
     * Update description
     * Emits {UpdateDataDashboardEvent}
     * @param id ID
     * @param desc ddescription
     * @return ID
     */
    function updateDesciptionOfDataDashboard(uint id, string desc) external returns (uint);

    /**
     * Update charts
     * Emits {UpdateDataDashboardEvent}
     * @param id ID
     * @param charts charts list
     * @return ID
     */
    function updateChartsOfDataDashboard(uint id, uint[] charts) external returns (uint);

    /**
     * Update data(params)
     * Emits {UpdateDataDashboardEvent}
     * @param id ID
     * @param data data
     * @return ID
     */
    function updateDataOfDataDashboard(uint id, string data) external returns (uint);

    /**
     * Like a data dashboard
     * Emits {LikeDataDashboard}
     * @param dashboard_id dashboard ID
     */
    function likeDataDashboard(uint dashboard_id) external;

    /**
     * Cancel like a data dashboard
     * Emits {CancelLikeDataDashboard}
     * @param dashboard_id dashboard ID
     */
    function cancelLikeDataDataboard(uint dashboard_id) external;

    /**
     * Dislike a data dashboard
     * Emits {DislikeDataDashboard}
     * @param dashboard_id dashboard ID
     */
    function dislikeDataDashboard(uint dashboard_id) external;

    /**
     * Cancel dislike a data dashboard
     * Emits {CancelDislikeDataDashboard}
     * @param dashboard_id dashboard ID
     */
    function cancelDislikeDataDataboard(uint dashboard_id) external;

    /**
     * Enable a data dashboard
     * Emits {EnableDataDashboardEvent}
     * @param id ID
     */
    function enableDataDashboard(uint id) external;

    /**
     * Disable a data dashboard
     * Emits {DisableDataDashboardEvent}
     * @param id ID
     */
    function disableDataDashboard(uint id) external;

    /**
     * Register the validator contract address
     * Emits {RegisterDataDashboardValidatorEvent}
     * @param version version
     * @param contract_address contract address
     */
    function registerDataDashboardValidator(uint version, address contract_address) external;
}
