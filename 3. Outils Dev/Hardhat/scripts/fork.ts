import { network } from "hardhat";

const { ethers } = await network.connect({
    network: "localhost",
});

// ✅ IMPERSONATION DE VITALIK - ENVOIE 0.1 ETH À VOTRE COMPTE
async function main(): Promise<void> {
    // 1. Récupère VOTRE compte Hardhat (1er du keystore)
    const [sender] = await ethers.getSigners();

    // 2. IMPERSONNE Vitalik sur Sepolia (contrôle total GRATUIT)
    const impersonatedSigner = await ethers.getImpersonatedSigner("0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045");

    // 3. VÉRIFIE SOLDE VITALIK (en wei)
    const balance1 = await ethers.provider.getBalance(impersonatedSigner.address);
    console.log(`Le solde de vitalik est de : ${balance1} wei`);

    // 4. VÉRIFIE VOTRE SOLDE INITIAL (en wei)
    const balance2 = await ethers.provider.getBalance(sender.address);
    console.log(`Mon ancien solde (amon address  ${sender.address} ) est de : ${balance2} wei`);

    // 5. TRANSACTION: Vitalik → Vous : 0.1 ETH
    //    Calcul: 1n * 10^17 = 100,000,000,000,000,000 wei = 0.1 ETH
    const tx = await impersonatedSigner.sendTransaction({
        to: sender.address,                    // Destinataire: VOTRE adresse
        value: 1n * 1n ** 17n,                // Montant: 0.1 ETH
    });

    // 6. ATTEND confirmation blockchain (1 bloc)
    await tx.wait();
    console.log(`Transfert effectué, 1 wei envoyé à ${sender.address}`); // ❌ ERREUR: c'est 0.1 ETH !

    // 7. VÉRIFIE VOTRE NOUVEAU SOLDE (+0.1 ETH)
    const balance3 = await ethers.provider.getBalance(sender.address);
    console.log(`Mon nouveau solde est de : ${balance3} wei`);
}

// 8. GESTION ERREURS: Affiche + Arrête si échec
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});