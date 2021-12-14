function start (song)
	print("Song: " .. song .. " @ " .. bpm .. " donwscroll: " .. downscroll)
    setActorAlpha(0, 'dad1')
    setActorAlpha(0, 'boyfriend1')
end

local defaultHudX = 0
local defaultHudY = 0

local defaultWindowX = 0
local defaultWindowY = 0

local lastStep = 0


function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
    if l1 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 10 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
    if l2 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'], i)
        setActorY(_G['defaultStrum'..i..'Y'], i)
        end
    end
    if l3 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 30 * math.sin((currentBeat + i*0.32)), i)
        end
    end

    if l4 then
        for i=0,7 do
        setActorY(_G['defaultStrum'..i..'Y'] + 30 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
    if l5 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 20 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
    if l6 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 50 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 30 * math.cos((currentBeat + i*0.25) * math.pi), i)
        end
    end
    if l7 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 150 * math.sin((currentBeat + i*0.32)), i)
        setActorY(_G['defaultStrum'..i..'Y'], i)
        end
    end
    if l8 then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'], i)
        setActorY(_G['defaultStrum'..i..'Y'] + 150 * math.cos((currentBeat * 0.25) * math.pi), i)
        end
    end
    if circleArrows then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 64 * math.sin((currentBeat * 0.35) * math.pi), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 64 * math.cos((currentBeat * 0.35) * math.pi), i)
        end
    end
    if circleArrowsCrazy then
        for i=0,7 do
        setActorX(_G['defaultStrum'..i..'X'] + 40 * math.sin((currentBeat + i*0.35) * math.pi), i)
        setActorY(_G['defaultStrum'..i..'Y'] + 40 * math.cos((currentBeat + i*0.35) * math.pi), i)
        end
    end
end

function beatHit (beat)

end

