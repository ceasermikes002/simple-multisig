import fs from 'fs';
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("MultiSigDeployment", (m) => {
  const owners = [
    "0x1234567890123456789012345678901234567890", // Replace with actual address
    "0xabcdefabcdefabcdefabcdefabcdefabcdefabcdef", // Replace with actual address
    "0x9876543210987654321098765432109876543210"  // Replace with actual address
  ];

  const requiredApprovals = 2;

  console.log("Deploying SimpleMultiSig with owners:", owners);

  const multiSigContract = m.contract("SimpleMultiSig", [owners, requiredApprovals]);

  console.log("SimpleMultiSig deployed successfully!");

  return { multiSigContract };
});
