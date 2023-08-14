// SPDX-License-Identifier: MIT
//the sc can interact with each other and this is called composibility
pragma solidity^0.8.0;
import "contracts/SimpleStorage.sol"; //importing SS contract to deploy from this contract

contract StorageFactory {
    //lets deploy Simplestorage contract from this contract
    // SimpleStorage public simpleStorage;//creating new variable of type SimpleStorage sc
    
    SimpleStorage[] public simpleStorageArray;//for every new sc created lets keep them in a list of array

    //function to create new and deploy
    function createSimpleStorageContract() public {
       SimpleStorage simpleStorage= new SimpleStorage(); //creating new ss contract , now when we deploy Storage FAactory , this function will be there and we can interact with this function to create and deploy ss , creating a contract is like deploying it in a new address
       simpleStorageArray.push(simpleStorage); //pushing in array for list of newly created deployed sc 
    }
    //lets interact with the ss sc,
    //to interact with any contract we need 2 things:
    // 1- Address of contract 2-ABI-Application BVinary Interface
    
    function sfStore(uint256 _simpleStorageIndex, uint256 _simpleStorageNumber) public {
        //lets get address of SS contract and store in its object type , this object will have ABI too which comes with compilation itself so we need address
    SimpleStorage simpleStorage=simpleStorageArray[_simpleStorageIndex]; //in the array accessing the contract , which will be the address of that cointrat     
    //now we have both address and abi of ss sc so we can interact with it from here using simpleStorage object
    simpleStorage.store(_simpleStorageNumber);
    }
    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256){
         SimpleStorage simpleStorage=simpleStorageArray[_simpleStorageIndex];//similarly getting contract address
         simpleStorage.retrieve();
    }
}
