function start (song)

end

function update (elapsed)
    local currentBeat = (songPos / 1000)*(bpm/60)
  
end

function beatHit (beat)

   
end

function stepHit (step)

    --leaving this here to test stuff
    if curStep == 1 then
        
    end

    if curStep == 320 then
        changeDadCharacter('impostor2', 50, 500)
        changeBoyfriendCharacter('henry-angry', 920, 380)
    end

    if curStep == 352 then
        changeDadCharacter('richard1', -200, 100)
        changeBoyfriendCharacter('sunday', 860, 370)
    end

    if curStep == 384 then
        changeDadCharacter('bob2', 170, 160)
        changeBoyfriendCharacter('bosip', 800, 60)
    end

    if curStep == 446 then
        changeDadCharacter('eteled2', 100, 300)
        changeBoyfriendCharacter('austin', 670, 0)
    end

    if curStep == 512 then
        changeDadCharacter('oswald-happy', 30, 300)
        changeBoyfriendCharacter('bf', 770, 450)
    end

    if curStep == 562 then
        changeDadCharacter('skye', -150, 70)
        changeBoyfriendCharacter('little-man', 930, 720)
    end

    if curStep == 624 then
        changeDadCharacter('nyancat', 0, 100)
        changeBoyfriendCharacter('dust-sans', 530, 50)
    end

    if curStep == 672 then
        changeBoyfriendCharacter('bf', 770, 450)
    end

    if curStep == 688 then
        changeDadCharacter('sadmouse', 50, 140)     
    end

    if curStep == 720 then
        changeBoyfriendCharacter('exe', 740, 250)
    end

    if curStep == 752 then
        changeDadCharacter('doxxie', 130, 420)
        changeBoyfriendCharacter('bf-carol', 760, 450)
    end

    if curStep == 816 then
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