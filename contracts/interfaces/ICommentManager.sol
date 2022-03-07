pragma solidity ^0.4.24;

interface ICommentManager {

    event AddComment(uint id, uint dataElementID, address sender, string comment);

    event UpdateComment(uint id, string comment);

    event ReplyComment(uint id, uint targetID, address sender, string comment);

    event DeleteComment(uint id);

    event LikeComment(uint id, address sender, bool liked);

    function addComment(address sender, uint id, string comment) external returns (uint);

    function updateComment(address sender, uint id, string comment) external;

    function deleteComment(address sender, uint id) external;

    function replyComment(address sender, uint targetID, string comment) external;

    function likeComment(address sender, uint, bool liked) external;
}
