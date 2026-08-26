-- ===========================================================================
--  Custom District Rules (Config) - Gameplay Script
--  Provides preprocessed tables/arrays to use for restrictions.
-- ===========================================================================

include("DistrictRestrictions_Constants")

CityDistrictsByType = {}
PrereqDistrictForWonders = {}
TierByBuildingType = {}

GreatBathRiverName = nil
WondersByCity = {}
MuseumOfAntiquityCount = 0
MuseumOfAntiquityCityTable = {}

function GatherCityDistrictsByType()
    for k, v in pairs(CityDistrictTypes) do
        if CityDistrictsByType[v] == nil then
            CityDistrictsByType[v] = {}
        end
        table.insert(CityDistrictsByType[v], k)
    end
end

function GatherBuildingRelatedData()
    local prereqData = {}
    for building in GameInfo.Buildings() do
        if building.IsWonder == true then
            if building.AdjacentDistrict ~= nil then
                PrereqDistrictForWonders[building.BuildingType] = building.AdjacentDistrict
            elseif #building.PrereqBuildingCollection > 0 then
                local _, row = next(building.PrereqBuildingCollection)
                if row and row.PrereqDistrict then
                    PrereqDistrictForWonders[building.BuildingType] = row.PrereqDistrict
                end
            end
        end
        if (
            not building.InternalOnly
            and building.TraitType == nil
            and #building.ReplacesCollection
        ) then
            if prereqData[building.PrereqDistrict] == nil then
                prereqData[building.PrereqDistrict] = {}
            end
            prereqData[building.PrereqDistrict][building.BuildingType] = true
        end
    end
    for row in GameInfo.BuildingPrereqs() do
        local districtType = GameInfo.Buildings[row.Building].PrereqDistrict
        if (
                prereqData[districtType][row.PrereqBuilding] ~= nil and
                prereqData[districtType][row.Building] ~= nil
            ) then
            prereqData[districtType][row.Building] = row.PrereqBuilding
        end
    end
    for districtType, prereqBuildings in pairs(prereqData) do
        TierByBuildingType[districtType] = {}
        for buildingType in pairs(prereqBuildings) do
            local tier = 1
            local currentBuildingType = buildingType
            while currentBuildingType do
                currentBuildingType = prereqBuildings[currentBuildingType]
                if currentBuildingType ~= nil and currentBuildingType ~= true then
                    tier = tier + 1
                end
            end
            -- Store the result: TierByBuildingType["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            -- Store the result: TierByBuildingType["DISTRICT_CAMPUS"]["BUILDING_LIBRARY"] = 1
            TierByBuildingType[districtType][buildingType] = tier
        end
    end
end

print("=== Custom District Rules (OnLoad) Loaded ===")
