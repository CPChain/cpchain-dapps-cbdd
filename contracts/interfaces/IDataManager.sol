pragma solidity ^0.4.24;

interface IDataManager {

    /**
     * Triggered when user create a new data chart
     * @param chart_id chart ID
     * @param sender address
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param chart_type type
     * @param data params
     */
    event CreateDataChartEvent(uint chart_id, address sender, string name, uint source_id,
        string desc, string chart_type, string data);

    /**
     * Triggered when user update a data chart
     * @param chart_id chart ID
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param chart_type type
     * @param data params
     */
    event UpdateDataChartEvent(uint chart_id, string name, uint source_id, string desc,
        string chart_type, string data);

    /**
     * Triggered when user delete a data chart
     * @param chart_id chart ID
     */
    event DeleteDataChartEvent(uint chart_id);

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
     * @param chart_id chart ID
     */
    event LikeDataChartEvent(address sender, uint chart_id);

    /**
     * @param sender sender
     * @param chart_id chart ID
     */
    event CancelLikeDataChartEvent(address sender, uint chart_id);

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
     * @param chart_id chart ID
     */
    event DislikeDataChartEvent(address sender, uint chart_id);

    /**
     * @param sender sender
     * @param chart_id chart ID
     */
    event CancelDislikeDataChartEvent(address sender, uint chart_id);

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
     * Create data chart
     * Emits {CreateDataChartEvent}
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param chart_type type
     * @param data params
     * @return sequence ID
     */
    function createDataChart(string name, uint source_id, string desc, string chart_type, string data) external returns (uint);

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
     * Emits {UpdateDataChartEvent} 
     * @param id ID
     * @param name name
     * @return ID
     */
    function updateNameOfDataChart(uint id, string name) external returns (uint);

    /**
     * Update description
     * Emits {UpdateDataChartEvent} 
     * @param id ID
     * @param desc description
     * @return ID
     */
    function updateDescOfDataChart(uint id, string desc) external returns (uint);

    /**
     * Update source ID
     * Emits {UpdateDataChartEvent} 
     * @param id ID
     * @param source_id data source ID
     * @return ID
     */
    function updateSourceIDOfDataChart(uint id, uint source_id) external returns (uint);

    /**
     * Update type
     * Emits {UpdateDataChartEvent}
     * @param id ID
     * @param chart_type chart type
     * @return ID
     */
    function updateTypeOfDataChart(uint id, string chart_type) external returns (uint);

    /**
     * Update data(params)
     * Emits {UpdateDataChartEvent}
     * @param id ID
     * @param data data
     * @return ID
     */
    function updateDataOfDataChart(uint id, string data) external returns (uint);

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
     * Like a data chart
     * Emits {LikeDataChart}
     * @param chart_id chart ID
     */
    function likeDataChart(uint chart_id) external;

    /**
     * Cancel like a data chart
     * Emits {CancelLikeDataChart}
     * @param chart_id chart ID
     */
    function cancelLikeDataChart(uint chart_id) external;

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
     * Dislike a data chart
     * Emits {DislikeDataChart}
     * @param chart_id chart ID
     */
    function dislikeDataChart(uint chart_id) external;

    /**
     * Cancel dislike a data chart
     * Emits {CancelDislikeDataChart}
     * @param chart_id chart ID
     */
    function cancelDislikeDataChart(uint chart_id) external;

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
}
