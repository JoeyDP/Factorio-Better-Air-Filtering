data:extend({
    {
        type = "recipe-category",
        name = "air-filtering-basic"
    },
    {
        type = "recipe-category",
        name = "air-filtering-advanced"
    },
    {
        type = "recipe",
        name = "air-filter-machine-1",
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "assembling-machine-2", 1 },
            { "electronic-circuit", 5 },
            { "steel-plate", 10 }
        },
        result = "air-filter-machine-1"
    },
    {
        type = "recipe",
        name = "air-filter-machine-2",
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "air-filter-machine-1", 2 },
            { "advanced-circuit", 10 }
        },
        result = "air-filter-machine-2"
    },
    {
        type = "recipe",
        name = "air-filter-machine-3",
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "air-filter-machine-2", 2 },
            { "processing-unit", 10 }
        },
        result = "air-filter-machine-3"
    },
    {
        type = "recipe",
        name = "expendable-air-filter",
        category = "crafting",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[expendable-air-filter]",
        energy_required = 2,
        enabled = "true",
        ingredients =
        {
            { "coal", 5 },
            { "iron-plate", 2 },
        },
        result = "expendable-air-filter"
    },
    {
        type = "recipe",
        name = "unused-air-filter",
        category = "crafting",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[unused-air-filter]",
        energy_required = 5,
        enabled = "false",
        ingredients =
        {
            { "coal", 10 },
            { "plastic-bar", 4 },
            { "steel-plate", 2 }
        },
        result = "unused-air-filter"
    },
    {
        type = "recipe",
        name = "filter-air",
        hide_from_player_crafting = true,
        icon = "__better-air-filtering__/graphics/icons/recipe/filter-air.png",
        icon_size = 32,
        category = "air-filtering-basic",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 0.5,
        enabled = "true",
        ingredients =
        {
            { type = "fluid", name = "pollution", amount = 2, fluidbox_index = 1 }
        },
        results = {}
    },
    {
        type = "recipe",
        name = "filter-air2",
        hide_from_player_crafting = true,
        icon = "__better-air-filtering__/graphics/icons/recipe/filter-air.png",
        icon_size = 32,
        category = "air-filtering-advanced",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 5,
        enabled = "true",
        ingredients =
        {
            { type = "fluid", name = "pollution", amount = 25, fluidbox_index = 1 },
            { type = "item", name = "unused-air-filter", amount = 1 },
        },
        results = { { type = "item", name = "used-air-filter", amount = 1 } }
    },
    {
        type = "recipe",
        name = "liquid-pollution",
        hide_from_player_crafting = true,
        category = "air-filtering-advanced",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 0.5,
        enabled = "true",
        ingredients =
        {
            { type = "fluid", name = "pollution", amount = 6, fluidbox_index = 1 },
            { type = "fluid", name = "water", amount = 10, fluidbox_index = 2 }
        },
        results = { { type = "fluid", name = "polluted-water", amount = 10 } }
    },
    {
        type = "recipe",
        name = "air-filter-recycling",
        icons = {
            {
                icon = "__better-air-filtering__/graphics/icons/used-air-filter.png"
            },
            {
                icon = "__better-air-filtering__/graphics/icons/recipe/recycle.png",
                scale = 0.6,
                shift = { 6, 6 }
            },
        },
        icon_size = 32,
        category = "crafting",
        subgroup = "raw-material",
        order = "f[unused-air-filter]-f[air-filter-recycling]",
        energy_required = 5,
        enabled = "false",
        ingredients =
        {
            { "used-air-filter", 1 },
            { "coal", 5 }
        },
        result = "unused-air-filter"
    }
})
