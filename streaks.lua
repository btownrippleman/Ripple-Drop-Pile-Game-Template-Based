-----------------------------------------------------------------------------------------
--
-- streaks.lua
--
-----------------------------------------------------------------------------------------


local function printHello()
  print("hello streaks")
end

function fadingCircle(x,y,rad,strokeWidth,time, color)
 local colors = {1,0,1}
  local colors = color --{color[1]-a*math.random(),color[3]-b*math.random(),color[3]-c*math.random()}
        local xval = x+strokeWidth*( -.5*math.random() + .5*math.random())
        local yval = y+strokeWidth*( -.5*math.random() + .5*math.random())
        local radius = rad * math.random()*math.random()*math.random()
        local circle = display.newCircle(xval,yval,radius)
        circle.radius = radius
        -- circle.alpha =  radius/rad
        colors[2] = (1-radius/rad)*(1-radius/rad)*(1-radius/rad)
        circle.time = colors[2]*6*time*math.random()+200
        circle:setFillColor(unpack(colors))
        local options =
        {
         x = circle.x + strokeWidth*( -.5*math.random() + .5*math.random()),
         y = circle.y + strokeWidth*( -.5*math.random() + .5*math.random()),
         time = circle.time,
         alpha = 0,
         onComplete = removeOrNot,
         easing= outInExpo

         }
        transition.to(circle,options)

end

function removeOrNot(obj)
  local n = math.floor(math.random(3))
  if math.random() < (1/n) then obj:removeSelf() else
      rnd = math.floor(math.random(n))
      for i = 1, rnd do 
        fadingCircle(obj.x,obj.y,obj.radius *.9, obj.strokeWidth*1.3,.4*obj.time/(n*n), {1,0,1}) 
        end 
      end
end

function touched(event,radius,time,strokeWidth)

  local color = {1,0,1}
  if event.phase == "moved" then
    for i = 1,math.ceil(math.random(3)) do
      fadingCircle(event.x,event.y,radius,strokeWidth,time, color)
      -- if math.random() < .002 then randomFunction(event) end
    end
end
end

local M = {}
M.fadingCircle = fadingCircle
M.removeOrNot = removeOrNot
M.touched = touched
M.printHello = printHello
M.radius = radius

return M