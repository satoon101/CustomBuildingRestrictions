-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides district blocking logic to the UI layer.
-- ===========================================================================

print("=== Custom District Rules (Gameplay) Loading ===")

include("DistrictRestrictions_Config")
include("DistrictRestrictions_Constants")
include("DistrictRestrictions_Helpers")

ExposedMembers.CustomDistrictRules = ExposedMembers.CustomDistrictRules or {}

function IsDistrictBlocked(playerID, cityID, districtType)
    if PlayerUniqueDistricts[playerID] == nil then
        PlayerUniqueDistricts[playerID] = GetPlayerUniqueDistricts(playerID)
    end

    local baseDistrictType = PlayerUniqueDistricts[playerID][districtType] or districtType

    local districtConfig = DistrictRestrictions[baseDistrictType]

    -- Disallow if always restricted
    local isDisabled = districtConfig["disabled"]
    if isDisabled then
        local wonder = ExposedMembers.MapPins.GetCityWonderFromMapPins(
            playerID,
            cityID
        )
        local prereqDistrictType = PrereqDistrictForWonders[wonder]
        if prereqDistrictType ~= baseDistrictType then
            return true, "District is always disabled"
        end
    end

    -- Disallow districts based on Era
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local requiredEraIndex = districtConfig["era"]
    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    local districtTypes = CityDistrictsByType[CityDistrictTypes[baseDistrictType]]
    local check_primary_districts = false
    if districtTypes and #districtTypes > 1 then
        for _, newDistrictType in ipairs(districtTypes) do
            if newDistrictType ~= baseDistrictType then
                if GetCityHasDistrict(playerID, cityID, newDistrictType) then
                    check_primary_districts = true
                    break
                end
            end
        end
    end

    if check_primary_districts then
        if not HasCityBuiltPrimaryDistricts(playerID, cityID) then
            return true, "Disabled until all primary districts have been built."
        end
    end

    if districtConfig["function"] then
        local isBlocked, reason = districtConfig["function"](playerID, cityID, districtType, baseDistrictType)
        if isBlocked then
            return isBlocked, reason
        end
    end

    -- Default: allowed
    return false, nil
end

function IsBuildingBlocked(playerID, cityID, districtType, buildingType, isWonder)
    if PlayerUniqueDistricts[playerID] == nil then
        PlayerUniqueDistricts[playerID] = GetPlayerUniqueDistricts(playerID)
    end

    if PlayerUniqueBuildings[playerID] == nil then
        PlayerUniqueBuildings[playerID] = GetPlayerUniqueBuildings(playerID)
    end

    local baseDistrictType = PlayerUniqueDistricts[playerID][districtType] or districtType

    local baseBuildingType = PlayerUniqueBuildings[playerID][buildingType] or buildingType

    local districtConfig = DistrictRestrictions[baseDistrictType] or {}

    -- Disallow if always restricted
    local isDisabled = false
    local disabledBuildings = districtConfig["disabled_buildings"] or {}
    local buildingDisabled = disabledBuildings[buildingType]
    if buildingDisabled ~= nil then
        -- TODO: test to see if this is working correctly with Alexander Encampment Tier 1
        -- TODO:    Statue of Zeus (might need to be in 'functions')
        isDisabled = disabledBuildings[baseBuildingType]
    end
    if isDisabled then
        return true, "Building is always disabled"
    end

    if districtConfig["functions"] then
        local uniqueFunction = districtConfig["functions"][baseBuildingType]
        if uniqueFunction then
            local isBlocked, reason = uniqueFunction(
                playerID,
                cityID,
                districtType,
                baseDistrictType,
                buildingType,
                baseBuildingType
            )
            if isBlocked then
                return isBlocked, reason
            end
        end
    end

    -- Disallow buildings based on era by tier
    local currentEraIndex = Game.GetEras():GetCurrentEra()
    local districtTierData = TierByBuildingType[baseDistrictType] or {}
    local requiredEraIndex = districtTierData[baseBuildingType]
    if requiredEraIndex ~= nil and currentEraIndex < requiredEraIndex then
        local eraName = GameInfo.Eras[requiredEraIndex].Name
        return true, "Disabled until the " .. Locale.Lookup(eraName) .. "."
    end

    if isWonder then

        -- Disallow building more than 1 Wonder in the city
        local wonderIndex = WondersByCity[playerID] or {}
        wonderIndex = wonderIndex[cityID]
        if (
            wonderIndex and
            wonderIndex ~= buildingType
        ) then
            return true, "This city has already established a Wonder"
        end

        -- Only allow a Wonder from the city's MapPins
        local wonderForCity = ExposedMembers.MapPins.GetCityWonderFromMapPins(
            playerID,
            cityID
        )
        if wonderForCity == nil then
            return true, "City has not been marked to establish a Wonder"
        elseif wonderForCity ~= buildingType then
            return true, "This city is marked to establish a different Wonder"
        end
    end

    -- Default: allowed
    return false, nil
end

-- ===========================================================================
--  Expose the functions to the UI layer
-- ===========================================================================

ExposedMembers.CustomDistrictRules.IsDistrictBlocked = IsDistrictBlocked
ExposedMembers.CustomDistrictRules.IsBuildingBlocked = IsBuildingBlocked

print("=== Custom District Rules (Gameplay) Loaded ===")
