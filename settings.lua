-----------------------------------------------------------------------------------------
--
-- settings.lua -- this just basically has the one slider for the number of words to have added 
-- each time you get down to 2 words
--
-----------------------------------------------------------------------------------------
require("languages")
local composer = require( "composer" )
local scene = composer.newScene()
-- include Corona's "widget" library
local widget = require "widget"
local sceneGroup

-- # number of words will be decided based on how well the user is doing
-- local function   numberOfWordsSliderListener(event)
-- 	_G.listLength = math.round(event.value/10)
-- 	boxText.text = "    #Words: ".._G.listLength  -- the number of words to add next time you get a new number of words
-- end
  
local function onDoneBtnRelease() -- go to previous scene
  	composer.gotoScene( previousScene, "fade", 100 )
  	return true	-- indicates successful touch
end

local function onlanguagePickButtonRelease() -- changes list of languages, which then you can see back in level1
  	composer.gotoScene( "languagepick", "fade", 100 )
  	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view



--widget button for returning to prev screen
  doneBtn = widget.newButton{
		font = _G.defaultFont, fontsize = _G.defaultFontSize,
		label = "Done",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onDoneBtnRelease}  -- event listener function

	doneBtn.x = display.contentWidth*0.5
	doneBtn.y = display.contentHeight - 125

--widget slider for # of words to add, corresponding to _G.listLength value
 --  numberOfWordsSlider = widget.newSlider{
	-- 	font = _G.defaultFont, fontsize = _G.defaultFontSize,
 --   		labelColor = { default={255}, over={128} },
 --  		default="button.png",
 --  		over="button-over.png",
 --  		width=154, height=40,
	-- 	value = 5,
 --      	listener = numberOfWordsSliderListener
 --      	} 
 --      	-- event listener function
 --  numberOfWordsSlider:setValue(50)
 --  numberOfWordsSlider.x = display.contentWidth*0.5 - 44
 --  numberOfWordsSlider.y = doneBtn.y - 40
 --  boxText = display.newText(sceneGroup,"    #Words: 5",numberOfWordsSlider.x+105,numberOfWordsSlider.y)
 
	-- sceneGroup:insert( numberOfWordsSlider )
 	sceneGroup:insert( doneBtn ) 
end

function scene:show( event )
local sceneGroup = self.view
local phase = event.phase

if phase == "will" then

	-- Called when the scene is still off screen and is about to move on screen
elseif phase == "did" then
	-- Called when the scene is now on screen
	--
	-- INSERT code here to make the scene come alive
	-- e.g. start timers, begin animation, play audio, etc.
end
end

function scene:hide( event )
local sceneGroup = self.view
local phase = event.phase

if event.phase == "will" then
	_G.previousScene = "menu"

	-- Called when the scene is on screen and is about to move off screen
	--
	-- INSERT code here to pause the scene
	-- e.g. stop timers, stop animation, unload sounds, etc.)

elseif phase == "did" then
	-- Called when the scene is now off screen
end
end

function scene:destroy( event )
local sceneGroup = self.view

-- Called prior to the removal of scene's "view" (sceneGroup)
--
-- INSERT code here to cleanup the scene
-- e.g. remove display objects, remove touch listeners, save state, etc.

if doneBtn then
	doneBtn:removeSelf()	-- widgets must be manually `removed`
end
 
end

---------------------------------------------------------------------------------

-- Listener setup


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
