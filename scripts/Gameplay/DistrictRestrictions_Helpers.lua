-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around district restrictions.
-- ===========================================================================

include("DistrictRestrictions_Config")
include("DistrictRestrictions_Constants")
include("DistrictRestrictions_GlobalObjects")

ExposedMembers.CustomDistrictRules = ExposedMembers.CustomDistrictRules or {}

PlayerUniqueDistricts = {}
PlayerUniqueBuildings = {}

function GetCityHasDistrict(playerID, cityID, districtType)
    local city = CityManager.GetCity(playerID, cityID)
    local cityDistricts = city:GetDistricts()
    local uniqueDistricts = PlayerUniqueDistricts[playerID] or {}
    local checkDistrict = uniqueDistricts[districtType]
    if checkDistrict then
        districtType = checkDistrict
    end
    return cityDistricts:HasDistrict(GameInfo.Districts[districtType].Index)
end

function HasCityBuiltPrimaryDistricts(playerID, cityID)
    for _, districts in pairs(CityDistrictsByType) do
        local purpose_missing = true
        for _, district in ipairs(districts) do
            if GetCityHasDistrict(playerID, cityID, district) then
                purpose_missing = false
                break
            end
        end
        if purpose_missing then
            return false
        end
    end
    return true
end

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

function GetPlayerUniqueDistricts(playerID)
    local data = {}
    local playerConfig = PlayerConfigurations[playerID]
    local civType = playerConfig:GetCivilizationTypeName()

    for row in GameInfo.DistrictReplaces() do
        local traitType = GameInfo.Districts[row.CivUniqueDistrictType].TraitType
        for civTraitRow in GameInfo.CivilizationTraits() do
            if (
                civType == civTraitRow.CivilizationType and
                traitType == civTraitRow.TraitType
            ) then
                data[row.ReplacesDistrictType] = row.CivUniqueDistrictType
                data[row.CivUniqueDistrictType] = row.ReplacesDistrictType
            end
        end
    end
    return data
end

function GetPlayerUniqueBuildings(playerID)
    local data = {}
    local playerConfig = PlayerConfigurations[playerID]
    local civType = playerConfig:GetCivilizationTypeName()

    for row in GameInfo.BuildingReplaces() do
        local traitType = GameInfo.Buildings[row.CivUniqueBuildingType].TraitType
        if traitType == nil then
            data[row.CivUniqueBuildingType] = row.ReplacesBuildingType
        end
        for civTraitRow in GameInfo.CivilizationTraits() do
            if (
                civType == civTraitRow.CivilizationType and
                traitType == civTraitRow.TraitType
            ) then
                data[row.CivUniqueBuildingType] = row.ReplacesBuildingType
            end
        end
    end
    return data
end

function GetWonderFromCity(playerID, cityID)
    local wonderName = WondersByCity[playerID] or {}
    wonderName = wonderName[cityID]
    if wonderName == nil then
        wonderName = ExposedMembers.MapPins.GetCityWonderFromMapPins(playerID, cityID)
    end
end

function GetCountOfAntiquitySitesOnMap()
    local iW, iH = Map.GetGridSize()
    local count = 0
    for x = 0, iW - 1 do
        for y = 0, iH - 1 do
            local pPlot = Map.GetPlot(x, y)
            local iResourceType = pPlot:GetResourceType()
            if iResourceType == ANTIQUITY_SITE_INDEX or iResourceType == SHIPWRECK_INDEX then
                count = count + 1
            end
        end
    end
    return count
end

--function GetCountOfExistingArtifacts()
--    local count = 0
--    for _, player in ipairs(Players) do
--        if player:IsAlive() then
--            local cities = player:GetCities()
--            for _, city in cities:Members() do
--                local buildings = city:GetBuildings()
--                if buildings:HasBuilding(MUSEUM_OF_ARCHAEOLOGY_INDEX) then
--                    local slot_count = buildings:GetNumGreatWorkSlots()
--                    for index = 0,
--                end
--            end
--        end
--    end
--end

-- ===========================================================================
--  Expose the functions to the UI layer
-- ===========================================================================

ExposedMembers.CustomDistrictRules.GetWonderFromCity = GetWonderFromCity
ExposedMembers.CustomDistrictRules.YieldBuildingTypeByTier = YieldBuildingTypeByTier

print("=== Custom District Rules (Helpers) Loaded ===")
