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
     * Register the validator contract address
     * Emits {RegisterDataSourceValidator}
     * @param version version
     * @param contract_address contract address
     */
    function registerDataSourceValidator(uint version, address contract_address) external;
}
