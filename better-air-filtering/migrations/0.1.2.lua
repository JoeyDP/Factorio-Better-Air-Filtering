-- Unlock new recipe
for _, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    recipes["filter-air-expendable"].enabled = technologies["air-filtering-2"].researched
end


-- Doesn't work because migration script is loaded too late

--local function capAtCapacity(entity, capacity)
--    local pollutionFluid = entity.fluidbox[1]
--    local pollution = 0
--    if pollutionFluid then
--        pollution = pollutionFluid.amount
--    end
--    if pollution > capacity then
--        local toRemove = pollution - capacity
--        entity.surface.pollute(entity.position, toRemove)
--        entity.insert_fluid({ name = "pollution", amount = -toRemove })
--        game.print("Removing " .. toRemove .. " pollution")
--    end
--end
--
---- Disperse pollution (fluidbox made smaller)
--for _, surface in pairs(game.surfaces) do
--    local filters1 = surface.find_entities_filtered {
--        name = { "air-filter-machine-1" }
--    }
--    for _, filter in pairs(filters1) do
--        capAtCapacity(filter, 4)
--    end
--    local filters23 = surface.find_entities_filtered {
--        name = { "air-filter-machine-2", "air-filter-machine-3" }
--    }
--    for _, filter in pairs(filters23) do
--        capAtCapacity(filter, 40)
--    end
--end