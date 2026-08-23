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
    for _, pin in pairs(pPins) do
        local x = pin:GetHexX()
        local y = pin:GetHexY()
        local plotID = Map.GetPlot(x, y):GetIndex()
        local city = Cities.GetPlotPurchaseCity(x, y)
        local cityID = -1
        if city ~= nil then
            cityID = city:GetID()
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

SyncPins()

function GetPinForWonderInCity(cityID, buildingType)
    local cityMapPinPlots = PinsByCity[cityID]
    if cityMapPinPlots == nil then
        return nil
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[plotID]
        if pinData ~= nil then
            local icon = pinData.Icon
            if icon == buildingType then
                return pinData.PinID
            end
        end
    end
    return nil
end

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


function IsDistrictPinInCity(cityID, districtType)
    local cityMapPinPlots = PinsByCity[cityID]
    if cityMapPinPlots == nil then
        return false
    end

    for _, plotID in ipairs(cityMapPinPlots) do
        local pinData = PinsByPlot[plotID]
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
