pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/ownership/Claimable.sol";
import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataSourceManager.sol";
import "./interfaces/IDataSourceManagerProxy.sol";
import "./interfaces/IController.sol";
import "./interfaces/IVersion.sol";
import "./interfaces/IControllerIniter.sol";
import "./interfaces/IActionYieldFarming.sol";
import "./lib/Actions.sol";

contract Controller is Claimable, Enable, IController, IDataSourceManagerProxy {
    enum CONTRACTS {
        ADDRESS_VALIDATOR,
        DATA_SOURCE_MANAGER,
        TAG_MANAGER,
        COMMENT_MANAGER,
        CBDD_TOKEN
    }

    // CBDD ERC20 contract
    IActionYieldFarming cbdd;

    // Data Manager contract
    IDataSourceManager dataSourceManager;

    struct MyContract {
        address addr;
        uint version;
    }
    mapping(uint => MyContract) private my_contracts;

    constructor(address cbdd_addr, address data_manager_addr) public {
        _setContract(CONTRACTS.CBDD_TOKEN, cbdd_addr);
        _setContract(CONTRACTS.DATA_SOURCE_MANAGER, data_manager_addr);
    }

    modifier initedCBDD() {require(my_contracts[uint(CONTRACTS.CBDD_TOKEN)].addr != address(0x0)); _;}

    function _setContract(CONTRACTS code, address addr) private {
        require(addr != address(0x0), "Address can't be zero address");
        // The contract should be Version and ControllerIniter
        IVersion versionInstance = IVersion(addr);
        IControllerIniter initer = IControllerIniter(addr);

        if (my_contracts[uint(code)].addr != address(0x0)) {
            // validate version, the version should greater than current
            require(versionInstance.version() > my_contracts[uint(code)].version,
                "New version of contract should greater than current version");
        }
        // the contract should not has any controller inited it
        require(!initer.isInitedController(), "This contract have been inited by other controller");

        // init the contract
        initer.initController(address(this));

        // set this contract
        my_contracts[uint(code)].addr = addr;
        my_contracts[uint(code)].version = versionInstance.version();

        // set instances
        if (code == CONTRACTS.CBDD_TOKEN) {
            cbdd = IActionYieldFarming(addr);
            emit RegisterCBDDToken(my_contracts[uint(code)].version, addr);
        } else if (code == CONTRACTS.DATA_SOURCE_MANAGER) {
            dataSourceManager = IDataSourceManager(addr);
            emit RegisterDataManager(my_contracts[uint(code)].version, addr);
        }
    }

    function registerAddressValidator(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerDataManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.DATA_SOURCE_MANAGER, contract_address);
    }

    function registerTagManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerCommentManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerCBDDToken(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.CBDD_TOKEN, contract_address);
    }

    function yieldTest(address recipient) external initedCBDD onlyEnabled onlyOwner {
        cbdd.actionYield(recipient, address(0x0), uint(Actions.Action.CREATE_DATA_SOURCE));
    }

    // Data Source Manager Proxy
    function createDataSource(string name, string desc, string version, string url) external returns (uint) {
        // TODO 地址不在黑名单
        uint id = dataSourceManager.createDataSource(msg.sender, name, desc, version, url);
        // yield
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.CREATE_DATA_SOURCE));
        return id;
    }

    function updateDataSource(uint id, string name, string desc, string version, string url) external {
        dataSourceManager.updateDataSource(msg.sender, id, name, desc, version, url);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.UPDATE_DATA_SOURCE));
    }

    function deleteDataSource(uint id) external {
        dataSourceManager.deleteDataSource(msg.sender, id);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.DELETE_DATA_SOURCE));
    }

    function likeDataSource(uint source_id, bool liked) external {
        // TODO 已被奖励过点赞某数据源的地址，取消点赞后再次点赞，双方都不再进行奖励
        dataSourceManager.likeDataSource(msg.sender, source_id, liked);
        // TODO 给双方进行奖励
    }
    // Data Source Manager Proxy End
}
