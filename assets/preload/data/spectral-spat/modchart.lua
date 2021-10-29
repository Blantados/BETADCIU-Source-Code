function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorX(-200, 'dad1')
    followDadXOffset = -50
    changeDadIcon('gar-spirit')
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

    if curBeat == 356 or curBeat == 364 then
        playActorAnimation('dad', 'idle', true, false)
    end

    if curBeat == 360 then
        playActorAnimation('dad1', 'idle', true, false)
    end
end

function stepHit (step)

    if curStep == 1152 then
        flashCam(255, 255, 255, 1.3)
    end
end

function dadNoteHit()

    if curStep >= 0 and curStep < 1152 or curStep >= 1408 then
        shakeCam(0.002, 0.3)
    end

    if curStep >= 1152 and curStep < 1408 then
        shakeCam(0.004, 0.3)
    end
    
end
