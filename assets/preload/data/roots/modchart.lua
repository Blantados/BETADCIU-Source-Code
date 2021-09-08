function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    
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

    if curStep == 1152 then
        tweenFadeOutOneShot('boyfriend', 0, 22)
        tweenFadeOutOneShot('iconP1', 0, 22)
    end
end
