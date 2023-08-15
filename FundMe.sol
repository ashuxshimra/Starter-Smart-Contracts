    //Get funds from users can be in any bc token - avalanche, phantom etc
//Withdraw funds - can be done by only who deployed the contract
//Set a minimum funding value in USD
//smart contracts can hold funds just like how wallets can

// SPDX-License-Identifier: MIT 
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";//remix is smart enough to understand the imports of contratcs from chainlink so here done for V3 from docuimemnation of data feeds
contract FundMe {
uint256 public minimumUsd=50*1e18; //msg.value typecasted and will give 18 0's , hence this too
address[] public funders;
mapping (address=>uint256) public addressToAmountFunded;
function fund() public payable { //this payable will set tehe button red and payable implies some bc amount to receive or send
//want to be able to set a min fund amount in USD  
//  1. How do we send ETH to this contract
    // require(msg.value > minimumUsd, "Didn't send enough!!");//adding a statment that checkes if sent amount value is not more than 1 eth then revert back with the following messaage //1e18==1*10**18
    // in above msg.valuye is in terms of eth and minimumusd in terms of usd , so we need a minusd in terms of eth amount and this varies , also this value is somethinhg outside of bc hence we will use a decentralized n/w like oracle chainlink which will provide outside chain data
    //what is reverting
    //undo any action before, and send the remaining gas back

    require(getConversionRate(msg.value) >= minimumUsd, "Didn't send enough!!"); //that is entered amount for fund will be cinverted to usd and checked
    funders.push(msg.sender); //msg.value : how much eth amount or bc token sent , msg.sender - from which address amount was sent , here in metamask your acc no is msg.sender
    // list of funders done now lets have who funded how much amount hence we use mapping
    addressToAmountFunded[msg.sender]+=msg.value; //which address funded how much amount
    
  }
 function getPrice() public view returns(uint256)  {//this contract will give outside chain prices so for this we will need to access a contract from oracle chainlink n/w and thus for that we need ABI and address of that contract
 //address of that contract can be obtained from data feeds section from oracle chainlink and since we want price feed for eth/usd we can get it
//  0x694AA1769357215DE4FAC081bf1f309aDC325306 - address (obtained from datafeeds)
AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);//this V3 along with the address of data feed contract for particular n/w will give access to the sc of price feed , so u can use all the functions as defined in the V3 contract 
// also this V3 assumes that i address provided will have all the functionaloities as defined in the V3.
 (,int256 price,,,)=priceFeed.latestRoundData(); //at gitrepo check the funtion code , this function returns multiple thinghs buty we onluy care about price
//  ETH in terms of USD from above
// can give 3000.000000000 - but eth is in terms of wei uinit too so its like this 1eth=1.000000000000000000 but price we got is 8 decimal so we have to fix this
 return uint256(price * 1e10); //type casting into uint256
 }
//   we have something called as AggregatorV3 Interface - since we now have data feed oracle smartcontract address , now we need ABI so that we can interact with this sc and thus access the price and everything
// AggregatorV3 Interface provides us all the interface which doesnt have any implememntation but only the functions defined as interfaces , and that is what ABI is about that is what can the contract do hence we can use this along with the address of data feed which will allow us to access the sc and we can get price function from it for prices



function getVersion() public view returns (uint256) {
AggregatorV3Interface priceFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);//this V3 along with the address of data feed contract for particular n/w will give access to the sc of price feed , so u can use all the functions as defined in the V3 contract 
return priceFeed.version(); //here just getting version for sake of understanding
}


//now a function which takes eth amouint and converts into usd amount :
function getConversionRate(uint256 ethAmount) public view returns (uint256){
    uint256 ethPrice=getPrice(); //price of one eth in terms of usd
    uint256 ethAmountInUsd=(ethAmount * ethPrice) / 1e18; //total price of eth in terms of usd and this will give 18 decimals that is eth units
    return ethAmountInUsd;
}
// now that the contract can be funded let us withdraw the amount for personal purpose
function withdraw() public {
    for(uint256 funderIndex=0;funderIndex<funders.length;funderIndex++){ //traversing throught the funders array
       address funder =funders[funderIndex]; //this will give the address of funder
       addressToAmountFunded[funder]=0;     //simply mapping the value to 0 for every funder who funded amnount
    }
}


}