------------
-- TILE --
------------

Tile = Class{function(self, id, x, y, size, coord, frame)
    self.id = id
    self.x = x
    self.y = y
    self.size = size
    self.coord = {x = coord.x, y = coord.y}
    self.colour = {r=0,g=0,b=0,a=0}
    self.dead = false
    self.frame = frame
end}


function Tile:update()
    if not windowopen then
        if love.mouse.isDown("l") and mouseHover(self.x, self.y, self.size, self.size) then
            if love.keyboard.isDown("lctrl") then
                Colour.picked.primary.r = self.colour.r 
                Colour.picked.primary.b = self.colour.b
                Colour.picked.primary.g = self.colour.g
                Colour.picked.primary.a = self.colour.a
            elseif love.keyboard.isDown("lalt") then
                self.colour.r = 255
                self.colour.g = 255
                self.colour.b = 255
                self.colour.a = 0

                if v_sym == true then
                    local opposite = frames[currentFrame].size_x - self.coord.x
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite and v.coord.y == self.coord.y then
                            v.colour.r = 255
                            v.colour.g = 255
                            v.colour.b = 255
                            v.colour.a = 0
                        end
                    end
                end

                if h_sym == true then
                    local opposite = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.y+1 == opposite and v.coord.x == self.coord.x then
                            v.colour.r = 255
                            v.colour.g = 255
                            v.colour.b = 255
                            v.colour.a = 0
                        end
                    end
                end
                
                if h_sym == true and v_sym == true then
                    local opposite_x = frames[currentFrame].size_x - self.coord.x
                    local opposite_y = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite_x and v.coord.y+1 == opposite_y then
                            v.colour.r = 255
                            v.colour.g = 255
                            v.colour.b = 255
                            v.colour.a = 0
                        end
                    end
                end
            else
                self.colour.r = selectedColour.primary.r
                self.colour.g = selectedColour.primary.g
                self.colour.b = selectedColour.primary.b
                self.colour.a = selectedColour.primary.a

                if v_sym == true then
                    local opposite = frames[currentFrame].size_x - self.coord.x
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite and v.coord.y == self.coord.y then
                            v.colour.r = selectedColour.primary.r
                            v.colour.g = selectedColour.primary.g
                            v.colour.b = selectedColour.primary.b
                            v.colour.a = selectedColour.primary.a
                        end
                    end
                end

                if h_sym == true then
                    local opposite = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.y+1 == opposite and v.coord.x == self.coord.x then
                            v.colour.r = selectedColour.primary.r
                            v.colour.g = selectedColour.primary.g
                            v.colour.b = selectedColour.primary.b
                            v.colour.a = selectedColour.primary.a
                        end
                    end
                end

                if h_sym == true and v_sym == true then
                    local opposite_x = frames[currentFrame].size_x - self.coord.x
                    local opposite_y = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite_x and v.coord.y+1 == opposite_y then
                            v.colour.r = selectedColour.primary.r
                            v.colour.g = selectedColour.primary.g
                            v.colour.b = selectedColour.primary.b
                            v.colour.a = selectedColour.primary.a
                        end
                    end
                end
            end
        elseif love.mouse.isDown("r") and mouseHover(self.x, self.y, self.size, self.size) then
            if love.keyboard.isDown("lctrl") then
                Colour.picked.secondary.r = self.colour.r
                Colour.picked.secondary.b = self.colour.b
                Colour.picked.secondary.g = self.colour.g
                Colour.picked.secondary.a = self.colour.a
            else
                self.colour.r = selectedColour.secondary.r
                self.colour.g = selectedColour.secondary.g
                self.colour.b = selectedColour.secondary.b
                self.colour.a = selectedColour.secondary.a

                if v_sym == true then
                    local opposite = frames[currentFrame].size_x - self.coord.x
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite and v.coord.y == self.coord.y then
                            v.colour.r = selectedColour.secondary.r
                            v.colour.g = selectedColour.secondary.g
                            v.colour.b = selectedColour.secondary.b
                            v.colour.a = selectedColour.secondary.a
                        end
                    end
                end

                if h_sym == true then
                    local opposite = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.y+1 == opposite and v.coord.x == self.coord.x then
                            v.colour.r = selectedColour.secondary.r
                            v.colour.g = selectedColour.secondary.g
                            v.colour.b = selectedColour.secondary.b
                            v.colour.a = selectedColour.secondary.a
                        end
                    end
                end

                if h_sym == true and v_sym == true then
                    local opposite_x = frames[currentFrame].size_x - self.coord.x
                    local opposite_y = frames[currentFrame].size_y - self.coord.y
                    for k,v in pairs(frames[currentFrame].tiles) do
                        if v.coord.x+1 == opposite_x and v.coord.y+1 == opposite_y then
                            v.colour.r = selectedColour.secondary.r
                            v.colour.g = selectedColour.secondary.g
                            v.colour.b = selectedColour.secondary.b
                            v.colour.a = selectedColour.secondary.a
                        end
                    end
                end
            end
        end
    end

    if self.colour.a == nil then
        self.colour.a = 255
    end

    if self.dead == true then
        self = nil
    end
