pragma solidity ^0.4.24;

interface ITagManager {

    event AddTagOfDataSource(uint source_id, address sender, string tags);

    event RemoveTagOfDataSource(uint source_id, address sender, string tags);

    event AddTagOfDataChart(uint chart_id, address sender, string tags);

    event RemoveTagOfDataChart(uint chart_id, address sender, string tags);

    event AddTagOfDataDashboard(uint dashboard_id, address sender, string tags);

    event RemoveTagOfDataDashboard(uint dashboard_id, address sender, string tags);

    /**
     * @param source_id source ID
     * @param tags split by ","
     */
    function addTagOfDataSource(uint source_id, string tags) external;

    /**
     * @param source_id source ID
     * @param tags split by ","
     */
    function removeTagOfDataSource(uint source_id, string tags) external;

    /**
     * @param chart_id chart ID
     * @param tags split by ","
     */
    function addTagOfDataChart(uint chart_id, string tags) external;

    /**
     * @param chart_id chart ID
     * @param tags split by ","
     */
    function removeTagOfDataChart(uint chart_id, string tags) external;

    /**
     * @param dashboard_id dashboard ID
     * @param tags split by ","
     */
    function addTagOfDataDashboard(uint dashboard_id, string tags) external;

    /**
     * @param dashboard_id dashboard ID
     * @param tags split by ","
     */
    function removeTagOfDataDashboard(uint dashboard_id, string tags) external;

}
