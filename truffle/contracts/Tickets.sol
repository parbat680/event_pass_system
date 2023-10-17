// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

    /*
        The EventTickets contract keeps track of the details and ticket sales of one event.
     */

contract EventTickets {

    /*
        Create a public state variable called owner.
        Use the appropriate keyword to create an associated getter function.
        Use the appropriate keyword to allow ether transfers.
     */
     address public owner;

    uint   TICKET_PRICE = 100000000 wei;

    struct Event{
        string description;
        string websiteUrl;
        uint totalTickets;
        uint sales;
        mapping (address => uint) buyers;
        bool isOpen;
    }

    Event myEvent;

    
    event LogBuyTickets(address purchaser, uint tickets);
    event LogGetRefund(address requester, uint tickets);
    event LogEndSale(address owner, uint balance);

    
    modifier onlyOwner(){ 
        require(
            msg.sender == owner,
            "Only owner can call this."
        ); 
        _;
      }
     
   
    constructor (string memory _description, string memory _websiteUrl, uint _totalTickets)  {
        owner = msg.sender;
        myEvent.description = _description;
        myEvent.websiteUrl = _websiteUrl;
        myEvent.totalTickets = _totalTickets;
        myEvent.isOpen = true;
        myEvent.sales = 0;
    }
    
   
    function readEvent() public view
    returns(string memory description, string memory website, uint totalTickets, uint sales, bool isOpen) 
    {
        return (myEvent.description, myEvent.websiteUrl, myEvent.totalTickets, myEvent.sales, myEvent.isOpen);
    }

   
    function getBuyerTicketCount(address buyer) public view returns(uint tickets)
    {
      tickets = myEvent.buyers[buyer];
      return tickets;
    }
     
    

    function buyTickets(uint tickets) payable external {
        require(myEvent.isOpen==true);
        require(msg.value >= tickets*TICKET_PRICE);
        require( tickets <= (myEvent.totalTickets - myEvent.sales) );
        

        myEvent.buyers[msg.sender] = tickets;
        myEvent.sales = myEvent.sales + tickets;
        address payable recipient = payable(msg.sender);
    uint256 refundAmount = msg.value - (tickets * TICKET_PRICE);
    recipient.transfer(refundAmount);
        emit LogBuyTickets(msg.sender,tickets);
    }
    
    /*
        Define a function called getRefund().
        This function allows someone to get a refund for tickets for the account they purchased from.
        TODO:
            - Check that the requester has purchased tickets.
            - Make sure the refunded tickets go back into the pool of avialable tickets.
            - Transfer the appropriate amount to the refund requester.
            - Emit the appropriate event.
    */

    function getRefund() public {
        require(myEvent.buyers[msg.sender]!=0 );
        

        uint ticketsPurchased = myEvent.buyers[msg.sender];
        myEvent.sales = myEvent.sales -  ticketsPurchased;
        address payable recipient = payable(msg.sender);
    uint256 refundAmount = (ticketsPurchased * TICKET_PRICE);
    recipient.transfer(refundAmount);
        
        emit LogGetRefund(msg.sender,ticketsPurchased);
    }
    
    /*
        Define a function called endSale().
        This function will close the ticket sales.
        This function can only be called by the contract owner.
        TODO:
            - close the event
            - transfer the contract balance to the owner
            - emit the appropriate event
    */
    function endSale() public payable{
        require(msg.sender==owner); 

        myEvent.isOpen = false;
        address payable recipient = payable(msg.sender);
    uint256 refundAmount =(myEvent.sales * TICKET_PRICE);
    recipient.transfer(refundAmount);
       
        emit LogEndSale(msg.sender,myEvent.sales*TICKET_PRICE);

    }
}