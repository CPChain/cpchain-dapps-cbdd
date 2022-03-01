pragma solidity ^0.4.24;

interface IDataAdminManager {

    /**
     * @param ID
     */
    event EnableDataSourceEvent(uint);

    /**
     * @param ID
     */
    event DisableDataSourceEvent(uint);

    /**
     * @param ID
     */
    event EnableDataChartEvent(uint);

    /**
     * @param ID
     */
    event DisableDataChartEvent(uint);

    /**
     * @param ID
     */
    event EnableDataDashboardEvent(uint);

    /**
     * @param ID
     */
    event DisableDataDashboardEvent(uint);

    /**
     * Allowed user dislike a data element
     * @param allowed
     */
    function setIfAllowedDislike(bool) external;

    /**
     * Set the one-address upper limit of data elements
     * @param upper
     */
    function setOneAddressUpperLimitOfDataElements(uint) external;

    /**
     * Set the max length of a name
     * @param name
     */
    function setMaxLengthOfName(uint) external;

    /**
     * Set the min length of a name
     * @param length
     */
    function setMinLengthOfName(uint) external;

    /**
     * Set the max length of the description
     * @param length
     */
    function setMaxLengthOfDescription(uint) external;

    /**
     * Enable a data source
     * @param ID
     * Emits {EnableDataSourceEvent}
     */
    function enableDataSource(uint) external;

    /**
     * Disable a data source
     * @param ID
     * Emits {DisableDataSourceEvent}
     */
    function disableDataSource(uint) external;

    /**
     * Enable a data chart
     * @param ID
     * Emits {EnableDataChartEvent}
     */
    function enableDataChart(uint) external;

    /**
     * Disable a data chart
     * @param ID
     * Emits {DisableDataChartEvent}
     */
    function disableDataChart(uint) external;

    /**
     * Enable a data dashboard
     * @param ID
     * Emits {EnableDataDashboardEvent}
     */
    function enableDataDashboard(uint) external;

    /**
     * Disable a data dashboard
     * @param ID
     * Emits {DisableDataDashboardEvent}
     */
    function disableDataDashboard(uint) external;
}
