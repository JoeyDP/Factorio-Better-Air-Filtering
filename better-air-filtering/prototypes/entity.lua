data:extend({
    {
        type = "assembling-machine",
        name = "air-filter-machine",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine" },
        fast_replaceable_group = "air-filter-machine",
        max_health = 150,
        corpse = "medium-remnants",
        alert_icon_shift = util.by_pixel(-3, -12),
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation =
        {
            filename = "__better-air-filtering__/graphics/entity/air-filter-machine.png",
            priority = "high",
            width = 99,
            height = 102,
            frame_count = 32,
            line_length = 8,
            shift = { 0.4, -0.06 }
        },
        match_animation_speed_to_activity = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound =
        {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes =
        {
            {
                production_type = "input",
                filter = "pollution",
                base_area = 10,
                base_level = -1,
                pipe_connections = {},
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-basic" },
        crafting_speed = 0.5,
        energy_source =
        {
            type = "burner",
            fuel_category = "pollution-filter",
            usage_priority = "secondary-input",
            fuel_inventory_size = 1,
            burnt_inventory_size = 1,
        },
        energy_usage = "0.5MW",
        fixed_recipe = "filter-air",
        ingredient_count = 1,
        module_slots = 0,
        allowed_effects=nill
    },
    {
        type = "assembling-machine",
        name = "air-filter-machine-mk2",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-mk2.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine" },
        fast_replaceable_group = "air-filter-machine",
        max_health = 150,
        corpse = "medium-remnants",
        alert_icon_shift = util.by_pixel(-3, -12),
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation =
        {
            filename = "__better-air-filtering__/graphics/entity/air-filter-machine-mk2.png",
            priority = "high",
            width = 99,
            height = 102,
            frame_count = 32,
            line_length = 8,
            shift = { 0.4, -0.06 }
        },
        match_animation_speed_to_activity = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound =
        {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes =
        {
            {
                production_type = "input",
                filter = "pollution",
                base_area = 10,
                base_level = -1,
                pipe_connections= {}
            },
            {
                production_type = "input",
                filter="water",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = -1,
                pipe_connections = {{ type="input", position = {0, -2} }}
            },
            {
                production_type = "output",
                filter = "polluted-water",
                pipe_picture = assembler2pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = 1,
                pipe_connections = { { type = "output", position = { 0, 2 } } },
                secondary_draw_orders = { north = -1 }
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-advanced" },
        crafting_speed = 1.0,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
        },
        energy_usage = "1MW",
        ingredient_count = 1,
        module_slots = 0,
        allowed_effects=nill
    },
    {
        type = "assembling-machine",
        name = "air-filter-machine-mk3",
        icon = "__better-air-filtering__/graphics/icons/air-filter-machine-mk3.png",
        icon_size = 32,
        flags = { "placeable-neutral", "placeable-player", "player-creation" },
        minable = { hardness = 0.2, mining_time = 0.5, result = "air-filter-machine-mk3" },
        fast_replaceable_group = "air-filter-machine",
        max_health = 150,
        corpse = "medium-remnants",
        collision_box = { { -1.2, -1.2 }, { 1.2, 1.2 } },
        selection_box = { { -1.5, -1.5 }, { 1.5, 1.5 } },
        animation =
        {
            filename = "__better-air-filtering__/graphics/entity/air-filter-machine-mk3.png",
            priority = "high",
            width = 99,
            height = 102,
            frame_count = 32,
            line_length = 8,
            shift = { 0.4, -0.06 }
        },
        match_animation_speed_to_activity = true,
        open_sound = { filename = "__base__/sound/machine-open.ogg", volume = 0.85 },
        close_sound = { filename = "__base__/sound/machine-close.ogg", volume = 0.75 },
        working_sound =
        {
            sound = { { filename = "__base__/sound/electric-furnace.ogg", volume = 0.7 } },
            idle_sound = { filename = "__base__/sound/idle1.ogg", volume = 0.6 },
            apparent_volume = 1.5,
        },
        fluid_boxes =
        {
            {
                production_type = "input",
                filter = "pollution",
                base_area = 10,
                base_level = -1,
                pipe_connections= {}
            },
            {
                production_type = "input",
                filter="water",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = -1,
                pipe_connections = {{ type="input", position = {0, -2} }}
            },
            {
                production_type = "output",
                filter = "polluted-water",
                pipe_picture = assembler3pipepictures(),
                pipe_covers = pipecoverspictures(),
                base_area = 10,
                base_level = 1,
                pipe_connections = { { type = "output", position = { 0, 2 } } },
                secondary_draw_orders = { north = -1 }
            },
            off_when_no_fluid_recipe = true
        },
        crafting_categories = { "air-filtering-advanced" },
        crafting_speed = 1.25,
        energy_source =
        {
            type = "electric",
            usage_priority = "secondary-input",
        },
        energy_usage = "1MW",
        ingredient_count = 1,
        module_slots = 0,
        allowed_effects=nill
    }
})
