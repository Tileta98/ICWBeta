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
--*   @Date:                2017-10-05T20:50:45+02:00
--*   @Project:             Imperial Civil War
--*   @Filename:            StoryEvents.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:31:50+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("GameGlobals")
require("PGCommands")

function NewEvent(id, event, reward, prereqs, repeatable)
  return {
    id = id,
    event = event,
    reward = reward,
    prereqs = prereqs,
    repeatable = repeatable,
    concluded = false
  }
end

function Event(id)
  return {
    event = {
      id = id,
      event = {
        evaluate = function(self)
          return false
        end
      },
      reward = nil,
      repeatable = false,
      prereqs = nil,
      concluded = false
    },
    WithEventType = function(self, eventType)
      self.event.event = eventType
      return self
    end,
    WithRewardType = function(self, rewardType)
      self.event.reward = rewardType
      return self
    end,
    WithPrereqs = function(self, prereqs)
      self.event.prereqs = prereqs
      return self
    end,
    Repeatable = function(self, bool)
      self.event.repeatable = bool
      return self
    end,
    Create = function(self)
      return self.event
    end
  }
end

function PlanetOwnerChanged(planet, player)
  local originalOwner = planet.Get_Owner()
  return {
    originalOwner = originalOwner,
    planet = planet,
    player = player,
    evaluate = function(self)
      if self.planet.Get_Owner() ~= self.originalOwner then
        self.originalOwner = planet.Get_Owner()
        if player then
          return planet.Get_Owner() == player
        end
        return true
      end
      return false
    end
  }
end

function FactionOwns(player, planet)
  return {
    player = player,
    planet = planet,
    evaluate = function(self)
      return self.planet.Get_Owner() == self.player
    end
  }

end

function FactionHasTechLevel(player, level)
  return {
    player = player,
    level = level,
    evaluate = function(self)
      return self.player.Get_Tech_Level() == self.level
    end
  }

end

function ObjectIsOnPlanet(object, planet)
  return {
    object = object,
    planet = planet,
    evaluate = function(self)
      return self.object.Get_Planet_Location() == self.planet
    end
  }
end

function PlanetHasStructure(planet, structureString)
  return {
    planet = planet,
    structureString = structureString,
    evaluate = function(self)
      local structures = Find_All_Objects_Of_Type(self.structureString)
      for i, struc in pairs(structures) do
        if struc.Get_Planet_Location() == self.planet then
          return true
        end
      end
      return false
    end
  }

end

function IsAlive(object)
  return {
    object = object,
    evaluate = function(self)
      return TestValid(self.object)
    end
  }

end

function IsDead(object)
  return {
    object = object,
    evaluate = function()
      return not TestValid(self.object)
    end
  }

end

function StoryFlag(player, id)
  return {
    player = player,
    id = id,
    evaluate = function(self)
      return Check_Story_Flag(self.player, self.id, nil, true)
    end
  }

end

function SpawnUnits(units, location, player)
  return {
    units = units,
    location = location,
    player = player,
    execute = function(self)
      for i, unit in pairs(self.units) do
        Spawn_Unit(unit, self.location, self.player)
      end
    end
  }
end

function ScreenText(textId, time, var, color)
  return {
    textId = textId,
    var = var,
    color = color,
    execute = function(self)
      GLOBALS.ShowScreenText(textId, var, color)
    end
  }
end
