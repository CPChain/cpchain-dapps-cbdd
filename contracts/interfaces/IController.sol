pragma solidity ^0.4.24;

/**
 * IController
 * 控制器，同时是 DataManager, ITagManager, ICommentManager 的合约代理，实现合约可升级
 */
interface IController {
    event RegisterAddressValidator(uint version, address contract_addr);

    event RegisterDataManager(uint version, address contract_addr);

    event RegisterTagManager(uint version, address contract_addr);

    event RegisterCommentManager(uint version, address contract_addr);

    /**
     * Register the address of AddressValidator contract
     * 注册合约地址，合约需已实现 IVersion 接口，且 version 与传入的参数相同
     * @param version contract version
     * @param contract_address AddressValidator contract
     */
    function registerAddressValidator(uint version, address contract_address) external;

    function registerDataManager(uint version, address contract_address) external;

    function registerTagManager(uint version, address contract_address) external;

    function registerCommentManager(uint version, address contract_address) external;
}
