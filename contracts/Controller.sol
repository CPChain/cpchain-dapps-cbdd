pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/ownership/Claimable.sol";
import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataManager.sol";
import "./interfaces/IController.sol";
import "./interfaces/IVersion.sol";
import "./interfaces/IControllerIniter.sol";
import "./interfaces/IActionYieldFarming.sol";
import "./lib/Actions.sol";

contract Controller is Claimable, Enable, IController {
    enum CONTRACTS {
        ADDRESS_VALIDATOR,
        DATA_MANAGER,
        TAG_MANAGER,
        COMMENT_MANAGER,
        CBDD_TOKEN
    }

    // CBDD ERC20 contract
    IActionYieldFarming cbdd;

    // Data Manager contract
    IDataManager dataManager;

    struct MyContract {
        address addr;
        uint version;
    }
    mapping(uint => MyContract) private my_contracts;

    constructor(address cbdd_addr) public {
        _setContract(CONTRACTS.CBDD_TOKEN, cbdd_addr);
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
        }
    }

    function registerAddressValidator(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerDataManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
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

    // Data Manager Proxy
    function createDataSource(string name, string desc, string version, string url) external returns (uint) {
        // TODO 地址不在黑名单
        uint id = dataManager.createDataSource(name, desc, version, url);
        // yield
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.CREATE_DATA_SOURCE));
        return id;
    }

    function createDataChart(string name, uint source_id, string desc, string chart_type, string data) external returns (uint) {
        return 0;
    }

    function createDataDashboard(string name, uint[] charts, string desc, string data) external returns (uint) {
        return 0;
    }

    function updateNameOfDataSource(uint id, string name) external returns (uint) {
        return 0;
    }

    function updateDescOfDataSource(uint id, string desc) external returns (uint) {
        return 0;
    }

    function updateVersionOfDataSource(uint id, string version) external returns (uint) {
        return 0;
    }

    function updateURLOfDataSource(uint id, string url) external returns (uint) {
        return 0;
    }

    function deleteDataSource(uint id) external returns (uint) {
        return 0;
    }

    function updateNameOfDataChart(uint id, string name) external returns (uint) {
        return 0;
    }

    function updateDescOfDataChart(uint id, string desc) external returns (uint) {
        return 0;
    }

    function updateSourceIDOfDataChart(uint id, uint source_id) external returns (uint) {
        return 0;
    }

    function updateTypeOfDataChart(uint id, string chart_type) external returns (uint) {
        return 0;
    }

    function updateDataOfDataChart(uint id, string data) external returns (uint) {
        return 0;
    }

    function updateNameOfDataDashboard(uint id, string name) external returns (uint) {
        return 0;
    }

    function updateDesciptionOfDataDashboard(uint id, string desc) external returns (uint) {
        return 0;
    }

    function updateChartsOfDataDashboard(uint id, uint[] charts) external returns (uint) {
        return 0;
    }

    function updateDataOfDataDashboard(uint id, string data) external returns (uint) {
        return 0;
    }

    function likeDataSource(uint source_id) external {
        // TODO 已被奖励过点赞某数据源的地址，取消点赞后再次点赞，双方都不再进行奖励
    }

    function cancelLikeDataSource(uint source_id) external {
    }

    function likeDataChart(uint chart_id) external {
    }

    function cancelLikeDataChart(uint chart_id) external {
    }

    function likeDataDashboard(uint dashboard_id) external {
    }

    function cancelLikeDataDataboard(uint dashboard_id) external {
    }

    function dislikeDataSource(uint source_id) external {
    }

    function cancelDislikeDataSource(uint source_id) external {
    }

    function dislikeDataChart(uint chart_id) external {
    }

    function cancelDislikeDataChart(uint chart_id) external {
    }

    function dislikeDataDashboard(uint dashboard_id) external {
    }

    function cancelDislikeDataDataboard(uint dashboard_id) external {
    }

    function registerDashSourceValidator(uint version, address contract_address) external {
    }

    function registerDashChartValidator(uint version, address contract_address) external {
    }

    function registerDashDashboardValidator(uint version, address contract_address) external {
    }
    // Data Manager Proxy End
}
