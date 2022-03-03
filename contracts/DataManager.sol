pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataSourceManager.sol";
import "./interfaces/IDataAdminManager.sol";
import "./interfaces/IVersion.sol";
import "./lib/ControllerIniter.sol";
import "./lib/Strings.sol";

contract DataManager is Enable, IVersion, ControllerIniter, IDataSourceManager {
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
    modifier onlyDataSourceOwner(address sender, uint id) {
        require(data_sources[id].owner == sender, "Only the owner of this data source can call it");
        _;
    }
    modifier onlyDataSourceExists(uint id) {
        require(data_sources[id].id > 0, "Data source does not exists!");
        require(!data_sources[id].deleted, "Data source have been deleted");
        _;
    }
    modifier elementsCntLessThanUpper(address sender) {
        require(addrElementsCnt[sender] < context.addressDataElementsUpper, "You have created too many elements");
        _;
    }

    function _nextDataSourceSeq() private returns (uint) {
        data_source_seq += 1;
        return data_source_seq;
    }

    function createDataSource(address sender, string name, string desc, string version, string url) external 
        onlyEnabled onlyController returns (uint) {
        // TODO validate data source by DataSourceValidator
        return _createDataSource(sender, name, desc, version, url);
    }

    function _createDataSource(address sender, string name, string desc, string version, string url) private validateNameLength(name) validateDescLength(desc)
        onlyNotExistsName(name) elementsCntLessThanUpper(sender) returns (uint) {
        uint id = _nextDataSourceSeq();
        data_sources[id] = DataSource({
            id: id,
            owner: sender,
            name: name,
            desc: desc,
            version: version,
            url: url,
            disabled: false,
            deleted: false
        });
        addrElementsCnt[sender] ++;
        emit CreateDataSourceEvent(id, sender, name, desc, version, url);
        return id;
    }

    function updateDataSource(address sender, uint id, string name, string desc, string version, string url)
        onlyEnabled onlyController external {
        _updateDataSource(sender, id, name, desc, version, url);
    }

    function _updateDataSource(address sender, uint id, string name, string desc, string version, string url) private validateNameLength(name) validateDescLength(desc)
        onlyDataSourceOwner(sender, id) onlyDataSourceExists(id) {
        delete source_name_set[data_sources[id].name];
        source_name_set[data_sources[id].name] = true;
        data_sources[id].name = name;
        data_sources[id].desc = desc;
        data_sources[id].version = version;
        data_sources[id].url = url;
        emit UpdateDataSourceEvent(id, name, desc, version, url);
    }

    function deleteDataSource(address sender, uint id) onlyEnabled onlyController onlyDataSourceExists(id)
        onlyDataSourceOwner(sender, id) external {
        data_sources[id].deleted = true;
        emit DeleteDataSourceEvent(id);
    }

    function likeDataSource(address sender, uint source_id, bool liked) onlyEnabled onlyController external {
        _likeDataSource(sender, source_id, liked);
    }

    function _likeDataSource(address sender, uint source_id, bool liked) private onlyDataSourceExists(source_id) {
        if (!data_sources[source_id].liked[sender] && !data_sources[source_id].disliked[sender]) {
            if (liked) {
                data_sources[source_id].liked[sender] = true;
                emit LikeDataSourceEvent(sender, source_id);
            } else {
                delete data_sources[source_id].liked[sender];
                emit DislikeDataSourceEvent(sender, source_id);
            }
        } else if(data_sources[source_id].liked[sender]) {
            require(!liked, "You have liked this data source");
            data_sources[source_id].liked[sender] = false;
            emit CancelLikeDataSourceEvent(sender, source_id);
        } else if(data_sources[source_id].disliked[sender]) {
            require(liked, "You have disliked this data source");
            emit CancelDislikeDataSourceEvent(sender, source_id);
        }
    }

    // Admin interface


    // Version interface

    function version() public view returns (uint) {
        return context.version;
    }

}
