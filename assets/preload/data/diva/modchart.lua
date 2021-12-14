function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    newIcons = true
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

--[[default positions for characters:
    changeGFCharacter('gf', 335, 330)
    changeDadCharacter('dad', 55, 400)
    changeBoyfriendCharacter('bf', 920, 750)
]]--

function stepHit (step)

    --for testing purposes
    if curStep == 1 then
        --changeDadCharacter('taeyai-b3', 150, 820)
        --changeBoyfriendCharacter('miku', 900, 350)
    end

    if curStep == 192 then
        changeDadCharacter('calebcity', 150, 820)
    end

    if curStep == 224 then
        changeBoyfriendCharacter('little-man', 1020, 1020)
    end

    if curStep == 256 then
        changeDadCharacter('whitty-b3', 55, 400)
    end

    if curStep == 288 then
        changeBoyfriendCharacter('whitty-minus-b3', 370, 370)
    end

    if curStep == 316 then
        changeDadCharacter('bf-carol', 55, 750)
    end

    if curStep == 384 then
        changeDadCharacter('yukichi-police', -25, 530)
    end

    if curStep == 448 then
        changeBoyfriendCharacter('bf-demoncesar', 880, 700)
    end

    if curStep == 508 then -- taeyai
      
    end

    if curStep == 572 then 
        changeBoyfriendCharacter('amor-ex', 870, 450)
        characterZoom('boyfriend', 0.83)
    end

    if curStep == 640 then 
        changeDadCharacter('botan-b3', 5, 650)
    end

    if curStep == 704 then
        changeBoyfriendCharacter('pico-b3', 840, 670)
    end

    if curStep == 768 then -- sakuroma
      
    end

    if curStep == 784 then -- retro
      
    end

    if curStep == 800 then -- ace
      
    end

    if curStep == 832 then
        changeBoyfriendCharacter('selever', 900, 350)
    end

    if curStep == 848 then
        changeDadCharacter('hd-monika', 55, 450)
    end

    if curStep == 864 then -- miku
      
    end

    if curStep == 896 then -- kade
      
    end

    if curStep == 960 then -- bbpanzu
      
    end

    if curStep == 1024 then
        changeDadCharacter('maijin', 25, 550)
    end

    if curStep == 1056 then -- crash
      
    end

    if curStep == 1156 then 
        changeDadCharacter('hd-senpai-angry-b3', 55, 400)
    end

    if curStep == 1220 then--
        changeDadCharacter('hd-senpai-giddy-b3', 55, 400)
        changeBoyfriendCharacter('bf-aloe-b3', 920, 750)
    end

    if curStep == 1276 then
        changeDadCharacter('shaggy', 75, 400)
    end

    if curStep == 1344 then
        changeBoyfriendCharacter('tankman', 900, 600)
    end

    if curStep == 1408 then
        changeDadCharacter('beebz-b3', 25, 640)
    end

    if curStep == 1424 then -- b3 gf? if no such thing then normal gf
      
    end

    if curStep == 1488 then
        changeDadCharacter('dad-b3', 55, 275)
    end

    if curStep == 1536 then
        changeBoyfriendCharacter('bf-dad-b3', 900, 400)
    end

    if curStep == 1600 then
        changeDadCharacter('lila', 55, 400)
        changeBoyfriendCharacter('spooky-b3', 920, 600)
    end

    if curStep == 1640 then -- peri and bana
      
    end

    if curStep == 1648 then -- cg5 and garcello
      
    end

    if curStep == 1652 then -- sonic and blantad
      
    end

    if curStep == 1656 then -- tom and tord
      
    end

    if curStep == 1680 then -- tricky and hank
      
    end

    if curStep == 1696 then
        changeDadCharacter('cablecrow', -155, 250)
    end

    if curStep == 1760 then
        changeBoyfriendCharacter('zardy', 670, 400)
    end

    if curStep == 1824 then
        changeDadCharacter('bf-lexi-b3', 135, 640)
    end

    if curStep == 1840 then
        changeBoyfriendCharacter('lexi-b3', 900, 550)
    end

    if curStep == 1856 then
        changeDadCharacter('sky-b3', 125, 630)
    end

    if curStep == 1888 then -- henry
      
    end

    if curStep == 1904 then -- ellie
      
    end

    if curStep == 1920 then -- charles
      
    end
end
