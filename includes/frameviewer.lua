Frameview = Class{function(self, x, y)
    -- Set position values
    self.x = x
    self.y = y

    -- Set up required images.
    self.image = {
        border = love.graphics.newImage("resources/images/fv_border.png"),
        background = love.graphics.newImage("resources/images/fv_background.png"),
        transbg = love.graphics.newImage("resources/images/transparent_preview.png")
    }

    --Set up width and height.
    self.width = self.image.border:getWidth()
    self.height = self.image.border:getHeight()

    -- Set up required buttons.
    self.buttons = {
        left_scroll = Button(self.x + 10, self.y + 15, img_prev_arrow),
        right_scroll = Button(self.x + self.width - 30, self.y + 15, img_next_arrow)
    }

    self.frames = {}

end}

function Frameview:update()

    if #frames >16  then
        if self.buttons.left_scroll:mouseover() and self.frames[1].x < self.x + 50 then
            for k, v in pairs(self.frames) do
                if love.mouse.isDown("l") then
                    v.x = v.x + 4
                else
                    v.x = v.x + 2
                end
            end
        end

        if self.buttons.right_scroll:mouseover() and self.frames[#self.frames].x + self.frames[#self.frames].width > self.x +self. width -  50 then
            for k, v in pairs(self.frames) do
                if love.mouse.isDown("l") then
                    v.x = v.x - 4
                else
                    v.x = v.x - 2
                end
            end
        end
    end

    for k, v in pairs(self.frames) do
        v:update()
    end
end

function Frameview:draw()
    -- Draw  background
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.image.background, self.x+2, self.y+2)

    -- Draw frames
    for k, v in pairs(self.frames) do
        if v.x + v.width > self.x + 40 and v.x < self.x + self.width - 40 then
            v:draw()
        end
    end

    -- Draw border
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(self.image.border, self.x, self.y)

    if #self.frames > 16 then
        --Draw Left Arrow button
        if self.buttons.left_scroll:mouseover() then
            love.graphics.setColor(255,255,255,100)
        else
            love.graphics.setColor(255,255,255,50)
        end
            self.buttons.left_scroll:draw()

        --Draw Right Arrow Button
        if self.buttons.right_scroll:mouseover() then
            love.graphics.setColor(255,255,255,100)
        else
            love.graphics.setColor(255,255,255,50)
        end
        self.buttons.right_scroll:draw()
    end

end

-----------------------
-- FRAME PREVIEW --
-----------------------

FramePreview = Class{function(self, x, y, frame)
    -- Set position values
    self.x = x
    self.y = y
    self.frame = frame

    -- Render image of grid for preview, change size depending on canvas scale.
     if size_x > 8 or size_y > 8 then
        self.data = newDataSingle(size_x, size_y, 2,  frames[self.frame])
    elseif size_x  > 4 and size_x <=8 or size_y > 4 and size_y <=8 then
        self.data = newDataSingle(size_x, size_y, 4,  frames[self.frame])
    elseif size_x > 2 and size_x <=4 or size_y > 2 and size_y <=4 then
        self.data = newDataSingle(size_x, size_y, 8,  frames[self.frame])
    elseif size_x > 1 and size_x <=2 or size_y > 1 and size_y <=2 then
        self.data = newDataSingle(size_x, size_y, 16,  frames[self.frame])
    elseif size_x == 1 and size_y == 1 then
        self.data = newDataSingle(size_x, size_y, 32,  frames[self.frame])
    end
    self.image = love.graphics.newImage(self.data)

    -- Get width and height from image, as well as the x center of the frame
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()
    self.centerx = self.x + self.width/2

end}

function FramePreview:change()
    -- Re-Render image of grid for preview, change size depending on canvas scale.
    if size_x > 8 or size_y > 8 then
        self.data = newDataSingle(size_x, size_y, 2,  frames[self.frame])
    elseif size_x  > 4 and size_x <=8 or size_y > 4 and size_y <=8 then
        self.data = newDataSingle(size_x, size_y, 4,  frames[self.frame])
    elseif size_x > 2 and size_x <=4 or size_y > 2 and size_y <=4 then
        self.data = newDataSingle(size_x, size_y, 8,  frames[self.frame])
    elseif size_x > 1 and size_x <=2 or size_y > 1 and size_y <=2 then
        self.data = newDataSingle(size_x, size_y, 16,  frames[self.frame])
    elseif size_x == 1 and size_y == 1 then
        self.data = newDataSingle(size_x, size_y, 32,  frames[self.frame])
    end
    self.image = love.graphics.newImage(self.data)
end

function FramePreview:mousepressed(button)
    if button == "l" and mouseHover(self.x, self.y, self.width, self.height) then
        if self.x > framev.x + 35 and self.x < framev.x + framev.width - 35 then
            if not framev.buttons.left_scroll:mouseover() and not framev.buttons.right_scroll:mouseover() then
                if currentFrame ~= self.frame then
                    currentFrame = self.frame
                end
            end
        end
    end
end

function FramePreview:update()

end

function FramePreview:mouseover()
    if mouseHover(self.x, self.y, self.width, self.height) then
        return true
    else
        return false
    end
end

function FramePreview:draw()
    love.graphics.setColor(255, 255, 255, 255)

    --Draw transparent bg image
    love.graphics.draw(framev.image.transbg, self.x, self.y)

    --Draw rendered preview
    love.graphics.draw(self.image, self.x, self.y)

    --Draw borders
    love.graphics.rectangle("line", self.x, self.y-1, self.width+1, self.height+1)
    if self.frame == currentFrame then
        love.graphics.setColor(225,55,45,255)
    else
        love.graphics.setColor(0,0,0,255)
    end
    love.graphics.rectangle("line", self.x-1, self.y-2, self.width+3, self.height+3)

    if self:mouseover() then
        if not framev.buttons.left_scroll:mouseover() and not framev.buttons.right_scroll:mouseover() then
            love.graphics.setColor(67,67,67,200)
            love.graphics.rectangle("fill", self.x, self.y, 32, 32)
            love.graphics.setColor(255,255,255,200)
            love.graphics.printf(self.frame .. "/" .. #framev.frames, self.x+5, self.y+3,  32-6, "center")
        end
    end

end
