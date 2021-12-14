local originalScroll = 0

function start(song)
    showOnlyStrums = true;
    strumLine1Visible = false;
    strumLine2Visible = false;
    setActorAlpha(0, 'bluescreen', true)

    -- to check da original scroll
    if downscroll == true then
        originalScroll = 0
    else
        originalScroll = 1
    end
end

function update(elapsed)

    if tallDad then
        followDadYOffset = -100
    end

    if tallBF then
        followBFYOffset = -50
    end

    if reset then
        followBFYOffset = 0
        followDadYOffset = 0
    end

end

local randomX = 0
local randomY = 0
local whereStrum = 0

function beatHit(beat)
    if (beat >= 64) then
        showOnlyStrums = false;
        strumLine1Visible = true;
        strumLine2Visible = true;
    end

    if curBeat == 64  or curBeat == 256 or curBeat == 384 or curBeat == 544 then
        followDadYOffset = 0
        followBFYOffset = 0
        setDefaultCamZoom(0.8)
    end

    if curBeat == 255 or curBeat == 316 or curBeat == 830 then
        setDefaultCamZoom(1.7)
    end

    if curBeat == 320 or curBeat == 480 or curBeat == 608 or curBeat == 847 then
        followDadYOffset = 0
        followBFYOffset = 0
        setDefaultCamZoom(0.55)
    end

    if curBeat == 831 then
        followDadYOffset = -200
        followDadXOffset = 50
    end

    if curBeat >= 831 and curBeat < 848 or curBeat >= 316 and curBeat < 320 then
        playActorAnimation('gf', 'scared', true, false)
    end

    if curBeat == 831 or curBeat == 316 then
        stopGFDance(true)
    end

    if curBeat == 848 or curBeat == 320 then
        stopGFDance(false)
    end

    if curBeat == 772 or curBeat == 775 then
        setActorAlpha(1, 'bluescreen', true)
    end

    if curBeat == 773 or curBeat == 776 then
        setActorAlpha(0, 'bluescreen', true)
    end
    
end

