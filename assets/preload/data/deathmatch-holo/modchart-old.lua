function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorAlpha(0, 'bg2', true)
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

    if curBeat % 32 == 16 then
        tweenFadeInAndOut('bg2', 2, 6, 2, true)
    end

    if curBeat == 192 then
        changeBoyfriendCharacterBetter(820, 350, 'botan')
        flashCam(255,255,255,1)
    end

    if curBeat == 256 then
        changeBoyfriendCharacter('gura-amelia-walfie', 770, 300)
        flashCam(255,255,255,1)
    end

    if curBeat == 352 then
        changeDadCharacter('calli-sad', 100, 100)
        changeBoyfriendCharacter('coco', 770, 70)
        flashCam(255,255,255,1)
    end

    if curBeat == 416 then   
        changeBoyfriendCharacterBetter(770, 450, 'bf-aloe-corrupt')
        flashCam(255,255,255,1)
    end

    if curBeat == 512 then  
        flashCam(255,255,255,1)
        changeDadCharacter('calli-mad', 100, 100)  
    end

    if curBeat == 544 then  
        changeDadCharacter('calli-sad', 100, 100)          
        flashCam(255,255,255,1)
    end

end

function stepHit (step)


end

function dadNoteHit()

    if curBeat < 352 then
        minusHealth(0.02)
    end

    if curBeat >= 512 and curBeat < 544 then
        minusHealth(0.04)
    end
end
