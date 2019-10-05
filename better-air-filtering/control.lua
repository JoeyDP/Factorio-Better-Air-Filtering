function onTick(event)
    local maxRadius = 4
    local radius = event.tick % 30
    if radius <= maxRadius then
        for _, surface in pairs(game.surfaces) do
            local filters = surface.find_entities_filtered {
                name = {"air-filter-machine-1", "air-filter-machine-2", "air-filter-machine-3"}
            }
            updateAirFilters(surface, filters, radius)
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

function groupByChunk(entities)
    local chunks = {}
    for _, e in pairs(entities) do
        local chunk = positionToChunk(e.position)
        local chunkListX = chunks[chunk.x] or {}
        local chunkList = chunkListX[chunk.y] or {}
        table.insert(chunkList, e)
        chunkListX[chunk.y] = chunkList
        chunks[chunk.x] = chunkListX
    end
    local pretty_chunks = {}
    for chunkX, t in pairs(chunks) do
        for chunkY, l in pairs(t) do
            print(t)
            table.insert(pretty_chunks, {chunk={x = chunkX, y = chunkY}, entities=l})
        end
    end
    return pretty_chunks
end

function positionToChunk(position)
    return {x=math.floor(position.x / 32), y=math.floor(position.y / 32)}
end

function chunkToPosition(chunk)
    return {x=chunk.x *32, y=chunk.y*32}
end

function movePollution(chunkFrom, chunkTo, amount)

end

function getPurificationRate(entity)
    -- TODO implement
    -- 0 if not able to run
    -- based on crafting speed and amount of power (if possible)
end

function getSucktionRate(entity)
    return 1/4 * getPurificationRate(entity)
end

--    TODO
-- Make more efficient
-- flow rate of machines

script.on_event(defines.events.on_tick, onTick)

