import {network} from "hardhat";
import { abi as ERC20 } from "@openzeppelin/contracts/build/contracts/ERC20.json";
const {ethers} = await network.connect({
    network: "localhost",
});

async function main(): Promise<void> {
    console.log("Connecting to testnet USDC contract");
    // Use ERC20 interface (works for ANY ERC20 token)
    const usdc = await ethers.getContractAt(ERC20, "0xaddd620ea6d20f4f9c24fff3bc039e497cebedc2");

    // All methods work perfectly!
    console.log("Name:", await usdc.name());                    // "USD Coin"
    console.log("Symbol:", await usdc.symbol());                // "USDC"
    console.log("Decimals:", await usdc.decimals());            // 6
    console.log("Total Supply:", ethers.formatUnits(await usdc.totalSupply(), 6));

    const [signer] = await ethers.getSigners();
    let signerBalance = await usdc.balanceOf(signer.address);
    console.log("Your Balance:", ethers.formatUnits(signerBalance, 6), "USDC");

    const impersonatedSigner = await ethers.getImpersonatedSigner("0x661bA32eb5f86CaB358DDbB7F264b10c5825e2dd");
    let impersonatedBalance = await usdc.balanceOf(impersonatedSigner.address);
    console.log("impersonatedSigner Balance:", ethers.formatUnits(impersonatedBalance, 6), "USDC");

    console.log("Transferring tokens.....")
    const value = ethers.parseUnits("100", 6);

    // @ts-ignore
    const tx = await usdc.connect(impersonatedSigner).transfer(signer.address,value);

    console.log(`Transfert completed, ${ethers.formatUnits(value, 6)} USDC  sent to ${signer.address}`);

    signerBalance = await usdc.balanceOf(signer.address);
    console.log(`Your new balance is : ${ethers.formatUnits(signerBalance, 6)} USDC `);
    console.log("Approving tokens.....");

    // @ts-ignore
    await usdc.connect(impersonatedSigner).approve(signer.address, value);
    console.log(`${impersonatedSigner.address} approved allowance of  ${ethers.formatUnits(value, 6)} usdc to ${signer.address}`);

    // @ts-ignore
    await usdc.connect(signer).transferFrom(impersonatedSigner.address, signer.address, value);
    console.log(`${signer.address} received  ${ethers.formatUnits(value, 6)} usdc transfered from ${impersonatedSigner.address}`);

    signerBalance = await usdc.balanceOf(signer.address);
    impersonatedBalance = await usdc.balanceOf(impersonatedSigner.address);

    console.log(`Your new balance is : ${ethers.formatUnits(signerBalance, 6)} USDC `);
    console.log(`ImpoersonatedSigner balance is ${ethers.formatUnits(impersonatedBalance, 6)} USDC `);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});