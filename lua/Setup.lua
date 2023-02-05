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
    local deck = spawnDeck("characters")

    return deck
end

function setupPlayerDeck(color)
    local deck = spawnDeck(color)

    return deck
end

function setupEverything()
    --setupCharactersDeck()
    setupPlayerDeck("orange")
    setupPlayerDeck("yellow")
    setupPlayerDeck("green")
    setupPlayerDeck("teal")
    -- setupPlayerDeck("blue")
    -- setupPlayerDeck("purple")
end
