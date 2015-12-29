-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

function genInit()
  currentTime = system.getTimer()
  -- print "genInit called"
  widget = require "widget"
  composer = require( "composer" )
  scene = composer.newScene()
  physics = require "physics"
  physics.start();
  physics.setGravity(0,-2)
  Runtime:hideErrorAlerts( )
  require("languages")
  streaks  = require("streaks")
  -- require("main") --  this code right here cost me 4+ hours trying to figure out why when I would press the "return to menu" btn
  -- right after i first started and came from the menu that it would let me immediately revert back
  require("menu")
  listLength = 5 -- the number of words it adds each time
  pickedLanguages = {English, Spanish} 
  -- forward declarations and other s
  screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
  scaleFactor = scaleFactorOfBoxes
  
  --in here I'll put the words actually guessed, i.e. the number where they fall in the array and I'll start out an array each with 
    --unsure of how many of the last guesses to watch for we arbitrarily chose 5 -- this is an array of ones and zeroes that tells us whether or not the user guessed right
  guessSize = 5
  lastNGuesses = {} 
  previousSet = {}
  for i = 1, guessSize do
    lastNGuesses[i] = 1
  end
  secondsToGuess = 15
  secondsEachGuess = {}
  avgSecondsBetweenGuesses = 0.5
  numberOfCorrectAnswers = 0
  numberOfIncorrectAnswers = 0
  lexiconSize = 20 -- this i'll change in the future but it just assumes you know 200 words in each language
 end

function lexiconSizeChange()
  if sumOf(lastNGuesses) > #lastNGuesses -1 then
    lexiconSize = lexiconSize * 1.1
  elseif sumOf(lastNGuesses) <= #lastNGuesses*.5 and lexiconSize > 15 then
    lexiconSize = lexiconSize / 1.1
  end
 end

