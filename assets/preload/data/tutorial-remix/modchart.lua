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

    -- remove this entire file if you wanna play without the switches

    if curBeat == 16 then
        changeDadCharacter('gf1', 430, 130)
    end
    
    if curBeat == 24 then
        changeBoyfriendCharacter('bf1', 770, 450)
    end

    if curBeat == 32 then
        changeDadCharacter('gf2', 430, 130)
    end

    if curBeat == 40 then
        changeBoyfriendCharacter('bf2', 770, 450)
    end

    if curBeat == 48 then
        changeDadCharacter('gf3', 400, 130)
    end

    if curBeat == 56 then
        changeBoyfriendCharacter('bf3', 770, 450)
    end

    if curBeat == 64 then
        changeDadCharacter('gf4', 400, 130)
    end

    if curBeat == 72 then
        changeBoyfriendCharacter('bf4', 770, 450)
    end

    if curBeat == 80 then
        changeDadCharacter('gf5', 400, 130)
    end

    if curBeat == 84 then
        changeBoyfriendCharacter('bf5', 770, 450)
    end

end

function stepHit (step)

end
