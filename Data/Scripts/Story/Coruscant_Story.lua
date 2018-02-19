--////////////////////////////////////////////////
-- Katana Mission (New Republic)
--////////////////////////////////////////////////

require("PGStoryMode")
require("PGSpawnUnits")
require("PGMoveUnits")



function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Battle_Start = Begin_Battle,
		STORY_VICTORY_Player = Return_Katana_Count
	}


	
	marker_list = {}	
	mission_started = false
	
end


function Begin_Battle(message)
	if message == OnEnter then
		empire = Find_Player("Empire")
		rebels = Find_Player("Rebel")
		hutts = Find_Player("Hutts")
		pirates = Find_Player("Yevetha")
		entry_marker = Find_First_Object("Attacker Entry Position")
		invading_fleet = {"Generic_Star_Destroyer_Two", "Generic_Star_Destroyer_Two", "Generic_Secutor", "Generic_Praetor", "Generic_Allegiance", "MTC_Sensor", "MTC_Sensor", "MTC_Sensor", "Dreadnaught_Empire", "Dreadnaught_Empire", "Dreadnaught_Empire", "Generic_Interdictor_Cruiser", "Generic_Victory_Destroyer", "Vindicator_Cruiser", "Carrack_Cruiser", "Carrack_Cruiser", "Carrack_Cruiser", "Lancer_Frigate", "Lancer_Frigate", "Raider_Pentastar", "Lancer_Frigate", "Tartan_Patrol_Cruiser", "Raider_Pentastar", "Generic_Procursator", "Generic_Victory_Destroyer_Two", "Generic_Procursator", "Generic_Victory_Destroyer_Two", "Generic_Star_Destroyer", "Generic_Star_Destroyer","Generic_Secutor", "Strike_Cruiser", "Strike_Cruiser", "Strike_Cruiser", "Generic_Victory_Destroyer", "Neutron_Star" }
		invading_fleet_2 = {"Generic_Allegiance", "Generic_Victory_Destroyer", "Generic_Procursator", "Lancer_Frigate"}
		invading_fleet_3 = {"Raider_Pentastar", "Strike_Cruiser", "Dreadnaught_Empire", "Carrack_Cruiser"}
		imp_boarders = {"Imperial_Landing_Craft", "Imperial_Landing_Craft", "Imperial_Landing_Craft"}
		
		local invaders = Find_Player("Hostile")
		
		player_list = nil
		player = nil

		if rebels.Is_Human() then
			player = rebels
			player_list = invading_fleet			
		end

		Register_Timer(spawnFleet, 0, {self, invading_fleet, entry_marker, invaders})
		-- Register_Timer(spawnFleet, 10, {self, invading_fleet_2, entry_marker, invaders})
		-- Register_Timer(spawnFleet, 20, {self, invading_fleet_3, entry_marker, invaders})
		-- boarder_list = SpawnList(invading_fleet, entry_marker, invaders, false, true)
		-- boarder_list_2 = SpawnList(invading_fleet_2, entry_marker, invaders, false, true)
		-- boarder_list_3 = SpawnList(invading_fleet_3, entry_marker, invaders, false, true)
	end
end

function spawnFleet(param)
  local self = param[1]
  self.spawnList = SpawnList(param[2], param[3], param[4], true, true)
end
