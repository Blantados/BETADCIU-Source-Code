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

    if curBeat >= 224 and curBeat < 256 then
        setGFAltAnim('-alt')
        setActorAlpha(0, 'headlight')
        playBGAnimation('fac_bg', 'shitfartflip', true, false)
    end

    if curBeat == 256 then
        setGFAltAnim('')
        setActorAlpha(1, 'headlight')
        playBGAnimation('fac_bg', 'shitfart', true, false)
    end 

end

function stepHit (step)


end
