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

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)


end

--default positions
-- changeDadCharacter('dad', 0, 100) 
-- changeBoyfriendCharacter('bf', 770, 450) 

function stepHit (step)

    if curStep == 1 then --for testing
        
    end

    if curStep == 128 then
        changeDadCharacter('sarvente', -50, 60) 
    end

    if curStep == 192 then
        changeBoyfriendCharacter('ruv', 770, 30) 
    end

    if curStep == 256 then
        changeDadCharacter('dad', 0, 100)   
    end

    if curStep == 272 then
        changeBoyfriendCharacter('mom', 770, 80)
    end

    if curStep == 288 then
        changeDadCharacter('spooky', -50, 300) 
    end

    if curStep == 320 then
        changeBoyfriendCharacter('hd-senpai-angry', 770, 100)   
    end

    if curStep == 336 then
        changeBoyfriendCharacter('hd-senpai-giddy', 770, 100) 
        changeDadCharacter('tankman', 0, 280) 
    end

    if curStep == 352 then
        changeBoyfriendCharacter('pico', 760, 400) 
    end

    if curStep == 384 then
        changeDadCharacter('whitty', 0, 100)  
    end

    if curStep == 416 then
        changeBoyfriendCharacter('bf-carol', 700, 450) 
    end

    if curStep == 448 then
        changeDadCharacter('zardy', -160, 80) 
    end

    if curStep == 480 then
        changeBoyfriendCharacter('bf-exgf', 600, 30) 
    end

    if curStep == 512 then
        changeDadCharacter('tricky', -50, 180) 
    end

    if curStep == 544 then
        changeBoyfriendCharacter('bf-sky', 820, 330) 
    end

    if curStep == 576 then
        changeDadCharacter('hex', 0, 95)  
    end

    if curStep == 608 then 
        changeBoyfriendCharacter('dr-springheel', 600, 30) 
    end

    if curStep == 640 then
        changeDadCharacter('hd-monika', 0, 120)  
    end

    if curStep == 704 then 
        changeBoyfriendCharacter('bf-annie', 710, 430) 
    end

    if curStep == 768 then 
        changeDadCharacter('agoti', 0, 10)  
        followDadXOffset = -20
    end

    if curStep == 832 then 
        changeBoyfriendCharacter('tabi', 720, 100) 
    end

    if curStep == 896 then
        followDadXOffset = 0
        changeDadCharacter('anders', 0, 120)  
    end

    if curStep == 960 then
        changeBoyfriendCharacter('neon-bigger', 920, 350)
    end

    if curStep == 1024 then 
        changeDadCharacter('botan', -70, 350)  
    end

    if curStep == 1056 then
        changeBoyfriendCharacter('bf-sans', 770, 450) 
    end

    if curStep == 1088 then
        changeDadCharacter('kapi', 0, 100)  
    end

    if curStep == 1120 then
        changeBoyfriendCharacter('henry', 770, 0) 
    end

    if curStep == 1152 then
        changeDadCharacter('matt', 30, 400)  
    end

    if curStep == 1184 then
        changeBoyfriendCharacter('shaggy', 770, 100)
        followBFYOffset = 50
    end

    if curStep == 1216 then
        changeDadCharacter('liz', 0, 400)  
    end

    if curStep == 1248 then
        followBFXOffset = 0
        followBFYOffset = 0
        changeBoyfriendCharacter('sunday', 800, 360) 
    end

    if curStep == 1280 then
        changeDadCharacter('garcello', -100, 100)  
    end

    if curStep == 1344 then
        changeBoyfriendCharacter('pompom', 800, 310) 
        followBFXOffset = -75
    end

end

function dadNoteHit()

end
