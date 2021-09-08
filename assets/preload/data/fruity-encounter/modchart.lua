function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'citywire')
    setActorAlpha(0, 'bgwire')
    setActorAlpha(0, 'streetwire')
    setActorAlpha(0, 'streetBehindwire')
    setActorAlpha(0, 'gfBG2')
    setActorAlpha(0, 'lightwire')
     
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

local dadX = 0
local dadY = 0
local boyfriendX = 0
local boyfriendY = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
end

function beatHit (beat)

    if curBeat == 128 or curBeat == 224 then
        setActorAlpha(1, 'bgwire')
        setActorAlpha(1, 'citywire')
        setActorAlpha(1, 'streetwire')
        setActorAlpha(1, 'streetBehindwire')
        setActorAlpha(1, 'gfBG2')
        setActorAlpha(1, 'lightwire')
        changeGFCharacter('nogf-wire', 400, 130)
        changeBoyfriendCharacter('bana-wire', 770, 190)
        changeDadCharacter('mia-wire', 200, 250)
    end

    if curBeat == 192 or curBeat == 256 then
        setActorAlpha(0, 'citywire')
        setActorAlpha(0, 'bgwire')
        setActorAlpha(0, 'streetwire')
        setActorAlpha(0, 'streetBehindwire')
        setActorAlpha(0, 'gfBG2')
        setActorAlpha(0, 'lightwire')
        changeGFCharacter('nogf', 400, 130)
        changeBoyfriendCharacter('bana', 770, 190)
        changeDadCharacter('mia', 200, 250)
    end

end

function stepHit (step)

end
