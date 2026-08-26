-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Event hooks for storing data related to district restrictions.
-- ===========================================================================

include("DistrictRestrictions_Constants")
include("DistrictRestrictions_GlobalObjects")
include("DistrictRestrictions_Helpers")

------------------------------------------------------------------------------
-- CITY WONDERS EVENTS
------------------------------------------------------------------------------
-- When a Wonder is placed, store it with its city
Events.BuildingAddedToMap.Add(function(_, _, buildingTypeID, playerID, cityID)
    -- Is the new production a wonder?
    local bInfo = GameInfo.Buildings[buildingTypeID]
    local buildingType = bInfo.BuildingType
    if bInfo and bInfo.IsWonder then
        -- Wonder added to the queue for the first time
        if WondersByCity[playerID] == nil then
            WondersByCity[playerID] = {}
        end
        if WondersByCity[playerID][cityID] == nil then
            WondersByCity[playerID][cityID] = buildingType
            local pinID = ExposedMembers.MapPins.GetPinForWonderInCity(
                playerID,
                cityID,
                buildingType
            )
            ExposedMembers.MapPins.DeleteMapPin(playerID, pinID)
        end
    end
end)

------------------------------------------------------------------------------
-- GREAT BATH RIVER EVENTS
------------------------------------------------------------------------------
-- Store the Name of the river where the Great Bath was placed
Events.BuildingAddedToMap.Add(function(iX, iY, buildingType)
    if GreatBathRiverName ~= nil then return end
    if buildingType ~= GREAT_BATH_BUILDING_INDEX then return end
    local plot = Map.GetPlot(iX, iY)
    GreatBathRiverName = RiverManager.GetRiverName(plot)
end)

-- On Load, find if the Great Bath exists, and store the river name
Events.LoadGameViewStateDone.Add(function()
    local players = PlayerManager.GetAlive()
    for _, player in ipairs(players) do
        local playerID = player:GetID()
        local cities = player:GetCities()
        for _, city in cities:Members() do
            local districts = city:GetDistricts()
            local district = districts:GetDistrict(WONDER_DISTRICT_INDEX)
            if district ~= nil then
                local plot = Map.GetPlot(district:GetX(), district:GetY())
                local wonderIndex = plot:GetWonderType()
                if wonderIndex ~= nil then
                    if WondersByCity[playerID] == nil then
                        WondersByCity[playerID] = {}
                    end
                    WondersByCity[playerID][city:GetID()] = wonderIndex
                end
                if wonderIndex == GREAT_BATH_BUILDING_INDEX then
                    GreatBathRiverName = RiverManager.GetRiverName(plot)
                end
                break
            end
        end
    end
end)

------------------------------------------------------------------------------
-- MUSEUM OF ANTIQUITY EVENTS
------------------------------------------------------------------------------
-- When the shipwrecks are added to the map, find the number of Antiquity Museums needed
Events.CivicCompleted.Add(function(_, iCivic)
    if MuseumOfAntiquityCount > 0 then
        return
    end
    if iCivic ~= CULTURAL_HERITAGE_INDEX then
        return
    end

    local count = GetCountOfAntiquitySitesOnMap()
    MuseumOfAntiquityCount = math.ceil(count / 3)
end)

-- On load, find the number of Antiquity Museums needed
Events.LoadGameViewStateDone.Add(function()
    local siteCount = GetCountOfAntiquitySitesOnMap()
    local artifactCount = GetCountOfExistingArtifacts()
    local count = siteCount + artifactCount
    MuseumOfAntiquityCount = math.ceil(count / 3)
end)

Events.CityProductionChanged.Add(function(playerID, cityID)
    -- TODO: verify this works to add the city to the array
    --       work on removing the city if the production is
    --       changed away before any progress made
    local player = Players[playerID]
    if not player then return end

    if not player:IsHuman() then return end

    local city = CityManager.GetCity(playerID, cityID)
    if not city then return end

    local queue = city:GetBuildQueue()
    local prodType = queue:CurrentlyBuilding()

    -- Nothing being produced
    if prodType == -1 then return end

    if prodType == MUSEUM_OF_ARCHAEOLOGY_INDEX then
        local cityCheck = MuseumOfAntiquityCityTable[cityID]
        if cityCheck == nil then
            MuseumOfAntiquityCityTable[cityID] = true
            local keys = {}
            for k, _ in pairs(MuseumOfAntiquityCityTable) do
                table.insert(keys, tostring(k))
            end
        end
    end
end)

------------------------------------------------------------------------------
-- BASE LOAD EVENTS
------------------------------------------------------------------------------
Events.LoadGameViewStateDone.Add(function()
    GatherCityDistrictsByType()
    GatherBuildingRelatedData()
end)
print("=== Custom District Rules (Events) Loaded ===")
