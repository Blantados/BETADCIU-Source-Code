function start (song)
	print("This is the stage switch Modchart")
    followBFXOffset = -150
    setupNoteSplash('-maijin')
    --setDefaultCamZoom(0.5)
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    hudX = getHudX()
    hudY = getHudY()

    -- damn scrollfactor. why tf isn't the scrollfactor set for the stage stuff instead?
    setScrollFactor('dad', 1.37, 1) 
	setScrollFactor('boyfriend', 1.37, 1)
end

function beatHit (beat)

end

function stepHit (step)

    --for tests and stuff
    if curStep == 1 then
      
    end

    if curStep == 264 then
        flashCam(255, 0, 0, 2, true)
    end

    --[[if curStep == 800 or curStep == 1296 then -- reset offsets
        followDadXOffset = 0
        followDadYOffset = 0
        followBFXOffset = 0
        followBFYOffset = 0
    end]]--

    if curStep == 416 then 
        changeDadCharacter('coco', 140, 110)
        followDadXOffset = -50
        followDadYOffset = 50   
    end

    if curStep == 480 then
        changeBoyfriendCharacter('mom', 930, 110)
        followBFXOffset = 0
        setupNoteSplash('-normal')
    end

    if curStep == 544 then
        changeDadCharacter('nikusa', 150, 100)
        characterZoom('dad', 0.7)
        followDadYOffset = 150
        followDadXOffset = -100
    end

    if curStep == 608 then
        changeBoyfriendCharacter('aldryx', 640, 150)      
        characterZoom('boyfriend', 0.8)
        followBFXOffset = 500
    end

    if curStep == 672 then
        changeDadCharacter('rshaggy', 180, 130)
        changeBoyfriendCharacter('cassette-girl', 820, 220)
        characterZoom('boyfriend', 0.9)
        followDadXOffset = -50
        followDadYOffset = 50
        followBFXOffset = -150
    end

    if curStep == 800 then
        changeDadCharacter('zardy', 0, 100)  
        followDadXOffset = 0
        followDadYOffset = 0
    end

    if curStep == 864 then
        changeBoyfriendCharacter('spooky', 890, 340)
        followBFXOffset = -100
    end

    if curStep == 928 then
        changeDadCharacter('hypno-two', -100, 0)  
        followDadXOffset= -200
    end

    if curStep == 992 then
        changeBoyfriendCharacter('bf-gf-lullaby', 890, 380)
        followBFXOffset = -170
    end

    if curStep == 1056 then 
        changeDadCharacter('angrybob', 100, 420)
		changeBoyfriendCharacter('neon', 1050, 440) 
        setupNoteSplash('-neon')
        pixelStrums('bf', true)
        followBFXOffset = -50
        followDadXOffset = 0
    end

    if curStep == 1184 then
        changeDadCharacter('soul-tails', 255, 400)
        followDadYOffset = -50
    end

    if curStep == 1192 then
        changeBoyfriendCharacter('tails', 770, 300) 
        setupNoteSplash('-normal')
        pixelStrums('bf', false)
        followBFXOffset = -50
        followBFYOffset = 50
    end

    if curStep == 1200 then
        changeDadCharacter('arch', 0, -130)	      
        followDadYOffset = 0
    end

    if curStep == 1208 then
        changeBoyfriendCharacter('bf-bbpanzu', 860, 300) 
        followBFXOffset = -100
        followBFYOffset = 0
    end

    if curStep == 1216 then
        changeDadCharacter('ron', 173, 388)
    end

    if curStep == 1224 then
        changeBoyfriendCharacter('little-man', 1025, 734)
        setupNoteSplash('-white')
        followBFXOffset = -100
        followBFYOffset = -100
    end

    if curStep == 1232 then
        changeDadCharacter('monika-real', 80, 140)
        changeBoyfriendCharacter('sayori', 940, 230)
        setupNoteSplash('-normal')
        characterZoom('dad', 0.9)
        followBFXOffset = -50
        followBFYOffset = 0
        followDadXOffset = 0
        followDadYOffset = 100
    end

    if curStep == 1248 then
        changeBoyfriendCharacter('bf-shirogane', 870, 475)
        followBFXOffset = -150
        followBFYOffset = 0      
    end

    if curStep == 1256 then
        changeDadCharacter('fujiwara', 140, 110)
        followDadXOffset = -50
        followDadYOffset = 0 
    end

    if curStep == 1264 then
        changeBoyfriendCharacter('bf-demoncesar', 880, 430) 
        changeStaticNotes('exe', 'fever')
        followBFXOffset = -150 
        followBFYOffset = 0
    end

    if curStep == 1272 then
        changeDadCharacter('makocorrupt', -190, 0)     
        followDadXOffset = 75
        followDadYOffset = 20
    end

    if curStep == 1280 then
        changeBoyfriendCharacter('prdev', 880, 90)
        followBFXOffset = -250
    end

    if curStep == 1288 then
        changeDadCharacter('neonight', 50, 250)
        followDadXOffset = 0
        followDadYOffset = 0
    end

    if curStep == 1296 then
        changeDadCharacter('gold-side', 240, 200)
        changeBoyfriendCharacter('bf', 870, 475)
        followDadXOffset = -50
        followDadYOffset = 50
        followBFXOffset = -150
    end

    if curStep == 1312 then
        changeDadCharacter('tankman', 150, 335)
        followDadXOffset = 0
        followDadYOffset = 0
    end

    if curStep == 1376 then
        changeBoyfriendCharacter('bf-hd-senpai-giddy', 870, 125)
    end

    if curStep == 1440 then
        changeDadCharacter('amor', 200, 150)         
    end

    if curStep == 1504 then
        changeBoyfriendCharacter('bob2', 880, 200)
        characterZoom('dad', 0.9)    
        followBFXOffset = -100        
        setupNoteSplash('-bob') 
    end
end
