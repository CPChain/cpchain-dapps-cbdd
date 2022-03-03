pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataManager.sol";
import "./interfaces/IDataAdminManager.sol";
import "./interfaces/IVersion.sol";
import "./lib/ControllerIniter.sol";
import "./lib/Strings.sol";

contract DataManager is Enable, IVersion, ControllerIniter, IDataManager {
    // context
    struct Context {
        uint version;
        bool allowedDislike;
        uint maxLenOfName;
        uint minLenOfName;
        uint maxLenOfDescription;
        uint minLenOfDescription;
        uint addressDataElementsUpper;
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

    // address count
    mapping(address => uint) private addrElementsCnt;

    constructor() public {
        context.version = 0;
        context.allowedDislike = false;
        context.maxLenOfDescription = 200;
        context.minLenOfDescription = 1;
        context.maxLenOfName = 50;
        context.minLenOfName = 1;
        context.addressDataElementsUpper = 500;
    }

    modifier validateNameLength(string name) {
        uint length = bytes(name).length;
        require(length <= context.maxLenOfDescription && length >= context.minLenOfName,
            "Length of name is not in the range");
        _;
    }
    modifier validateDescLength(string desc) {
        uint length = bytes(desc).length;
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
    modifier elementsCntLessThanUpper() {
        require(addrElementsCnt[msg.sender] < context.addressDataElementsUpper, "You have created too many elements");
        _;
    }

    function _nextDataSourceSeq() private returns (uint) {
        data_source_seq += 1;
        return data_source_seq;
    }

    function createDataSource(string name, string desc, string version, string url) external 
        onlyEnabled onlyController validateNameLength(name) validateDescLength(desc)
        onlyNotExistsName(name) elementsCntLessThanUpper returns (uint) {
        // TODO validate data source by DataSourceValidator
        return _createDataSource(name, desc, version, url);
    }

    function _createDataSource(string name, string desc, string version, string url) private returns (uint) {
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
        addrElementsCnt[msg.sender] ++;
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
        _updateDataSource(data_sources[id]);
        return id;
    }

    function _updateDataSource(DataSource ds) private {
        data_sources[ds.id].name = ds.name;
        data_sources[ds.id].desc = ds.desc;
        data_sources[ds.id].version = ds.version;
        data_sources[ds.id].url = ds.url;
        emit UpdateDataSourceEvent(ds.id, ds.name, ds.desc, ds.version, ds.url);
    }

    function updateDescOfDataSource(uint id, string desc) onlyEnabled onlyController validateDescLength(desc)
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].desc = desc;
        _updateDataSource(data_sources[id]);
        return id;
    }

    function updateVersionOfDataSource(uint id, string version) onlyEnabled onlyController
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].version = version;
        _updateDataSource(data_sources[id]);
        return id;
    }

    function updateURLOfDataSource(uint id, string url) onlyEnabled onlyController
        onlyDataSourceExists(id) onlyDataSourceOwner(id) external returns (uint) {
        data_sources[id].url = url;
        _updateDataSource(data_sources[id]);
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
        _likeDataSource(source_id, true);
    }

    function cancelLikeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(data_sources[source_id].liked[msg.sender], "You do not like this data source");
        _likeDataSource(source_id, false);
    }

    function _likeDataSource(uint source_id, bool liked) private {
        if (liked) {
            data_sources[source_id].liked[msg.sender] = true;
            emit LikeDataSourceEvent(msg.sender, source_id);
        } else {
            delete data_sources[source_id].liked[msg.sender];
            emit CancelLikeDataSourceEvent(msg.sender, source_id);
        }
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
        _dislikeDataSource(source_id, true);
    }

    function cancelDislikeDataSource(uint source_id) onlyEnabled onlyController onlyDataSourceExists(source_id) external {
        require(data_sources[source_id].disliked[msg.sender], "You do not dislike this data source");
        _dislikeDataSource(source_id, false);
    }

    function _dislikeDataSource(uint source_id, bool disliked) private {
        if (disliked) {
            data_sources[source_id].disliked[msg.sender] = true;
            emit DislikeDataSourceEvent(msg.sender, source_id);
        } else {
            delete data_sources[source_id].disliked[msg.sender];
            emit CancelDislikeDataSourceEvent(msg.sender, source_id);
        }
    }

    function dislikeDataChart(uint chart_id) external {
    }

    function cancelDislikeDataChart(uint chart_id) external {
    }

    function dislikeDataDashboard(uint dashboard_id) external {
    }

    function cancelDislikeDataDataboard(uint dashboard_id) external {
    }

    // Admin interface


    // Version interface

    function version() public view returns (uint) {
        return context.version;
    }

}
