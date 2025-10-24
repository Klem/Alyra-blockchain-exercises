
# 🧪 Projet 2 — Tests Unitaires sur le Smart Contract *Voting*

Suite à ma question sur Discord et à la réponse de Ben, j’ai ajouté la fonction suivante pour récuperer le nombre de proposals :

```solidity
function getProposalsCount() external view returns (uint) {
    return proposalsArray.length;
}
```

---

## 🧭 Catégories de tests

* ✅ Vérification de l’état nominal post-construction
* 🔄 Vérification du **workflow** : rôles, validité des transitions, refus des transitions invalides
* 🌞 Vérification du **happy path** (*expect success*)
* 🌧️ Vérification du **sad path** (*expect revert*)
* ⚙️ Vérification de la **charge** (nombre élevé de propositions et de votants)
* ⚡ Je manque encore d’inspiration pour les **edge cases**...

---

## 🧾 Résultats des tests

### **Voting — Post Construct**

* ✔ Should set the deployer as the owner
* ✔ Should set the initial status at `RegisteringVoters`
* ⏸️ Should have no registered voters *(pending)*
* ✔ Should have no proposals

---

### **Voting Workflow**

#### Workflow Transitions

* ✔ should start proposals registering from `RegisteringVoters`
* ✔ should end proposals registering
* ✔ should start voting session
* ✔ should end voting session
* ✔ should tally votes session

#### Access Control (`onlyOwner`)

* ✔ should revert if non-owner calls `startProposalsRegistering`
* ✔ should revert if non-owner calls `endProposalsRegistering`
* ✔ should revert if non-owner calls `startVotingSession`
* ✔ should revert if non-owner calls `endVotingSession`
* ✔ should revert if non-owner calls `tallyVotes`

#### State Validation

* ✔ should revert `startProposalsRegistering` if not in `RegisteringVoters`
* ✔ should revert `endProposalsRegistering` if not started
* ✔ should revert `startVotingSession` if proposals not ended
* ✔ should revert `endVotingSession` if not started
* ✔ should revert `tallyVotes` if not started
* ✔ should not allow skipping workflow steps
* ✔ should not allow re-entering a closed phase
* ✔ should allow `tallyVotes` only once

---

### **Nominal Scenario — Happy Path**

* ✔ Should register the voter
* ✔ Should open the proposal submission, add a proposal, and close the submission period
* ✔ Should open the voting session, cast a vote, and close the voting session
* ✔ Should tally the votes
* ✔ Should return voter details correctly for a registered voter
* ✔ Should return proposal details correctly
* ✔ Should return correct proposal count

---

### **Nominal Scenario — Sad Path**

#### Getters

* ✔ Should revert if `getVoter` called by unregistered address
* ✔ Should revert if `getOneProposal` called by unregistered address
* ✔ Should revert if `getOneProposal` for invalid index

#### addVoter

* ✔ Should revert if called by non-owner
* ✔ Should revert if registration phase is closed
* ✔ Should revert if voter already registered

#### addProposal

* ✔ Should revert if called by unregistered voter
* ✔ Should revert if proposal description is empty

#### vote

* ✔ Should revert if called by unregistered voter
* ✔ Should revert if voter already voted
* ✔ Should revert if proposal does not exist

---

### **Edge**

* ✔ Should process voting even with dozens of voters and proposals

---

## 📊 Résumé d’exécution

```
40 passing (3s)
1 pending
```

---

## 📈 Couverture des tests

| Fichier 📦             | Lignes % 📈 | Statements % 📈 | Lignes non couvertes 🔍 | Lignes partiellement couvertes 🔍 |
| ---------------------- | ----------- | --------------- | ----------------------- | --------------------------------- |
| `contracts/Voting.sol` | 100.00      | 100.00          | -                       | -                                 |
| **Total**              | **100.00**  | **100.00**      |                         |                                   |

