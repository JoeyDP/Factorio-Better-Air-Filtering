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

local function sign(x)
    return x / math.abs(x)
end

local function positionToChunk(position)
    return { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }
end

function movePollution(surface, chunkFrom, chunkTo, amount)
    amount = math.min(amount, surface.get_pollution(chunkToPosition(chunkFrom)))
    surface.pollute(chunkToPosition(chunkFrom), -amount)
    surface.pollute(chunkToPosition(chunkTo), amount)
    return amount
end

function getBasePurificationRate(entity)
    -- Depends mostly on recipe (optimal recipe used per machine). Should be multiplied by crafting speed to achieve actual max purification rate
    if entity.name == "air-filter-machine-1" then
        return 2 * INTERVAL / 60    -- max pollution cleaning per second among mk1 recipes
    elseif entity.name == "air-filter-machine-2" or entity.name == "air-filter-machine-3" then
        return 6 * INTERVAL / 60    -- max pollution cleaning for mk2 and mk3 recipes (liquid)
    else
        return 0
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

local function inRadius(filter, radius)
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

local function manhattan(x, y)
    -- Manhattan distance from origin to xy.
    return math.abs(x) + math.abs(y)
end

--  #####################
--  #   Update script   #
--  #####################

function absorbPollution(event)
--    game.print("insertPollution")
    for _, c in pairs(global.air_filtered_chunks) do
        absorbChunk(c)
    end
end

function absorbChunk(chunk)
    if chunk:get_pollution() == 0 then
        return
    end

    local totalAbsorptionRate = chunk:getTotalAbsorptionRate()

