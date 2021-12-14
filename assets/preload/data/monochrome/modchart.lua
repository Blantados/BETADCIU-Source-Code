function start (song)
    print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'eyes')
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

    if curStep == 256 or curStep == 512 or curStep == 640 or curStep == 1280 then
        startWriting(16, '')
    end

    if curStep == 896 or curStep == 928 or curStep == 1408 or curStep == 1440 then
        startWriting(8, '')
    end
    
    if curStep == 504 or curStep == 952 or curStep == 1116 or curStep == 1208 or curStep == 1536 then
        showOnlyStrums = true
        strumLine2Visible = false
        setActorAlpha(0, 'stageFront', true)
        setActorAlpha(0, 'dad')
        setActorAlpha(1, 'eyes')
        playBGAnimation2('eyes', 'crashDeath2', true, false)
        shakeCam(0.0125 * (1.625/2), 8 * crochet/1000)
        shakeHUD(0.0125 * (1.625/2), 8 * crochet/1000)
    end

    if curStep == 964 or curStep == 972 or curStep == 980 then
        showOnlyStrums = true
        strumLine2Visible = false
        setActorAlpha(0, 'stageFront', true)
        setActorAlpha(0, 'dad')
        setActorAlpha(1, 'eyes')
        playBGAnimation2('eyes', 'crashDeath2', true, false)
        shakeCam(0.0125 * (1.625/2), 4 * crochet/1000)
        shakeHUD(0.0125 * (1.625/2), 4 * crochet/1000)
    end

    if curStep == 512 or curStep == 960 or curStep == 968 or curStep == 976 or curStep == 984 or curStep == 1120 or curStep == 1216 or curStep == 1546 then
        showOnlyStrums = false
        strumLine2Visible = true
        setActorAlpha(0, 'eyes')
        setActorAlpha(1, 'dad')
        setActorAlpha(1, 'stageFront', true)
    end
end
