function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'wireBG', true)
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if l1 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
end

function beatHit (beat)

    if curBeat == 144 then
        setActorAlpha(0, 'gf')
        setActorAlpha(1, 'wireBG', true)
        changeDadCharacter('agoti-wire', 0, 200)
        changeBoyfriendCharacter('tabi-wire', 920, 100)
    end

    if curBeat == 204 then
        setActorAlpha(1, 'gf')
        setActorAlpha(0, 'wireBG', true)
        changeDadCharacter('agoti-glitcher', 0, 200)
        changeBoyfriendCharacter('tabi-glitcher', 920, 100)
    end

    if curBeat == 272 then
        setActorAlpha(0, 'gf')
        setActorAlpha(1, 'wireBG', true)
        changeDadCharacter('agoti-wire', 0, 200)
        changeBoyfriendCharacter('tabi-wire', 920, 100)
    end

    if curBeat == 332 then
        setActorAlpha(1, 'gf')
        setActorAlpha(0, 'wireBG', true)
        changeDadCharacter('agoti-glitcher', 0, 200)
        changeBoyfriendCharacter('tabi-glitcher', 920, 100)
    end

end

function stepHit (step)

    
end
