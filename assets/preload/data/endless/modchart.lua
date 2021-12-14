function start (song)
    print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
end

local defaultHudX = 0
local defaultHudY = 0

local tvX = 0
local tvY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

--default positions
-- changeBoyfriendCharacter('bf', 970, 350)
-- changeDadCharacter('dad', -70, 90)

local dadY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

    if fly then
        setActorY(dadY + 50 * math.cos((currentBeat * 0.60) * math.pi), 'dad')
    end
end

function beatHit (beat)

end

function stepHit (step)

    if curStep == 1 then --for testing
       
    end

    if curStep == 900 then -- da changing notes
        setupNoteSplash('-maijin')
        changeStaticNotes('maijin', 'maijin')
    end 

    if curStep >= 256 and curStep < 1664 then
        if curStep % 64 == 16 or curStep % 64 == 20 then
            for i = 0,7 do
                setActorAngle(0, i)
                tweenAnglePsych(i, 360, 0.2, 'quintout') 
            end
        end
    end

    --[[if curStep == 272 or curStep == 276 or curStep == 336 or curStep == 340 or curStep == 400 or curStep == 404 or curStep == 464 or curStep == 468 or curStep == 528 or curStep == 532 then -- da spins 1
        for i = 0,7 do
            setActorAngle(0, i)
            tweenAnglePsych(i, 360, 0.2, 'quintout') 
        end
    end

    if curStep == 592 or curStep == 596 or curStep == 656 or curStep == 660 or curStep == 720 or curStep == 724 or curStep == 784 or curStep == 788 or curStep == 848 or curStep == 852 then -- da spins 2
        for i = 0,7 do
            setActorAngle(0, i)
            tweenAnglePsych(i, 360, 0.2, 'quintout') 
        end
    end  

    if curStep == 912 or curStep == 916 or curStep == 976 or curStep == 980 or curStep == 1040 or curStep == 1044 or curStep == 1104 or curStep == 1108 or curStep == 1160 or curStep == 1164 then -- da spins part 3
        for i = 0,7 do
            setActorAngle(0, i)
            tweenAnglePsych(i, 360, 0.2, 'quintout') 
        end
    end  ]]--
end

function dadNoteHit()

end
