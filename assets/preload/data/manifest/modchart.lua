function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    setActorAlpha(0, 'gfCrazyBG', true)
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

    if curBeat == 32 then
        changeDadCharacter('sarvente-lucifer', 50, -200)
    end

    if curBeat == 48 then
        followBFXOffset = -100
        changeBoyfriendCharacter('selever', 870, -110)
    end

    if curBeat == 64 then
        changeDadCharacter('nene2', 50, 255)
    end

    if curBeat == 74 then
        followBFXOffset = 0
        changeBoyfriendCharacter('pico', 870, 235)
    end

    if curBeat == 84 then
        changeDadCharacter('drunk-annie', 50, -35)
        characterZoom('dad', 1.2)
    end

    if curBeat == 94 then
        changeBoyfriendCharacter('garcellodead', 670, -85)
    end

    if curBeat == 104 then
        characterZoom('dad', 1)
        changeDadCharacter('hd-monika-angry', 120, 0)
    end

    if curBeat == 120 then
        changeBoyfriendCharacter('senpaighosty', 830, -85)
    end

    if curBeat == 128 then
        changeGFCharacter('crazygf-crucified', 480, -55)
    end

    if curBeat == 136 then
        changeGFCharacter('nogf-crucified', 480, -55)
        changeDadCharacter('crazygf', 120, 155)
        characterZoom('dad', 1.1)
    end

    if curBeat == 152 then
        changeBoyfriendCharacter('brother', 830, -25)
    end

    if curBeat == 168 then
        setActorAlpha(1, 'gfCrazyBG', true)
        characterZoom('dad', 1)
        changeDadCharacter('mom', 120, -100)
    end

    if curBeat == 174 then
        changeBoyfriendCharacter('bf-mom', 830, -100)
    end

    if curBeat == 180 then
        changeDadCharacter('sunday', 120, 200)
    end

    if curBeat == 186 then
        changeBoyfriendCharacter('bf-carol', 830, 275)
    end

    if curBeat == 192 then
        changeDadCharacter('pompom-mad', 120, 200)
    end

    if curBeat == 198 then
        changeBoyfriendCharacter('kapi-angry', 780, -75)
    end

    if curBeat == 204 then
        changeDadCharacter('roro', -180, 25)
    end

    if curBeat == 210 then
        changeBoyfriendCharacter('anchor', 830, -125)
    end

    if curBeat == 216 then
        changeDadCharacter('chara', 120, 250)
    end

    if curBeat == 232 then
        changeBoyfriendCharacter('bf-sans', 830, 275)
    end

    if curBeat == 248 then
        changeDadCharacter('whittyCrazy', 50, 0)
    end

    if curBeat == 264 then
        changeBoyfriendCharacter('agoti-mad', 830, 125)
    end

    if curBeat == 280 then
        changeDadCharacter('miku-mad', 120, -50)
    end

    if curBeat == 312 then
        changeDadCharacter('gura-amelia', 70, 150)
        changeBoyfriendCharacter('hex-virus', 830, 75)
    end

    if curBeat == 344 then
        changeBoyfriendCharacter('botan', 870, 200)
    end

    if curBeat == 376 then
        changeDadCharacter('tabi-crazy', 120, -25);
        fixTrail('tabiTrail')
    end

    if curBeat == 392 then
        changeBoyfriendCharacter('bf-exgf', 820, -100)
    end

    if curBeat == 408 then
        removeObject('tabiTrail')
        changeDadCharacter('tord', 170, 100)    
    end

    if curBeat == 416 then
        changeBoyfriendCharacter('tom', 870, 100)
    end

end

function stepHit (step)

end
