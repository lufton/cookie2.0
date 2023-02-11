require("lua/Constants")

local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad
math.sin = function (x) return sin(rad(x)) end
math.cos = function (x) return cos(rad(x)) end

function table.clone(tbl)
    return { table.unpack(tbl) }
end

function table.index(tbl, value)
    for k, v in pairs(tbl) do 
        if v == value then return k end
    end
end

function table.contains(tbl, value)
    return table.index(tbl, value) != nil
end

function table.foreach(tbl, fn, ...)
    for k, v in pairs(tbl) do
        local _, r = pcall(fn, v, k, ...)
    end
end

function table.map(tbl, fn, ...)
    local t = { }
    
    for _, v in pairs(tbl) do
        local _, r = pcall(fn, v, ...)
        
        table.insert(t, r)
    end

    return t
end

function table.kmap(tbl, fn, ...)
    local t = { }
    
    for k, v in pairs(tbl) do
        local _, r = pcall(fn, v, ...)
        
        t[k] = r
    end

    return t
end

function table.filter(tbl, value)
    local t = { }
    
    for _, v in pairs(tbl) do
        if v != value then table.insert(t, v) end
    end

    return t
end

function table.reduce(list, fn, init)
    local acc = init
    
    for k, v in ipairs(list) do
        if 1 == k and not init then
            acc = v
        else
            acc = fn(acc, v)
        end
    end

    return acc
end

function dump(o)
    print(JSON.encode_pretty(o))
 end

function img(name)
    return BASE_IMAGES_URL .. string.lower(name)
end

function face(name)
    return img("faces/" .. name .. ".jpg")
end

function back(name)
    return img("backs/" .. name .. ".jpg")
end

function coin(name)
    return img("coins/" .. name .. ".jpg")
end

function range(from, count)
    local range = {}

    for i = 1, count do
        range[i] = from + i - 1
    end

    return range
end

function cardName(number)
    return CARDS[number]
end

function colorNameUK(color)
    if color == "Orange" then return "Помаранчевий"
    elseif color == "Yellow" then return "Жовтий"
    elseif color == "Green" then return "Зелений"
    elseif color == "Teal" then return "Бірюзовий"
    elseif color == "Blue" then return "Синій"
    elseif color == "Purple" then return "Фіолетовий"
    else return color
    end
end

function colorNameRU(color)
    if color == "Orange" then return "Оранжевый"
    elseif color == "Yellow" then return "Жёлтый"
    elseif color == "Green" then return "Зелёный"
    elseif color == "Teal" then return "Бирюзовый"
    elseif color == "Blue" then return "Синий"
    elseif color == "Purple" then return "Фиолетовый"
    else return color
    end
end

function cardNickname(number)
    if number == 1 then return "{uk}Печивко{ru}Печенька{en}Cookie"
    elseif number == 2 then return "{uk}Синій{ru}Синий{en}Blue"
    elseif number == 3 then return "{uk}Стронцій{ru}Стронций{en}Strontium"
    elseif number == 4 then return "{uk}37{ru}37{en}37"
    elseif number == 5 then return "{uk}Перси{ru}Персы{en}Persians"
    elseif number == 6 then return "{uk}Косинус{ru}Косинус{en}Cosine"
    elseif number == 7 then return "{uk}Пагорб{ru}Холм{en}Hill"
    elseif number == 8 then return "{uk}Меч{ru}Меч{en}Sword"
    elseif number == 9 then return "{uk}Щит{ru}Щит{en}Shield"
    end
end

