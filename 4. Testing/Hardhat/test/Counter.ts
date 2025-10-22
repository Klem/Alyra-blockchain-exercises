import {expect} from "chai";
import {network} from "hardhat";

const {ethers} = await network.connect();

async function setUpSmartContract() {
    const counter = await ethers.deployContract("Counter");
    const [owner] = await ethers.getSigners();

    return {counter, owner};
}


describe("Counter contract", function () {
    describe.only("Tests simples", function () {
        let counter: any;
        let owner: any;

        beforeEach(async () => {
            ({counter, owner} = await setUpSmartContract());
        })

        it("Should emit the Increment event when calling the inc() function", async function () {
            await expect(counter.inc()).to.emit(counter, "Increment").withArgs(1n);
        });


        it("Should deploy with x == 0", async function () {
            // await to get result of function and not the related transaction
            expect(await counter.x()).to.equal(0n);
        });

        it("Should increment x = 1", async function () {
            await counter.inc();
            // await to get result of function and not the related transaction
            expect(await counter.x()).to.equal(1n);
        });

    });

    describe("Test complexe", function () {
        it.skip("The sum of the Increment events should match the current value", async function () {
            const counter = await ethers.deployContract("Counter");
            const deploymentBlockNumber = await ethers.provider.getBlockNumber();

            // run a series of increments
            for (let i = 1; i <= 10; i++) {
                await counter.incBy(i);
            }

            const events = await counter.queryFilter(
                counter.filters.Increment(),
                deploymentBlockNumber,
                "latest",
            );

            // check that the aggregated events match the current value
            let total = 0n;
            for (const event of events) {
                total += event.args.by;
            }

            expect(await counter.x()).to.equal(total);
        });

    });

});
