pragma solidity 0.6.1;

contract newProductContract {
    
    uint256 public count = 0;
    
   //  Product[] public supplyChain; //declaring an array of Products called supplyChain
   
    mapping(uint => Product) public supplyChain;
    mapping(uint => Transaction) public transactionHistory;
    mapping(uint => string) public miscellaneous;
    
    mapping(string => string) public counterparties;
    
    
   // string[] public counterparties; //history of previous owners


    address manufacturer;

    modifier onlyManufacturer() {
        require(msg.sender == manufacturer);
        _;
    }
    

    struct Product{
        string productName;
        string health;
        bool sold;
        bool recalled;
        string custodian; //who currently owns the product
        string lastScannedAt;
        string trackingID;
        
        //misc: Map<String,Any>;
        
    }
    

    struct Transaction{
            uint256 timestamp;
            string containerID;
    }
    
    
    event productAdded (string ID);
   
    
    
     constructor() public{
        manufacturer = msg.sender;
    }
    
    
    function addProduct(string memory _productName, string memory _health, bool _sold, 
                        bool _recalled, string memory _custodian, string memory _lastScannedAt, 
                        string memory _trackingID, string memory _containerID, string memory message) public onlyManufacturer {
      uint256 _timestamp = block.timestamp;
      
      //  supplyChain.push(Product(_productName,_health,_sold,_recalled,_custodian,_lastScannedAt,_trackingID,_containerID));
        count += 1;
        supplyChain[count] = (Product(_productName,_health,_sold,_recalled,_custodian,_lastScannedAt,_trackingID));
        emit productAdded(_trackingID);
        
        transactionHistory[count] = (Transaction(_timestamp, _containerID));
        
        counterparties[_trackingID] = _custodian;
        miscellaneous[count] = message;
        

    }
    
    
    
}