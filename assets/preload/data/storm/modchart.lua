function start (song)
	print("Song then " .. song .. " @ " .. bpm .. " downscroll then " .. downscroll) 
    newIcons = true
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

    -- not this time

end

function stepHit (step)

    if curStep == 1 then

    end

    if curStep == 128 then
		changeDadCharacterBetter(0, 100, 'whitty-bw')
		changeGFCharacterBetter (400, 130, 'gf-ruv-bw')
    end

    if curStep == 192 then
        changeBoyfriendCharacterBetter(870, 100, 'hex-bw')
    end

    if curStep == 248 then 
        playActorAnimation('boyfriend', 'wink', true)
    end

    if curStep == 256 then
        playActorAnimation('boyfriend', 'idle', true)
    end

    if curStep == 258 then		
        changeDadCharacterBetter(-300, 100, 'roro-bw')
        changeGFCharacterBetter (400, 30, 'gf-alya-bw')
    end

    if curStep == 322 then
        changeBoyfriendCharacterBetter(870, 50, 'anchor-bw')
    end

    if curStep == 386 then     
        changeDadCharacterBetter(0, 300, 'gura-amelia-bw')
        changeGFCharacterBetter (400, 130, 'gf-nene-bw')
    end

    if curStep == 450 then
        changeBoyfriendCharacterBetter(870, 450, 'bf-aloe-bw')
    end

    if curStep == 514 then 
        changeDadCharacterBetter(0, 150, 'hd-senpai-giddy-bw')
        changeGFCharacterBetter (400, 130, 'gf-monika-bw')
    end

    if curStep == 578 then
        changeBoyfriendCharacterBetter(870, 350, 'tankman-bw')
    end

    if curStep == 642 then   
        changeDadCharacterBetter(0, 125, 'cassandra-bw')
        changeGFCharacterBetter (400, 130, 'gf-pico-bw')
    end

    if curStep == 682 then
        changeBoyfriendCharacterBetter(870, 375, 'nene-bw')
    end

    if curStep == 746 then
        changeGFCharacterBetter (400, 130, 'gf-cassandra-bw')
        changeDadCharacterBetter(0, 400, 'pico-bw')
    end
end
