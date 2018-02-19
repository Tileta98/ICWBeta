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
--*   @Date:                2017-11-24T12:43:51+01:00
--*   @Project:             Imperial Civil War
--*   @Filename:            GCPlayerAgnostic.lua
-- @Last modified by:
-- @Last modified time: 2018-02-11T02:52:16+01:00
--*   @License:             This source code may only be used with explicit permission from the developers
--*   @Copyright:           © TR: Imperial Civil War Development Team
--******************************************************************************



require("PGDebug")
require("PGStateMachine")
require("PGStoryMode")
require("StoryEvents")
require("StoryEventManager")
require("GameObjectLibrary")
GLOBALS = require("GameGlobals")
require("DisplayManager")
require("CategoryFilter")
TM = require("TRGameModeTransactions")


function Definitions()

    DebugMessage("%s -- In Definitions", tostring(Script))

    ServiceRate = 0.1

    CONST_STORY_THREAD_FLAG = true
    StoryModeEvents = { Zoom_Zoom = Begin_GC }
end

function Begin_GC(message)
    if message == OnEnter then
        GLOBALS.Init()
        GLOBALS.InitializeEvents()
        GLOBALS.PLAYER.Enable_Advisor_Hints("Galactic",false)
        GLOBALS.PLAYER.Enable_Advisor_Hints("Space",false)
        GLOBALS.PLAYER.Enable_Advisor_Hints("Land",false)

        StructureDisplay = OrbitalStructureDisplay:New()
        Filter = CategoryFilter:New()

        -- Create_Thread("EventManagerThread")
        Create_Thread("TransactionManagerThread")
        -- Create_Thread("CategoryFilterThread")

      elseif message == OnUpdate then
        GLOBALS.Update()
        Filter:Update()
    end
end

function TransactionManagerThread()
    while true do
        TM.ExecuteRegisteredTransactions()
        Sleep(1)
    end
end

function CategoryFilterThread()
  while true do
    Filter:Update()
    Sleep(0.1)
  end
end
