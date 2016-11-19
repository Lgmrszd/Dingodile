require('Libraries/calculating')
require('Libraries/crystals')

crystals = Encounter.GetVar('crystals')

for x,y in pairs(crystals) do
  DEBUG(x)
end


crystals_row1 = {}
for i = 0, 20 do
  local crstl = CreateProjectileAbs(crystals[i+1].sprite, 16 + i*32, 230)
  crstl.SetVar('iscrystal', true)
  table.insert(crystals_row1, crstl)
end

function TableMoveRight(tbl)
  local temp = tbl[#tbl]
  table.remove(tbl,#tbl)
  table.insert(tbl,1,temp)
  return tbl
end

local movetimer = 0
function MoveCrystals()
  for crstl in crystals_row1 do
  end
  movetimer = movetimer + 1
end

spawntimer = -1
crystals_sx = 0
bullets = {}
flamevel = 5
flame_spawn_x = GetGlobal('flamethrower_spawner_x')
flame_spawn_y = GetGlobal('flamethrower_spawner_y')
flame_pivot_x = GetGlobal('flamethrower_pivot_x')
flame_pivot_y = GetGlobal('flamethrower_pivot_y')
function Update()
  spawntimer = spawntimer + 1

  if true then
    local flame_pivot_x = GetGlobal('flamethrower_pivot_x')
    local flame_pivot_y = GetGlobal('flamethrower_pivot_y')
    --DEBUG(xdifference)
    --DEBUG(ydifference)
    local angle = angleFromVector(Player.absx - flame_pivot_x, Player.absy - flame_pivot_y)
    --DEBUG('ANGLE '..angle..' '..180*angle/math.pi)
    Encounter.Call('EncRotateGun', 180*angle/math.pi)
    local flame_spawn_x = GetGlobal('flamethrower_spawner_x')
    local flame_spawn_y = GetGlobal('flamethrower_spawner_y')
    if (spawntimer/60)%4 > 3 then
      for i=-2,2 do
        local bullet = CreateProjectileAbs('flame', flame_spawn_x, flame_spawn_y)
        bullet.SetVar('iscrystal', false)
        bullet.sprite.rotation = 90 + 180*(angle + i * 3 * math.pi/180)/math.pi
        bullet.SetVar('velx', math.cos(angle + i * 3 * math.pi/180)*flamevel)
        bullet.SetVar('vely', math.sin(angle + i * 3 * math.pi/180)*flamevel)
        table.insert(bullets, bullet)
      end
    end
  end
  
  for i=1,#bullets do
    local bullet = bullets[i]
    local velx = bullet.GetVar('velx')
    local vely = bullet.GetVar('vely')
    local newflame_spawn_x = bullet.x + velx
    local newflame_spawn_y = bullet.y + vely
    bullet.MoveTo(newflame_spawn_x, newflame_spawn_y)
    if newflame_spawn_y < 0 then
      --bullet.Remove()
    end

    bullet.SetVar('vely', vely)
  end
end

function OnHit(bullet)
  Player.Hurt(0)
  DEBUG('playerpos '..Player.x..' '..Player.y)
  DEBUG('playerabspos '..Player.absx..' '..Player.absy)
  DEBUG((Arena.height-130)/2)
  if not bullet.GetVar('iscrystal') then
    bullet.Remove()
  end
--    EndWave()
  for i = 1,#bullets do
    if bullets[i] == bullet then
      table.remove(bullets, i)
      break
      end
  end
end
