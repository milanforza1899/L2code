// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "./Project.sol";

contract CrowdfundingPlatformV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    address[] public projects;

    event ProjectCreated(address projectAddress, address creator, string description, uint256 goalAmount, uint256 deadline);

    //代理初始化
    function initialize(address initialOwner) public initializer {
        __Ownable_init(initialOwner);
        __UUPSUpgradeable_init();
    }

    // 需要此方法来防止未经授权的升级，因为在 UUPS 模式中，升级是从实现合约完成的，而在透明代理模式中，升级是通过代理合约完成的
    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function createProject(string memory _description, uint256 _goalAmount, uint256 _duration) public {
        Project newProject = new Project();
        newProject.initialize(msg.sender, _description, _goalAmount, _duration);
        projects.push(address(newProject));

        emit ProjectCreated(address(newProject), msg.sender, _description, _goalAmount, block.timestamp + _duration);
    }

    function getProjects() public view returns (address[] memory) {
        return projects;
    }
}