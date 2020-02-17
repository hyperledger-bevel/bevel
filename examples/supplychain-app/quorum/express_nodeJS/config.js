const dotenv = require('dotenv');
dotenv.config();
module.exports = {
  port: process.env.PORT,
  quorumServer : process.env.QUORUM_SERVER,
  nodeIdentity : process.env.NODE_IDENTITY,
  productContractAddress : process.env.PRODUCT_CONTRACT_ADDRESS
};
