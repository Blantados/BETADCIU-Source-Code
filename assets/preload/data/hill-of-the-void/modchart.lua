function start (song)
	print("This is the stage switch Modchart")
    followBFXOffset = -150
    setupNoteSplash('-maijin')
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

    if curStep == 416 or curStep == 544 or curStep == 672 or curStep == 800 or curStep == 928 or curStep == 1056 or curStep == 1184 or curStep == 1200 then
        exeStatic('thing')
    end

    if curStep == 1216 or curStep == 1232 or curStep == 1248 or curStep == 1264 or curStep == 1280 or curStep == 1296 or curStep == 1312 or curStep == 1440 then
        exeStatic('thing')
    end

    if curStep == 544 or curStep == 672 or curStep == 1248 or curStep == 1296 then -- reset offsets
        followDadXOffset = 0
        followDadYOffset = 0
        followBFXOffset = 0
        followBFYOffset = 0
    end

    if curStep == 416 then 
        changeStage('limoholo')  
        changeGFCharacter('emptygf', 100, 100)     
        changeDadCharacter('coco-car', 100, 100)
        changeBoyfriendCharacter('maijin-new', 1030, 0)
        followDadXOffset = -50
        followDadYOffset = 50   
    end

    if curStep == 480 then
        changeBoyfriendCharacter('mom-car', 1030, -170)
        setupNoteSplash('-normal')
        followBFXOffset = 150
        followBFYOffset = 50
    end

    if curStep == 544 then
        changeStage('hall')   
        changeDadCharacter('nikusa-shaded', 0, 300)
        changeBoyfriendCharacter('mom-shaded', 1250, 380)
    end

    if curStep == 608 then
        changeBoyfriendCharacter('aldryx-shaded', 1000, 400)
        followBFXOffset = 500
    end

    if curStep == 672 then
        changeStage('out')
        changeGFCharacter('nogf', 470, 130)
        changeDadCharacter('rshaggy', 100, 100)
        changeBoyfriendCharacter('cassette-girl', 1070, 170)
    end

    if curStep == 800 then
        changeStage('zardymaze')
        changeGFCharacter('nogf', 400, 270)
        changeDadCharacter('zardy', 20, 240)
        changeBoyfriendCharacter('cassette-girl', 870, 350)
        characterZoom('boyfriend', 0.9)
    end

    if curStep == 864 then
        changeBoyfriendCharacter('spooky', 900, 470)
    end

    if curStep == 928 then
        changeStage('pokecenter')    
        changeGFCharacter('emptygf', 100, 100)   
        changeDadCharacter('hypno-two', -100, -300)  
        changeBoyfriendCharacter('spooky', 1290, 40)
    end

    if curStep == 992 then
        changeBoyfriendCharacter('bf-gf-lullaby', 1290, 80)
        followBFXOffset = -200
    end

    if curStep == 1056 then
        changeStage('withered')  
        changeGFCharacter('nogf', 400, 130)     
        changeDadCharacter('angrybob', 100, 380)
		changeBoyfriendCharacter('neon', 1030, 400) 
        setupNoteSplash('-neon')
        pixelStrums('bf', true)
        followBFXOffset = 200
    end

    if curStep == 1184 then
        changeStage('trioStage')
        changeGFCharacter('emptygf', 100, 100)
        changeDadCharacter('soul-tails', -45, 300)
		changeBoyfriendCharacter('neon', 700, 340) 
        setDefaultCamZoom(1.1)
    end

    if curStep == 1192 then
        changeBoyfriendCharacter('tails', 400, 200) 
        setupNoteSplash('-normal')
        pixelStrums('bf', false)
    end

    if curStep == 1200 then
        changeStage('emptystage2')
        changeGFCharacter('gf-demona', 300, -195)
        changeDadCharacter('arch', -575, -380)	      
        changeBoyfriendCharacter('tails', 800, 50)
        setDefaultCamZoom(1)
        followBFXOffset = 100 
    end

    if curStep == 1208 then
        changeBoyfriendCharacter('bf-bbpanzu', 800, 40) 
    end

    if curStep == 1216 then
        changeStage('ron');
        changeGFCharacter('nogf', 400, 130)
        changeDadCharacter('ron', 73, 368)
        changeBoyfriendCharacter('bf-bbpanzu', 900, 270) 
    end

    if curStep == 1224 then
        changeBoyfriendCharacter('little-man', 1125, 744)
        setupNoteSplash('-white')
        followBFXOffset = 0
    end

    if curStep == 1232 then
        changeStage('dokiclubroom-monika')
        setActorAlpha(0, 'sayori', true)
        changeGFCharacter('nogf', 400, 130)
        changeDadCharacter('monika-real', 80, 140)
        changeBoyfriendCharacter('sayori', 870, 220)
        setupNoteSplash('-normal')
        characterZoom('dad', 0.9)
        followBFXOffset = 50
        followDadYOffset = 100
        followBFYOffset = 100
    end

    if curStep == 1248 then
        changeStage('stuco')
        changeGFCharacter('gf-kaguya', 400, 130)
        changeDadCharacter('monika-real', 70, 90)
        changeBoyfriendCharacter('bf-shirogane', 770, 450)
        characterZoom('dad', 0.9)
        followDadYOffset = 100
    end

    if curStep == 1256 then
        changeDadCharacter('fujiwara', 100, 100)
        followDadYOffset = 0
    end

    if curStep == 1264 then
        changeStage('melonfarm')
        setupNoteSplash('-fever')
        changeGFCharacter('gf-tea', 400, 130)
        changeDadCharacter('fujiwara', 120, 120)
        changeBoyfriendCharacter('bf-demoncesar-cas', 950, 450) 
        followBFXOffset = -75 
        followDadXOffset = 75
    end

    if curStep == 1272 then
        changeDadCharacter('makocorrupt', -190, 0)     
        followDadXOffset = 75
        followDadYOffset = 20
    end

    if curStep == 1280 then
        changeStage('philly-neo')
        setupNoteSplash('-normal')
        changeGFCharacter('nogf', 400, 130)
        changeDadCharacter('makocorrupt', -190, 0)
        changeBoyfriendCharacter('prdev', 950, 150)
        followDadXOffset = 120
        followDadYOffset = 50
        followBFXOffset = -150
    end

    if curStep == 1288 then
        changeDadCharacter('neonight', 70, 270)
        followDadXOffset = 50
    end

    if curStep == 1296 then
        changeStage('emptystage2')
		changeDadCharacter('gold', 20, 340)
        changeBoyfriendCharacter('bf', 810, 450)
        setActorAlpha(0, 'gf')
        setActorAlpha(0, 'boyfriend')
    end

    if curStep == 1312 then
        changeStage('tank2')
		changeGFCharacter('gf-tankmen', 220, 100)
		changeDadCharacter('tankman', 20, 340)
        changeBoyfriendCharacter('bf', 810, 450)
    end

    if curStep == 1376 then
        changeBoyfriendCharacter('bf-hd-senpai-giddy', 870, 100)
    end

    if curStep == 1440 then
        changeStage('night');
        changeGFCharacter('nogf-night', 700, 80)
        changeDadCharacter('amor', -270, 139)
        changeBoyfriendCharacter('bf-hd-senpai-angry-night', 960, 80)      
    end

    if curStep == 1504 then
        changeBoyfriendCharacter('bob2-night', 960, 130)     
        setupNoteSplash('-bob') 
    end
end
