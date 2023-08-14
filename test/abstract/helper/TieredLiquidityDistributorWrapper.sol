// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/console2.sol";

import { TieredLiquidityDistributor, Tier, fromUD34x4toUD60x18, convert } from "../../../src/abstract/TieredLiquidityDistributor.sol";

contract TieredLiquidityDistributorWrapper is TieredLiquidityDistributor {
  constructor(
    uint8 _numberOfTiers,
    uint8 _tierShares,
    uint8 _reserveShares
  ) TieredLiquidityDistributor(_numberOfTiers, _tierShares, _reserveShares) {}

  function nextDraw(uint8 _nextNumTiers, uint96 liquidity) external {
    _nextDraw(_nextNumTiers, liquidity);
  }

  function consumeLiquidity(uint8 _tier, uint104 _liquidity) external returns (Tier memory) {
    Tier memory _tierData = _getTier(_tier, numberOfTiers);
    return _consumeLiquidity(_tierData, _tier, _liquidity);
  }

  function remainingTierLiquidity(uint8 _tier) external view returns (uint112) {
    uint8 shares = tierShares;
    Tier memory tier = _getTier(_tier, numberOfTiers);
    return
      uint112(
        convert(
          _getTierRemainingLiquidity(
            shares,
            fromUD34x4toUD60x18(tier.prizeTokenPerShare),
            fromUD34x4toUD60x18(prizeTokenPerShare)
          )
        )
      );
  }

  function findHighestNumberOfTiersWithEstimatedPrizesLt(uint32 _prizeCount) external view returns (uint8) {
    uint8 result = _findHighestNumberOfTiersWithEstimatedPrizesLt(_prizeCount);
    return result;
  }

  function getTierLiquidityToReclaim(uint8 _nextNumberOfTiers) external view returns (uint256) {
    return
      _getTierLiquidityToReclaim(
        numberOfTiers,
        _nextNumberOfTiers,
        fromUD34x4toUD60x18(prizeTokenPerShare)
      );
  }
}
