pragma solidity ^0.4.24;

interface IDataSourceAdminManager {
    /**
     * @param source_id source ID
     */
    event EnableDataSourceEvent(uint source_id);

    /**
     * @param source_id source ID
     */
    event DisableDataSourceEvent(uint source_id);

    /**
     * @param version version
     * @param contract_addr contract address
     */
    event RegisterDataSourceValidatorEvent(uint version, address contract_addr);

    /**
     * Register the validator contract address
     * Emits {RegisterDataSourceValidator}
     * @param version version
     * @param contract_address contract address
     */
    function registerDataSourceValidator(uint version, address contract_address) external;

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
}
