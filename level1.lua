-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
 _G.level1Visited = true

local widget = require "widget"

local composer = require( "composer" )
local scene = composer.newScene()
-- include Corona's "physics" library
local physics = require "physics"
physics.start(); --physics.pause() -- i don't see the point in physics.pause()
physics.setGravity(0,-2)


physics.setDrawMode("hybrid")
--Runtime:hideErrorAlerts( )
require("languages")
require("main")

_G.listLength = 5
_G.pickedLanguages = {_G.English, _G.Spanish}
numberRight  = 0 -- every time you get a word right, it incrrements this value up 1, every time u answer incorrectly it goes down 1
time = system.getTimer()-- these two values u will use to modify listLength and give the user an idea as to how they are doing
--------------------------------------------

function scoreEval()



end


-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
local scaleFactor = scaleFactorOfBoxes
local menuBtn

-- 'onRelease' event listener for menuBtn
local function onlanguagePickButtonRelease()

	-- go to level1.lua scene
	composer.gotoScene( "languagepick", "fade", 100 )

	return true	-- indicates successful tap

end

-- 'onRelease' event listener for menuBtn
local function onMenuBtnRelease()

	-- go to level1.lua scene
	composer.gotoScene( "menu", "fade", 100 )

	return true	-- indicates successful tap

end


	-- 'onRelease' event listener for optionsBtn
local function onOptionsBtnRelease()

		-- go to options.lua
 		composer.gotoScene( "options", "fade", 100 )

		return true	-- indicates successful tap
end

--crate creating function with for loop for making multiple crates on one tap event... added functionality
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

end


