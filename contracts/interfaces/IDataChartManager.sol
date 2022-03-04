pragma solidity ^0.4.24;


interface IDataChartManager {
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
     * Create data chart
     * Emits {CreateDataChartEvent}
     * @param name unique name
     * @param source_id id of the data source
     * @param desc description
     * @param chart_type type
     * @param data params
     * @return sequence ID
     */
    function createDataChart(address sender, string name, uint source_id, string desc, string chart_type, string data) external returns (uint);

    /**
     * Update name
     * Emits {UpdateDataChartEvent}
     * @param id ID
     * @param name name
     * @param desc description
     * @param chart_type type
     * @param data params
     * @return ID
     */
    function updateDataChart(address sender, uint id, uint source_id, string name, string desc, string chart_type, string data) external;

    /**
     * Delete data chart
     * Emits {DeleteDataChartEvent}
     * @param id ID
     * @return ID
     */
    function deleteDataChart(address sender, uint id) external;

    /**
     * Like a data chart
     * 如果当前既没有 like，也没有 dislike，那么 liked 为 true 时，是 like
     * liked 为 false 时，是 dislike；
     * 如果当前为 like，那么 liked 为 false 时，是 cancel-like；否则报错
     * 如果当前为 dislike，那么 liked 为 true 时，是 cancel-dislike；否则报错
     * Emits {LikeEvent, CancelLike, Dislike, CancelDislike}
     * @param chart_id chart ID
     */
    function likeDataChart(address sender, uint chart_id, bool liked) external;

    // views
    function getDataChartOwner(uint id) external view returns (address);

    function getDataChart(uint id) external view returns (uint chart_id, uint source_id, address sender, string name, string desc,
        string chart_type, string data);
}

