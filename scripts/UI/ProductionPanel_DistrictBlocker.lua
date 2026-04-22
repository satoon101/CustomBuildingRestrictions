-- ===========================================================================
--  Custom District Rules - UI Script
--  Overrides ProductionPanel to block certain districts.
-- ===========================================================================

print("=== Custom District Rules (ProductionPanel) Loading ===")

include("ProductionPanel")
include("AdjacencyBonusSupport_DamBlocker")

local BASE_GetData = GetData

function GetData()
    local data = BASE_GetData()
    local city = data.City
    local cityID = city:GetID()
    local playerID = data.Owner
    local player = Players[playerID]
    if not player:IsHuman() then
        return data
    end

    for _, item in ipairs(data.DistrictItems) do
        if not item.Disabled and not item.HasBeenBuilt and item.Progress == 0 then
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
    for _, item in ipairs(data.BuildingItems) do
        if not item.Disabled and item.Progress == 0 then
            local isBlocked, reason = ExposedMembers.CustomDistrictRules.IsBuildingBlocked(
                cityID,
                item.PrereqDistrict,
                item.Type,
                item.IsWonder
            )
            if isBlocked then
                item.Disabled = true
                item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_RED]" .. reason
            end
        end
    end
    return data
end

print("=== Custom District Rules (ProductionPanel) Loaded ===")
