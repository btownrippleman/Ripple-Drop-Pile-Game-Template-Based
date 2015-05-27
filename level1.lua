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
-- physics.setDrawMode("hybrid")
--Runtime:hideErrorAlerts( )
require("languages")
require("main")
_G.listLength = 5 -- the number of words it adds each time
_G.pickedLanguages = {_G.English, _G.Spanish} -- tried to use this declaration in main.lua but essentially it initializes English and Spanish

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

	-- go to menu.lua scene
	composer.gotoScene( "menu", "fade", 100 )

	return true	-- indicates successful tap

end
	-- 'onRelease' event listener for optionsBtn
local function onOptionsBtnRelease()

		-- go to options.lua
 		composer.gotoScene( "options", "fade", 100 )

		return true	-- indicates successful tap
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
-- scene:create is the most important function of this file
---

function scene:create( event )

  local sceneGroup = self.view
  local cellWidth = 100 -- width of word cells
  local cellHeight = 30 -- height of word cells
  local languageCells1 = {} -- array for the first column of word cells
  local languageCells2 = {} -- array for the second
  local g2 = _G.pickedLanguages[2] -- using these local variables for languages
  local g1 = _G.pickedLanguages[1]
  local lexiconSize = 200 -- this i'll change in the future but it just assumes you know 200 words in each language
 
  physics.start()
  physics.setGravity(0,-2) -- this pushes the wordCell upward
  local toprect = display.newRect(0,0,640,200) -- this stops the wordCells from moving upward with upward gravity
  physics.addBody(toprect,"static")
  toprect:setFillColor(0,0,0)
  local background = display.newImageRect( "stock.jpg", screenW, screenH )
  background.anchorX = 0
  background.anchorY = 1
  background.x, background.y = 0, display.contentHeight

  function remove(obj) 
    if obj.box then obj.box:removeSelf() end
    obj:removeSelf()
        if #languageCells2 <3  and #languageCells2 == #languageCells1 then -- this is where extra words are added based on _G.listLength, keeps game flowing
          cellsCreate(sceneGroup,toprect.height/2,_G.listLength,unpack(_G.pickedLanguages)) end
   end

  function cellExit(obj) -- this makes the objects kind of explode and leave
  	obj:setFillColor(1,0,0)
    transition.scaleTo(obj,{time = 700,alpha = 0,xScale=3,yScale =3, onComplete = remove}) -- objects then are removed  after animation is done
   end


  		-- this checks for matching words, and calls for functions to clear them out as well as to add more words
  		-- kind of the bread and butter of the app
  function listCheck(obj) 
    local index, list = 0,0

    if table.indexOf(languageCells1, obj) then index = table.indexOf(languageCells1, obj); list =1 elseif
      table.indexOf(languageCells2, obj) then  index = table.indexOf(languageCells2,obj); list =2
    end

    if list == 1 and math.abs(languageCells2[index].y - obj.y) < 10 then 
      print ("list =1")
      cellExit(obj); cellExit(languageCells2[index]); 
      -- cellExit(languageSoundCells2[index]); 
      table.remove(languageCells2,index);
      table.remove(languageCells1,index); 
      audio.play(audio.loadSound("applause.mp3")) -- this is a sound made to indicate you got the word right


    elseif list ==2 and math.abs(languageCells1[index].y - obj.y) < 10 then
      cellExit(obj); cellExit(languageCells1[index]); 
      -- cellExit(languageSoundCells1[index]);
      table.remove(languageCells2,index);
      table.remove(languageCells1,index);
      audio.play(audio.loadSound("tada.mp3")) -- this is a sound made to indicate you got the word right

    else 
      audio.play(audio.loadSound("wrong.mp3"))  -- this is a sound made to indicate you got the word incorrect

    end

  end

  local function networkListener( event ) -- this worked in class but I had a hard time testing it on my computer
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

  function soundMake(event) -- this was the function to call the function above, which I used in class, but not for this particular
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

  function randomSetOfNumbersGenerator(length,listSize) -- this generates a random set of numbers from which we used to pick the same words from
                                                        -- two different languages
    local randomSetOfNumbers = {}
      for i = 1, length do
        table.insert(randomSetOfNumbers, math.ceil(math.random(listSize)))
      end
    return randomSetOfNumbers
  end

  function wordListGenerator(array,lng)  -- we then use this below in the cellsCreate function taking the array above to get our words
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

  function touched(event)  -- this is used for the words to move them up and down, i had to remove physics and put it back in to get this to work 
    local scaleFactor =1.1
     local cells = {} 
 
    if event.phase == "moved" or event.phase == "began"
    then
      event.target.alpha = .5
      physics.removeBody(event.target)
      event.target.xScale = scaleFactor; event.target.yScale = scaleFactor
      event.target:toFront()
      display.getCurrentStage():setFocus( event.target )
      event.target.y = event.y
    else
      listCheck(event.target) -- this checks to see how low the list is to add more words
      event.target.alpha = 1
      if (event.y < 1/2*toprect.height  ) then  --this code prevents you from dragging the cells too far
        event.target.y = toprect.height -150
      end

      if (event.y > 300  ) then
        event.target.y = 200
      end

      display.getCurrentStage():setFocus( nil  )
      event.target.xScale = 1; event.target.yScale =1
      physics.addBody(event.target,"dynamic ")
      event.target.isFixedRotation = true
    end

  end

  -- local function soundCellMake(x,y,width,height,lng,text,id)  left this code for the future 
  --                 local radius = 10
 
  --                 local soundCell = display.newCircle(width,height,radius)
  --                 soundCell:setFillColor(0,0,1)
  --                 soundCell.x, soundCell.y = x+cellWidth*.5 + radius*1.1,y
  --                 soundCell.id = id
  --                 soundCell.language = lng.symbol
  --                 physics.addBody(soundCell,"dynamic ")
  --                 soundCell.isFixedRotation = true
  --                 soundCell.alpha = 0
  --                 transition.to(soundCell,{time = 1000, alpha =1})
  --                 soundCell:addEventListener("touch",soundMake) 
  --                 return soundCell
  -- end

  local function wordMake(x,y,width,height,lng,text,id) -- this makes individual word cells
 
                  local wordCell = display.newText(text,width,height,_G.defaultFont,_G.defaultFontSize)
                  wordCell.width = width
                  wordCell:setFillColor(0,1,.5)
                  wordCell.x, wordCell.y = x,y
                  wordCell.id = id
                  wordCell.language = lng.symbol
                  physics.addBody(wordCell,"dynamic ")
                  wordCell.isFixedRotation = true
                  wordCell.alpha = 0
                  transition.to(wordCell,{time = 1000, alpha =1})
                  wordCell:addEventListener("touch",touched) 
                  return wordCell
  end


  function cellsCreate(parent,yInit,listLength,lng1,lng2) -- this is for making the two columns of words
    --local languageCells1, languageCells2 = {},{}  -- cells for the columns of words
    local randArray = randomSetOfNumbersGenerator(listLength,lexiconSize)
    local wordlist1 = wordListGenerator(randArray,lng1)
    local wordlist2 = wordListGenerator(randArray,lng2)
    local cellStartX, cellStartY = (display.contentWidth-1.5*cellWidth)/2, yInit

    for i = 1, listLength do
      local randomDist = 150*math.random()
    	local c1 = wordMake(cellStartX,cellStartY,cellWidth,cellHeight,lng1,wordlist1[i],i)
    	local c2 = wordMake(cellStartX+1.5*cellWidth,cellStartY+randomDist,cellWidth,cellHeight,lng2,wordlist2[i],i)
      table.insert(languageCells1, c1)
      table.insert(languageCells2, c2)
      parent:insert(c1)
      parent:insert(c2)
 
    end
      
  end


  -- widget button for picking languages, i.e.taking you to languagepick.lua
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

  --heres the text which shows which languages our on display. when you change the languages in options, however, the old words still remain
  langText = display.newText(_G.pickedLanguages[1].symbol.."         ".._G.pickedLanguages[2].symbol,154,40,_G.defaultFont,44)
  langText:setFillColor(0.05)
  langText.x = display.contentWidth*0.5
  langText.y = display.contentHeight - 210

  -- pretty straight forward, takes u back to menu.lua, i.e. this is the button for that
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

  -- this takes you to the options screen, i.e. to change the number of words to be added each time words get added
  optionsBtn = widget.newButton{
  	font = _G.defaultFont, fontsize = _G.defaultFontSize,
  	label="Number of Words Added",
  	labelColor = { default={155,0,155}, over={128} },
  	default="button.png",
  	over="button-over.png",
  	width=154, height=40,
  	onRelease = onOptionsBtnRelease	-- event listener function where onOptionsBtnRelease sends us to options.lua with composer
  }
  optionsBtn.x = menuBtn.x
  optionsBtn.y = menuBtn.y - 40

 -- all the objects are added to the scene so that they don't show up elsewhere
  sceneGroup:insert( toprect)
  sceneGroup:insert( background )
  sceneGroup:insert( menuBtn )
  sceneGroup:insert( optionsBtn )
  sceneGroup:insert( languagePickButton )
  sceneGroup:insert( langText )

  cellsCreate(sceneGroup,toprect.height,_G.listLength,g1,g2) -- this is where the function is called to make the two columns of words
 
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
end

--------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

