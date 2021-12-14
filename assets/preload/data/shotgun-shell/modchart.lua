function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorY(450, 'boyfriend')
    setActorY(520, 'dad')
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

    if curStep == 1 then --testing duh
        
    end

    if curStep == 160 then -- dad
        changeDadCharacter('dad', 150, 520)
    end

    if curStep == 164 then -- mom
        changeBoyfriendCharacter('mom', 1120, 480)   
    end

    if curStep == 168 then -- lila
        changeDadCharacter('lila', 160, 520)
    end

    if curStep == 170 then -- spookeez
        changeBoyfriendCharacter('spooky', 1150, 750)
    end

    if curStep == 172 then -- impostor
        changeDadCharacter('impostor2', 80, 930)
        followDadYOffset = -180
    end

    if curStep == 174 then -- henry
        changeBoyfriendCharacter('henry-angry', 1290, 770)
        characterZoom('boyfriend', 1.3)
    end

    if curStep == 176 then -- bomberman and whitty
        changeDadCharacter('bomberman', 0, 720)
        changeBoyfriendCharacter('whitty', 1140, 520)
        followDadYOffset = -50
    end

    if curStep == 256 then -- daidem
        changeDadCharacter('daidem', 130, 380)
        followDadYOffset = 150
        followDadXOffset = -100
    end

    if curStep == 320 then -- six
        changeBoyfriendCharacter('bf-six', 1170, 880)
        followBFYOffset = -100
        followBFXOffset = -150
    end

    if curStep == 384 then -- cassette girl
        changeDadCharacter('cassette-girl', 30, 580)
        followDadYOffset = -50
        followDadXOffset = 0
    end

    if curStep == 448 then -- tankman
        changeBoyfriendCharacter('tankman', 1120, 770)
        followBFXOffset = 0
        followBFYOffset = -50
    end

    if curStep == 516 then -- baldi
        changeDadCharacter('baldi-angry', 120, 450)
        followDadYOffset = 150
    end

    if curStep == 548 then -- senpai
        changeBoyfriendCharacter('bf-hd-senpai-angry', 1120, 550)
        followBFXOffset = -100
        followBFYOffset = 0
    end

    if curStep == 578 then -- rushia
        changeDadCharacter('rushia', 120, 770)
        followDadYOffset = -100
    end

    if curStep == 610 then -- sunday
        changeBoyfriendCharacter('sunday', 1170, 800)
        followBFYOffset = -50
        followBFXOffset = 0
    end

    if curStep == 630 then -- sonic mad
        changeDadCharacter('sonic-mad', 50, 720)
        followDadYOffset = -50
        followDadXOffset = 200
    end

    if curStep == 640 then -- soul tails
        changeBoyfriendCharacter('soul-tails', 1200, 820)
        followBFYOffset = -100
        followBFXOffset = -100
    end

    if curStep == 768 then -- beast sonic
        changeDadCharacter('beast-sonic', 60, 440)
        followDadXOffset = 50
        followDadYOffset = 0
    end

    if curStep == 800 then -- lord x
        changeBoyfriendCharacter('lord-x', 1000, 570)
        followBFYOffset = -50
        followBFXOffset = -100
    end

    if curStep == 832 then -- beebz
        changeDadCharacter('beebz', 90, 770)
        followDadYOffset = -100
        followDadXOffset = 0
    end

    if curStep == 864 then -- aloe
        changeBoyfriendCharacter('bf-aloe', 1120, 900)
        followBFYOffset = -100
        followBFXOffset = 0
    end

    if curStep == 896 then -- skye
        changeDadCharacter('skye', -150, 500)
        followDadYOffset = 0
    end

    if curStep == 960 then -- sky mad
        changeBoyfriendCharacter('sky-mad', 1000, 710) 
        followBFXOffset = 50
    end

    if curStep == 1024 then -- teto
        changeDadCharacter('teto', 150, 480)
    end

    if curStep == 1088 then -- miku
        changeBoyfriendCharacter('miku', 1120, 550)
        followBFXOffset = -50
        followBFYOffset = -50
    end

    if curStep == 1156 then -- steven
        changeDadCharacter('steven-pibby', 100, 720)
        followDadYOffset = -50
    end

    if curStep == 1188 then -- spongebob
        changeBoyfriendCharacter('spongebob-pibby', 700, 450) 
        followBFXOffset = -150
        followBFYOffset = 0
    end

    if curStep == 1218 then -- taki
        changeDadCharacter('taki', 70, 430)
        followDadYOffset = 0
    end

    if curStep == 1250 then -- hallow
        changeBoyfriendCharacter('hallow', 950, 450)   
        followBFXOffset = 0 
    end

    if curStep == 1270 then -- ghost twins
        changeDadCharacter('twinstwo', 0, 430) 
        characterZoom('dad', 0.9)
        tweenFadeOut('dad', 0.78, 0.00000001)
    end

    if curStep == 1280 then -- garcellodead
        changeBoyfriendCharacter('garcellodead', 860, 500)
        followBFXOffset = 100
    end

    if curStep == 1408 then -- hypno
        changeDadCharacter('hypno-two', 50, 380)
        followDadXOffset = -100
        followDadYOffset = -100
    end

    if curStep == 1440 then -- wooper
        changeBoyfriendCharacter('wooper', 1140, 940)
        followBFYOffset = -50
        followBFXOffset = 50
    end

    if curStep == 1472 then -- prdev
        changeDadCharacter('prdev', 150, 500)
        followDadXOffset = 0
        followDadYOffset = 0
    end

    if curStep == 1504 then -- blantad
        changeBoyfriendCharacter('blantad-watch', 1150, 560)
        followBFXOffset = -50
        followBFYOffset = 50
    end

end

function playerTwoTurn()
    if curStep >= 0 then
        setDefaultCamZoom(0.6)
    end
end

function dadNoteHit()
    if curStep >= 256 and curStep < 384 then
        shakeCam(0.005, 0.1)
    end
end

function playerOneTurn()

    if curStep >= 0 then
        setDefaultCamZoom(0.7)
    end
    
end
