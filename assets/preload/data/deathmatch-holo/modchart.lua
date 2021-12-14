function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    showOnlyStrums = true
    newIcons = true
    changeStaticNotes('1930')
end

local defaultHudX = 0
local defaultHudY = 0

local tvX = 0
local tvY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

    if curBeat == 28 then
        flashCam(255,255,255,1)
        changeStage('holostage-corrupt')
        setActorAlpha(0, 'bg2', true)
        showOnlyStrums = false
        changeGFCharacter('gf-nene-corrupt', 400, 130)
        changeDadCharacter('calli-mad', 100, 100)  
        changeBoyfriendCharacter('bf-aloe-corrupt', 770, 450)
        shakeCam(0.08, 0.5)
    end

    if curBeat % 32 == 16 and curBeat > 28 then
        tweenFadeInAndOut('bg2', 2, 6, 2, true)
    end

    if curBeat == 64 then
        followDadXOffset = 50
        followDadYOffset = 50
        setDefaultCamZoom(0.6)
    end

    if curBeat == 192 then
        changeBoyfriendCharacterBetter(820, 350, 'botan-corrupt')
        flashCam(255,255,255,1)
    end

    if curBeat == 256 then
        changeBoyfriendCharacter('gura-amelia-corrupt', 770, 300)
        flashCam(255,255,255,1)
    end

    if curBeat == 352 then
        followBFYOffset = 100
        followBFXOffset = 20
        changeDadCharacter('calli-sad', 100, 100)
        changeBoyfriendCharacter('coco-corrupt', 780, 70)
        flashCam(255,255,255,1)
    end

    if curBeat == 384 then
        changeDadCharacter('calli-mad', 100, 100)  
        flashCam(255,255,255,1)
    end

    if curBeat == 416 then   
        followBFYOffset = 0
        followBFXOffset = 0
        changeDadCharacter('calli-sad2', 100, 100)
        changeBoyfriendCharacterBetter(770, 450, 'bf-aloe-corrupt')
        flashCam(255,255,255,1)
    end

    if curBeat == 576 then  
        flashCam(255,255,255,1)
        changeDadCharacter('calli-mad', 100, 100)  
    end

    if curBeat == 608 then  
        changeDadCharacter('calli-sad3', 100, 100)        
        flashCam(255,255,255,1)
    end

end

function stepHit (step)


end

function dadNoteHit()

    if curBeat < 352 then
        minusHealth(0.02)
    end

    if curBeat >= 384 and curBeat < 416 or curBeat >= 576 and curBeat < 608 then
        minusHealth(0.04)
    end
end
