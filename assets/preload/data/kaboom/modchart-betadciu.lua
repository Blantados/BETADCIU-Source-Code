function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
	changeBoyfriendCharacter('bf', 815, 285)
end

local lastStep = 0
local angleshit = 1;
local anglevar = 1;

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

	if curBeat >= 192 and curBeat < 224 then
		shakeCam(0.01, 0.05)
		shakeHUD(0.01, 0.05)
	end

end

function beatHit (beat)

	if curBeat >= 0 then
		
	end

    if curBeat < 192 or curBeat >= 224 and curBeat < 288 then
		addCamZoom(0.03)

		if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
        
		cameraAngle= angleshit*2
		camHudAngle = angleshit*2

		tweenAnglePsych('camHUD', angleshit, crochet*0.002, 'circOut')
		tweenXPsych('camHUD', -angleshit*8, crochetReal*0.001, 'linear')
		tweenAnglePsych('camGame', angleshit, crochet*0.002, 'circOut')
		tweenXPsych('camGame', -angleshit*8, crochetReal*0.001, 'linear')
	end

	if curBeat > 304 and curBeat < 388 then
		addCamZoom(0.03)

		if curBeat % 2 == 0 then
			angleshit = anglevar;
		else
			angleshit = -anglevar;
		end
        
		cameraAngle= angleshit*2
		camHudAngle = angleshit*2

		tweenAnglePsych('camHUD', angleshit, crochet*0.002, 'circOut')
		tweenXPsych('camHUD', -angleshit*8, crochetReal*0.001, 'linear')
		tweenAnglePsych('camGame', angleshit, crochet*0.002, 'circOut')
		tweenXPsych('camGame', -angleshit*8, crochetReal*0.001, 'linear')
	end

	if curBeat == 192 or curBeat == 388 or curBeat == 288 then
		cameraAngle = 0
		camHudAngle = 0
		setCamPosition(0,0)
		setHudPosition(0,0)
	end

end

--default positions--
--[[
    changeDadCharacter('dad', 100, 100)
    changeBoyfriendCharacter('bf', 870, 480)
]]--

function stepHit (step)

	if curStep == 1 then
		
	end

	if curStep == 126 then
        changeDadCharacter('whittyCrazy', -50, -50)
    end
	
	if curStep == 158 then
        changeBoyfriendCharacter('natsuki', 820, 105)
    end
	
	if curStep == 190 then
        changeDadCharacter('hd-senpai-angry', 50, -50)
    end
	
	if curStep == 222 then
		changeDadCharacter('hd-senpai-giddy', 50, -50)
        changeBoyfriendCharacter('tankman', 800, 150)
    end
	
	if curStep == 256 then
        changeDadCharacter('tabi-crazy', 0, 0)
    end
	
	if curStep == 256 then
        changeBoyfriendCharacter('agoti-mad', 770, 90)
		followBFXOffset = -150
    end
	
	if curStep == 320 then
        changeBoyfriendCharacter('bf-demoncesar', 800, 250)
		followBFXOffset = 0
    end
	
	if curStep == 320 then
        changeDadCharacter('peasus', -75, -70)
		followDadXOffset = 200
    end
	
	if curStep == 384 then
        changeDadCharacter('happymouse2', -20, -0)
		followDadXOffset = 0
    end
	
	if curStep == 384 then
        changeBoyfriendCharacter('oswald-angry', 830, 200)
		followBFYOffset = 0
    end
	
	if curStep == 448 then
        changeDadCharacter('trickward', 100, -70)
    end
	
	if curStep == 448 then
        changeBoyfriendCharacter('bf-spongebob', 800, 270)
    end
	
	if curStep == 514 then
        changeDadCharacter('auditor', -200, -120)
    end
	
	if curStep == 642 then
        changeBoyfriendCharacter('hank', 870, 130)
		followBFYOffset = 0
		followBFXOffset = -150
    end
	
	if curStep == 768 then
        changeDadCharacter('ruv', 50, -130)
    end
	
	if curStep == 770 then
        changeBoyfriendCharacter('sarvente', 800, -70)
		followBFYOffset = 0
		followBFXOffset = -200
    end
	
	if curStep == 896 then
		changeBoyfriendCharacter('huggy', 870, 25)
		characterZoom('boyfriend', 1.2)
    end

	if curStep == 898 then
        changeDadCharacter('exe', 100, 100)
    end
	
	if curStep == 1024 then
        changeDadCharacter('opheebop', 0, 50)
    end
	
	if curStep == 1024 then
        changeBoyfriendCharacter('glitched-bob', 650, 200)
		followBFYOffset = 0
    end
	
	if curStep == 1088 then
        changeDadCharacter('calli', 100, -50)
    end
	
	if curStep == 1088 then
        changeBoyfriendCharacter('gura-amelia', 800, 150)
		followBFYOffset = 0
    end
	
	if curStep == 1152 then
        changeDadCharacter('sky-mad', 0, 100)
		followDadYOffset = -20
    end
	
	if curStep == 1152 then
        changeBoyfriendCharacter('bf-gf', 800,  250)
		followBFYOffset = 0
    end
	
	if curStep == 1216 then
        changeDadCharacter('matt', 70, 250)
		followDadYOffset = 0
		followDadXOffset = 50
    end
	
	if curStep == 1216 then
        changeBoyfriendCharacter('shaggy', 850, -70)
		followBFYOffset = 20
		followBFXOffset = 0
    end
	
	if curStep == 1280 then
        changeDadCharacter('garcellotired', -70, -75)
		followDadXOffset = 0
    end
	
	if curStep == 1280 then
        changeBoyfriendCharacter('bf-annie', 780, 270)
		followBFYOffset = 0
		followBFXOffset = 0
    end
	
	if curStep == 1344 then
        changeDadCharacter('neko-crazy', -60, 190)
    end
	
	if curStep == 1344 then
        changeBoyfriendCharacter('nene', 830, 230)
		followBFYOffset = 0
    end
	
	if curStep == 1408 then
        changeDadCharacter('nonsense', 125, 40)
    end
	
	if curStep == 1408 then
        changeBoyfriendCharacter('bob2', 800, 20)
		followBFYOffset = 0
    end
	
	if curStep == 1472 then
        changeDadCharacter('lucian', 0, -100)
    end
	
	if curStep == 1472 then
        changeBoyfriendCharacter('kapi-angry', 700, -100)
		followBFYOffset = 0
    end
        
    if curBeat < 192 or curBeat >= 224 and curBeat < 288 or curBeat > 304 and curBeat < 388 then
		if curStep % 4 == 0 and curStep < 1152 or curStep % 4 == 0 and curStep >= 1216 then
			tweenYPsych('camHUD', -12, crochet*0.002, 'circOut')
			tweenYPsych('camGame', 12, crochet*0.002, 'sineIn')
		end
		if curStep % 4 == 2 and curStep < 1152 or curStep % 4 == 2 and curStep >= 1216 then
			tweenYPsych('camHUD', 0, crochet*0.002, 'sineIn')
			tweenYPsych('camGame', 0	, crochet*0.002, 'sineIn')
		end
	end

end
