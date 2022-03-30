pragma solidity ^0.4.24;

interface IDataSourceManagerProxy {
    
    function createDataSource(string name, string desc, string version, string url) external returns (uint);

    function updateDataSource(uint id, string name, string desc, string version, string url) external;

    function deleteDataSource(uint id) external;

    function likeDataSource(uint source_id, bool liked) external;

    // comments
    function addCommentForDataSource(uint source_id, string comment) external returns (uint);

    function updateCommentForDataSource(uint comment_id, string comment) external;

    function deleteCommentForDataSource(uint comment_id) external;

    function replyCommentForDataSource(uint targetID, string comment) external returns (uint);

    function likeCommentForDataSource(uint id, bool liked) external;

    
}
