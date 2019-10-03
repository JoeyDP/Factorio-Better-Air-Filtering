data:extend({
    {
        type = "fluid",
        name = "pollution",
        default_temperature = 5,
        max_temperature = 15,
        base_color = {r=0.38, g=0.27, b=0.53},  -- 97, 69, 135
        flow_color = {r=0.7, g=0.7, b=0.7},
        icon = "__better-air-filtering__/graphics/icons/fluid/pollution.png",
        icon_size = 32,
        order = "a[fluid]-z[water]",
        auto_barrel="false"
    },
    {
        type = "fluid",
        name = "pollution-gas",
        default_temperature = 15,
        max_temperature = 100,
        gas_temperature = 15,
        base_color = {r=0.38, g=0.27, b=0.53},  -- 97, 69, 135
        flow_color = {r=0.7, g=0.7, b=0.7},
        icon = "__base__/graphics/icons/fluid/pollution.png",
        icon_size = 32,
        order = "a[fluid]-z[water]",
        auto_barrel="false"
    }
})