function cardDescription(number, p)
    p = p or 6
    if number == 1 then return "{uk}Полює за Синім\nХовається від " .. (p > 5 and "Косинуса" or p > 4 and "Персів" or "37") .. "{ru}Охотится на Синего\nПрячется от " .. (p > 5 and "Косинуса" or p > 4 and "Персов" or "37") .. "{en}Hunting for Blue\nHiding from " .. (p > 5 and "Cosine" or p > 4 and "Persians" or "37")
    elseif number == 2 then return "{uk}Полює за Стронцієм\nХовається від Печивка{ru}Охотится на Стронция\nПрячется от Печеньки{en}Hunting for Strontium\nHiding from Cookie"
    elseif number == 3 then return "{uk}Полює за 37\nХовається від Синього{ru}Охотится на 37\nПрячется от Синего{en}Hunting for 37\nHiding from Blue"
    elseif number == 4 then return "{uk}Полює за " .. (p > 4 and "Персами" or "Печивком") .. "\nХовається від Стронцію{ru}Охотится на " .. (p > 4 and "Персов" or "Печеньку") .. "\nПрячется от Стронция{en}Hunting for " .. (p > 4 and "Persians" or "Cookie") .. "\nHiding from Strontium"
    elseif number == 5 then return "{uk}Полює за " .. (p > 5 and "Косинусом" or "Печивком") .. "\nХовається від 37{ru}Охотится на " .. (p > 5 and "Косинуса" or "Печеньку") .. "\nПрячется от 37{en}Hunting for " .. (p > 5 and "Cosine" or "Cookie") .. "\nHiding from 37"
    elseif number == 6 then return "{uk}Полює за Печивком\nХовається від Персів{ru}Охотится на Печеньку\nПрячется от Персов{en}Hunting for Cookie\nHiding from Persians"
    elseif number == 7 then return "{uk}Використовується для того, щоб не давати іншим гравцям додаткової інформації щодо вашої особистості{ru}Используется для того, чтобы не давать другим игрокам дополнительной информации о вашей личности{en}Use to give no additional information on your identity to other players"
    elseif number == 8 then return "{uk}Використовується для атаки того, за ким ви полюєте{ru}Используется для атаки того, за кем вы охотитесь{en}Use to attack the one you are hunting"
    elseif number == 9 then return "{uk}Використовується для захисту від того, хто на вас полює{ru}Используется для защиты от того, кто за вами охотится{en}Use to pretect from the one who is hunting you"
    end
end

function cardTag(number, color)
    if number > 0 and number < 8 then return color .. " Clue"
    else return color .. " Weapon"
    end
end

