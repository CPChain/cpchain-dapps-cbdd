pragma solidity ^0.4.24;

interface IDataDashboardManager {

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
     * Create data dashboard
     * Emits {CreateDataDashboardEvent}
     * @param name unique name
     * @param charts charts
     * @param desc description
     * @param data params
     * @return sequence ID
     */
    function createDataDashboard(address sender, string name, uint[] charts, string desc, string data) external returns (uint);

    /**
     * Update name
     * Emits {UpdateDataDashboardEvent}
     * @param id ID
     * @param name name
     * @param desc description
     * @param data params
     * @return ID
     */
    function updateDataDashboard(address sender, uint id, string name, uint[] charts, string desc, string data) external;
    
    /**
     * Delete data dashboard
     * Emits {DeleteDataDashboardEvent}
     * @param id ID
     * @return ID
     */
    function deleteDataDashboard(address sender, uint id) external;


     /**
     * Like a data dashboard
     * Emits {LikeDataDashboard}
     * @param dashboard_id dashboard ID
     */
    function likeDataDashboard(address sender, uint dashboard_id, bool liked) external;

    // views
    function getDataDashboardOwner(uint id) external view returns (address);

    function getDataDashboard(uint id) external view returns (uint dashboard_id, uint[] charts, address sender, string name, string desc,
        string data);
}
