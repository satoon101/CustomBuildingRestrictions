-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides district blocking logic to the UI layer.
-- ===========================================================================

print("=== Custom District Rules (Gameplay) Loading ===")

if not ExposedMembers.CustomDistrictRules then
    ExposedMembers.CustomDistrictRules = {}
end

local playerUniqueDistricts = {}

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

function getEraForBuilding(districtType, buildingType)
    local districtTierData = tierData[districtType]
    if not districtTierData then
        return nil
    end

    local tierNumber = districtTierData[buildingType]
    if not tierNumber then
        return nil
    end

    local districtEraData = buildingEraConfig[districtType]
    if not districtEraData then
        return nil
    end

    return districtEraData[tierNumber]
end

-- ERA REFERENCE:
--      0 = ERA_ANCIENT
--      1 = ERA_CLASSICAL (turn 61)
--      2 = ERA_MEDIEVAL (turn 121)
--      3 = ERA_RENAISSANCE (turn 181)
--      4 = ERA_INDUSTRIAL (turn 241)
--      5 = ERA_MODERN (turn 301)
--      6 = ERA_ATOMIC (turn 361)
--      7 = ERA_INFORMATION (turn 421)
--      8 = ERA_FUTURE (turn 481)
districtEraConfig = {
    ["DISTRICT_INDUSTRIAL_ZONE"]    = GameInfo.Eras["ERA_MEDIEVAL"].Index,
    ["DISTRICT_THEATER"]            = GameInfo.Eras["ERA_INDUSTRIAL"].Index
}

buildingEraConfig = { 
    ["DISTRICT_HOLY_SITE"] = {
        [4] = GameInfo.Eras["ERA_ATOMIC"].Index
    }, 
    ["DISTRICT_CAMPUS"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_MODERN"].Index, 
        [4] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_ENCAMPMENT"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_HARBOR"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_COMMERCIAL_HUB"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_ENTERTAINMENT_COMPLEX"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_THEATER"] = { 
        [2] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [3] = GameInfo.Eras["ERA_MODERN"].Index, 
        [4] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_INDUSTRIAL_ZONE"] = { 
        [4] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [5] = GameInfo.Eras["ERA_MODERN"].Index, 
        [6] = GameInfo.Eras["ERA_ATOMIC"].Index 
    }, 
    ["DISTRICT_WATER_ENTERTAINMENT_COMPLEX"] = { 
        [1] = GameInfo.Eras["ERA_INDUSTRIAL"].Index, 
        [2] = GameInfo.Eras["ERA_MODERN"].Index, 
        [3] = GameInfo.Eras["ERA_ATOMIC"].Index 
    } 
}

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

function IsDistrictBlocked(playerID, cityID, districtType)
    if playerUniqueDistricts[playerID] == nil then
        playerUniqueDistricts[playerID] = getPlayerUniqueDistricts(playerID)
    end

    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local requiredEraIndex = districtEraConfig[districtType]
    -- Disallow districts based on Era
    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    local baseDistrictType = playerUniqueDistricts[playerID][districtType]
    if baseDistrictType == nil then
        baseDistrictType = districtType
    end
    local player = Players[playerID]
    local city = player:GetCities():FindID(cityID)
    local cityDistricts = city:GetDistricts()

    -- Disallow harbor and commercial hub from both being created unless
    --      civic, entertainment, AND industrial have been completed
    --      holy site, campus, OR encampment has been completed
    if (
        baseDistrictType == "DISTRICT_COMMERCIAL_HUB" or
        baseDistrictType == "DISTRICT_HARBOR"
    ) then
        local compareDistricts = {
            ["DISTRICT_COMMERCIAL_HUB"] = "DISTRICT_HARBOR",
            ["DISTRICT_HARBOR"] = "DISTRICT_COMMERCIAL_HUB",
        }
        local compareDistrict = compareDistricts[baseDistrictType]
        if getCityHasDistrict(playerID, cityDistricts, compareDistrict) then
            if not hasCityBuiltPrimaryDistricts(playerID, cityDistricts) then
                return true, "Disabled until all primary districts have been built."
            end
        end
    end

    -- Only allow for one of holy site, campus, OR encampment unless
    --      civic, entertainment, industrial, AND harbor OR commercial hub have been completed
    if (
        baseDistrictType == "DISTRICT_ENCAMPMENT" or
        baseDistrictType == "DISTRICT_CAMPUS" or
        baseDistrictType == "DISTRICT_HOLY_SITE"
    ) then
        local foundDistrict = false
        for _, checkDistrictType in ipairs({
            "DISTRICT_ENCAMPMENT",
            "DISTRICT_CAMPUS",
            "DISTRICT_HOLY_SITE"
        }) do
            if getCityHasDistrict(playerID, cityDistricts, checkDistrictType) then
                foundDistrict = true
            end
        end
        if foundDistrict then
            if not hasCityBuiltPrimaryDistricts(playerID, cityDistricts) then
                return true, "Disabled until all primary districts have been built."
            end
        end
    end

    -- Default: allowed
    return false, nil
end

function IsBuildingBlocked(districtType, buildingType)
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    -- Disallow buildings based on era by tier
    local requiredEraIndex = getEraForBuilding(districtType, buildingType)

    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    -- Default: allowed
    return false, nil
end

-- ===========================================================================
--  Expose the function to the UI layer
-- ===========================================================================

ExposedMembers.CustomDistrictRules.IsDistrictBlocked = IsDistrictBlocked
ExposedMembers.CustomDistrictRules.IsBuildingBlocked = IsBuildingBlocked

print("=== Custom District Rules (Gameplay) Loaded ===")
