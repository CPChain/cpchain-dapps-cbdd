pragma solidity ^0.4.24;

interface IDataChartValidator {
    /**
     * Validate data chart
     * @param name unique name
     * @param desc description
     * @param type type
     * @param data params
     * @return validated
     */
    function validateDataChart(string, string, string, string) external returns (bool);
}
