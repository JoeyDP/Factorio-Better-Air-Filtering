data:extend({
    {
        type = "fluid",
        name = "pollution",
        default_temperature = 15,
        max_temperature = 100,
        gas_temperature = 0,
        base_color = {r=0.7, g=0.7, b=0.7},
        flow_color = {r=0.7, g=0.7, b=0.7},
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
        base_color = {r=0.7, g=0.7, b=0.7},
        flow_color = {r=0.7, g=0.7, b=0.7},
        icon = "__better-air-filtering__/graphics/icons/fluid/pollution.png",
        icon_size = 32,
        order = "a[fluid]-z[pollution]",
        auto_barrel="false"
    }
})