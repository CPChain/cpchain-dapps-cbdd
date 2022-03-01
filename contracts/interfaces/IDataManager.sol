pragma solidity ^0.4.24;

interface IDataManager {
    /**
     * Triggered when user create a new data source
     * @param id source ID
     * @param owner address
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event CreateDataSourceEvent(uint, address, string, string, string, string);
    
    /**
     * Triggered when user update a data source
     * @param id source ID
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event UpdateDataSourceEvent(uint, string, string, string, string);

    /**
     * Triggered when user delete a data source
     * @param ID
     */
    event DeleteDataSourceEvent(uint);

    /**
     * Triggered when user create a new data chart
     * @param id chart ID
     * @param owner address
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param type type
     * @param data params
     */
    event CreateDataChartEvent(uint, address, string, uint, string, string, string);

    /**
     * Triggered when user update a data chart
     * @param id chart ID
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param type type
     * @param data params
     */
    event UpdateDataChartEvent(uint, string, uint, string, string, string);

    /**
     * Triggered when user delete a data chart
     * @param ID
     */
    event DeleteDataChartEvent(uint);

    /**
     * Triggered when user create a new data dashboard
     * @param id dashboard ID
     * @param owner address
     * @param name unique name
     * @param charts id of the data source
     * @param desc description
     * @param data params
     */
    event CreateDataDashboardEvent(uint, address, string, uint[], string, string);

    /**
     * Triggered when user update a data dashboard
     * @param id dashboard ID
     * @param name unique name
     * @param charts id of the data source
     * @param desc description
     * @param data params
     */
    event UpdateDataDashboardEvent(uint, string, uint[], string, string);

    /**
     * Triggered when user delete a data dashboard
     * @param ID
     */
    event DeleteDataDashboardEvent(uint);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataSource(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataSource(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataChart(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataChart(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataDashboard(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataDashboard(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataSource(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataSource(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataChart(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataChart(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataDashboard(address, uint);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataDashboard(address, uint);

    /**
     * Create data source
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     * @return sequence ID
     * Emits {CreateDataSourceEvent}
     */
    function createDataSource(string, string, string, string) external returns (uint);

    /**
     * Create data chart
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param type type
     * @param data params
     * @return sequence ID
     * Emits {CreateDataChartEvent}
     */
    function createDataChart(string, uint, string, string, string) external returns (uint);

    /**
     * Create data dashboard
     * @param name unique name
     * @param charts charts
     * @param desc description
     * @param data params
     * @return sequence ID
     * Emits {CreateDataDashboardEvent}
     */
    function createDataDashboard(string, uint[], string, string) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateNameOfDataSource(uint, string) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param desc
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateDescOfDataSource(uint, string) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param version
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateVersionOfDataSource(uint, string) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param url
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateURLOfDataSource(uint, string) external returns (uint);

    /**
     * Delete data source
     * @param ID
     * @return ID
     * Emits {DeleteDataSourceEvent}
     */
    function deleteDataSource(uint) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateNameOfDataChart(uint, string) external returns (uint);

    /**
     * Update description
     * @param ID
     * @param desc
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateDescOfDataChart(uint, string) external returns (uint);

    /**
     * Update source ID
     * @param ID
     * @param source ID
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateSourceIDOfDataChart(uint, uint) external returns (uint);

    /**
     * Update type
     * @param ID
     * @param type
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateTypeOfDataChart(uint, string) external returns (uint);

    /**
     * Update data(params)
     * @param ID
     * @param data
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateDataOfDataChart(uint, string) external returns (uint);

    /**
     * Update name
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataDashboardEvent} 
     */
    function updateNameOfDataDashboard(uint, string) external returns (uint);

    /**
     * Update description
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataDashboardEvent} 
     */
    function updateDesciptionOfDataDashboard(uint, string) external returns (uint);

    /**
     * Update charts
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataDashboardEvent} 
     */
    function updateChartsOfDataDashboard(uint, uint[]) external returns (uint);

    /**
     * Update data(params)
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataDashboardEvent} 
     */
    function updateDataOfDataDashboard(uint, string) external returns (uint);

    /**
     * Like a data source
     * @param source_id source ID
     * Emits {LikeDataSource}
     */
    function likeDataSource(uint) external;

    /**
     * Cancel like a data source
     * @param source_id source ID
     * Emits {CancelLikeDataSource}
     */
    function cancelLikeDataSource(uint) external;

    /**
     * Like a data chart
     * @param chart_id chart ID
     * Emits {LikeDataChart}
     */
    function likeDataChart(uint) external;

    /**
     * Cancel like a data chart
     * @param chart_id chart ID
     * Emits {CancelLikeDataChart}
     */
    function cancelLikeDataChart(uint) external;

    /**
     * Like a data dashboard
     * @param dashboard_id dashboard ID
     * Emits {LikeDataDashboard}
     */
    function likeDataDashboard(uint) external;

    /**
     * Cancel like a data dashboard
     * @param dashboard_id dashboard ID
     * Emits {CancelLikeDataDashboard}
     */
    function cancelLikeDataDataboard(uint) external;

    /**
     * Dislike a data source
     * @param source_id source ID
     * Emits {DislikeDataSource}
     */
    function dislikeDataSource(uint) external;

    /**
     * Cancel dislike a data source
     * @param source_id source ID
     * Emits {CancelDislikeDataSource}
     */
    function cancelDislikeDataSource(uint) external;

    /**
     * Dislike a data chart
     * @param chart_id chart ID
     * Emits {DislikeDataChart}
     */
    function dislikeDataChart(uint) external;

    /**
     * Cancel dislike a data chart
     * @param chart_id chart ID
     * Emits {CancelDislikeDataChart}
     */
    function cancelDislikeDataChart(uint) external;

    /**
     * Dislike a data dashboard
     * @param dashboard_id dashboard ID
     * Emits {DislikeDataDashboard}
     */
    function dislikeDataDashboard(uint) external;

    /**
     * Cancel dislike a data dashboard
     * @param dashboard_id dashboard ID
     * Emits {CancelDislikeDataDashboard}
     */
    function cancelDislikeDataDataboard(uint) external;
}
