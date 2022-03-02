pragma solidity ^0.4.24;

interface IDataChartValidator {
    /**
     * Validate data chart
     * @param name unique name
     * @param desc description
     * @param chart_type type
     * @param data params
     * @return validated
     */
    function validateDataChart(string name, string desc, string chart_type, string data) external returns (bool);
}
