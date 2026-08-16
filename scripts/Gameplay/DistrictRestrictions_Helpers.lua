-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around district restrictions.
-- ===========================================================================

include("DistrictRestrictions_Config")

playerUniqueDistricts = {}

function getCityHasDistrict(playerID, cityDistricts, districtType)
    local uniqueDistricts = playerUniqueDistricts[playerID]
    local checkDistrict = uniqueDistricts[districtType]
    if checkDistrict then
        districtType = checkDistrict
    end
    return cityDistricts:HasDistrict(GameInfo.Districts[districtType].Index)
end

function hasCityBuiltPrimaryDistricts(playerID, cityDistricts)
    if not (
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_COMMERCIAL_HUB") or
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_HARBOR")
    ) then
        return false
    end

    if not getCityHasDistrict(playerID, cityDistricts, "DISTRICT_INDUSTRIAL_ZONE") then
        return false
    end

    if not getCityHasDistrict(playerID, cityDistricts, "DISTRICT_THEATER") then
        return false
    end

    if not (
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_ENTERTAINMENT_COMPLEX") or
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_WATER_ENTERTAINMENT_COMPLEX")
    ) then
        return false
    end

    if not (
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_ENCAMPMENT") or
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_CAMPUS") or
        getCityHasDistrict(playerID, cityDistricts, "DISTRICT_HOLY_SITE")
    ) then
        return false
    end
    return true
end

function getTierData()
    local prereqData = {}
    for row in GameInfo.BuildingPrereqs() do
        prereqData[row.Building] = row.PrereqBuilding
    end
    local data = {}
    for building in GameInfo.Buildings() do
        local districtType = building.PrereqDistrict

        if districtType ~= nil then
            -- Initialize the district sub-table if it doesn't exist
            if not data[districtType] then
                data[districtType] = {}
            end

            -- Calculate tier by tracing prerequisites
            local tier = 1
            local currentBuildingType = building.BuildingType

            -- Trace back through BuildingPrereqs
            while currentBuildingType do
                currentBuildingType = prereqData[currentBuildingType];
                if currentBuildingType ~= nil then
                    tier = tier + 1;
                end;
            end

            -- Store the result: data["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            data[districtType][building.BuildingType] = tier
        end
    end
    return data
end

tierData = getTierData()

function getTierForBuilding(buildingType, districtType)
    if districtType == nil then
        districtType = GameInfo.Buildings[buildingType].DistrictType
    end

    local districtTierData = tierData[districtType]
    if districtTierData ~= nil then
        return districtTierData[buildingType]
    end

    return nil
end

function getEraForDistrict(districtType)
    local districtEraData = eraConfigPerDistrict[districtType]
    if not districtEraData then
        return nil
    end

    return districtEraData["0"]
end

function getEraForBuilding(districtType, buildingType)
    local districtEraData = eraConfigPerDistrict[districtType]
    if not districtEraData then
        return nil
    end

    local buildingRestriction = districtEraData[buildingType]
    if buildingRestriction ~= nil then
        return buildingRestriction
    end
    local tierNumber = getTierForBuilding(buildingType, districtType)
    if tierNumber == nil then
        return nil
    end

    return districtEraData[tostring(tierNumber)]
end

function getPlayerUniqueDistricts(playerID)
    data = {}
    local playerConfig = PlayerConfigurations[playerID]
    local civType = playerConfig:GetCivilizationTypeName()

    for row in GameInfo.DistrictReplaces() do
        local traitType = GameInfo.Districts[row.CivUniqueDistrictType].TraitType
        for civTraitRow in GameInfo.CivilizationTraits() do
            if (
                civTraitRow.CivilizationType == civType and
                traitType == civTraitRow.TraitType
            ) then
                data[row.ReplacesDistrictType] = row.CivUniqueDistrictType
                data[row.CivUniqueDistrictType] = row.ReplacesDistrictType
            end
        end
    end
    return data
end

function loadPropertyToTable(propertyKey, tableObject, value, mutatingFunction)
    local dataStr = Game.GetProperty(propertyKey)
    if dataStr ~= nil then
        for id in string.gmatch(dataStr, "([^,]+)") do
            if mutatingFunction ~= nil then
                id = mutatingFunction(id)
            end
            tableObject[id] = value
        end
    end
end

stableGovernorBuildings = {
    ["BUILDING_JNR_MINT"] = true,
    ["BUILDING_JNR_ALTAR"] = true
}

function restrictForStableGovernor(playerID, cityID, buildingType)
    local buildingCheck = stableGovernorBuildings[buildingType]
    local hasStableGovernor = ExposedMembers.ProductionPanelHelpers.CityHasStableGovernor(
        playerID,
        cityID
    )
    if hasStableGovernor then
        if buildingCheck then
            return false, nil
        else
            return true, "Restricted due to stable governor."
        end
    else
        if buildingCheck then
            return true, "Only allowed for cities with a stable governor."
        end
    end
    return nil, nil
end

print("=== Custom District Rules (Helpers) Loaded ===")
