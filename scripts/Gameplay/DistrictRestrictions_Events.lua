-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Event hooks for storing data related to district restrictions.
-- ===========================================================================

g_GreatBathRiverName = Game:GetProperty("GreatBathRiverName") or nil
g_WondersByCity = Game:GetProperty("WondersByCity") or {}
WONDER_DISTRICT_INDEX = GameInfo.Districts["DISTRICT_WONDER"].Index
GREAT_BATH_BUILDING_INDEX = GameInfo.Buildings["BUILDING_GREAT_BATH"].Index

function StoreGreatBathRiverName(iX, iY, buildingType)
    if g_GreatBathRiverName ~= nil then return end
    if buildingType ~= GREAT_BATH_BUILDING_INDEX then return end
    local plot = Map.GetPlot(iX, iY)
    g_GreatBathRiverName = RiverManager.GetRiverName(plot)
    Game:SetProperty("GreatBathRiverName", g_GreatBathRiverName)
end

function StoreWonderForCity(_, _, buildingTypeID, playerID, cityID)
    -- Is the new production a wonder?
    local bInfo = GameInfo.Buildings[buildingTypeID]
    local buildingType = bInfo.BuildingType
    if bInfo and bInfo.IsWonder then
        -- Wonder added to the queue for the first time
        if not g_WondersByCity[cityID] then
            g_WondersByCity[cityID] = buildingType
            Game:SetProperty("WondersByCity", g_WondersByCity)
            local pinID = ExposedMembers.MapPins.GetPinForWonderInCity(
                cityID,
                buildingType
           )
            ExposedMembers.MapPins.DeleteMapPin(playerID, pinID)
        end
    end
end

Events.BuildingAddedToMap.Add(StoreGreatBathRiverName)
Events.BuildingAddedToMap.Add(StoreWonderForCity)

MUSEUM_OF_ART_INDEX = GameInfo.Buildings["BUILDING_MUSEUM_ART"].Index
MUSEUM_OF_ARCHAEOLOGY_INDEX = GameInfo.Buildings["BUILDING_MUSEUM_ARTIFACT"].Index
districtCountsPerEra = {}

function IncrementBuildCount(playerID, cityID)
    local player = Players[playerID]
    if not player then return end

    if not player:IsHuman() then return end

    local city = player:GetCities():FindID(cityID)
    if not city then return end

    local queue = city:GetBuildQueue()
    local prodType = queue:CurrentlyBuilding()

    -- Nothing being produced
    if prodType == -1 then return end

    if prodType == MUSEUM_OF_ARCHAEOLOGY_INDEX then
        local cityCheck = g_MuseumOfAntiquityCityTable[cityID]
        if cityCheck == nil then
            g_MuseumOfAntiquityCityTable[cityID] = true
            local keys = {}
            for k, _ in pairs(g_MuseumOfAntiquityCityTable) do
                table.insert(keys, tostring(k))
            end
            Game.SetProperty(
                MUSEUM_OF_ARCHAEOLOGY_ARRAY_KEY,
                table.concat(keys, ",")
            )
        end
    end


end

Events.CityProductionChanged.Add(IncrementBuildCount)

local DA_VINCI_KEY = "GREAT_PERSON_INDIVIDUAL_LEONARDO_DA_VINCI"
local DA_VINCI_GREAT_PERSON = GameInfo.GreatPersonIndividuals[DA_VINCI_KEY]
DA_VINCI_INDEX = DA_VINCI_GREAT_PERSON.Index

function StoreDaVinciActivated(_, _, _, greatPersonIndividualType)
    if greatPersonIndividualType == DA_VINCI_INDEX then
        g_DaVinciActivated = true
        Game.SetProperty(DA_VINCI_KEY, g_DaVinciActivated)
    end
end

Events.UnitGreatPersonActivated.Add(StoreDaVinciActivated)

function StoreCivicTierEnabled(_, _, buildingTypeID)
    local buildingInfo = GameInfo.Buildings[buildingTypeID]
    local districtType = buildingInfo.PrereqDistrict
    if districtType ~= "DISTRICT_THEATER" then
        return
    end

    local buildingType = buildingInfo.BuildingType
    local tierNumber = getTierForBuilding(buildingType, districtType)
    if tierNumber == nil or tierNumber == 1 then
        return
    end

    for _, tier in pairs(g_TiersEnabled) do
        if tier == tierNumber then
            return
        end
    end

    table.insert(g_TiersEnabled, tierNumber)
    Game.SetProperty(
        CIVIC_TIERS_ENABLED_KEY,
        table.concat(g_TiersEnabled, ",")
    )
end

GameEvents.BuildingConstructed.Add(StoreCivicTierEnabled)

CULTURAL_HERITAGE_INDEX = GameInfo.Civics["CIVIC_CULTURAL_HERITAGE"].Index
MUSEUM_OF_ARCHAEOLOGY_COUNT_KEY = "MUSEUM_OF_ARCHAEOLOGY_COUNT"
MUSEUM_OF_ARCHAEOLOGY_ARRAY_KEY = "MUSEUM_OF_ARCHAEOLOGY_ARRAY"
g_MuseumOfAntiquityCount = 0
g_MuseumOfAntiquityCityTable = {}

function DetermineMuseumOfAntiquityCount(_, iCivic)
    if g_MuseumOfAntiquityCount > 0 then
        return
    end
    if iCivic ~= CULTURAL_HERITAGE_INDEX then
        return
    end

    local iW, iH = Map.GetGridSize();
    local count = 0;
    local iAntiquitySite = GameInfo.Resources["RESOURCE_ANTIQUITY_SITE"].Index
    local iShipwreck = GameInfo.Resources["RESOURCE_SHIPWRECK"].Index
    for x = 0, iW - 1 do
        for y = 0, iH - 1 do
            local pPlot = Map.GetPlot(x, y)
            local iResourceType = pPlot:GetResourceType()
            if iResourceType == iAntiquitySite or iResourceType == iShipwreck then
                count = count + 1
            end
        end
    end
    g_MuseumOfAntiquityCount = math.ceil(count / 3)
    Game.SetProperty(MUSEUM_OF_ARCHAEOLOGY_COUNT_KEY, g_MuseumOfAntiquityCount)
end

Events.CivicCompleted.Add(DetermineMuseumOfAntiquityCount)

function OnLoadScreenClose()
    g_DaVinciActivated = Game.GetProperty(DA_VINCI_KEY) or false
    g_MuseumOfAntiquityCount = Game.GetProperty(MUSEUM_OF_ARCHAEOLOGY_COUNT_KEY) or 0
    if g_MuseumOfAntiquityCount then
        loadPropertyToTable(
            MUSEUM_OF_ARCHAEOLOGY_ARRAY_KEY,
            g_MuseumOfAntiquityCityTable,
            true,
            tonumber
        )
    end
    loadPropertyToTable(
        CIVIC_TIERS_ENABLED_KEY,
        g_TiersEnabled,
        true,
        tonumber
    )
end

Events.LoadScreenClose.Add(OnLoadScreenClose)

print("=== Custom District Rules (Events) Loaded ===")
