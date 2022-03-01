pragma solidity ^0.4.24;

interface ITagManager {

    event AddTagOfDataSource(uint source_id, address sender, string tags);

    event RemoveTagOfDataSource(uint source_id, address sender, string tags);

    event AddTagOfDataChart(uint chart_id, address sender, string tags);

    event RemoveTagOfDataChart(uint chart_id, address sender, string tags);

    event AddTagOfDataDashboard(uint dashboard_id, address sender, string tags);

    event RemoveTagOfDataDashboard(uint dashboard_id, address sender, string tags);

    /**
     * @param source_id
     * @param tags split by ","
     */
    function addTagOfDataSource(uint, string) external;

    /**
     * @param source_id
     * @param tags split by ","
     */
    function removeTagOfDataSource(uint, string) external;

    /**
     * @param chart_id
     * @param tags split by ","
     */
    function addTagOfDataChart(uint, string) external;

    /**
     * @param chart_id
     * @param tags split by ","
     */
    function removeTagOfDataChart(uint, string) external;

    /**
     * @param dashboard_id
     * @param tags split by ","
     */
    function addTagOfDataDashboard(uint, string) external;

    /**
     * @param dashboard_id
     * @param tags split by ","
     */
    function removeTagOfDataDashboard(uint, string) external;

}