function timeSinceLastGuess()
  if #secondsEachGuess > 0 then
    return system.getTimer()/1000 - secondsEachGuess[#secondsEachGuess]
  else
    return 0
  end
 end


function guessUpdate(boolean)
  table.remove(lastNGuesses,1)
  if boolean == 0 then
    lastNGuesses[#lastNGuesses + 1] = 0
  else
    lastNGuesses[#lastNGuesses + 1] = 1
  end
  if #secondsEachGuess > 0 then 
     secondsEachGuess[#secondsEachGuess+1] = system.getTimer()/1000
  else 
    secondsEachGuess[1] = system.getTimer()/1000
  end
  if #secondsEachGuess > #lastNGuesses then 
    -- print (secondsEachGuess[1]) 
    table.remove(secondsEachGuess,1) 
  end
  lexiconSizeChange()
  -- print("lexiconSize = "..lexiconSize)
 end

function cellRenewal()
    if #languageCells2 < 3 then
     cellsCreate(sceneGroup,lexiconSize,listLength,unpack(pickedLanguages)) 
   end
   end

function sumOf(arr)
  total = 0
    for i = 1, #arr do
      total = total + arr[i]
    end
  return total
  end

function streakGenerator(event)
  time = 250/(avgSecondsBetweenGuesses() * (#lastNGuesses - sumOf(lastNGuesses) +1 ))
  -- print("time = "..time)
  if time < 400  and sumOf(lastNGuesses)>guessSize -1  then
    time = 250/(avgSecondsBetweenGuesses() * (#lastNGuesses - sumOf(lastNGuesses) +1 ))
    -- print ("time = "..time)

    strokeWidth = 45
    radius = 25
    streaks.touched(event,radius,time,strokeWidth)
  end

 
 end

local function onlanguagePickButtonRelease(event)
    composer.gotoScene("languagepick", "fade", 100 )
    return true -- indicates successful tap
   end

local function onMenuBtnRelease(event)

  -- go to menu.lua scene
      -- print "onMenuBtnRelease function called"
      composer.gotoScene( "menu", "fade", 100 )
    return true -- indicates successful tap
 end
  -- 'onRelease' event listener for optionsBtn

local function printNumberAndWord(obj,array)
  -- print(obj.." "..array[obj])
 end

genInit()

function scene:create( event )
  function init() 
    sceneGroup = self.view
    cellWidth = 100 -- width of word cells
    cellHeight = 20 -- height of word cells
    languageCells1 = {} -- array for the first column of word cells
    languageCells2 = {} -- array for the second
    g2 = pickedLanguages[2] -- using these local variables for languages
    g1 = pickedLanguages[1]
    guesses = {}
    for i = 1, #g1 do
      guesses[#guesses+1] = {}
     end

   --newly entered variables
    --you'll also want an array associated with how many times a certain word has been answered correctly

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
    -- optionsBtn = widget.newButton{
    --   font = defaultFont, fontsize = defaultFontSize,
    --   label="Refresh",
    --   labelColor = { default={155,0,155}, over={128} },
    --   default="button.png",
    --   over="button-over.png",
    --   width=154, height=40,
    --   onRelease = onRefreshBtnRelease -- event listener function where onRefreshBtnRelease sends us to options.lua with composer
    -- }
    -- optionsBtn.x = menuBtn.x
    -- optionsBtn.y = menuBtn.y - 40

    sceneGroup:insert( toprect)
    sceneGroup:insert( background )
    sceneGroup:insert( menuBtn )
    -- sceneGroup:insert( optionsBtn )
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
       print ("****************sortedArrayValuesofY")
       passThroughAllFields(print,sortedArrayValuesofY)

      -- print("languageCells["..i.."].id = "..languageCells1[i].id)
      -- print("languageCells["..i.."] is in position "..table.indexOf(sortedArrayValuesofY,arrayValuesofY[i]))
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

  function silentCellExit(obj) -- this makes the objects kind of explode and leave
    local overAllScale = 1
    obj:removeEventListener("touch", touched); obj.soundButton:removeEventListener("touch",soundMake)
    local params = {time = 1500,alpha = 0,xScale=overAllScale,yScale =overAllScale, onComplete = remove}
    obj:setFillColor(1,0,0)
    passThroughImportantFields( transition.scaleTo, obj, params)
   end   
  
  function cellPairRemove(i)
    cellExit(languageCells1[i]); cellExit(languageCells2[i])
    table.remove(languageCells1, i);
    table.remove(languageCells2, i);
   end

  function slowCellPairRemove(i)
    silentCellExit(languageCells1[i]); cellExit(languageCells2[i])
    table.remove(languageCells1, i);
    table.remove(languageCells2, i);
   end

  function listCheck(obj)
    -- print("listCheck obj ="..obj.text)
    -- print("language of word = "..obj.language)
    -- print("language number = "..obj.langId)
    -- print("place in array = "..obj.numberInArray)

    -- this checks for matching words, and calls for functions to clear them out as well as to add more words
    -- kind of the bread and butter of the app

    if table.indexOf(languageCells1, obj) then 
      index = table.indexOf(languageCells1, obj); list =1 
     else 
      index = table.indexOf(languageCells2,obj); list =2 
     end

    if list == 1 and math.abs(languageCells2[index].y - obj.y) < cellHeight/2  or list ==2 and math.abs(languageCells1[index].y - obj.y) < cellHeight/2 then 
      cellPairRemove(index)
      attemptMade(1)

      answerPercentageChange(obj.numberInArray,1 )
      -- _LANGUAGES[obj.langId][obj.numberInArray].percentage = .80
      -- print(_LANGUAGES[obj.langId][obj.numberInArray].percentage)

      -- print("tostring(_LANGUAGES[obj.langId][obj.numberInArray])"..tostring(_LANGUAGES[obj.langId][obj.numberInArray]))

    else
      answerPercentageChange(obj.numberInArray,0) 
      attemptMade(0)
    end
  end

  function highPriorityWords()
    -- this return highPriority words without including words already on the screen
        local highPriorityWords = {}
        local existingSet = {}
        for i=1,#languageCells1 do
          existingSet[#existingSet] = languageCells1[i].numberInArray
        end
        print("existing set  = ")
        print(stringify(existingSet))
    
    -- for i=1,#guesses do
    --   if sumOf(guesses[i])/#guesses[i] < .50 and i < listSize then
    --     if table.contains(existingSet,i) then
    --        print("table.indexOf(existingSet,guesses["..i.."])"..table.indexOf(existingSet,guesses[i]))
    --     highPriorityWords[#highPriorityWords + 1] = i
    --     -- local index = a[i]
    --     table.remove(a,table.indexOf(a,i))
    --   end
    --   end
    --  end
     return highPriorityWords
   end

  -- the whole purpose of the following function is to record percentages of answers to guesses in order to isolate words that are hard to remember

  function answerPercentageChange(num,val)
    guesses[num][#guesses[num]+1] = val
    -- print ("guess size for "..num.." equals "..#guesses[num])
    -- print ("percentage = "..sumOf(guesses[num])/#guesses[num])
    passThroughAllFields(print,guesses[num])  
  end

  local function soundButtonRefreshListener( obj )
    --this is to make the white buttons go back to normal shape and size
      obj.alpha = 1
      -- print( "soundButtonRefreshListener called" )
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

  function attemptMade(boolean)
    guessUpdate(boolean)
    if boolean == 1 then playCongratulatorySound()
      else playNonCongratulatorySound() end
    end

  function soundMake(event)

    local obj = event.target
    local lng = obj.language
    local text = obj.text
    if event.phase == "began" then 
      obj.alpha = .5; obj.xScale = 1.1; obj.xScale = 1.1; display.getCurrentStage():setFocus( event.target )

    elseif event.phase == "ended" then 
      obj.alpha = 1; obj.xScale = 1; obj.xScale = 1;
      audio.play(audio.loadSound("soundFiles/"..lng.."/"..text..".mp3")) -- I just got rid of obj id
      -- print(lng)
      display.getCurrentStage():setFocus(nil)
      end
    end -- used for making the sounds of the words

  function randomSetOfNumbersGenerator(length,listSize,existingArray) -- this generates a random set of unique numbers from which we used to pick the same words from
    --this function gives us random numbers and at the same time prevents duplicate words from appearing on the screen, really annoying when I figured this out
    -- print ("listSize = "..listSize)
    local randomSetOfNumbers = {}
    local wordList = {}
    local a = {}    -- new array
    for i=1, listSize do
       a[i] = i 
     end



     -- this makes a list of words that have been poorly guessed i.e. below 25 percent, maybe should be higher, 
     -- and then sorts them according to how many times they have been guessed

    -- local highPriorityWords = {}
    
    -- for i=1,#guesses do
    --   if sumOf(guesses[i])/#guesses[i] < .50 and i < listSize then
    --     highPriorityWords[#highPriorityWords + 1] = i
    --     -- local index = a[i]
    --     table.remove(a,table.indexOf(a,i))
    --   end
    --  end
     -- highPriorityWords = bubbleSortByNthElement(highPriorityWords,2) -- this sorts the highprioritywords from least to greatest
    local existingWords = {}
     for i =1, #languageCells1 do
      existingWords[#existingWords +1 ] = languageCells1[i].numberInArray
    end
    -- print("existingWords = "..stringify(existingWords))
    -- print(" a = "..stringify(a))
    -- print("highPriorityWords = "..stringify(highPriorityWords))
     --this loop takes out the words that are still on the screen, so they don't get added twice
    if #existingWords > 0 then
       for i,v in ipairs(existingWords) do
        if v < listSize then 
          table.remove(a, table.indexOf(a,v))
          -- table.remove(highPriorityWords, table.indexOf(highPriorityWords,v))
        end
        end
    end

    -- print(" a after removing existing words = "..stringify(a))
    -- print("highPriorityWords after removing existing words = "..stringify(highPriorityWords))
    
    for i = 1, length do
      -- if #highPriorityWords > 0 and math.random() < .5 then local m = highPriorityWords[#highPriorityWords]; table.remove(highprioritywords)
      -- else 

        -- if #highPriorityWords > 0 and math.random() < .5 then 
        --   local  m = highPriorityWords[#highPriorityWords]; 
        --   table.remove(highPriorityWords,#highPriorityWords) 
        -- else
        local g = math.ceil(math.random(#a)) --  pick a random number in the set of a
        local m =  a[g]
        table.remove(a,g)
      -- end
       
      table.insert(randomSetOfNumbers, m)
 --  this prevents you from picking the same number again
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
    if event.target.isBodyActive ==true then  physics.removeBody(event.target) end
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
      audio.stop()
      if math.random() > .5 then audio.play(audio.loadSound("applause.mp3")) else
      audio.play(audio.loadSound("tada.mp3")) end
     end  -- sounds indicating you got the matches right
  function playNonCongratulatorySound()
      audio.stop()
      audio.play(audio.loadSound("wrong.mp3")) 
     end
  function wordMake(parent,x,y,width,height,lng,text,id,columnNumber,numberInArray) -- this makes individual word cells

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
                  wordCell.langId = lng.id
                  -- wordCell.order = 0
                  wordCell.language = lng.string
                  wordCell.anchorX = 1
                  wordCell.columnNumber = columnNumber
                  wordCell.numberInArray = numberInArray
                  wordCell.time = system.getTimer()/1000
                  wordCell.alpha = 0
                  transition.to(wordCell,{time = 1000, alpha =1})
                  physics.addBody(wordCell,"dynamic ",{bounce = 0.3})
                  wordCell.isFixedRotation = true
                  wordCell:addEventListener("touch",touched)
                  wordCell:setLinearVelocity(0,-110)
                  wordCell:toFront()
                  wordCell:addEventListener("touch", streakGenerator)

                  local bg = display.newRoundedRect(x,y,width,height,2)
                  bg.strokeWidth = 2
                  bg:setStrokeColor( 0,0,0 )
                  bg.x = bg.x - width/2
                  wordCell.background = bg
                  bg:setFillColor(.5)

                  local c = display.newCircle(x,y,height/2)
                  wordCell.soundButton = c
                  c.language = lng.string
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
 
  function findIndexOfWordInEnglish(arr)
    returnArr = {}
    for i,v in ipairs(arr) do
      returnArr[i] = table.indexOf(_G.English,_G.EnglishWordsByFrequency[i])
    end
    return returnArr
  end

  

  function cellsCreate(parent,yInit,listLength,lng1,lng2) -- this is for making the two columns of words
    -- print "cellsCreate called"
    local permutedIndices = fullShuffle(listLength) 
    local currentSet = randomSetOfNumbersGenerator(listLength,lexiconSize,previousSet)
    local wordlist1,wordlist2 = wordListGenerator(currentSet,lng1), wordListGenerator(currentSet,lng2)
    local cellStartX, cellStartY = (display.contentWidth-1*cellWidth+cellHeight)/2, yInit
    local associatedPercentages, highPriorityWords = {}, {}
    -- local highPriorityWords = highPriorityWords()

    -- for i=1,#guesses do
    --   if sumOf(guesses[i])/#guesses[i] < .50 and i < listSize then
    --     highPriorityWords[#highPriorityWords + 1] = i
    --     -- local index = a[i]
    --     table.remove(a,table.indexOf(a,i))
    --   end
    --  end
    -- if #languageCells1 > 1 then f
    --     print ("languageCells1 should ahve the followingwords")
    --     for i=1,#languageCells1 do
    --     print(English[languageCells1[i].numberInArray])

    --      existingSet[#existingSet+1] = languageCells1[i].numberInArray
    --       end
    --     for i=1,#currentSet do
    --       if table.indexOf(existingSet, currentSet[i]) then
    --         print(English[currentSet[i]].." should be a duplicate")
    --       else
    --         print("no duplicates found")
    --       end

    --       end

    -- end

    -- for i=1,#guesses do
    --   if sumOf(guesses[i])/#guesses[i] < .25 then
    --     associatedPercentages[#associatedPercentages + 1] = sumOf(guesses[i])/#guesses[i]
    --     highPriorityWords[#highPriorityWords + 1] = {#guesses[i],i}
    --   end
    --  end
      
    -- highPriorityWords = bubbleSortByNthElement(highPriorityWords,1)

    for i = 1, listLength do
      local c1 = wordMake(parent,cellStartX,cellStartY+(i)*cellHeight*1.1,cellWidth,cellHeight,lng1,wordlist1[i],#languageCells1 + i,1,currentSet[i])
      local c2 = wordMake(parent,cellStartX+1.5*cellWidth,cellStartY+(permutedIndices[i])*cellHeight*1.1,cellWidth,cellHeight,lng2,wordlist2[i],#languageCells1 + i,2,currentSet[i])
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
      if  obj[i]~=nil and type(obj[i]) == "table"  then 
        return passThroughAllFields(f,obj[i]) 
      else 
        f(obj[i])
      end
     end
   end

  function bubbleSortByNthElement(arr,n)
    returnArr = {}
    for i=1,#arr-1 do
      for j=1,#arr-1 do
        k = arr[j]
        if arr[j+1][n] < arr[j][n] then arr[j] = arr[j+1]; arr[j+1] = k end
      end
    end
    for i =1, #arr do
      returnArr[#returnArr + 1] = arr[i][n]
    end
    return returnArr
   end

  function bubbleSort(arr)
    for i=1,#arr-1 do
      for j=1,#arr-1 do
        k = arr[j]
        if arr[j+1] < arr[j] then arr[j] = arr[j+1]; arr[j+1] = k end
      end
    end
    return arr
   end

  function stringify(obj)
    string = ' '
     for i =1, #obj do
        if  obj[i]~=nil and type(obj[i]) == "table"  then
          -- print(obj[i].string.." recursion") 
          string = string..'\n'..stringify(obj[i]) 
        elseif  obj[i]~=nil then
          string = string .. ' ' .. tostring(obj[i])
        end
    end
    return string
   end

  function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
   end

  function passThroughImportantFields2(f,obj,...) -- slightly different format for functions of the form obj:function()
   for i=1, #obj.importantFields do -- also, remember f has to put as "f", as Dr. Parker Explained
    local objekt = obj.importantFields[i] 
              objekt[f](objekt,params) 
   end
              obj[f](obj,params)
   end 

  function avgSecondsBetweenGuesses()
    total = 0 
    if secondsEachGuess == nil then
      return "nil"
    else
      for i =2, #secondsEachGuess do
        total  = secondsEachGuess[i] - secondsEachGuess[i-1]
       end
      for i =1, #secondsEachGuess do
        -- print("secondsEachGuess["..i.."] = "..secondsEachGuess[i])
       end      
    return total/#secondsEachGuess
    end
   end   
   
  function runFrame()
      cellRenewal()
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
  local sceneGroup = self.view  
  local phase = event.phase
  if phase == "will" then
      -- Called when the scene is still off screen and is about to move on screen
  elseif phase == "did" then
      -- Runtime:addEventListener( "tap", self )  
      -- Called when the scene is now on screen
      -- INSERT code here to make the scene come alive
      -- e.g. start timers, begin animation, play audio, etc.
      physics.start()
      Runtime:addEventListener("enterFrame",runFrame)
    end
 end

function scene:hide( event )
  -- print "function scene:hide called"
  local sceneGroup = self.view
  local phase = event.phase
  if event.phase == "will" then
    -- Called when the scene is on screen and is about to move off screen
    -- INSERT code here to pause the scene
    -- e.g. stop timers, stop animation, unload sounds, etc.)
    -- physics.pause() -- this used to be physics.stop()
    -- Runtime:removeEventListener( "tap", self )
    physics.pause()
  elseif phase == "did" then
    previousScene = "level1"
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

