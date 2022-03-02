pragma solidity ^0.4.24;

interface IDataManager {
    /**
     * Triggered when user create a new data source
     * @param id source ID
     * @param sender address
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event CreateDataSourceEvent(uint source_id, address sender, string name, string desc,
        string version, string url);
    
    /**
     * Triggered when user update a data source
     * @param id source ID
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event UpdateDataSourceEvent(uint source_id, string name, string desc, string version, string url);

    /**
     * Triggered when user delete a data source
     * @param ID
     */
    event DeleteDataSourceEvent(uint source_id);

    /**
     * Triggered when user create a new data chart
     * @param id chart ID
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
     * @param id chart ID
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param type type
     * @param data params
     */
    event UpdateDataChartEvent(uint chart_id, string name, uint source_id, string desc,
        string chart_type, string data);

    /**
     * Triggered when user delete a data chart
     * @param ID
     */
    event DeleteDataChartEvent(uint chart_id);

    /**
     * Triggered when user create a new data dashboard
     * @param id dashboard ID
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
     * @param id dashboard ID
     * @param name unique name
     * @param charts id of the data source
     * @param desc description
     * @param data params
     */
    event UpdateDataDashboardEvent(uint dashboard_id, string sender, uint[] charts,
        string desc, string data);

    /**
     * Triggered when user delete a data dashboard
     * @param ID
     */
    event DeleteDataDashboardEvent(uint dashboard_id);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataSource(address sender, uint source_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataSource(address sender, uint source_id);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataChart(address sender, uint chart_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataChart(address sender, uint chart_id);

    /**
     * @param sender
     * @param ID
     */
    event LikeDataDashboard(address sender, uint dashboard_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelLikeDataDashboard(address sender, uint dashboard_id);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataSource(address sender, uint source_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataSource(address sender, uint source_id);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataChart(address sender, uint chart_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataChart(address sender, uint chart_id);

    /**
     * @param sender
     * @param ID
     */
    event DislikeDataDashboard(address sender, uint dashboard_id);

    /**
     * @param sender
     * @param ID
     */
    event CancelDislikeDataDashboard(address sender, uint dashboard_id);

    /**
     * @param version
     * @param contract_addr
     */
    event RegisterDashSourceValidator(uint version, address contract_addr);

    /**
     * @param version
     * @param contract_addr
     */
    event RegisterDashChartValidator(uint version, address contract_addr);

    /**
     * @param version
     * @param contract_addr
     */
    event RegisterDashDashboardValidator(uint version, address contract_addr);

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

    /**
     * Register the validator contract address
     * @param version
     * @param contract_address
     * Emits {RegisterDashSourceValidator}
     */
    function registerDashSourceValidator(uint, address) external;

    /**
     * Register the validator contract address
     * @param version
     * @param contract_address
     * Emits {RegisterDashChartValidator}
     */
    function registerDashChartValidator(uint, address) external;

    /**
     * Register the validator contract address
     * @param version
     * @param contract_address
     * Emits {RegisterDashDashboardValidator}
     */
    function registerDashDashboardValidator(uint, address) external;
}
