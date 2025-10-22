import { network } from "hardhat";

const { ethers } = await network.connect({
    network: "localhost",
});

async function main(): Promise<void> {
    console.log("Connexion en cours.....");

    const voting = await ethers.getContractAt("Voting","0x5FbDB2315678afecb367f032d93F642f64180aa3");

    const [voter1, voter2] = await ethers.getSigners();
    console.log("Voter1 "+ voter1+", voter2 "+ voter2);

    const tx1 = await voting.addVoter("0x3c44cdddb6a900fa2b585dd299e03d12fa4293bc");
    tx1.wait();

    const tx2 = await voting.startProposalsRegistering();
    tx2.wait();

    const tx3 = await voting.startProposalsRegistering();
    tx3.wait();

    const tx4 = await voting.connect(voter2).addProposal("Des frites a la cantine");
    tx4.wait();

}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});