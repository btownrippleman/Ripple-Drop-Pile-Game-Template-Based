-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar


local composer = require( "composer" )
local scene = composer.newScene()


--previousScene = "menu"
function initializeValues()
maxNumberOfBoxes = 10
numberOfBoxes = 1;
scaleFactorOfBoxes = .5
boxBounciness = 0
previousScene = nil
--randomnessInBoxSize = true
--randomnessInBounciness = true

end

initializeValues()


display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load menu screen
composer.gotoScene( "menu" )
