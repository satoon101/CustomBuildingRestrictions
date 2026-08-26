-- ===========================================================================
--  Custom District Rules (Config) - Gameplay Script
--  Provides Configuration values for restricting districts/buildings.
-- ===========================================================================

include("DistrictRestrictions_Constants")
include("DistrictRestrictions_DistrictFunctions")
include("DistrictRestrictions_BuildingFunctions")

DistrictRestrictions = {
    ["DISTRICT_AERODROME"] = {
        ["era"] = INFORMATION_ERA_INDEX
    },
    ["DISTRICT_AQUEDUCT"] = {
        ["disabled"] = true,
        ["disabled_buildings"] = {
            -- Tier 2
            ["BUILDING_JNR_BATHHOUSE"] = true,
            ["BUILDING_JNR_HAMMER_WORKS"] = true
        },
        ["tier_era"] = {
            [1] = INFORMATION_ERA_INDEX,
            [2] = INFORMATION_ERA_INDEX,
            [3] = INFORMATION_ERA_INDEX
        }
    },
    ["DISTRICT_CAMPUS"] = {
        ["disabled"] = true,
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_JNR_ACADEMY"] = true,
            -- Tier 2
            ["BUILDING_JNR_SCHOOL"] = true,
            -- Tier 3
            ["BUILDING_JNR_LIBERAL_ARTS"] = true,
            -- Tier 4
            ["BUILDING_JNR_EDUCATION"] = true,
        },
        ["tier_era"] = {
            [1] = CLASSICAL_ERA_INDEX,
            [2] = RENAISSANCE_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX,
            [4] = ATOMIC_ERA_INDEX
        }
    },
    ["DISTRICT_CANAL"] = {
        ["disabled"] = true
    },
    ["DISTRICT_CITY_CENTER"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_MONUMENT"] = true,
            -- Tier 3
            ["BUILDING_JNR_WHARF_TRADE"] = true
        },
        ["tier_era"] = {
            [3] = INDUSTRIAL_ERA_INDEX
        }
    },
    ["DISTRICT_COMMERCIAL_HUB"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_JNR_WAYSTATION"] = true,
            -- Tier 2
            ["BUILDING_JNR_GUILDHALL"] = true,
            ["BUILDING_JNR_MERCHANT_QUARTER"] = true,
            -- Tier 3
            ["BUILDING_JNR_COMMODITY_EXCHANGE"] = true,
            ["BUILDING_STOCK_EXCHANGE"] = true,
        },
        ["tier_era"] = {
            [1] = CLASSICAL_ERA_INDEX,
            [2] = INDUSTRIAL_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX
        },
        ["functions"] = {
            ["BUILDING_JNR_MINT"] = RestrictForStableGovernor,
            ["BUILDING_MARKET"] = RestrictForStableGovernor
        }
    },
    ["DISTRICT_DAM"] = {
        ["tier_era"] = {
            [1] = ATOMIC_ERA_INDEX
        },
        ["function"] = CheckDamRestricted
    },
    ["DISTRICT_DIPLOMATIC_QUARTER"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_CONSULATE"] = true,
            ["BUILDING_JNR_CONSULATE_SPIES"] = true
        },
        ["disabled"] = true,
        ["era"] = ATOMIC_ERA_INDEX
    },
    ["DISTRICT_ENCAMPMENT"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_JNR_TARGET_RANGE"] = true,
            -- Tier 2
            ["BUILDING_JNR_CASEMATES"] = true,
            ["BUILDING_JNR_DEPOT"] = true,
            -- Tier 3
            ["BUILDING_JNR_ORDNANCE_BOARD"] = true,
            ["BUILDING_JNR_PRISON"] = true
        },
        ["tier_era"] = {
            [1] = CLASSICAL_ERA_INDEX,
            [2] = RENAISSANCE_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX
        },
        ["functions"] = {
            ["BUILDING_BARRACKS"] = nil
        }
    },
    ["DISTRICT_ENTERTAINMENT_COMPLEX"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_ARENA"] = true,
            -- Tier 2
            ["BUILDING_JNR_BOTANICAL_GARDEN"] = true,
            -- Tier 3
            ["BUILDING_JNR_CONVENTION"] = true
        },
        ["tier_era"] = {
            [1] = CLASSICAL_ERA_INDEX,
            [2] = MODERN_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX
        }
    },
    ["DISTRICT_GOVERNMENT"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_GOV_CONQUEST"] = true,
            ["BUILDING_GOV_TALL"] = true,
            -- Tier 2
            ["BUILDING_GOV_CITYSTATES"] = true,
            ["BUILDING_GOV_SPIES"] = true,
            -- Tier 3
            ["BUILDING_GOV_CULTURE"] = true,
            ["BUILDING_GOV_SCIENCE"] = true,
            -- Tier 4
            ["BUILDING_GOV_JNR_DIPLOMACY"] = true,
            ["BUILDING_GOV_JNR_PROPAGANDA"] = true,
        },
        ["disabled"] = true
    },
    ["DISTRICT_HARBOR"] = {
        ["disabled_buildings"] = {
            -- Tier 1
            ["BUILDING_JNR_LIGHTHOUSE_FISHING"] = true,
            -- Tier 2
            ["BUILDING_JNR_ENTREPOT"] = true,
            -- Tier 3
            ["BUILDING_JNR_OFFSHORE_TERMINAL"] = true,
            ["BUILDING_SEAPORT"] = true
        },
        ["tier_era"] = {
            [1] = CLASSICAL_ERA_INDEX,
            [2] = RENAISSANCE_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX
        }
    },
    ["DISTRICT_HOLY_SITE"] = {
        ["disabled_buildings"] = {
            -- Tier 4
            ["BUILDING_JNR_HOSPITIUM"] = true
        },
        ["tier_era"] = {
            [4] = ATOMIC_ERA_INDEX
        },
        ["functions"] = {
            ["BUILDING_JNR_ALTAR"] = RestrictForStableGovernor,
            ["BUILDING_SHRINE"] = RestrictForStableGovernor,
            ["BUILDING_JNR_MONASTERY"] = RestrictForTier2HolySite,
            ["BUILDING_TEMPLE"] = RestrictForTier2HolySite
        }
    },
    ["DISTRICT_INDUSTRIAL_ZONE"] = {
        ["disabled_buildings"] = {
            --  Tier 2
            ["BUILDING_JNR_MANUFACTURY"] = true,
            --  Tier 3
            ["BUILDING_FACTORY"] = true,
            --  Tier 4
            ["BUILDING_COAL_POWER_PLANT"] = true,
            ["BUILDING_FOSSIL_FUEL_POWER_PLANT"] = true,
            ["BUILDING_JNR_FREIGHT_YARD"] = true
        },
        ["tier_era"] = {
            [1] = INDUSTRIAL_ERA_INDEX,
            [2] = ATOMIC_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX,
            [4] = ATOMIC_ERA_INDEX
        },
        ["functions"] = {
            ["BUILDING_JNR_WIND_MILL"] = RestrictWindMill
        }
    },
    ["DISTRICT_NEIGHBORHOOD"] = {
        ["disabled_buildings"] = {
            --  Tier 2
            ["BUILDING_JNR_ART_GALLERY"] = true,
            ["BUILDING_JNR_HOSPITAL"] = true
        },
        ["era"] = ATOMIC_ERA_INDEX,
        ["disabled"] = true,
        ["tier_era"] = {
            [1] = INFORMATION_ERA_INDEX,
            [2] = INFORMATION_ERA_INDEX
        }
    },
    ["DISTRICT_PRESERVE"] = {
        ["era"] = ATOMIC_ERA_INDEX,
        ["tier_era"] = {
            [1] = INFORMATION_ERA_INDEX
        }
    },
    ["DISTRICT_SPACEPORT"] = {
        ["era"] = ATOMIC_ERA_INDEX,
        ["disabled"] = true
    },
    ["DISTRICT_THEATER"] = {
        ["disabled_buildings"] = {
            --  Tier 1
            ["BUILDING_JNR_ASSEMBLY"] = true,
            --  Tier 2
            ["BUILDING_JNR_CABINET"] = true,
            -- Tier 3
            ["BUILDING_JNR_OPERA"] = true,
            -- Tier 4
            ["BUILDING_BROADCAST_CENTER"] = true
        },
        ["era"] = ATOMIC_ERA_INDEX,
        ["tier_era"] = {
            [1] = ATOMIC_ERA_INDEX,
            [2] = ATOMIC_ERA_INDEX,
            [3] = INFORMATION_ERA_INDEX,
            [4] = INFORMATION_ERA_INDEX
        },
        ["functions"] = {
            ["BUILDING_MUSEUM_ART"] = nil,
            ["BUILDING_MUSEUM_ARTIFACT"] = nil
        }
    },
    ["DISTRICT_WATER_ENTERTAINMENT_COMPLEX"] = {
        ["disabled_buildings"] = {
            --  Tier 1
            ["BUILDING_JNR_MARINA"] = true,
            --  Tier 2
            ["BUILDING_AQUARIUM"] = true,
            --  Tier 3
            ["BUILDING_JNR_CRUISE_TERMINAL"] = true
        },
        ["tier_era"] = {
            [1] = INDUSTRIAL_ERA_INDEX,
            [2] = MODERN_ERA_INDEX,
            [3] = ATOMIC_ERA_INDEX
        }
    }
}

print("=== Custom District Rules (Config) Loaded ===")
