--  #################
--  #   Constants   #
--  #################

local INTERVAL = 30


--  #################
--  #   Utilities   #
--  #################

function starts_with(str, start)
    return str:sub(1, #start) == start
end

function positionToChunk(position)
    return { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }
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
        return 4 -- 4 max pollution cleaning per second among mk1 recipes
    elseif entity.name == "air-filter-machine-2" or entity.name == "air-filter-machine-3" then
        return 6 -- 6 max pollution cleaning for mk2 and mk3 recipes (liquid)
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

function getAbsorptionRate(entity)
    return math.min(getSpaceForPollution(entity), getSuctionRate(entity))
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

function inRadius(filter, radius)
    if filter.name == "air-filter-machine-1" then
        return radius <= 0
    elseif filter.name == "air-filter-machine-2" then
        return radius <= 2
    elseif filter.name == "air-filter-machine-3" then
        return radius <= 3
    else
        return false
    end
end

--  #####################
--  #   Update script   #
--  #####################

function insertPollution(event)
--    game.print("Filtered chunks:")
--    for _, c in pairs(global.air_filtered_chunks) do
--        game.print(c.x .. ", " .. c.y)
--    end
--
--    game.print("Chunkmap:")
--    for surface, chunkListX in pairs(global.air_filtered_chunks_map) do
--        game.print("Surface " .. surface)
--        for x, chunkListY in pairs(chunkListX) do
--            game.print("x: " .. x)
--            for y, chunk in pairs(chunkListY) do
--                game.print("y: " .. y)
--            end
--        end
--    end

    game.print("insertPollution")
    for _, c in pairs(global.air_filtered_chunks) do
        absorbChunk(c)
    end
end

function absorbChunk(chunk)
    if chunk:get_pollution() == 0 then
        return
    end

    local totalAbsorption = 0.0
    for _, filter in pairs(chunk.filters) do
        local absorptionRate = getAbsorptionRate(filter) * INTERVAL / 60
        totalAbsorption = totalAbsorption + absorptionRate
    end

    if totalAbsorption == 0 then
        return
    end

    local toAbsorb = math.min(chunk:get_pollution() , totalAbsorption)
    --    game.print("To absorb: " .. toAbsorb)

    local totalInsertedAmount = 0.0
    for _, filter in pairs(chunk.filters) do
        local toInsert = ((getAbsorptionRate(filter) * INTERVAL / 60) / totalAbsorption) * toAbsorb
        if toInsert > 0 then
            local insertedAmount = filter.insert_fluid({ name = "pollution", amount = toInsert })
            totalInsertedAmount = totalInsertedAmount + insertedAmount
        end
    end
    --    game.print("Total inserted: " .. totalInsertedAmount)
    assert(math.abs(toAbsorb - totalInsertedAmount) < 0.01, "Error with inserting pollution in air filter machine. Different amounts absorbed/inserted: " .. toAbsorb .. " absorbed and " .. totalInsertedAmount .. " inserted.")
    chunk:pollute(-totalInsertedAmount)
end


function generateRadiusUpdateFunctions(radius)
    return {}
end


function generateFunctions()
    local functions = {}

--    for i = 1, 110 do
--        table.insert(functions, function(event)
--        end)
--    end
--
--    table.insert(functions, init)
    table.insert(functions, insertPollution)

    for radius = 1, 4 do
        for _, f in pairs(generateRadiusUpdateFunctions(radius)) do
            table.insert(functions, f)
        end
    end

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
        --        game.print("Step: " .. step)
        local funcs = tickMap[step]
        if funcs ~= nil then
            for _, f in pairs(funcs) do
                f(event)
            end
        end
    end

    return onTick
end


function FilteredChunk(surface, x, y)
    local self = {
        surface = surface,
        x = x,
        y = y,
        filters = {},
    }

    local function equal(self, other)
        return self.surface.name == other.surface.name and self.x == other.x and self.y == other.y
    end

    local function addToMap()
        game.print("Adding chunk to map")
        local chunkListX = global.air_filtered_chunks_map[surface.name] or {}
        local chunkListY = chunkListX[x] or {}
        assert(chunkListY[y] == nil, "Chunklist entry should not exist yet.")
        chunkListY[y] = self
        chunkListX[x] = chunkListY
        global.air_filtered_chunks_map[surface.name] = chunkListX
        table.insert(global.air_filtered_chunks, self)
    end

    local function removeFromMap()
        game.print("Removing chunk from map")
        table.remove(global.air_filtered_chunks_map[surface.name][x], y)
        for i, c in pairs(global.air_filtered_chunks) do
            if equal(self, c) then
                table.remove(global.air_filtered_chunks, i)
                break
            end
        end
    end

    local function get_pollution(self)
        return self.surface.get_pollution(self:toPosition())
    end

    local function pollute(self, amount)
        self.surface.pollute(self:toPosition(), amount)
    end

    local function toPosition(self)
        return { x = self.x * 32, y = self.y * 32 }
    end

    local function addFilter(self, filter)
        table.insert(self.filters, filter)
        if #self.filters == 1 then
            addToMap()
        end
    end

    local function removeFilter(self, filter)
        for i, f in pairs(self.filters) do
            if f.unit_number == filter.unit_number then
                table.remove(self.filters, i)
                break
            end
        end
        if #self.filters == 0 then
            removeFromMap()
        end
    end

    self.get_pollution = get_pollution
    self.pollute = pollute
    self.toPosition = toPosition
    self.addFilter = addFilter
    self.removeFilter = removeFilter
    return self
end

function getFilteredChunk(surface, x, y)
    local chunkListX = global.air_filtered_chunks_map[surface.name]
    if chunkListX ~= nil then
        local chunkListY = chunkListX[x]
        if chunkListY ~= nil then
            local chunk = chunkListY[y]
            if chunk ~= nil then
                return chunk
            end
        end
    end
    return FilteredChunk(surface, x, y)
end


--function groupByChunk(entities)
--    local chunks = {}
--    for _, e in pairs(entities) do
--        local chunk = positionToChunk(e.position)
--        local chunkListX = chunks[chunk.x] or {}
--        local chunkList = chunkListX[chunk.y] or {}
--        table.insert(chunkList, e)
--        chunkListX[chunk.y] = chunkList
--        chunks[chunk.x] = chunkListX
--    end
--    local pretty_chunks = {}
--    for chunkX, t in pairs(chunks) do
--        for chunkY, l in pairs(t) do
--            print(t)
--            table.insert(pretty_chunks, { chunk = { x = chunkX, y = chunkY }, entities = l })
--        end
--    end
--    return pretty_chunks
--end



--  #################
--  #   callbacks   #
--  #################

function isAirFilterMachine(entity)
    return starts_with(entity.name, "air-filter-machine-")
end

function OnEntityCreated(event)
    game.print("entity created")
    game.print(event.created_entity.name)
    if isAirFilterMachine(event.created_entity) then
        game.print("air filter created")
        local chunkPos = positionToChunk(event.created_entity.position)
        local chunk = getFilteredChunk(event.created_entity.surface, chunkPos.x, chunkPos.y)
        chunk:addFilter(event.created_entity)
        game.print("Air filter added to chunk")
    end
end

function OnEntityRemoved(event)
    if isAirFilterMachine(event.entity) then
        local chunkPos = positionToChunk(event.entity.position)
        local chunk = getFilteredChunk(event.entity.surface, chunkPos.x, chunkPos.y)
        chunk:removeFilter(event.entity)
    end
end

script.on_event({ defines.events.on_built_entity, defines.events.on_robot_built_entity }, OnEntityCreated)
script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_robot_pre_mined, defines.events.on_entity_died }, OnEntityRemoved)


function init()
    game.print("Init")
    -- gather all filters on every surface
    global.air_filtered_chunks_map = {}
    global.air_filtered_chunks = {}
    for _, surface in pairs(game.surfaces) do
        local filters = surface.find_entities_filtered {
            name = { "air-filter-machine-1", "air-filter-machine-2", "air-filter-machine-3" }
        }
        for _, filter in pairs(filters) do
            game.print(#filters)
            local chunkPos = positionToChunk(filter.position)
            local chunk = getFilteredChunk(surface, chunkPos.x, chunkPos.y)
            game.print("Chunk: " .. chunk.x .. ", " .. chunk.y)
            chunk:addFilter(filter)
        end
    end
end

script.on_init(init)
script.on_configuration_changed(init)

script.on_load(function()
    local functions = generateFunctions()
    local onTick = spreadOverTicks(functions, INTERVAL)

    script.on_event(defines.events.on_tick, onTick)
end)


