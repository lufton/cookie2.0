require("lua/Helpers")

function clearObjects()
    local objects = getObjects()
    
    for _, object in pairs(objects) do
        if object.hasTag("Game") then
            object.destruct()
        end
    end

    DECKS = { }
    print("Objects were cleared")
end

function clearSnapPoins()
    Global.setSnapPoints({ })

    print("Snap points were cleared")
end

function clearEverything()
    GAME_STARTED = false
    clearSnapPoins()
    clearObjects()
    print("Everything was cleared")
end

function setupSnapPoints()
    Global.setSnapPoints(snapPointsData())
end

function setupCharactersDeck()
    local deck = spawnDeck("Characters")

    deck.hide_when_face_down = false

    return deck
end

function setupPlayerDeck(color)
    return spawnDeck(color)
end

function setupSeatedPlayersDecks()
    local seatedPlayers = getSeatedPlayers()
    
    table.foreach(COLORS, function(color)
        if table.contains(seatedPlayers, color) then
            setupPlayerDeck(color)
        end
    end)
end

function setupPlayerZones(color)
    local angle = colorAngle(color)
    local weaponTags = table.map(table.filter(getSeatedPlayers(), color), function(color) return color .. " Weapon" end)
    
    CLUE_ZONES[color] = spawnObject({
        type = "ScriptingTrigger",
        position = cluePosition(color),
        rotation = { 0, 180 + angle, 0 },
        scale = CARDS_ZONES_SCALE
    })
    CLUE_ZONES[color].setTags({ color })
    CLUES_ZONES[color] = { }

    for dx = 2.5 * CARDS_X_OFFSET, -2.5 * CARDS_X_OFFSET, -CARDS_X_OFFSET do
        local zone = spawnObject({
            type = "ScriptingTrigger",
            position = { -math.sin(angle) * CLUE_CARDS_Y_OFFSET - math.cos(angle) * dx, 1, -math.cos(angle) * CLUE_CARDS_Y_OFFSET + math.sin(angle) * dx },
            rotation = { 0, 180 + angle, 0 },
            scale = CARDS_ZONES_SCALE
        })
        zone.setTags({ color })
        table.insert(CLUES_ZONES[color], zone)
    end

    WEAPONS_ZONES[color] = { }

    for dx = 1.5 * CARDS_X_OFFSET, -1.5 * CARDS_X_OFFSET, -CARDS_X_OFFSET do
        local zone = spawnObject({
            type = "ScriptingTrigger",
            position = { -math.sin(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET) - math.cos(angle) * dx, 1, -math.cos(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET) + math.sin(angle) * dx },
            rotation = { 0, 180 + angle, 0 },
            scale = CARDS_ZONES_SCALE
        })
        zone.setVar("color", color)
        zone.setTags(weaponTags)
        table.insert(WEAPONS_ZONES[color], zone)
    end
end

function setupHiddenZone(color)
    local angle = colorAngle(color)

    table.foreach(getObjects(), function(object)
        if object.tag == "FogOfWar" then object.destruct() end
    end)

    CHARACTER_ZONES[color] = spawnObject({
        type = "FogOfWarTrigger",
        position = characterPosition(color),
        rotation = { 0, 180 + angle, 0 },
        scale = CHARACTERS_ZONES_SCALE,
        callback_function = function(zone) zone.setValue(color) end
    })
    CHARACTER_ZONES[color].setTags({ "Character", "Game" })
end

function setupSeatedPlayersZones()
    table.foreach(getObjects(), function(object)
        if object.tag == "Scripting" then object.destruct() end
    end)
    CLUE_ZONES = { }
    CHARACTER_ZONES = { }
    CLUES_ZONES = { }
    WEAPONS_ZONES = { }
    table.foreach(COLORS, function(color)
        setupPlayerZones(color)
        setupHiddenZone(color)
    end)
end

function setupReminder()
    local reminder = spawnObjectData(reminderData())

    return reminder
end

