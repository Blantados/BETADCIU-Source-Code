function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorAlpha(0, 'limoOhNo')
    setActorAlpha(0, 'blantadBG')
    setActorAlpha(0, 'bgLimoOhNo')
    setActorAlpha(0, 'gfBG')

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0
local floatShit = 0

local dadMidpointX = 0
local dadMidpointY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

    dadMidpointX = getActorXMidpoint('dad')
    dadMidpointY = getActorYMidpoint('dad')

    if fastCamFollow then
        setCamFollow(dadMidpointX + 150, dadMidpointY - 100)
    end
end

function beatHit (beat)

    if curBeat == 127 then
        dadAltAnim = true
    end

    if curBeat == 128 then
        dadAltAnim = false
    end

    if curBeat == 159 then
        bfAltAnim = true
    end

    if curBeat == 160 then
        bfAltAnim = false
    end
end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then
        
    end

    if curStep == 318 then
        changeDadCharacter('edd2', 20, 50)
    end

    if curStep == 348 then   
        changeBoyfriendCharacter('matt2', 770, -150)
        followBFXOffset = 100
    end

    if curStep == 382 then
        changeDadCharacter('liz', 150, 400)
    end

    if curStep == 406 then
        followBFXOffset = 0
        changeBoyfriendCharacter('lane', 1030, 150)
    end

    if curStep == 442 then
        changeDadCharacter('mackiepom', 100, 70)
    end

    if curStep == 570 then
        changeBoyfriendCharacter('cj-ruby', 1030, -150)
    end

    if curStep == 688 then
        changeDadCharacter('starecrown', -40, 70)
        changeBoyfriendCharacter('zardy', 870, -150)
    end

    if curStep == 704 then
        changeDadCharacter('bf-sans', 150, 450)
    end

    if curStep == 736 then
        changeBoyfriendCharacter('bf-frisk', 970, 200)
    end

    if curStep == 768 then
        changeDadCharacter('garcello', 50, 90)
    end

    if curStep == 800 then
        changeBoyfriendCharacter('bf-annie', 930, 200)
    end

    if curStep == 816 then
        changeDadCharacter('mario', 140, 300)
        changeBoyfriendCharacter('bf-sonic', 930, 200)
        followBFXOffset = 100
    end

    if curStep == 832 then
        changeDadCharacter('exgf', 150, 100)
    end

    if curStep == 896 then
        followBFXOffset = 0
        changeBoyfriendCharacter('sky-happy', 1070, 100)
    end

    if curStep == 958 then
        changeDadCharacter('kou', 150, 370)
        followDadYOffset = 50
    end
    
    if curStep == 988 then
        changeBoyfriendCharacter('miku', 1020, -130)
    end

    if curStep == 1022 then
        followDadYOffset = 0
        changeDadCharacter('cg5', 150, 120)
    end

    if curStep == 1046 then
        changeBoyfriendCharacter('blantad-watch', 1000, -120)
    end

    if curStep == 1072 then
        setActorAlpha(1, 'limoOhNo')
        setActorAlpha(0, 'limo')
        setActorAlpha(1, 'bgLimoOhNo')
        setActorAlpha(0, 'bgLimo')
        changeGFCharacter('holo-cart-ohno', 357, 99)
        changeBoyfriendCharacter('blantad-handscutscene', 850, -130) 
        playSound('eyeglow')
        playActorAnimation('boyfriend', 'warning-special', true, false)
        playBGAnimation2('limoOhNo', 'drive', true, false)      
        setActorAlpha(1, 'gfBG')
    end

    if curStep == 1082 then      
        changeDadCharacter('kapi', 150, 50)
        setActorAngle(-6, 'dad')
    end

     -- this is just for all the getActorY stuff
     if curStep == 1088 then 
        limoX = getActorX('limoOhNo')
        limoY = getActorY('limoOhNo')
        dadX = getActorX('dad')
        dadY = getActorY('dad')
        bfX = getActorX('boyfriend')
        bfY = getActorY('boyfriend')  
        gfX = getActorX('gf')
        gfY = getActorY('gf')
        bgLimoX = getActorX('bgLimoOhNo')
        bgLimoY = getActorY('bgLimoOhNo')
        -- idk how to handle flxgroups so the dancers are hardcoded
    end
    
    if curStep == 1088 then
        setDefaultCamZoom(0.77)
        changeGFCharacter('holo-cart-hover', 357, 99)
        playActorAnimation('boyfriend', 'lift-special', true, false)
        playBGAnimation2('limoOhNo', 'driveFlying', true, false)  
        tweenPosQuad('bgLimoOhNo', bgLimoX, bgLimoY - 3800, 1)     
        tweenPosQuad('limoOhNo', limoX, limoY - 9500, 1)
        tweenPosQuad('gf', gfX, gfY - 9100, 1)
        tweenPosQuad('dad', dadX, dadY - 9500, 1)
        tweenPosQuad('boyfriend', bfX, bfY - 9500, 1)
        moveHoloDancers('doinks');
        playSound('whoosh')
        setActorVelocityX(5, 'upperSky')
        setActorVelocityX(5, 'upperSky2')
        fastCamFollow = true
    end

    if curStep == 1100 then
        fastCamFollow = false
        playActorAnimation('boyfriend', 'idle', true, false)
    end

    if curStep == 1108 then 
        resetCamEffects('dad')
    end

    if curStep == 1140 then
        changeBoyfriendCharacter('blantad-teleport', 30, -10320)
        playActorAnimation('boyfriend', 'tele-special', true, false)
        playSound('teleport')
    end
    
    if curStep == 1148 then  
        setActorAlpha(1, 'blantadBG')
        playActorAnimation('blantadBG', 'tele', true, false)
        playSound('teleport')
        changeBoyfriendCharacter('snow', 1000, -9520)
        followBFXOffset = -50
    end

    if curStep == 1210 then      
        changeDadCharacter('bob2', 140, -9350)
    end

    if curStep == 1276 then
        followBFXOffset = 0
        changeBoyfriendCharacter('bosip', 970, -9700)
    end

    if curStep == 1328 then
        changeDadCharacter('bf-mom-car', 140, -9400)
        changeBoyfriendCharacter('bf-dad', 930, -9650)
        followBFXOffset = -50
    end

    if curStep == 1344 then      
        changeDadCharacter('hd-monika', 140, -9400)
    end

    if curStep == 1376 then
        changeBoyfriendCharacter('hd-senpai-happy', 970, -9650)
    end

    if curStep == 1408 then      
        changeDadCharacter('rosie', 80, -9300)
    end

    if curStep == 1440 then
        changeBoyfriendCharacter('pico', 970, -9350)
        followBFXOffset = -120
    end

    if curStep == 1470 then      
        changeDadCharacter('kkslider', 140, -9100)
    end

    if curStep == 1500 then
        followBFXOffset = 0
        changeBoyfriendCharacter('beardington', 970, -9400) 
    end

    if curStep == 1534 then      
        changeDadCharacter('steve', 140, -9300)
    end

    if curStep == 1558 then
        changeBoyfriendCharacter('noke', 970, -9650)
    end

    if curStep == 1610 then
        changeDadCharacter('hex', 140, -9420)
        changeBoyfriendCharacter('cyrix', 930, -9650)
    end

    if curStep == 1676 then
        changeDadCharacter('anchor-bowl', -150, -9400)
        changeBoyfriendCharacter('alya', 940, -9310)
    end

    if curStep == 1738 then
        changeDadCharacter('updike', 130, -9400)
        changeBoyfriendCharacter('whitty', 920, -9650)
        followBFXOffset = -100
    end

    if curStep == 1804 then  
        changeDadCharacter('mel', 140, -9400)
        changeBoyfriendCharacter('bana', 930, -9600)    
        followBFXOffset = -200 
    end

    if curStep == 1856 then
        changeDadCharacter('sarvente', 140, -9400)
        changeBoyfriendCharacter('ruv', 970, -9750)
        followBFXOffset = -100 
    end

    if curStep == 1872 then      
        changeDadCharacter('momi', 50, -9350)
    end

    if curStep == 1936 then
        followBFXOffset = 0
        changeBoyfriendCharacter('sunday', 930, -9400)
    end

    if curStep == 2000 then
        changeDadCharacter('bf-kaity-car', 140, -9100)
        changeBoyfriendCharacter('bf-car', 930, -9300)
        characterZoom('dad', 1.25)
    end

    if curStep == 2064 then
        changeDadCharacter('tankman', 140, -9220)
        changeBoyfriendCharacter('phil', 930, -9300)
    end

    if curStep == 2224 then
        playActorAnimation('dad', 'idle', true, false)
    end

end








