--For usage, check out the encounter Lua's EncounterStarting() and Update() functions.
require('Libraries/calculating')

local weapon_pivot_x = 0.3
local weapon_pivot_y = 0.5
local weapon_anchor_x = 0.4
local weapon_anchor_y = 0.15

local armlength = 60

darm1 = CreateSprite('arm1')
darm2 = CreateSprite('arm2')

dtorso = CreateSprite('torso')
dlegs = CreateSprite('legs')
dhead = CreateSprite('head')
dweapon = CreateSprite('weapon')

--dlegs.alpha = 0
--dtorso.alpha = 0


dtorso.SetParent(dlegs)
dhead.SetParent(dtorso)
dweapon.SetParent(dtorso)
darm1.SetParent(dtorso)
darm2.SetParent(darm1)

dlegs.y = 240

dweapon.SetPivot(weapon_pivot_x, weapon_pivot_y)
dweapon.SetAnchor(weapon_anchor_x, weapon_anchor_y)

darm1.SetPivot(0.08, 0.5)
darm1.SetAnchor(0.875, 0.9)
darm2.SetPivot(0.08, 0.5)
darm2.SetAnchor(0.9, 0.5)

darm1.rotation = 270
darm2.rotation = 180

--We set the torso's pivot point to halfway horizontally, and on the bottom vertically, 
--so we can rotate it around the bottom instead of the center.
dhead.SetPivot(0.5, 0)
dhead.SetAnchor(0.5, 1)
dtorso.SetPivot(0.5, 0.1)

--We set the torso's anchor point to the top center. Because the legs are pivoted on the bottom (so rescaling them only makes them move up),
--we want the torso to move along upwards with them.
dtorso.SetAnchor(0.5, 1)
dlegs.SetPivot(0.5, 0)

--Finally, we do some frame-by-frame animation just to show off the feature. You put in a list of sprites,
--and the time you want a sprite change to take. In this case, it's 1/2 of a second.


function RotateGun(deg)
  dweapon.rotation = deg
  --DEBUG('legs '..dlegs.x..' '..dlegs.y)
  --DEBUG('torso '..dtorso.x..' '..dtorso.y)
  --DEBUG('head '..dhead.x..' '..dhead.y)
  local x = dlegs.x - dtorso.width*0.5 + dtorso.width*weapon_anchor_x
  local y = dlegs.y + dlegs.height + dtorso.y +dtorso.height*weapon_anchor_y
  local sx = dlegs.x - dtorso.width*0.5 + dtorso.width*weapon_anchor_x + dweapon.width*math.cos(deg*math.pi/180)
  local sy = dlegs.y + dlegs.height + dtorso.y + dtorso.height*weapon_anchor_y + dweapon.width*math.sin(deg*math.pi/180)
  local ssx = dlegs.x - dtorso.width*0.5 + dtorso.width*weapon_anchor_x + 0.7*dweapon.width*math.cos(deg*math.pi/180)
  local ssy = dlegs.y + dlegs.height + dtorso.y + dtorso.height*weapon_anchor_y + 0.7*dweapon.width*math.sin(deg*math.pi/180)
  local shoulder_x = dlegs.x - dtorso.width*0.5 + dtorso.width*0.875
  local shoulder_y = dlegs.y + dlegs.height + dtorso.y + dtorso.height*0.9
  local sx2shx, sy2shy = shoulder_x - ssx, shoulder_y - ssy
  local s2sh = (sx2shx^2 + sy2shy ^ 2)^0.5
  --DEBUG(sx2shx..' - '..sy2shy)
  local alphaangle = 180*angleFromVector(sx2shx, sy2shy)/math.pi - 180
  --DEBUG('AA '..alphaangle)
  local betaangle1 = 180*(math.acos(s2sh/(2*armlength)))/math.pi
  --DEBUG('BA '..betaangle1)
  local betaangle2 = alphaangle - betaangle1
  darm1.rotation = alphaangle + betaangle1
  darm2.rotation = betaangle2
  return x, y, sx, sy
end

function AnimateEnemy()
--  dtorso.MoveTo(0, -3 + 1*math.cos(Time.time*2))
  --dhead.MoveTo(2*math.sin(Time.time), 40 + 2*math.cos(Time.time))
end
