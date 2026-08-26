-- ===========================================================================
--  Custom District Rules - UI Script
--  Provides MapPin based functionality to gameplay scripts.
-- ===========================================================================

ExposedMembers.MapPins = ExposedMembers.MapPins or {}

PinsByPlot = {}
PinsByCity = {}

function SyncPins()
    local playerID = Game.GetLocalPlayer()
    if playerID == -1 then return end

    local pConfig = PlayerConfigurations[playerID]
    if not pConfig then return end

    PinsByPlot[playerID] = {}
    PinsByCity[playerID] = {}
    local pPins = pConfig:GetMapPins()
    for _, pin in pairs(pPins) do
        local x = pin:GetHexX()
        local y = pin:GetHexY()
        local plotID = Map.GetPlot(x, y):GetIndex()
        local city = Cities.GetPlotPurchaseCity(x, y)
        local cityID = -1
        if city ~= nil then
            cityID = city:GetID()
            if PinsByCity[playerID][cityID] == nil then
                PinsByCity[playerID][cityID] = {}
            end
            table.insert(PinsByCity[playerID][cityID], plotID)
        end
        PinsByPlot[playerID][plotID] = {
            PinID = pin:GetID(),
            Icon = pin:GetIconName():gsub("^ICON_", ""),
            CityID = cityID
        }
    end
end

SyncPins()

function GetPinForWonderInCity(playerID, cityID, buildingType)
    local cityMapPinPlots = PinsByCity[playerID][cityID]
    if cityMapPinPlots == nil then
        return nil
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[playerID][plotID]
        if pinData ~= nil then
            local icon = pinData.Icon
            if icon == buildingType then
                return pinData.PinID
            end
        end
    end
    return nil
end

function GetCityWonderFromMapPins(playerID, cityID)
    local cityMapPinPlots = PinsByCity[playerID][cityID]
    if cityMapPinPlots == nil then
        return nil
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[playerID][plotID]
        if pinData ~= nil then
            local icon = pinData.Icon
            local buildingInfo = GameInfo.Buildings[icon]
            if buildingInfo ~= nil and buildingInfo.IsWonder then
                return buildingInfo.BuildingType
            end
        end
    end
    return nil
end


function IsDistrictPinInCity(playerID, cityID, districtType)
    local cityMapPinPlots = PinsByCity[playerID][cityID]
    if cityMapPinPlots == nil then
        return false
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[playerID][plotID]
        if pinData ~= nil then
            local icon = pinData.Icon
            if icon == districtType then
                return true
            end
        end
    end
    return false
end


function DeleteMapPin(playerID, pinID)
    PlayerConfigurations[playerID]:DeleteMapPin(pinID)
    Network.BroadcastPlayerInfo()
    SyncPins()
end

function AddInitialCityIcon(playerID, _, iX, iY)
    local player = Players[playerID]
    if not player:IsAlive() then
        return
    end

    local cities = player:GetCities()
    if cities:GetCount() > 1 then
        return
    end

    local config = PlayerConfigurations[playerID]
    local pin = config:GetMapPin(iX, iY)
    pin:SetIconName("ICON_BUILDING_APADANA")
    Network.BroadcastPlayerInfo()
end

Events.CityAddedToMap.Add(AddInitialCityIcon)
Events.LoadGameViewStateDone.Add(SyncPins)
Events.CityAddedToMap.Add(SyncPins)

-- ===========================================================================
--  Expose the functions to the Gameplay layer
-- ===========================================================================

ExposedMembers.MapPins.DeleteMapPin = DeleteMapPin
ExposedMembers.MapPins.GetCityWonderFromMapPins = GetCityWonderFromMapPins
ExposedMembers.MapPins.GetPinForWonderInCity = GetPinForWonderInCity
ExposedMembers.MapPins.IsDistrictPinInCity = IsDistrictPinInCity

print("=== Custom District Rules (MapTack) Loaded ===")
