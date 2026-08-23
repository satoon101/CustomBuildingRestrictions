-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around district restrictions.
-- ===========================================================================

include("DistrictRestrictions_Config")

ExposedMembers.CustomDistrictRules = ExposedMembers.CustomDistrictRules or {}

PlayerUniqueDistricts = {}

function GetCityHasDistrict(playerID, cityDistricts, districtType)
    local uniqueDistricts = PlayerUniqueDistricts[playerID]
    local checkDistrict = uniqueDistricts[districtType]
    if checkDistrict then
        districtType = checkDistrict
    end
    return cityDistricts:HasDistrict(GameInfo.Districts[districtType].Index)
end

function HasCityBuiltPrimaryDistricts(playerID, cityDistricts)
    if not (
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_COMMERCIAL_HUB") or
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_HARBOR")
    ) then
        return false
    end

    if not GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_INDUSTRIAL_ZONE") then
        return false
    end

    if not GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_THEATER") then
        return false
    end

    if not (
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_ENTERTAINMENT_COMPLEX") or
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_WATER_ENTERTAINMENT_COMPLEX")
    ) then
        return false
    end

    if not (
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_ENCAMPMENT") or
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_CAMPUS") or
        GetCityHasDistrict(playerID, cityDistricts, "DISTRICT_HOLY_SITE")
    ) then
        return false
    end
    return true
end

function GetTierData()
    local prereqData = {}
    for row in GameInfo.BuildingPrereqs() do
        prereqData[row.Building] = row.PrereqBuilding
    end
    local dataByBuildingType = {}
    local dataByTier = {}
    for building in GameInfo.Buildings() do
        local districtType = building.PrereqDistrict

        if districtType ~= nil then
            -- Initialize the district sub-table if it doesn't exist
            if not dataByBuildingType[districtType] then
                dataByBuildingType[districtType] = {}
                dataByTier[districtType] = {}
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

            -- Store the result: dataByBuildingType["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            -- Store the result: dataByBuildingType["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            dataByBuildingType[districtType][building.BuildingType] = tier

            if dataByTier[districtType][tier] == nil then
                dataByTier[districtType][tier] = {}
            end
            -- Store the result: dataByTier["DISTRICT_CAMPUS"][1] = {"BUILDING_LIBRARY", "BUILDING_SHCOOL"}
            table.insert(dataByTier[districtType][tier], building.BuildingType)
        end
    end
    return dataByBuildingType, dataByTier
end

TierByBuildingType, BuildingTypesByTier = GetTierData()

function YieldBuildingTypeByTier(districtType)
    local tierData = BuildingTypesByTier[districtType]
    if tierData == nil then
        return
    end

    return coroutine.wrap(function()
        local count = #tierData
        for i = 1, count do
            for _, row in ipairs(tierData[i]) do
                coroutine.yield(row)
            end
        end
    end)
end

function GetTierForBuilding(buildingType, districtType)
    if districtType == nil then
        districtType = GameInfo.Buildings[buildingType].DistrictType
    end

    local districtTierData = TierByBuildingType[districtType]
    if districtTierData ~= nil then
        return districtTierData[buildingType]
    end

    return nil
end

function GetEraForDistrict(districtType)
    local districtEraData = eraConfigPerDistrict[districtType]
    if not districtEraData then
        return nil
    end

    return districtEraData["0"]
end

function GetEraForBuilding(districtType, buildingType)
    local districtEraData = eraConfigPerDistrict[districtType]
    if not districtEraData then
        return nil
    end

    local buildingRestriction = districtEraData[buildingType]
    if buildingRestriction ~= nil then
        return buildingRestriction
    end
    local tierNumber = GetTierForBuilding(buildingType, districtType)
    if tierNumber == nil then
        return nil
    end

    return districtEraData[tostring(tierNumber)]
end

function GetPlayerUniqueDistricts(playerID)
    local data = {}
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

function LoadPropertyToTable(propertyKey, tableObject, value, mutatingFunction)
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

StableGovernorBuildings = {
    ["BUILDING_JNR_MINT"] = true,
    ["BUILDING_JNR_ALTAR"] = true
}

function RestrictForStableGovernor(playerID, cityID, buildingType)
    local buildingCheck = StableGovernorBuildings[buildingType]
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

function GetWonderFromCity(cityID)
    local wonderName = g_WondersByCity[cityID]
    if wonderName == nil then
        wonderName = ExposedMembers.MapPins.GetCityWonderFromMapPins(cityID)
    end
end

-- ===========================================================================
--  Expose the functions to the UI layer
-- ===========================================================================

ExposedMembers.CustomDistrictRules.GetWonderFromCity = GetWonderFromCity
ExposedMembers.CustomDistrictRules.YieldBuildingTypeByTier = YieldBuildingTypeByTier

print("=== Custom District Rules (Helpers) Loaded ===")
