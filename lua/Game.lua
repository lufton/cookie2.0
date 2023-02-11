require("lua/Setup")

function onSave()
    return JSON.encode(saveData())
end

function onLoad(json)
    Turns.enable = true
    
    if json then
        local data = JSON.decode(json)
        GAME_STARTED = data.GAME_STARTED
        GAME_MODE = data.GAME_MODE
        ROLES = data.ROLES
        Turns.turn_color = data.PREVIOUS_PLAYER
        DECKS = { }
        table.foreach(data.DECKS or { }, function(guid, color)
            DECKS[color] = getObjectFromGUID(guid)
        end)
        CLUE_ZONES = { }
        table.foreach(data.CLUE_ZONES or { }, function(guid, color)
            CLUE_ZONES[color] = getObjectFromGUID(guid)
        end)
        CHARACTER_ZONES = { }
        table.foreach(data.CHARACTER_ZONES or { }, function(guid, color)
            CHARACTER_ZONES[color] = getObjectFromGUID(guid)
        end)
        CLUES_ZONES = { }
        table.foreach(data.CLUES_ZONES or { }, function(guids, color)
            CLUES_ZONES[color] = { }
            table.foreach(guids, function(guid, i)
                CLUES_ZONES[color][i] = getObjectFromGUID(guid)
            end)
        end)
        WEAPONS_ZONES = { }
        table.foreach(data.WEAPONS_ZONES or { }, function(guids, color)
            WEAPONS_ZONES[color] = { }
            table.foreach(guids, function(guid, i)
                WEAPONS_ZONES[color][i] = getObjectFromGUID(guid)
                WEAPONS_ZONES[color][i].setVar("color", color)
            end)
        end)

        if GAME_STARTED then
            attachIsEveryoneHasPlayedCardWaiter()
            attachAreCardsRevealedWaiter()
            attachIsRoundFinishedWaiter()
        end
    else
        clearEverything()
        setupEverything()
    end
end

function onChat(message, player)
    local obj = getObjectFromGUID(message)

    if obj then
        dump(obj.getData())
        return
    end

    if message == "r" then
        clearEverything()
        setupEverything()
    elseif message == "s" then
        startGame()
    elseif message == "c" then
        print(isColorPlayedCard(player.color))
    elseif message == "f" then
        isRoundFinished()
    elseif message == "p" then
        print(isEveryonePlayedCard())
    end
end

function onObjectLeaveZone(zone, object)
    if zone.tag == "Hand" and object.tag == "Card" then
        local color = cardColor(object)

        if playedCard(color) then
            object.deal(1, color)
            broadcastToColor("{uk}Ви вже зіграли карту!{ru}Вы уже сиграли карту!{en}You have already played a card!", color)
        else
            object.setRotation({ 0, 180 + colorAngle(color), 180 })
            object.setPositionSmooth(cluePosition(color), false, true)
        end
    end
end

function onObjectPickUp(player_color, picked_up_object)
    LAST_PICKED_UP_LOCATION = picked_up_object.getPosition()
    LAST_PICKED_UP_ROTATION = picked_up_object.getRotation()
end

function onObjectDrop(player_color, dropped_object)
    local zones = dropped_object.getZones()

    if dropped_object.hasTag("Sword") or dropped_object.hasTag("Shield") then
        checkIfWeaponIsAllowed(dropped_object)
    end

    table.foreach(zones, function(zone)
        if dropped_object.is_face_down and zone.tag == "Hand" then
            dropped_object.flip()
        end
    end)
end

function onPlayerChangeColor(player_color)
    if not GAME_STARTED then
        clearEverything()
        setupEverything()
    end
end

function onPlayerTurnStart(player_color_start, player_color_previous)
    if GAME_STARTED and not isRoundFinished() then
        PREVIOUS_PLAYER = PREVIOUS_PLAYER or player_color_start

        if PREVIOUS_PLAYER != player_color_start then
            broadcastToAll("{uk}Гру розпочато, але раунд іще не закінчено. В даний момент не можна передавати передавати хід!{ru}Игра начата, но раунд ещё не закончен. В данный момент нельзя передавать ход!{en}Game is started, but round is not over. Can't pass turns at this point!")
            Turns.turn_color = player_color_previous
        end
    else
        if GAME_STARTED and table.contains(getSeatedPlayers(), player_color_start) then
            firstPlayerMarker().setRotationSmooth({ 0, 180 + colorAngle(player_color_start), 0 }, false, true)
            firstPlayerMarker().setPositionSmooth(firstPlayerMarkerPosition(player_color_start), false, true)
            clearEverything()
            setupEverything()
            startGame()
        end
    end 
end

function saveData()
    local data = {
        GAME_STARTED = GAME_STARTED,
        GAME_MODE = GAME_MODE,
        PREVIOUS_PLAYER = Turns.turn_color,
        ROLES = ROLES,
        DECKS = table.kmap(DECKS or { }, function(deck) return deck.getGUID() end),
        CLUE_ZONES = table.kmap(CLUE_ZONES or { }, function(zone) return zone.getGUID() end),
        CHARACTER_ZONES = table.kmap(CHARACTER_ZONES or { }, function(zone) return zone.getGUID() end),
        CLUES_ZONES = table.kmap(CLUES_ZONES or { }, function(zones) return table.map(zones, function(zone) return zone.getGUID() end) end ),
        WEAPONS_ZONES = table.kmap(WEAPONS_ZONES or { }, function(zones) return table.map(zones, function(zone) return zone.getGUID() end) end )
    }

    return data
end
