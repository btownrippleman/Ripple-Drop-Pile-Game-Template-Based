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
  -- physics.setDrawMode("hybrid")
  --Runtime:hideErrorAlerts( )
  require("languages")
  require("main")
  listLength = 5 -- the number of words it adds each time
  pickedLanguages = {English, Spanish} 
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
    elseif event.phase == "ended" and event.target.color then
        event.target:setFillColor(unpack(color)) 
        composer.gotoScene( "languagepick", "fade", 100 )

    else
      composer.gotoScene("languagepick", "fade", 100 )
  	return true	-- indicates successful tap
  end
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
--    _|_|_  |_|_|_|  |_|__   \___/   _|_|_   _\__|  \__,_|  |_||_|   _\__|   TS__[O] 
--  _|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""|_|"""""| {======| 
--  "`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'"`-0-0-'./o--000' 
---

function scene:create( event )
  function init() -- where all the initial physical UI is created
    currentRandomSet = {}
     sceneGroup = self.view
      cellWidth = 100 -- width of word cells
      cellHeight = 30 -- height of word cells
    languageCells1 = {} -- array for the first column of word cells
    languageCells2 = {} -- array for the second
      g2 = pickedLanguages[2] -- using these local variables for languages
      g1 = pickedLanguages[1]
     lexiconSize = 200 -- this i'll change in the future but it just assumes you know 200 words in each language
   
   --newly entered variables

    numberOfAverageSecondsBetweenGuesses = 0
    numberOfCorrectAnswers = 0
    numberOfIncorrectAnswers = 0
    --you'll also want an array associated with how many times a certain word has been answered correctly

  ----------------------------------

    physics.setGravity(0,-2) -- this pushes the wordCell upward
     toprect = display.newRect(0,0,640,200) -- this stops the wordCells from moving upward with upward gravity
    physics.addBody(toprect,"static")
    toprect:setFillColor(0,0,0)
    background = display.newImageRect( "stock.jpg", screenW, screenH )
    background.anchorX = 0
    background.anchorY = 1
    background.x, background.y = 0, display.contentHeight

    langText = langTextMaker(display.contentWidth*0.5 - 80, display.contentHeight - 210, pickedLanguages[1].symbol)
    langText2 = langTextMaker(display.contentWidth*0.5 + 55, display.contentHeight - 210, pickedLanguages[2].symbol)

      languagePickButton = widget.newButton{

    font = defaultFont, fontsize = defaultFontSize,
    x = display.contentWidth*0.5,
    y = display.contentHeight - (125 +40)/2,
    label = "Pick Languages",
    labelColor = { default={155,0,155}, over={128} },
    default="button.png",
    over="button-over.png",
    width=154, height=40,
    onRelease = onlanguagePickButtonRelease -- event listener function
    }
     
    -- pretty straight forward, takes u back to menu.lua, i.e. this is the button for that
    menuBtn = widget.newButton{
      x = display.contentWidth*0.5,
      y = display.contentHeight - 125,
      font = defaultFont, fontsize = defaultFontSize,
      label="Return to Main Menu",
      labelColor = { default={255,0,255}, over={128} },
      default="button.png",
      over="button-over.png",
      width=154, height=40,
      onRelease = onMenuBtnRelease  -- event listener function where onMenuBtnRelease sends us back to menu.lua with composer
    }

    -- this takes you to the options screen, i.e. to change the number of words to be added each time words get added
    optionsBtn = widget.newButton{
      font = defaultFont, fontsize = defaultFontSize,
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
   
  function getCellsOrder()
    local arrayValuesofY,sortedArrayValuesofY = {},{}
    for i =1, #languageCells1 do
      arrayValuesofY[i] = languageCells1[i].y 
      sortedArrayValuesofY = arrayValuesofY 
       table.sort(sortedArrayValuesofY)
      print("languageCells["..i.."].id = "..languageCells1[i].id)
      print("languageCells["..i.."] is in position "..table.indexOf(sortedArrayValuesofY,arrayValuesofY[i]))
    end
    -- for i =1, #arrayValuesofY do
    --   --   table.sort(sortedArrayValuesofY)
    --   -- print("order of Values post sortem = "..sortedArrayValuesofY[i].indexOf(arrayValuesofY[i]))
    --   print("arrayValuesofY["..i.." = "..arrayValuesofY[i])
    -- end
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

          -- one thing i'm trying to change is to use the id and columnNumber properly in the listCheck function so that I don't have to
    -- go back through my lists to find values that are already given, i.e., in the id and columnNumber

    -- print("#languageCells1 = "..#languageCells1)
    -- print( "obj.id, obj.columnNumber equal ".. obj.id.. " and " .. obj.columnNumber .. " respectively")
    getCellsOrder(languageCells1)
    -- getCellsOrder(languageCells2)
    
    for i =1,#languageCells1 do
      -- print("languageCells1["..i.."].id = "..languageCells1[1].id)
      -- print("languageCells1["..i.."].columnNumber = "..languageCells1[1].columnNumber)
      -- print("languageCells2["..i.."].id = "..languageCells2[1].id)
      -- print("languageCells2["..i.."].columnNumber = "..languageCells2[1].columnNumber)
    end

    -- local index, list = obj.id, obj.columnNumber

    if table.indexOf(languageCells1, obj) then index = table.indexOf(languageCells1, obj); list =1 
    else index = table.indexOf(languageCells2,obj); list =2
    end

    if list == 1 and math.abs(languageCells2[index].y - obj.y) < cellHeight/2 then 
      -- print ("cell picked from list 1")
      cellExit(obj); cellExit(languageCells2[index]); 
      -- cellExit(languageSoundCells2[index]); 
      table.remove(languageCells2,index);
      table.remove(languageCells1,index); 
      playCongratulatorySound()       -- this is a sound made to indicate you got the word right

    elseif list ==2 and math.abs(languageCells1[index].y - obj.y) < cellHeight/2 then
      -- print ("cell picked from list 2")
      cellExit(obj); cellExit(languageCells1[index]); 
      -- cellExit(languageSoundCells1[index]);
      table.remove(languageCells2,index);
      table.remove(languageCells1,index);
      playCongratulatorySound()  -- this is a sound made to indicate you got the word right

    else 
      audio.stop()
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
       -- print( "Found file: " .. file )
    end

    if ( event.isError ) then
       -- print ( "Network error - download failed" )
    else
      -- print("no network error")

      local speech = audio.loadSound(files[3],system.TemporaryDirectory)

      local playSpeech = function()
              audio.stop()
              audio.play( speech )
      end

      playSpeech ()
    end

    os.remove( system.pathForFile( "corona.mp3", system.TemporaryDirectory ))
    -- print ( "RESPONSE: " .. event.response )
   end -- used to download the words using googles unofficial API tts

  function soundMake(event)
    local obj = event.target
    local lng = obj.language
    local lfs = require "lfs"
    local doc_path = system.pathForFile( "", system.TemporaryDirectory )

      for file in lfs.dir(doc_path) do
         --file is the current file or directory name
         os.remove( system.pathForFile( file, system.TemporaryDirectory ))
         -- print( "Found file: " .. file )
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

  function redundancyCheck(array,initialArray) --this is for randomSetOfNumbersGenerator() to see if any of the values are the same
    local redundance = false
    for k = 1, #array do
      for i = 1, k do
        if array[i] == array[k] then redundance = true end
      end
      if initialArray then
        for i=1, #initialArray do 
          if initialArray[i] == array[k] then redundance = true end
         end
       end

    end
   end

  function randomSetOfNumbersGenerator(length,listSize,existingArray) -- this generates a random set of unique numbers from which we used to pick the same words from
    local randomSetOfNumbers = {}
      for i = 1, length do
        local a =  math.ceil(math.random(listSize))
        table.insert(randomSetOfNumbers, a)
      end

      while redundancyCheck(randomSetOfNumbers, existingArray) do randomSetOfNumbers = randomSetOfNumbersGenerator(length,listSize,existingArray) end

      for i = 1, #randomSetOfNumbers do
        -- print("randomSetOfNumbers[i] = " .. randomSetOfNumbers[i])
       end
    return randomSetOfNumbers
   end

  function fullShuffleCheck(array) -- this is for fullShuffle() to make sure that none of the numbers equals its position in the array
    local boolean = true
    for i=1,#array do
      if array[i] == i then boolean = false
      end
    end
    return boolean
   end

  function fullShuffle(n)  -- i.e. this changes {1,2,3} to {2,3,1} or {3,1,2} but not {1,3,2} essentially making sure that no value ends up int the same place
    -- local shift = math.ceil(math.random(n))
    local array = {}
    for i =1,n do
      array[i] = i
     end
  

    while not fullShuffleCheck(array) do
      for i =1, #array do
        if array[i] == i then
        local m = array[i]
        local rand = math.ceil(math.random(n))
        array[i] = array[rand] 
        array[rand] = m
         end
       end 
     end
   

    for i = 1, n do
      -- print("shuffle[i] =" .. array[i])
     end

     return array
   end

  function wordListGenerator(array,lng)  -- we then use this below in the cellsCreate function taking the array above to get our words
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
      for i = 1, #languageCells1 do
        languageCells1[i].alpha = .3
      end
    else
      for i =1, #languageCells2 do
        languageCells2[i].alpha = .3
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
       transition.to(event.target,{time = 25, y = toprect.height -150 })
    end

    if (event.y > toprect.y+#languageCells1*cellHeight*1.6 ) then
       transition.to(event.target,{time = 25, y = toprect.y+#languageCells1*cellHeight*1.6 })
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

    for i = 1, #languageCells1 do -- put the color back after the user let's go of a wordCell
      ---ideally id use event.target.columnNumber to refer to a specific column
      passThroughImportantFields( transition.to,languageCells1[i], params)
      passThroughImportantFields( transition.to,languageCells2[i], params)

    end
    end
    return true
   end

  function playCongratulatorySound()
      if math.random() > .5 then audio.play(audio.loadSound("applause.mp3")) else
      audio.play(audio.loadSound("tada.mp3")) end
     end  -- sounds indicating you got the matches right

  function wordMake(parent,x,y,width,height,lng,text,id,columnNumber) -- this makes individual word cells

                  local options = 
                    {
                        --parent = textGroup,
                        text = text,     
                        x = x,
                        y = y,
                        align = "center",
                        width = width,     --required for multi-line and alignment
                        height = height,
                        font = defaultFontSize,   
                        fontSize = defaultFont,
                     }
                  -- local wordCell = display.newText( parent, text, x, y, width, height, align = "right", defaultFont, defaultFontSize )
                  wordCell = display.newText(options)
                  wordCell:setFillColor(0,1,.5)
                  wordCell.id = id
                  wordCell.order = 0
                  wordCell.language = lng.symbol
                  wordCell.anchorX = 1
                  wordCell.columnNumber = columnNumber
                  wordCell.alpha = 0
                  transition.to(wordCell,{time = 1000, alpha =1})
                  physics.addBody(wordCell,"dynamic ")
                  wordCell.isFixedRotation = true
                  wordCell:addEventListener("touch",touched)
                  wordCell:setLinearVelocity(0,-110)
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
                  c.strokeWidth = 2
                  c:setStrokeColor(0)
                  c.anchorX = 0
                  c:addEventListener("touch",soundMake)
                  parent:insert(c)
                  parent:insert(bg)
                  parent:insert(wordCell)
                  wordCell.importantFields = {c,bg}

                  return wordCell
                 end

  function cellsCreate(parent,yInit,listLength,lng1,lng2) -- this is for making the two columns of words
    -- local languageCells1, languageCells2 = {},{}  -- cells for the columns of words
    -- one thing i'm trying to change is to use the id and columnNumber properly in the listCheck function so that I don't have to
    -- go back through my lists to find values that are already given, i.e., in the id and columnNumber

    local permutedIndices = fullShuffle(listLength) 
    if currentSet then 
      -- print(" the previous set consists of "); passThroughAllFields(print, currentSet) 
    end
    currentSet = randomSetOfNumbersGenerator(listLength,lexiconSize,currentSet)
    -- print("the current set consists of")
    passThroughAllFields(print,currentSet)
    local wordlist1 = wordListGenerator(currentSet,lng1)
    local wordlist2 = wordListGenerator(currentSet,lng2)
    local cellStartX, cellStartY = (display.contentWidth-1*cellWidth+cellHeight)/2, yInit

    if languageCells1 and #languageCells1 > 0 then 
      for i=1,#languageCells1 do
         languageCells1[i].id = i 
      end
     end


    for i = 1, listLength do
    	local c1 = wordMake(parent,cellStartX,cellStartY+(i)*cellHeight*1.1,cellWidth,cellHeight,lng1,wordlist1[i],#languageCells1 + i,1)
    	local c2 = wordMake(parent,cellStartX+1.5*cellWidth,cellStartY+(permutedIndices[i])*cellHeight*1.1,cellWidth,cellHeight,lng2,wordlist2[i],#languageCells1 + i,2)
      table.insert(languageCells1, c1)
      table.insert(languageCells2, c2)
   
     end  
   end

  function removeAllCells()
    -- if #languageCells1[1].importantFields > 0 then
    --   print("#languageCells1[1].importantFields = "..#languageCells1[1].importantFields )
     for i = 1, #languageCells1 do
      cellExit(languageCells1[i])
      cellExit(languageCells2[i])
     end

     languageCells1, languageCells2 = {},{}
     -- for i = 1, #languageCells1 do
     --  for j = 1, #languageCells1[i].importantFields do
     --    languageCells1[i].importantFields[j]:removeSelf()
     --    languageCells2[i].importantFields[j]:removeSelf()
     --  end
     --    languageCells1[i]:removeSelf()
     --    languageCells2[i]:removeSelf()
     --  end
    -- end
   end  -- removes all cells, used particularly when new languages are being loaded

  function soundCellsMaintainYCoordinate() -- uses runFrame() during runtime to make sure all the components of the cells stay togeher
    for i = 1, #languageCells1 do
            for j = 1, #languageCells1[i].importantFields do
              languageCells1[i].importantFields[j].y = languageCells1[i].y
              languageCells2[i].importantFields[j].y = languageCells2[i].y
            end
    end

    -- for i = 1, #languageCells2 do
    --   languageCells2[i].soundButton.y = languageCells2[i].y
    --   languageCells2[i].background.y  = languageCells2[i].y
 -- end
   end

  function passThroughImportantFields(f,obj,params) -- the next three functions are functions of functions particularly for word Objects
    local dist
       for i=1, #obj.importantFields do
        f(obj.importantFields[i],params)
        
         dist = obj.importantFields[i].x - obj.x 
         if params["xScale"] and obj.importantFields[i] == obj.soundButton then
          -- print ("params[\"xscale\"] exists and it equals "..params["xScale"])
          obj.importantFields[i].x = dist*params["xScale"] + obj.x

          -- obj.importantFields[i].x = obj.anchorX + 

         else
          -- print("params[xScale] does not exist") 
         end
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
      if #languageCells2 < 3   then -- this is where extra words are added based on listLength, keeps game flowing
           -- print("cells should have been created")
           -- if sceneGroup then print ("sceneGroup exists")
           --  else print("sceneGroup does not exist") end
           --  print("the size of scenegroup is "..#sceneGroup)
           --  passThroughAllFields(print,sceneGroup)
           cellsCreate(sceneGroup,200,listLength,unpack(pickedLanguages)) end
           soundCellsMaintainYCoordinate()
    
      end

  function langTextMaker(x,y,text)  -- to make the text for which languages are being tested on 
    local langText = display.newText(text,0,0,defaultFont,44)
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

     fullShuffle(3)

 end
-- end of scene:create( event )
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

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

