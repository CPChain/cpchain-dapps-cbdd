pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/ownership/Claimable.sol";
import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataSourceManager.sol";
import "./interfaces/IDataSourceManagerProxy.sol";
import "./interfaces/IDataChartManager.sol";
import "./interfaces/IDataChartManagerProxy.sol";
import "./interfaces/IDataDashboardManager.sol";
import "./interfaces/IDataDashboardManagerProxy.sol";
import "./interfaces/IController.sol";
import "./interfaces/IVersion.sol";
import "./interfaces/IControllerIniter.sol";
import "./interfaces/IActionYieldFarming.sol";
import "./interfaces/ICommentManager.sol";
import "./lib/Actions.sol";

contract Controller is Enable, IController, IDataSourceManagerProxy, IDataChartManagerProxy,
    IDataDashboardManagerProxy {
    enum CONTRACTS {
        ADDRESS_VALIDATOR,
        DATA_SOURCE_MANAGER,
        DATA_CHART_MANAGER,
        DATA_DASHBOARD_MANAGER,
        TAG_MANAGER,
        COMMENT_MANAGER,
        CBDD_TOKEN
    }

    // CBDD ERC20 contract
    IActionYieldFarming cbdd;

    // Data Source Manager contract
    IDataSourceManager dataSourceManager;
    ICommentManager commentOnDataSource;

    // Data Chart Manager contract
    IDataChartManager dataChartManager;

    // Data Dashboard Manager contract
    IDataDashboardManager dataDashboardManager;

    struct MyContract {
        address addr;
        uint version;
    }
    mapping(uint => MyContract) private my_contracts;

    mapping(uint => mapping (address => bool)) private likedDataSource;
    mapping(uint => mapping (address => bool)) private likedDataCharts;
    mapping(uint => mapping (address => bool)) private likedDataDashboard;

    constructor(address cbddAddr, address dataSourceManagerAddr, address dataChartManagerAddr,
        address dataDashboardManagerAddr) public {
        _setContract(CONTRACTS.CBDD_TOKEN, cbddAddr);
        _setContract(CONTRACTS.DATA_SOURCE_MANAGER, dataSourceManagerAddr);
        _setContract(CONTRACTS.DATA_CHART_MANAGER, dataChartManagerAddr);
        _setContract(CONTRACTS.DATA_DASHBOARD_MANAGER, dataDashboardManagerAddr);
    }

    modifier initedCBDD() {require(my_contracts[uint(CONTRACTS.CBDD_TOKEN)].addr != address(0x0)); _;}

    function _setContract(CONTRACTS code, address addr) private onlyEnabled onlyOwner {
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
            commentOnDataSource = ICommentManager(addr);
            emit RegisterDataSourceManager(my_contracts[uint(code)].version, addr);
        } else if (code == CONTRACTS.DATA_CHART_MANAGER) {
            dataChartManager = IDataChartManager(addr);
            emit RegisterDataChartManager(my_contracts[uint(code)].version, addr);
        } else if (code == CONTRACTS.DATA_DASHBOARD_MANAGER) {
            dataDashboardManager = IDataDashboardManager(addr);
            emit RegisterDataDashboardManager(my_contracts[uint(code)].version, addr);
        }
    }

    function registerAddressValidator(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
    }

    function registerDataSourceManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.DATA_SOURCE_MANAGER, contract_address);
    }

    function registerDataChartManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.DATA_CHART_MANAGER, contract_address);
    }

    function registerDataDashboardManager(uint version, address contract_address) external {
        IVersion versionInstance = IVersion(contract_address);
        require(version == versionInstance.version(), "The version of the address is different from the one passed in");
        _setContract(CONTRACTS.DATA_DASHBOARD_MANAGER, contract_address);
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
        dataSourceManager.likeDataSource(msg.sender, source_id, liked);
        // 已被奖励过点赞某数据源的地址，取消点赞后以及不喜欢、再次点赞等等，双方都不再进行奖励
        if (!likedDataSource[source_id][msg.sender]) {
            // 给双方进行奖励
            likedDataSource[source_id][msg.sender] = true;
            address owner = dataSourceManager.getDataSourceOwner(source_id);
            // 判断是 LIKE 还是 DISLIKE
            if (liked) {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.LIKE_DATA_SOURCE));
            } else {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.DISLIKE_DATA_SOURCE));
            }
        }
    }
    // Data Source Manager Proxy End

    // Data Chart Manager Proxy Start
    function createDataChart(string name, uint source_id, string desc, string chart_type, string data) external returns (uint) {
        // TODO 地址不在黑名单
        uint id = dataChartManager.createDataChart(msg.sender, name, source_id, desc, chart_type, data);
        // yield
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.CREATE_DATA_CHART));
        return id;
    }

    function updateDataChart(uint id, uint source_id, string name, string desc, string chart_type, string data) external {
        dataChartManager.updateDataChart(msg.sender, id, source_id, name, desc, chart_type, data);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.UPDATE_DATA_CHART));
    }

    function deleteDataChart(uint id) external {
        dataChartManager.deleteDataChart(msg.sender, id);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.DELETE_DATA_CHART));
    }

    function likeDataChart(uint chart_id, bool liked) external {
        dataChartManager.likeDataChart(msg.sender, chart_id, liked);
        // 已被奖励过点赞某数据源的地址，取消点赞后以及不喜欢、再次点赞等等，双方都不再进行奖励
        if (!likedDataCharts[chart_id][msg.sender]) {
            // 给双方进行奖励
            likedDataCharts[chart_id][msg.sender] = true;
            address owner = dataChartManager.getDataChartOwner(chart_id);
            // 判断是 LIKE 还是 DISLIKE
            if (liked) {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.LIKE_DATA_CHART));
            } else {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.DISLIKE_DATA_CHART));
            }
        }
    }

    // Data Chart Manager Proxy End

    // Data Dashboard Manager Proxy Start
    function createDataDashboard(string name, uint[] charts, string desc, string data) external returns (uint) {
         // TODO 地址不在黑名单
        uint id = dataDashboardManager.createDataDashboard(msg.sender, name, charts, desc, data);
        // yield
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.CREATE_DATA_DASHBOARD));
        return id;
    }

    function updateDataDashboard(uint id, string name, uint[] charts, string desc, string data) external {
        dataDashboardManager.updateDataDashboard(msg.sender, id, name, charts, desc, data);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.UPDATE_DATA_DASHBOARD));
    }

    function deleteDataDashboard(uint id) external {
        dataDashboardManager.deleteDataDashboard(msg.sender, id);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.DELETE_DATA_DASHBOARD));
    }

    function likeDataDashboard(uint dashboard_id, bool liked) external {
        dataDashboardManager.likeDataDashboard(msg.sender, dashboard_id, liked);
        // 已被奖励过点赞某数据面的地址，取消点赞后以及不喜欢、再次点赞等等，双方都不再进行奖励
        if (!likedDataCharts[dashboard_id][msg.sender]) {
            // 给双方进行奖励
            likedDataCharts[dashboard_id][msg.sender] = true;
            address owner = dataDashboardManager.getDataDashboardOwner(dashboard_id);
            // 判断是 LIKE 还是 DISLIKE
            if (liked) {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.LIKE_DATA_DASHBOARD));
            } else {
                cbdd.actionYield(msg.sender, owner, uint(Actions.Action.DISLIKE_DATA_DASHBOARD));
            }
        }
    }

    // ---------- End ------------

    // Comment on Data Source
    function addCommentForDataSource(uint source_id, string comment) external returns (uint) {
        commentOnDataSource.addComment(msg.sender, source_id, comment);
        address sourceOwner = dataSourceManager.getDataSourceOwner(source_id);
        cbdd.actionYield(msg.sender, sourceOwner, uint(Actions.Action.ADD_COMMENT_ON_DATA_SOURCE));
    }

    function updateCommentForDataSource(uint comment_id, string comment) external {
        commentOnDataSource.updateComment(msg.sender, comment_id, comment);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.UPDATE_COMMENT));
    }

    function deleteCommentForDataSource(uint comment_id) external {
        commentOnDataSource.deleteComment(msg.sender, comment_id);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.DELETE_COMMENT));
    }

    function replyCommentForDataSource(uint targetID, string comment) external returns (uint) {
        commentOnDataSource.replyComment(msg.sender, targetID, comment);
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.REPLY_COMMENT));
    }

    function likeCommentForDataSource(uint id, bool liked) external {
        commentOnDataSource.likeComment(msg.sender, id, liked);
        
        cbdd.actionYield(msg.sender, address(0x0), uint(Actions.Action.LIKE_COMMENT));
    }

    // ---------- End ------------
}
