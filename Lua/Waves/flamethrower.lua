require('Libraries/calculating')
require('Libraries/crystals')

crystals = Encounter.GetVar('crystals')

spawntimer = -1
crystals_sx = 0
bullets = {}
flamevel = 10
crystalvel = 2
movetimer = 0


for x,y in pairs(crystals) do
  DEBUG(x)
end


crystals_row1 = {}
for i = 1, 20 do
  local crstl = CreateProjectileAbs(crystals[i].sprite, -16 + i*32, 230)
  crstl.SetVar('iscrystal', true)
  table.insert(crystals_row1, crstl)
end
row1_sc = CreateProjectileAbs(crystals[20].sprite, -16, 230)

function TableMoveRight(tbl)
  local temp = tbl[#tbl]
  table.remove(tbl,#tbl)
  table.insert(tbl,1,temp)
  return tbl
end

function MoveCrystals()
  for _, crstl in pairs(crystals_row1) do
    crstl.MoveTo(crstl.x + crystalvel, crstl.y)
  end
  row1_sc.MoveTo(row1_sc.x + crystalvel, row1_sc.y)
  movetimer = movetimer + crystalvel
  if movetimer == 32 then
    movetimer = 0
    crystals_row1[20].MoveToAbs(16, crystals_row1[20].absy)
    crystals_row1 = TableMoveRight(crystals_row1)
    crystals = TableMoveRight(crystals)
    row1_sc.MoveToAbs(-16, row1_sc.absy)
    row1_sc.sprite.Set(crystals[20].sprite)
  end
end
flame_spawn_x = GetGlobal('flamethrower_spawner_x')
flame_spawn_y = GetGlobal('flamethrower_spawner_y')
flame_pivot_x = GetGlobal('flamethrower_pivot_x')
flame_pivot_y = GetGlobal('flamethrower_pivot_y')
function Update()
  spawntimer = spawntimer + 1
  flame_pivot_x = GetGlobal('flamethrower_pivot_x')
  flame_pivot_y = GetGlobal('flamethrower_pivot_y')
  --DEBUG(xdifference)
  --DEBUG(ydifference)
  --DEBUG('ANGLE '..angle..' '..180*angle/math.pi)
  flame_spawn_x = GetGlobal('flamethrower_spawner_x')
  flame_spawn_y = GetGlobal('flamethrower_spawner_y')

  if (spawntimer/60)%5 < 4 then
    angle = angleFromVector(Player.absx - flame_pivot_x, Player.absy - flame_pivot_y)
    Encounter.Call('EncRotateGun', 180*angle/math.pi)
  else
    for i=-2,2 do
      local bullet = CreateProjectileAbs('flame', flame_spawn_x, flame_spawn_y)
      bullet.SetVar('iscrystal', false)
      --bullet.sprite.rotation = 90 + 180*(angle + i * 3 * math.pi/180)/math.pi
      bullet.SetVar('velx', math.cos(angle + i * 3 * math.pi/180)*flamevel)
      bullet.SetVar('vely', math.sin(angle + i * 3 * math.pi/180)*flamevel)
      table.insert(bullets, bullet)
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
  MoveCrystals()
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
