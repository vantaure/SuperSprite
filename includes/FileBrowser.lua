FileBrowser = Class{function(self, x, y, directory, validtypes)
    self.x = x
    self.y = y

    self.selectedfile = nil
    self.directory = directory
    self.validtypes = validtypes
    self.files = {}
    self.buttons = {}
    self.selected = nil

    self:FindFiles()

    local alt = true
    local offset = 0
    for _,v in pairs(self.files) do
    	table.insert(self.buttons, FB_Button(self.x+1,self.y+20+offset, 294, 20, v, alt))
    	alt = not alt
    	offset = offset+20
    end
end}




function FileBrowser:IsValidDir(directory)
	if love.filesystem.isDirectory(directory) then
		return true
	end
	return false
end

function FileBrowser:FindFiles()
	if self:IsValidDir(self.directory) then
		local files = love.filesystem.getDirectoryItems(self.directory)
		if files then
			local validfiles = {}
			for _, name in pairs(files) do
				for _, ext in pairs(self.validtypes) do
					if string.find(name, ".png") then
						table.insert(validfiles, name)
					end
				end
			end
			self.files = validfiles
			return validfiles
		else
			return false
		end
	else
		return false
	end
end

function FileBrowser:mousepressed(x, y, button)
	for _, v in pairs(self.buttons) do
		v:mousepressed(x, y, button)
	end
end

function FileBrowser:Refresh()

end

function FileBrowser:Update()

end

function FileBrowser:Draw()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(img_buttonarea2, self.x, self.y)

	love.graphics.setColor(95, 95, 95, 255)
	love.graphics.print("FILE BROWSER", self.x+108, self.y+5)

	for _, v in pairs(self.buttons) do
		v:Draw()
	end
end


------------------------------------\
------------------------------------|
------- FILE BROWSER BUTTONS--------| This bit is pretty boring :(((
------------------------------------|
------------------------------------/ 




FB_Button = Class{function(self, x, y, w, h, label, alternate)
    self.x = x
    self.y = y
    self.w = w
    self.h = h

    self.label = label
    self.alt = alternate
end}

function FB_Button:mousepressed(x, y, button)
	if button == "l" and mouseHover(self.x, self.y, self.w, self.h) then
		FBrowser.selected = self.label
	end
end

function FB_Button:Update()

end

function FB_Button:Draw()
	if self.alt then
		love.graphics.setColor(255,255,255,20)
		alternate = false
	else
		love.graphics.setColor(255,255,255,0)
		alternate = true
	end

	love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	love.graphics.setColor(95, 95, 95, 255)

	if self.label == FBrowser.selected then
		love.graphics.print("  " .. self.label, self.x+10, self.y+4)
	else
		love.graphics.print(self.label, self.x+10, self.y+4)
	end

	if mouseHover(self.x, self.y, self.w, self.h) or self.label == FBrowser.selected then
		love.graphics.setColor(255,255,255,10)
		love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
	end
end