function stepHit (step)

    if curStep == 1 then --testing duh
       
    end

    if curStep == 192 then
        changeDadCharacterBetter(-150, 250, 'parents-christmas-soft')
        characterZoom('dad', 0.85)
        followDadXOffset = 150
    end

    if curStep == 224 then
        followBFYOffset = 100
        changeBoyfriendCharacterBetter(770, 195, 'parents-christmas-angel')
        characterZoom('boyfriend', 0.82)
    end

    if curStep == 384 then
        changeDadCharacterBetter(0, 190, 'cj-ruby')
        characterZoom('dad', 0.95)
    end

    if curStep == 400 then
        changeBoyfriendCharacterBetter(720, 220, 'sarv-ruv')
        characterZoom('boyfriend', 0.85)
    end

    if curStep == 448 then
        followDadYOffset = 175
        changeDadCharacterBetter(-150, 180, 'qt-kb')
        characterZoom('dad', 0.85)
    end

    if curStep == 480 then
        changeBoyfriendCharacterBetter(770, 200, 'shaggy')
        changeBoyfriend1Character('matt', 970, 500)
        followBFXOffset = -200
        followBFYOffset = 200
    end

    if curStep == 512 then --512
        followDadXOffset = -20--
        followDadYOffset = 20
        --setActorAlpha(1, 'dad1')
        changeDad1Character('mia', 0, 300)
        changeDadCharacter('bana', 200, 210)
    end

    if curStep == 580 then
        followBFYOffset = 150
        followBFXOffset = 75
        setActorAlpha(0, 'boyfriend1')
        changeBoyfriendCharacterBetter(720, 450, 'liz')
        characterZoom('boyfriend', 0.85)
        followBFXOffset = 0
        followBFYOffset = 0
    end

    if curStep == 624 then
        followBFYOffset = 300
        followBFXOffset = 100
        changeBoyfriendCharacterBetter(650, 150, 'garcello')
        changeBoyfriend1Character('drunk-annie', 460, 230)
        followBFXOffset = 100
        followBFYOffset = 150
    end

    if curStep == 644 then --644
        followDadXOffset = 130--
        followDadYOffset = 20
        --setActorAlpha(1, 'dad1')      
        changeDad1Character('agoti', 160, 200)
        changeDadCharacter('tabi', -150, 220)
        characterZoom('dad', 0.85)
        characterZoom('dad1', 0.8)
    end
	
	if curStep == 768 then --768
        followDadXOffset = 130--
        followDadYOffset = 20
        --setActorAlpha(1, 'dad1')      
        changeDad1Character('tom2', 10, 150)
        changeDadCharacter('tord2', -180, 150)
    end
	
	if curStep == 784 then --784
        followBFYOffset = 300
        followBFXOffset = 100
        changeBoyfriendCharacterBetter(650, 150, 'matt2')
        changeBoyfriend1Character('edd2', 420, 150)
        followBFXOffset = 100
        followBFYOffset = 150
    end

    if curStep == 832 then
        followDadYOffset = 30
        followDadXOffset = 90
		setActorAlpha(0, 'dad1')
        changeDadCharacterBetter(0, 380, 'spooky-pixel')
    end

    if curStep == 848 then
        followBFYOffset = 30
        followBFXOffset = -20
		setActorAlpha(0, 'boyfriend1')
        changeBoyfriendCharacterBetter(970, 530, 'gura-amelia-pixel')
    end
	
	if curStep == 864 then --864
        followDadXOffset = 40--
        followDadYOffset = -150
        --setActorAlpha(1, 'dad1')      
        changeDad1Character('bf-botan-pixel', 330, 600)
        changeDadCharacter('bf-pico-pixel', 100, 650)
    end
	
	if curStep == 880 then --880
        followBFYOffset = 300
        followBFXOffset = 100
        changeBoyfriendCharacterBetter(850, 280, 'rosie')
        changeBoyfriend1Character('bf-pixel', 850, 670)
        followBFXOffset = 100
        followBFYOffset = 150
    end
	
	if curStep == 896 then --896
        followDadXOffset = 100--
        followDadYOffset = -20
        --setActorAlpha(1, 'dad1')      
        changeDad1Character('cablecrow', -100, 30)
        changeDadCharacter('zardy', -250, 160)
        characterZoom('dad1', 0.9)
		 characterZoom('dad', 0.9)
    end
        
    -- the arrow shits

    if step == 128 then
        l2 = true
        l2 = false
        l3 = true
    end

    if step == 192 or step == 224 then
        l3 = false
        l4 = true
    end

    if step == 205 or step == 237 then
        l4 = false
        l2 = true
    end

    if step == 208 or step == 240 then
        l2 = false
        for i=0,7 do
            setActorY(_G['defaultStrum'..i..'X'] + 30 , i)
            setActorY(_G['defaultStrum'..i..'Y'] - 50 , i)
        end
    end

    if step == 210 or step == 242 then
        for i=0,7 do
            setActorY(_G['defaultStrum'..i..'Y'], i)
            setActorX(_G['defaultStrum'..i..'X'] - 50, i)     
        end
    end

    if step == 211 or step == 243 then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 50 , i)
        end
    end

    if step == 212 or step == 244 then
        for i=0,7 do
            setActorX(_G['defaultStrum'..i..'X'] + 10, i)
            setActorY(_G['defaultStrum'..i..'Y'] - 50, i)
        end
    end

    if step == 214 or step == 246 then
        l2 = true
    end

    if step == 256 then
        l2 = false
        l1 = true
    end

    if step == 384 then
        l1 = false
        l5 = true
    end

    if step == 448 then
        l5 = false
        l6 = true
    end

    if step == 512 then
        l6 = false
        l2 = true
        l2 = false
        circleArrows = true 
    end

    if step == 640 then
        circleArrows = false
        l2 = true
        l2 = false
        l7 = true
    end

    if step == 768 then
        l7 = false
        l2 = true
        l2 = false
        l8 = true
    end

    if step == 832 then
        l8 = false
        l2 = true
        l2 = false
        circleArrowsCrazy = true
    end

    if step == 872 then
        dadAltAnim = true
    end

    if step == 880 then
        dadAltAnim = false
    end

    if step == 704 or step == 888 then
        bfAltAnim = true
    end

    if step == 706 or step == 896 then
        bfAltAnim = false
    end

    if step == 896 then
        circleArrowsCrazy = false
        l2 = true
    end

    if curStep == 120 or curStep == 248 or curStep == 375 or curStep == 632 or curStep == 696 or curStep == 824 or curStep == 952 or curStep == 1208 then
        for i = 0, 7 do
            tweenPosXAngle(i, _G['defaultStrum'..i..'X'],getActorAngle(i) + 360, 0.3, 'setDefault')
        end
    end
end
