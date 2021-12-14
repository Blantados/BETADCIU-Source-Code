function start (song)
    print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorAlpha(0, 'dad1')
    setActorAlpha(0, 'popup', true)
    setActorY(170, 'boyfriend')
    setActorX(920, 'boyfriend')
    followBFXOffset = -50
    followDadXOffset = 50
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

    if curBeat == 648 then --for testing
        setActorAlpha(1, 'popup', true)
        playBGAnimation('popup', 'idle', true, false)
    end

    if curBeat == 776 then
        playActorAnimation('dad1', 'lastNOTE', true, false)
    end

end

function stepHit (step)

    if curStep == 1 then --for testing

    end

    if curStep == 96 then
        setActorAlpha(1, 'dad1')
        changeDadCharacter('yuri', -40, 100)
    end

    if curStep == 128 then
        changeBoyfriendCharacter('natsuki', 830, 265)
    end

    if curStep == 160 then
        flashCam(255,255,255, 1)
        isPixel(true)
        setActorAlpha(0, 'dad1')
        changeStaticNotes('doki-pixel')
        changeStage('school-monika-finale')
        changeDadCharacter('monika-finale', 415, 390)
        changeBoyfriendCharacter('bf-senpai-pixel-angry', 970, 710)
    end

    if curStep == 288 then
        flashCam(255,255,255, 1)
        isPixel(false)
        setActorAlpha(1, 'dad1')
        changeStaticNotes('doki')
        changeStage('clubroomevil')
        changeDadCharacter('pico', -105, 390)
        changeBoyfriendCharacter('bf-hd-senpai-angry', 800, 90)
        playActorAnimation('boyfriend', 'idle', true, false)
        setActorAlpha(0, 'popup', true)
    end

    if curStep == 320 then
        changeBoyfriendCharacter('tankman', 860, 280)
    end

    if curStep == 352 then
        changeBoyfriendCharacter('snow', 920, 210)
        changeDadCharacter('mara', -10, 110)
        characterZoom('dad', 1.2)
    end

    if curStep == 416 then
        changeDadCharacter('bf-sans-new', -160, 330)  
    end

    if curStep == 480 then
        changeBoyfriendCharacter('chara', 870, 405)
    end

    if curStep == 544 then
        changeDadCharacter('abby-mad', -180, 370)
       
    end

    if curStep == 608 then
        changeBoyfriendCharacter('lucian', 880, 35)
    end

    if curStep == 672 then
        changeDadCharacter('shaggy', -40, 100)
        changeBoyfriendCharacter('bf', 870, 450)
    end

    if curStep == 832 then
        changeDadCharacter('dad', -70, 100)
    end

    if curStep == 864 then
        changeBoyfriendCharacter('mom', 880, 80)
    end

    if curStep == 896 then
        changeDadCharacter('spooky', -100, 300)
    end

    if curStep == 928 then
        changeDadCharacter('geese-fly', -60, 100)
        changeBoyfriendCharacter('bf-sticky', 860, 450)
        fly = true
        dadY = 100
    end

    if curStep == 1056 then
        changeBoyfriendCharacter('bf-cesar', 905, 400)
    end

    if curStep == 1088 then
        fly = false
        changeDadCharacter('amor', -70, 120)
        characterZoom('dad', 0.9)
    end

    if curStep == 1312 then
        changeDadCharacter('bob2', 10, 160)
    end

    if curStep == 1376 then
        changeBoyfriendCharacter('bosip', 900, 60)
    end

    if curStep == 1440 then
        changeDadCharacter('cerbera', -100, 520) 
    end

    if curStep == 1504 then
        changeBoyfriendCharacter('richard1', 650, 70)
    end

    if curStep == 1568 then
        changeDadCharacter('nonsense', 30, 200)
        changeBoyfriendCharacter('tails', 770, 260)
    end

    if curStep == 1696 then
        changeDadCharacter('flexy', -50, 420)
    end

    if curStep == 1728 then
        changeBoyfriendCharacter('omega-angry', 770, 105)
    end

    if curStep == 1760 then
        changeDadCharacter('retro', -70, 30)
    end

    if curStep == 1792 then
        changeBoyfriendCharacter('ace', 830, 100)
    end

    if curStep == 1824 then
        changeDadCharacter('kadedev', -70, 90)
    end

    if curStep == 1840 then
        changeBoyfriendCharacter('bf-bbpanzu', 850, 255)
    end

    if curStep == 1856 then
        changeDadCharacter('arch', -240, -130)
        characterZoom('dad', 0.9)
    end

    if curStep == 1872 then
        changeBoyfriendCharacter('pinkie', 770, 120)
    end

    if curStep == 1888 then
        changeDadCharacter('impostor2', -120, 480)   
    end

    if curStep == 1920 then
        changeBoyfriendCharacter('pompom', 900, 280)
    end

    if curStep == 1952 then
        changeDadCharacter('maijin', -150, 220)
        changeBoyfriendCharacter('exe', 830, 260)
    end

    if curStep == 2344 then
        setActorAlpha(0, 'dad1')
        changeDadCharacter('bigmonika', 16 , -140)
        changeBoyfriendCharacter('sayori', 920, 170)
    end

    if curStep == 2472 then
        setActorAlpha(1, 'dad1')
        changeDadCharacter('yuri', -40, 100)
        changeBoyfriendCharacter('natsuki', 800, 265)
    end

    if curStep == 2600 then
        changeDadCharacter('tord', 10, 200)
        changeBoyfriendCharacter('tom', 920, 200)
    end

    if curStep == 2720 then 
        changeBoyfriendCharacter('kapi-angry', 690, 50)
        changeDadCharacter('v-calm', -180, 350)
        characterZoom('dad', 1.3)
    end

    if curStep == 2848 then
        changeDadCharacter('ruv', -100, 30)
    end

    if curStep == 2912 then
        changeBoyfriendCharacter('sarvente', 870, 80)
    end

    if curStep == 2976 then
        changeDadCharacter('hellbob', -100, 380)
    end

    if curStep == 3008 then
        changeBoyfriendCharacter('ron', 920, 360)
    end

    if curStep == 3040 then
        changeDadCharacter('little-man', 250, 550)
    end

    if curStep == 3072 then
        flashCam(255,255,255, 1)
        changeDadCharacter('maijin', -150, 220)
        changeBoyfriendCharacter('bf-sticky', 860, 450)
    end

    if curStep == 3080 then
        flashCam(255,255,255, 1)
        changeDadCharacter('bob2', 10, 160)
        changeBoyfriendCharacter('richard1', 650, 70)
    end

    if curStep == 3088 then
        flashCam(255,255,255, 1)
        changeDadCharacter('snow', -140, 210)
        changeBoyfriendCharacter('tails', 770, 260)
    end

    if curStep == 3104 then
        flashCam(255,255,255, 1)
        changeDadCharacter('bigmonika', 16 , -140)
        setActorAlpha(0, 'dad')
        changeBoyfriendCharacter('bf', 0, 0)
        setActorAlpha(0, 'boyfriend')
    end

end

function dadNoteHit()

end
