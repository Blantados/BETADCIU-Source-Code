function start (song)
    setActorAlpha(0, 'chara',  true)
    followDadYOffset = 130
    followBFYOffset = 130
    setDefaultCamZoom(1.1)
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

    if curBeat >= 1 then
        if curBeat % 4 == 2 then
            playActorAnimation('gf', 'scared', false, false)
        end
    end
end

function stepHit (step)

    if curStep == 1 then
        
    end

    if curStep == 128 then
        setDefaultCamZoom(0.7)
    end

    if curStep == 768 then
        tweenFadeInBG('chara', 0.5, 0.3)
    end

    if curStep == 896 then
        tweenFadeOutBG('chara', 0, 0.3)
    end
end

function playerTwoSing()

    tweenCameraZoomIn(0.9, 0.1)
    shakeCam(0.02, 0.02)
    shakeHUD(0.03,0.03);

end

function playerOneSing()
    tweenCameraZoomIn(0.9, 0.1)
end
