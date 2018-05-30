require("PGStoryMode")
require("PGBase")
CONSTANTS = require("GameConstants")

--
-- Definitions -- This function is called once when the script is first created.
--
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))

	ServiceRate = 5

	StoryModeEvents = {
						Stat_Display = Stat_Display_Setup
					}
end

function Stat_Display_Setup(message)
	if message == OnEnter then
		plot = Get_Story_Plot("GCStatDisplay.xml")

		DebugMessage("%s -- plot is %s", tostring(Script), tostring(plot))

		stat_display_event = plot.Get_Event("Stat_Display")

		DebugMessage("%s -- event is %s", tostring(Script), tostring(stat_display_event))

		FactionTable = {}
		for _, faction in CONSTANTS.ALL_FACTIONS do
			CreateFactionEntry(faction)
		end
	end
end

function CreateFactionEntry(factionString)
	if factionString == "NEUTRAL" or factionString == "HOSTILE" then
		return
	end

	local factionObject = Find_Player(factionString)
	if FactionOwnsPlanets(factionObject) then
		table.insert(FactionTable, factionObject)
	end
end

function FactionOwnsPlanets(faction)
	for _, planet in pairs(FindPlanet.Get_All_Planets()) do
		if planet.Get_Owner() == faction then
			return true
		end
	end

	return false
end


function Story_Mode_Service()

	if stat_display_event then
		DebugMessage("%s -- Refreshing perceptions", tostring(Script))
		stat_display_event.Clear_Dialog_Text()

		for _, faction in pairs(FactionTable) do
			local planet_stat = EvaluatePerception("Planet_Ownership", faction)
			local force_stat = EvaluatePerception("Percent_Forces", faction)
			local money_stat = EvaluatePerception("Current_Income", faction)
			stat_display_event.Add_Dialog_Text("STAT_SEPARATOR")
			stat_display_event.Add_Dialog_Text(CONSTANTS.ALL_FACTION_TEXTS[faction.Get_Faction_Name()])
			stat_display_event.Add_Dialog_Text("STAT_SEPARATOR")
			stat_display_event.Add_Dialog_Text("STAT_PLANET_COUNT", planet_stat)
			stat_display_event.Add_Dialog_Text("STAT_FORCE_PERCENT", force_stat*100)
			stat_display_event.Add_Dialog_Text("STAT_INCOME", money_stat)
		end
	end
end