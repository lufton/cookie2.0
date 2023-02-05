require("lua/Constants")

local sin, cos = math.sin, math.cos
local deg, rad = math.deg, math.rad
math.sin = function (x) return sin(rad(x)) end
math.cos = function (x) return cos(rad(x)) end

function capitalize(str)
    return str:gsub("^%l", string.upper)
end

function table.clone(tbl)
    return { table.unpack(tbl) }
end

function table.index(tbl, value)
    for k, v in ipairs(tbl) do 
        if v == value then return k end
    end
end

function table.contains(tbl, value)
    return table.index(tbl, value) != nil
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k, v in pairs(o) do
          local stringkey = type(k) ~= 'number'
          k = '"' .. k .. '"'
          s = s .. k .. ': ' .. dump(v) .. ','
       end
       return s .. '} '
    else
        local stringvalue = type(o) ~= 'number'
        return stringvalue and '"' .. tostring(o) .. '"' or tostring(o)
    end
 end

function img(name)
    return BASE_IMAGES_URL .. name
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

function cardName(number, cap)
    local name = ({"cookie", "blueguy", "strontium", "37", "persians", "cosine", "hill", "sword", "shield"})[number]

    return cap and capitalize(name) or name
end

function cardNickname(number)
    if number == 1 then return "{uk}Печивко{ru}Печенька{en}Cookie"
    elseif number == 2 then return "{uk}Синій{ru}Синий{en}Blue"
    elseif number == 3 then return "{uk}Стронцій{ru}Строний{en}Strontium"
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

