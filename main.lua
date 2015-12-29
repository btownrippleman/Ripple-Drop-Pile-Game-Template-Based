-----------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------
--  main.lua
-- ok so the main point of this app, as seen demoed in class is to test your knowledge of words in other languages. When you drag a word and drop it next to a word in the other column it will make a sound, either a good sound or an error sound to tell you if you got it right. If you get it wrong the word then stays in the column. If you get it right the word then changes to red and the disappears from the screen. You can change the languages by pressing on "Pick Languages" as well as chnage the number of words to be tested on by pressing on "Number of Words Added". 
-- include the Corona "composer" module

local loadsave = require( "loadsave" )  -- Require the 'loadsave' module
local json = require( "json" )  -- Include the Corona JSON library

gameSettings = {
    {numberOfWords = 200},
    {musicOn = true},
    {soundOn = true},
}
loadsave.saveTable( gameSettings, "settings.json" )
local serializedString = json.encode( gameSettings )
print( serializedString )


local gameNetwork = require( "gameNetwork" )
 
local function initCallback( event )
    --this is annoying if you're using it in production
    -- if not event.isError then
    --     native.showAlert( "Success!", "", { "OK" } )
    -- else
    --     native.showAlert( "Failed!", event.errorMessage, { "OK" } )
    --     print( "Error Code:", event.errorCode )
    -- end
end

local function onSystemEvent( event )
    if ( event.type == "applicationStart" ) then
        gameNetwork.init( "google", initCallback )
        return true
    end
end
Runtime:addEventListener( "system", onSystemEvent )

-- gameNetwork.init( "google",  initCallback] )
gameNetwork.show( "invitations", { listener=invitationListener } )

gameNetwork.request( "login",
    {
        userInitiated = true,
        listener = requestCallback
    }
)


local licensing = require( "licensing" )
licensing.init( "google" )

local composer = require( "composer" )
-- local scene = composer.newScene()


--i added this global fcn  so that the restart button would also have this functionality
function initializeValues()
    _G.initialLanguages = {_G.English, _G.Spanish} -- initial languages set to english and spanish
    composer.gotoScene( "menu" )
end

initializeValues() -- intializes the 2 languages as well as previousScene variable to make sure you go the right scenes in teh composer api

-- display.setStatusBar( display.HiddenStatusBar )
-- load menu screen

