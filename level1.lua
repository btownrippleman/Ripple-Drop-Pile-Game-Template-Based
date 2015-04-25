-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------


local widget = require "widget"

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); --physics.pause() -- i don't see the point in physics.pause()

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local scaleFactor = scaleFactorOfBoxes
local menuBtn

-- 'onRelease' event listener for menuBtn
local function onMenuBtnRelease()

	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 100 )

	return true	-- indicates successful tap

end


	-- 'onRelease' event listener for menuBtn
local function onOptionsBtnRelease()

		-- go to options.lua
 		composer.gotoScene( "options", "fade", 100 )

		return true	-- indicates successful tap
end


local function crateCreate(event,parent)

	-- So, we can get the proper display group for the scene
	for i=1,numberOfBoxes do
		crate = display.newImage("crate.png", event.x, event.y)
		local scaleX,scaleY = scaleFactorOfBoxes,scaleFactorOfBoxes;
		crate:scale(scaleX,scaleY);
		--display.newText(numberOfBoxes,math.random(333),math.random(333))
		--this was just really see the actual value of the number of boxes, i realized the real problem was that i need to remove the event listener

		local nw, nh = crate.width*scaleX*0.5, crate.height*scaleY*0.5;
		physics.addBody(crate, { density = 2.5, friction = .2, bounce = boxBounciness, shape={-nw,-nh,nw,-nh,nw,nh,-nw,nh} });
		parent:insert(crate)
  end


	--menuBtn:toFront()
  --return crate
end


function scene:create( event )



	-- Called when the scene's view does not exist.
	--
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add tap listeners, etc.

	local sceneGroup = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background.anchorX = 0
	background.anchorY = 0
	background:setFillColor( .5 )

	-- make a crate (off-screen), position it, and rotate slightly
	local crate = display.newImageRect( "crate.png", 90, 90 )
	crate.x, crate.y = 160, -100
	crate.rotation = 15

	-- add physics to the crate
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.3 } )

	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 82 )
	grass.anchorX = 0
	grass.anchorY = 1
	grass.x, grass.y = 0, display.contentHeight
	-- create a widget button (which will loads level1.lua on release)

	menuBtn = widget.newButton{
		label="Return to Main Menu",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onMenuBtnRelease	-- event listener function
	}
	menuBtn.x = display.contentWidth*0.5
	menuBtn.y = display.contentHeight - 125

	optionsBtn = widget.newButton{
		label="Options",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onOptionsBtnRelease	-- event listener function
	}
	optionsBtn.x = menuBtn.x
	optionsBtn.y = menuBtn.y - 40


	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( grass)
	sceneGroup:insert( crate )
	sceneGroup:insert( menuBtn )
	sceneGroup:insert( optionsBtn )

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
		physics.start()
		Runtime:addEventListener( "tap", self )

	end
end

function scene:hide( event )

	local sceneGroup = self.view

	local phase = event.phase

	if event.phase == "will" then
		previousScene = "level1"

		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)

		physics.pause() -- this used to be physics.stop()
		Runtime:removeEventListener( "tap", self )

	elseif phase == "did" then
		-- Called when the scene is now off screen
	end

end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	--
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove tap listeners, save state, etc.
	local sceneGroup = self.view

	package.loaded[physics] = nil
	physics = nil
end

function scene:tap( event )
	local sceneGroup = self.view

  crateCreate(event,sceneGroup)
	--text = display.newText(numberOfBoxes,math.random(300),math.random(300))
  --sceneGroup:insert(text)
	menuBtn:toFront()
	optionsBtn:toFront()
	-- Increment our global circle counter
	--g.numCircles = g.numCircles + 1
end
---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
