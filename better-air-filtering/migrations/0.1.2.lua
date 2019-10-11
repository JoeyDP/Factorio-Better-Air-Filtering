for index, force in pairs(game.forces) do
    local technologies = force.technologies
    local recipes = force.recipes

    recipes["filter-air-expendable"].enabled = technologies["air-filtering-2"].researched
end