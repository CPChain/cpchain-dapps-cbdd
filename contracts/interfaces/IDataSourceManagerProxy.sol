pragma solidity ^0.4.24;

interface IDataSourceManagerProxy {
    
    function createDataSource(string name, string desc, string version, string url) external returns (uint);

    function updateDataSource(uint id, string name, string desc, string version, string url) external;

    function deleteDataSource(uint id) external;

    function likeDataSource(uint source_id, bool liked) external;
}
