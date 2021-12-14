function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
  
    if curStep >= 624 and curStep < 632 then
        changeStaticNotes('nyan', 'nyan')
    end

    if curStep >= 688 and curStep < 692 then
        changeStaticNotes('1930', '1930')
    end

    if spin then
        setActorX(dadX + 50 * math.sin((currentBeat * 0.5) * math.pi), 'dad')
        setActorY(dadY - 50 * math.cos((currentBeat * 0.5) * math.pi), 'dad')
    end

    if moveRocks then
        setActorY(gfY - 25 * math.cos((currentBeat * 0.5) * math.pi), 'gf')
        setActorY(gfrockY - 25 * math.cos((currentBeat * 0.5) * math.pi), 'gfRock', true)
        setActorY(bfY - 25 * math.cos((currentBeat * 0.5) * math.pi), 'boyfriend')
        setActorY(bfrockY - 25 * math.cos((currentBeat * 0.5) * math.pi), 'bfRock', true)
    end
end

function beatHit (beat)

   
end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then
        setupNoteSplash('-normal')
    end

    if curStep == 320 then
        changeStage('polus2')
        changeGFCharacter('gf-ghost', 206, -206.7)
        changeDadCharacter('impostor2', -169.55, 264.9)
        changeBoyfriendCharacter('henry-angry', 900, 150)
        setActorAlpha(0, 'deadBF', true)      
    end

    if curStep == 352 then
        changeStage('airplane1')
        changeGFCharacter('gf-nospeaker', 850, 230)
        changeDadCharacter('richard1', -50, 100)
        changeBoyfriendCharacter('sunday', 1210, 410)
    end

    if curStep == 384 then
        changeStage('day')
        changeGFCharacter('gf', 330, 80)
        changeDadCharacter('bob2', 20, 150)
        changeBoyfriendCharacter('bosip', 990, 40)
    end

    if curStep == 446 then
        changeStage('hallway')
        changeGFCharacter('gf-mii', 580, 110)
        changeDadCharacter('eteled2', 100, 320)
        changeBoyfriendCharacter('austin', 1105,5)
        setupNoteSplash('-austin')
    end

    if curStep == 512 then
        changeStage('stage')
        changeGFCharacter('gf-judgev2', 450, 210)
        changeDadCharacter('oswald-happy', 30, 300)
        changeBoyfriendCharacter('bf', 770, 450)
        setupNoteSplash('-normal')
    end

    if curStep == 562 then
        changeStage('sofdeez')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('skye', -400, 70)
        changeBoyfriendCharacter('little-man', 1160, 720)
        followBFYOffset = -100
        setupNoteSplash('-white')
    end

    if curStep == 624 then
        followBFYOffset = 0
        changeStage('nyan')
        changeGFCharacter('gf', 400, 130)
        changeDadCharacter('nyancat', -100, 300)
        changeBoyfriendCharacter('dust-sans', 530, 50) 
        followDadYOffset = 50
    end

    if curStep == 624 then -- da floaty thingamajigs
        dadX = getActorX('dad')
        dadY = getActorY('dad')
        gfY = getActorY('gf')
        gfrockY = getActorY('gfRock', true)
        bfY = getActorY('boyfriend')
        bfrockY = getActorY('bfRock', true)
        moveRocks = true
        spin = true
        setupNoteSplash('-nyan')
    end

    if curStep == 672 then
        spin = false
        moveRocks = false
        changeStage('stage')
        changeGFCharacter('gf-judgev2', 450, 210)
        changeBoyfriendCharacter('bf', 770, 450)
        followDadYOffset = 0
        setupNoteSplash('-normal')
    end

    if curStep == 688 then
        changeStage('street1') 
        changeGFCharacter('gf-bw2', 400, 130)
        changeDadCharacter('sadmouse-bw', 50, 140)  
        changeBoyfriendCharacter('bf-bw2', 770, 450)  
        updateHealthbar('', 'FFB0B0B0') 
        changeStaticNotes('1930', '1930')
        setupNoteSplash('-1930')
    end

    if curStep == 720 then
        changeBoyfriendCharacter('exe-bw', 740, 250)
        changeStaticNotes('1930', '1930')
    end

    if curStep == 752 then
        changeStage('bfroom')
        changeGFCharacter('gf-nospeaker', 1050, 70)
        changeDadCharacter('doxxie', 100, 200)
        changeBoyfriendCharacter('bf-carol', 805, 240)
        setupNoteSplash('-normal')
    end

    if curStep == 816 then
        changeStage('stage')
        changeGFCharacter('gf-judgev2', 450, 210)
        changeDadCharacter('oswald-angry', 30, 300)
        changeBoyfriendCharacter('bf', 770, 450)
    end

    --all the oswald stuff

    if curStep == 104 then
        playActorAnimation('dad', 'lucky', true, false)
    end

    if curStep == 376 or curStep == 512 then
        addCamZoom(0.3)
    end

    if curStep == 545 then
        playActorAnimation('dad', 'oldtimey', true, false)
    end

    if curStep == 546 then
        playActorAnimation('gf', 'spooked', true, false)
    end

    if curStep == 560 then
        playActorAnimation('gf', 'danceLeft', true, false)
    end

    if curStep == 672 then
        changeDadCharacter('oswald-angry', 30, 300)
        playActorAnimation('dad', 'notold', true, false)
        addCamZoom(0.05);
    end

    if curStep == 676 then
        addCamZoom(0.1);
    end

    if curStep == 680 then
        addCamZoom(0.15);
    end

    if curStep == 684 then
        addCamZoom(0.01);
        shakeCam(0.05, 0.5)
    end

    if curStep == 688 then
        addCamZoom(0.015)
    end

    if curStep == 831 then
        playActorAnimation('dad', 'hah', true, false)
    end
end

function dadNoteHit()

end