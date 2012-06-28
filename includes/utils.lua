--------------------------------------------------------------
-- Check if mouse is hovered over the definded bounding box --
--------------------------------------------------------------

function mouseHover(box1x, box1y, box1w, box1h)
    if box1x > love.mouse.getX() + 1 - 1 or -- Is box1 on the right side of box2?
        box1y > love.mouse.getY() + 1 - 1 or -- Is box1 under box2?
        love.mouse.getX() > box1x + box1w - 1 or -- Is box2 on the right side of box1?
        love.mouse.getY() > box1y + box1h - 1    -- Is b2 under b1?
    then
        return false
    else
        return true
    end
end

------------------------------------------------------------
-- Converts HSL to RGB. (input and output range: 0 - 255) -- -- not by me.
------------------------------------------------------------

function HSL(h, s, l)
    if s <= 0 then return l,l,l end
    h, s, l = h/256*6, s/255, l/255
    local c = (1-math.abs(2*l-1))*s
    local x = (1-math.abs(h%2-1))*c
    local m,r,g,b = (l-.5*c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return (r+m)*255,(g+m)*255,(b+m)*255
end
