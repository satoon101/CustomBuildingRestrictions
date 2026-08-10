-- ===========================================================================
--  Custom District Rules (Config) - Gameplay Script
--  Provides Configuration values for restricting districts/buildings.
-- ===========================================================================

include("DistrictRestrictions_Special")

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

ANCIENT_ERA_INDEX = GameInfo.Eras["ERA_ANCIENT"].Index
CLASSICAL_ERA_INDEX = GameInfo.Eras["ERA_CLASSICAL"].Index
MEDIEVAL_ERA_INDEX = GameInfo.Eras["ERA_MEDIEVAL"].Index
RENAISSANCE_ERA_INDEX = GameInfo.Eras["ERA_RENAISSANCE"].Index
INDUSTRIAL_ERA_INDEX = GameInfo.Eras["ERA_INDUSTRIAL"].Index
MODERN_ERA_INDEX = GameInfo.Eras["ERA_MODERN"].Index
ATOMIC_ERA_INDEX = GameInfo.Eras["ERA_ATOMIC"].Index
INFORMATION_ERA_INDEX = GameInfo.Eras["ERA_INFORMATION"].Index
FUTURE_ERA_INDEX = GameInfo.Eras["ERA_FUTURE"].Index

alwaysRestrict = {
    ["districts"] = {
        ["DISTRICT_CANAL"] = true
    },
    ["buildings"] = {
        -- DISTRICT_AQUEDUCT
        --  Tier 2
        ["BUILDING_JNR_BATHHOUSE"] = true,
        ["BUILDING_JNR_HAMMER_WORKS"] = true,

        -- DISTRICT_CITY_CENTER
        --  Tier 3
        ["BUILDING_JNR_WHARF_TRADE"] = true,

        -- DISTRICT_COMMERCIAL_HUB
        --  Tier 1
        ["BUILDING_JNR_WAYSTATION"] = true,
        --  Tier 2
        ["BUILDING_JNR_GUILDHALL"] = true,
        ["BUILDING_JNR_MERCHANT_QUARTER"] = true,
        --  Tier 3
        ["BUILDING_JNR_COMMODITY_EXCHANGE"] = true,
        ["BUILDING_STOCK_EXCHANGE"] = true,

        -- DISTRICT_DIPLOMATIC_QUARTER
        --  Tier 1
        ["BUILDING_CONSULATE"] = true,
        ["BUILDING_JNR_CONSULATE_SPIES"] = true,

        -- DISTRICT_ENCAMPMENT
        --  Tier 1
        ["BUILDING_JNR_TARGET_RANGE"] = true,
        --  Tier 2
        ["BUILDING_JNR_CASEMATES"] = true,
        ["BUILDING_JNR_DEPOT"] = true,
        --  Tier 3
        ["BUILDING_JNR_ORDNANCE_BOARD"] = true,
        ["BUILDING_JNR_PRISON"] = true,

        -- DISTRICT_ENTERTAINMENT_COMPLEX
        --  Tier 1
        ["BUILDING_ARENA"] = true,
        --  Tier 2
        ["BUILDING_JNR_BOTANICAL_GARDEN"] = true,
        --  Tier 3
        ["BUILDING_JNR_CONVENTION"] = true,

        -- DISTRICT_GOVERNMENT
        --  Tier 1
        ["BUILDING_GOV_CONQUEST"] = true,
        ["BUILDING_GOV_TALL"] = true,
        --  Tier 2
        ["BUILDING_GOV_CITYSTATES"] = true,
        ["BUILDING_GOV_SPIES"] = true,
        --  Tier 3
        ["BUILDING_GOV_CULTURE"] = true,
        ["BUILDING_GOV_SCIENCE"] = true,
        --  Tier 4
        ["BUILDING_GOV_JNR_DIPLOMACY"] = true,
        ["BUILDING_GOV_JNR_PROPAGANDA"] = true,

        -- DISTRICT_HARBOR
        --  Tier 1
        ["BUILDING_JNR_LIGHTHOUSE_FISHING"] = true,
        --  Tier 2
        ["BUILDING_JNR_ENTREPOT"] = true,
        --  Tier 3
        ["BUILDING_JNR_OFFSHORE_TERMINAL"] = true,
        ["BUILDING_SEAPORT"] = true,

        -- DISTRICT_INDUSTRIAL_ZONE
        --  Tier 4
        ["BUILDING_JNR_MANUFACTURY"] = true,
        --  Tier 5
        ["BUILDING_FACTORY"] = true,
        --  Tier 6
        ["BUILDING_COAL_POWER_PLANT"] = true,
        ["BUILDING_FOSSIL_FUEL_POWER_PLANT"] = true,
        ["BUILDING_JNR_FREIGHT_YARD"] = true,

        -- DISTRICT_NEIGHBORHOOD
        --  Tier 2
        ["BUILDING_JNR_ART_GALLERY"] = true,
        ["BUILDING_JNR_HOSPITAL"] = true,

        -- DISTRICT_THEATER
        --  Tier 1
        ["BUILDING_JNR_ASSEMBLY"] = true,
        --  Tier 2
        ["BUILDING_JNR_CABINET"] = true,
        -- Tier 3
        ["BUILDING_JNR_OPERA"] = true,
        -- Tier 4
        ["BUILDING_BROADCAST_CENTER"] = true,

        -- DISTRICT_WATER_ENTERTAINMENT_COMPLEX
        --  Tier 1
        ["BUILDING_JNR_MARINA"] = true,
        --  Tier 2
        ["BUILDING_AQUARIUM"] = true,
        --  Tier 3
        ["BUILDING_JNR_CRUISE_TERMINAL"] = true
    }
}
-- TODO: work on adding civic/tech restriction system
-- TODO: work on adding this functionality
districtCountRestrictions = {
    ["DISTRICT_CAMPUS"] = {
        [ANCIENT_ERA_INDEX] = 2,
        [CLASSICAL_ERA_INDEX] = 2,
        [MEDIEVAL_ERA_INDEX] = 2,
        [RENAISSANCE_ERA_INDEX] = 2,
        [INDUSTRIAL_ERA_INDEX] = 2,
        [ATOMIC_ERA_INDEX] = 2,
        [INFORMATION_ERA_INDEX] = 2,
    },
    ["DISTRICT_COMMERCIAL_HUB"] = {
        [ANCIENT_ERA_INDEX] = 2,
        [CLASSICAL_ERA_INDEX] = 2,
        [MEDIEVAL_ERA_INDEX] = 2,
        [RENAISSANCE_ERA_INDEX] = 2,
        [INDUSTRIAL_ERA_INDEX] = 2,
        [ATOMIC_ERA_INDEX] = 2,
        [INFORMATION_ERA_INDEX] = 2,
    },
    ["DISTRICT_ENCAMPMENT"] = {
        [ANCIENT_ERA_INDEX] = 2,
        [CLASSICAL_ERA_INDEX] = 2,
        [MEDIEVAL_ERA_INDEX] = 2,
        [RENAISSANCE_ERA_INDEX] = 2,
        [INDUSTRIAL_ERA_INDEX] = 2,
        [ATOMIC_ERA_INDEX] = 2,
        [INFORMATION_ERA_INDEX] = 2,
    },
    ["DISTRICT_INDUSTRIAL_ZONE"] = {
        [ANCIENT_ERA_INDEX] = 2,
        [CLASSICAL_ERA_INDEX] = 2,
        [MEDIEVAL_ERA_INDEX] = 2,
        [RENAISSANCE_ERA_INDEX] = 2,
        [INDUSTRIAL_ERA_INDEX] = 2,
        [ATOMIC_ERA_INDEX] = 2,
        [INFORMATION_ERA_INDEX] = 2,
    },
}

