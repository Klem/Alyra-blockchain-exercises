// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract People {
     struct Person {
        string name;
        uint8 age;
    }

    Person public moi = Person("Klem", 43);

    function  modifyPerson(string memory _name, uint8 _age) public {
        moi.name = _name;
        moi.age = _age;
    }
}