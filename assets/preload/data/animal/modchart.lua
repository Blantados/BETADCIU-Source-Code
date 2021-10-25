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

    if curBeat == 20 then
        changeDadCharacter('monster-christmas', 100, 150)
    end

    if curBeat == 28 then
        changeBoyfriendCharacter('spooky', 1090, 300)
    end

    if curBeat == 40 then
        changeDadCharacter('garcello', 80, 100)
    end

    if curBeat == 48 then
        changeBoyfriendCharacter('matt', 1090, 450)
    end

    if curBeat == 55 then
        changeDadCharacter('miku', 100, 100)
    end

    if curBeat == 63 then
        changeBoyfriendCharacter('hd-monika', 1090, 125)
    end

    if curBeat == 72 then
        changeDadCharacter('selever', 100, 100)
    end

    if curBeat == 88 then
        changeBoyfriendCharacter('ruv', 1090, 75)
    end

    if curBeat == 96 then
        changeDadCharacter('hd-senpai-giddy', 100, 100)
    end

    if curBeat == 104 then
        changeBoyfriendCharacter('tankman', 990, 300)
    end

    if curBeat == 112 then
        changeDadCharacter('liz', 100, 400)
    end

    if curBeat == 128 then
        changeGFCharacter('nogf', 400, 130)
        changeBoyfriendCharacter('bf-gf', 1090, 450)
    end

    if curBeat == 144 then
        changeDadCharacter('dad', 100, 100)
    end

    if curBeat == 152 then
        changeGFCharacter('gf', 400, 130)
        changeBoyfriendCharacter('mom', 1090, 75)
    end

    if curBeat == 160 then
        changeDadCharacter('bf-frisk', 100, 400)
    end

    if curBeat == 168 then
        changeBoyfriendCharacter('bf-sans', 1090, 450);
    end

    if curBeat == 176 then
        changeDadCharacter('whitty', 100, 100)    
    end

    if curBeat == 184 then
        changeBoyfriendCharacter('hex', 1090, 75)
    end

    if curBeat == 192 then
        changeDadCharacter('pico', 100, 400)
        changeBoyfriendCharacter('kapi', 1090, 75)
    end

    if curBeat == 212 then
        changeDadCharacter('agoti', -55, 75)    
    end

    if curBeat == 220 then
        changeBoyfriendCharacter('tabi', 1090, 75)
    end

    if curBeat == 228 then
        changeDadCharacter('tord', 100, 200)    
    end

    if curBeat == 244 then
        changeBoyfriendCharacter('tom', 1090, 175)
    end

    if curBeat == 260 then
        changeDadCharacter('bf-carol', 100, 400) 
    end

    if curBeat == 268 then
        changeBoyfriendCharacter('bf-sky', 1090, 300)
    end

end

function stepHit (step)

end
