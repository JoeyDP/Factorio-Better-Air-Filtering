data:extend({
    {
        type = "technology",
        name = "air-filtering-1",
        localised_description = {"technology-description.air-filtering-1"},
        icon = "__better-air-filtering__/graphics/technology/air-filtering-1.png",
        icon_size = "64",
        prerequisites = { "automation", "electronics" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "air-filter-machine-1"
            },
            {
                type = "unlock-recipe",
                recipe = "expendable-air-filter"
            },
            {
                type = "unlock-recipe",
                recipe = "filter-air"
            }
        },
        unit = {
            count = 100,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 }
            },
            time = 30
        },
        order = "d-a-a"
    },
    {
        type = "technology",
        name = "reusable-air-filters",
        icon = "__better-air-filtering__/graphics/technology/reusable-air-filters.png",
        icon_size = "64",
        prerequisites = { "air-filtering-1", "plastics", "steel-processing" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "air-filter"
            }
        },
        unit = {
            count = 200,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
            },
            time = 30
        },
        order = "d-a-b"
    },
    {
        type = "technology",
        name = "air-filter-recycling",
        icon = "__better-air-filtering__/graphics/technology/air-filter-recycling.png",
        icon_size = "64",
        prerequisites = { "reusable-air-filters" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "air-filter-recycling"
            }
        },
        unit = {
            count = 200,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 },
            },
            time = 30
        },
        order = "d-a-c"
    },
    {
        type = "technology",
        name = "air-filtering-2",
        localised_description = {"technology-description.air-filtering-2"},
        icon = "__better-air-filtering__/graphics/technology/air-filtering-2.png",
        icon_size = "64",
        prerequisites = { "air-filtering-1", "reusable-air-filters", "advanced-electronics" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "air-filter-machine-2"
            },

            {
                type = "unlock-recipe",
                recipe = "filter-air2"
            }
        },
        unit = {
            count = 300,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 1 }
            },
            time = 60
        },
        order = "d-a-d"
    },
    {
        type = "technology",
        name = "air-filtering-3",
        localised_description = {"technology-description.air-filtering-3"},
        icon = "__better-air-filtering__/graphics/technology/air-filtering-3.png",
        icon_size = "64",
        prerequisites = { "air-filtering-2" },
        effects = {
            {
                type = "unlock-recipe",
                recipe = "air-filter-machine-3"
            }
        },
        unit = {
            count = 500,
            ingredients = {
                { "automation-science-pack", 1 },
                { "logistic-science-pack", 1 },
                { "chemical-science-pack", 2 },
                { "production-science-pack", 1 }
            },
            time = 60
        },
        order = "d-a-e"
    }
})
