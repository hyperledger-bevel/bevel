var Web3 = require("web3");
var express = require("express"),
  router = express();
var bodyParser = require("body-parser");

web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

router.use(bodyParser.json()); // for parsing application/json
const port = 8000;
router.get("/", (req, res) => res.send("Hello World!"));
router.listen(port, () =>
  console.log(`Example app listening on port ${port}!`)
);

var address = "0x9561C133DD8580860B6b7E504bC5Aa500f0f06a7";
var abi = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "string",
        name: "ID",
        type: "string"
      }
    ],
    name: "productAdded",
    type: "event"
  },
  {
    constant: true,
    inputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256"
      }
    ],
    name: "supplyChain",
    outputs: [
      {
        internalType: "string",
        name: "productName",
        type: "string"
      },
      {
        internalType: "string",
        name: "health",
        type: "string"
      },
      {
        internalType: "bool",
        name: "sold",
        type: "bool"
      },
      {
        internalType: "bool",
        name: "recalled",
        type: "bool"
      },
      {
        internalType: "string",
        name: "custodian",
        type: "string"
      },
      {
        internalType: "string",
        name: "lastScannedAt",
        type: "string"
      },
      {
        internalType: "string",
        name: "trackingID",
        type: "string"
      },
      {
        internalType: "string",
        name: "containerID",
        type: "string"
      }
    ],
    payable: false,
    stateMutability: "view",
    type: "function"
  },
  {
    constant: false,
    inputs: [
      {
        internalType: "string",
        name: "_productName",
        type: "string"
      },
      {
        internalType: "string",
        name: "_health",
        type: "string"
      },
      {
        internalType: "bool",
        name: "_sold",
        type: "bool"
      },
      {
        internalType: "bool",
        name: "_recalled",
        type: "bool"
      },
      {
        internalType: "string",
        name: "_custodian",
        type: "string"
      },
      {
        internalType: "string",
        name: "_lastScannedAt",
        type: "string"
      },
      {
        internalType: "string",
        name: "_trackingID",
        type: "string"
      },
      {
        internalType: "string",
        name: "_containerID",
        type: "string"
      }
    ],
    name: "addProduct",
    outputs: [],
    payable: false,
    stateMutability: "nonpayable",
    type: "function"
  }
];

var productContract = new web3.eth.Contract(abi, address);

//POST METHODS

router.post("/product", function(req, res) {
  console.log("******", req.body);
  let newProduct = {
    productName: req.body.productName,
    misc: { name: req.body.misc.name },
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties
  };

  productContract.methods
    .addProduct(
      newProduct.productName,
      "",
      true,
      true,
      "",
      newProduct.trackingID,
      "",
      ""
    )
    .send({ from: "0x90F8bf6A479f320ead074411a4B0e7944Ea8c9C1" })
    .on("transactionHash", function(hash) {
      console.log("hash: " + hash);
    })
    .once("confirmation", function(confirmationNumber, receipt) {
      console.log("transaction mined: ");
    })
    .on("receipt", function(receipt) {
      // receipt example
      console.log(receipt);
      if (receipt.status === true) {
        res.send("Transaction successful");
      }
      if (receipt.status === false) {
        res.send("Transaction not successful");
      }
    })
    .on("error", function(error, receipt) {
      console.log("error" + JSON.stringify(error, null, 4));
      console.log(error);
    });
});

module.exports = router;