function setupMenu()
    DECKS.Characters.clearButtons()

    if #getSeatedPlayers() == 4 then
        DECKS.Characters.createButton({
            click_function = "selectMode1",
            function_owner = self,
            label = "{uk}Режим 1{ru}Режим 1{en}Mode 1",
            position = { 0, -0.25, -0.5 },
            rotation = { 180, 180, 0 },
            width = 1000,
            height = 400,
            font_size = 250,
            tooltip = "Tooltip"
        })
        DECKS.Characters.createButton({
            click_function = "selectMode2",
            function_owner = self,
            label = "{uk}Режим 2{ru}Режим 2{en}Mode 2",
            position = { 0, -0.25, 0.5 },
            rotation = { 180, 180, 0 },
            width = 1000,
            height = 400,
            font_size = 250,
            tooltip = "Tooltip"
        })
    else
        DECKS.Characters.createButton({
            click_function = "startGame",
            function_owner = self,
            label = "{uk}Почати{ru}Начать{en}Start",
            position = { 0, -0.25, 0 },
            rotation = { 180, 180, 0 },
            width = 1000,
            height = 400,
            font_size = 250,
            tooltip = "Tooltip"
        })
    end
end

function modeMenu()
    DECKS.Characters.clearButtons()
    DECKS.Characters.createButton({
        click_function = "startGame",
        function_owner = self,
        label = "{uk}Почати{ru}Начать{en}Start",
        position = { 0, -0.25, -0.5 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "Tooltip"
    })
    DECKS.Characters.createButton({
        click_function = "setupMenu",
        function_owner = self,
        label = "{uk}Назад{ru}Назад{en}Back",
        position = { 0, -0.25, 0.5 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "Tooltip"
    })
end

function selectMode1()
    GAME_MODE = 1
    modeMenu()
end

function selectMode2()
    GAME_MODE = 2
    modeMenu()
end

function setupEverything()
    setupSnapPoints()
    setupCharactersDeck()
    setupSeatedPlayersDecks()
    --setupSeatedPlayersZones()
    setupReminder()
    setupMenu()
end

function dealCharacters()
    ROLES = { }
    table.foreach(getSeatedPlayers(), function(color)
        setupHiddenZone(color)

        local index = table.index(COLORS, color)
        local angle = (index - 1) * 60
        local card = DECKS.Characters.takeObject({
            position = characterPosition(color),
            rotation = { 0, 180 + angle, 180 },
            smooth = true,
            callback_function = function(card) card.setRotation({ 0, 180 + angle, 0 }) card.setLock(true) end
        })
        ROLES[color] = card.getGMNotes()
        broadcastToColor(youArePlayingForMessage(card.getGMNotes()), color)
    end)
end

function startGame(object, player_clicker_color, alt_click)
    if player_clicker_color and player_clicker_color != Turns.turn_color then
        broadcastToColor("{uk}Тільки гравець із Маркером Первого Гравця може натискати кнопки!{ru}Только игрок с Маркером Первого Игрока может нажимать на кнопки!{en}Only player with a First Player Marker can press buttons!", player_clicker_color)
        return
    end

    removeExtraCards(DECKS.Characters, "Characters")
    DECKS.Characters.clearButtons()
    DECKS.Characters.shuffle()
    dealCharacters()
    table.foreach(DECKS, function(deck, color)
        removeExtraCards(deck, color)
        deck.shuffle()
        deck.deal(7, color)
    end)

    local reminder = reminder()
    local state

    if GAME_MODE == 1 then
        state = #getSeatedPlayers() > 5 and 1 or #getSeatedPlayers() > 4 and 2 or 3
    elseif GAME_MODE == 2 then
        state = 1
    end

    reminder.setPosition({ 0, 1, 0 })
    if reminder.getStateId() != state then reminder.setState(state) end
    attachIsEveryoneHasPlayedCardWaiter()
    attachAreCardsRevealedWaiter()
    attachIsRoundFinishedWaiter()
    GAME_STARTED = true
    PREVIOUS_PLAYER = Turns.turn_color
end

function revealCards(object, player_clicker_color, alt_click)
    if player_clicker_color and player_clicker_color != Turns.turn_color then
        broadcastToColor("{uk}Тільки гравець із Маркером Первого Гравця може натискати кнопки!{ru}Только игрок с Маркером Первого Игрока может нажимать на кнопки!{en}Only player with a First Player Marker can press buttons!", player_clicker_color)
        return
    end

    reminder().clearButtons()
    table.foreach(getSeatedPlayers(), function(color)
        local card = playedCard(color)
        if card.is_face_down then card.flip() end
    end)
end

function everyOneHasPlayedCard()
    local reminder = reminder()

    broadcastToAll("{uk}Усі зіграли!{ru}Все сиграли!{en}Everyone has played!")
    reminder.clearButtons()
    reminder.createButton({
        click_function = "revealCards",
        function_owner = self,
        label = "{uk}Вскрити{ru}Всрыть{en}Reveal",
        position = { 0, -0.25, 0 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Вскрити зіграні карти{ru}Вскрыть сиграные карты{en}Reveal played cards"
    })
    reminder.createButton({
        click_function = "revealCards",
        function_owner = self,
        label = "{uk}Вскрити{ru}Всрыть{en}Reveal",
        position = { 0, 0.25, 0 },
        rotation = { 0, 0, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Вскрити зіграні карти{ru}Вскрыть сиграные карты{en}Reveal played cards"
    })
    Wait.condition(function()
        reminder.clearButtons()
        attachIsEveryoneHasPlayedCardWaiter(true)
    end, function() return not isEveryonePlayedCard() end)
end

function attachIsEveryoneHasPlayedCardWaiter(force)
    if force or not IS_EVERYONE_HAS_PLAYED_CARD_WAITER_ATTACHED then
        IS_EVERYONE_HAS_PLAYED_CARD_WAITER_ATTACHED = true
        Wait.condition(everyOneHasPlayedCard, isEveryonePlayedCard)
    end
end

function discardCards(object, player_clicker_color, alt_click)
    if player_clicker_color and player_clicker_color != Turns.turn_color then
        broadcastToColor("{uk}Тільки гравець із Маркером Первого Гравця може натискати кнопки!{ru}Только игрок с Маркером Первого Игрока может нажимать на кнопки!{en}Only player with a First Player Marker can press buttons!", player_clicker_color)
        return
    end

    reminder().clearButtons()
    table.foreach(getSeatedPlayers(), function(color)
        local card = playedCard(color)
        if card.hasTag(color .. " Clue") then
            card.setPositionSmooth(firstEmptyCluePosition(color), false, false)
        end
    end)
end

function cardsRevealed()
    local reminder = reminder()

    broadcastToAll("{uk}Карти вскриті!{ru}Карты вскрыты!{en}Cards are revealed!")
    reminder.clearButtons()
    reminder.createButton({
        click_function = "discardCards",
        function_owner = self,
        label = "{uk}Здати{ru}Сдать{en}Deal",
        position = { 0, -0.25, 0 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Здати вскриті карти{ru}Сдать вскрытые карты{en}Deal revealed cards"
    })
    reminder.createButton({
        click_function = "discardCards",
        function_owner = self,
        label = "{uk}Здати{ru}Сдать{en}Deal",
        position = { 0, 0.25, 0 },
        rotation = { 0, 0, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Здати вскриті карти{ru}Сдать вскрытые карты{en}Deal revealed cards"
    })
    Wait.condition(function()
        reminder.clearButtons()
        attachAreCardsRevealedWaiter(true)
    end, function() return not areCardsRevealed() end)
end

function attachAreCardsRevealedWaiter(force)
    if force or not ARE_CARDS_REVEALED_WAITER_ATTACHED then
        ARE_CARDS_REVEALED_WAITER_ATTACHED = true
        Wait.condition(cardsRevealed, areCardsRevealed)
    end
end

function announceResults(object, player_clicker_color, alt_click)
    if player_clicker_color and player_clicker_color != Turns.turn_color then
        broadcastToColor("{uk}Тільки гравець із Маркером Первого Гравця може натискати кнопки!{ru}Только игрок с Маркером Первого Игрока может нажимать на кнопки!{en}Only player with a First Player Marker can press buttons!", player_clicker_color)
        return
    end

    local reminder = reminder()
    local playersCount = #getSeatedPlayers()
    local players = Player.getPlayers()

    reminder.clearButtons()
    reminder.createButton({
        click_function = "endTurn",
        function_owner = self,
        label = "{uk}Далі{ru}Далее{en}Next",
        position = { 0, -0.25, 0 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Передати хід наступному гравцю{ru}Предеть ход следующему игроку{en}Pass turn to the next player"
    })
    reminder.createButton({
        click_function = "endTurn",
        function_owner = self,
        label = "{uk}Далі{ru}Далее{en}Next",
        position = { 0, 0.25, 0 },
        rotation = { 0, 0, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Передати хід наступному гравцю{ru}Предеть ход следующему игроку{en}Pass turn to the next player"
    })
    table.foreach(getSeatedPlayers(), function(color)
        local coins = 0
        local card = characterCard(color)
        local role = ROLES[color]
        local roleNumber = table.index(CARDS, role)
        local prey = cardName(roleNumber % playersCount + 1)
        local preyColor = table.index(ROLES, prey)
        local assaulter = cardName((roleNumber + playersCount - 2) % playersCount + 1)
        local assaulterColor = table.index(ROLES, assaulter)
        CHARACTER_ZONES[color].destruct()

        for i = 1, 4 do
            local weapon = playerWeaponCard(preyColor, i)
            if weapon and weapon.hasTag(color) and weapon.hasTag("Sword") then
                broadcastToColor("{uk}Ви напали на правильну жертву (3 монети){ru}Вы напали на правильную жертву (3 монеты){en}You have attacked right prey (3 coins)", color)
                coins = coins + 3
            end
        end

        for i = 1, 4 do
            local weapon = playerWeaponCard(assaulterColor, i)
            if weapon and weapon.hasTag(color) and weapon.hasTag("Shield") then
                broadcastToColor("{uk}Ви захистилися від правильного нападника (2 монети){ru}Вы защитились от правильного нападающего (2 монеты){en}You have protected from the right assaulter (2 coins)", color)
                coins = coins + 2
            end
        end

        if playersCount < 6 then
            keptHillCard = true
            for i = 1, 6 do
                local clue = playerClueCard(color, i)
                keptHillCard = keptHillCard and (not clue or not clue.hasTag("Hill"))
            end

            if keptHillCard then
                broadcastToColor("{uk}Ви зберегли карту Пагорба (1 монета){ru}Вы сохранили карту Холма (1 монета){en}You have saved Hill card (1 coins)", color)
                coins = coins + 1
            end
        end

        broadcastToColor("{uk}Ви отримуєте " .. coins .. " монет(у/и){ru}Вы получаете " .. coins .. " монет(у/ы){en}You receive " .. coins .. " coin(s)", color)
        table.foreach(players, function(player)
            if player.color == color then
                print("{uk}" .. player.steam_name .. " (" .. colorNameUK(color) .. "): +" .. coins .. " монет(а/и){ru}" .. player.steam_name .. " (" .. colorNameRU(color) .. "): +" .. coins .. " монет(а/ы){en}" .. player.steam_name .. " (" .. color .. "): +" .. coins .. " coin(s)")
            end
        end)
    end)
end

function roundIsFinished()
    local reminder = reminder()

    broadcastToAll("{uk}Раунд закінчився, можна оголошувати результати!{ru}Раунд закончился, можно оглашать результаты!{en}Round is over, results can be announced!")
    reminder.clearButtons()
    reminder.createButton({
        click_function = "announceResults",
        function_owner = self,
        label = "{uk}Раунд!{ru}Раунд!{en}Round!",
        position = { 0, -0.25, 0 },
        rotation = { 180, 180, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Оголосити результати{ru}Огласить результаты{en}Announce results"
    })
    reminder.createButton({
        click_function = "announceResults",
        function_owner = self,
        label = "{uk}Раунд!{ru}Раунд!{en}Round!",
        position = { 0, 0.25, 0 },
        rotation = { 0, 0, 0 },
        width = 1000,
        height = 400,
        font_size = 250,
        tooltip = "{uk}Оголосити результати{ru}Огласить результаты{en}Announce results"
    })
    Wait.condition(function()
        reminder.clearButtons()
        attachIsRoundFinishedWaiter(true)
    end, function() return not isRoundFinished() end)
end

function attachIsRoundFinishedWaiter(force)
    if force or not IS_ROUND_FINISHED_WAITER_ATTACHED then
        IS_ROUND_FINISHED_WAITER_ATTACHED = true
        Wait.condition(roundIsFinished, isRoundFinished)
    end
end

function endTurn(object, player_clicker_color, alt_click)
    if player_clicker_color and player_clicker_color != Turns.turn_color then
        broadcastToColor("{uk}Тільки гравець із Маркером Первого Гравця може натискати кнопки!{ru}Только игрок с Маркером Первого Игрока может нажимать на кнопки!{en}Only player with a First Player Marker can press buttons!", player_clicker_color)
        return
    end

    reminder().clearButtons()
    Turns.turn_color = Turns.getNextTurnColor()
end
