-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

function genInit()
  widget = require "widget"
  composer = require( "composer" )
  scene = composer.newScene()
  -- include Corona's "physics" library
  physics = require "physics"
  physics.start();
  physics.setGravity(0,-2)
  physics.setDrawMode("hybrid")
  --Runtime:hideErrorAlerts( )
  require("languages")
  require("main")
  _G.listLength = 5 -- the number of words it adds each time
  _G.pickedLanguages = {_G.English, _G.Spanish} 
  -- forward declarations and other s
  screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
  scaleFactor = scaleFactorOfBoxes
  menuBtn = {}
 end

genInit()

local function onlanguagePickButtonRelease(event)
  local color = event.target.color
   if event.phase == "began" and event.target.color then
   event.target:setFillColor(1,1,1)
   event.target.alpha = .5
   transition.to(event.target,{alpha = 1, time = 250, easing = easeOutBack})
  elseif event.phase == "ended" then
      event.target:setFillColor(unpack(color)) 
      composer.gotoScene( "languagepick", "fade", 100 )

  end
	return true	-- indicates successful tap
 end
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
---

function scene:create( event )
  function init() -- where all the initial physical UI is created
   sceneGroup = self.view
      cellWidth = 100 -- width of word cells
      cellHeight = 30 -- height of word cells
    _G.languageCells1 = {} -- array for the first column of word cells
    _G.languageCells2 = {} -- array for the second
      g2 = _G.pickedLanguages[2] -- using these local variables for languages
      g1 = _G.pickedLanguages[1]
     lexiconSize = 200 -- this i'll change in the future but it just assumes you know 200 words in each language
   
    physics.setGravity(0,-2) -- this pushes the wordCell upward
     toprect = display.newRect(0,0,640,200) -- this stops the wordCells from moving upward with upward gravity
    physics.addBody(toprect,"static")
    toprect:setFillColor(0,0,0)
    background = display.newImageRect( "stock.jpg", screenW, screenH )
    background.anchorX = 0
    background.anchorY = 1
    background.x, background.y = 0, display.contentHeight

    langText = langTextMaker(display.contentWidth*0.5 - 80, display.contentHeight - 210, _G.pickedLanguages[1].symbol)
    langText2 = langTextMaker(display.contentWidth*0.5 + 55, display.contentHeight - 210, _G.pickedLanguages[2].symbol)

      languagePickButton = widget.newButton{

    font = _G.defaultFont, fontsize = _G.defaultFontSize,
    x = display.contentWidth*0.5,
    y = display.contentHeight - (125 +40)/2,
    label = "Pick Languages",
    labelColor = { default={155,0,155}, over={128} },
    default="button.png",
    over="button-over.png",
    width=154, height=40,
    onRelease = onlanguagePickButtonRelease -- event listener function
    }
    languagePickButton.color = {155,0,155}
    


    

    -- pretty straight forward, takes u back to menu.lua, i.e. this is the button for that
    menuBtn = widget.newButton{
      x = display.contentWidth*0.5,
      y = display.contentHeight - 125,
      font = _G.defaultFont, fontsize = _G.defaultFontSize,
      label="Return to Main Menu",
      labelColor = { default={255,0,255}, over={128} },
      default="button.png",
      over="button-over.png",
      width=154, height=40,
      onRelease = onMenuBtnRelease  -- event listener function where onMenuBtnRelease sends us back to menu.lua with composer
    }

    -- this takes you to the options screen, i.e. to change the number of words to be added each time words get added
    optionsBtn = widget.newButton{
      font = _G.defaultFont, fontsize = _G.defaultFontSize,
      label="Number of Words Added",
      labelColor = { default={155,0,155}, over={128} },
      default="button.png",
      over="button-over.png",
      width=154, height=40,
      onRelease = onOptionsBtnRelease -- event listener function where onOptionsBtnRelease sends us to options.lua with composer
    }
    optionsBtn.x = menuBtn.x
    optionsBtn.y = menuBtn.y - 40

    sceneGroup:insert( toprect)
    sceneGroup:insert( background )
    sceneGroup:insert( menuBtn )
    sceneGroup:insert( optionsBtn )
    sceneGroup:insert( languagePickButton )
    sceneGroup:insert( langText )
    sceneGroup:insert( langText2 )
   end
   
  function remove(obj)    
    display.remove(obj)
    obj = nil
   end

  function cellExit(obj) -- this makes the objects kind of explode and leave
    local overAllScale = 3
    obj:removeEventListener("touch", touched); obj.soundButton:removeEventListener("touch", soundMake)
    local params = {time = 700,alpha = 0,xScale=overAllScale,yScale =overAllScale, onComplete = remove}
  	obj:setFillColor(1,0,0)
    passThroughImportantFields( transition.scaleTo, obj, params)
   end
		
  function listCheck(obj) -- obj refers to the cell that's being currently touched
    -- this checks for matching words, and calls for functions to clear them out as well as to add more words
      -- kind of the bread and butter of the app
    local index, list = 0,0

    if table.indexOf(_G.languageCells1, obj) then index = table.indexOf(_G.languageCells1, obj); list =1 
    else index = table.indexOf(_G.languageCells2,obj); list =2
    
    end

    if list == 1 and math.abs(_G.languageCells2[index].y - obj.y) < cellHeight/2 then 
      print ("cell picked from list 1")
      cellExit(obj); cellExit(_G.languageCells2[index]); 
      -- cellExit(languageSoundCells2[index]); 
      table.remove(_G.languageCells2,index);
      table.remove(_G.languageCells1,index); 
      playCongratulatorySound()       -- this is a sound made to indicate you got the word right

    elseif list ==2 and math.abs(_G.languageCells1[index].y - obj.y) < cellHeight/2 then
      print ("cell picked from list 2")
      cellExit(obj); cellExit(_G.languageCells1[index]); 
      -- cellExit(languageSoundCells1[index]);
      table.remove(_G.languageCells2,index);
      table.remove(_G.languageCells1,index);
      playCongratulatorySound()  -- this is a sound made to indicate you got the word right

    else 
      audio.play(audio.loadSound("wrong.mp3"))  -- this is a sound made to indicate you got the word incorrect
    end
   end

  local function networkListener( event )
    local obj = event.target
    local files = {}
    local lfs = require "lfs"
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )

    for file in lfs.dir(doc_path) do
       --file is the current file or directory name
       table.insert(files, file)
       --os.remove( system.pathForFile( file, system.TemporaryDirectory ))
       print( "Found file: " .. file )
    end

    if ( event.isError ) then
       print ( "Network error - download failed" )
    else
      print("no network error")
      local speech = audio.loadSound(files[3],system.TemporaryDirectory)

      local playSpeech = function()
              audio.play( speech )
      end

      playSpeech ()
    end

    os.remove( system.pathForFile( "corona.mp3", system.TemporaryDirectory ))
    print ( "RESPONSE: " .. event.response )
   end -- used to download the words using googles unofficial API tts

  function soundMake(event)
    local obj = event.target
    local lng = obj.language
    local lfs = require "lfs"
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )

      for file in lfs.dir(doc_path) do
         --file is the current file or directory name
         os.remove( system.pathForFile( file, system.TemporaryDirectory ))
         print( "Found file: " .. file )
      end

    if event.phase == "began" then event.target.alpha = .5;event.target.xScale = 1.1; event.target.yScale = 1.1 
         network.download(

            "http://www.translate.google.com/translate_tts?tl="..obj.language.."&q="..obj.text,
            --  "http://www.trbimg.com/img-5559ef8d/turbine/la-na-waco-biker-gang-deaths-20150518-001/500/500x281",
             "GET",
             networkListener,
             math.random()..".mp3",
             -- obj.language..obj.text..".mp3",
             system.TemporaryDirectory )
    else
     event.target.alpha = 1; event.target.xScale = 1; event.target.yScale = 1 

    end
   end -- used for making the sounds of the words

  function randomSetOfNumbersGenerator(length,listSize) -- this generates a random set of numbers from which we used to pick the same words from
    local randomSetOfNumbers = {}
      for i = 1, length do
        local a =  math.ceil(math.random(listSize))
        table.insert(randomSetOfNumbers, a)
      end
    return randomSetOfNumbers
   end

  function wordListGenerator(array,lng)  -- we then use this below in the _G.cellsCreate function taking the array above to get our words
    local list = {}

    for i = 1, #array do
       list[i] = lng[array[i]]
       -- print( "lngArrayloop"..lng[array[i]])
    end

    return list
   end

  function touched(event)  -- this is used for the words to move them up and down, i had to remove physics and put it back in to get this to work 
    local cells = {} 
    passThroughImportantFields2("toFront",event.target)
    if event.target.columnNumber == 1 then  -- these for loops temporarily darken the chosen list
      for i = 1, #_G.languageCells1 do
        _G.languageCells1[i].alpha = .3
      end
    else
      for i =1, #_G.languageCells2 do
        _G.languageCells2[i].alpha = .3
      end
    end
    event.target.alpha = 1
    if event.phase == "moved" or event.phase == "began" then
       -- physics.removeBody(c)
    physics.removeBody(event.target)
    local overAllScale = 1.1
    local params = {time = 25,xScale=overAllScale,yScale =overAllScale}
    passThroughImportantFields( transition.to, event.target, params)
    display.getCurrentStage():setFocus( event.target )
    event.target.y = event.y
    else
    listCheck(event.target) -- this checks to see how low the list is to add more words
    event.target.alpha = 1
    if (event.y < 1/2*toprect.height  ) then  --this code prevents you from dragging the cells too far
      event.target.y= toprect.height -150
    end

    if (event.y > 300  ) then
      event.target.y =  200

    end

    display.getCurrentStage():setFocus( nil  )
    overAllScale = 1
    params = {time = 25,xScale=overAllScale,yScale =overAllScale}
    passThroughImportantFields( transition.to,event.target, params)
    physics.addBody(event.target,"dynamic ")
    event.target.soundButton:toFront()
    event.target.isFixedRotation = true
    -- physics.addBody(c,"dynamic ")
    -- c.isFixedRotation = true
    params = {time = 25, alpha = 1}

    for i = 1, #_G.languageCells1 do -- put the color back after the user let's go of a wordCell
      ---ideally id use event.target.columnNumber to refer to a specific column
      passThroughImportantFields( transition.to,_G.languageCells1[i], params)
      passThroughImportantFields( transition.to,_G.languageCells2[i], params)

    end
    end
    return true
   end

  function playCongratulatorySound()
      if math.random() > .5 then audio.play(audio.loadSound("applause.mp3")) else
      audio.play(audio.loadSound("tada.mp3")) end
     end  -- sounds indicating you got the matches right

  local function wordMake(parent,x,y,width,height,lng,text,id,columnNumber) -- this makes individual word cells

                  local wordCell = display.newText(text,width,height,_G.defaultFont,_G.defaultFontSize)               
                  wordCell.width = width
                  wordCell:setFillColor(0,1,.5)
                  wordCell.x, wordCell.y = x,y
                  wordCell.id = id
                  wordCell.language = lng.symbol
                  wordCell.anchorX = 1
                  wordCell.columnNumber = columnNumber
                  wordCell.alpha = 0
                  transition.to(wordCell,{time = 1000, alpha =1})
                  physics.addBody(wordCell,"dynamic ")
                  wordCell.isFixedRotation = true
                  wordCell:addEventListener("touch",touched)
                  wordCell:toFront()

                  local bg = display.newRoundedRect(x,y,width,height,2)
                  bg.strokeWidth = 2
                  bg:setStrokeColor( 0,0,0 )
                  bg.x = bg.x - width/2
                  wordCell.background = bg
                  bg:setFillColor(.5)

                  local c = display.newCircle(x,y,height/2)
                  wordCell.soundButton = c
                  c.language = lng.symbol
                  c.text = text
                  c.id = id
                  c.anchorX = 0
                  c:addEventListener("touch",soundMake)
                  parent:insert(c)
                  parent:insert(bg)
                  parent:insert(wordCell)
                  wordCell.importantFields = {c,bg}

                  return wordCell
                 end

  function _G.cellsCreate(parent,yInit,listLength,lng1,lng2) -- this is for making the two columns of words
    --local _G.languageCells1, _G.languageCells2 = {},{}  -- cells for the columns of words
    local randArray = randomSetOfNumbersGenerator(listLength,lexiconSize)
    wordlist1 = wordListGenerator(randArray,lng1)
    local wordlist2 = wordListGenerator(randArray,lng2)
    local cellStartX, cellStartY = (display.contentWidth-1*cellWidth+cellHeight)/2, yInit

    for i = 1, listLength do
      local randomDist = 150
    	local c1 = wordMake(parent,cellStartX,cellStartY+randomDist*math.random(),cellWidth,cellHeight,lng1,wordlist1[i],i,1)
    	local c2 = wordMake(parent,cellStartX+1.5*cellWidth,cellStartY+randomDist*math.random(),cellWidth,cellHeight,lng2,wordlist2[i],i,2)
      table.insert(_G.languageCells1, c1)
      table.insert(_G.languageCells2, c2)
   
    end  
   end

  function _G.removeAllCells()
    -- if #_G.languageCells1[1].importantFields > 0 then
    --   print("#_G.languageCells1[1].importantFields = "..#_G.languageCells1[1].importantFields )
     for i = 1, #_G.languageCells1 do
      cellExit(_G.languageCells1[i])
      cellExit(_G.languageCells2[i])
     end

     _G.languageCells1, _G.languageCells2 = {},{}
     -- for i = 1, #_G.languageCells1 do
     --  for j = 1, #_G.languageCells1[i].importantFields do
     --    _G.languageCells1[i].importantFields[j]:removeSelf()
     --    _G.languageCells2[i].importantFields[j]:removeSelf()
     --  end
     --    _G.languageCells1[i]:removeSelf()
     --    _G.languageCells2[i]:removeSelf()
     --  end
    -- end
   end  -- removes all cells, used particularly when new languages are being loaded

  function soundCellsMaintainYCoordinate() -- uses runFrame() during runtime to make sure all the components of the cells stay togeher
    for i = 1, #_G.languageCells1 do
            for j = 1, #_G.languageCells1[i].importantFields do
              _G.languageCells1[i].importantFields[j].y = _G.languageCells1[i].y
              _G.languageCells2[i].importantFields[j].y = _G.languageCells2[i].y
            end
    end

    -- for i = 1, #_G.languageCells2 do
    --   _G.languageCells2[i].soundButton.y = _G.languageCells2[i].y
    --   _G.languageCells2[i].background.y  = _G.languageCells2[i].y

    -- end
   end

  function passThroughImportantFields(f,obj,params) -- the next three functions are functions of functions particularly for word Objects
    local dist
       for i=1, #obj.importantFields do
        f(obj.importantFields[i],params)
         dist = obj.importantFields[i].x - obj.x 
         if params["xScale"] and obj.importantFields[i] == obj.soundButton then
          print ("params[\"xscale\"] exists and it equals "..params["xScale"])
          obj.importantFields[i].x = dist*params["xScale"] + obj.x

          -- obj.importantFields[i].x = obj.anchorX + 

         else
          print("params[xScale] does not exist") end
       end
        f(obj,params)
   end

  function passThroughAllFields(f,obj)
    for i =1, #obj do
      if obj[i] then 
        print("obj"..i.." exists and it is ") 
        f(obj[i]) 
        else 
          print( "obj"..i.." does not exist" )end
    end
   end

  function passThroughImportantFields2(f,obj,...) -- slightly different format for functions of the form obj:function()
   for i=1, #obj.importantFields do -- also, remember f has to put as "f", as Dr. Parker Explained
    local objekt = obj.importantFields[i] 
              objekt[f](objekt,params) 
   end
              obj[f](obj,params)
   end 

  function runFrame()
      if #_G.languageCells2 < 3   then -- this is where extra words are added based on _G.listLength, keeps game flowing
           -- print("cells should have been created")
           -- if sceneGroup then print ("sceneGroup exists")
           --  else print("sceneGroup does not exist") end
           --  print("the size of scenegroup is "..#sceneGroup)
           --  passThroughAllFields(print,sceneGroup)
           _G.cellsCreate(sceneGroup,200,_G.listLength,unpack(_G.pickedLanguages)) end
           soundCellsMaintainYCoordinate()
    
      end

  function langTextMaker(x,y,text)  -- to make the text for which languages are being tested on 
    local langText = display.newText(text,0,0,_G.defaultFont,44)
    langText.color = {0,0,1}
    langText:setFillColor(unpack(langText.color))
    langText:addEventListener("touch",onlanguagePickButtonRelease)
    langText.x = x --display.contentWidth*0.5 - 80
    langText.y = y --display.contentHeight - 210
    return langText
   end

  init()

  Runtime:addEventListener("enterFrame", runFrame)  -- this event listener, however computationally expesive it is use it, 
     --is to make sure that the langauge cells stay aligned
 end
-- end of scene:create( event )

function scene:show( event )
  sceneGroup = self.view	

  local phase = event.phase

  if phase == "will" then
  		-- Called when the scene is still off screen and is about to move on screen
  elseif phase == "did" then
 
      -- Runtime:addEventListener( "tap", self )  
  		-- Called when the scene is now on screen
  		--
  		-- INSERT code here to make the scene come alive
  		-- e.g. start timers, begin animation, play audio, etc.
  		physics.start()

      Runtime:addEventListener("enterFrame",runFrame)



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

		-- physics.pause() -- this used to be physics.stop()
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
   sceneGroup = self.view
   end

--------------------------------------------------------------------------------
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene

