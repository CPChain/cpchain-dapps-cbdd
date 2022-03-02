pragma solidity ^0.4.24;

interface IDataAdminManager {

    /**
     * @param source_id source ID
     */
    event EnableDataSourceEvent(uint source_id);

    /**
     * @param source_id source ID
     */
    event DisableDataSourceEvent(uint source_id);

    /**
     * @param chart_id chart ID
     */
    event EnableDataChartEvent(uint chart_id);

    /**
     * @param chart_id chart ID
     */
    event DisableDataChartEvent(uint chart_id);

    /**
     * @param dashboard_id dashboard ID
     */
    event EnableDataDashboardEvent(uint dashboard_id);

    /**
     * @param dashboard_id dashboard ID
     */
    event DisableDataDashboardEvent(uint dashboard_id);

    /**
     * Allowed user dislike a data element
     * @param allowed allowed
     */
    function setIfAllowedDislike(bool allowed) external;

    /**
     * Set the one-address upper limit of data elements
     * @param upper upper
     */
    function setOneAddressUpperLimitOfDataElements(uint upper) external;

    /**
     * Set the max length of a name
     * @param length length
     */
    function setMaxLengthOfName(uint length) external;

    /**
     * Set the min length of a name
     * @param length length
     */
    function setMinLengthOfName(uint length) external;

    /**
     * Set the max length of the description
     * @param length length
     */
    function setMaxLengthOfDescription(uint length) external;

    /**
     * Enable a data source
     * Emits {EnableDataSourceEvent}
     * @param id ID
     */
    function enableDataSource(uint id) external;

    /**
     * Disable a data source
     * Emits {DisableDataSourceEvent}
     * @param id ID
     */
    function disableDataSource(uint id) external;

    /**
     * Enable a data chart
     * Emits {EnableDataChartEvent}
     * @param id ID
     */
    function enableDataChart(uint id) external;

    /**
     * Disable a data chart
     * Emits {DisableDataChartEvent}
     * @param id ID
     */
    function disableDataChart(uint id) external;

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
}
