function start (song)
    print("Song: " .. song .. " @ " .. bpm .. " downscroll: " .. downscroll)
     --changeDadCharacter('dad', 150, -75)   
    setActorAlpha(0, 'dad1')
    setActorAlpha(0, 'dad2')
    setActorVisibility(false, 'boyfriend1')
    setActorVisibility(false, 'boyfriend2') 
    setActorVisibility(false, 'rope')
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


end

--default positions
-- changeDadCharacter('dad', 150, -100) 
-- changeBoyfriendCharacter('bf', 1120, 290) 

function stepHit (step)

    if curStep == 1 then --for testing
        
    end

    if curStep == 128 then
        changeDadCharacter('dad', 150, -75) 
    end

    if curStep == 160 then   
        changeBoyfriendCharacter('mom', 1120, -110)
    end

    if curStep == 192 then
        changeDadCharacter('hd-senpai-angry', 150, -75) 
    end

    if curStep == 224 then
        changeDadCharacter('hd-senpai-giddy', 150, -75) 
        changeBoyfriendCharacter('tankman', 1100, 130)
    end

    if curStep == 256 then
        changeDadCharacter('spooky', 70, 135) 
    end

    if curStep == 288 then
        changeBoyfriendCharacter('pico', 1130, 230) 
    end

    if curStep == 320 then
        changeDadCharacter('whitty', 150, -65) 
    end

    if curStep == 384 then
        changeBoyfriendCharacter('bf-carol', 1070, 270) 
    end

    if curStep == 448 then
        changeDadCharacter('hex', 150, -75) 
    end

    if curStep == 512 then
        changeBoyfriendCharacter('sarvente-dark', 1120, -100) 
        followBFXOffset = -150
    end

    if curStep == 576 then 
        followBFXOffset = 0
        changeDadCharacter('jevil', 100, 125)
        changeBoyfriendCharacter('jester', 1150, 170) 
    end

    if curStep == 608 then
        changeDadCharacter('cassandra', 140, -65) 
    end

    if curStep == 624 then 
        changeBoyfriendCharacter('nene2', 1110, 270) 
    end

    if curStep == 640 then
        changeDadCharacter('papyrus', 130, -45) 
    end

    if curStep == 656 then
        changeBoyfriendCharacter('bf-sans', 1120, 290) 
    end

    if curStep == 672 then
        changeDadCharacter('chara', 150, 245) 
    end

    if curStep == 736 then
        changeDadCharacter('cyrix', 150, -55) 
    end

    if curStep == 752 then
        changeBoyfriendCharacter('rebecca', 1100, -120) 
        followBFYOffset = 100
    end

    if curStep == 768 then 
        changeDadCharacter('botan', 80, 185) 
    end

    if curStep == 784 then
        followBFYOffset = 0
        changeBoyfriendCharacter('henry', 1080, -170) 
    end

    if curStep == 800 then
        changeDadCharacter('kou', 160, 205)
    end
    
    if curStep == 864 then
        changeDadCharacter('trollge', 130, -30) 
    end

    if curStep == 992 then
        changeBoyfriendCharacter('opheebop', 1140, 50) 
    end

    if curStep == 1120 then
        changeDadCharacter('hubert', 180, -75) 
    end

    if curStep == 1184 then
        changeBoyfriendCharacter('lane', 1120, 240) 
    end

    if curStep == 1248 then
        changeDadCharacter('neko-crazy', 40, 185) 
    end

    if curStep == 1312 then
        changeBoyfriendCharacter('tord', 1130, 50) 
    end

    if curStep == 1376 then
        changeDadCharacter('tabi', 140, -85) 
    end

    if curStep == 1440 then
        changeBoyfriendCharacter('bf-exgf', 980, -125)
    end

    if curStep == 1504 then
        changeDadCharacter('tornsketchy', 60, 115) 
    end

    if curStep == 1568 then
        changeBoyfriendCharacter('blantad-watch', 1170, -30) 
    end

    if curStep == 1632 then
        changeDadCharacter('zardy', -7, -95) 
    end

    if curStep == 1760 then
        changeBoyfriendCharacter('garcello', 880, -70) 
    end

    if curStep == 1888 then
        changeDadCharacter('bf-annie', 100, 265) 
    end

    if curStep == 1920 then
        changeBoyfriendCharacter('updike', 1070, -60) 
    end

    if curStep == 1952 then
        changeDadCharacter('ruby', 200, -65) 
    end

    if curStep == 1984 then
        changeBoyfriendCharacter('cj', 1150, -60) 
    end

    if curStep == 2016 then
        changeDadCharacter('ridzak', 80, 235)
    end

    if curStep == 2032 then
        changeBoyfriendCharacter('tom', 1130, 50) 
    end

    if curStep == 2048 then
        changeDadCharacter('miku', 120, -65) 
    end

    if curStep == 2064 then
        changeBoyfriendCharacter('neon-bigger', 1280, 200) 
    end

    if curStep == 2080 then
        changeDadCharacter('anders', 140, -35) 
    end

    if curStep == 2084 then
        changeBoyfriendCharacter('bob', 950, 230) 
    end

    if curStep == 2088 then
        changeDadCharacter('hd-monika', 150, -45) 
    end

    if curStep == 2092 then
        changeBoyfriendCharacter('ruv', 1150, -150) 
    end

    if curStep == 2096 then
        changeDadCharacter('kapi', 150, -115) 
    end

    if curStep == 2100 then
        changeBoyfriendCharacter('anchor', 1120, -110) 
    end

    if curStep == 2104 then
        changeDadCharacter('impostor', 50, 335)
    end

    if curStep == 2108 then
        changeBoyfriendCharacter('roro', 920, -50) 
    end

    if curStep == 2112 then
        changeDadCharacter('sanford', 80, 235)
        changeBoyfriendCharacter('dr-springheel', 1010, -130) 
    end

    if curStep == 2128 then
        changeDadCharacter('exTricky', -150, -265)
        playActorAnimation('dad', 'Hank', true, false)
    end

    -- triples start here

    if curStep == 2144 then
        setActorAlpha(1, 'dad1')
        setActorAlpha(1, 'dad2')  
        followDadXOffset = 150
        --gf escape
        setActorVisibility(false, 'gf')
        setActorVisibility(true, 'rope')
        newIcons = true
        swapIcons = false
    end

    if curStep == 2176 then
        setActorVisibility(true, 'boyfriend1')
        setActorVisibility(true, 'boyfriend2')   
        followBFXOffset = 100
    end

    if curStep == 2144 then
        changeDadCharacter('dad', -100, -75) 
        changeDad1Character('mom', 350, -110) 
        changeDad2Character('bf-gf', 150, 290) 
        updateHealthbar('FFAF66CE', 'FFAF68CE')
        changeDadIconNew('dearest-trio')
    end

    if curStep == 2176 then
        changeBoyfriendCharacter('bf-dad', 920, -75)
        changeBoyfriend1Character('bf-mom', 1370, -110)
        changeBoyfriend2Character('bf', 1120, 290) 
        updateHealthbar('FFAF66CE', 'FF0EAEFE')
        changeBFIconNew('bf-trio')
    end

    if curStep == 2208 then
        changeDadCharacter('monster', -170, 25) 
        changeDad1Character('lila', 350, -75) 
        changeDad2Character('spooky', 70, 135) 
        updateHealthbar('FF725585', 'FF0EAEFE')
        changeDadIconNew('spooky-trio')
    end

    if curStep == 2240 then
        changeBoyfriendCharacter('pico', 870, 230)
        changeBoyfriend1Character('cassandra', 1370, -55)
        changeBoyfriend2Character('nene2', 1110, 270) 
        updateHealthbar('FF725585', 'FFB7D855')
        changeBFIconNew('pico-trio')
    end

    if curStep == 2272 then
        changeDadCharacter('hd-senpai-angry', -80, -75) 
        changeDad1Character('hd-monika', 350, -60) 
        changeDad2Character('tankman', 150, 130) 
        changeDadIconNew('senpai-trio')
        updateHealthbar('FFFFAA6F', 'FFB7D855')
    end

    if curStep == 2304 then
        changeBoyfriendCharacter('whitty', 1120, -75)
        changeBoyfriend1Character('bf-carol', 1280, 280) 
        changeBoyfriend2Character('sunday', 920, 190) 
        updateHealthbar('FFFFAA6F', 'FF1D1E35')
        changeBFIconNew('whitty-trio')
    end

    if curStep == 2336 then
        changeDadCharacter('tabi', -80, -65) 
        changeDad1Character('bf-exgf', 350, -125) 
        changeDad2Character('neko-crazy', 40, 205) 
        updateHealthbar('FFFFD779', 'FF1D1E35')
        changeDadIconNew('ex-trio')
    end

    if curStep == 2368 then
        changeBoyfriendCharacter('hex', 920, -75)
        changeBoyfriend1Character('cyrix', 1370, -55)
        changeBoyfriend2Character('static', 1120, -75) 
        updateHealthbar('FFFFD779', 'FF434050')
        changeBFIconNew('robo-trio')
    end

    if curStep == 2400 then
        changeDadCharacter('garcello', -160, -70) 
        changeDad1Character('updike', 270, -70) 
        changeDad2Character('bf-annie', 100, 265) 
        updateHealthbar('FF8E40A5', 'FF434050')
        changeDadIconNew('calm-trio')
    end

    if curStep == 2416 then
        changeBoyfriendCharacter('cj', 920, -65)
        changeBoyfriend1Character('ruby', 1370, -65)
        changeBoyfriend2Character('ridzak', 1130, 235) 
        updateHealthbar('FF8E40A5', 'FF0244EF')
        changeBFIconNew('cj-trio')
    end

    if curStep == 2432 then
        changeDadCharacter('hubert', -70, -75) 
        changeDad1Character('starecrown', 230, -125) 
        changeDad2Character('trollge', 130, -30) 
        updateHealthbar('FFB5B5B5', 'FF0244EF')
        changeDadIconNew('scary-trio')
    end

    if curStep == 2448 then
        changeBoyfriendCharacter('cheeky', 1150, 270) 
        changeBoyfriend1Character('opheebop', 1370, 60)
        changeBoyfriend2Character('bob', 770, 230)
        updateHealthbar('FFB5B5B5', 'FFA4DCF4')
        changeBFIconNew('round-trio')
    end

    if curStep == 2464 then
        changeDadCharacter('papyrus', 130, -45) 
        changeDad1Character('bf-sans', -50, 300) 
        changeDad2Character('chara', 350, 245) 
        updateHealthbar('FFFF0000', 'FFA4DCF4')
        changeDadIconNew('under-trio')
    end

    if curStep == 2480 then
        changeBoyfriendCharacter('henry', 1080, -170) 
        changeBoyfriend1Character('jevil', 1330, 135) 
        changeBoyfriend2Character('impostor', 720, 345) 
        updateHealthbar('FFFF0000', 'FFE1E1E1')
        changeBFIconNew('danger-trio')
    end

    if curStep == 2496 then
        changeDadCharacter('roro', -250, -75) 
        changeDad1Character('anchor', 390, -110) 
        changeDad2Character('alya', 180, 290) 
        updateHealthbar('FF4E6575', 'FFE1E1E1')
        changeDadIconNew('sea-trio')
    end

    if curStep == 2512 then
        changeBoyfriendCharacter('coco', 1120, -110)
        changeBoyfriend1Character('gura-amelia', 1280, 135) 
        changeBoyfriend2Character('bf-aloe', 920, 290) 
        updateHealthbar('FF4E6575', 'FFE67A34')
        changeBFIconNew('holo-trio')
    end

    if curStep == 2528 then
        changeDadCharacter('ruv', -200, -150) 
        changeDad1Character('sarvente-dark', 250, -100) 
        changeDad2Character('selever', 0, -120) 
        updateHealthbar('FF96224F', 'FFE67A34')
        changeDadIconNew('holy-trio')
    end

    if curStep == 2544 then
        changeBoyfriendCharacter('anders', 750, -35)
        changeBoyfriend1Character('dr-springheel', 1240, -130) 
        changeBoyfriend2Character('botan', 1060, 205) 
        updateHealthbar('FF96224F', 'FF7DA8C5') 
        changeBFIconNew('weapon-trio')
    end

    if curStep == 2560 then
        changeDadCharacter('matt2', -200, -70) 
        changeDad1Character('edd2', 150, -70) 
        changeDad2Character('tom2', 0, -70) 
        updateHealthbar('FF265D86', 'FF7DA8C5') 
        changeDadIconNew('edd-trio')
    end

    if curStep == 2576 then
        changeBoyfriendCharacter('pompom', 870, 140)
        changeBoyfriend1Character('jester', 1370, 170)
        changeBoyfriend2Character('kou', 1110, 205) 
        updateHealthbar('FF265D86', 'FFF14CF1') 
        changeBFIconNew('short-trio')
    end

    if curStep == 2592 then
        changeDadCharacter('blantad-watch', -90, -35) 
        changeDad1Character('rebecca', 350, -120) 
        changeDad2Character('tornsketchy', 60, 115) 
        updateHealthbar('FF64B3FE', 'FFF14CF1') 
        changeDadIconNew('artist-trio')
    end

    if curStep == 2608 then
        changeBoyfriendCharacter('glitch', 1030, 200)
        changeBoyfriend1Character('neon-bigger', 1530, 200)
        changeBoyfriend2Character('bf-kapi-pixel', 1250, 410) 
        characterZoom('boyfriend2', 6.5)
        updateHealthbar('FF64B3FE', 'FF0DA554') 
        changeBFIconNew('pixel-trio')
    end

    if curStep == 2624 then
        changeDadCharacter('ron', -90, 195) 
        changeDad1Character('phil', 350, 265) 
        changeDad2Character('little-man', 250, 565) 
        updateHealthbar('FFFFFFFF', 'FF0DA554') 
        changeDadIconNew('little-trio')
    end

    if curStep == 2640 then
        changeBoyfriendCharacter('shaggy', 950, -60)
        changeBoyfriend1Character('zardy', 1170, -95)
        changeBoyfriend2Character('matt', 1120, 260) 
        updateHealthbar('FFFFFFFF', 'FF2C253B')
        changeBFIconNew('god-trio') 
    end

    -- triples end here

    if curStep == 2656 then
        setActorAlpha(0, 'dad1')
        setActorAlpha(0, 'dad2')      
        followDadXOffset = 0
        newIcons = false
    end

    if curStep == 2688 then
        setActorVisibility(false, 'boyfriend1')
        setActorVisibility(false, 'boyfriend2')  
        followBFXOffset = 0 
    end

    if curStep == 2656 then 
        changeDadCharacter('bob2', 180, 5) 
        updateHealthbar('FFEBDD44', 'FF2C253B') 
        changeDadIcon('bob2')
    end

    if curStep == 2688 then
        changeBoyfriendCharacter('bosip', 1150, -100)
    end

    if curStep == 2720 then
        changeDadCharacter('starecrown', -13, -125) 
    end

    if curStep == 2752 then
        changeBoyfriendCharacter('mackiepom', 1100, -70)
    end

    if curStep == 2784 then
        changeDadCharacter('liz', 160, 225) 
    end

    if curStep == 2816 then
        changeBoyfriendCharacter('lila', 1120, -60)
    end

    if curStep == 2848 then
        changeDadCharacter('matt', 200, 250) 
    end

    if curStep == 2880 then
        changeBoyfriendCharacter('shaggy', 1150, -60)
    end

end

function dadNoteHit()

end
