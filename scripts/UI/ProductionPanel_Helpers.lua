-- ===========================================================================
--  Custom District Rules - UI Script
--  Provides Dam District based functionality to gameplay scripts.
-- ===========================================================================

ExposedMembers.ProductionPanelHelpers = ExposedMembers.ProductionPanelHelpers or {}

function GetCityDamPlots(playerID, cityID)
    local player = Players[playerID]
    local cities = player:GetCities()
    local city = cities:FindID(cityID)
    local districtHash = GameInfo.Districts["DISTRICT_DAM"].Hash
    return GetCityRelatedPlotIndexesDistrictsAlternative(city, districtHash)
end

ExposedMembers.ProductionPanelHelpers.GetCityDamPlots = GetCityDamPlots

VICTOR_INDEX = GameInfo.Governors["GOVERNOR_THE_DEFENDER"].Index
AMANI_INDEX = GameInfo.Governors["GOVERNOR_THE_AMBASSADOR"].Index
MOKSHA_INDEX = GameInfo.Governors["GOVERNOR_THE_CARDINAL"].Index
MAGNUS_INDEX = GameInfo.Governors["GOVERNOR_THE_RESOURCE_MANAGER"].Index
LIANG_INDEX = GameInfo.Governors["GOVERNOR_THE_BUILDER"].Index
PINGALA_INDEX = GameInfo.Governors["GOVERNOR_THE_EDUCATOR"].Index
REYNA_INDEX = GameInfo.Governors["GOVERNOR_THE_MERCHANT"].Index

stableGovernors = {
    [VICTOR_INDEX] = false,
    [AMANI_INDEX] = false,
    [MOKSHA_INDEX] = true,
    [MAGNUS_INDEX] = false,
    [LIANG_INDEX] = true,
    [PINGALA_INDEX] = true,
    [REYNA_INDEX] = false,
}

function CityHasStableGovernor(playerID, cityID)
    local player = Players[playerID]
    local cities = player:GetCities()
    local city = cities:FindID(cityID)
    local governor = city:GetAssignedGovernor()
    if governor == nil then
        return false
    end

    return stableGovernors[governor:GetType()] or false
end

ExposedMembers.ProductionPanelHelpers.CityHasStableGovernor = CityHasStableGovernor

print("=== Custom District Rules (Helpers) Loaded ===")
