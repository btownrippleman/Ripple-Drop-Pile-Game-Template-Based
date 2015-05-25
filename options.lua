-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
require("languages")
local composer = require( "composer" )
local scene = composer.newScene()


-- include Corona's "widget" library
local widget = require "widget"

-- forward declarations and other locals
local sceneGroup



-- the next 3 sliderlisteners are to change value in number of boxes, box size and bounciness

local function   numberOfBoxesSliderListener(event)
	numberOfBoxes = math.round(event.value*maxNumberOfBoxes/100)
end

local function   boxSizeSliderListener(event)
	scaleFactorOfBoxes =  event.value*0.01
end

local function   boxBouncinessSliderListener(event)
	boxBounciness =  event.value*0.01
end

local function onDoneBtnRelease()
  	-- go to previous scene
  	composer.gotoScene( previousScene, "fade", 100 )

  	return true	-- indicates successful touch
end
local function onlanguagePickButtonRelease()
  	-- go to previous scene
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
		onRelease = onDoneBtnRelease	-- event listener function
	}

	doneBtn.x = display.contentWidth*0.5
	doneBtn.y = display.contentHeight - 125

--widget slider for # of boxes ranging from 1 to 10 starting at an initial value of 1
  numberOfBoxesSlider = widget.newSlider{
		font = _G.defaultFont, fontsize = _G.defaultFontSize,
   		labelColor = { default={255}, over={128} },
  		default="button.png",
  		over="button-over.png",
  		width=154, height=40,
		value = 5,
      	listener = numberOfBoxesSliderListener	-- event listener function
  	}
  numberOfBoxesSlider.x = display.contentWidth*0.5 - 44
  numberOfBoxesSlider.y = doneBtn.y - 40
	boxText = display.newText(sceneGroup," #Boxes",numberOfBoxesSlider.x+105,numberOfBoxesSlider.y)

	--widget slider for box size changing a scale factor from 0 to 1 of the initial large box starting at .5
	boxSizeSlider = widget.newSlider{
		font = _G.defaultFont, fontsize = _G.defaultFontSize,
  		labelColor = { default={255}, over={128} },
  		default="button.png",
  		over="button-over.png",
  		width=154, height=40,
      listener = boxSizeSliderListener	-- event listener function
  	}
	boxSizeSlider.x = numberOfBoxesSlider.x
	boxSizeSlider.y = numberOfBoxesSlider.y - 40
	boxText2 = display.newText(sceneGroup,"  Box Size",boxSizeSlider.x+105,boxSizeSlider.y)

	--widget slider for box bounciness going from 0 to 1 starting at .5
	boxBouncinessSlider = widget.newSlider{
		font = _G.defaultFont, fontsize = _G.defaultFontSize,
  		labelColor = { default={255}, over={128} },
  		default="button.png",
  		over="button-over.png",
  		width=154, height=40,
      	listener = boxBouncinessSliderListener	-- event listener function
	  	}
	boxBouncinessSlider.x = numberOfBoxesSlider.x
	boxBouncinessSlider.y = boxSizeSlider.y - 40
	boxText3  = display.newText(sceneGroup,"      Bounciness",boxBouncinessSlider.x+105,boxBouncinessSlider.y)

	-- all display objects must be inserted into group

	sceneGroup:insert( numberOfBoxesSlider )
	sceneGroup:insert( boxSizeSlider )
	sceneGroup:insert( boxBouncinessSlider )
	sceneGroup:insert( boxText )
	sceneGroup:insert( boxText2 )
	sceneGroup:insert( boxText3 )
	sceneGroup:insert( doneBtn ) 
	-- sceneGroup:insert( languagePickButton ) 

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
	previousScene = "options"

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
