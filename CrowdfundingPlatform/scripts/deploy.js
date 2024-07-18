const { ethers, upgrades } = require("hardhat");
const fs = require('fs');

async function main() {
    //通过合约工厂创建合约对象
    const CrowdfundingPlatform = await ethers.getContractFactory("CrowdfundingPlatformV1");
    //通过代理的方式部署合约
    // 需要传递的地址
    const ownerAddress = "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266";
    const platform = await upgrades.deployProxy(CrowdfundingPlatform, [ownerAddress], { initializer: "initialize" });
    //等待合约执行
    await platform.waitForDeployment();
    //输出合约的地址
    console.log("CrowdfundingPlatform deployed to:", platform.target);
    // Save the contract address to a file
    fs.writeFileSync('./deployedAddress.txt', platform.target);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });