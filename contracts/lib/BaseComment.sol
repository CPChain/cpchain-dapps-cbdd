pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "../interfaces/ICommentAdminManager.sol";
import "../interfaces/ICommentManager.sol";
import "../interfaces/IDataBaseManager.sol";
import "./ControllerIniter.sol";

contract BaseComment is Enable, ICommentAdminManager, ControllerIniter, ICommentManager {
    struct CommentContext {
        uint comments_seq;
        uint minLenOfComment;
        uint maxLenOfComment;
        bool allowedDislike;
    }
    CommentContext private context;

    // Comment
    struct Comment {
        uint id;
        uint dataElementID;
        uint replyTo;
        address sender;
        string comment;
        bool deleted;
        mapping(address => bool) liked;
        mapping(address => bool) disliked;
    }
    mapping(uint=>Comment) private comments;

    IDataBaseManager dataBase;

    constructor() public {
        // comment
        context.minLenOfComment = 1;
        context.maxLenOfComment = 200;
        context.comments_seq = 0;
        context.allowedDislike = true;
    }

    function initController(address c) public returns (bool) {
        super.initController(c);
        initBaseComment(c);
    }

    function initBaseComment(address dataBaseContract) internal {
        require(dataBaseContract != address(0x0), "dataBaseContract can not be null");
        dataBase = IDataBaseManager(dataBaseContract);
    }

    modifier onlyExists(uint id) {
        require(comments[id].id > 0, "This comment is not exists");
        require(!comments[id].deleted, "This comment has been deleted");
        _;
    }

    modifier onlyCommentOwner(address sender, uint id) {
        require(comments[id].sender == sender, "Only the owner of this comment can call it");
        _;
    }

    modifier validateCommentLength(string name) {
        uint length = bytes(name).length;
        require(length <= context.maxLenOfComment && length >= context.minLenOfComment,
            "Length of name is not in the range");
        _;
    }

    function _nextCommentSeq() private returns (uint) {
        context.comments_seq += 1;
        return context.comments_seq;
    }

    // Comment

    function addComment(address sender, uint id, string comment) external returns (uint) {
        return _addComment(sender, id, comment);
    }

    function updateComment(address sender, uint id, string comment) external {
        _updateComment(sender, id, comment);
    }

    function deleteComment(address sender, uint id) external {
        _deleteComment(sender, id);
    }

    function replyComment(address sender, uint targetID, string comment) external {
        _replyComment(sender, targetID, comment);
    }

    function likeComment(address sender, uint id, bool liked) external {
        _likeComment(sender, id, liked);
    }

    // Comment End

    function _addComment(address sender, uint dataElementID, string comment) internal
        onlyEnabled validateCommentLength(comment) onlyController returns (uint) {
        require(dataBase.existsID(dataElementID), "The data element no exists");
        uint id = _nextCommentSeq();
        comments[id] = Comment({
            id: id,
            dataElementID: dataElementID,
            replyTo: 0,
            sender: sender,
            comment: comment,
            deleted: false
        });
        emit AddComment(id, dataElementID, sender, comment);
    }

    function _updateComment(address sender, uint id, string comment) internal onlyEnabled onlyExists(id)
        onlyCommentOwner(sender, id) onlyController
        validateCommentLength(comment) {
        comments[id].comment = comment;
        emit UpdateComment(id, comment);
    }

    function _deleteComment(address sender, uint id) internal onlyEnabled onlyExists(id)
        onlyCommentOwner(sender, id) onlyController {
        comments[id].deleted = true;
        emit DeleteComment(id);
    }

    function _replyComment(address sender, uint targetID, string comment) internal onlyExists(targetID) onlyEnabled
        validateCommentLength(comment) onlyController {
        uint id = _nextCommentSeq();
        comments[id] = Comment({
            id: id,
            dataElementID: comments[targetID].dataElementID,
            replyTo: targetID,
            sender: sender,
            comment: comment,
            deleted: false
        });
        emit ReplyComment(id, targetID, sender, comment);
    }

    function _likeComment(address sender, uint id, bool liked) internal onlyExists(id) onlyEnabled onlyController {
        if (!comments[id].liked[sender] && !comments[id].disliked[sender]) {
            if (liked) {
                comments[id].liked[sender] = true;
            } else {
                require(context.allowedDislike, "Don't allow dislike comment now");
                comments[id].disliked[sender] = true;
            }
        } else if(comments[id].liked[sender]) {
            require(!liked, "You have liked this comment");
            comments[id].liked[sender] = false;
        } else if(comments[id].disliked[sender]) {
            require(liked, "You have disliked this comment");
            comments[id].disliked[sender] = false;
        }
        emit LikeComment(id, sender, liked);
    }

    // called by owner
    
    function setMaxCommentLength(uint length) external onlyEnabled onlyOwner {
        context.maxLenOfComment = length;
    }

    function setMinCommentLength(uint length) external onlyEnabled onlyOwner {
        context.minLenOfComment = length;
    }

    function setIfAllowedDislikeComment(bool allowed) external onlyEnabled onlyOwner {
        context.allowedDislike = allowed;
    }

    // views

    function getCommentContext() external view returns (uint minLen, uint maxLen, bool allowedDislike) {
        minLen = context.minLenOfComment;
        maxLen = context.maxLenOfComment;
        allowedDislike = context.allowedDislike;
    }

    function getComment(uint id) external view returns (uint commentID, address sender, string comment, uint replyTo) {
        commentID = comments[id].id;
        sender = comments[id].sender;
        comment = comments[id].comment;
        replyTo = comments[id].replyTo;
    }

    function getCommentOwner(uint id) external view returns (address sender) {
        sender = comments[id].sender;
    }

    function isLikedComment(uint id, address sender) external view returns (bool) {
        return comments[id].liked[sender];
    }

    function isDislikedComment(uint id, address sender) external view returns (bool) {
        return comments[id].disliked[sender];
    }

    // Comments and Tag
}
