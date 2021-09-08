function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
    changeBFIcon('hd-senpai-fear')   
    setActorAlpha(0, 'tv')
end

local defaultHudX = 0
local defaultHudY = 0

local tvX = 0
local tvY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)

end

function beatHit (beat)

    if curBeat == 192 then
        followBFYOffset = 0
        changeBoyfriendCharacter('tankman-mad', 890, 370)
        changeBFIcon('tankman-mad')
        flashCam(255,255,255,1)
    end

    if curBeat == 256 then
        followBFYOffset = 0
        changeBoyfriendCharacter('ruv-mad', 890, 145)
        flashCam(255,255,255,1)
    end

    if curBeat == 352 then
        changeBoyfriendCharacter('hd-monika-angry', 890, 170)
        flashCam(255,255,255,1)
    end

    if curBeat == 416 then   
        changeDadCharacter('dad-sad', 150, 170)
        changeBoyfriendCharacter('hd-senpai', 890, 170)
        changeBFIcon('hd-senpai-fear-happy')
        flashCam(255,255,255,1)
        setActorAlpha(1, 'tv')
    end

    if curBeat == 544 then  
        changeDadCharacter('dad-sad-pixel', 150, 170)          
        flashCam(255,255,255,1)
    end

    if curBeat == 608 then  
        changeDadIcon('dad-sad-pixel-white')     
        tweenFadeOut('dad', 0, 1)
        tweenFadeOut('iconP2', 0, 1)
    end

end

function stepHit (step)


end
