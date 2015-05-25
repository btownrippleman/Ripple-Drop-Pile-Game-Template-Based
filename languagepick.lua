-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------
require("languages")
require("level1")
local composer = require( "composer" )
local scene = composer.newScene()
_G.pickedLanguages = {asdf,asldkjafld}

-- include Corona's "widget" library
local widget = require "widget"

-- forward declarations and other locals





function scene:create( event )
    local sceneGroup = self.view

    function onDoneBtnRelease(event)
        local values =  languagePicker:getValues()
        
        print ("pickerwheelvals".._LANGUAGES[values[1].index].symbol)
        _G.pickedLanguages = {_LANGUAGES[values[1].index],  _LANGUAGES[values[2].index]}

        composer.gotoScene( "level1", "fade", 100 )

        return true -- indicates successful touch
    end

    local sceneGroup = self.view

     --widget button for returning to prev screen
    local doneBtn = widget.newButton{
        font = _G.defaultFont, fontsize = _G.defaultFontSize,
        label = "Done",
        labelColor = { default={255}, over={128} },
        default="button.png",
        over="button-over.png",
        width=154, height=40,
        onRelease = onDoneBtnRelease    -- event listener function
    }

    doneBtn.x = display.contentWidth*0.5
    doneBtn.y = display.contentHeight - 111

    -- Configure the picker wheel columns
    local columnData = 
    {
    -- Language of the first column
    { 
        align = "right",
        width = 140,
        startIndex = 5,
        labels = _G.languages
    },
    -- Language of the Second Column
    {
        align = "left",
        width = 140,
        startIndex = 5,
        labels = _G.languages
    }
    }

    -- Create the widget
      languagePicker = widget.newPickerWheel
    {
        font = _G.defaultFont, fontsize = _G.defaultFontSize,
        top =   111,
        font= _G.defaultFont,
        columns = columnData,
        overlayFrame = 1,
        overlayFrameWidth = 320,
        overlayFrameHeight = 222,
        backgroundFrame = 2,
        backgroundFrameWidth = 320,
        backgroundFrameHeight = 222,
        separatorFrame = 3,
        separatorFrameWidth = 8,
        separatorFrameHeight = 222,
        columnColor = { 0, 0, 0, 0 },
        fontColor = { 0.4, 0.4, 0.4, 0.5 },
        fontColorSelected = { 0.2, 0.6, 0.4 }
    }

    --widget button for returning to prev screen

    sceneGroup:insert(  languagePicker )
    sceneGroup:insert( doneBtn )

    end


function scene:show( event )
local sceneGroup = self.view
local phase = event.phase
-- if sceneGroup:pickerWheel then print "scene group pickherwwell in hide is recognizeed " end
 
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
    doneBtn:removeSelf()    -- widgets must be manually `removed`
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
 