--    game.print("totalAbsorptionRate: " .. totalAbsorptionRate)
--    game.print("filter count: " .. #chunk.filters)

    if totalAbsorptionRate == 0 then
        return
    end

    local toAbsorb = math.min(chunk:get_pollution() , totalAbsorptionRate)
--    game.print("To absorb: " .. toAbsorb)

    local totalInsertedAmount = 0.0
    for _, filter in pairs(chunk.filters) do
        local toInsert = (getAbsorptionRate(filter) / totalAbsorptionRate) * toAbsorb
        if toInsert > 0 then
            local insertedAmount = filter.insert_fluid({ name = "pollution", amount = toInsert })
            totalInsertedAmount = totalInsertedAmount + insertedAmount
        end
    end
--    game.print("Total inserted: " .. totalInsertedAmount)
    assert(math.abs(toAbsorb - totalInsertedAmount) < 0.01, "Error with inserting pollution in air filter machine. Different amounts absorbed/inserted: " .. toAbsorb .. " absorbed and " .. totalInsertedAmount .. " inserted.")
    chunk:pollute(-totalInsertedAmount)
end

local function suctionUpdateChunk(chunkTo, dx, dy)
--    local totalSuction = chunkTo:getTotalSuctionRate(manhattan(dx, dy))

--    if totalSuction == 0 then
--        return
--    end

--    game.print("suction: " .. totalSuction)


--    local chunkFrom = getFilteredChunk(chunkTo.surface, chunkTo.x + dx, chunkTo.y + dy)

end

local function generateSuctionFunction(dx, dy)

    local function suctionUpdate(event)
--        game.print("suck pollution " .. dx .. ", " .. dy)
        for _, chunkTo in pairs(global.air_filtered_chunks) do
            suctionUpdateChunk(chunkTo, dx, dy)
        end
    end

    return suctionUpdate
end


local function generateRadiusCoordinates(radius)
    local coords = {}
    for signR = -1, 1, 2 do
        for signX = -1, 1, 2 do
            for dx = -radius, radius do
                if not (sign(signX * dx) == signR) then
                    if not (dx == 0 and signR == -1) and not (math.abs(dx) == 3 and signR == -1) then
                        local dy = (signR * radius) + (signX * dx)
                        table.insert(coords, {dx=dx, dy=dy})
                    end
                end
            end
        end
    end
    return coords
end

local function generateRadiusSuctionFunctions(radius)
    local functions = {}

    for _, offset in pairs(generateRadiusCoordinates(radius)) do
        local f = generateSuctionFunction(offset.dx, offset.dy)
        table.insert(functions, f)
    end

    return functions
end


local function generateFunctions()
    local functions = {}

    -- Debug statement
--    table.insert(functions, init)

    table.insert(functions, absorbPollution)

    for radius = 1, 4 do
        for _, f in pairs(generateRadiusSuctionFunctions(radius)) do
            table.insert(functions, f)
        end
    end

    return functions
end



local function spreadOverTicks(functions, interval)
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


--  #####################
--  #   FilteredChunk   #
--  #####################

--local function FilteredChunk(surface, x, y)
--    local self = {
--        surface = surface,
--        x = x,
--        y = y,
--        filters = {},
--    }
--
----    self.getTotalSuctionRate = getTotalSuctionRate
----    self.getTotalAbsorptionRate = getTotalAbsorptionRate
----    self.get_pollution = get_pollution
----    self.pollute = pollute
----    self.toPosition = toPosition
----    self.addFilter = addFilter
----    self.removeFilter = removeFilter
--    return self
--end

local FilteredChunk = {
    surface = nil,
    x = 0,
    y = 0,
    filters = {},
}

function FilteredChunk:equal(other)
    return self.surface.name == other.surface.name and self.x == other.x and self.y == other.y
end

function FilteredChunk:addToMap()
    game.print("Adding chunk to map")
    local chunkListX = global.air_filtered_chunks_map[self.surface.name] or {}
    local chunkListY = chunkListX[self.x] or {}
    assert(chunkListY[y] == nil, "Chunklist entry should not exist yet.")
    chunkListY[self.y] = self
    chunkListX[self.x] = chunkListY
    global.air_filtered_chunks_map[self.surface.name] = chunkListX
    table.insert(global.air_filtered_chunks, self)
end

function FilteredChunk:removeFromMap()
    game.print("Removing chunk from map")
    table.remove(global.air_filtered_chunks_map[self.surface.name][self.x], self.y)
    for i, c in pairs(global.air_filtered_chunks) do
        if self:equal(c) then
            table.remove(global.air_filtered_chunks, i)
            game.print("Removing chunk from list")
            break
        end
    end
end

function FilteredChunk:getTotalAbsorptionRate()
    local totalAbsorptionRate = 0.0
    for _, filter in pairs(self.filters) do
        local absorptionRate = getAbsorptionRate(filter)
        totalAbsorptionRate = totalAbsorptionRate + absorptionRate
    end
    return totalAbsorptionRate
end

function FilteredChunk:getTotalSuctionRate(distance)
    local totalSuctionRate = 0.0
    for _, filter in pairs(self.filters) do
        if inRadius(filter, distance) then
            local suctionRate = getSuctionRate(filter)
            totalSuctionRate = totalSuctionRate + suctionRate
        end
    end
    return totalSuctionRate
end

function FilteredChunk:get_pollution()
    return self.surface.get_pollution(self:toPosition())
end

function FilteredChunk:pollute(amount)
    self.surface.pollute(self:toPosition(), amount)
end

function FilteredChunk:toPosition()
    return { x = self.x * 32, y = self.y * 32 }
end

function FilteredChunk:addFilter(filter)
    table.insert(self.filters, filter)
    if #self.filters == 1 then
        self:addToMap()
    end
end

function FilteredChunk:removeFilter(filter)
    for i, f in pairs(self.filters) do
        if f.unit_number == filter.unit_number then
            table.remove(self.filters, i)
            break
        end
    end
    if #self.filters == 0 then
        self:removeFromMap()
    end
end

function FilteredChunk:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function createFilteredChunk(surface, x, y)
    local chunk = FilteredChunk:new(nil)
    chunk.surface = surface
    chunk.x = x
    chunk.y = y
    chunk.filters = {}      -- this statement, though it appears to have no effect, has a large impact on the saving of global state.
    return chunk
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
    return createFilteredChunk(surface, x, y)
end



--  #################
--  #   callbacks   #
--  #################

function isAirFilterMachine(entity)
    return starts_with(entity.name, "air-filter-machine-")
end

function OnEntityCreated(event)
    if isAirFilterMachine(event.created_entity) then
        local chunkPos = positionToChunk(event.created_entity.position)
        local chunk = getFilteredChunk(event.created_entity.surface, chunkPos.x, chunkPos.y)
        chunk:addFilter(event.created_entity)
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


function refreshMetatables()
    for i, chunk in pairs(global.air_filtered_chunks) do
        FilteredChunk:new(chunk)    -- reset metatable
    end
end

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
            local chunkPos = positionToChunk(filter.position)
            local chunk = getFilteredChunk(surface, chunkPos.x, chunkPos.y)
            chunk:addFilter(filter)
        end
    end
end

script.on_init(init)
script.on_configuration_changed(init)

script.on_load(function()
    refreshMetatables()

    local functions = generateFunctions()
    local onTick = spreadOverTicks(functions, INTERVAL)

    script.on_event(defines.events.on_tick, onTick)
end)


