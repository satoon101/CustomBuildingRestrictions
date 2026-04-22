-- ===========================================================================
--  Custom District Rules - UI Script
--  Overrides MapPinPopup to refresh data on Ok & Delete.
-- ===========================================================================

print("=== Custom District Rules (MapPinPopup) Loading ===")

include("MapPinPopup")
include("MapTack_Interface")

local BASE_OnOk = OnOk

function OnOk()
    BASE_OnOk()
    SyncPins()
end

local BASE_OnDelete = OnDelete

function OnDelete()
    BASE_OnDelete()
    SyncPins()
end

local BASE_OnMapPinPlayerInfoChanged = OnMapPinPlayerInfoChanged;

function OnMapPinPlayerInfoChanged(playerID)
    -- If VisibilityPull is nil, the window is closing; don't try to update it
    if Controls.VisibilityPull ~= nil then
        BASE_OnMapPinPlayerInfoChanged(playerID);
    end
end

if Controls.OkButton then
    Controls.OkButton:RegisterCallback(Mouse.eLClick, OnOk)
end

if Controls.DeleteButton then
    Controls.DeleteButton:RegisterCallback(Mouse.eLClick, OnDelete)
end

print("=== Custom District Rules (MapPinPopup) Loaded ===")
