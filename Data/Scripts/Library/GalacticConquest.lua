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
--*   @Author:              [TR]Pox
--*   @Date:                2018-03-10T03:05:37+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GalacticConquest.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-10T19:27:15+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("TRUtil")
require("Class")
require("GalacticEvents")

GalacticConquest = Class {
  Constructor = function(self, player_agnostic_plot, playableFactions)
    self.HumanPlayer = self:FindHumanPlayerInTable(playableFactions)
    self.Planets = FindPlanet.Get_All_Planets()
    self:InitializeEvents(player_agnostic_plot)
    self.Events = {
        SelectedPlanetChanged = SelectedPlanetChangedEvent:New(self.HumanPlayer),
        PlanetOwnerChanged = PlanetOwnerChangedEvent:New(),
        GalacticProductionFinished = ProductionFinishedEvent:New()
    }
  end,

  Update = function(self)
    self.Events.SelectedPlanetChanged:Check()
    self.Events.PlanetOwnerChanged:Check()
    self.Events.GalacticProductionFinished:Check()
  end,

  GetSelectedPlanet = function(self)
    local selectedPlanetName = GlobalValue.Get("SELECTED_PLANET")
    if not TRUtil.ValidGlobalValue(selectedPlanetName) then
        return nil
    end
    return FindPlanet(selectedPlanetName)
  end,

  FindHumanPlayerInTable = function(self, factions)
    for _, faction in pairs(factions) do
      local player = Find_Player(faction)
      if player.Is_Human() then
        return player
      end
    end
  end,

  InitializeEvents = function(self, plot)
    for _, planet in pairs(self.Planets) do
        local planetName = planet.Get_Type().Get_Name()
        local event = plot.Get_Event("Zoom_Into_"..planetName)
        if event then
            event.Set_Reward_Parameter(1, self.HumanPlayer.Get_Faction_Name())
        end
    end
  end

}

return GalacticConquest