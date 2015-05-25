-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- hide the status bar

-- include the Corona "composer" module

local composer = require( "composer" )
local scene = composer.newScene()


--i added this global fcn  so that the restart button would also have this functionality
function initializeValues()
 
previousScene = nil
 

end

initializeValues()


display.setStatusBar( display.HiddenStatusBar )


-- load menu screen
composer.gotoScene( "menu" )