end

function Tile:draw()
    love.graphics.setColor(255,255,255,255)
    if onionskin == true and self.frame == currentFrame-1 then
        love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a/2)
    else
        love.graphics.setColor(self.colour.r, self.colour.g, self.colour.b, self.colour.a)
    end
    love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)

    if mouseHover(self.x, self.y, self.size, self.size) then
        if cursor_fill == false then
            love.graphics.setColor(255,0,0,255)
            love.graphics.setLineWidth(1)
            love.graphics.rectangle("line", self.x, self.y, self.size, self.size)
        else
            love.graphics.setColor(0,0,0,50)
            love.graphics.rectangle("fill", self.x, self.y, self.size, self.size)
        end
    end

    if settings.debug then 
        love.graphics.print(self.coord.x .. "," .. self.coord.y, self.x + 2, self.y + 2) 
        --love.graphics.print(self.id, self.x + 12, self.y + 12) 
    end
end

-------------------
------ GRID  ------
-------------------

Grid = Class{function(self, x, y, size_x, size_y, tilesize, frame)
    self.x = x
    self.y = y
    self.size_x = size_x
    self.size_y = size_y
    self.tilesize = tilesize
    self.width = self.size_x * tilesize
    self.height = self.size_y * tilesize
    self.frame = frame

    self.tiles = {}
    local int = 0
    for u=0, self.size_x - 1 do
        for v=0, self.size_y - 1 do
            local coord = {x = u, y = v}
            table.insert(self.tiles, Tile(int, self.x + u*self.tilesize, self.y + v*self.tilesize, self.tilesize, coord, self.frame))
            int = int + 1
        end
    end 
end}

function Grid:removeRow()
    for k, v in pairs(self.tiles) do
        if v.coord.x == self.size_x - 1 then
            lolin = v.coord.x .. "/" .. v.coord.y
            self.tiles[v.id+1] = nil
        end
    end
    self.size_x = size_x
    self.width = self.size_x * self.tilesize
    self.height = self.size_y * self.tilesize
end

function Grid:addRow()
    for v=0, self.size_y - 1 do
        local coord = {x = self.size_x, y = v}
        table.insert(self.tiles, Tile(#self.tiles, self.x + (self.size_x)*self.tilesize, self.y + v*self.tilesize, self.tilesize, coord, self.frame))
    end
    self.size_x = self.size_x + 1
    size_x = self.size_x
end

function Grid:removeColumn()
    for k, v in pairs(self.tiles) do
        if v.coord.y == self.size_y - 1 then
            self.tiles[v.id+1] = nil
        end
    end
    self.size_y = size_y
    self.width = self.size_x * self.tilesize
    self.height = self.size_y * self.tilesize
end

function Grid:addColumn()
    for u=0, self.size_x - 1 do
        local coord = {x = u, y = self.size_y}
        table.insert(self.tiles, Tile(#self.tiles, self.x + u*self.tilesize, self.y + self.size_y*self.tilesize, self.tilesize, coord, self.frame))
    end
    self.size_y = self.size_y + 1
    size_y = self.size_y
end

function Grid:update()
    self.width = self.size_x * self.tilesize
    self.height = self.size_y * self.tilesize

    for k,v in pairs(self.tiles) do
        v:update()
    end
end

function Grid:Copy(source)
    for selfk,selfv in pairs(self.tiles) do
        for sourcek,sourcev in pairs(source.tiles) do
            if selfv.x == sourcev.x and selfv.y == sourcev.y then
                selfv.colour.r = sourcev.colour.r
                selfv.colour.g = sourcev.colour.g
                selfv.colour.b = sourcev.colour.b
                selfv.colour.a = sourcev.colour.a
            end
        end
    end
end

function Grid:draw()
    for k,v in pairs(self.tiles) do
        if onionskin == false or onionskin == true and self.frame == 1 or onionskin == true and self.frame == currentFrame-1 then
        	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(img_transparent, v.x, v.y)
       end
       v:draw()
        if onionskin == false or onionskin == true and self.frame == 1 or onionskin == true and self.frame == currentFrame-1 then
            if settings.showgrid == true then
                love.graphics.setColor(0,0,0,100)
                love.graphics.setLineWidth(1)
                love.graphics.rectangle("line", v.x, v.y, v.size, v.size)
            end
        end
    end

    if v_sym and settings.showgrid then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(0,0,0,180)
        love.graphics.line(self.width/2+self.tilesize, self.y, self.width/2+self.tilesize, self.y + self.height)
        love.graphics.setLineWidth(1)
    end

    if h_sym and settings.showgrid then
        love.graphics.setLineWidth(2)
        love.graphics.setColor(0,0,0,180)
        love.graphics.line(self.x, (self.height/2) + self.y, self.x + self.width, (self.height/2) + self.y)
        love.graphics.setLineWidth(1)
    end

   -- love.graphics.setColor(30, 30, 30, 255)
   -- love.graphics.setLineWidth(2)
   -- love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end