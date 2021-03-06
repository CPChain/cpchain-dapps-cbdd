pragma solidity ^0.4.24;

import "@cpchain-tools/cpchain-dapps-utils/contracts/lifecycle/Enable.sol";

import "../interfaces/IDataBaseManager.sol";
import "../interfaces/IVersion.sol";
import "./ControllerIniter.sol";
import "../interfaces/ICommentManager.sol";


contract DataBaseManager is Enable, IVersion, ControllerIniter, IDataBaseManager, ICommentManager {
    // context
    struct Context {
        uint version;
        bool allowedDislike;
        uint maxLenOfName;
        uint minLenOfName;
        uint maxLenOfDescription;
        uint minLenOfDescription;
        uint addressDataElementsUpper;
        uint seq;
    }
    Context internal context;

    // address count
    mapping(address => uint) internal addrElementsCnt;

    // Comment and tags
    ICommentManager commentManager;
    

    struct Element {
        uint id;
        address owner;
        string name;
        string desc;
        bool disabled;
        bool deleted;
        mapping(address => bool) liked;
        mapping(address => bool) disliked;
    }
    mapping(string => bool) private _name_set;
    mapping(uint => Element) private _elements;

    constructor(address commentAddress) public {
        require(commentAddress != address(0x0), "Comment manager can not be null");
        context.version = 0;
        context.allowedDislike = true;
        context.maxLenOfDescription = 200;
        context.minLenOfDescription = 1;
        context.maxLenOfName = 50;
        context.minLenOfName = 1;
        context.addressDataElementsUpper = 500;
        context.seq = 0;

        initBaseComment(commentAddress);
    }

    function initBaseComment(address baseComment) private {
        IControllerIniter initer = IControllerIniter(baseComment);
        // the contract should not has any controller inited it
        require(!initer.isInitedController(), "This contract have been inited by other controller");
        // init the contract
        initer.initController(address(this));

        commentManager = ICommentManager(baseComment);
    }

    modifier onlyNotExistsName(string name) {
        require(!_name_set[name], "Name of element have been exists!");
        _;
    }
    modifier onlyDataElementOwner(address sender, uint id) {
        require(_elements[id].owner == sender, "Only the owner of this data element can call it");
        _;
    }
    modifier onlyDataElementExists(uint id) {
        require(_elements[id].id > 0, "Data element does not exists!");
        require(!_elements[id].deleted, "Data element have been deleted");
        _;
    }
    modifier onlyDataElementEnabled(uint id) {
        require(!_elements[id].disabled, "Data element is diabled now");
        _;
    }

    function version() public view returns (uint) {
        return context.version;
    }

    modifier validateNameLength(string name) {
        uint length = bytes(name).length;
        require(length <= context.maxLenOfDescription && length >= context.minLenOfName,
            "Length of name is not in the range");
        _;
    }
    modifier validateDescLength(string desc) {
        uint length = bytes(desc).length;
        require(length <= context.maxLenOfDescription && length >= context.minLenOfDescription,
            "Length of desc is not in the range");
        _;
    }
    modifier elementsCntLessThanUpper(address sender) {
        require(addrElementsCnt[sender] < context.addressDataElementsUpper, "You have created too many elements");
        _;
    }

    function _nextSeq() internal returns (uint) {
        context.seq += 1;
        return context.seq;
    }

    function _createElement(address sender, string name, string desc) internal validateNameLength(name) validateDescLength(desc)
        onlyNotExistsName(name) elementsCntLessThanUpper(sender) returns (uint) {
        uint id = _nextSeq();
        _elements[id] = Element({
            id: id,
            owner: sender,
            name: name,
            desc: desc,
            disabled: false,
            deleted: false
        });
        addrElementsCnt[sender] ++;
        _name_set[name] = true;
        return id;
    }

    function _updateElement(address sender, uint id, string name, string desc) internal
        validateNameLength(name) validateDescLength(desc) onlyDataElementEnabled(id)
        onlyDataElementOwner(sender, id) onlyDataElementExists(id) {
        delete _name_set[_elements[id].name];
        _name_set[name] = true;
        _elements[id].name = name;
        _elements[id].desc = desc;
    }

    function _deleteElement(address sender, uint id) onlyDataElementExists(id)
        onlyDataElementOwner(sender, id) onlyDataElementEnabled(id) internal {
        _elements[id].deleted = true;
        delete _name_set[_elements[id].name];
    }

    function _likeElement(address sender, uint id, bool liked) internal onlyDataElementExists(id) onlyDataElementEnabled(id) {
        if (!_elements[id].liked[sender] && !_elements[id].disliked[sender]) {
            if (liked) {
                _elements[id].liked[sender] = true;
                emit LikeEvent(sender, id);
            } else {
                require(context.allowedDislike, "Don't allow dislike data element now");
                _elements[id].disliked[sender] = true;
                emit DislikeEvent(sender, id);
            }
        } else if(_elements[id].liked[sender]) {
            require(!liked, "You have liked this data element");
            _elements[id].liked[sender] = false;
            emit CancelLikeEvent(sender, id);
        } else if(_elements[id].disliked[sender]) {
            require(liked, "You have disliked this data element");
            _elements[id].disliked[sender] = false;
            emit CancelDislikeEvent(sender, id);
        }
    }

    function enableDataElement(uint id) external onlyEnabled onlyOwner onlyDataElementExists(id) {
        _elements[id].disabled = false;
        emit EnableDataElementEvent(id);
    }

    function disableDataElement(uint id) external onlyEnabled onlyOwner onlyDataElementExists(id) {
        _elements[id].disabled = true;
        emit DisableDataElementEvent(id);
    }

    function setIfAllowedDislike(bool allowed) external onlyEnabled onlyOwner {
        context.allowedDislike = allowed;
    }

    function setOneAddressUpperLimitOfDataElements(uint upper) external onlyEnabled onlyOwner {
        context.addressDataElementsUpper = upper;
    }

    function setMaxLengthOfName(uint length) external onlyEnabled onlyOwner {
        context.maxLenOfName = length;
    }

    function setMinLengthOfName(uint length) external onlyEnabled onlyOwner {
        context.minLenOfName = length;
    }

    function setMaxLengthOfDescription(uint length) external onlyEnabled onlyOwner {
        context.maxLenOfDescription = length;
    }

    function setMinLengthOfDescription(uint length) external onlyEnabled onlyOwner {
        context.minLenOfDescription = length;
    }

    function getIfAllowedDislike() external view returns (bool) {
        return context.allowedDislike;
    }

    function getUpperElementsPerAddress() external view returns (uint) {
        return context.addressDataElementsUpper;
    }

    function getLengthOfName() external view returns (uint min, uint max) {
        min = context.minLenOfName;
        max = context.maxLenOfName;
    }

    function getLengthOfDesc() external view returns (uint min, uint max) {
        min = context.minLenOfDescription;
        max = context.maxLenOfDescription;
    }

    // views
    function existsID(uint id) external view returns (bool) {
        return _elements[id].id > 0 && !_elements[id].deleted;
    }

    function existsName(string name) external view returns (bool) {
        return _name_set[name];
    }

    function isLiked(uint id, address sender) external view returns (bool) {
        return _elements[id].liked[sender];
    }

    function isDisliked(uint id, address sender) external view returns (bool) {
        return _elements[id].disliked[sender];
    }

    function getDataElementOwner(uint id) public view returns (address) {
        return _elements[id].owner;
    }

    function getDataElement(uint id) public view returns (uint source_id, address sender, string name, string desc) {
        source_id = _elements[id].id;
        sender = _elements[id].owner;
        name = _elements[id].name;
        desc = _elements[id].desc;
    }

    function isDisabled(uint id) external view returns (bool) {
        return _elements[id].disabled;
    }

    // Comment Manager

    function addComment(address sender, uint id, string comment) external onlyEnabled onlyController returns (uint) {
        return commentManager.addComment(sender, id, comment);
    }

    function updateComment(address sender, uint id, string comment) external onlyEnabled onlyController {
        return commentManager.updateComment(sender, id, comment);
    }

    function deleteComment(address sender, uint id) external onlyEnabled onlyController {
        return commentManager.deleteComment(sender, id);
    }

    function replyComment(address sender, uint targetID, string comment) external onlyEnabled onlyController returns (uint) {
        return commentManager.replyComment(sender, targetID, comment);
    }

    function likeComment(address sender, uint id, bool liked) external onlyEnabled onlyController {
        return commentManager.likeComment(sender, id, liked);
    }

    // views
    function getComment(uint id) external view returns (uint commentID, address sender, string comment, uint replyTo) {
        return commentManager.getComment(id);
    }

    function getCommentOwner(uint id) external view returns (address sender) {
        return commentManager.getCommentOwner(id);
    }

    function isLikedComment(uint id, address sender) external view returns (bool) {
        return commentManager.isLikedComment(id, sender);
    }

    function isDislikedComment(uint id, address sender) external view returns (bool) {
        return commentManager.isDislikedComment(id, sender);
    }

    // ----------- End -----------
}
