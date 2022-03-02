pragma solidity ^0.4.24;

interface IDataDashboardValidator {
     /**
     * Validate data dashboard
     * @param name unique name
     * @param desc description
     * @param data params
     * @return validated
     */
    function validateDataDashboard(string name, string desc, string data) external returns (bool);
}
