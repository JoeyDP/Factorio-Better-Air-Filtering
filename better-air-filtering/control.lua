

function updateAirFilters(surface, filters)
    for _, filter in pairs(filters) do
        local chunk_pollution = surface.get_pollution(filter.position)
        if chunk_pollution > 0 then
            local suctionRate = getSuctionRate(filter)
            game.print(suctionRate)
            if suctionRate > 0 then
                local to_insert = math.min(chunk_pollution, suctionRate)
                local inserted_amount = filter.insert_fluid({name="pollution", amount=to_insert})
                surface.pollute(filter.position, -inserted_amount)
                game.print("Inserted: " .. inserted_amount)
            end
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

function movePollution(surface, chunkFrom, chunkTo, amount)
    amount = math.min(amount, surface.get_pollution(chunkToPosition(chunkFrom)))
    surface.pollute(chunkToPosition(chunkFrom), -amount)
    surface.pollute(chunkToPosition(chunkTo), amount)
    return amount
end

function getBasePurificationRate(entity)
    -- Depends mostly on recipe. Should be multiplied by crafting speed to achieve actual max purification rate
    if entity.name == "air-filter-machine-1" then
        return 4       -- 4 max pollution cleaning per second among mk1 recipes
    elseif entity.name == "air-filter-machine-2" or entity.name == "air-filter-machine-3" then
        return 6       -- 6 max pollution cleaning for mk2 and mk3 recipes (liquid)
    else
        return 0
    end
end

function getSuctionRate(entity)
    if not entity.is_crafting() and getSpaceForPollution(entity) == 0 then
        return 0
    else
        return getBasePurificationRate(entity) * entity.crafting_speed * energyCraftingModifier(entity)
    end
end

function energyCraftingModifier(entity)
    -- Approximation to speed modifier for machine running out of power
    if entity.electric_buffer_size then
        return entity.energy / entity.electric_buffer_size
    else
        return 1
    end
end

function getSpaceForPollution(entity)
    if #entity.fluidbox < 1 then
        return 0
    end
    local capacity = entity.fluidbox.get_capacity(1)
    local pollutionFluid = entity.fluidbox[1]
    local pollution = 0
    if pollutionFluid then
        pollution = pollutionFluid.amount
    end
    return capacity - pollution
end

function generateFunctions()
    local functions = {}

    local function test(event)
        for _, surface in pairs(game.surfaces) do
            local filters = surface.find_entities_filtered {
                name = {"air-filter-machine-1", "air-filter-machine-2", "air-filter-machine-3"}
            }
            updateAirFilters(surface, filters, 0)
        end
    end
    table.insert(functions, test)


    return functions
end


function spreadOverTicks(functions, interval)
    local tickMap = {}
    local funcs = {}
    for index, f in pairs(functions) do
        -- amount of functions to be inserted in this tick update to fit them all in the remaining interval
        local functionsPerTick = math.ceil((#functions - index) / (interval - #tickMap - 1))
        table.insert(funcs, f)
        if #funcs >= functionsPerTick then
            table.insert(tickMap, funcs)
            funcs = {}
        end
    end
    if #funcs > 0 then
        table.insert(tickMap, funcs)
        funcs = {}
    end

    local function onTick(event)
        local step = (event.tick % interval) + 1
        game.print("Step: " .. step)
        local funcs = tickMap[step]
        if funcs ~= nil then
            for _, f in pairs(funcs) do
                f(event)
            end
        end
    end

    return onTick
end


script.on_load(function()
    local functions = generateFunctions()
    local onTick = spreadOverTicks(functions, 30)

    script.on_event(defines.events.on_tick, onTick)
end)


