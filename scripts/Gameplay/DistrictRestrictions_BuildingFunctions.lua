-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around unique building restrictions.
-- ===========================================================================

include("DistrictRestrictions_Constants")

function RestrictWindMill(playerID, cityID, _, _, _, _)
    if ExposedMembers.ProductionPanelHelpers.CanCityBuildBuilding(
        playerID,
        cityID,
        "BUILDING_JNR_IZ_WATER_MILL"
    ) then
        return true, "Blocked in favor of the Water Mill"
    end
    return false, nil
end

function RestrictForStableGovernor(playerID, cityID, _, _, _, baseBuildingType)
    local buildingCheck = StableGovernorBuildings[baseBuildingType]
    local hasStableGovernor = ExposedMembers.ProductionPanelHelpers.CityHasStableGovernor(
        playerID,
        cityID
    )
    if hasStableGovernor then
        if not buildingCheck then
            return true, "Restricted due to stable governor."
        end
    elseif buildingCheck then
        return true, "Only allowed for cities with a stable governor."
    end
    return nil, nil
end

function RestrictForTier2HolySite(playerID, cityID, _, _, _, baseBuildingType)
    if CityMountainCounts[playerID] == nil then
        CityMountainCounts[playerID] = {}
    end

    if CityMountainCounts[playerID][cityID] == nil then
        local city = CityManager.GetCity(playerID, cityID)
        local plots = Map.GetNeighborPlots(city:GetX(), city:GetY(), 3)
        local mountainCount = 0
        for _, plot in ipairs(plots) do
            if plot:IsMountain() then
                mountainCount = mountainCount + 1
            end
        end
        CityMountainCounts[playerID][cityID] = mountainCount
    end
    if CityMountainCounts[playerID][cityID] >= 4 then
        if baseBuildingType == "BUILDING_TEMPLE" then
            return true, "Enough mountains to prioritize the Monastery"
        end
    elseif baseBuildingType == "BUILDING_JNR_MONASTERY" then
        return true, "Not enough mountains to prioritize the Monastery"
    end
end

function restrictCivicSquareMuseums(_, cityID, _, buildingType)
    if MuseumOfAntiquityCount == 0 then
        return true, "Prerequisite Civic has not been researched."
    end

    local cityCheck = MuseumOfAntiquityCityTable[cityID]
    if cityCheck ~= nil then
        return false, nil
    end

    local buildingIndex = GameInfo.Buildings[buildingType].Index
    if #MuseumOfAntiquityCityTable >= MuseumOfAntiquityCount then
        if buildingIndex == MUSEUM_OF_ARCHAEOLOGY_INDEX then
            return true, "Number of museums allowed has been reached."
        end
    else
        if buildingIndex == MUSEUM_OF_ART_INDEX then
            return true, "Number of Archaeological Museums has not been met."
        end
    end
    return false, nil
end

print("=== Custom District Rules (BuildingFunctions) Loaded ===")
