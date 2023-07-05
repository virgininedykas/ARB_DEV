import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/FlagsInterface.sol";



 function getThePrice(address _priceFeedAddress) public view returns (int) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_priceFeedAddress);

        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();

        return price;
    }
// Identifier of the Sequencer offline flag on the Flags contract 
address constant private FLAG_ARBITRUM_SEQ_OFFLINE = address(bytes20(bytes32(uint256(keccak256("chainlink.flags.arbitrum-seq-offline")) - 1)));
FlagsInterface internal chainlinkFlags;

constructor() {
    chainlinkFlags = FlagsInterface(0x491B1dDA0A8fa069bbC1125133A975BF4e85a91b);
}


    function getThePrice(address _priceFeedAddress) public view returns (int) {
        bool isRaised = chainlinkFlags.getFlag(FLAG_ARBITRUM_SEQ_OFFLINE);
        if (isRaised) {
            // If flag is raised we shouldn't perform any critical operations
            revert("Chainlink feeds are not being updated");
        }

        AggregatorV3Interface priceFeed = AggregatorV3Interface(_priceFeedAddress);
        (
            uint80 roundID, 
            int price,
            uint startedAt,
            uint updatedAt,
            uint80 answeredInRound
        ) = priceFeed.latestRoundData();
        return price;
    }

