function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    followDadYOffset = 50
    followBFYOffset = 70
    followBFXOffset = -30
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

    if curStep == 1 then
        
    end

    if curStep == 176 then
        followDadXOffset = 20
        followDadYOffset = 0
        changeDadCharacter('monster', 220, 200)
    end

    if curStep == 240 then
        followDadXOffset = 0
        followBFXOffset = 100
        followBFYOffset = 100
        changeDadCharacter('senpaighosty', 240, 130)
        changeBoyfriendCharacter('monika-real', 860, 130)
        characterZoom('dad', 0.9)
        characterZoom('boyfriend', 0.8)
    end

    if curStep == 304 then
        changeDadCharacter('exe', 350, 260)
    end

    if curStep == 368 then
        followBFXOffset = 0
        followBFYOffset = 50
        changeBoyfriendCharacter('sunky', 720, 210)
    end

    if curStep == 432 then
        followDadXOffset = -50
        followDadYOffset = 50
        changeDadCharacter('happymouse', 180, 185)
        characterZoom('dad', 0.9)
    end

    if curStep == 492 then
        changeDadCharacter('happymouse2', 180, 185)
        characterZoom('dad', 0.9)
    end

    if curStep == 496 then
        changeBoyfriendCharacter('mokey', 930, 100)
    end

    if curStep == 560 then
        followDadXOffset = -50
        followDadYOffset = 100
        followBFXOffset = 50
        followBFYOffset = 0
        changeDadCharacter('freddy', 320, 130)
        characterZoom('dad', 0.9)
        changeBoyfriendCharacter('geese-minus', 900, 180)
        characterZoom('boyfriend', 0.9)
    end

    if curStep == 688 then
        followDadXOffset = -230
        followDadYOffset = 50
        changeDadCharacter('herobrine', 350, 200)
    end

    if curStep == 752 then
        followBFXOffset = 0
        followBFYOffset = 50
        changeBoyfriendCharacter('steve', 980, 250)
        characterZoom('boyfriend', 0.9)
    end

    if curStep == 816 then
        followDadXOffset = 0
        followDadYOffset = 50
        changeDadCharacter('zardy', 50, 110)
        characterZoom('dad', 0.9)
    end

    if curStep == 875 then
        tweenFadeOutOneShot('dad', 0, 0.2)
    end

    if curStep == 880 then
        changeDadCharacter('cablecrow', 35, -15)
        characterZoom('dad', 0.9)
        setActorAlpha(0, 'dad')
        tweenFadeIn('dad', 1, 0.2)
    end

    if curStep == 944 then
        followBFXOffset = -50
        changeDadCharacter('haachama', 260, 200)
        changeBoyfriendCharacter('bf-nene', 970, 380)
    end
end
