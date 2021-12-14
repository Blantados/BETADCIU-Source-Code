local weFlashin = 0

function start (song)
	print("Song then " .. song .. " @ " .. bpm .. " downscroll then " .. downscroll) 
    followBFXOffset = 100
    followBFYOffset = 100

    if flashing == true then
        weFlashin = 1
    else
        weFlashin = 0
    end
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

    if curBeat > 3 and curBeat < 229 then
        shakeCam(0.01, 0.2)
        addCamZoom(0.015)
        addHudZoom(0.03)
        playBGAnimation2('speakers', 'boom', false, false)
    end

    if curBeat > 100 and curBeat < 114 then
        shakeCam(0.01, 0.2)
        addCamZoom(0.015)
        addHudZoom(0.03)
    end

    if curBeat > 99 and curBeat < 195 then
        tweenFadeOut('garage', 0.2, 0.0000001)
        if weFlashin == 1 then
            playBGAnimation2('garage', 'crazy', false, false)
            
        else
            playBGAnimation2('garage', 'notcrazy', false, false)
        end

        sundayFilter(true)
    end

    if curBeat == 195 then
        tweenFadeIn('garage', 1, 0.0000001)
        playBGAnimation2('garage', 'idle', false, false)
        sundayFilter(false)
    end
end

function stepHit (step)

    if curStep == 1 then
    end

end
