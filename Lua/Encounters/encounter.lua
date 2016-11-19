-- A basic encounter script skeleton you can copy and modify for your own creations.

music = "Dingodile_Crash_Bandicoot" --Always OGG. Extension is added automatically. Remove the first two lines for custom music.
encountertext = "Poseur strikes a pose!" --Modify as necessary. It will only be read out in the action select screen.
nextwaves = {"bullettest_chaserorb"}
wavetimer = 10.0
--arenasize = {155, 130}
arenasize = {512, 150}

enemies = {
"Dingodile"
}

enemypositions = {
{0, 0}
}

-- A custom list with attacks to choose from. Actual selection happens in EnemyDialogueEnding(). Put here in case you want to use it.
possible_attacks = {"flamethrower"}

function EncRotateGun(deg)
  x, y, sx, sy = RotateGun(deg)
  --DEBUG('Gun coords '..x..' '..y)
  SetGlobal('flamethrower_pivot_x', x)
  SetGlobal('flamethrower_pivot_y', y)
  SetGlobal('flamethrower_spawner_x', sx)
  SetGlobal('flamethrower_spawner_y', sy)
end

function EncounterStarting()
  require('Libraries/crystals')
  require('Libraries/enemysprites')
  local number_of_crystals = 21
  crystals = {}
  for i=1, number_of_crystals do
    local crystal = Crystal:New()
    table.insert(crystals, crystal)
  end

  EncRotateGun(0)
  -- If you want to change the game state immediately, this is the place.
end

function Update()
  AnimateEnemy()
end

function EnemyDialogueStarting()
    -- Good location for setting monster dialogue depending on how the battle is going.
    -- enemies[1].SetVar('currentdialogue', {"It's\nworking."})
end

function EnemyDialogueEnding()
    -- Good location to fill the 'nextwaves' table with the attacks you want to have simultaneously.
    -- This example line below takes a random attack from 'possible_attacks'.
    -- nextwaves = { possible_attacks[math.random(#possible_attacks)] }
    nextwaves = {"flamethrower"}
end

function DefenseEnding() --This built-in function fires after the defense round ends.
    encountertext = RandomEncounterText() --This built-in function gets a random encounter text from a random enemy.
end

function HandleSpare()
     State("ENEMYDIALOGUE")
end

function HandleItem(ItemID)
    BattleDialog({"Selected item " .. ItemID .. "."})
end
