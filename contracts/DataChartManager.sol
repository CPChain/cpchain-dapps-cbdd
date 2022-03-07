pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataChartManager.sol";
import "./lib/DataBaseManager.sol";
import "./interfaces/IDataBaseManager.sol";

contract DataChartManager is DataBaseManager, IDataChartManager {
    // data source
    struct DataChartExtend {
        uint source_id;
        string chart_type;
        string data;
    }
    mapping(uint => DataChartExtend) private data_charts;

    IDataBaseManager dataSourceInstance;

    constructor(address dataSourceContract) public {
        require(dataSourceContract != address(0x0), "DataSource can not be null");
        dataSourceInstance = IDataBaseManager(dataSourceContract);
    }

    function createDataChart(address sender, string name, uint source_id, string desc, string chart_type, string data) external 
        onlyEnabled onlyController returns (uint) {
        return _createDataChart(sender, name, source_id, desc, chart_type, data);
    }

    function _createDataChart(address sender, string name, uint source_id, string desc, string chart_type, string data) private
        returns (uint) {
        uint id = _createElement(sender, name, desc);
        // validate if source_id exists
        require(dataSourceInstance.existsID(source_id), "Do not find the data source");
        data_charts[id] = DataChartExtend({
            source_id: source_id,
            chart_type: chart_type,
            data: data
        });
        emit CreateDataChartEvent(id, sender, name, source_id, desc, chart_type, data);
        return id;
    }

    function updateDataChart(address sender, uint id, uint source_id, string name, string desc, string chart_type, string data)
        onlyEnabled onlyController external {
        _updateDataChart(sender, id, source_id, name, desc, chart_type, data);
    }

    function _updateDataChart(address sender, uint id, uint source_id, string name, string desc, string chart_type, string data) private {
        _updateElement(sender, id, name, desc);
        // validate if source_id exists
        require(dataSourceInstance.existsID(source_id), "Do not find the data source");
        data_charts[id].source_id = source_id;
        data_charts[id].chart_type = chart_type;
        data_charts[id].data = data;
        emit UpdateDataChartEvent(id, name, source_id, desc, chart_type, data);
    }

    function deleteDataChart(address sender, uint id) onlyEnabled onlyController external {
        _deleteElement(sender, id);
        emit DeleteDataChartEvent(id);
    }

    function likeDataChart(address sender, uint chart_id, bool liked) onlyEnabled onlyController external {
        _likeElement(sender, chart_id, liked);
    }

    function getDataChartOwner(uint id) external view returns (address) {
        return getDataElementOwner(id);
    }

    // views
    function getDataChart(uint id) external view returns (uint chart_id, uint source_id, address sender, string name, string desc,
        string chart_type, string data) {
        (chart_id, sender, name, desc) = getDataElement(id);
        source_id = data_charts[id].source_id;
        chart_type = data_charts[id].chart_type;
        data = data_charts[id].data;
    }
}
