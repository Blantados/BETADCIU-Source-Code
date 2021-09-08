function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    changeDadIcon('spirit-glitch')

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

    if curBeat == 94 then
        inAndOutCam(0.5, 0.5, 0.5)
    end

    if curBeat == 96 then 
        changeDadCharacterBetter(250, 460, 'senpai-angry')
        changeDadIcon('senpai-glitch')
    end

    if curBeat == 144 then 
        changeDadCharacterBetter(250, 460, 'senpai-giddy')
        changeDadIcon('senpai-glitch')
    end

end

function stepHit (step)

end
