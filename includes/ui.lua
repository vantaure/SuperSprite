------------
-- BUTTON --
------------

Button = Class{function(self, x, y, image, label, type, imagepressed)
    self.x = x
    self.y = y
    self.image = image
    if imagepressed then self.imagepressed = imagepressed end
    self.width = image:getWidth()
    self.height = image:getHeight()
    if label then self.label = label else self.label = "" end

    self.colour = {255,255,255,255}
    self.toggle = false
    self.type = type

    self.pressed = false
end}

function Button:mousepressed(button)
    if button == "l" and mouseHover(self.x, self.y, self.width, self.height) then
        self.pressed = true

        if self.type == "toggle" then
            self:Toggle()
        end
    end
end

function Button:mouseover()
    if mouseHover(self.x, self.y, self.width, self.height) then
        return true
    else
        return false
    end
end

function Button:Toggle()
    self.toggle = not self.toggle
end

function Button:update()
    if mouseHover(self.x, self.y, self.width, self.height) then
        self.colour = {200, 240, 150, 255}
    else
        self.colour = {255,255,255,255}
    end
end

function Button:isPressed()
    if self.pressed == true then
        self.pressed = false
        return true
    else
        return false
    end
end

function Button:draw()
    --love.graphics.setColor(255,255,255,255)

    if self.image == img_button_prev or self.image == img_button_next then
        if mouseHover(self.x, self.y, self.width, self.height) then
            love.graphics.setColor(255,255,255,100)
            love.graphics.draw(self.image, self.x, self.y)
        else
            love.graphics.setColor(255,255,255,80)
            love.graphics.draw(self.image, self.x, self.y)
        end
    elseif self.image == img_prev_arrow or self.image == img_next_arrow then
        love.graphics.draw(self.image, self.x, self.y)
    else
        if mouseHover(self.x, self.y, self.width, self.height) then
            if self.type == "toggle" and self.toggle == true then
                love.graphics.setColor(255,255,255,255)
                love.graphics.draw(self.imagepressed, self.x, self.y)
                love.graphics.printf(self.label, self.x, self.y+7, self.width, "center")
            else
                love.graphics.setColor(255,255,255,255)
                love.graphics.draw(self.image, self.x, self.y)
                love.graphics.printf(self.label, self.x, self.y+7, self.width, "center")
            end
        else
            if self.type == "toggle" then
                if self.toggle == false then
                    love.graphics.setColor(255,255,255,255)
                    love.graphics.draw(self.image, self.x, self.y)
                    love.graphics.setColor(95,95,95,255)
                else 
                    love.graphics.setColor(255,255,255,255)
                    love.graphics.draw(self.imagepressed, self.x, self.y)
                end
            else
                love.graphics.setColor(255,255,255,255)
                love.graphics.draw(self.image, self.x, self.y)
            end
            love.graphics.setColor(95,95,95,255)
            love.graphics.printf(self.label, self.x, self.y+7, self.width, "center")
        end
    end
end

------------------
-- CONTEXT MENU --
------------------

CMenu = Class{function(self, x, y, width, butts)
    self.x = x
    self.y = y
    self.width = width

    self.butpos = 0
    self.expired = false
    self.butts = butts

    for k, v in pairs(butts) do
        v.x = x
        v.y = y + self.butpos
        v.width = width
        self.butpos = self.butpos + v.height
    end
end}

function CMenu:menuPressed()
    local number = 1
    for k,v in pairs(self.butts) do
        if v:isPressed() then
            return number
        end
        number = number + 1
    end

    return 0
end

function CMenu:mouseOver()
    if mouseHover(self.x, self.y, self.width, self.butpos) then
        return true
    else
        return false
    end
end

function CMenu:update()
    for k,v in pairs(self.butts) do
        v:update()
    end
end

function CMenu:draw()
    for k, v in pairs(self.butts) do
        v:draw()
    end
    love.graphics.setLine( 2, "rough")
    love.graphics.rectangle("line", self.x, self.y, self.width+1, self.butpos+1)
end

-------------
-- WINDOWS --
-------------

Window = Class{function(self,x, y, width, height, label, name)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.label = label
    self.titleheight = 30
    self.name = name

    self.mousex = love.mouse.getX() - self.x
    self.mousey = love.mouse.getY() - self.y

end}

function Window:close()
    windowopen = nil
end

function Window:update()
    self.mousex = love.mouse.getX() - self.x
    self.mousey = love.mouse.getY() - self.y

    if mouseHover(self.x, self.y, self.width, self.titleheight) then
        if love.mouse.isDown("l") then
            self.x = love.mouse.getX() - self.width/2
            self.y = love.mouse.getY() - self.titleheight/2
        end
    end   
end

function Window:draw()
    love.graphics.setColor(0,0,0,200)
    love.graphics.rectangle("fill", 0, 0, window_width, window_height)
    love.graphics.setColor(230, 230, 230, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height + self.titleheight)

    love.graphics.setColor(0, 128, 255, 255)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.titleheight)
    love.graphics.setColor(255,255,255,255)
    love.graphics.print(self.label, self.x + 10, self.y + self.titleheight/2-5)
    --love.graphics.draw(button_close, self.x + self.width - 20, self.y + self.titleheight/2-8)
end