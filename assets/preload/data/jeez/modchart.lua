function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'yoMamaBG')
    setActorAlpha(0, 'brody')
end

local lastStep = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

end

--default positions--
--[[
    changeDadCharacter('dad', 100, 100)
    changeBoyfriendCharacter('bf', 870, 480)
]]--

function stepHit (step)
        
    if curStep == 1 then    
        
    end

    if curStep == 64 then
        changeDadCharacter('cj', 100, 140)
    end

    if curStep == 96 then
        changeBoyfriendCharacter('ruby', 920, 140)
    end

    if curStep == 128 then
        changeDadCharacter('shaggy', 150, 100)
    end

    if curStep == 160 then
        changeBoyfriendCharacter('matt', 920, 420) --haha funni number
    end

    if curStep == 176 then     
        changeDadCharacter('eteled2', 100, 300)
    end

    if curStep == 216 then
        changeBoyfriendCharacter('austin', 770, 30)
    end

    if curStep == 256 then
        changeDadCharacter('mom', 100, 100)
    end

    if curStep == 320 then
        changeBoyfriendCharacter('bf-kitty', 870, 480)
    end

    if curStep == 384 then     
        changeDadCharacter('exe', 220, 300)
    end

    if curStep == 408 then     
        changeBoyfriendCharacter('happymouse', 670, 180)
    end

    if curStep == 452 then     
        changeDadCharacter('hd-senpai-angry', 100, 130)
    end

    if curStep == 484 then     
        changeDadCharacter('hd-senpai-giddy', 100, 130)
        changeBoyfriendCharacter('tankman', 870, 330)
    end
   
    if curStep == 512 then     
        changeDadCharacter('matt2', 0, 100)
    end

    if curStep == 528 then     
        changeBoyfriendCharacter('tord2', 620, 100)
    end

    if curStep == 544 then     
        changeDadCharacter('tom2', 0, 100)
    end

    if curStep == 560 then     
        changeBoyfriendCharacter('edd2', 620, 100)
    end

    if curStep == 576 then     
        changeDadCharacter('garcello', 0, 100)
        changeBoyfriendCharacter('bf-annie', 870, 480)
    end

    if curStep == 631 then
        flashCamHUD(255,255,255,1)
        setActorAlpha(1, 'yoMamaBG')
        setActorAlpha(1, 'brody') 
        playSound('yomama')
    end

    if curStep == 632 then
        playBGAnimation2('brody', 'yomom', true, false) 
    end

    if curStep == 640 then --just separatin this shit
        flashCamHUD(255,255,255,1)
        setActorAlpha(0, 'yoMamaBG')
        setActorAlpha(0, 'brody')
    end

    if curStep == 640 then
        changeDadCharacter('pico', 100, 400)
        changeBoyfriendCharacter('midas', 870, 110)
    end

    if curStep == 704 then
        changeDadCharacter('kirbo', 100, 550)
    end

    if curStep == 736 then
        changeBoyfriendCharacter('foks', 870, 500)
        followBFYOffset = 50
    end

    if curStep == 768 then
        changeDadCharacter('papyrus', 100, 150)
    end

    if curStep == 800 then
        followBFYOffset = 0
        changeBoyfriendCharacter('bf-sans', 870, 480)
    end
end
