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
            local isTracing = true
            while isTracing do
                local foundPrereq = false
                for row in GameInfo.BuildingPrereqs() do
                    if row.Building == currentBuildingType then
                        currentBuildingType = row.PrereqBuilding
                        tier = tier + 1
                        foundPrereq = true
                        break
                    end
                end
                if not foundPrereq then isTracing = false end
            end

            -- Store the result: data["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            data[districtType][building.BuildingType] = tier
        end
    end
    return data
end

local tierData = getTierData()

function getEraForDistrict(districtType)
    local districtEraData = districtEraConfig[districtType]
    if not districtEraData then
        return nil
    end

    return districtEraData["0"]
end

function getEraForBuilding(districtType, buildingType)
    local districtTierData = tierData[districtType]
    if not districtTierData then
        return nil
    end

    local tierNumber = districtTierData[buildingType]
    if not tierNumber then
        return nil
    end

    local districtEraData = districtEraConfig[districtType]
    if not districtEraData then
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

print("=== Custom District Rules (Helpers) Loaded ===")
