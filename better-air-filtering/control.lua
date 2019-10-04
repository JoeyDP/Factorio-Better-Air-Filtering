function onTick(event)
    for radius = 0, 4 do
        if event.tick % 30 == radius then
            for _, surface in pairs(game.surfaces) do
                local filters = surface.find_entities_filtered {
                    name = {"air-filter-machine-1", "air-filter-machine-2", "air-filter-machine-3"}
                }
                updateAirFilters(surface, filters, radius)
            end
        end
    end
end

function updateAirFilters(surface, filters, radius)
    -- Carefull not to suck in more pollution than can process
    -- This would make air filters OP because they would capture cloud without the need to filter
    for _, filter in pairs(filters) do
        local chunk_pollution = surface.get_pollution(filter.position)
        if chunk_pollution > 0 then
            local to_insert = math.min(chunk_pollution, 4)
            local inserted_amount = filter.insert_fluid({name="pollution", amount=to_insert})
            surface.pollute(filter.position, -inserted_amount)
        end
    end
end

function iteratePerChunk(filters)
    -- TODO implement
end

function movePollution(chunkFrom, chunkTo, amount)
    -- TODO should make machine consume power to move?
end

function getPurificationRate(entity)
    -- TODO implement
    -- 0 if not able to run
    -- based on crafting speed and amount of power (if possible)
    -- based on recipe? Maybe not -> machine not stronger/weaker
end

--    TODO
-- Make multiple filters in same chunk absorb balanced amount of pollution (not iterative)
-- Make more efficient
--

script.on_event(defines.events.on_tick, onTick)

