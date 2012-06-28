Picker = Class{function(self, x, y, filename)
    self.x = x
    self.y = y
    self.image = love.graphics.newImage(filename)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.mousex = love.mouse.getX() - self.x
    self.mousey = love.mouse.getY()

    self.pointerx = self.x
    self.pointery = self.y
    self.pointer2x = self.x
    self.pointer2y = self.y

    self.hue = 0
    self.sat = 0
    self.lum = 0
    self.hue2 = 0
    self.sat2 = 0
    self.lum2 = 0

    self.imgData =  love.image.newImageData(filename)

    self.picked = {primary = {r=40,g=40,b=40,a=255}, secondary = {r=255, g=255, b=255, a=255}}
end}


function Picker:update()
    self.mousex = love.mouse.getX() - self.x
    self.mousey = love.mouse.getY()- self.y

    self.lum = Lumosity:getLum()
    self.lum2 = Lumosity:getLum2()

    

    
    if not windowopen then
        if mouseHover(self.x, self.y, self.width, self.height) then
            if love.mouse.isDown("l") then
                self.hue = self.mousex
                self.sat = self.height - self.mousey
                self.pointerx = love.mouse.getX()
                self.pointery = love.mouse.getY()

                self.picked.primary.r, 
                self.picked.primary.b, 
                self.picked.primary.g = HSL(self.hue, self.sat, self.lum)
            elseif love.mouse.isDown("r") then
                self.hue2 = self.mousex
                self.sat2 = self.height - self.mousey
                self.pointer2x = love.mouse.getX()
                self.pointer2y = love.mouse.getY()

                self.picked.secondary.r, 
                self.picked.secondary.b, 
                self.picked.secondary.g = HSL(self.hue2, self.sat2, self.lum2)
            end
        end
    end
end

function Picker:getHueSat()
    return self.hue, self.sat
end

function Picker:getPrimary()
    return self.picked.primary
end

function Picker:getSecondary()
    return self.picked.secondary
end

function Picker:draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(self.pointery-self.x+20,self.pointery-self.x+20,self.pointery-self.x+20,255)
    love.graphics.circle("line", self.pointerx, self.pointery, 2)
    love.graphics.setColor(self.pointer2y-self.x+20,self.pointer2y-self.x+20,self.pointer2y-self.x+20,255)
    love.graphics.circle("line", self.pointer2x, self.pointer2y, 2)
end

-------------------
--LUMO SLIDER--
-------------------

Lumo = Class{function(self, x, y, filename)
    self.x = x
    self.y = y

    self.image = love.graphics.newImage(filename)
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.mousey = love.mouse.getY() - self.y
    self.lum = 120
    self.lum2 = 120

    self.pointer1y = self.y
    self.pointer2y = self.y

end}

function Lumo:update()
    self.mousey = self.height - (love.mouse.getY() - self.y)

    if not windowopen then
        if mouseHover(self.x, self.y+1, self.width, self.height) then
            if love.mouse.isDown("l") then
                self.lum = self.mousey
                self.pointer1y = self.height - self.mousey + self.y

                Colour.picked.primary.r, 
                Colour.picked.primary.b, 
                Colour.picked.primary.g = HSL(Colour.hue, Colour.sat, self.lum)

            elseif love.mouse.isDown("r") then
                self.lum2 = self.mousey
                self.pointer2y = self.height - self.mousey + self.y

                Colour.picked.secondary.r, 
                Colour.picked.secondary.b, 
                Colour.picked.secondary.g = HSL(Colour.hue2, Colour.sat2, self.lum2)
            end
        end
    end
end

function Lumo:getLum()
    return self.lum
end

function Lumo:getLum2()
    return self.lum2
end


function Lumo:draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.image, self.x, self.y)
    love.graphics.setColor(self.pointer1y-self.y,self.pointer1y-self.y,self.pointer1y-self.y,255)
    love.graphics.line(self.x, self.pointer1y, self.x+self.width, self.pointer1y)
    love.graphics.setColor(self.pointer2y-self.y,self.pointer2y-self.y,self.pointer2y-self.y,255)
    love.graphics.line(self.x, self.pointer2y, self.x+self.width, self.pointer2y)
end

------------------
--OPACITY SLIDER--
------------------

Opacity = Class{function(self, x, y)
    self.x = x
    self.y = y

    self.width = 255
    self.height = 20

    self.mousex = love.mouse.getX() - self.x
    self.opacity = 255
    self.opacity2 = 255

    self.pointerx = self.x
    self.pointer2x = self.x
end}

function Opacity:update()
    self.mousex = love.mouse.getX() - self.x
    if not windowopen then 
        if mouseHover(self.x, self.y, self.width, self.height) then
            if love.mouse.isDown("l") then
                self.pointerx = self.x + self.mousex
                self.opacity = self.mousex
                Colour.picked.primary.a = self.opacity
            end

            if love.mouse.isDown("r") then
                self.pointer2x = self.x + self.mousex
                self.opacity2 = self.mousex
                Colour.picked.secondary.a = self.opacity2
            end
        end
    end
end

function Opacity:draw()
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(img_opacityslider, self.x, self.y)
    if selectedColour.primary.r == 0 and selectedColour.primary.g == 0 and selectedColour.primary.b == 0 then
        love.graphics.setColor(0,0,0,255)
    else
        love.graphics.setColor(selectedColour.primary.r, selectedColour.primary.g, selectedColour.primary.b)
    end
    love.graphics.line(self.pointerx, self.y, self.pointerx, self.y + self.height)

    if selectedColour.secondary.r == 0 and selectedColour.secondary.g == 0 and selectedColour.secondary.b == 0 then
        love.graphics.setColor(0,0,0,255)
    else
        love.graphics.setColor(selectedColour.secondary.r, selectedColour.secondary.g, selectedColour.secondary.b)
    end
    love.graphics.line(self.pointer2x, self.y, self.pointer2x, self.y + self.height)
    love.graphics.setColor(0,0,0,255)
end