---      _              _ __                    _                       _              
--     (_)    _ __    | '_ \   ___      _ _   | |_    __ _    _ _     | |_      o O O 
--     | |   | '  \   | .__/  / _ \    | '_|  |  _|  / _` |  | ' \    |  _|    o      
--    _|_|_  |_|_|_|  |_|__   \___/   _|_|_   _\__|  \__,_|  |_||_|   _\__|   TS__[O] 
--  _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======| 
--  "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000' 
--       __                            _        _                                     
--      / _|  _  _    _ _      __     | |_     (_)     ___    _ _                     
--     |  _| | +| |  | ' \    / _|    |  _|    | |    / _ \  | ' \                    
--    _|_|_   \_,_|  |_||_|   \__|_   _\__|   _|_|_   \___/  |_||_|                   
--  _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|                  
--  "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'



function scene:create( event )
  local numFrames = 0
  local numAnsweredRight = 0
  local sceneGroup = self.view
  local cellWidth = 100
  local cellHeight = 30
  local languageCells1 = {}
  local languageCells2 = {}
  local languageSoundCells1 = {}
  local languageSoundCells2 = {}
  local g2 = _G.pickedLanguages[2]
  local g1 = _G.pickedLanguages[1]
  local lexiconSize = _G.initialWordCapacity	
  local listLength = _G.listLength

  -- print("listLength = "..listLength)

  physics.start()
  physics.setGravity(0,-2)
  local toprect = display.newRect(0,0,640,200)
  physics.addBody(toprect,"static")
  toprect:setFillColor(0,0,0)
  local background = display.newImageRect( "stock.jpg", screenW, screenH )
  background.anchorX = 0
  background.anchorY = 1
  background.x, background.y = 0, display.contentHeight

  function remove(obj)
    if obj.box then obj.box:removeSelf() end
    obj:removeSelf()
        if #languageCells2 <3  and #languageCells2 == #languageCells1 then 
          cellsCreate(sceneGroup,toprect.height/2,listLength-2,unpack(_G.pickedLanguages)) end
   end

  function cellExit(obj)
  	obj:setFillColor(1,0,0)
    transition.scaleTo(obj,{time = 700,alpha = 0,xScale=3,yScale =3, onComplete = remove})
    -- transition.to(obj,{time = 700,alpha = 0,scale=3,onComplete = remove})
  end


  		-- this checks for matching words, and calls for functions to clear them out as well as to add more words
  		-- kind of the bread and butter of the app
  function listCheck(obj) 
    local index, list = 0,0

    if table.indexOf(languageCells1, obj) then index = table.indexOf(languageCells1, obj); list =1 elseif
      table.indexOf(languageCells2, obj) then  index = table.indexOf(languageCells2,obj); list =2
    end

    if list == 1 and math.abs(languageCells2[index].y - obj.y) < 10 then 
      cellExit(obj); cellExit(languageCells2[index]); 
      -- cellExit(languageSoundCells2[index]); 
      table.remove(languageCells2,index);
      table.remove(languageCells1,index); 
      audio.play(audio.loadSound("applause.mp3"))


    elseif list ==2 and math.abs(languageCells1[index].y - obj.y) < 10 then
      cellExit(obj); cellExit(languageCells1[index]); 
      -- cellExit(languageSoundCells1[index]);
      table.remove(languageCells2,index);
      table.remove(languageCells1,index);
      audio.play(audio.loadSound("tada.mp3"))

    else 
      audio.play(audio.loadSound("wrong.mp3"))
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")
      -- print("it should be playing")

    end

  end

  local function networkListener( event )
    local obj = event.target
            local files = {}

            local lfs = require "lfs"

            local doc_path = system.pathForFile( "", system.DocumentsDirectory )

            for file in lfs.dir(doc_path) do
               --file is the current file or directory name
               table.insert(files, file)
               os.remove( system.pathForFile( file, system.DocumentsDirectory ))
               -- print( "Found file: " .. file )
            end
       
              
   
          if ( event.isError ) then
                  print ( "Network error - download failed" )
          else
                  print("no network error")
                   local speech = audio.loadSound(files[#files],system.DocumentsDirectory)

                  local playSpeech = function()
                          audio.play( speech )
                  end

                  playSpeech ()
          end
               -- os.remove( system.pathForFile( "corona.mp3", system.DocumentsDirectory ))

          -- print ( "RESPONSE: " .. event.response )
  end

  function soundMake(event)

    -- if event.phase == "began" then event.target.alpha = .5 end
    -- local obj = event.target
    -- local lng = obj.language
    --         local lfs = require "lfs"

    --         local doc_path = system.pathForFile( nil, system.DocumentsDirectory )

    --         for file in lfs.dir(doc_path) do
    --            --file is the current file or directory name
    --            -- os.remove( system.pathForFile( file, system.DocumentsDirectory ))
    --            -- print( "Found file: " .. file )
    --         end



    --  if event.phase == "ended" then
    --  event.target.alpha = 1
    --  network.download(

    --         "http://www.translate.google.com/translate_tts?tl="..obj.language.."&q="..obj.text,
    --         --  "http://www.trbimg.com/img-5559ef8d/turbine/la-na-waco-biker-gang-deaths-20150518-001/500/500x281",
    --          "GET",
    --          networkListener,
    --          math.random()..".mp3",
    --          -- obj.language..obj.text..".mp3",
    --          system.DocumentsDirectory )
    --                        end

  end

  function randomSetOfNumbersGenerator(length,listSize,existingTable)
    local randomSetOfNumbers = {1,2,3,4,5}
      -- for i = 1, listLength do
      --   randomSetOfNumbers[i] = math.ceil(math.random(listSize))
      -- end
    return randomSetOfNumbers
  end

  function wordListGenerator(array,lng)
    local list = {}

    -- print("xxxxxxxxx wordListGenerator arraysize = "..#array)
    -- print("xxxxxxxxx wordListGenerator lng = "..#lng)

    for i = 1, #array do
       list[i] = lng[array[i]]
       -- print( "lngArrayloop"..lng[array[i]])
    end

    -- for i = 1, #lng do
    --   print(lng[i].."wordListGenerator loop")
    -- end

    return list

  end

  function touched(event)



    local scaleFactor =1.1
    -- local box = event.target.box

    local cells = {} 

    -- print ("box.x"..box.x)

    if event.phase == "moved" or event.phase == "began"
    then
      event.target.alpha = .5

      -- box.stroke = {0.8, 0.8, 1, 1}

      physics.removeBody(event.target)
      -- physics.removeBody(box )

      event.target.xScale = scaleFactor; event.target.yScale = scaleFactor
      -- box.xScale = scaleFactor; box.yScale = scaleFactor;
      event.target:toFront()
      -- box:toFront()

      -- event.target.box.xScale =1.2
      display.getCurrentStage():setFocus( event.target )
      event.target.y = event.y
      -- box.y = event.y
      -- event.target.x = event.x
      -- box.x = event.x
      -- event.target.x = event.x

    else

      listCheck(event.target) -- this checks to see how low the list is to add more words

        event.target.alpha = 1

      if (event.y < 1/2*toprect.height  ) then  --this code prevents you from dragging the cells too far
        event.target.y = toprect.height -150
        -- event.target.box.y =   event.target.y
      end

      if (event.y > 300  ) then
        event.target.y = 200
        -- event.target.box.y =   event.target.y
      end

      --here you need to put in a function that checks

      display.getCurrentStage():setFocus( nil  )
      --you'll need to make a functin that transitions to the neerest neighbor or not stop physics
      event.target.xScale = 1; event.target.yScale =1
      -- box.xScale = 1; box.yScale =1;
      -- box.stroke =   { 1, 0.4, 0, 1 }
      physics.addBody(event.target,"dynamic ")

      -- physics.addBody(event.target.box,"dynamic")
      event.target.isFixedRotation = true
      -- event.target.box.isFixedRotation = true

      -- local weldJoint1 = physics.newJoint( "piston",  event.target,event.target.box,event.target.x,event.target.y,1,0,1,0)
      -- local weldJoint2 = physics.newJoint( "distance",event.target,event.target.box,event.target.anchorX,event.target.anchorY,event.target.box.anchorX,event.target.box.anchorY)



      -- event.target.box:addEventListener("touch",soundMake)

    end

  end

  local function buttonMake(x,y,width,height,lng,text,id)
 
                  local button = display.newText(text,width,height,_G.defaultFont,_G.defaultFontSize)
                  button.width = width
                  button:setFillColor(0,1,.5)
                  button.x, button.y = x,y
                  button.id = id
                  button.language = lng.symbol
                  physics.addBody(button,"dynamic ")
                  button.isFixedRotation = true
                  button.alpha = 0
                  transition.to(button,{time = 1000, alpha =1})
                  button:addEventListener("touch",touched) 
                  return button
  end

  local function soundCellMake(x,y,width,height,lng,text,id)
                  local radius = 10
 
                  local soundCell = display.newCircle(width,height,radius)
                  soundCell:setFillColor(0,0,1)
                  soundCell.x, soundCell.y = x+cellWidth*.5 + radius*1.1,y
                  soundCell.id = id
                  soundCell.language = lng.symbol
                  physics.addBody(soundCell,"dynamic ")
                  soundCell.isFixedRotation = true
                  soundCell.alpha = 0
                  transition.to(soundCell,{time = 1000, alpha =1})
                  soundCell:addEventListener("touch",soundMake) 
                  return soundCell
  end




  function cellsCreate(parent,yInit,listLength,lng1,lng2)
    local cells1, cells2,languageSoundCells1,languageSoundCells2 = {},{},{},{}
    local randArray = randomSetOfNumbersGenerator(listLength,lexiconSize)
    local wordlist1 = wordListGenerator(randArray,lng1)
    -- for i = 1, #wordlist1 do print ("wordlist1 = "..wordlist1[i]) end
    local wordlist2 = wordListGenerator(randArray,lng2)
    -- for i = 1, #wordlist2 do print ("wordlist2 = "..wordlist2[i]) end

    local cellStartX, cellStartY = (display.contentWidth-1.5*cellWidth)/2, yInit


    for i = 1, listLength do
      local randomDist = 150*math.random()
    	local c1 = buttonMake(cellStartX,cellStartY,cellWidth,cellHeight,lng1,wordlist1[i],i)
    	local c2 = buttonMake(cellStartX+1.5*cellWidth,cellStartY+randomDist,cellWidth,cellHeight,lng2,wordlist2[i],i)
      table.insert(languageCells1, c1)
      table.insert(languageCells2, c2)
      parent:insert(c1)
      parent:insert(c2)

      -- local c3 = soundCellMake(cellStartX,cellStartY,cellWidth,cellHeight,lng1,wordlist1[i],i)
      -- local c4 = soundCellMake(cellStartX+1.5*cellWidth,cellStartY+randomDist,cellWidth,cellHeight,lng2,wordlist2[i],i)
      -- table.insert(languageSoundCells1, c3)
      -- table.insert(languageSoundCells2, c4)
      -- parent:insert(c3)
      -- parent:insert(c4)

      -- local weldJoint = physics.newJoint( "distance",c1,c3,c1.anchorX,c1.anchorY,c3.anchorX,c3.anchorY)    -- making joints between the wordcells and the circle next to it
      -- local distanceJoint = physics.newJoint( "distance",c1,c3,c1.anchorX,c1.anchorY,c3.anchorX,c3.anchorY)

      -- local weldJoint2 = physics.newJoint( "distance",c2,c4,c2.anchorX,c2.anchorY,c4.anchorX,c4.anchorY)-- making joints between the wordcells and the circle next to it
      -- local distanceJoint2 = physics.newJoint( "distance",c2,c4,c2.anchorX,c2.anchorY,c4.anchorX,c4.anchorY)
 

 
    end
      
  end


  -- create a widget button (which will loads menu.lua on release)
  --widget button for picking languages
  languagePickButton = widget.newButton{
  	font = _G.defaultFont, fontsize = _G.defaultFontSize,
		label = "Pick Languages",
		labelColor = { default={155,0,155}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = onlanguagePickButtonRelease	-- event listener function
	}

	languagePickButton.x = display.contentWidth*0.5
	languagePickButton.y = display.contentHeight - (125 +40)/2

  langText = display.newText(_G.pickedLanguages[1].symbol.."         ".._G.pickedLanguages[2].symbol,154,40,_G.defaultFont,44)
  langText:setFillColor(0.05)
  -- langText = widget.newButton{
  --   font = _G.defaultFont, fontSize = 44,
  --   label= _G.pickedLanguages[1].symbol.."         ".._G.pickedLanguages[2].symbol,
  --   labelColor = { default={0,0,0,.5}, over={0,0,0,.9} },
  --   default="button.png",
  --   over="button-over.png",
  --   width=154, height=40, -- event listener function where onMenuBtnRelease sends us back to menu.lua with composer
  -- }
  langText.x = display.contentWidth*0.5
  langText.y = display.contentHeight - 210

  menuBtn = widget.newButton{
  	font = _G.defaultFont, fontsize = _G.defaultFontSize,
  	label="Return to Main Menu",
  	labelColor = { default={255,0,255}, over={128} },
  	default="button.png",
  	over="button-over.png",
  	width=154, height=40,
  	onRelease = onMenuBtnRelease	-- event listener function where onMenuBtnRelease sends us back to menu.lua with composer
  }
  menuBtn.x = display.contentWidth*0.5
  menuBtn.y = display.contentHeight - 125

  -- create a widget button (which will loads options.lua on release)

  optionsBtn = widget.newButton{
  	font = _G.defaultFont, fontsize = _G.defaultFontSize,
  	label="Options",
  	labelColor = { default={155,0,155}, over={128} },
  	default="button.png",
  	over="button-over.png",
  	width=154, height=40,
  	onRelease = onOptionsBtnRelease	-- event listener function where onOptionsBtnRelease sends us to options.lua with composer
  }
  optionsBtn.x = menuBtn.x
  optionsBtn.y = menuBtn.y - 40



  -- cellsCreate(toprect.height*.5,_G.listLength,unpack(_G.pickedLanguages))


  -- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
  -- local grassShape = { -halfW,-34, halfW,-34, halfW,34, -halfW,34 }
  -- physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

  -- all display objects must be inserted into group
  sceneGroup:insert( toprect)
  sceneGroup:insert( background )
  -- sceneGroup:insert( grass)
  sceneGroup:insert( menuBtn )
  sceneGroup:insert( optionsBtn )
  sceneGroup:insert( languagePickButton )
  sceneGroup:insert( langText )

  cellsCreate(sceneGroup,toprect.height,listLength,g1,g2)

  function newFrame(event)
    numFrames = numFrames +1

  
  end

end




function scene:show( event )
sceneGroup = self.view
 
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
    langText.label = math.random()

  	if event.phase == "will" then
  		previousScene = "level1"

  		-- Called when the scene is on screen and is about to move off screen
  		--
  		-- INSERT code here to pause the scene
  		-- e.g. stop timers, stop animation, unload sounds, etc.)

  		physics.pause() -- this used to be physics.stop()
  		Runtime:removeEventListener( "tap", self ) -- this was really key, otherwise I ended up making mulitple boxes by accident

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

    -- crateCreate(event,sceneGroup)

  	menuBtn:toFront()
  	optionsBtn:toFront()
  	--i added this code to make sure that on each tap the menu options stay in front so that you can see them
end





---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------



return scene

