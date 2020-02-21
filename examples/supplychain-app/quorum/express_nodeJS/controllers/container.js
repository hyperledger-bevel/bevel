var express = require('express')
  , router = express.Router();

const {productContract, fromAddress} = require('../web3services');
var multer = require('multer'); // v1.0.5
var upload = multer(); // for parsing multipart/form-data
var bodyParser = require('body-parser');

router.use(bodyParser.json()); // for parsing application/json

//GET container with or without trackingID
router.get("/:trackingID?", function(req, res) {
  if (req.params.trackingID != null) {
    // TODO: Implement getContainerByID functionality
    const trackingID = req.params.trackingID;
    console.log(trackingID, "***");
    productContract.methods
      .getSingleContainer(req.params.trackingID)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then(response => {
        if(Object.keys(response.events).length !== 0 && response.events.sendObject) res.send(response.events.sendObject.returnValues[0]);
        else if(Object.keys(response.events).length !== 0 && response.events.sendString) res.send(response.events.sendString.returnValues[0]);
        else res.send(response);
      })
      .catch(error => {
        console.log(error);
        res.send("error");
      });
  } else {
    // TODO: Implement get all containers functionality
    // getContainers()
    productContract.methods
    .getAllContainers()
    .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000"})
    .then(response => {
      console.log(response);
      if(response.events.sendArray.returnValues) res.send(response.events.sendArray.returnValues[0]);
      else res.send(response);
    })
    .catch(err => {
      console.log(err);
      res.send(err);
    });
  }
});

//POST for new container
router.post("/", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement new container functionality
  let newContainer = {
    misc: req.body.misc,
    trackingID: req.body.trackingID,
    counterparties: req.body.counterparties.map(it =>
      it.indexOf("O=") != -1 ? it.split("O=")[1].split(",")[0] : it
    ) //filter out to only send org name
  }; //filter out to only send org
  var isInArray = false;
  if (newContainer.counterparties.includes(fromAddress)) {
    isInArray = true;
  }
  console.log(isInArray);
  if (isInArray) {
    productContract.methods
      .addContainer(
        "health",
        JSON.stringify(newContainer.misc),
        newContainer.trackingID,
        "",
        newContainer.counterparties
      )
      .send({ from: fromAddress, gas: 6721900, gasPrice: "30000000" })
      .on("receipt", function(receipt) {
        console.log(receipt);

        if (receipt.status === true) {
          if(receipt.events.sendObject) res.send(receipt.events.sendObject.returnValues[0]);
          else res.send(receipt);
        }
        if (receipt.status === false) {
          res.send("Transaction not successful");
        }
      })
      .catch(error => {
        res.send("error");
        console.log(error);
      });
  } else {
    res.send(
      "Transaction not sent. Your address is not in counterparties list"
    );
  }
});

//PUT for changing custodian
router.put("/:trackingID/custodian", function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement change custodian functionality
  var trackingID = req.params.trackingID;
  console.log(trackingID);
    productContract.methods
      .updateContainerCustodian(trackingID)
      .send({ from: fromAddress, gas: 6721975, gasPrice: "30000000" })
      .then( response => {
        res.send(response)
      })
      .catch(error => {
        console.log(error)
        res.send(error.message)
      })
});

//PUT for updatating contents
router.put("/:trackingID/package", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement update content packages
  // packageGood(req.params.trackingID,req.body)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
});

//PUT for removing contents
router.put("/:trackingID/unpackage", upload.array(), function(req, res) {
  res.setTimeout(15000);
  // TODO: Implement remove content from container
  // unPackageGood(req.params.trackingID,req.body)
  // .then( response => {
  //   res.send(response)
  // })
  // .catch(error => {
  //   console.log(error)
  //   res.send("error")
  // })
});

// PUT for package trackable
router.put("/:trackingID/package", function(req, res){

});
module.exports = router;
