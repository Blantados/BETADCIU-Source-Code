function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)

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

    if curBeat == 24 then
        changeDadCharacter('bf-annie', 100, 420)
    end

    if curBeat == 32 then
        changeGFCharacter('nogf', 400, 130)
        changeBoyfriendCharacter('bf-gf', 830, 440)
    end

    if curBeat == 52 then
        changeBoyfriendCharacter('bf-mom', 920, 100)
    end

    if curBeat == 61 then
        changeDadCharacter('tricky', 50, 170)
    end

    if curBeat == 63 then
        changeDadCharacter('knuckles', 100, 100)
        changeDadIcon('uganda-knuckles')
    end

    if curBeat == 64 then
        changeDadIcon('knuckles')
    end

    if curBeat == 65 then
        changeDadCharacter('lila', 100, 100)
        changeBoyfriendCharacter('spooky', 820, 300)
    end

    if curBeat == 67 then
        changeDadCharacter('tom', 100, 250)
        changeBoyfriendCharacter('tord', 820, 250)
    end

    if curBeat == 69 then
        changeDadCharacter('gura-amelia', 100, 300)
        changeBoyfriendCharacter('botan', 860, 370)
    end

    if curBeat == 71 then
        changeDadCharacter('tabi', 80, 130)
        changeBoyfriendCharacter('bf-blantad', 820, 0)
    end

    if curBeat == 80 then
        changeBoyfriendCharacter('bf-exgf', 820, 75)
    end

    if curBeat == 88 then
        changeDadCharacter('miku', 100, 100)
    end

    if curBeat == 96 then
        changeBoyfriendCharacter('hex', 820, 100)
    end

    if curBeat == 120 then
        changeDadCharacter('whitty', 100, 100)
    end

    if curBeat == 128 then
        followBFXOffset = 0
        changeBoyfriendCharacter('agoti', 870, 50)
    end

    if curBeat == 136 then
        changeDadCharacter('kapi', 100, 100)
    end

    if curBeat == 152 then
        changeBoyfriendCharacter('liz', 820, 400)
    end

    if curBeat == 160 then
        changeDadCharacter('bf-sky', 150, 350)
    end

    if curBeat == 168 then
        changeDadCharacter('hd-senpai-angry', 100, 100)
    end

    if curBeat == 176 then
        changeDadCharacter('hd-senpai-giddy', 100, 100)
        changeBoyfriendCharacter('tankman', 860, 300)
    end

    if curBeat == 183 then
        changeDadIcon('hd-senpai-dark')
    end

    if curBeat == 184 then
        changeDadCharacter('hd-spirit', 100, 100)
        changeDadIcon('hd-spiritnotmad')
    end

end

function stepHit (step)

    if curStep == 1 then
        
    end

    if curStep == 166 then
        changeDadCharacter('dad', 100, 100)
    end

    if curStep == 182 then
        changeBoyfriendCharacter('bf-dad', 820, 100)
        changeGFCharacter('gf', 400, 130)
    end

    if curStep == 198 then
        changeDadCharacter('mom', 100, 100)
    end

    if curStep == 422 then
        changeDadCharacter('pico', 100, 400)
    end

    if curStep == 454 then
        changeBoyfriendCharacter('nene2', 910, 405)
    end

end
