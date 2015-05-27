-----------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------
--  main.lua
-- ok so the main point of this app, as seen demoed in class is to test your knowledge of words in other languages. When you drag a word and drop it next to a word in the other column it will make a sound, either a good sound or an error sound to tell you if you got it right. If you get it wrong the word then stays in the column. If you get it right the word then changes to red and the disappears from the screen. You can change the languages by pressing on "Pick Languages" as well as chnage the number of words to be tested on by pressing on "Number of Words Added". 

-- above in the first scene it opens up to the menu.lua file very much based on the app we did in class with the widget Slider, which I have revised so that now the number of words that gets added is based on the slider in the options.lua file. I would have had the words make their individual sounds using HTTP get but I couldn't test if the api was going to work from google and I didn't want to use it and have it not work. My code is pretty straight forward, I've cleaned a lot of it up, and having gone through it I found the particular items below for which I should get credit.

-- (5) physics Bodies  -- included in the wordMake function in the scene:create function of level1.lua at line 283
-- (5) Transition animations --  used in the same file and function at line 286 as well as using a scaling effect in the cellExit function on line 99
-- (5) Changing text  -- you can see after you've changed the languages when you click on "Pick Languages"
-- (5) Touch events (touch or tap) -- the words move themselves
-- (5) Sounds 3 different -- when you drag and drop words
-- (10) Composer API
-- (5)  Hide/show UI
-- (5)  Slider -- the options.lua file
-- (5) Picker wheel -- languagepick.lua file
-- (5) HTTP get -- as demoed in class the code is from 135 to 198 in level1
-- (5) Show deployment on Android or iOS 
-- (10) Demo app and show some code in front of class (during the last week)

--  5+5+5+5+5+10+5+5+5+5+5+10 = 70

-- include the Corona "composer" module

local composer = require( "composer" )
local scene = composer.newScene()


--i added this global fcn  so that the restart button would also have this functionality
function initializeValues()
 
previousScene = nil
_G.initialLanguages = {_G.English, _G.Spanish} -- initial languages set to english and spanish

end

initializeValues() -- intializes the 2 languages as well as previousScene variable to make sure you go the right scenes in teh composer api

display.setStatusBar( display.HiddenStatusBar )
-- load menu screen
composer.gotoScene( "menu" )
