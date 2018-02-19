--******************************************************************************
--     _______ __
--    |_     _|  |--.----.---.-.--.--.--.-----.-----.
--      |   | |     |   _|  _  |  |  |  |     |__ --|
--      |___| |__|__|__| |___._|________|__|__|_____|
--     ______
--    |   __ \.-----.--.--.-----.-----.-----.-----.
--    |      <|  -__|  |  |  -__|     |  _  |  -__|
--    |___|__||_____|\___/|_____|__|__|___  |_____|
--                                    |_____|
--*   @Author:              Corey
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCShadowHandCampaign.lua
--*   @Last modified by:
--*   @Last modified time:  2018-02-03T12:22:17-05:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGBase")
require("PGStateMachine")
require("PGStoryMode")
require("PGSpawnUnits")
require("ChangeOwnerUtilities")
TM = require("TRGameModeTransactions")

function Definitions()

  DebugMessage("%s -- In Definitions", tostring(Script))

  StoryModeEvents =
    {
      Determine_Faction_LUA = Find_Faction,
      Eclipse_Completed_Generic = Palpatine_Joins,
      Luke_Completed = Luke_Joins,
	  Empire_wins_Coruscant = Spawn_Empire_Reward,
      Warlords_Breakoff = Empire_Fractures
    }

end

function Find_Faction(message)
  if message == OnEnter then

    p_newrep = Find_Player("Rebel")
    p_empire = Find_Player("Empire")
    p_eoth = Find_Player("Underworld")
    p_eriadu = Find_Player("Hutts")
    p_pentastar = Find_Player("Pentastar")
    p_zsinj = Find_Player("Pirates")
    p_maldrood = Find_Player("Teradoc")
    p_yevetha = Find_Player("Yevetha")

    if p_newrep.Is_Human() then
      Story_Event("ENABLE_BRANCH_NEWREP_FLAG")
    elseif p_empire.Is_Human() then
      Story_Event("ENABLE_BRANCH_EMPIRE_FLAG")
    elseif p_eoth.Is_Human() then
      Story_Event("ENABLE_BRANCH_EOTH_FLAG")
    elseif p_eriadu.Is_Human() then
      Story_Event("ENABLE_BRANCH_ERIADU_FLAG")
    elseif p_pentastar.Is_Human() then
      Story_Event("ENABLE_BRANCH_PENTASTAR_FLAG")
    elseif p_zsinj.Is_Human() then
      Story_Event("ENABLE_BRANCH_ZSINJ_FLAG")
    elseif p_maldrood.Is_Human() then
      Story_Event("ENABLE_BRANCH_MALDROOD_FLAG")
    elseif p_yevetha.Is_Human() then
      Story_Event("ENABLE_BRANCH_YEVETHA_FLAG")
    end
  end
end

function Palpatine_Joins(message)
  if message == OnEnter then

    p_empire = Find_Player("Empire")
    p_newrep = Find_Player("Rebel")
    start_planet = FindPlanet("Byss")

    --ChangePlanetOwnerAndRetreat(start_planet, p_empire)

    spawn_list_emperor = { "Emperor_Palpatine_Team" }
    EmperorSpawn = SpawnList(spawn_list_emperor, start_planet, p_empire,false,false)

    if p_newrep.Is_Human() then
      spawn_list_luke = { "Luke_Skywalker_Darkside_Team" }
      LukeSpawn = SpawnList(spawn_list_luke, start_planet, p_empire,false,false)
    end

  end
end

function Luke_Joins(message)
  if message == OnEnter then

    p_empire = Find_Player("Empire")
    start_planet = FindPlanet("Byss")

    start_planet = FindPlanet("Byss")

    if start_planet.Get_Owner() ~= Find_Player("Empire") then
      allPlanets = FindPlanet.Get_All_Planets()
      random = GameRandom(1, table.getn(allPlanets))
      start_planet = allPlanets[random]
      while start_planet.Get_Owner() ~= Find_Player("Empire") do
        random = GameRandom(1, table.getn(allPlanets))
        start_planet = allPlanets[random]
      end
    end

    spawn_list_luke = { "Luke_Skywalker_Darkside_Team" }
    LukeSpawn = SpawnList(spawn_list_luke, start_planet, p_empire,false,false)

  end
end

