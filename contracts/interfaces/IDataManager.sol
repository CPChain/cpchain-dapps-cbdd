pragma solidity ^0.4.24;

interface IDataManager {
    /**
     * Triggered when user create a new data source
     * @param id source ID
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event CreateDataSourceEvent(uint, string, string, string, string);
    
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
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param type type
     * @param data params
     */
    event CreateDataChartEvent(uint, string, uint, string, string, string);
    
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
     * Update name
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateNameOfDataSource(uint, string) returns (uint);

    /**
     * Update name
     * @param ID
     * @param desc
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateDescOfDataSource(uint, string) returns (uint);

    /**
     * Update name
     * @param ID
     * @param version
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateVersionOfDataSource(uint, string) returns (uint);

    /**
     * Update name
     * @param ID
     * @param url
     * @return ID
     * Emits {UpdateDataSourceEvent} 
     */
    function updateURLOfDataSource(uint, string) returns (uint);


    /**
     * Delete data source
     * @param ID
     * @return ID
     * Emits {DeleteDataSourceEvent}
     */
    function deleteDataSource(uint) returns (uint);

    /**
     * Update name
     * @param ID
     * @param name
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateNameOfDataChart(uint, string) returns (uint);

    /**
     * Update description
     * @param ID
     * @param desc
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateDescOfDataChart(uint, string) returns (uint);

    /**
     * Update source ID
     * @param ID
     * @param source ID
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateSourceIDOfDataChart(uint, uint) returns (uint);

    /**
     * Update type
     * @param ID
     * @param type
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateTypeOfDataChart(uint, string) returns (uint);

    /**
     * Update data(params)
     * @param ID
     * @param data
     * @return ID
     * Emits {UpdateDataChartEvent} 
     */
    function updateDataOfDataChart(uint, string) returns (uint);

}
