-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides district blocking logic to the UI layer.
-- ===========================================================================

print("=== Custom District Rules (Gameplay) Loading ===")

g_GreatBathRiverName = Game:GetProperty("GreatBathRiverName") or nil
g_WondersByCity = Game:GetProperty("WondersByCity") or {}

ExposedMembers.CustomDistrictRules = ExposedMembers.CustomDistrictRules or {}

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

    -- Disallow Dam being built on the same river as the Great Bath
    if baseDistrictType == "DISTRICT_DAM" then
        local foundValidDamPlot = false
        local plotIDsToCheck = ExposedMembers.DamValidator.GetCityDamPlots(playerID, cityID)
        for _, plotID in ipairs(plotIDsToCheck) do
            local plot = Map.GetPlotByIndex(plotID)
            local riverName = RiverManager.GetRiverName(plot)
            if riverName ~= g_GreatBathRiverName then
                foundValidDamPlot = true
                break
            end
        end
        if not foundValidDamPlot then
            return true, "No available dam plots"
        end
    end

    -- Default: allowed
    return false, nil
end

function IsBuildingBlocked(cityID, districtType, buildingType, isWonder)
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    -- Disallow buildings based on era by tier
    local requiredEraIndex = getEraForBuilding(districtType, buildingType)

    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    -- Disallow building more than 1 Wonder in the city
    if isWonder then
        if (
            g_WondersByCity[cityID] and
            g_WondersByCity[cityID] ~= buildingType
        ) then
            return true, "This city has already established a Wonder"
        end
    end

    -- Default: allowed
    return false, nil
end

-- ===========================================================================
--  Expose the function to the UI layer
-- ===========================================================================

ExposedMembers.CustomDistrictRules.IsDistrictBlocked = IsDistrictBlocked
ExposedMembers.CustomDistrictRules.IsBuildingBlocked = IsBuildingBlocked

function OnDistrictAddedToMap(playerID, districtID, cityID, x, y)
    if g_GreatBathRiverName ~= nil then return end
    local district = CityManager.GetDistrict(playerID, districtID)
    if district ~= nil then return end

    local gbDistrictType = GameInfo.Districts["DISTRICT_WONDER"].Index
    if district:GetType() ~= gbDistrictType then return end

    local plot = Map.GetPlot(x, y)
    local wonderType = plot:GetWonderType()
    if wonderType == GameInfo.Buildings["BUILDING_GREAT_BATH"].Index then
        g_GreatBathRiverName = RiverManager.GetRiverName(plot)
        Game:SetProperty("GreatBathRiverName", g_GreatBathRiverName)
    end
end

Events.DistrictAddedToMap.Add(OnDistrictAddedToMap)

function OnCityProductionChanged(playerID, cityID)
    local player = Players[playerID]
    if not player then
        return
    end

    if not player:IsHuman() then
        return
    end

    local city = player:GetCities():FindID(cityID)
    if not city then
        return
    end

    local queue = city:GetBuildQueue()
    local prodType = queue:CurrentlyBuilding()

    -- Nothing being produced
    if prodType == -1 then
        return
    end

    -- Is the new production a wonder?
    local bInfo = GameInfo.Buildings[prodType]
    if bInfo and bInfo.IsWonder then
        -- WONDER JUST ADDED TO QUEUE
        if not g_WondersByCity[cityID] then
            g_WondersByCity[cityID] = prodType
            Game:SetProperty("WondersByCity", g_WondersByCity)
        end
    end
end

Events.CityProductionChanged.Add(OnCityProductionChanged)

print("=== Custom District Rules (Gameplay) Loaded ===")
