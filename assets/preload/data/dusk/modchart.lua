function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

local dadX = 0
local dadY = 0
local boyfriendX = 0
local boyfriendY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
end

function beatHit (beat)

    if curBeat == 128 or curBeat == 256 then
        changeDadCharacter('b3-mom-mad', 100, 100)
    end

    if curBeat == 224 or curBeat == 276  then
        changeDadCharacter('b3-mom-sad', 100, 100)
    end

end

function stepHit (step)

end
