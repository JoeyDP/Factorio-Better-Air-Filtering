data:extend({
    {
        type = "recipe-category",
        name = "crafting-air-filter"
    },
    {
        type = "recipe-category",
        name = "suck-air"
    },
    {
        type = "recipe",
        name = "air-filter-machine",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine.png",
        icon_size = 32,
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "assembling-machine-2", 1 },
            { "electronic-circuit", 5 },
            { "steel-plate", 10 }
        },
        result = "air-filter-machine"
    },
    {
        type = "recipe",
        name = "air-filter-machine-mk2",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-mk2.png",
        icon_size = 32,
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "air-filter-machine", 2 },
            { "advanced-circuit", 10 }
        },
        result = "air-filter-machine-mk2"
    },
    {
        type = "recipe",
        name = "air-filter-machine-mk3",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-mk3.png",
        icon_size = 32,
        energy_required = 10.0,
        enabled = "false",
        ingredients =
        {
            { "air-filter-machine-mk2", 2 },
            { "processing-unit", 10 }
        },
        result = "air-filter-machine-mk3"
    },
    {
        type = "recipe",
        name = "unused-air-filter",
        icon = "__better-air-filtering__/graphics/icons/unused-air-filter.png",
        icon_size = 32,
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
        icon = "__better-air-filtering__/graphics/icons/filter-air.png",
        icon_size = 32,
        category = "crafting-air-filter",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 0.5,
        enabled = "true",
        ingredients =
        {
            {type="fluid", name="pollution-gas", amount=2}
        },
        results = {}
    },
    {
        type = "recipe",
        name = "suck-pollution",
        category = "suck-air",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 0.5,
        enabled = "true",
        ingredients =
        {
        },
        results = {{type="fluid", name="pollution-gas", amount=4}}
    },
    {
        type = "recipe",
        name = "liquid-pollution",
--        icon = "__better-air-filtering__/graphics/icons/filter-air.png",
--        icon_size = 32,
        category = "suck-air",
        subgroup = "raw-material",
        order = "f[plastic-bar]-f[filter-air]",
        energy_required = 0.5,
        enabled = "true",
        ingredients =
        {
            {type="fluid", name="pollution-gas", amount=6, fluidbox_index=1},
            {type="fluid", name="water", amount=10, fluidbox_index=2}
        },
        results = {{type="fluid", name="pollution", amount=10}}
    },
--    {
--        type = "recipe",
--        name = "debug-pollution",
----        icon = "__base__/graphics/icons/pollution.png",
----        icon_size = 32,
--        category = "crafting-with-fluid",
--        subgroup = "raw-material",
--        order = "f[plastic-bar]-f[filter-air]",
--        energy_required = 1,
--        enabled = "true",
--        ingredients =
--        {
--
--        },
--        results = {{type="fluid", name="pollution-gas", amount=10}}
--    },
    {
        type = "recipe",
        name = "air-filter-recycling",
        icon = "__better-air-filtering__/graphics/icons/air-filter-recycling.png",
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
