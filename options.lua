-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local newText =display.newText("",math.random(300),math.random(300))


-- include Corona's "widget" library
local widget = require "widget"
local sceneGroup

-- forward declarations and other locals

-- 'onRelease' event listener for doneBtn

local function   numberOfBoxesSliderListener(event)
	numberOfBoxes = math.round(event.value/maxNumberOfBoxes)
--newText.text = ""
--newText = display.newText(numberOfBoxes,math.random(300),math.random(300))
-- I used this as a means of catching errors

end

local function   boxSizeSliderListener(event)
	scaleFactorOfBoxes =  event.value*0.01
--display.newText(scaleFactorOfBoxes,math.random(300),math.random(300))
-- I used this as a means of catching errors

end

local function   boxBouncinessSlider(event)
	boxBounciness =  event.value*0.01
--display.newText(boxBounciness,math.random(300),math.random(300))
-- I used this as a means of catching errors

end


local function onDoneBtnRelease()
  	-- go to level1.lua scene
  	composer.gotoScene( previousScene, "fade", 100 )

  	return true	-- indicates successful touch
  end

function scene:create( event )
	 local sceneGroup = self.view


  doneBtn = widget.newButton{
		label = "Done",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onDoneBtnRelease	-- event listener function
	}

	doneBtn.x = display.contentWidth*0.5
	doneBtn.y = display.contentHeight - 125

  numberOfBoxesSlider = widget.newSlider{
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

	boxSizeSlider = widget.newSlider{
  		labelColor = { default={255}, over={128} },
  		default="button.png",
  		over="button-over.png",
  		width=154, height=40,
      listener = boxSizeSliderListener	-- event listener function
  	}
	boxSizeSlider.x = numberOfBoxesSlider.x
	boxSizeSlider.y = numberOfBoxesSlider.y - 40
	boxText2 = display.newText(sceneGroup,"  Box Size",boxSizeSlider.x+105,boxSizeSlider.y)

	boxBouncinessSlider = widget.newSlider{
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
--	sceneGroup:insert( background )
	--sceneGroup:insert( titleLogo )

	sceneGroup:insert( numberOfBoxesSlider )
	sceneGroup:insert( boxSizeSlider )
	sceneGroup:insert( boxBouncinessSlider )
	sceneGroup:insert( boxText )
	sceneGroup:insert( boxText2 )
	sceneGroup:insert( boxText3 )
	sceneGroup:insert( doneBtn )




-- Called when the scene's view does not exist.
--
-- INSERT code here to initialize the scene
-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

-- display a background image
--local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
--	background.anchorX = 0
--	background.anchorY = 0
--background.x, background.y = 0, 0

-- create/position logo/title image on upper-half of the screen
--	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
--titleLogo.x = display.contentWidth * 0.5
--titleLogo.y = 100

-- create a widget button (which will loads level1.lua on release)

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
	doneBtn:removeSelf()	-- widgets must be manually removed
	doneBtn = nil
end
--[[  else if doneBtn then
doneBtn:removeSelf()
doneBtn = nil
end]]--
end

---------------------------------------------------------------------------------

-- Listener setup


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
