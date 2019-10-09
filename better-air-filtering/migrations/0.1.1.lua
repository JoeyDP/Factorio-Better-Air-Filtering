for surfaceName, chunkListX in pairs(global.air_filtered_chunks_map) do
    for x, chunkListY in pairs(chunkListX) do
        for y, chunk in pairs(chunkListY) do
            if chunk.filters == nil or #chunk.filters == 0 then
                global.air_filtered_chunks_map[surfaceName][x][y] = nil
            end
        end
    end
end