function stepHit(step)

    if curStep == 1 then        
       
    end

    if curStep == 380 then
        followDadYOffset = -100
        changeDadCharacter('midas-double', 0, 190)
    end

    if curStep == 444 then
        followBFYOffset = -100
        changeBoyfriendCharacter('skye', 550, 150)
    end

    if curStep == 512 then
        changeDadCharacter('retro', 0, 130)
    end

    if curStep == 576 then
        changeBoyfriendCharacter('coco', 770, 160)
    end

    if curStep == 640 then
        changeDadCharacter('tabi-crazy', -55, 230)
    end

    if curStep == 704 then
        changeBoyfriendCharacter('whittyCrazy', 670, 200)
    end

    if curStep == 760 then
        changeDadCharacter('calli', -10, 190)
    end

    if curStep == 824 then 
        changeBoyfriendCharacter('gold-side', 820, 270)
    end

    if curStep == 896 then
        followDadYOffset = 0
        followBFYOffset = 0
        changeDadCharacter('bf-nene-scream', -50, 480)
        changeBoyfriendCharacter('bf-aloe', 830, 540)
    end

    if curStep == 1020 then
        playActorAnimation('dad', 'scream', true, false)
    end

    if curStep == 1024 then
        followDadYOffset = -100   
        changeGFCharacter('gf-nene', 250, 220)
        changeDadCharacter('peri', -85, 220)
    end

    if curStep == 1056 then
        followBFYOffset = -100
        changeGFCharacter('gf-nene-aloe', 250, 220)
        changeBoyfriendCharacter('hd-senpai-angry', 770, 190)
    end

    if curStep == 1088 then
        followBFYOffset = 0
        changeDadCharacter('tankman', -55, 390)   
        changeBoyfriendCharacter('hd-senpai-giddy', 770, 190)
    end

    if curStep == 1120 then
        followBFYOffset = 0
        changeBoyfriendCharacter('pico', 790, 490)
    end

    if curStep == 1152 then
        followDadYOffset = -100
        changeDadCharacter('blantad-scream', -55, 190)
    end

    if curStep == 1216 then
        changeBoyfriendCharacter('neonight', 670, 320)
    end

    if curStep == 1264 then
        followDadYOffset = -300
        followDadXOffset = 100
    end

    if curStep == 1280 then
        changeBoyfriendCharacter('ina2', 620, 150)
        updateHealthbar('FF0015FE', '')
    end

    if curStep == 1312 then
        changeDadCharacter('gura-amelia', -155, 390)
    end

    if curStep == 1344 then
        changeBoyfriendCharacter('bf-tc', 770, 320)
    end

    if curStep == 1376 then
        changeDadCharacter('garcello', -155, 190) 
    end

    if curStep == 1408 then
        changeDadCharacter('kb', -235, 190)
    end

    if curStep == 1472 then
        changeBoyfriendCharacter('cablecrow', 530, 20)
    end

    if curStep == 1532 then
        followDadYOffset = 0
        changeDadCharacter('sonic-forced', -140, 370)
    end

    if curStep == 1664 then
        followBFYOffset = 0
        changeDadCharacter('kapi', 0, 170)
        changeBoyfriendCharacter('tails', 650, 350)
    end

    if curStep == 1696 then
        changeDadCharacter('momi', -125, 250)
    end

    if curStep == 1728 then
        changeDadCharacter('nyancat', -145, 300)
    end

    if curStep == 1760 then
        changeDadCharacter('botan', -130, 430)
    end

    if curStep == 1792 then       
        followBFYOffset = -100 
        changeBoyfriendCharacter('rshaggy', 820, 190)
    end

    if curStep == 1824 then
        followDadYOffset = -100
        changeDadCharacter('nonsense-mad', 65, 310)
    end

    if curStep == 1856 then
        followBFYOffset = 0
        changeBoyfriendCharacter('natsuki', 770, 365)
    end

    if curStep == 1888 then
        followDadYOffset = 0
        changeDadCharacter('impostor', -155, 580)
    end

    if curStep == 1920 then
        changeDadCharacter('bf-cesar-scream', -105, 490)
        changeBoyfriendCharacter('geese', 650, 170)
    end

    if curStep == 1984 then
        changeDadCharacter('bf-sticky', 100, 540)
        changeBoyfriendCharacter('amor', 780, 240)
        characterZoom('boyfriend', 0.83)
    end

    if curStep == 2048 then
        changeDadCharacter('exe', 50, 350)
    end

    if curStep == 2080 then
        changeBoyfriendCharacter('maijin', 600, 310)
    end

    if curStep == 2112 then
        changeDadCharacter('zipper', -80, 210)
    end

    if curStep == 2144 then
        changeBoyfriendCharacter('sayori', 850, 270)
    end

    if curStep == 2176 then
        changeDadCharacter('snow', -105, 320)
        changeBoyfriendCharacter('foks', 820, 570)
    end

    if curStep == 2232 then
        followDadYOffset = -100
        followBFYOffset = -100
        changeDadCharacter('monika-real', -105, 200)
        characterZoom('dad', 0.9)
        changeBoyfriendCharacter('ruby', 820, 200)
    end

    if curStep == 2304 then
        changeDadCharacter('rosie', -90, 290)
        changeBoyfriendCharacter('updike', 730, 210)
    end

    if curStep == 2360 then
        changeDadCharacter('mel', -90, 210)
        changeBoyfriendCharacter('yuri', 840, 210)
        characterZoom('boyfriend', 0.95)
    end

    if curStep == 2432 then
        changeDadCharacter('mami-holy', -345, 170)
        characterZoom('dad', 0.9)
    end

    if curStep == 2496 then
        changeBoyfriendCharacter('kalisa', 580, 330)
        characterZoom('boyfriend', 1.1)
    end

    if curStep == 2560 then
        changeDadCharacter('miku', -105, 190)
    end

    if curStep == 2624 then --using this one so less lag
        changeBoyfriendCharacter('bf-updike', 780, 540)
    end 

    if curStep == 2688 then
        changeDadCharacter('alucard', -55, 250)    
    end

    if curStep == 2720 then
        changeBoyfriendCharacter('yukichi-mad', 650, 200)
        characterZoom('boyfriend', 0.9)
    end

    if curStep == 2752 then
        changeDadCharacter('woody', 0, 580)
        characterZoom('dad', 1.2)
    end

    if curStep == 2784 then
        changeBoyfriendCharacter('calebcity', 850, 580)
        characterZoom('boyfriend', 1.2)
    end

    if curStep == 2816 then
        changeDadCharacter('dad', 0, 190)   
    end

    if curStep == 2880 then
        changeBoyfriendCharacter('haachama', 800, 300)
    end

    if curStep == 2944 then
        changeDadCharacter('lucian', -75, 140)
    end

    if curStep == 3008 then
        changeBoyfriendCharacter('abby-mad', 730, 470)
    end

    if curStep == 3068 then
        changeDadCharacter('hex-virus', 30, 300)   
    end

    if curStep == 3104 then
        changeBoyfriendCharacter('cyrix-crazy', 730, 150)
        characterZoom('boyfriend', 1)
    end

    if curStep == 3136 then
        changeDadCharacter('auditor', -305, 150)  
    end

    if curStep == 3168 then
        changeBoyfriendCharacter('cjClone', 800, 230)
    end

    if curStep == 3200 then
        changeDadCharacter('tricky', -135, 270)  
    end

    if curStep == 3232 then
        changeBoyfriendCharacter('hank', 750, 370)
    end

    if curStep == 3264 then
        changeDadCharacter('bipolarmouse', -85, 250)
        changeBoyfriendCharacter('oswald-angry', 850, 440)
    end
    
end

function dadNoteHit()

    if curStep < 380 then
        shakeCam(0.0125, 0.1)
		shakeHUD(0.005, 0.1)
    end

    --for scream characters without special animations/sounds, i just gave their push back some extra power
    if curStep == 1040 or curStep == 1041 or curStep == 1052 then 
        shakeCam(0.1, 0.1)
    end

    if curStep == 2688 or curStep == 2704 or curStep == 2705 or curStep == 2716 then

        randomX = generateNumberFromRange(-700, 200)

        if downscroll == true then
            randomY = generateNumberFromRange(100, -600)
        else
            randomY = generateNumberFromRange(-100, 600)
        end
       
        for i = 4,7 do 
            setActorX(_G['defaultStrum'..i..'X'] + randomX, i)
            setActorY(_G['defaultStrum'..i..'Y'] + randomY, i)
        end

        whereStrum = getPlayerStrumsY(4)

        print(whereStrum)

        if whereStrum >= 360 then
            setDownscroll(true)
        end

        if whereStrum < 360 then
            setDownscroll(false)
        end

    end

    if curStep == 2768 then
        for i= 4,7 do
            setActorX(_G['defaultStrum'..i..'X'], i)
            setActorY(_G['defaultStrum'..i..'Y'], i)
        end

        if originalScroll == 0 then
            setDownscroll(true)
        else
            setDownscroll(false)
        end 
    end
   
end