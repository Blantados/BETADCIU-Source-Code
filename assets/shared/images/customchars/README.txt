I have added a feature that allows you to add your own custom characters to the game. Just follow the existing template to add a character! Don't forget their icon since the game crashes without it. 

Offsets in code are all set to 0. Still working on finding a way to read offsets from a JSON or smthn. For now, just manually edit the xml.

XML EDITING GUIDE:
FrameX = If number goes up, character moves left. If number goes down, character moves right.
FrameY = If number goes up, character moves up. If number goes down, character moves down.
FrameWidth = If number goes up, camera moves right. If number goes down, camera moves left.
FrameHeight = If number goes up, camera moves down. If number goes down, camera moves up.

(Doesn't work for Pixel Characters, which is fine for Pixel BF since his offsets are normally 0, but you may have to edit your .png a bit for Senpai)

Character naming procedure:
PNG File - charactername_assets.png (make sure character name is all lowercase)
.xml File - charactername_assets.xml (same thing)

Animation Names (Set your .xml animation names to these):

Idle - Idle
Up - Up
Down - Down
Left - Left
Right - Right

If your character has alt animations:

Idle-Alt - Idle-Alt
Up-Alt - Up-Alt
Down-Alt - Down-Alt
Left-Alt - Left-Alt
Right-Alt - Right-Alt


