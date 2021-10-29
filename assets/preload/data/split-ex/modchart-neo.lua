function start (song)
	print("This is the stage switch Modchart")
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    hudX = getHudX()
    hudY = getHudY()
	
    if sway then
        camHudAngle = 1 * math.sin(currentBeat / 1.5)
        cameraAngle = -1 * math.sin(currentBeat / 1.5)
    end
    
    if agotiArrows then
        for i=0,7 do
        setActorY(defaultStrum0Y + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end

    if resetArrows then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'], i)
        setActorY(_G['defaultStrum'..i..'Y'], i)
        end
    end
end

function beatHit (beat)

end

function stepHit (step)

    --for tests and stuff
    if curStep == 1 then
       
    end

    if curStep == 146 then 
        changeStage('ITB')
        setBFStaticNotes('bf-b&b')
        changeGFCharacter('gf', 161, 60)
        changeDadCharacter('bluskys', -280, 190)
        changeBoyfriendCharacter('bf', 770, 450)
    end

    if curStep == 256 or  curStep == 1792 then
        changeStage('night');
        changeGFCharacter('gf-ex-night', 700, 80)
        changeDadCharacter('amor-ex', -270, 139)
        changeBoyfriendCharacter('bf-ex-night', 960, 430)     
    end

    if curStep == 272 then
        changeStage('arcade4')
        setBFStaticNotes('kapi')
        setupNoteSplash('-kapi')
        changeGFCharacter('gf-arcade', 400, 130)
        changeDadCharacter('kapi', 100, 100)
        changeBoyfriendCharacter('bf', 770, 450)       
    end

    if curStep == 400 then
        setupNoteSplash('')
        changeStage('studio-crash')
        setBFStaticNotes('normal')  
        changeGFCharacter('gf-nospeaker', 496, 306)
        changeDadCharacter('cyrix-crazy', 100, 100)
        changeBoyfriendCharacter('bf', 770, 450)   
        characterZoom('gf', 0.85)
    end

    if curStep == 528 then
        setupNoteSplash('-neon')
        changeStage('neopolis')
        changeGFCharacter('gf-pixel-neon', 580, 430) 
        changeDadCharacter('neon', 250, 460) 
        changeBoyfriendCharacter('bf-pixel-neon', 970, 670) 
    end

    if curStep == 592 then 
        setupNoteSplash('-void')
        followDadXOffset = 0
        changeStage('space')
        setBFStaticNotes('void')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('void', -440, 80)
        changeBoyfriendCharacter('bf', 770, 450)       
    end

    if curStep == 656 then
        setupNoteSplash('')
        changeStage('kbStreet')
        setBFStaticNotes('normal')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('kb', 30, 166)
        changeBoyfriendCharacter('bf', 810, 515)   
    end

    if curStep == 784 then 
        changeStage('limo');
        changeGFCharacter('gf-car', 400, 130)
        changeDadCharacter('mom-car', 100, 100)
        changeBoyfriendCharacter('bf-car', 1030, 200)  
    end

    if curStep == 912 then 
        changeStage('pillars')
        setBFStaticNotes('agoti')
        changeGFCharacter('gf-rock2', 400, -380)
        changeDadCharacter('agoti-mad', -50, 220)
        changeBoyfriendCharacter('bf-car', 870, 480) 
        agotiArrows = true
        sway = true
    end

    if curStep == 1170 then
        agotiArrows = false
        sway = false
        camHudAngle = 0
        cameraAngle = 0
        changeStage('room-space')
        setBFStaticNotes('normal')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('nonsense-god', -100, -50)
        changeBoyfriendCharacter('bf', 1100, 450)  
        resetArrows = true
    end

    if curStep == 1171 then
        resetArrows = false
    end

    if curStep == 1234 then
        changeStage('melonfarm')
        setBFStaticNotes('fever')  
        setupNoteSplash('-fever')
        changeDadCharacter('makocorrupt', -190, 0)
        changeBoyfriendCharacter('bf', 950, 450)  
        followBFXOffset = -75
        followDadXOffset = 75
        followDadYOffset = 20
    end

    if curStep == 1288 then
        followDadXOffset = 0
        followDadYOffset = 0
        followBFXOffset = 0
        changeStage('ballin');
        setBFStaticNotes('normal')
        setupNoteSplash('')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('hex', 100, 100)
        changeBoyfriendCharacter('bf', 770, 450)     
    end

    if curStep == 1426 then 
        changeStage('gamer')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('liz', 100, 400)
        changeBoyfriendCharacter('bf', 770, 450)
    end

    if curStep == 1490 then
        changeStage('ron');
        changeDadCharacter('little-man', 224, 744)
    end

    if curStep == 1552 then
        changeDadCharacter('ron', 73, 368)
    end

    if curStep == 1808 then
        changeStage('churchselever')
        setBFStaticNotes('normal')
        changeGFCharacter('gf', 250, -50)
        changeDadCharacter('selever', -50, 35)
        changeBoyfriendCharacter('bf', 770, 450)
    end

    if curStep == 1936 then
        changeStage('polus2')
        changeGFCharacter('gf-ghost', 206, -206.7)
        changeDadCharacter('impostor2', -169.55, 264.9)
        changeBoyfriendCharacter('bf-ghost', 751.7, 217.55)
    end

    if curStep == 2064 then
        changeStage('night');
        changeGFCharacter('gf-ex-night', 700, 80)
        changeDadCharacter('amor-ex', -270, 139)
        changeBoyfriendCharacter('bf-ex-night', 960, 430)    
        playActorAnimation('dad', 'drop', true, false)
    end

end
