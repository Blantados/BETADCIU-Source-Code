function start (song)
	print("This is the no switch Modchart")
    
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

end

function stepHit (step)

    --leaving this here for testing purposes
    if curStep == 1 then
        
    end

    if curStep == 146 then
        changeDadCharacter('bluskys', -270, 200)
        characterZoom('dad', 1.05)
    end

    if curStep == 256 then
        changeDadCharacter('amor-ex', -270, 139)
    end

    if curStep == 272 then
        changeDadCharacter('kapi', -270, 120)
    end

    if curStep == 400 then
        changeDadCharacter('cyrix-crazy', -270, 139)
        characterZoom('dad', 1.01)
    end

    if curStep == 528 then
        changeDadCharacter('neon', -120, 439) 
        followDadXOffset = 200
    end

    if curStep == 592 then
        followDadXOffset = 0
        changeDadCharacter('void', -570, 139)
    end

    if curStep == 656 then
        followDadXOffset = 200
        changeDadCharacter('kb', -420, 109)
    end

    if curStep == 784 then 
        followDadXOffset = 0
        changeDadCharacter('mom', -250, 139)
    end

    if curStep == 912 then 
        changeDadCharacter('agoti-mad', -370, 269)
        characterZoom('dad', 0.9)
    end

    if curStep == 1170 then
        changeDadCharacter('nonsense-god', -320, 139)
    end

    if curStep == 1234 then
        changeDadCharacter('makocorrupt', -570, -139)
    end

    if curStep == 1288 then
        changeDadCharacter('hex', -270, 139)
    end

    if curStep == 1426 then 
        changeDadCharacter('liz', -270, 439)
        characterZoom('dad', 1.05)
    end

    if curStep == 1490 then
        changeDadCharacter('little-man', 240, 529)
    end

    if curStep == 1552 then
        changeDadCharacter('ron', -270, 339)
    end

    if curStep == 1792 then
        changeDadCharacter('amor-ex', -270, 139)
    end

    if curStep == 1808 then
        changeDadCharacter('selever', -320, 89)
    end

    if curStep == 1936 then
        changeDadCharacter('impostor2', -370, 529)
        characterZoom('dad', 1.02)
    end

    if curStep == 2064 then
        changeDadCharacter('amor-ex', -270, 139)
        playActorAnimation('dad', 'drop', true, false)
    end
end
