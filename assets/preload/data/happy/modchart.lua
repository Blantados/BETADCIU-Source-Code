function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    followDadXOffset = -75
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0
local floatShit = 0

local dadMidpointX = 0
local dadMidpointY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

    if cameraShake then
        shakeCam(0.01, 0.01)
        shakeHUD(0.01, 0.01)
    end

    if laughShake then
        shakeCam(0.005, 0.01)
    end
end

function beatHit (beat)

end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then

    end

    if curStep >= 432 and curStep < 448 then
        setDefaultCamZoom(1.1)
    end

    if curStep == 440 then
        laughShake = true
        flashCam(125, 125, 125, 2)
    end
    
    if curStep == 448 then
        laughShake = false
        cameraShake = true
        setDefaultCamZoom(0.9)    
    end

    if curStep == 704 then
        cameraShake = false
    end
end

function dadNoteHit()

    if curStep >= 444 and curStep < 448 then
       -- addCamZoom(0.2)
        --addHudZoom(0.2)
    end
end








