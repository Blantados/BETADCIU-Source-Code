function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

local dadX = 0
local dadrockX = 0
local bfX = 0
local bfrockX = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if l1 then
        for i=0,3 do
        setActorX(_G['defaultStrum'..i..'X'] + 100 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 64 * math.cos((currentBeat * 0.35) * math.pi), i)
        end
        for i=4,7 do
        setActorX(_G['defaultStrum'..i..'X'] - 100 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 64 * math.cos((currentBeat * 0.35) * math.pi), i)
        end
    end
    if moveRocks then
        setActorY(dadX - 50 * math.cos((currentBeat * 0.25) * math.pi), 'dad')
        setActorY(dadrockX - 50 * math.cos((currentBeat * 0.25) * math.pi), 'dadrock')
        setActorY(bfX - 50 * math.cos((currentBeat * 0.25) * math.pi), 'boyfriend')
        setActorY(bfrockX - 50 * math.cos((currentBeat * 0.25) * math.pi), 'rock')
    end
end

function beatHit (beat)

end

function stepHit (step)

    if curStep == 1024 then
        l1 = true

    end
    if curStep == 1025 then
        moveRocks = true
    end
end
