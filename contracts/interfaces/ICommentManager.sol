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

    function replyComment(address sender, uint targetID, string comment) external returns (uint);

    function likeComment(address sender, uint id, bool liked) external;

    // views
    function getComment(uint id) external view returns (uint commentID, address sender, string comment, uint replyTo);

    function getCommentOwner(uint id) external view returns (address sender);

    function isLikedComment(uint id, address sender) external view returns (bool);

    function isDislikedComment(uint id, address sender) external view returns (bool);
}
