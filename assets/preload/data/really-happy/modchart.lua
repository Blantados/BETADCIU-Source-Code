function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorAlpha(0, 'blackScreen')
    setActorAlpha(0, 'eyes')
    setActorAlpha(0, 'eyes2')
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
  
    if cameraShake then
        shakeCam(0.01, 0.01)
        shakeHUD(0.01, 0.01)
    end

    if laughShake then
        shakeCam(0.025, 0.01)
        shakeHUD(0.025, 0.01)
    end
end

function beatHit (beat)

    if curBeat % 2 == 0 then
        eyeX = generateNumberFromRange(-8, 5)
        eyeY = generateNumberFromRange(-8, 5)
        setActorX(eyeX, 'eyes2')
        setActorY(eyeY, 'eyes2')
    end

    if curBeat > 240 and curBeat % 4 == 4 then
        setCamZoom(0.95)
    end

    if curBeat > 240 and curBeat % 4 == 3 then
        setCamZoom(0.92)
    end
   
end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then

    end

    if curStep == 384 then
        cameraShake = true
    end

    if curStep == 512 then
        cameraShake = false
    end

    if curStep == 652 or curStep == 668 or curStep == 684 or curStep == 700 or curStep == 716 or curStep == 732 or curStep == 748 or curStep == 764 then
        laughShake = true
    end

    if curStep == 656 or curStep == 672 or curStep == 688 or curStep == 704 or curStep == 720 or curStep == 736 or curStep == 752 or curStep == 768 then
        laughShake = false
    end

    if curStep == 960 then
        setDefaultCamZoom(1)
        setActorAlpha(1, 'blackScreen')   
        tweenFadeIn('eyes', 0.3, 0.000000000001) --setActorAlpha was not being nice
        tweenFadeIn('eyes2', 0.3, 0.000000000001)
        showOnlyStrums = true
        strumLine1Visible = false
        strumLine2Visible = false
    end
end

function dadNoteHit()
    playActorAnimation('gf', 'scared', false, false)
end








