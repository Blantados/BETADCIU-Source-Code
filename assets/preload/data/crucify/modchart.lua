function start (song) -- do nothing

end

function update (elapsed)
if curStep >= 0 and curStep < 12 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end

if curStep == 896 and curStep < 904 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		tweenPosXAngle(i, _G['defaultStrum'..i..'X'], 0, 0.6, 'setDefault')
		tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.6, 'setDefault')
end
end

if curStep == 1528 then
strumLine1Visible = false

end

if curStep == 1558 then
strumLine1Visible = true

end


if curStep >= 128 and curStep < 624 or curStep >= 1152 and curStep < 1648 then
local currentBeat = (songPos / 1000)*(bpm/120)
		for i=0,3 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
		end
		end

if curStep >= 640 and curStep < 896 or curStep >= 1664 and curStep < 2176 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end	
	end



if curStep >= 1024 and curStep < 1154 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorY(_G['defaultStrum'..i..'Y'] + 25 * math.cos((currentBeat + i*5) * math.pi), i)
	end
	end



if curStep >= 12 and curStep < 16 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 16 and curStep < 28 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 28 and curStep < 32 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 32 and curStep < 44 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 44 and curStep < 48 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end

if curStep >= 48 and curStep < 60 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 60 and curStep < 64 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 64 and curStep < 76 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 76 and curStep < 80 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 80 and curStep < 92 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 92 and curStep < 96 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 96 and curStep < 108 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 108 and curStep < 112 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end

if curStep >= 112 and curStep < 124 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 124 and curStep < 126 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 118 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep == 264 or curStep == 280 or curStep == 296 or curStep == 312 then
setHudZoom(1.1)

	end


if curStep == 646 or curStep == 652 or curStep == 658 or curStep == 660 or curStep == 666 or curStep == 672 or curStep == 678 or curStep == 684 or curStep == 690 or curStep == 692 or curStep == 698 or curStep == 704 or curStep == 710 or curStep == 716 or curStep == 722 or curStep == 724 or curStep == 730 or curStep == 736 or curStep == 742 or curStep == 748 or curStep == 754 or curStep == 756 or curStep == 762 then
setCamZoom(0.62)

	end

if curStep == 648 or curStep == 664 or curStep == 680 or curStep == 696 or curStep == 712 or curStep == 728 or curStep == 744 or curStep == 760 then
setCamZoom(0.62)

	end

if curStep == 768 or curStep == 774 or curStep == 780 or curStep == 786 or curStep == 788 or curStep == 794 or curStep == 800 or curStep == 806 or curStep == 812 or curStep == 818 or curStep == 820 or curStep == 826 or curStep == 832 or curStep == 838 or curStep == 844 or curStep == 850 or curStep == 852 or curStep == 858 or curStep == 864 or curStep == 870 or curStep == 876 then
setCamZoom(0.62)

	end

if curStep == 776 or curStep == 792 or curStep == 808 or curStep == 824 or curStep == 840 or curStep == 856 or curStep == 872 then
setHudZoom(1.1)

	end


if curStep == 328 or curStep == 344 or curStep == 360 then
setCamZoom(0.62)

	end


if curStep == 640 or curStep == 1664 then
setHudZoom(1.1)
setCamZoom(0.65)
showOnlyStrums = true

	end

if curStep == 896 or curStep == 2176 then
setHudZoom(1.1)
setCamZoom(0.65)
showOnlyStrums = false

	end


if curStep == 1164 then
setCamPosition(5,5)
end

if curStep == 1165 then
setCamPosition(-5,-5)
end

if curStep == 1166 then
setCamPosition(10,10)
end

if curStep == 1167 then
setCamPosition(-10,-10)
end

if curStep == 1168 then
setCamPosition(0,0)
end



if curStep == 1180 then
setCamPosition(5,5)
end

if curStep == 1181 then
setCamPosition(-5,-5)
end

if curStep == 1182 then
setCamPosition(10,10)
end

if curStep == 1183 then
setCamPosition(-10,-10)
end

if curStep == 1184 then
setCamPosition(0,0)
end


if curStep == 1212 then
setCamPosition(5,5)
end

if curStep == 1213 then
setCamPosition(-5,-5)
end

if curStep == 1214 then
setCamPosition(10,10)
end

if curStep == 1215 then
setCamPosition(-10,-10)
end

if curStep == 1216 then
setCamPosition(0,0)
end



if curStep == 1228 then
setCamPosition(5,5)
end

if curStep == 1229 then
setCamPosition(-5,-5)
end

if curStep == 1230 then
setCamPosition(10,10)
end

if curStep == 1231 then
setCamPosition(-10,-10)
end

if curStep == 1232 then
setCamPosition(0,0)
end



if curStep == 1244 then
setCamPosition(5,5)
end

if curStep == 1245 then
setCamPosition(-5,-5)
end

if curStep == 1246 then
setCamPosition(10,10)
end

if curStep == 1247 then
setCamPosition(-10,-10)
end

if curStep == 1248 then
setCamPosition(0,0)
end


if curStep == 1276 then
setCamPosition(5,5)
end

