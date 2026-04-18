print("=== DISTRICT BLOCKER UI LOADING ***")
-- ===========================================================================
--  Custom District Rules - UI Script
--  Overrides ProductionPanel to block certain districts.
-- ===========================================================================
include("ProductionPanel")

local BASE_GetData = GetData

function GetData()
    local data = BASE_GetData()
    local cityID = data.City
    local playerID = data.Owner
    local player = Players[playerID]
    if not player:IsHuman() then
        return data
    end

    local city = player:GetCities():FindID(cityID)
    for i, item in ipairs(data.DistrictItems) do
        print(item.Type, item.Disabled, item.IsComplete, item.HasBeenBuilt, item.Progress)
        if not item.Disabled and not item.HasBeenBuilt and item.Progress == 0 then
            print("starting...")
            local isBlocked, reason = ExposedMembers.CustomDistrictRules.IsDistrictBlocked(
                playerID,
                cityID,
                item.Type
            )
            if isBlocked then
                item.Disabled = true
                item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_RED]" .. reason
            end
        end
    end
    for i, item in ipairs(data.BuildingItems) do
        if not item.Disabled and not item.IsWonder and item.Progress == 0 then
            local isBlocked, reason = ExposedMembers.CustomDistrictRules.IsBuildingBlocked(
                item.PrereqDistrict,
                item.Type
            )
            if isBlocked then
                item.Disabled = true
                item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_RED]" .. reason
            end
        end
    end
    return data
end

print("*** DISTRICT BLOCKER UI LOADED ===")
