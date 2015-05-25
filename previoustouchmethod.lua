-- function touched(event)



--   local scaleFactor =1.1
--   local box = event.target.box

--   local cells = {}

--   -- print ("box.x"..box.x)

--   if event.phase == "moved" or event.phase == "began"
--   then
--     event.target.alpha = .5

--     box.stroke = {0.8, 0.8, 1, 1}

--     physics.removeBody(event.target)
--     physics.removeBody(box )

--     event.target.xScale = scaleFactor; event.target.yScale = scaleFactor
--     box.xScale = scaleFactor; box.yScale = scaleFactor;
--     event.target:toFront()
--     box:toFront()

--     -- event.target.box.xScale =1.2
--     display.getCurrentStage():setFocus( event.target )
--     event.target.y = event.y
--     box.y = event.y
--     -- event.target.x = event.x
--     -- box.x = event.x
--     -- event.target.x = event.x

--   else

--     listCheck(event.target)

--       event.target.alpha = 1

--     if (event.y < 1/2*toprect.height  ) then  --this code prevents you from dragging the cells too far
--       event.target.y = toprect.height -150
--       event.target.box.y =   event.target.y
--     end

--     if (event.y > 300  ) then
--       event.target.y = 200
--       event.target.box.y =   event.target.y
--     end

--     --here you need to put in a function that checks

--     display.getCurrentStage():setFocus( nil  )
--     --you'll need to make a functin that transitions to the neerest neighbor or not stop physics
--     event.target.xScale = 1; event.target.yScale =1
--     box.xScale = 1; box.yScale =1;
--     box.stroke =   { 1, 0.4, 0, 1 }
--     physics.addBody(event.target,"dynamic ")

--     physics.addBody(event.target.box,"dynamic")
--     event.target.isFixedRotation = true
--     event.target.box.isFixedRotation = true

--     -- local weldJoint1 = physics.newJoint( "piston",  event.target,event.target.box,event.target.x,event.target.y,1,0,1,0)
--     -- local weldJoint2 = physics.newJoint( "distance",event.target,event.target.box,event.target.anchorX,event.target.anchorY,event.target.box.anchorX,event.target.box.anchorY)



--     -- event.target.box:addEventListener("touch",soundMake)

--   end -- this is the deprecated method for touched

-- end

-- function cellOrder()
-- end
