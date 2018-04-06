-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/VaderAssistsLand.lua#3 $
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/AI/LandMode/VaderAssistsLand.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 52287 $
--
--          $DateTime: 2006/08/22 10:41:09 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This plan simply puts Vader in the right places.
-- It relies on the object script darthvader.lua to activate abilities.

require("pgevents")

function Definitions()
	
	Category = "VaderAssists"
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"TaskForceRequired"
	}
	}
	
	IgnoreTarget = true
	AllowEngagedUnits = true
	
	duration_to_assist = 20
	duration_to_fight = 30

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce)
	
	MainForce.Set_As_Goal_System_Removable(false)

	vader = MainForce.Get_Unit_Table()[1]
	if not TestValid(vader) then
		MessageBox("unexpected state; vader unavailable")
		ScriptExit()
	end

	-- Continuously try to attack, assist the most significant nearby unit, and heal up
	while true do

		ConsiderHeal(vader)

		enemy_location = FindTarget.Reachable_Target(PlayerObject, "Current_Enemy_Location", "Tactical_Location", "Any_Threat", 0.5)
		if TestValid(enemy_location) then
			DebugMessage("%s--  moving toward enemy concentration", tostring(Script))
			BlockOnCommand(MainForce.Attack_Move(enemy_location), duration_to_fight)
		end

		ConsiderHeal(vader)

		best_ally = FindTarget(MainForce, "Needs_Vader_Assist", "Friendly_Unit", 1.0, 1500)
		if TestValid(best_ally) then
			DebugMessage("%s-- assisting %s", tostring(Script), tostring(best_ally))
			BlockOnCommand(MainForce.Guard_Target(best_ally), duration_to_assist)
		end
		
		MainForce.Set_Plan_Result(true)

		-- Make sure the loop always yields
		Sleep(1)
	
	end

end

