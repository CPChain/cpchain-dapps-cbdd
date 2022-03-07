pragma solidity ^0.4.24;

interface IDataChartManagerProxy {
    function createDataChart(string name, uint source_id, string desc, string chart_type, string data) external returns (uint);

    function updateDataChart(uint id, uint source_id, string name, string desc, string chart_type, string data) external;

    function deleteDataChart(uint id) external;

    function likeDataChart(uint chart_id, bool liked) external;
}
