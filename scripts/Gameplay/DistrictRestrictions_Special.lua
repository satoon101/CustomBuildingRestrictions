-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around district restrictions.
-- ===========================================================================

function restrictWindMill(playerID, cityID, districtType)
    local player = Players[playerID];
    local cities = player:GetCities();
    local city = cities:FindID(cityID);
    local districts = city:GetDistricts();
    local district = districts:GetDistrictByType(GameInfo.Districts[districtType].Index)
    local plot = Map.GetPlot(district:GetX(), district:GetY())
    if plot:IsRiver() then
        return true, "Blocked in favor of the Water Mill"
    end
    return false, nil
end

GUILDS_INDEX = GameInfo.Civics["CIVIC_GUILDS"].Index

function restrictCommercialTier1(playerID, cityID, _, buildingType)
    local bCheck, strMessage = restrictForStableGovernor(
        playerID,
        cityID,
        buildingType
    )
    if bCheck ~= nil then
        return bCheck, strMessage
    end

    local player = Players[playerID]
    local civics = player:GetCulture()
    local hasGuildsCivic = civics:HasCivic(GUILDS_INDEX)
    if hasGuildsCivic then
        if buildingType == "BUILDING_MARKET" then
            return false, nil
        else
            return true, "Restricted now that civ has the Guilds Civic."
        end
    else
        if buildingType == "BUILDING_JNR_WAYSTATION" then
            return false, nil
        else
            return true, "Restricted until civ has the Guilds Civic."
        end
    end
end

function restrictHolySiteTier1(playerID, cityID, _, buildingType)
    return restrictForStableGovernor(
        playerID,
        cityID,
        buildingType
    )
end

g_DaVinciActivated = false

function restrictWorkshopForDaVinci()
    if not g_DaVinciActivated then
        return true, "Cannot be built until DaVinci has been activated."
    end
    return false, nil
end

civicTierForWonder = {
    ["BUILDING_HERMITAGE"] = 2,
    ["BUILDING_BOLSHOI_THEATRE"] = 3,
    ["BUILDING_BROADWAY"] = 4,
}
CIVIC_TIERS_ENABLED_KEY = "CIVIC_TIERS_ENABLED"
g_TiersEnabled = {}

function restrictCivicSquareByTier(_, cityID, districtType, buildingType)
    local function getBuildingIsAllowed()
        local tierNumber = getTierForBuilding(buildingType, districtType)
        if tierNumber == nil then
            return true
        end

        for _, tier in pairs(g_TiersEnabled) do
            if tier == tierNumber then
                return true
            end
        end

        local wonder = ExposedMembers.MapPins.GetCityWonderFromMapPins(cityID)
        if wonder == nil then
            return false
        end

        local maxTierAllowed = civicTierForWonder[wonder] or 0
        if maxTierAllowed < tierNumber then
            return false
        end

        return true
    end

    if not getBuildingIsAllowed() then
        return true, "Tier not allowed, yet, for city."
    end
    return false, nil
end

function restrictCivicSquareMuseums(_, cityID, _, buildingType)
    if g_MuseumOfAntiquityCount == 0 then
        return true, "Prerequisite Civic has not been researched."
    end

    local cityCheck = g_MuseumOfAntiquityCityTable[cityID]
    if cityCheck == nil then
        return false, nil
    end

    if #g_MuseumOfAntiquityCityArray >= g_MuseumOfAntiquityCount then
        if buildingType == MUSEUM_OF_ARCHAEOLOGY_INDEX then
            return true, "Number of museums allowed has been reached."
        end
    else
        if buildingType == MUSEUM_OF_ART_INDEX then
            return true, "Number of Archaeological Museums has not been met."
        end
    end
    return false, nil
end

print("=== Custom District Rules (Special) Loaded ===")
