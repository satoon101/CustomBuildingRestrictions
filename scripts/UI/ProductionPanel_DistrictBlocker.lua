-- ===========================================================================
--  Custom District Rules - UI Script
--  Overrides ProductionPanel to block certain districts.
-- ===========================================================================

print("=== Custom District Rules (ProductionPanel) Loading ===")

include("ProductionPanel")
include("ProductionPanel_Helpers")

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
    local progressData = {}
    local disabledItems = {}
    for _, item in ipairs(data.BuildingItems) do
        progressData[item.Type] = item.Progress
        if not item.Disabled and item.Progress == 0 then
            local isBlocked, reason = ExposedMembers.CustomDistrictRules.IsBuildingBlocked(
                playerID,
                cityID,
                item.PrereqDistrict,
                item.Type,
                item.IsWonder
            )
            if isBlocked then
                item.Disabled = true
                item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_RED]" .. reason
                disabledItems[item.Type] = item.ToolTip
            end
        end
    end

    -- the item currently at the front of the queue will not be included,
    --  so we need to retrieve that value separately
    local building = GameInfo.Buildings[data.CurrentProductionType]
    if building ~= nil then
        local queue = city:GetBuildQueue()
        local currentProgressAmount = queue:GetBuildingProgress(building.Index)
        progressData[data.CurrentProductionType] = currentProgressAmount
    end
    for _, item in ipairs(data.BuildingPurchases) do
        if not item.Disabled then
            local tooltip = disabledItems[item.Type]
            if tooltip ~= nil then
                item.Disabled = true
                item.ToolTip = tooltip
            else
                if progressData[item.Type] > 0 then
                    item.Disabled = true
                    local reason = "Building process has already begun"
                    item.ToolTip = item.ToolTip .. "[NEWLINE][COLOR_RED]" .. reason
                end
            end
        end
    end
    return data
end

print("=== Custom District Rules (ProductionPanel) Loaded ===")
