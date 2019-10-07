data:extend({
    {
        type = "fluid",
        name = "pollution",
        default_temperature = 15,
        max_temperature = 100,
        gas_temperature = 0,
        base_color = {r=0.95, g=0.9, b=0.9},
        flow_color = {r=0.95, g=0.9, b=0.9},
        icon = "__base__/graphics/icons/fluid/pollution.png",
        icon_size = 32,
        order = "a[fluid]-z[water]",
        auto_barrel="false"
    },
    {
        type = "fluid",
        name = "polluted-water",
        default_temperature = 15,
        max_temperature = 100,
        base_color = {r=0.27, g=0.30, b=0.34},
        flow_color = {r=0.27, g=0.30, b=0.34},
        icon = "__better-air-filtering__/graphics/icons/fluid/pollution.png",
        icon_size = 32,
        order = "a[fluid]-z[pollution]",
        auto_barrel="false"
    }
})