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
--*   @Filename:            StoryEventManager.lua
--*   @Last modified by:    [TR]Pox
--*   @Last modified time:  2017-12-21T12:31:42+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



StoryEventManager = {}
StoryEventManager.events = {}

function StoryEventManager:RegisterEvent(event)
  self.events[event.id] = event
end

function StoryEventManager:ProcessEvents()
  for i, event in pairs(self.events) do
    if self:PrereqsDone(event) then
      self:TriggerEvent(event)
    end
  end
end

function StoryEventManager:PrereqsDone(event)
  if event.prereqs then
    for j, prereq in pairs(event.prereqs) do
      if self.events[prereq] and not self.events[prereq].concluded then
        return false
      end
    end
  end
  return true
end

function StoryEventManager:TriggerEvent(event)
  if event.event:evaluate() then
    if event.reward then
      event.reward:execute()
    end

    event.concluded = true
    if not event.repeatable then
      table.remove(self.events, i)
    end
  end
end

return StoryEventManager
