pragma solidity ^0.4.24;

// 可升级合约需实现此接口
interface IVersion {
    /**
     * @return version
     */
    function version() external view returns (uint);
}
