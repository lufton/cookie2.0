require("lua/Helpers")

function clearObjects()
    objects = getObjects()
    
    for _, object in pairs(objects) do
        if object.tag != "Hand" then
            object.destruct()
        end
    end

    print("Objects were cleared")
end

function clearSnapPoins()
    Global.setSnapPoints({})

    print("Snap points were cleared")
end

function clearEverything()
    clearObjects()
    clearSnapPoins()
    print("Everything was cleared")
end

function setupCharactersDeck()
    return spawnDeck("characters")
end

function setupPlayerDeck(color)
    return spawnDeck(color)
end

function setupSeatedPlayersDecks()
    local seatedPlayers = getSeatedPlayers()
    
    for _, color in pairs(COLORS) do
        if table.contains(seatedPlayers, capitalize(color)) then setupPlayerDeck(color) end
    end
end

function setupEverything()
    setupCharactersDeck()
    setupSeatedPlayersDecks()
end
