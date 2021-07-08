function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'tordBG')

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

end

function stepHit (step)

    if curStep == 192 then
        setActorAlpha(0, 'bfBG')
        setActorAlpha(1, 'tordBG')
        changeDadCharacter('bf', 100, 400)
    end

    if curStep == 256 then
        changeBoyfriendCharacter('bf-gf', 1096, 271)
    end

    if curStep == 320 then
        setActorAlpha(1, 'bfBG')
        changeDadCharacter('tabi', 100, 0)
    end

    if curStep == 384 then
        changeBoyfriendCharacter('bf-exgf', 1000, -103)
    end

    if curStep == 448 then
        changeDadCharacter('pico', 100, 300)
    end

    if curStep == 480 then
        changeBoyfriendCharacter('cassandra', 1096, 0)
    end

    if curStep == 512 then
        changeDadCharacter('cj', 100, 0)
    end

    if curStep == 544 then
        changeBoyfriendCharacter('ruby', 1096, 0)
    end

    if curStep == 576 then
        changeDadCharacter('coco', 100, 0)
    end

    if curStep == 608 then
        changeBoyfriendCharacter('gura-amelia', 1096, 200)
    end

    if curStep == 640 then
        changeDadCharacter('tankman', 100, 180)
    end

    if curStep == 672 then
        changeBoyfriendCharacter('hd-senpai', 1096, 0)
    end

    if curStep == 120 or curStep == 248 or curStep == 375 or curStep == 632 or curStep == 696 or curStep == 824 or curStep == 952 or curStep == 1208 then
        for i = 0, 7 do
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i) + 360, 0.3, 'setDefault')
        end
    end
end
