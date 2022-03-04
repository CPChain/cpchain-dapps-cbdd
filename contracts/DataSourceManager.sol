pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataSourceManager.sol";
import "./interfaces/IVersion.sol";
import "./lib/ControllerIniter.sol";
import "./lib/DataBaseManager.sol";

contract DataSourceManager is DataBaseManager, IDataSourceManager {
    // data source
    struct DataSourceExtend {
        string version;
        string url;
    }
    mapping(uint => DataSourceExtend) private data_sources;

    function createDataSource(address sender, string name, string desc, string version, string url) external 
        onlyEnabled onlyController returns (uint) {
        return _createDataSource(sender, name, desc, version, url);
    }

    function _createDataSource(address sender, string name, string desc, string version, string url) private
        returns (uint) {
        uint id = _createElement(sender, name, desc);
        data_sources[id] = DataSourceExtend({
            version: version,
            url: url
        });
        emit CreateDataSourceEvent(id, sender, name, desc, version, url);
        return id;
    }

    function updateDataSource(address sender, uint id, string name, string desc, string version, string url)
        onlyEnabled onlyController external {
        _updateDataSource(sender, id, name, desc, version, url);
    }

    function _updateDataSource(address sender, uint id, string name, string desc, string version, string url) private {
        _updateElement(sender, id, name, desc);
        data_sources[id].version = version;
        data_sources[id].url = url;
        emit UpdateDataSourceEvent(id, name, desc, version, url);
    }

    function deleteDataSource(address sender, uint id) onlyEnabled onlyController external {
        _deleteElement(sender, id);
        emit DeleteDataSourceEvent(id);
    }

    function likeDataSource(address sender, uint source_id, bool liked) onlyEnabled onlyController external {
        _likeElement(sender, source_id, liked);
    }

    function getDataSourceOwner(uint id) external view returns (address) {
        return getDataElementOwner(id);
    }

    // views
    function getDataSource(uint id) external view returns (uint source_id, address sender, string name, string desc,
        string version, string url) {
        (source_id, sender, name, desc) = getDataElement(id);
        version = data_sources[id].version;
        url = data_sources[id].url;
    }
}
