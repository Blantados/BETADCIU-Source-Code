function start (song)
	print("Song then " .. song .. " @ " .. bpm .. " downscroll then " .. downscroll) 
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

    for i = 2,2 do
        setActorAlpha(0, i)
    end
end

function beatHit (beat)

    -- not this time

end

function stepHit (step)

    if curStep == 1 then
        --setDefaultCamZoom(1.1)
    end

    if curStep == 1040 or curStep == 4111  then
        setDefaultCamZoom(0.9)
        changeDadCharacter('beast-sonic', -180, 5.25)
        changeBoyfriendCharacter('bf-sonic', 566, 435)
        followDadXOffset = 100
    end

    if curStep == 1296 then
        setDefaultCamZoom(1.1)
        changeDadCharacter('maijin-new-flipped', 1255, 225)
        changeBoyfriendCharacter('bf-sonic-flipped', 466, 385)
        setActorFlipX(true, 'boyfriend')
        setActorFlipX(true, 'dad')
        for i = 0,4 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'] + 700, 0.1, 'quartout')
        end
        for i = 5,9 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'] - 600, 0.1, 'quartout')
        end
        followBFXOffset = 300
        followDadXOffset = -200
    end

    if curStep == 2320 then
        setDefaultCamZoom(0.9)
        changeDadCharacter('beast-sonic-flipped', 1050, 5.25)
        changeBoyfriendCharacter('bf-sonic-flipped', 66, 435)
        setActorFlipX(true, 'boyfriend')
        setActorFlipX(true, 'dad')
        followBFXOffset = 400
        followDadXOffset = -450
    end

    if curStep == 2823 then
        followBFXOffset = 0
        followDadXOffset = -250
        setDefaultCamZoom(1)
        for i = 0,4 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'], 0.1, 'quartout')
        end
        for i = 5,9 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'], 0.1, 'quartout')
        end
        changeDadCharacter('lord-x', -180, 100)
        changeBoyfriendCharacter('bf-sonic', 666, 435)
    end

end
