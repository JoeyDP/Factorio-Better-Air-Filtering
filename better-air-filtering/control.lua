--  #################
--  #   Constants   #
--  #################

local INTERVAL = 20



--  #####################
--  #   Local handles   #
--  #####################

local air_filtered_chunks = {}


--  #################
--  #   Utilities   #
--  #################

function starts_with(str, start)
    return str:sub(1, #start) == start
end

function sign(x)
    if x == 0 then
        return 1
    else
        return x / math.abs(x)
    end
end

function manhattan(x, y)
    -- Manhattan distance from origin to xy.
    return math.abs(x) + math.abs(y)
end

function positionToChunk(position)
    return { x = math.floor(position.x / 32), y = math.floor(position.y / 32) }
end

function getBasePurificationRate(entity)
    -- Depends mostly on recipe (optimal recipe used per machine). Should be multiplied by crafting speed to achieve actual max purification rate
    if entity.name == "air-filter-machine-1" then
        return 2 * INTERVAL / 60    -- max pollution cleaning per second among mk1 recipes
    elseif entity.name == "air-filter-machine-2" or entity.name == "air-filter-machine-3" then
        return 4 * INTERVAL / 60    -- max pollution cleaning for mk2 and mk3 recipes TODO: change if fluid filtering is implemented
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

function pollutionInPollutedWater(amount)
    return amount * 6 / 10
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

--function updateInserters(event)
    --for _, surface in pairs(game.surfaces) do
    --    local inserters = surface.find_entities_filtered({type="inserter"})
    --    for _, inserter in pairs(inserters) do
    --        updateInserter(inserter)
    --    end
    --end
--end

--function updateInserter(inserter)
    --game.print(serpent.line(inserter.position))
    --local drop_target = inserter.drop_target
    --if drop_target == nil then return end
    --local pickup_target = inserter.pickup_target
    --if pickup_target == nil then return end
    --local burnt_result_inventory = pickup_target.get_burnt_result_inventory()
    --if burnt_result_inventory == nil then return end
    --if burnt_result_inventory.is_empty() then return end
    --if inserter.get_item_count() > 0 then return end
    --
    --
    --local contents = burnt_result_inventory.get_contents()
    --
    --
    --for item_name, count in pairs (contents) do
    --    fuel_item_name = item_name
    --end
    --
    --if inserter.get_item_count() < 1 then
    --    if inserter.held_stack.valid_for_read == false then
    --        if pickup_target.get_item_count(fuel_item_name) > 0 then
    --            inserter.held_stack.set_stack({name = fuel_item_name, count = 1})
    --            pickup_target.remove_item({name = fuel_item_name, count = 1})
    --            return
    --        end
    --    end
    --end
--end


function absorbPollution(event)
    --    game.print("insertPollution")
    for _, c in pairs(air_filtered_chunks) do
        absorbChunk(c)
    end
end

function absorbChunk(chunk)
    if chunk:get_pollution() == 0 then
        return
    end

    local totalAbsorptionRate = chunk:getTotalAbsorptionRate()

    --game.print("totalAbsorptionRate: " .. totalAbsorptionRate)
    --game.print("filter count: " .. #chunk.filters)

    if totalAbsorptionRate == 0 then
        return
    end

    local toAbsorb = math.min(chunk:get_pollution(), totalAbsorptionRate)
    --    game.print("To absorb: " .. toAbsorb)

    local totalInsertedAmount = 0.0
    for _, filter in pairs(chunk:getFilters()) do
        local toInsert = (getAbsorptionRate(filter) / totalAbsorptionRate) * toAbsorb
        if toInsert > 0 then
            local insertedAmount = filter.insert_fluid({ name = "pollution", amount = toInsert })
            game.pollution_statistics.on_flow(filter.name, -insertedAmount)
            totalInsertedAmount = totalInsertedAmount + insertedAmount
        end
    end
    chunk:pollute(-totalInsertedAmount)
    --    game.print("Total inserted: " .. totalInsertedAmount)
    if math.abs(toAbsorb - totalInsertedAmount) > 0.01 then
        game.print("Error with inserting pollution in air filter machine. Different amounts absorbed/inserted: " .. toAbsorb .. " absorbed and " .. totalInsertedAmount .. " inserted.")
    end
end

function stepsToOrigin(x, y)
    -- Provide coordinates of possible 1-steps toward (0, 0)
    local steps = {}
    if x ~= 0 then
        table.insert(steps, { x = x - sign(x), y = y })
    end
    if y ~= 0 then
        table.insert(steps, { x = x, y = y - sign(y) })
    end
    return steps
end

function suctionUpdateChunk(chunkTo, dx, dy)
    local totalSuction = chunkTo:getTotalSuctionRate(manhattan(dx, dy))

    if totalSuction == 0 then
        return
    end

    --    game.print("From " .. dx .. ", " .. dy)
    --    game.print("suction: " .. totalSuction)

    local chunkFrom = getFilteredChunk(chunkTo.surface, chunkTo.x + dx, chunkTo.y + dy)
    local test = chunkFrom:getTotalSuctionRate(0)
    local pollution = chunkFrom:get_pollution()
    if pollution > 0 then
        local toPollute = math.min(pollution, totalSuction)
        local chunksVia = {}
        for _, step in pairs(stepsToOrigin(dx, dy)) do
            local chunk = getFilteredChunk(chunkTo.surface, chunkTo.x + step.x, chunkTo.y + step.y)
            table.insert(chunksVia, chunk)
        end

        --        game.print("Moving " .. toPollute .. " pollution")
        --        game.print("From: " .. chunkFrom.x .. ", " .. chunkFrom.y)
        for _, chunkVia in pairs(chunksVia) do
            --            game.print("To: " .. chunkVia.x .. ", " .. chunkVia.y)
            chunkVia:pollute(toPollute / #chunksVia)
        end
        chunkFrom:pollute(-toPollute)
    end
end

function generateSuctionFunction(dx, dy)

    local function suctionUpdate(event)
        --        game.print("suck pollution " .. dx .. ", " .. dy)
        for _, chunkTo in pairs(air_filtered_chunks) do
            suctionUpdateChunk(chunkTo, dx, dy)
        end
    end

    return suctionUpdate
end

function generateRadiusCoordinates(radius)
    local coords = {}
    for signR = -1, 1, 2 do
        for signX = -1, 1, 2 do
            for dx = -radius, radius do
                if not (sign(signX) * sign(dx) == signR) then
                    if not (math.abs(dx) == radius and signR == 1) then
                        local dy = (signR * radius) + (signX * dx)
                        table.insert(coords, { dx = dx, dy = dy })
                    end
                end
            end
        end
    end
    return coords
end

function generateRadiusSuctionFunctions(radius)
    local functions = {}

    for _, offset in pairs(generateRadiusCoordinates(radius)) do
        local f = generateSuctionFunction(offset.dx, offset.dy)
        table.insert(functions, f)
    end

    return functions
end

function generateFunctions()
    local functions = {}

    table.insert(functions, absorbPollution)

    for radius = 1, 4 do
        for _, f in pairs(generateRadiusSuctionFunctions(radius)) do
            table.insert(functions, f)
        end
    end

    --table.insert(functions, updateInserters)

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
        local funcs = tickMap[step]
        if funcs ~= nil then
            for _, f in pairs(funcs) do
                f(event)
            end
        end
        --        if step == 1 then
        --            game.print("================================")
        --        end
    end

    return onTick
end


--  #####################
--  #   FilteredChunk   #
--  #####################


local FilteredChunk = {
    surface = nil,
    x = 0,
    y = 0,
    --filters = {}
}

function FilteredChunk:new (o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.filters = o.filters or {}
    return o
end

function createFilteredChunk(surface, x, y)
    local chunk = FilteredChunk:new(nil)
    chunk.surface = surface
    chunk.x = x
    chunk.y = y
    return chunk
end

function FilteredChunk:equal(other)
    return self.surface.name == other.surface.name and self.x == other.x and self.y == other.y
end

function FilteredChunk:getFilters()
    local filters = {}
    for _, filter in pairs(self.filters) do
        if filter.valid then
            table.insert(filters, filter)
        end
    end
    self.filters = filters
    return filters
end

function FilteredChunk:addToMap()

    --game.print("Active chunks before: ")
    --for i, c in pairs(air_filtered_chunks) do
    --    game.print(serpent.line(c))
    --end
    --game.print(serpent.block(global.air_filtered_chunks_map))

    --game.print("Adding chunk to map")
    local chunkListX = global.air_filtered_chunks_map[self.surface.name] or {}
    local chunkListY = chunkListX[self.x] or {}
    assert(chunkListY[y] == nil, "Chunklist entry should not exist yet.")
    chunkListY[self.y] = self
    chunkListX[self.x] = chunkListY
    global.air_filtered_chunks_map[self.surface.name] = chunkListX
    table.insert(air_filtered_chunks, self)


    --game.print("Active chunks after: ")
    --for i, c in pairs(air_filtered_chunks) do
    --    game.print(serpent.line(c))
    --end
    --game.print(serpent.block(global.air_filtered_chunks_map))
end

function FilteredChunk:removeFromMap()
    --game.print("Removing chunk from map")
    global.air_filtered_chunks_map[self.surface.name][self.x][self.y] = nil

    for i, c in pairs(air_filtered_chunks) do
        if self:equal(c) then
            --game.print("Removing chunk from list")
            table.remove(air_filtered_chunks, i)
            break
        end
    end

    --local i = 1
    --while i <= #air_filtered_chunks do
    --    local c = air_filtered_chunks[i]
    --    if self:equal(c) then
    --        --game.print("Removing chunk from list")
    --        table.remove(air_filtered_chunks, i)
    --    else
    --        i = i + 1
    --    end
    --end

    --game.print("Remaining chunks: ")
    --for _, c in pairs(air_filtered_chunks) do
    --    game.print(serpent.line(c))
    --end
end

function FilteredChunk:getTotalAbsorptionRate()
    local totalAbsorptionRate = 0.0
    for _, filter in pairs(self:getFilters()) do
        local absorptionRate = getAbsorptionRate(filter)
        totalAbsorptionRate = totalAbsorptionRate + absorptionRate
    end
    return totalAbsorptionRate
end

function FilteredChunk:getTotalSuctionRate(distance)
    local totalSuctionRate = 0.0
    for _, filter in pairs(self:getFilters()) do
        if inRadius(filter, distance) then
            local suctionRate = getSuctionRate(filter)
            totalSuctionRate = totalSuctionRate + suctionRate
        end
    end
    return totalSuctionRate * (1 / 4) ^ distance
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

function onEntityCreated(event)
    if isAirFilterMachine(event.created_entity) then
        local chunkPos = positionToChunk(event.created_entity.position)
        local chunk = getFilteredChunk(event.created_entity.surface, chunkPos.x, chunkPos.y)
        chunk:addFilter(event.created_entity)
    end
end

function onEntityRemoved(event)
    -- Update map of air filters
    if isAirFilterMachine(event.entity) then
        local chunkPos = positionToChunk(event.entity.position)
        local chunk = getFilteredChunk(event.entity.surface, chunkPos.x, chunkPos.y)
        chunk:removeFilter(event.entity)
    end

    -- Disperse pollution back
    local pollution = 0

    -- from pollution (fluid)
    pollution = pollution + event.entity.get_fluid_count("pollution")

    -- from polluted water (fluid)
    local pollutedWater = event.entity.get_fluid_count("polluted-water")
    pollution = pollution + pollutionInPollutedWater(pollutedWater)

    -- from current crafting op
    --local crafting = "No"
    --if event.entity.is_crafting() then crafting = "Yes" end
    --game.print("crafting? " .. crafting)
    --local recipe = event.entity.get_recipe()
    --if recipe ~= nil and event.entity.is_crafting() then
    --    for _, ingredient in pairs(recipe.ingredients) do
    --        game.print("Ingredient: " .. ingredient.name)
    --        if ingredient.name == "pollution" then
    --            pollution = pollution + ingredient.amount
    --        elseif ingredient.name == "polluted-water" then
    --            pollution = pollution + pollutionInPollutedWater(ingredient.amount)
    --        end
    --    end
    --end

    if pollution > 0 then
        --game.print("Dispersing " .. pollution .. " pollution back")
        event.entity.surface.pollute(event.entity.position, pollution)
        game.pollution_statistics.on_flow(event.entity.name, pollution)
    end
end

function preEntityRemoved(event)
    local isCrafting = event.entity.type == "assembling-machine" and event.entity.is_crafting()

    -- disperse pollution in recipe back
    if isCrafting then
        local pollution = 0
        local recipe = event.entity.get_recipe()

        if recipe ~= nil then
            for _, ingredient in pairs(recipe.ingredients) do
                if ingredient.name == "pollution" then
                    pollution = pollution + ingredient.amount
                elseif ingredient.name == "polluted-water" then
                    pollution = pollution + pollutionInPollutedWater(ingredient.amount)
                end
            end
        end

        if pollution > 0 then
            --game.print("Dispersing " .. pollution .. " pollution back")
            event.entity.surface.pollute(event.entity.position, pollution)
            game.pollution_statistics.on_flow(event.entity.name, pollution)
        end
    end

    -- On entity died has no pre version -> call onEntityRemoved manually
    if event.name == defines.events.on_entity_died then
        onEntityRemoved(event)
    end
end

function refreshMetatables()
    for _, chunkListX in pairs(global.air_filtered_chunks_map) do
        for x, chunkListY in pairs(chunkListX) do
            for y, chunk in pairs(chunkListY) do
                chunk = FilteredChunk:new(chunk)    -- resets metatable
                table.insert(air_filtered_chunks, chunk)
            end
        end
    end
end

function init()
    -- gather all filters on every surface
    global.air_filtered_chunks_map = {}
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

function load()
    refreshMetatables()
end


-- Set up callbacks

script.on_event({ defines.events.on_built_entity, defines.events.on_robot_built_entity }, onEntityCreated)

-- on_entity_died should trigger both functions -> called manually
script.on_event({ defines.events.on_player_mined_entity, defines.events.on_robot_mined_entity, defines.events.on_entity_died }, onEntityRemoved)
script.on_event({ defines.events.on_pre_player_mined_item, defines.events.on_pre_robot_mined_item, defines.events.on_entity_died }, preEntityRemoved)

local functions = generateFunctions()
local onTick = spreadOverTicks(functions, INTERVAL)
script.on_event(defines.events.on_tick, onTick)

script.on_load(load)
script.on_init(init)
script.on_configuration_changed(init)




