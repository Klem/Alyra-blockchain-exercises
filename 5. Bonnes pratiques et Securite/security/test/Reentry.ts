import {network} from "hardhat";
import {expect} from "chai";
import {parseEther} from "ethers";

const {ethers} = await network.connect({
    network: "localhost",
});

async function setUpSmartContract() {
    const [owner, attacker, noob] = await ethers.getSigners();

    const Vault = await ethers.getContractFactory("Vault", owner)
    const vault = await Vault.deploy()
    console.log("Vault contract deployed at " + vault.getAddress())

    const Reentry = await ethers.getContractFactory("ReentryAttack", attacker);
    const reentry = await Reentry.deploy(vault.getAddress());
    console.log("Reentry contract deployed at " + reentry.getAddress())
    // const vault = await ethers.getContractAt("Vault", " 0x5FbDB2315678afecb367f032d93F642f64180aa3")

    return {vault, reentry, owner, attacker, noob};
}

describe("Edge", function () {

    let vault: any;
    let reentry: any;
    let owner: any;
    let attacker: any;
    let noob: any;


    beforeEach(async () => {
        ({vault, reentry, owner, attacker, noob} = await setUpSmartContract());
    });

    it("Should have 0 balance at startup", async function () {
        expect(await vault.getBalance()).eq(0);
    });

    it("Should fund the vault", async function () {
        const deposit1 = await vault.connect(owner).store({
            value: ethers.parseEther("10")
        });

        const receipt1 = await deposit1.wait();

        console.log("Deposit tx: " + deposit1.hash)
        console.log("Deposit1 mined in block:", receipt1.blockNumber);

        expect(await vault.connect(owner).getBalance()).to.equal(ethers.parseEther("10"));

        const deposit2 = await vault.connect(noob).store({
            value: ethers.parseEther("5"),
        });

        const receipt2 = await deposit2.wait();
        console.log("Deposit tx: " + deposit2.hash)
        console.log("Deposit2 mined in block:", receipt2.blockNumber);

        expect(await vault.connect(noob).getBalance()).to.equal(ethers.parseEther("15"));
    });

    it("Should drain the vault", async function () {

        await reentry.connect(attacker).attack({
            value: ethers.parseEther("10"),
        });

        expect(await vault.connect(noob).getBalance()).to.equal(ethers.parseEther("0"));

    });
});
