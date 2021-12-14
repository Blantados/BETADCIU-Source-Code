
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

	if curBeat % 8 == 7 then
		playActorAnimation('boyfriend', 'hey', true, false)
	end

end

function stepHit(step) 

end