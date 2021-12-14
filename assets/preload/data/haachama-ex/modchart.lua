function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)  
    setActorAlpha(0, 'dad1')
    setActorAlpha(0, 'boyfriend1')
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

    if curStep == 120 or curStep == 688 then
        setDefaultCamZoom(1.25)
    end

    if curStep == 248 or curStep == 704 then
        setDefaultCamZoom(1.05)
    end

    if curStep == 384 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        changeDadCharacter('opheebop', 100, 200)
    end

    if curStep == 512 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('pumpkinpie', 920, 250)
    end

    if curStep == 640 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        changeDadCharacter('crazygf', 100, 350)
    end

    if curStep == 766 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('drunk-annie', 770, 150)
        characterZoom('boyfriend', 1.2)
        followBFYOffset = -50
    end

    if curStep == 896 then
        setDefaultCamZoom(0.9)
        flashCam(255, 255, 255, 2)
        playSound('thunder_2')
        changeDad1Character('amor-ex', 500, 170)
        characterZoom('dad1', 0.9)
    end

    if curStep == 896 then
        newIcons = true
        swapIcons = false
        changeDadCharacter('crazygf', 100, 350)   
        changeDadIconNew('crazygf-amor') 
        followDadXOffset = 200 
    end

    if curStep == 928 then
        flashCam(255, 255, 255, 2)
        followDadXOffset = 100
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        
    end

    if curStep == 928 then
        changeDadCharacter('taki', 50, 100)
        fixTrail('dadTrail')
        fixTrail('dad1Trail')
        changeDadIconNew('taki-amor')
    end

    if curStep == 1056 then
        setActorAlpha(0, 'dad1')
        changeBoyfriend1Character('amor-ex', 550, 170)
        characterZoom('boyfriend1', 0.9)
    end

    if curStep == 1056 then
        followBFXOffset = -200
        followBFYOffset = 0
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('piconjo', 870, 300)    
        changeBFIconNew('piconjo-amor')
        changeDadIconNew('taki') 
        fixTrail('bfTrail')
        fixTrail('bf1Trail')
        resetTrail('dad1Trail')
    end 

    if curStep == 1184 then
        setActorAlpha(1, 'dad1')
        setActorAlpha(0, 'boyfriend1')
        setActorX(550, 'dad1')
        playActorAnimation('dad1', 'drop', true, false, 11)
        changeBFIconNew('piconjo')
        resetTrail('bf1Trail')
    end

    if curStep >= 1184 then
        resetTrail('dad1Trail')
    end
 
end
