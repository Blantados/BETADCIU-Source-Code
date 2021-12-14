function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    characterZoom('gf', 0.9)
    setActorX(1050, 'gf')
    setActorY(280, 'gf')
    changeBFIcon('hd-senpai-dark')
    updateHealthbar('', 'FF000000')
    setActorAlpha(0, 'tv2', true)
   
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

    if curStep >= 784 then
        minusHealth(-2)
    end
end

function beatHit (beat)

end

function stepHit (step)

    if curStep == 1 then
        
    end

    if curStep == 528 then
        doStaticSign(0, false)
        changeStage('school-sad')
        isPixel(true)
        changeGFCharacter('nogf-pixel', 580, 430)
        changeDadCharacter('dad-pixel', 115, 160)
        changeBoyfriendCharacter('bf-senpai-pixel-angry', 970, 670)
        followDadXOffset = 50
        followDadYOffset = 50
    end

    if curStep == 784 then
        followDadXOffset = -250
        followBFXOffset = 150
        followBFYOffset = 100
        doStaticSign(0, false)
        changeStage('gfroom')
        changeGFCharacter('gf-nospeaker', 1050, 280)
        changeDadCharacter('dad-flipped', 770, 100)
        changeBoyfriendCharacter('senpai-z', -45, 280, 0.9, 0.9)
        setActorFlipX(true, 'dad')       
        setActorFlipX(false, 'boyfriend')
    end

    if curStep == 784 then
        changeBFIcon('dad')
        changeDadIcon('senpai')
        updateHealthbar('FFFFAA6F', 'FFAF66CE')
        isPixel(false)
        pixelStrums('bf', true)
    end

    if curStep == 785 then
        for i = 0,3 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'] + 700, 0.01, 'quartout')
        end
        for i = 4,7 do
            tweenXPsych(i, _G['defaultStrum'..i..'X'] - 600, 0.01, 'quartout')
        end
    end
end
