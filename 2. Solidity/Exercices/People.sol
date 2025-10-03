// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.28;

contract People {
     struct Person {
        string name;
        uint8 age;
    }

    Person public moi = Person("Klem", 43);
    Person[] public persons;

    /**
    * Modify the existing "Person" member
    */
    function  modifyPerson(string memory _name, uint8 _age) public {
        moi.name = _name;
        moi.age = _age;
    }

    /**
    * Add a new Person to the person array
    */
    function addPerson(string memory _name, uint8 _age) public {
        persons.push(Person(_name, _age));
    }
    
    
    /**
    * Remove the last added Person fron the person array
    */
    function removeLastPerson() public {
        persons.pop();
    }
}