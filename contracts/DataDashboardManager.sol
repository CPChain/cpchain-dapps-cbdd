pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "./interfaces/IDataDashboardManager.sol";
import "./lib/DataBaseManager.sol";
import "./interfaces/IDataBaseManager.sol";

contract DataDashboardManager is DataBaseManager, IDataDashboardManager {
    // data source
    struct DataDashboardExtend {
        uint[] charts;
        string data;
    }
    mapping(uint => DataDashboardExtend) private data_dashboards;

    IDataBaseManager dataChartsInstance;

    constructor(address dataChartContract) public {
        require(dataChartContract != address(0x0), "DataChart can not be null");
        dataChartsInstance = IDataBaseManager(dataChartContract);
    }

    function createDataDashboard(address sender, string name, uint[] charts, string desc, string data) external 
        onlyEnabled onlyController returns (uint) {
        return _createDataDashboard(sender, name, charts, desc, data);
    }

    function _createDataDashboard(address sender, string name, uint[] charts, string desc, string data) private
        returns (uint) {
        uint id = _createElement(sender, name, desc);
        // validate if chart exists
        require(charts.length > 0, "A dashboard at least includes a chart");
        for(uint i = 0; i < charts.length; i++) {
            require(dataChartsInstance.existsID(charts[i]), "Do not find the data chart");
        }
        data_dashboards[id] = DataDashboardExtend({
            charts: charts,
            data: data
        });
        // emit CreateDataChartEvent(id, sender, name, source_id, desc, chart_type, data);
        return id;
    }

    function updateDataDashboard(address sender, uint id, string name, uint[] charts, string desc, string data)
        onlyEnabled onlyController external {
        _updateDataDashboard(sender, id, name, charts, desc, data);
    }

    function _updateDataDashboard(address sender, uint id, string name, uint[] charts, string desc, string data) private {
        _updateElement(sender, id, name, desc);
        // validate if charts exists
        require(charts.length > 0, "A dashboard at least includes a chart");
        for(uint i = 0; i < charts.length; i++) {
            require(dataChartsInstance.existsID(charts[i]), "Do not find the data chart");
        }
        data_dashboards[id].charts = charts;
        data_dashboards[id].data = data;
        // emit UpdateDataChartEvent(id, name, source_id, desc, chart_type, data);
    }

    function deleteDataDashboard(address sender, uint id) onlyEnabled onlyController external {
        _deleteElement(sender, id);
        // emit DeleteDataChartEvent(id);
    }

    function likeDataDashboard(address sender, uint dashboard_id, bool liked) onlyEnabled onlyController external {
        _likeElement(sender, dashboard_id, liked);
    }

    function getDataDashboardOwner(uint id) external view returns (address) {
        return getDataElementOwner(id);
    }

    // views
    function getDataDashboard(uint id) external view returns (uint dashboard_id, uint[] charts, address sender, string name,
        string desc, string data) {
        (dashboard_id, sender, name, desc) = getDataElement(id);
        charts = data_dashboards[id].charts;
        data = data_dashboards[id].data;
    }
}
