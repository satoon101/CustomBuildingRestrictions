-- ===========================================================================
--  Custom District Rules - Gameplay Script
--  Provides helper functions around unique district restrictions.
-- ===========================================================================

function CheckDamRestricted(playerID, cityID, _, _)
    -- Disallow Dam being built on the same river as the Great Bath
    if GreatBathRiverName ~= nil then
        local foundValidDamPlot = false
        local plotIDsToCheck = ExposedMembers.ProductionPanelHelpers.GetCityDamPlots(
            playerID,
            cityID
        )
        for _, plotID in ipairs(plotIDsToCheck) do
            local plot = Map.GetPlotByIndex(plotID)
            local riverName = RiverManager.GetRiverName(plot)
            if riverName ~= GreatBathRiverName then
                foundValidDamPlot = true
                break
            end
        end
        if not foundValidDamPlot then
            return true, "No available dam plots"
        end
    end
end

print("=== Custom District Rules (DistrictFunctions) Loaded ===")
