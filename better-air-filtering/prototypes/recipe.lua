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
        enabled = false,
        ingredients =
        {
            { "assembling-machine-1", 1 },
            { "electronic-circuit", 5 }
        },
        result = "air-filter-machine-1"
    },
    {
        type = "recipe",
        name = "air-filter-machine-2",
        energy_required = 10.0,
        enabled = false,
        ingredients =
        {
            { "air-filter-machine-1", 2 },
            { "steel-plate", 10 },
            { "advanced-circuit", 10 }
        },
        result = "air-filter-machine-2"
    },
    {
        type = "recipe",
        name = "air-filter-machine-3",
        energy_required = 10.0,
        enabled = false,
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
        order = "f[plastic-bar]-a[expendable-air-filter]",
        energy_required = 2,
        enabled = false,
        ingredients =
        {
            { "coal", 5 },
            { "iron-plate", 2 },
        },
        result = "expendable-air-filter"
    },
    {
        type = "recipe",
        name = "air-filter",
        category = "crafting",
        subgroup = "raw-material",
        order = "f[plastic-bar]-b[air-filter]",
        energy_required = 5,
        enabled = false,
        ingredients =
        {
            { "coal", 10 },
            { "plastic-bar", 4 },
            { "steel-plate", 2 }
        },
        result = "air-filter"
    },
    {
        type = "recipe",
        name = "air-filter-recycling",
        icons = {
            {
                icon = "__better-air-filtering__/graphics/icons/air-filter.png"
            },
            {
                icon = "__better-air-filtering__/graphics/icons/used-air-filter-mask.png",
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
        order = "f[plastic-bar]-c[air-filter-recycling]",
        energy_required = 2,
        enabled = false,
        ingredients =
        {
            { "used-air-filter", 1 },
            { "coal", 5 }
        },
        result = "air-filter",
        main_product = ""
    },
    {
        type = "recipe",
        name = "filter-air",
        hide_from_player_crafting = true,
        icons = {
            {
                icon = "__base__/graphics/icons/fluid/pollution.png"
            },
            {
                icon = "__better-air-filtering__/graphics/icons/recipe/filter-air.png",
                scale = 0.6,
                shift = { 6, 6 }
            },
        },
        icon_size = 32,
        category = "air-filtering-basic",
        subgroup = "raw-material",
        order = "a[filter-air]",
        energy_required = 1,
        enabled = false,
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
        icons = {
            {
                icon = "__base__/graphics/icons/fluid/pollution.png"
            },
            {
                icon = "__better-air-filtering__/graphics/icons/recipe/filter-air.png",
                scale = 0.6,
                shift = { 6, 6 }
            },
        },
        icon_size = 32,
        category = "air-filtering-advanced",
        subgroup = "raw-material",
        order = "b[filter-air]",
        energy_required = 5,
        enabled = false,
        ingredients =
        {
            { type = "fluid", name = "pollution", amount = 20, fluidbox_index = 1 },
            { type = "item", name = "air-filter", amount = 1 },
        },
        results = { { type = "item", name = "used-air-filter", amount = 1 } },
        main_product = ""
    },
    {
        type = "recipe",
        name = "liquid-pollution",
        hide_from_player_crafting = true,
        category = "air-filtering-advanced",
        subgroup = "raw-material",
        order = "c[filter-air]",
        energy_required = 1,
        enabled = false,
        ingredients =
        {
            { type = "fluid", name = "pollution", amount = 6, fluidbox_index = 1 },
            { type = "fluid", name = "water", amount = 10, fluidbox_index = 2 }
        },
        results = { { type = "fluid", name = "polluted-water", amount = 10 } }
    }
})
