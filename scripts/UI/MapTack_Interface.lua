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

    PinsByPlot = {}
    PinsByCity = {}
    local pPins = pConfig:GetMapPins()
    for _, pin in ipairs(pPins) do
        local x = pin:GetHexX()
        local y = pin:GetHexY()
        local plotID = Map.GetPlot(x, y):GetIndex()
        local cityID = Cities.GetPlotPurchaseCity(x, y)
        if cityID ~= nil then
            cityID = cityID:GetID()
            if PinsByCity[cityID] == nil then
                PinsByCity[cityID] = {}
            end
            table.insert(PinsByCity[cityID], plotID)
        end
        PinsByPlot[plotID] = {
            PinID = pin:GetID(),
            Icon = pin:GetIconName():gsub("^ICON_", ""),
            CityID = cityID
        }
    end
end

function GetPinForWonderInCity(cityID, buildingID)
    local cityMapPinPlots = PinsByCity[cityID]
    if cityMapPinPlots == nil then
        return nil
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[plotID]
        if pinData ~= nil then
            local icon = pinData.Icon
            if icon == buildingID then
                return pinData.PinID
            end
        end
    end
    return nil
end

ExposedMembers.MapPins.GetPinForWonderInCity = GetPinForWonderInCity

function GetCityWonderFromMapPins(cityID)
    local cityMapPinPlots = PinsByCity[cityID]
    if cityMapPinPlots == nil then
        return nil
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[plotID]
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

ExposedMembers.MapPins.GetCityWonderFromMapPins = GetCityWonderFromMapPins

function DeleteMapPin(playerID, pinID)
    PlayerConfigurations[playerID]:DeleteMapPin(pinID)
    Network.BroadcastPlayerInfo()
    SyncPins()
end

ExposedMembers.MapPins.DeleteMapPin = DeleteMapPin

function OnLoadGameViewStateDone()
    SyncPins()
end

Events.LoadGameViewStateDone.Add(OnLoadGameViewStateDone)

print("=== Custom District Rules (MapTack) Loaded ===")
