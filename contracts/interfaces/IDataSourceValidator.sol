pragma solidity ^0.4.24;

interface IDataSourceValidator {
    /**
     * Validate data source
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     * @return validated
     */
    function validateDataSource(string, string, string, string) external returns (bool);
}
