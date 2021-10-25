function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

    if curBeat == 32 then
        changeDadCharacter('bf-sky', 50, 320)
    end

    if curBeat == 48 then
        changeBoyfriendCharacter('bf-exgf', 770, 75)
    end

    if curBeat == 64 then
        changeDadCharacter('mom', 20, 100)
    end

    if curBeat == 72 then
        changeBoyfriendCharacter('dad', 810, 75)
    end

    if curBeat == 80 then
        changeDadCharacter('hd-senpai-angry', 20, 100)
    end

    if curBeat == 88 then
        changeDadCharacter('hd-senpai-giddy', 20, 100)
        changeBoyfriendCharacter('hd-monika', 810, 125)
        followBFYOffset = 50
    end

    if curBeat == 96 then
        changeDadCharacter('whitty', 20, 100)
    end

    if curBeat == 112 then
        followBFYOffset = 0
        changeDadCharacter('whittyCrazy', 20, 100)
        changeBoyfriendCharacter('hex', 810, 75)
    end

    if curBeat == 128 then
        changeDadCharacter('cassandra', 20, 100)
    end

    if curBeat == 144 then
        changeBoyfriendCharacter('pico', 810, 400)
    end

    if curBeat == 160 then
        changeDadCharacter('bf-annie', 20, 400)
    end

    if curBeat == 176 then
        changeBoyfriendCharacter('garcello', 610, 100)
    end

    if curBeat == 192 then
        changeDadCharacter('sarvente', -55, 75)
    end

    if curBeat == 208 then
        changeBoyfriendCharacter('ruv', 810, 65)
    end

end

function stepHit (step)

end
