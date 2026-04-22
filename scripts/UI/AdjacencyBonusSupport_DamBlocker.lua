-- ===========================================================================
--  Custom District Rules - UI Script
--  Provides Dam District based functionality to gameplay scripts.
-- ===========================================================================

ExposedMembers.DamValidator = ExposedMembers.DamValidator or {}

function ExposedMembers.DamValidator.GetCityDamPlots(playerID, cityID)
    local player = Players[playerID]
    local cities = player:GetCities()
    local city = cities:FindID(cityID)
    local districtHash = GameInfo.Districts["DISTRICT_DAM"].Hash
    return GetCityRelatedPlotIndexesDistrictsAlternative(city, districtHash)
end

print("=== Custom District Rules (DamBlocker) Loaded ===")
