function start (song)
	tweenCameraZoomIn(1.1, 0.1)
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

    -- not this time

end

function stepHit (step)

end

function playerTwoSing()

    tweenCameraZoomIn(1.1, 0.1)
    shakeCam(0.02, 0.02)
    shakeHUD(0.03,0.03);

end

function playerOneSing()
    tweenCameraZoomIn(1.1, 0.1)
end