if curStep == 1277 then
setCamPosition(-5,-5)
end

if curStep == 1278 then
setCamPosition(10,10)
end

if curStep == 1279 then
setCamPosition(-10,-10)
end

if curStep == 1280 then
setCamPosition(0,0)
end


 
if curStep == 1288 or curStep == 1304 or curStep == 1320 or curStep == 1336 or curStep == 1352 or curStep == 1368 or curStep == 1384 then
setHudZoom(1.1)

	end



if curStep == 1672 or curStep == 1688 or curStep == 1704 or curStep == 1720 or curStep == 1736 or curStep == 1752 or curStep == 1784 or curStep == 1800 or curStep == 1816 or curStep == 1832 or curStep == 1848 or curStep == 1864 or curStep == 1880 or curStep == 1896 or curStep == 1928 or curStep == 1944 or curStep == 1960 or curStep == 1976 or curStep == 1992 or curStep == 2008 or curStep == 2024 or curStep == 2040 or curStep == 2056 or curStep == 2072 or curStep == 2088 or curStep == 2104 or curStep == 2120 or curStep == 2136 or curStep == 2152 or curStep == 2168 then
setHudZoom(1.1)

	end



if curStep == 1664 or curStep == 1670 or curStep == 1676 or curStep == 1682 or curStep == 1684 or curStep == 1690 or curStep == 1696 or curStep == 1702 or curStep == 1708 or curStep == 1714 or curStep == 1716 or curStep == 1722 then
setCamZoom(0.62)

	end

if curStep == 1728 or curStep == 1734 or curStep == 1740 or curStep == 1746 or curStep == 1748 or curStep == 1754 or curStep == 1760 or curStep == 1766 or curStep == 1772 or curStep == 1778 or curStep == 1780 or curStep == 1786 then
setCamZoom(0.62)

	end


if curStep == 1792 or curStep == 1804 or curStep == 1810 or curStep == 1812 or curStep == 1818 or curStep == 1824 or curStep == 1830 or curStep == 1836 or curStep == 1842 or curStep == 1844 or curStep == 1850 then
setCamZoom(0.62)

	end

if curStep == 1856 or curStep == 1862 or curStep == 1868 or curStep == 1874 or curStep == 1876 or curStep == 1882 or curStep == 1888 or curStep == 1894 or curStep == 1900 then
setCamZoom(0.62)

	end




if curStep == 1920 or curStep == 1926 or curStep == 1932 or curStep == 1938 or curStep == 1940 or curStep == 1946 or curStep == 1952 or curStep == 1958 or curStep == 1964 or curStep == 1970 or curStep == 1972 or curStep == 1978 then
setCamZoom(0.62)

	end

if curStep == 1984 or curStep == 1990 or curStep == 1996 or curStep == 2002 or curStep == 2004 or curStep == 2010 or curStep == 2016 or curStep == 2022 or curStep == 2028 or curStep == 2034 or curStep == 2036 or curStep == 2042 then
setCamZoom(0.62)

	end


if curStep == 2048 or curStep == 2054 or curStep == 2060 or curStep == 2066 or curStep == 2068 or curStep == 2074 or curStep == 2080 or curStep == 2086 or curStep == 2092 or curStep == 2098 or curStep == 2100 or curStep == 2106 then
setCamZoom(0.62)

	end

if curStep == 2112 or curStep == 2118 or curStep == 2124 or curStep == 2130 or curStep == 2132 or curStep == 2138 or curStep == 2144 or curStep == 2150 or curStep == 2156 or curStep == 2162 or curStep == 2164 or curStep == 2170 then
setCamZoom(0.62)

	end

if curStep >= 2176 and curStep < 2188 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2188 and curStep < 2192 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 2192 and curStep < 2204 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2204 and curStep < 2208 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 2208 and curStep < 2220 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2220 and curStep < 2224 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end

if curStep >= 2224 and curStep < 2236 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2236 and curStep < 2240 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 2240 and curStep < 2252 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2252 and curStep < 2256 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 2256 and curStep < 2268 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2268 and curStep < 2272 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end


if curStep >= 2272 and curStep < 2284 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end


if curStep >= 2284 and curStep < 2288 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + -120 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end

if curStep >= 2288 and curStep < 2300 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
			setActorX(_G['defaultStrum'..i..'X'] + 25 * math.sin((currentBeat + i*50) * math.pi), i)
			setActorY(_G['defaultStrum'..i..'Y'] + 5 * math.cos((currentBeat + i*0.25) * math.pi), i)
	end
	end

if curStep >= 2300 and curStep < 2302 then
local currentBeat = (songPos / 1000)*(bpm/60)
		for i=0,7 do
		setActorY(_G['defaultStrum'..i..'Y'] + 118 * math.cos((currentBeat + i*10) * math.pi), i)
	end	
	end
	end


function beatHit(beat)
if curStep >= 512 and curStep < 624 or curStep >= 1024 and curStep < 1152 or curStep >= 1536 and curStep < 1648 then
setCamZoom(0.62)

	end
	end

function stepHit (step) -- do nothing

	end