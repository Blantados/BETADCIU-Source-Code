function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
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

    if curStep == 336 then
        playActorAnimation('dad', 'idle', true, false)
    end

    if curStep == 464 then
        playActorAnimation('boyfriend', 'idle', true, false)
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        changeDadCharacter('opheebop', 100, 200)
    end

    if curStep == 590 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('pumpkinpie', 920, 250)
    end

    if curStep == 752 then
        playActorAnimation('boyfriend', 'idle', true, false)
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        changeDadCharacter('crazygf', 100, 350)
    end

    if curStep == 878 then
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('drunk-annie', 770, 150)
        characterZoom('boyfriend', 1.2)
        followBFYOffset = -50
    end

    if curStep == 1008 then
        playActorAnimation('boyfriend', 'idle', true, false)
        flashCam(255, 255, 255, 2)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_1')
        changeDadCharacter('taki', 50, 100)
    end

    if curStep == 1136 then
        followBFYOffset = 0
        flashCam(255, 255, 255, 2)
        characterZoom('boyfriend', 1)
        playBGAnimation('halloweenBG', 'lightning', true, false)
        playSound('thunder_2')
        changeBoyfriendCharacter('piconjo', 870, 300)        
    end 
end