function cardData(id, additionalTags, players, color)
    local number = id % 100 + 1
    local tags = additionalTags and table.clone(additionalTags) or { }
    tags[#tags + 1] = cardName(number)
    tags[#tags + 1] = "Game"
    
    if color != "Characters" then table.insert(tags, cardTag(number, color)) end

    local data = {
        Name = "Card",
        Nickname = cardNickname(number),
        Description = cardDescription(number, players),
        GMNotes = cardName(number),
        CardID = id,
        Tags = tags
    }

    return data
end

function deckContainedObjectsData(startId, count, tags, players, color)
    local data = {}

    for i = 1, count do
        data[i] = cardData(startId + i - 1, tags, players, color)
    end

    return data
end

function deckTransform(name)
    local isCharacter = name == "Characters"
    local angle = isCharacter and 0 or (table.index(COLORS, name) - 1) * 60
    local transform = {
        posX = isCharacter and -0.85 or -math.sin(angle) * INNER_CARDS_Y_OFFSET,
        posY = 1,
        posZ = isCharacter and 0 or -math.cos(angle) * INNER_CARDS_Y_OFFSET,
        rotX = 180,
        rotY = angle,
        rotZ = 0,
        scaleX = CARDS_SCALE,
        scaleY = 1,
        scaleZ = CARDS_SCALE
    }

    return transform
end

function deckNickname(name)
    if name == "Characters" then return "{uk}Персонажі{ru}Персонажи{en}Characters"
    elseif name == "Orange" then return "{uk}Помаранчевий{ru}Оранжевый{en}Orange"
    elseif name == "Yellow" then return "{uk}Жовтий{ru}Жёлтый{en}Yellow"
    elseif name == "Green" then return "{uk}Зелений{ru}Зелёный{en}Green"
    elseif name == "Teal" then return "{uk}Бірюзовий{ru}Бирюзовый{en}Teal"
    elseif name == "Blue" then return "{uk}Синій{ru}Синий{en}Blue"
    elseif name == "Purple" then return "{uk}Фіолетовий{ru}Фиолетовый{en}Purple"
    end
end

function deckDescription(name)
    if name == "Characters" then return "{uk}Колода персонажів{ru}Колода персонажей{en}Characters deck"
    elseif name == "Orange" then return "{uk}Колода помаранчевого гравця{ru}Оранжевого игрока{en}Orange player deck"
    elseif name == "Yellow" then return "{uk}Колода жовтого гравця{ru}Жёлтого игрока{en}Yellow player deck"
    elseif name == "Green" then return "{uk}Колода зеленого гравця{ru}Зелёного игрока{en}Green player deck"
    elseif name == "Teal" then return "{uk}Колода бірюзового гравця{ru}Бирюзового игрока{en}Teal player deck"
    elseif name == "Blue" then return "{uk}Колода синього гравця{ru}Синего игрока{en}Blue player deck"
    elseif name == "Purple" then return "{uk}Колода фіолетового гравця{ru}Фиолетового игрока{en}Purple player deck"
    end
end

function deckTags(name)
    return name == "Characters" and { "Character" } or { name }
end

function deckColumns(name)
    return name == "Characters" and 4 or 5
end

function deckRows(name)
    return 2
end

function deckCount(name)
    return name == "Characters" and 6 or 9
end

function deckStartId(name)
    if name == "Characters" then return 100
    elseif name == "Orange" then return 200
    elseif name == "Yellow" then return 300
    elseif name == "Green" then return 400
    elseif name == "Teal" then return 500
    elseif name == "Blue" then return 600
    elseif name == "Purple" then return 700
    end
end

function deckData(name)
    local players = GAME_MODE == 1 and #getSeatedPlayers() or 6
    local startId = deckStartId(name)
    local count = deckCount(name)
    local tags = deckTags(name)
    tags[#tags + 1] = "Game"
    local angle = name == "Characters" and 0 or (table.index(COLORS, name) - 1) * 60
    local data = {
        data = {
            Name = "DeckCustom",
            Transform = deckTransform(name),
            Nickname = deckNickname(name),
            Description = deckDescription(name),
            DeckIDs = range(startId, count),
            CustomDeck = { [math.floor(startId / 100)] = {
                FaceURL = face(name),
                BackURL = back(name),
                NumWidth = deckColumns(name),
                NumHeight = deckRows(name),
                BackIsHidden = true,
                UniqueBack = false,
                Type = 0
            } },
            Tags = tags ,
            ContainedObjects = deckContainedObjectsData(startId, count, tags, players, name)
        }
    }

    return data
end

function spawnDeck(name)
    local deck = spawnObjectData(deckData(name))
    
    DECKS = DECKS and DECKS or { }
    DECKS[name] = deck

    return deck
end

function removeCard(deck, number)
    for _, cardData in pairs(deck.getObjects()) do
        if table.contains(cardData.tags, cardName(number)) then
            local card = deck.takeObject({
                index = cardData.index
            })
            card.destruct()
        end
    end
end

function removeExtraCards(deck, name)
    if GAME_MODE == 1 then
        local players = #getSeatedPlayers()
        
        if players > 5 then removeCard(deck, 7)
        elseif players > 4 then removeCard(deck, 6)
        elseif players > 3 then removeCard(deck, 5) removeCard(deck, 6)
        end
        
        if name != "Characters" then
            removeCard(deck, table.index(CARDS, ROLES[name]))
        end
    end
end

function colorAngle(color)
    local index = table.index(COLORS, color)
    
    return (index - 1) * 60
end

function characterPosition(color)
    local angle = colorAngle(color)

    return { -math.sin(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET * 2) - math.cos(angle) * CARDS_X_OFFSET * 0.5, 1, -math.cos(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET * 2) + math.sin(angle) * CARDS_X_OFFSET * 0.5 }
end

function cluePosition(color)
    local angle = colorAngle(color)

    return { -math.sin(angle) * INNER_CARDS_Y_OFFSET, 1, -math.cos(angle) * INNER_CARDS_Y_OFFSET }
end

function firstPlayerMarkerPosition(color)
    local angle = colorAngle(color)

    return { -math.sin(angle) * FIRST_PLAYER_MARKER_Y_OFFSET + math.cos(angle) * FIRST_PLAYER_MARKER_X_OFFSET, 1, -math.cos(angle) * FIRST_PLAYER_MARKER_Y_OFFSET - math.sin(angle) * FIRST_PLAYER_MARKER_X_OFFSET }
end

function snapPointsData()
    local data = { }

    for i, color in ipairs(COLORS) do
        local angle = (i - 1) * 60

        for dx = 2.5 * CARDS_X_OFFSET, -2.5 * CARDS_X_OFFSET, -CARDS_X_OFFSET do
            table.insert(data, {
                position = { -math.sin(angle) * CLUE_CARDS_Y_OFFSET - math.cos(angle) * dx, 1, -math.cos(angle) * CLUE_CARDS_Y_OFFSET + math.sin(angle) * dx },
                rotation = { 0, 180 + angle, 0 },
                rotation_snap = true,
                tags = { color .. " Clue" }
            })
        end

        for dx = 1.5 * CARDS_X_OFFSET, -1.5 * CARDS_X_OFFSET, -CARDS_X_OFFSET do
            table.insert(data, {
                position = { -math.sin(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET) - math.cos(angle) * dx, 1, -math.cos(angle) * (CLUE_CARDS_Y_OFFSET - CARDS_Y_OFFSET) + math.sin(angle) * dx },
                rotation = { 0, 180 + angle, 0 },
                rotation_snap = true,
                tags = table.map(table.filter(COLORS, color), function(color)
                    return color .. " Weapon"
                end)
            })
        end

        table.insert(data, {
            position = characterPosition(color),
            rotation = { 0, 180 + angle, 0 },
            rotation_snap = true,
            tags = { "Character" }
        })
        table.insert(data, {
            position = cluePosition(color),
            rotation = { 0, 180 + angle, 0 },
            rotation_snap = true,
            tags = { color }
        })
        table.insert(data, {
            position = firstPlayerMarkerPosition(color),
            rotation = { 0, 180 + angle, 0 },
            rotation_snap = true,
            tags = { "First Player Marker" }
        })
    end

    table.insert(data, {
        position = { 0, 0, 0},
        rotation = { 0, 180, 0 },
        rotation_snap = true,
        tags = { "Reminder" }
    })

    return data
end

function reminderCardData(id, players)
    return {
        CardID = id,
        CustomDeck = {[8] = {
            BackIsHidden = false,
            BackURL = face("reminders"),
            FaceURL = face("reminders"),
            NumHeight = 2,
            NumWidth = 2,
            Type = 0,
            UniqueBack = true
        }},
        Description = "{uk}Пам'ятка для " .. players .. " гравців{ru}Памятка для " .. players .. " игроков{en}Reminder for " .. players .. " players",
        Hands = false,
        Name = "Card",
        Nickname = "{uk}Пам'ятка{ru}Памятка{en}Reminder",
        Tags = { "Reminder", "Game" },
        Transform = {
            posX = 0.85,
            posY = 1,
            posZ = 0,
            rotX = 0,
            rotY = 180,
            rotZ = 0,
            scaleX = 0.7,
            scaleY = 1,
            scaleZ = 0.7
        }
    }
end

function reminderData()
    local data = reminderCardData(802, 6)

    data["States"] = {
        [2] = reminderCardData(801, 5),
        [3] = reminderCardData(800, 4),
    }

    return { data = data }
end

function youArePlayingForMessage(cardName)
    return ({
        "{uk}Ви граєте за Печивко{ru}Вы играете за Печеньку{en}You are playing for Cookie",
        "{uk}Ви граєте за Синього{ru}Вы играете за Синего{en}You are playing for Blue",
        "{uk}Ви граєте за Стронція{ru}Вы играете за Стронция{en}You are playing for Strontium",
        "{uk}Ви граєте за 37{ru}Вы играете за 37{en}You are playing for 37",
        "{uk}Ви граєте за Персів{ru}Вы играете за Персов{en}You are playing for Persians",
        "{uk}Ви граєте за Косинуса{ru}Вы играете за Косинуса{en}You are playing for Cosine",
    })[table.index(CARDS, cardName)]
end

function reminder()
    for _, object in pairs(getAllObjects()) do
        if object.tag == "Card" and object.hasTag("Reminder") then return object end
    end

    return false
end

function firstPlayerMarker()
    for _, object in pairs(getAllObjects()) do
        if object.tag == "Tile" and object.hasTag("First Player Marker") then return object end
    end

    return false
end

function playedCard(color)
    -- print(color)
    for _, object in pairs(CLUE_ZONES[color].getObjects()) do
        if object.hasTag(color) then
            return object
        end
    end

    return false
end

function characterCard(color)
    for _, object in pairs(CHARACTER_ZONES[color].getObjects()) do
        if object.hasTag("Character") then
            return object
        end
    end

    return false
end

function isEveryonePlayedCard()
    local result = GAME_STARTED

    table.foreach(getSeatedPlayers(), function(color)
        local card = playedCard(color)
        result = result and card and card.resting and card.is_face_down
    end)

    return result
end

function areCardsRevealed()
    -- print("areCardsRevealed")
    local result = GAME_STARTED

    table.foreach(getSeatedPlayers(), function(color, i)
        local card = playedCard(color)
        result = result and card and card.resting and not card.is_face_down
    end)

    -- print(result)

    return result
end

function playerClueCard(color, i)
    for _, object in pairs(CLUES_ZONES[color][i].getObjects()) do
        if object.tag == "Card" then return object end
    end

    return false
end

function playerWeaponCard(color, i)
    for _, object in pairs(WEAPONS_ZONES[color][i].getObjects()) do
        if object.tag == "Card" then return object end
    end

    return false
end

function firstEmptyCluePosition(color)
    for i = 1, 6 do
        local card = playerClueCard(color, i)
        if not card then
            local angle = colorAngle(color)
            local dx = (3.5 - i) * CARDS_X_OFFSET
            
            return { -math.sin(angle) * CLUE_CARDS_Y_OFFSET - math.cos(angle) * dx, 1, -math.cos(angle) * CLUE_CARDS_Y_OFFSET + math.sin(angle) * dx }
        end
    end

    return false
end

function cardColor(card)
    for _, color in pairs(COLORS) do
        if card.hasTag(color) then return color end
    end

    return false
end

function checkIfWeaponIsAllowed(weapon)
    local allowed = true
    local weaponColor = cardColor(weapon)
    local zones = weapon.getZones()
    local isSword = weapon.hasTag("Sword")

    table.foreach(zones, function(zone)
        local zoneColor = zone.getVar("color")

        for i = 1, 4 do
            local weapon = playerWeaponCard(weaponColor, i)
            allowed = allowed and (weapon == nil or cardColor(weapon) != zoneColor or (isSword and weapon.hasTag("Sword") or (not isSword and not weapon.hasTag("Sword"))))
        end
    end)

    if not allowed then
        if LAST_PICKED_UP_LOCATION and LAST_PICKED_UP_ROTATION then
            weapon.setRotation(LAST_PICKED_UP_ROTATION)
            weapon.setPositionSmooth(LAST_PICKED_UP_LOCATION, false, true)
        else
            weapon.setRotation({ 0, 180 + colorAngle(weaponColor), 0 })
            weapon.setPositionSmooth(Vector(cluePosition(weaponColor)) + Vector(0, 0.5, 0), false, true)
        end
        broadcastToColor("{uk}Не можна використати " .. (isSword and "Меч" or "Щит") .. " проти гравця, який вже використав проти вас " .. (isSword and "Щит" or "Меч") .. "!{ru}Нельзя применять " .. (isSword and "Меч" or "Щит") .. " против игрока, который уже использовал против вас " .. (isSword and "Щит" or "Меч") .. "{en}You can't use " .. (isSword and "Sword" or "Shield") .. " against player, that already used " .. (isSword and "Shield" or "Sword") .. " against you!", weaponColor)
    end
end

function isRoundFinished()
    local counts = { }
    
    table.foreach(getSeatedPlayers(), function(color) counts[color] = 0 end)
    table.foreach(CLUES_ZONES, function(zones)
        table.foreach(zones, function(zone)
            table.foreach(zone.getObjects(), function(object)
                if object.resting then
                    local color = cardColor(object)
                    counts[color] = counts[color] + 1
                end
            end)
        end)
    end)
    table.foreach(WEAPONS_ZONES, function(zones)
        table.foreach(zones, function(zone)
            table.foreach(zone.getObjects(), function(object)
                if object.resting then
                    local color = cardColor(object)
                    counts[color] = counts[color] + 1
                end
            end)
        end)
    end)

    return table.reduce(table.map(counts, function(count) return count == #getSeatedPlayers() end), function(a, b) return a and b end, true)
end
