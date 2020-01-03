data:extend({
    {
        type = "furnace",
        name = "air-filter-machine-1",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-1.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine-1" },
        --fast_replaceable_group = "air-filter-machine",
        max_health = 150,
        corpse = "medium-remnants",
        alert_icon_shift = util.by_pixel(-3, -12),
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation = {
            layers = {
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-1.png",
                    priority = "medium",
                    width = 108,
                    height = 114,
                    frame_count = 32,
                    animation_speed = 0.8,
                    line_length = 8,
                    shift = util.by_pixel(0, 2)
                },
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-shadow.png",
                    priority = "medium",
                    width = 95,
                    height = 83,
                    frame_count = 1,
                    animation_speed = 0.8,
                    line_length = 1,
                    repeat_count = 32,
                    draw_as_shadow = true,
                    shift = util.by_pixel(8.5, 5.5)
                }
            }
        },
        match_animation_speed_to_activity = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound = {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes = {
            {
                production_type = "input",
                base_area = 0.2,
                base_level = -1,
                pipe_connections = {},
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-basic" },
        crafting_speed = 0.5,
        energy_source = {
            type = "burner",
            fuel_category = "pollution-filter",
            usage_priority = "secondary-input",
            fuel_inventory_size = 1,
            burnt_inventory_size = 1,
        },
        energy_usage = "50kW",
        result_inventory_size = 0,
        source_inventory_size = 0,
        --ingredient_count = 1,
        return_ingredients_on_change = true,
        module_specification = {
            module_slots = 0
        },
        allowed_effects = nil
    },
    {
        type = "furnace",
        name = "air-filter-machine-2",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-2.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine-2" },
        fast_replaceable_group = "air-filter-machine",
        next_upgrade = "air-filter-machine-3",
        max_health = 200,
        corpse = "medium-remnants",
        alert_icon_shift = util.by_pixel(-3, -12),
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation = {
            layers = {
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-2.png",
                    priority = "medium",
                    width = 108,
                    height = 110,
                    frame_count = 32,
                    line_length = 8,
                    shift = util.by_pixel(0, 4),
                },
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-shadow.png",
                    priority = "medium",
                    width = 95,
                    height = 83,
                    frame_count = 1,
                    line_length = 1,
                    repeat_count = 32,
                    draw_as_shadow = true,
                    shift = util.by_pixel(8.5, 5.5)
                }
            }
        },
        match_animation_speed_to_activity = true,
        entity_info_icon_shift={0, -0.3},
        scale_entity_info_icon = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound = {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes = {
            {
                production_type = "input",
                base_area = 0.4,
                base_level = -1,
                pipe_connections = {}
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-advanced" },
        crafting_speed = 1.0,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            drain = "200kW",
        },
        energy_usage = "100kW",
        result_inventory_size = 1,
        source_inventory_size = 1,
        module_specification = {
            module_slots = 2
        },
        allowed_effects = { "consumption", "speed" },
        return_ingredients_on_change = true,
    },
    {
        type = "furnace",
        name = "air-filter-machine-3",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-3.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine-3" },
        fast_replaceable_group = "air-filter-machine",
        max_health = 250,
        corpse = "medium-remnants",
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation = {
            layers = {
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-3.png",
                    priority = "medium",
                    width = 108,
                    height = 119,
                    frame_count = 32,
                    line_length = 8,
                    shift = util.by_pixel(0, -0.5),
                },
                {
                    filename = "__better-air-filtering__/graphics/entity/air-filter-machine-shadow.png",
                    priority = "medium",
                    width = 95,
                    height = 83,
                    frame_count = 1,
                    line_length = 1,
                    repeat_count = 32,
                    draw_as_shadow = true,
                    shift = util.by_pixel(8.5, 5.5)
                }
            }
        },
        match_animation_speed_to_activity = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound = {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes = {
            {
                production_type = "input",
                base_area = 0.4,
                base_level = -1,
                pipe_connections = {}
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-advanced" },
        crafting_speed = 1.25,
        energy_source = {
            type = "electric",
            usage_priority = "secondary-input",
            drain = "300kW",
        },
        energy_usage = "200kW",
        fixed_recipe = "filter-air2",
        result_inventory_size = 1,
        source_inventory_size = 1,
        module_specification = {
            module_slots = 3
        },
        allowed_effects = { "consumption", "speed" },
        return_ingredients_on_change = true,
    }
})
