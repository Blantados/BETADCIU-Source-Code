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

    if curStep == 460 then
        playActorAnimation('gf', 'cheer', true, false)
    end
end
