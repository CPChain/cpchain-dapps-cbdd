pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataSourceManager.sol";
import "./interfaces/IVersion.sol";
import "./lib/ControllerIniter.sol";
import "./lib/DataBaseManager.sol";

contract DataSourceManager is DataBaseManager, IDataSourceManager {
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
    mapping(string => bool) source_name_set;
    mapping(uint => DataSource) private data_sources;

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

    function createDataSource(address sender, string name, string desc, string version, string url) external 
        onlyEnabled onlyController returns (uint) {
        // TODO validate data source by DataSourceValidator
        return _createDataSource(sender, name, desc, version, url);
    }

    function _createDataSource(address sender, string name, string desc, string version, string url) private validateNameLength(name) validateDescLength(desc)
        onlyNotExistsName(name) elementsCntLessThanUpper(sender) returns (uint) {
        uint id = _nextSeq();
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
        source_name_set[name] = true;
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
        source_name_set[name] = true;
        data_sources[id].name = name;
        data_sources[id].desc = desc;
        data_sources[id].version = version;
        data_sources[id].url = url;
        emit UpdateDataSourceEvent(id, name, desc, version, url);
    }

    function deleteDataSource(address sender, uint id) onlyEnabled onlyController onlyDataSourceExists(id)
        onlyDataSourceOwner(sender, id) external {
        data_sources[id].deleted = true;
        delete source_name_set[data_sources[id].name];
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
                require(context.allowedDislike, "Don't allow dislike data source now");
                data_sources[source_id].disliked[sender] = true;
                emit DislikeDataSourceEvent(sender, source_id);
            }
        } else if(data_sources[source_id].liked[sender]) {
            require(!liked, "You have liked this data source");
            data_sources[source_id].liked[sender] = false;
            emit CancelLikeDataSourceEvent(sender, source_id);
        } else if(data_sources[source_id].disliked[sender]) {
            require(liked, "You have disliked this data source");
            data_sources[source_id].disliked[sender] = false;
            emit CancelDislikeDataSourceEvent(sender, source_id);
        }
    }

    // views
    function existsID(uint id) external view returns (bool) {
        return data_sources[id].id > 0 && !data_sources[id].deleted;
    }

    function existsName(string name) external view returns (bool) {
        return source_name_set[name];
    }

    function isLiked(uint id, address sender) external view returns (bool) {
        return data_sources[id].liked[sender];
    }

    function isDisliked(uint id, address sender) external view returns (bool) {
        return data_sources[id].disliked[sender];
    }

    function getDataSourceOwner(uint id) external view returns (address) {
        return data_sources[id].owner;
    }

    function getDataSource(uint id) external view returns (uint source_id, address sender, string name, string desc,
        string version, string url) {
        source_id = data_sources[id].id;
        sender = data_sources[id].owner;
        name = data_sources[id].name;
        desc = data_sources[id].desc;
        version = data_sources[id].version;
        url = data_sources[id].url;
    }

    // Called by owner
}
