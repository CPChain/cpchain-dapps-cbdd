pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataManager.sol";
import "./interfaces/IDataAdminManager.sol";
import "./interfaces/IVersion.sol";
import "./lib/ControllerIniter.sol";
import "./lib/Strings.sol";

contract DataManager is IDataManager, IDataAdminManager, Enable, IVersion, ControllerIniter {
    // context
    struct Context {
        bool allowedDislike;
        uint maxLenOfName;
        uint minLenOfName;
        uint maxLenOfDescription;
        uint minLenOfDescription;
    }
    Context private context;

    // data source
    struct DataSource {
        uint id;
        address owner;
        string name;
        string desc;
        string version;
        string url;
        bool disabled;
        bool deleted;
        mapping(address => bool) liked;
        mapping(address => bool) disliked;
    }
    uint private data_source_seq = 0;
    mapping(string => bool) source_name_set;
    mapping(uint => DataSource) private data_sources;

    modifier validateNameLength(string name) {
        uint length = Strings.utfStringLength(name);
        require(length <= context.maxLenOfDescription && length >= context.minLenOfName,
            "Length of name is not in the range");
        _;
    }
    modifier validateDescLength(string desc) {
        uint length = Strings.utfStringLength(desc);
        require(length <= context.maxLenOfDescription && length >= context.minLenOfDescription,
            "Length of desc is not in the range");
        _;
    }
    modifier onlyNotExistsName(string name) {
        require(!source_name_set[name], "Name of data source have been exists!");
        _;
    }
    modifier onlyDataSourceOwner(uint id) {
        require(data_sources[id].owner == msg.sender, "Only the owner of this data source can call it");
        _;
    }
    modifier onlyDataSourceExists(uint id) {
        require(data_sources[id].id > 0, "Data source does not exists!");
        require(!data_sources[id].deleted, "Data source have been deleted");
        _;
    }

    function _nextDataSourceSeq() private returns (uint) {
        data_source_seq += 1;
        return data_source_seq;
    }

    function createDataSource(string name, string desc, string version, string url) external 
        onlyEnabled onlyController validateNameLength(name) validateDescLength(desc)
        onlyNotExistsName(name) returns (uint) {
        // TODO validate data source by DataSourceValidator
        uint id = _nextDataSourceSeq();
        data_sources[id] = DataSource({
            id: id,
            owner: msg.sender,
            name: name,
            desc: desc,
            version: version,
            url: url,
            disabled: false,
            deleted: false
        });
        emit CreateDataSourceEvent(id, msg.sender, name, desc, version, url);
        return id;
    }

    function createDataChart(string name, uint source_id, string desc, string chart_type, string data) external returns (uint) {
        return 0;
    }

    function createDataDashboard(string name, uint[] charts, string desc, string data) external returns (uint) {
        return 0;
    }

    function updateNameOfDataSource(uint id, string name) onlyEnabled onlyController validateNameLength(name)
        onlyNotExistsName(name) onlyDataSourceOwner(id) onlyDataSourceExists(id) external returns (uint) {
        delete source_name_set[data_sources[id].name];
        data_sources[id].name = name;
        source_name_set[data_sources[id].name] = true;
        emit UpdateDataSourceEvent(id, name, data_sources[id].desc, data_sources[id].version, data_sources[id].url);
        return id;
    }

    function updateDescOfDataSource(uint id, string desc) onlyEnabled onlyController validateDescLength(desc)
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].desc = desc;
        emit UpdateDataSourceEvent(id, data_sources[id].name, desc, data_sources[id].version, data_sources[id].url);
        return id;
    }

    function updateVersionOfDataSource(uint id, string version) onlyEnabled onlyController
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].version = version;
        emit UpdateDataSourceEvent(id, data_sources[id].name, data_sources[id].desc, version, data_sources[id].url);
        return id;
    }

    function updateURLOfDataSource(uint id, string url) onlyEnabled onlyController
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].url = url;
        emit UpdateDataSourceEvent(id, data_sources[id].name, data_sources[id].desc, data_sources[id].version, url);
        return id;
    }

    function deleteDataSource(uint id) onlyEnabled onlyController onlyDataSourceExists(id)
        onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].deleted = true;
        emit DeleteDataSourceEvent(id);
        return id;
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

    function likeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(!data_sources[source_id].liked[msg.sender], "You have liked this data source");
        require(!data_sources[source_id].disliked[msg.sender], "You have disliked this data source");
        data_sources[source_id].liked[msg.sender] = true;
    }

    function cancelLikeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(data_sources[source_id].liked[msg.sender], "You do not like this data source");
        delete data_sources[source_id].liked[msg.sender];
    }

    function likeDataChart(uint chart_id) external {
    }

    function cancelLikeDataChart(uint chart_id) external {
    }

    function likeDataDashboard(uint dashboard_id) external {
    }

    function cancelLikeDataDataboard(uint dashboard_id) external {
    }

    function dislikeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(!data_sources[source_id].liked[msg.sender], "You have liked this data source");
        require(!data_sources[source_id].disliked[msg.sender], "You have disliked this data source");
        data_sources[source_id].disliked[msg.sender] = true;
    }

    function cancelDislikeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(data_sources[source_id].disliked[msg.sender], "You do not dislike this data source");
        delete data_sources[source_id].liked[msg.sender];
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

}
