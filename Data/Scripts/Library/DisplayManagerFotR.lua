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
--*   @Date:                2017-12-22T10:19:56+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            DisplayManager.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2018-03-17T02:25:08+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("Class")
require("TRUtil")
require("DisplayStructuresUtilities")

OrbitalStructureDisplay = Class {
    FACTION_COLORS = {
        ["EMPIRE"] = {r = 250, g = 44, b = 44},
        ["REBEL"] = {r = 44, g = 121, b = 216},
        ["UNDERWORLD"] = {r = 102, g = 188, b = 217},
        ["PENTASTAR"] = {r = 55, g = 64, b = 184},
        ["YEVETHA"] = {r = 248, g = 237, b = 60},
        ["TERADOC"] = {r = 255, g = 20, b = 50},
        ["PIRATES"] = {r = 179, g = 148, b = 105},
        ["HUTTS"] = {r = 255, g = 255, b = 255},
        ["WARLORDS"] = {r = 142, g = 195, b = 0},
        ["CORPORATE_SECTOR"] = {r = 176, g = 124, b = 172},
        ["NEUTRAL"] = {r = 100, g = 100, b = 100},
        ["HOSTILE"] = {r = 153, g = 21, b = 223}
    },

    CurrentText = {},

    SelectedPlanet = nil,

    Constructor = function(self, selectedPlanetChangedEvent, productionFinishedEvent)
        selectedPlanetChangedEvent:AttachListener(self.Update, self)
        productionFinishedEvent:AttachListener(self.ProductionUpdate, self)
    end,

    ProductionUpdate = function(self, planet)
        if planet ~= self.SelectedPlanet then
          return
        end
        self:Update(planet)
    end,

    Update = function(self, planet)
        self.SelectedPlanet = planet
        local owner = planet:get_owner()
        local ownerName = owner.Get_Faction_Name()
        local color = self.FACTION_COLORS[ownerName]

        self:Clear()

        TRUtil.ShowScreenText("TEXT_SELECTED_PLANET", -1, planet:get_game_object(), color)
        self.CurrentText = {"TEXT_SELECTED_PLANET"}

        if not planet:get_owner().Is_Human() then
          return
        end

        local structuresOnPlanet = planet:get_orbital_structure_information()

        for structureText, amount in pairs(structuresOnPlanet) do
            table.insert(self.CurrentText, structureText)
            local number = GameObjectNumber(amount)
            if number then
                TRUtil.ShowScreenText(structureText, -1, number, color)
            end
        end
    end,

    Clear = function(self)
        for _, text in pairs(self.CurrentText) do
            TRUtil.RemoveScreenText(text)
        end
    end
}

return OrbitalStructureDisplay