function Empire_Fractures(message)
  if message == OnEnter then

    p_empire = Find_Player("Empire")
    p_maldrood = Find_Player("Teradoc")
    p_eriadu = Find_Player("Hutts")
    p_harrsk = Find_Player("Harrsk")
    p_pentastar = Find_Player("Pentastar")


    --Carnor takes control of the Empire

    start_planet = FindPlanet("Byss")
    if start_planet.Get_Owner() == p_empire then
      spawn_list = { "Carnor_Jax_Team" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_empire, false, false)
    end

    --Federated Teradoc Union (Centares for Treutan, Hakassi for Kosh)

    local checkTeradoc = Find_First_Object("13X_Teradoc")
    if TestValid(checkTeradoc) then
      checkHarrsk.Despawn()
    end

    start_planet = FindPlanet("Centares")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_maldrood)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","13X_Teradoc" , "Crimson_Victory" , "Crimson_Victory" , "Crimson_Victory", "Crimson_Victory", "Crimson_Victory", "Crimson_Victory", "P_Ground_Barracks" , "P_Ground_Light_Vehicle_Factory"}
      ImperialForces = SpawnList(spawn_list, start_planet, p_maldrood, false, false)
    end

    local checkKosh = Find_First_Object("Lancet_Kosh")
    if TestValid(checkKosh) then
      checkHarrsk.Despawn()
    end

    start_planet = FindPlanet("Hakassi")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_maldrood)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Lancet_Kosh" , "Strike_Cruiser" ,"Strike_Cruiser" ,"Strike_Cruiser" , "P_Ground_Barracks" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_maldrood, false, false)
    end

    --Zero Command

    local checkHarrsk = Find_First_Object("Shockwave_Star_Destroyer")
    if TestValid(checkHarrsk) then
      checkHarrsk.Despawn()
    end

    start_planet = FindPlanet("Kalist")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_harrsk)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two", "P_Ground_Barracks" ,"Strike_Cruiser" ,"Strike_Cruiser" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_harrsk, false, false)
    end

    --Pentastar
    start_planet = FindPlanet("Entralla")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_pentastar)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad","Generic_Bellator" ,"Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two", "P_Ground_Barracks" ,"Strike_Cruiser" ,"Strike_Cruiser" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_pentastar, false, false)
    end

    start_planet = FindPlanet("Bastion")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_pentastar)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad","Generic_Bellator" ,"Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two", "P_Ground_Barracks" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_pentastar, false, false)
    end

    -- Delvardus

    local checkDelvardus = Find_First_Object("Thalassa")
    if TestValid(checkDelvardus) then
      checkHarrsk.Despawn()
    end

    start_planet = FindPlanet("Eriadu")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_eriadu)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad","Torpedo_Sphere" ,"Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Escort_Carrier","Escort_Carrier", "Torpedo_Sphere" ,"Torpedo_Sphere" ,"P_Ground_Barracks" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_eriadu, false, false)
    end

    start_planet = FindPlanet("Kampe")
    if start_planet.Get_Owner() == p_empire then
      ChangePlanetOwnerAndRetreat(start_planet, p_eriadu)
      spawn_list = { "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Assault_Company", "Imperial_Heavy_Scout_Squad", "Imperial_Heavy_Scout_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad", "Imperial_Stormtrooper_Squad","Torpedo_Sphere" , "Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two","Generic_Star_Destroyer_Two", "Escort_Carrier", "Escort_Carrier","Escort_Carrier","Thalassa", "Night_Hammer" , "P_Ground_Barracks" , "P_Ground_Light_Vehicle_Factory" }
      ImperialForces = SpawnList(spawn_list, start_planet, p_eriadu, false, false)
    end

  end
end

function Spawn_Empire_Reward(message)
  if message == OnEnter then

    p_empire = Find_Player("Empire")
    start_planet = FindPlanet("Coruscant")


	spawn_list_coruscant = {"Generic_Star_Destroyer_Two", "Generic_Secutor", "Generic_Allegiance", "MTC_Sensor", "MTC_Sensor", "MTC_Sensor", "Dreadnaught_Empire", "Dreadnaught_Empire", "Generic_Interdictor_Cruiser", "Generic_Victory_Destroyer", "Vindicator_Cruiser", "Carrack_Cruiser", "Carrack_Cruiser", "Lancer_Frigate", "Lancer_Frigate", "Lancer_Frigate", "Raider_Pentastar", "Generic_Procursator", "Generic_Victory_Destroyer_Two", "Generic_Star_Destroyer", "Generic_Star_Destroyer", "Strike_Cruiser", "Strike_Cruiser", "Generic_Victory_Destroyer" }
    CoruscantSpawn = SpawnList(spawn_list_coruscant, start_planet, p_empire,false,false)

  elseif message == OnUpdate then
  end
end