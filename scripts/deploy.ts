// scripts/deploy.js
import { ethers } from "hardhat";

async function main() {
  // Set the owners of the multisig wallet
  const owners = [
    "0x40638C53D6EF529243A981844B7192744640DD40", // Replace with actual address
    "0xD7f9f54194C633F36CCD5F3da84ad4a1c38cB2cB", // Replace with actual address
    "0x20A67D77E0EC2FbAE278C6B16e3B95689bB42BbA"  // Replace with actual address
  ];

  // Number of approvals required
  const requiredApprovals = 2;

  // Get the contract factory
  const MultiSig = await ethers.getContractFactory("SimpleMultiSig");

  // Deploy the contract
  const multiSigContract = await MultiSig.deploy(owners, requiredApprovals);

  // Wait for the deployment to finish
  await multiSigContract.waitForDeployment();

  // Log the deployed contract address
  console.log("Deployed SimpleMultiSig contract at:", multiSigContract.target);
}

// Run the main function
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
