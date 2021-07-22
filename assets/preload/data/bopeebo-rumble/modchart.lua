
function start(song) 

end

local camX = 0
local camY = 0

function update(elapsed) 
	local currentBeat = (songPos / 1000)*(bpm/60)

	local camX = getCameraX()
	local camY = getCameraY()

	if bounceCam then
	end

end

function beatHit(beat) 

end

function stepHit(step) 

	if curStep == 1 then
		bounceCam = true
	end

	if curStep == 76 or curStep == 140 or curStep == 268 or curStep == 332 or curStep == 396 then
		playActorAnimation('boyfriend', 'hey', true, false)
	end

end