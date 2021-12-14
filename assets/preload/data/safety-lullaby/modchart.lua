function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0
local floatShit = 0

local dadMidpointX = 0
local dadMidpointY = 0

local eyeX = 0
local eyeY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
  
end

function beatHit (beat)

end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then
        
    end

    if curStep == 190 then
        changeDadCharacter('exe-revie', 250, -200)
        followDadXOffset = -200
        followDadYOffset = -200
    end

    if curStep == 260 then
        changeBoyfriendCharacter('bf-sonic', 1140, 170)
    end

    if curStep == 320 then
        changeDadCharacter('haachama', 240, -60)
    end

end