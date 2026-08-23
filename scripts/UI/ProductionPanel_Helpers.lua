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

function GetCityQueueBuildings(playerID, cityID)
    local city = CityManager.GetCity(playerID, cityID)
    local queue = city:GetBuildQueue()
    local count = queue:GetSize()
    local queueBuildings = {}
    if count > 0 then
        for index = 0, count - 1 do
            local item = queue:GetAt(index)
            local buildingIndex = item.BuildingType
            if buildingIndex ~= nil then
                queueBuildings[buildingIndex] = true
            end
        end
    end
    return queueBuildings
end

-- ===========================================================================
--  Expose the functions to the Gameplay layer
-- ===========================================================================

ExposedMembers.ProductionPanelHelpers.CityHasStableGovernor = CityHasStableGovernor
ExposedMembers.ProductionPanelHelpers.GetCityDamPlots = GetCityDamPlots
ExposedMembers.ProductionPanelHelpers.GetCityQueueBuildings = GetCityQueueBuildings

print("=== Custom District Rules (Helpers) Loaded ===")
