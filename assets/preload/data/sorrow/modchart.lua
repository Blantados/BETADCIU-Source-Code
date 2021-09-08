function start (song)
	print("Song then " .. song .. " @ " .. bpm .. " downscroll then " .. downscroll) 

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

local dadX = 0
local dadY = 0
local boyfriendX = 0
local boyfriendY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
end

function beatHit (beat)

end

function stepHit (step)

    if curStep == 1 then
        
    end

    if curStep == 512 then
        flashCam(255,255,255,1)
        changeBoyfriendCharacterBetter(820, 350, 'botan')
    end

    if curStep == 768 then
        flashCam(255,255,255,1)
        changeBoyfriendCharacterBetter(770, 450, 'bf-aloe')
    end

    if curStep == 1024 then
        flashCam(255,255,255,1)
        stopGFDance(true)
        playActorAnimation('gf', 'scared', true, false);
        changeBoyfriendCharacterBetter(870, 200, 'haachama')
    end

end
