const Voting = artifacts.require("Voting");
const { CANDIDATE } = require('./constant')
module.exports = function (deployer) {
  deployer.deploy(Voting, CANDIDATE);
};
