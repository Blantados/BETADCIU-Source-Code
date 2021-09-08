function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

local dadY = 0
local dadrockY = 0
local bfY = 0
local bfrockY = 0

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
        setActorY(dadY - 50 * math.cos((currentBeat * 0.25) * math.pi), 'dad')
        setActorY(dadrockY - 50 * math.cos((currentBeat * 0.25) * math.pi), 'dadrock')
        setActorY(bfY - 50 * math.cos((currentBeat * 0.25) * math.pi), 'boyfriend')
        setActorY(bfrockY - 50 * math.cos((currentBeat * 0.25) * math.pi), 'rock')
    end
end

function beatHit (beat)

end

function stepHit (step)
        
    if curStep == 1280 then
        inAndOutCam(0.5, 0.2, 0.5)
        playSound('cesarpower')
        playActorAnimation('boyfriend', 'transition', true, false)
    end

    if curStep == 1288 then
        changeBoyfriendCharacter('bf-demoncesar', 830, 400)
    end
end