function cardData(id, additionalTags, players)
    local number = id % 100 + 1
    local tags = additionalTags and table.clone(additionalTags) or {}
    tags[#tags + 1] = cardName(number, true)

    local data = {
        Name = "Card",
        Nickname = cardNickname(number),
        Description = cardDescription(number, players),
        CardID = id,
        Tags = tags
    }

    return data
end

function deckContainedObjectsData(startId, count, tags, players, customDeck)
    local data = {}

    for i = 1, count do
        data[i] = cardData(startId + i - 1, tags, players, customDeck)
    end

    return data
end

function deckTransform(name)
    local isCharacter = name == "characters"
    local angle = isCharacter and 0 or (table.index(COLORS, name) - 1) * 60
    local transform = {
        posX = isCharacter and 0 or -math.sin(angle) * 3,
        posY = 1,
        posZ = isCharacter and 0 or -math.cos(angle) * 3,
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
    if name == "characters" then return "{uk}Персонажі{ru}Персонажи{en}Characters"
    elseif name == "orange" then return "{uk}Помаранчевий{ru}Оранжевый{en}Orange"
    elseif name == "yellow" then return "{uk}Жовтий{ru}Жёлтый{en}Yellow"
    elseif name == "green" then return "{uk}Зелений{ru}Зелёный{en}Green"
    elseif name == "teal" then return "{uk}Бірюзовий{ru}Бирюзовый{en}Teal"
    elseif name == "blue" then return "{uk}Синій{ru}Синий{en}Blue"
    elseif name == "purple" then return "{uk}Фіолетовий{ru}Фиолетовый{en}Purple"
    end
end

function deckDescription(name)
    if name == "characters" then return "{uk}Колода персонажів{ru}Колода персонажей{en}Characters deck"
    elseif name == "orange" then return "{uk}Колода помаранчевого гравця{ru}Оранжевого игрока{en}Orange player deck"
    elseif name == "yellow" then return "{uk}Колода жовтого гравця{ru}Жёлтого игрока{en}Yellow player deck"
    elseif name == "green" then return "{uk}Колода зеленого гравця{ru}Зелёного игрока{en}Green player deck"
    elseif name == "teal" then return "{uk}Колода бірюзового гравця{ru}Бирюзового игрока{en}Teal player deck"
    elseif name == "blue" then return "{uk}Колода синього гравця{ru}Синего игрока{en}Blue player deck"
    elseif name == "purple" then return "{uk}Колода фіолетового гравця{ru}Фиолетового игрока{en}Purple player deck"
    end
end

function deckTags(name)
    if name == "characters" then return { "Character" }
    elseif name == "orange" then return { "Orange" }
    elseif name == "yellow" then return { "Yellow" }
    elseif name == "green" then return { "Green" }
    elseif name == "teal" then return { "Teal" }
    elseif name == "blue" then return { "Blue" }
    elseif name == "purple" then return { "Purple" }
    end
end

function deckFace(name)
    if name == "characters" then return name
    elseif name == "orange" then return name
    elseif name == "yellow" then return name
    elseif name == "green" then return name
    elseif name == "teal" then return name
    elseif name == "blue" then return name
    elseif name == "purple" then return name
    end
end

function deckBack(name)
    if name == "characters" then return name
    elseif name == "orange" then return name
    elseif name == "yellow" then return name
    elseif name == "green" then return name
    elseif name == "teal" then return name
    elseif name == "blue" then return name
    elseif name == "purple" then return name
    end
end

function deckColumns(name)
    if name == "characters" then return 4
    elseif name == "orange" then return 5
    elseif name == "yellow" then return 5
    elseif name == "green" then return 5
    elseif name == "teal" then return 5
    elseif name == "blue" then return 5
    elseif name == "purple" then return 5
    end
end

function deckRows(name)
    if name == "characters" then return 2
    elseif name == "orange" then return 2
    elseif name == "yellow" then return 2
    elseif name == "green" then return 2
    elseif name == "teal" then return 2
    elseif name == "blue" then return 2
    elseif name == "purple" then return 2
    end
end

function deckStartId(name)
    if name == "characters" then return 100
    elseif name == "orange" then return 200
    elseif name == "yellow" then return 300
    elseif name == "green" then return 400
    elseif name == "teal" then return 500
    elseif name == "blue" then return 600
    elseif name == "purple" then return 700
    end
end

function deckCount(name)
    if name == "characters" then return 6
    elseif name == "orange" then return 9
    elseif name == "yellow" then return 9
    elseif name == "green" then return 9
    elseif name == "teal" then return 9
    elseif name == "blue" then return 9
    elseif name == "purple" then return 9
    end
end

function deckData(name)
    local players = GAME_MODE == 1 and #getSeatedPlayers() or 6
    local startId = deckStartId(name)
    local count = deckCount(name)
    local tags = deckTags(name)
    local angle = name == "characters" and 0 or (table.index(COLORS, name) - 1) * 60
    local customDeck = { }
    customDeck[math.floor(startId / 100)] = {
        FaceURL = face(deckFace(name)),
        BackURL = back(deckBack(name)),
        NumWidth = deckColumns(name),
        NumHeight = deckRows(name),
        BackIsHidden = true,
        UniqueBack = false,
        Type = 0
    }
    local data = {
        data = {
            Name = "DeckCustom",
            Transform = deckTransform(name),
            Nickname = deckNickname(name),
            Description = deckDescription(name),
            DeckIDs = range(startId, count),
            CustomDeck = customDeck,
            Tags = deckTags(name),
            ContainedObjects = deckContainedObjectsData(startId, count, tags, players, customDeck)
        }
    }

    return data
end

function spawnDeck(name)
    local deck = spawnObjectData(deckData(name))
    
    removeExtraCards(deck)

    return deck
end

function removeCard(deck, number)
    for _, cardData in pairs(deck.getObjects()) do
        if table.contains(cardData.tags, cardName(number, true)) then
            local card = deck.takeObject({
                guid = cardData.guid
            })
            card.destruct()
        end
    end
end

function removeExtraCards(deck)
    if GAME_MODE == 1 then
        local players = #getSeatedPlayers()

        if players > 5 then removeCard(deck, 7)
        elseif players > 4 then removeCard(deck, 6)
        elseif players > 3 then removeCard(deck, 5) removeCard(deck, 6)
        end
    end
end