--  Tier 0 = District
--  Tier 1+ = Buildings based off of # of prerequisites + 1
eraConfigPerDistrict = {
    ["DISTRICT_AERODROME"] = {
        ["0"] = INFORMATION_ERA_INDEX,
        ["1"] = INFORMATION_ERA_INDEX
    },
    ["DISTRICT_AQUEDUCT"] = {
        ["0"] = MEDIEVAL_ERA_INDEX,
        ["1"] = ATOMIC_ERA_INDEX,
        ["2"] = ATOMIC_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_CAMPUS"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = CLASSICAL_ERA_INDEX,
        ["2"] = RENAISSANCE_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX,
        ["4"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_CITY_CENTER"] = {
        ["0"] = ANCIENT_ERA_INDEX,
        ["1"] = ANCIENT_ERA_INDEX,
        ["2"] = ANCIENT_ERA_INDEX,
        ["3"] = ANCIENT_ERA_INDEX,
        ["BUILDING_MONUMENT"] = INDUSTRIAL_ERA_INDEX,
        ["BUILDING_CASTLE"] = RENAISSANCE_ERA_INDEX,
        ["BUILDING_STAR_FORT"] = INDUSTRIAL_ERA_INDEX
    },
    ["DISTRICT_COMMERCIAL_HUB"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = CLASSICAL_ERA_INDEX,
        ["2"] = INDUSTRIAL_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_DAM"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = MODERN_ERA_INDEX
    },
    ["DISTRICT_DIPLOMATIC_QUARTER"] = {
        ["0"] = MODERN_ERA_INDEX,
        ["1"] = MODERN_ERA_INDEX,
        ["2"] = MODERN_ERA_INDEX
    },
    ["DISTRICT_ENCAMPMENT"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = CLASSICAL_ERA_INDEX,
        ["2"] = RENAISSANCE_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_ENTERTAINMENT_COMPLEX"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = CLASSICAL_ERA_INDEX,
        ["2"] = MODERN_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_GOVERNMENT"] = {
        ["0"] = ANCIENT_ERA_INDEX,
        ["1"] = ANCIENT_ERA_INDEX,
        ["2"] = ANCIENT_ERA_INDEX,
        ["3"] = ANCIENT_ERA_INDEX,
        ["4"] = ANCIENT_ERA_INDEX
    },
    ["DISTRICT_HARBOR"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = CLASSICAL_ERA_INDEX,
        ["2"] = RENAISSANCE_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_HOLY_SITE"] = {
        ["0"] = ANCIENT_ERA_INDEX,
        ["1"] = ANCIENT_ERA_INDEX,
        ["2"] = CLASSICAL_ERA_INDEX,
        ["3"] = CLASSICAL_ERA_INDEX,
        ["4"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_INDUSTRIAL_ZONE"] = {
        ["0"] = MEDIEVAL_ERA_INDEX,
        ["1"] = INDUSTRIAL_ERA_INDEX,
        ["2"] = INDUSTRIAL_ERA_INDEX,
        ["3"] = INDUSTRIAL_ERA_INDEX,
        ["4"] = INDUSTRIAL_ERA_INDEX,
        ["5"] = MODERN_ERA_INDEX,
        ["6"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_NEIGHBORHOOD"] = {
        ["0"] = MODERN_ERA_INDEX,
        ["1"] = ATOMIC_ERA_INDEX,
        ["2"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_PRESERVE"] = {
        ["0"] = ATOMIC_ERA_INDEX,
        ["1"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_SPACEPORT"] = {
        ["0"] = MODERN_ERA_INDEX,
        ["1"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_THEATER"] = {
        ["0"] = INDUSTRIAL_ERA_INDEX,
        ["1"] = INDUSTRIAL_ERA_INDEX,
        ["2"] = INDUSTRIAL_ERA_INDEX,
        ["3"] = MODERN_ERA_INDEX,
        ["4"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_WATER_ENTERTAINMENT_COMPLEX"] = {
        ["0"] = CLASSICAL_ERA_INDEX,
        ["1"] = INDUSTRIAL_ERA_INDEX,
        ["2"] = MODERN_ERA_INDEX,
        ["3"] = ATOMIC_ERA_INDEX
    } 
}

districtMapPinRestrictions = {
    ["DISTRICT_DIPLOMATIC_QUARTER"] = true,
    ["DISTRICT_SPACEPORT"] = true,
    ["DISTRICT_GOVERNMENT"] = "BUILDING_CASA_DE_CONTRATACION",
    ["DISTRICT_AQUEDUCT"] = "BUILDING_ANGKOR_WAT",
    ["DISTRICT_NEIGHBORHOOD"] = "BUILDING_BIOSPHERE",
}

buildingMapPinRestrictions = {
    ["BUILDING_BARRACKS"] = "BUILDING_STATUE_OF_ZEUS"
}

specialRestrictions = {
    ["districts"] = {},
    ["buildings"] = {
        -- Restrict the wind mill when water mill is available
        ["BUILDING_JNR_WIND_MILL"] = restrictWindMill,

        -- Restrict Commercial Hub buildings
        ["BUILDING_JNR_MINT"] = restrictCommercialTier1,
        ["BUILDING_JNR_WAYSTATION"] = restrictCommercialTier1,
        ["BUILDING_MARKET"] = restrictCommercialTier1,

        -- Restrict Holy Site buildings
        ["BUILDING_JNR_ALTAR"] = restrictHolySiteTier1,
        ["BUILDING_SHRINE"] = restrictHolySiteTier1,

        -- Restrict Industrial Zone buildings
        ["BUILDING_WORKSHOP"] = restrictWorkshopForDaVinci,

        -- Restrict Theater district buildings
        ["BUILDING_JNR_MANSION"] = restrictCivicSquareByTier,
        ["BUILDING_JNR_GRAND_HOTEL"] = restrictCivicSquareByTier,
        ["BUILDING_JNR_OPERA"] = restrictCivicSquareByTier,
        ["BUILDING_MUSEUM_ART"] = restrictCivicSquareMuseums,
        ["BUILDING_MUSEUM_ARTIFACT"] = restrictCivicSquareMuseums,
        ["BUILDING_BROADCAST_CENTER"] = restrictCivicSquareByTier,
        ["BUILDING_JNR_MEDIA_CENTER"] = restrictCivicSquareByTier,
    }
}

print("=== Custom District Rules (Config) Loaded ===")
