    function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorX(-300, 'bg', true)
    setActorY(0, 'bg', true)
    followDadXOffset = -30
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
    
end

function stepHit (step)

    if curStep == 1 then

    end
    
    if curStep == 72 then
        tweenCameraZoom(1.4, 2.3)
    end

    if curStep == 96 then
        setCameraZoom(0.9)
    end
    
    if curStep == 536 or curStep == 2272 then
        changeDadCharacter('bf', 100, 550)
    end

    if curStep == 544 or curStep == 2288 then
        changeDadCharacter('mom', 100, 200)
    end
end
