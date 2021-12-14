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

    if curBeat == 1 then
       
    end
    
    if curBeat == 64 then
        changeDadCharacter('dad', 20, 100)
    end

    if curBeat == 80 then
        changeBoyfriendCharacter('mom', 810, 75)
    end

    if curBeat == 96 then
        changeDadCharacter('pico', 20, 400)
    end

    if curBeat == 104 then
        changeBoyfriendCharacter('hd-senpai-angry', 810, 100)
        followBFXOffset = -50
        followBFYOffset = 50
    end

    if curBeat == 128 then
        changeDadCharacter('garcello', -55, 75)
    end

    if curBeat == 140 then
        changeBoyfriendCharacter('bf-annie', 810, 450)
        followBFXOffset = 0
        followBFYOffset = 0
    end

    if curBeat == 160 then
        changeDadCharacter('zardy', -100, 100)
    end

    if curBeat == 176 then
        changeBoyfriendCharacter('spooky', 830, 300)
    end

    if curBeat == 192 then
        changeDadCharacter('whitty', 20, 100)
    end

    if curBeat == 208 then
        changeBoyfriendCharacter('bf-carol', 810, 450)
    end

    if curBeat == 224 then
        changeDadCharacter('sarvente', -55, 75)
    end

    if curBeat == 256 then
        changeBoyfriendCharacter('ruv', 810, 65)
    end

    if curBeat == 288 then
        followDadYOffset = 20
        changeDadCharacter('exgf', 20, 100)
    end

    if curBeat == 320 then 
        followBFXOffset = 50   
        changeBoyfriendCharacter('bf-sky', 850, 320)
    end

    if curBeat == 352 then
        followDadYOffset = 0
        changeDadCharacter('tricky', -40, 140)
    end

    if curBeat == 384 then
        followBFXOffset = 0
        changeBoyfriendCharacter('hex', 810, 75)
    end

end

function stepHit (step)

end
