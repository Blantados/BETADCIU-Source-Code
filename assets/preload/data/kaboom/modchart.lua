function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    
end

local lastStep = 0
local angleshit = 1;
local anglevar = 1;

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

	if curBeat >= 0 then
		
	end

    if curBeat < 388 then
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
	else
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
        
    if curBeat < 388 then
		if curStep % 4 == 0 then
			tweenYPsych('camHUD', -12, crochet*0.002, 'circOut')
			tweenYPsych('camGame', 12, crochet*0.002, 'sineIn')
		end
		if curStep % 4 == 2 then
			tweenYPsych('camHUD', 0, crochet*0.002, 'sineIn')
			tweenYPsych('camGame', 0	, crochet*0.002, 'sineIn')
		end
	end

end
