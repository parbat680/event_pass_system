/*
  Try `truffle exec scripts/increment.js`, you should `truffle migrate` first.

  Learn more about Truffle external scripts: 
  https://trufflesuite.com/docs/truffle/getting-started/writing-external-scripts
*/

const Tickets = artifacts.require("Tickets");

module.exports = async function (callback) {
    const deployed = await Tickets.deployed();

    const currentValue = (await deployed.readEvent());
    console.log(`Current Event: ${currentValue}`);

    //   const { tx } = await deployed.write(currentValue + 1);
    //   console.log(`Confirmed transaction ${tx}`);

    //   const updatedValue = (await deployed.read()).toNumber();
    //   console.log(`Updated Tickets value: ${updatedValue}`);

    callback();
};
