function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
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

    if curStep == 464 then
        flashCam(255, 255, 255, 2)
        playSound('thunder_1')
        changeDadCharacter('opheebop', 100, 200)
    end

    if curStep == 590 then
        flashCam(255, 255, 255, 2)
        playSound('thunder_2')
        changeBoyfriendCharacter('pumpkinpie', 870, 200)
    end

    if curStep == 752 then
        flashCam(255, 255, 255, 2)
        playSound('thunder_1')
        changeDadCharacter('crazygf', 100, 350)
    end
    
end
