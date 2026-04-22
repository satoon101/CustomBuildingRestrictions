-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Event hooks for storing data related to district restrictions.
-- ===========================================================================

g_GreatBathRiverName = Game:GetProperty("GreatBathRiverName") or nil
g_WondersByCity = Game:GetProperty("WondersByCity") or {}

function OnDistrictAddedToMap(playerID, districtID, _, x, y)
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
        -- Wonder added to the queue for the first time
        if not g_WondersByCity[cityID] then
            g_WondersByCity[cityID] = prodType
            Game:SetProperty("WondersByCity", g_WondersByCity)
            pinId = ExposedMembers.MapPins.GetPinForWonderInCity(
                cityID,
                prodType
            )
            ExposedMembers.MapPins.DeleteMapPin(playerID, pinID)
        end
    end
end

Events.CityProductionChanged.Add(OnCityProductionChanged)

print("=== Custom District Rules (Events) Loaded ===")
