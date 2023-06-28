


const TafitLotteryContract  = artifacts.require("tafitLottery")

module.exports = function (deployer){
// deployment steps
    deployer.deploy(TafitLotteryContract)
}