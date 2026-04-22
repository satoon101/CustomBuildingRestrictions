-- ===========================================================================
--  Custom District Rules (Config) - Gameplay Script
--  Provides Configuration values for restricting districts/buildings.
-- ===========================================================================

-- ERA REFERENCE:
--      0 = ERA_ANCIENT
--      1 = ERA_CLASSICAL (turn 61)
--      2 = ERA_MEDIEVAL (turn 121)
--      3 = ERA_RENAISSANCE (turn 181)
--      4 = ERA_INDUSTRIAL (turn 241)
--      5 = ERA_MODERN (turn 301)
--      6 = ERA_ATOMIC (turn 361)
--      7 = ERA_INFORMATION (turn 421)
--      8 = ERA_FUTURE (turn 481)

districtEraConfig = {
    ["DISTRICT_AERODROME"] = {
        ["0"] = GameInfo.Eras["ERA_INFORMATION"].Index,
        ["1"] = GameInfo.Eras["ERA_INFORMATION"].Index
    },
    ["DISTRICT_AQUEDUCT"] = {
        ["0"] = GameInfo.Eras["ERA_MEDIEVAL"].Index,
        ["1"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["2"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["Wonder"] = "BUILDING_ANGKOR_WAT"
    },
    ["DISTRICT_CAMPUS"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_RENAISSANCE"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["4"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_CITY_CENTER"] = {
        ["0"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["1"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["2"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["3"] = GameInfo.Eras["ERA_ANCIENT"].Index
    },
    ["DISTRICT_COMMERCIAL_HUB"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_RENAISSANCE"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_DAM"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_MODERN"].Index
    },
    ["DISTRICT_DIPLOMATIC_QUARTER"] = {
        ["0"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["1"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["2"] = GameInfo.Eras["ERA_MODERN"].Index
    },
    ["DISTRICT_ENCAMPMENT"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_RENAISSANCE"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_ENTERTAINMENT_COMPLEX"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_GOVERNMENT"] = {
        ["0"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["1"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["2"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["3"] = GameInfo.Eras["ERA_ANCIENT"].Index,
        ["4"] = GameInfo.Eras["ERA_ANCIENT"].Index
    },
    ["DISTRICT_HARBOR"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_RENAISSANCE"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_HOLY_SITE"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["2"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["3"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["4"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_INDUSTRIAL_ZONE"] = {
        ["0"] = GameInfo.Eras["ERA_MEDIEVAL"].Index,
        ["1"] = GameInfo.Eras["ERA_MEDIEVAL"].Index,
        ["2"] = GameInfo.Eras["ERA_MEDIEVAL"].Index,
        ["3"] = GameInfo.Eras["ERA_MEDIEVAL"].Index,
        ["4"] = GameInfo.Eras["ERA_INDUSTRIAL"].Index,
        ["5"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["6"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_NEIGHBORHOOD"] = {
        ["0"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["1"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["2"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["Wonder"] = "BUILDING_BIOSPHERE"
    },
    ["DISTRICT_PRESERVE"] = {
        ["0"] = GameInfo.Eras["ERA_ATOMIC"].Index,
        ["1"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_SPACEPORT"] = {
        ["0"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["1"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_THEATER"] = {
        ["0"] = GameInfo.Eras["ERA_INDUSTRIAL"].Index,
        ["1"] = GameInfo.Eras["ERA_INDUSTRIAL"].Index,
        ["2"] = GameInfo.Eras["ERA_INDUSTRIAL"].Index,
        ["3"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["4"] = GameInfo.Eras["ERA_ATOMIC"].Index
    },
    ["DISTRICT_WATER_ENTERTAINMENT_COMPLEX"] = {
        ["0"] = GameInfo.Eras["ERA_CLASSICAL"].Index,
        ["1"] = GameInfo.Eras["ERA_INDUSTRIAL"].Index,
        ["2"] = GameInfo.Eras["ERA_MODERN"].Index,
        ["3"] = GameInfo.Eras["ERA_ATOMIC"].Index
    } 
}

print("=== Custom District Rules (Config) Loaded ===")
