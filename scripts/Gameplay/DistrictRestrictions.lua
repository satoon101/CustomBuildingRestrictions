-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides district blocking logic to the UI layer.
-- ===========================================================================

print("=== Custom District Rules (Gameplay) Loading ===")

include("DistrictRestrictions_Events")
include("DistrictRestrictions_Helpers")

ExposedMembers.CustomDistrictRules = ExposedMembers.CustomDistrictRules or {}

function IsDistrictBlocked(playerID, cityID, districtType)
    if playerUniqueDistricts[playerID] == nil then
        playerUniqueDistricts[playerID] = getPlayerUniqueDistricts(playerID)
    end

    -- Disallow if always restricted
    local isDisabled = alwaysRestrict["districts"][districtType]
    if isDisabled then
        return true, "District is always disabled"
    end

    -- Disallow districts based on Era
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local requiredEraIndex = getEraForDistrict(districtType)
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
    if baseDistrictType == "DISTRICT_DAM" and g_GreatBathRiverName ~= nil then
        local foundValidDamPlot = false
        local plotIDsToCheck = ExposedMembers.ProductionPanelHelpers.GetCityDamPlots(playerID, cityID)
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

    local districtMapPinRestricted = districtMapPinRestrictions[baseDistrictType]
    if districtMapPinRestricted ~= nil then

        -- Disallow district if restricted to specific city map pin
        if districtMapPinRestricted == true then
            if not ExposedMembers.MapPins.IsDistrictPinInCity(cityID, districtType) then
                return true, "District restricted due to no district map pin for city."
            end
        end

        -- Disallow districts that should only be built in 1 city
        --  for a specific wonder
        local building = GameInfo.Buildings[districtMapPinRestricted]
        if building ~= nil and building.IsWonder then
            local cityWonder = ExposedMembers.MapPins.GetCityWonderFromMapPins(cityID)
            if cityWonder ~= districtMapPinRestricted then
                local name = Locale.Lookup(GameInfo.Buildings[districtMapPinRestricted].Name)
                return true, "District only allowed for city marked to build " .. name
            end
        end
    end

    -- Default: allowed
    return false, nil
end

function IsBuildingBlocked(playerID, cityID, districtType, buildingType, isWonder)
    -- Disallow if always restricted
    local isDisabled = alwaysRestrict["buildings"][buildingType]
    if isDisabled then
        return true, "Building is always disabled"
    end

    local specialRestriction = specialRestrictions["buildings"][buildingType]
    if specialRestriction ~= nil then
        local isBlocked, reason = specialRestriction(playerID, cityID, districtType, buildingType)
        if isBlocked then
            return true, reason
        end
    end

    local buildingMapPinRestricted = buildingMapPinRestrictions[buildingType]
    if buildingMapPinRestricted ~= nil then
        local wonderForCity = ExposedMembers.MapPins.GetCityWonderFromMapPins(
            cityID
        )
        if wonderForCity ~= buildingMapPinRestricted then
            local name = Locale.Lookup(GameInfo.Buildings[buildingMapPinRestricted].Name)
            return true, "Building only allowed for city marked to build " .. name
        end
    end

    -- Disallow buildings based on era by tier
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local requiredEraIndex = getEraForBuilding(districtType, buildingType)
    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    if isWonder then

        -- Disallow building more than 1 Wonder in the city
        if (
            g_WondersByCity[cityID] and
            g_WondersByCity[cityID] ~= buildingType
        ) then
            return true, "This city has already established a Wonder"
        end

        -- Only allow a Wonder from the city's MapPins
        local wonderForCity = ExposedMembers.MapPins.GetCityWonderFromMapPins(
            cityID
        )
        if wonderForCity ~= nil and wonderForCity ~= buildingType then
            return true, "This city is marked to establish a different Wonder"
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

print("=== Custom District Rules (Gameplay) Loaded ===")
