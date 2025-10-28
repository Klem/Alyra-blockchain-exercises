import {network} from "hardhat";
import {expect} from "chai";
import {parseEther} from "ethers";

const {ethers} = await network.connect({
    network: "localhost",
});

async function setUpSmartContract() {
    const [owner, attacker] = await ethers.getSigners();

    const Auction = await ethers.getContractFactory("Auction", owner)
    const auction = await Auction.deploy()
    console.log("Auction contract deployed at " + await auction.getAddress())

    const AttackAuction = await ethers.getContractFactory("AttackAuction", attacker);
    const attack = await AttackAuction.deploy(auction.getAddress());
    console.log("AttackAuction contract deployed at " + await attack.getAddress())


    return {auction,attack};
}

describe("Test Suite", function () {

    let auction: any;
    let attack: any;


    beforeEach(async () => {
        ({auction, attack} = await setUpSmartContract());
    });

    it("Should have no highest bid balance at startup", async function () {
        expect(await auction.highestBid()).to.be.equals(0);
    });
    it("Should be successful to vulnerableBid once", async function () {
        let tx = await attack.wreckAuction({
            value: 1000000000
        });

        await tx.wait();
    });

    it("Should not be successful to vulnerableBid twice", async function () {
        let tx = await attack.wreckAuction({
            value: 1000000000
        });

        await tx.wait();

        await expect(
            attack.wreckAuction({
                value: 10000001000
            })
        ).to.be.revertedWith("refund of previous bidder failed");
    });

    it("Should not be successful to vulnerableBid a third time", async function () {
        let tx = await attack.wreckAuction({
            value: 1000000000
        });

        await tx.wait();

        await expect(
            attack.wreckAuction({
                value: 10000001000
            })
        ).to.be.revertedWith("refund of previous bidder failed");

        await expect(
            attack.wreckAuction({
                value: 10001000000
            })
        ).to.be.revertedWith("refund of previous bidder failed");
    });

});
