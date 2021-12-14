function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)

end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0
local floatShit = 0

local dadMidpointX = 0
local dadMidpointY = 0

local eyeX = 0
local eyeY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
  
end

function beatHit (beat)

end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then
       
    end

    if curStep == 190 then
        changeDadCharacter('exe-revie', 250, -200)
    end

    if curStep == 260 then
        changeBoyfriendCharacter('bf-sonic', 1140, 170)
    end

    if curStep == 320 then
        changeDadCharacter('haachama', 240, -60)
    end

    if curStep == 384 then
        changeBoyfriendCharacter('gura-amelia', 1290, 20)
    end

    if curStep == 446 then
        changeDadCharacter('freddy', 230, -190)
    end

    if curStep == 512 then
        changeBoyfriendCharacter('bf-cryingchild', 1320, 170)
    end

    if curStep == 576 then
        changeDadCharacter('cc', 240, -120)
        characterZoom('dad', 1.3)
    end

    if curStep == 704 then
        changeBoyfriendCharacter('oswald-angry', 1340, 80)
    end

    if curStep == 768 then
        changeDadCharacter('huggy', 240, -120)
        followDadXOffset = -200 
    end

    if curStep == 832 then
        changeBoyfriendCharacter('beebz', 1260, 70)
    end

    if curStep == 896 then
        changeDadCharacter('monster', 180, -90)
        followDadXOffset = 0
    end

    if curStep == 1024 then
        changeBoyfriendCharacter('spooky', 1290, 20)
    end

    if curStep == 1088 then
        changeDadCharacter('yuri-crazy', 250, -50)
    end
end