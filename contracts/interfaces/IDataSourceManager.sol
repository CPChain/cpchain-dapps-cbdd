pragma solidity ^0.4.24;

interface IDataSourceManager {
    /**
     * Triggered when user create a new data source
     * @param source_id source ID
     * @param sender address
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event CreateDataSourceEvent(uint source_id, address sender, string name, string desc,
        string version, string url);
    
    /**
     * Triggered when user update a data source
     * @param source_id source ID
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     */
    event UpdateDataSourceEvent(uint source_id, string name, string desc, string version, string url);

    /**
     * Triggered when user delete a data source
     * @param source_id source ID
     */
    event DeleteDataSourceEvent(uint source_id);

    /**
     * @param sender sender
     * @param source_id source ID
     */
    event LikeDataSourceEvent(address sender, uint source_id);

    /**
     * @param sender sender
     * @param source_id source ID
     */
    event CancelLikeDataSourceEvent(address sender, uint source_id);

    /**
     * @param sender sender
     * @param source_id source ID
     */
    event DislikeDataSourceEvent(address sender, uint source_id);

    /**
     * @param sender sender
     * @param source_id source ID
     */
    event CancelDislikeDataSourceEvent(address sender, uint source_id);

    /**
     * @param version version
     * @param contract_addr contract address
     */
    event RegisterDataSourceValidatorEvent(uint version, address contract_addr);

    /**
     * Create data source
     * Emits {CreateDataSourceEvent}
     * @param name unique name
     * @param desc description
     * @param version version
     * @param url unique url
     * @return sequence ID
     */
    function createDataSource(address sender, string name, string desc, string version, string url) external returns (uint);

    /**
     * Update name
     * Emits {UpdateDataSourceEvent}
     * @param id ID
     * @param name name
     * @param desc description
     * @param version version
     * @param url URL
     * @return ID
     */
    function updateDataSource(address sender, uint id, string name, string desc, string version, string url) external;

    /**
     * Delete data source
     * Emits {DeleteDataSourceEvent}
     * @param id ID
     * @return ID
     */
    function deleteDataSource(address sender, uint id) external;

    /**
     * Like a data source
     * 如果当前既没有 like，也没有 dislike，那么 liked 为 true 时，是 like
     * liked 为 false 时，是 dislike；
     * 如果当前为 like，那么 liked 为 false 时，是 cancel-like；否则报错
     * 如果当前为 dislike，那么 liked 为 true 时，是 cancel-dislike；否则报错
     * Emits {LikeDataSource, CancelLikeDataSource, DislikeDataSource, CancelDislikeDataSource}
     * @param source_id source ID
     */
    function likeDataSource(address sender, uint source_id, bool liked) external;

    // views
    function existsID(uint id) external view returns (bool);

    function existsName(string name) external view returns (bool);

    function isLiked(uint id, address sender) external view returns (bool);

    function isDisliked(uint id, address sender) external view returns (bool);

    function getDataSourceOwner(uint id) external view returns (address);

    function getDataSource(uint id) external view returns (uint source_id, address sender, string name, string desc,
        string version, string url);
}
