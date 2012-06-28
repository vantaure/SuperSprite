Class = require 'includes/class'
require 'includes/utils'
require 'includes/grid'
require 'includes/colourpicker'
require 'includes/ui'
require 'includes/export'
require 'includes/frameviewer'
require 'includes/FileBrowser'
--------------------------------------------------

function love.load()

	-- Resource loading, import all graphics for usage in application.
	img_background 	= 	love.graphics.newImage("resources/images/background.png")
	img_transparent 	= 	love.graphics.newImage("resources/images/transparent.png")
	img_transparent_s 	= 	love.graphics.newImage("resources/images/transparent_s.png")
	img_opacityslider 	= 	love.graphics.newImage("resources/images/bw_2.png")
	img_frame_rgb 		=	love.graphics.newImage("resources/images/frame_rgb.png")
	img_frame_lum	 	= 	love.graphics.newImage("resources/images/frame_lum.png")
	img_frame_opa 		= 	love.graphics.newImage("resources/images/frame_opa.png")
	img_buttonarea 		= 	love.graphics.newImage("resources/images/buttonarea.png")
	img_buttonarea2 	= 	love.graphics.newImage("resources/images/buttonarea_large.png")
	img_button_200 		= 	love.graphics.newImage("resources/images/button_200.png")
	img_button_200_p 	= 	love.graphics.newImage("resources/images/button_200_pressed.png")
	img_button_88 		= 	love.graphics.newImage("resources/images/button_88.png")
	img_button_88_p 	= 	love.graphics.newImage("resources/images/button_88_pressed.png")
	img_button_prev 	= 	love.graphics.newImage("resources/images/button_prev.png")
	img_button_next 	= 	love.graphics.newImage("resources/images/button_next.png")
	img_prev_arrow		=	love.graphics.newImage("resources/images/arrow_prev.png")
	img_next_arrow 		=	love.graphics.newImage("resources/images/arrow_next.png")


	-- Set Initial canvas, or frame, settings, as well as the output zoom.
	size_x = 16
	size_y = 16
	grid_size = 32
	zoom = 10

	-- Set up a table for our window height and width for ease of access.
	window = {height = love.graphics.getHeight(), width = love.graphics.getWidth()}

	-- Build initial frame.
	frames = {
			Grid(32, 109, size_x, size_y, grid_size, 1)
		}

	

	-- Set the current frame to 1.
	currentFrame = 1

	-- Set up the colour picking objects.
	Colour = Picker(564, 109, "resources/images/rgb.png")
	Lumosity = Lumo(836, 109, "resources/images/bw.png")
	Opac = Opacity(564, 389)

	-- Set up frame view object.
	framev = Frameview(32, 32)
	table.insert(framev.frames, FramePreview(framev.x + 50 , framev.y + 17, 1))

	-- Set up some settings for the application.
	settings = {
		showgrid = true, 
		debug = false, 
		font = love.graphics.newFont('resources/fonts/pixelfont.ttf', 13)
	}

	-- Set temporary selected colours.
	selectedColour = {primary = {r=0, g=0, b=0, a=0}, secondary = {r=0, g=0, b=0, a=0}}

	-- Create all buttons and store them inside a table, so we can draw and update them with a loop later.
	buttons = {
		-- Edit buttons
		export 		= 	Button(610, 375 + 80, img_button_200, "Export Image"),
		clear 		= 	Button(610, 407 + 80, img_button_200, "Clear Canvas"),
		m_zoom 	= 	Button(610, 439 + 80, img_button_88, "-Zoom"),
		a_zoom 	= 	Button(722, 439 + 80, img_button_88, "+Zoom"),
		m_width 	= 	Button(610, 471 + 80, img_button_88, "-Width"),
		a_width 	= 	Button(722, 471 + 80, img_button_88, "+Width"),
		m_height	= 	Button(610, 503 + 80, img_button_88, "-Height"),
		a_height	= 	Button (722, 503 + 80, img_button_88, "+Height"),

		-- Options buttons
		togg_grid 	= 	Button(610, 375 + 80, img_button_200, "Toggle Grid", "toggle", img_button_200_p),
		togg_info 	= 	Button(610, 407 + 80, img_button_200, "Toggle Information", "toggle", img_button_200_p),
		togg_vsym 	= 	Button(610, 439 + 80, img_button_200, "Vertical Symmetry", "toggle", img_button_200_p),
		togg_hsym 	= 	Button(610, 471 + 80, img_button_200, "Horizontal Symmetry", "toggle", img_button_200_p),
		folder 		= 	Button(610, 503 + 80, img_button_200, "Open Save Folder"),

		prev 		= 	Button(564, 338 + 80, img_button_prev),
		next 		= 	Button(827, 338 + 80, img_button_next),

		-- Animation Buttons
		next_frame 	= 	Button(722, 375 + 80, img_button_88, "Next Frame"),
		prev_frame	= 	Button(610, 375 + 80, img_button_88, "Prev Frame"),
		add_frame 	= 	Button(610, 407 + 80, img_button_200, "Add Frame"),
		dup_frame 	= 	Button(610, 439 + 80, img_button_200, "Duplicate Frame"),
		del_frame 	= 	Button(610, 471 + 80, img_button_200, "Remove Frame"),
		onionskin 	= 	Button(610, 503 + 80, img_button_200, "Onion Skin", "toggle", img_button_200_p),

		-- Import Buttons
		import 		= 	Button(610, 375 + 80, img_button_200, "Import Image"),
		imp_m_zoom 	= 	Button(610, 407 + 80, img_button_88, "-Zoom"),
		imp_a_zoom 	= 	Button(722, 407 + 80, img_button_88, "+Zoom"),
		frame_m_width 	= 	Button(610, 439 + 80, img_button_88, "-Width"),
		frame_a_width	= 	Button(722, 439 + 80, img_button_88, "+Width"),
		frame_m_height = 	Button(610, 471 + 80, img_button_88, "-Height"),
		frame_a_height 	= 	Button(722, 471 + 80, img_button_88, "+Height"),
	}

	-- Set up symmetry and onion skin default values
	v_sym = false
	h_sym = false
	onionskin = false

	-- Set default page in the button area. ("Edit" / "Options" / "Animation" / "Import")
	page = "Edit"

	-- Create needed folders that may not exist if the user has not run the program before, else skip.
	if not love.filesystem.isDirectory("import") then
		love.filesystem.mkdir("import")
	end
	if not love.filesystem.isDirectory("export") then
		love.filesystem.mkdir("export")
	end

	FBrowser = FileBrowser(564,110, "import", {"png"})
end

--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

function love.keypressed(key)
	-- Keyboard shortcuts for switching pages.
	if key == "q" then page = "Edit" end
	if key == "w" then page = "Options" end
	if key == "e" then page = "Animation" end
	if key == "r" then page = "Import" end

	-- Keyboard shortcuts for simple functions
	if key == "o" then
		onionskin = not onionskin
		buttons.onionskin:Toggle()
	end
	if key == "g" then 
		settings.showgrid = not settings.showgrid
		buttons.togg_grid:Toggle()
	end

	-- Keyboard shortcut to rotate along symmetry options.
	if key == "s" then
		if v_sym == false and h_sym == false then
			v_sym = true h_sym = false
			buttons.togg_vsym.toggle = true
			buttons.togg_hsym.toggle = false
		elseif
			v_sym == true and h_sym == false then v_sym = false h_sym = true
			buttons.togg_vsym.toggle = false
			buttons.togg_hsym.toggle = true
		elseif
			v_sym == false and h_sym == true then v_sym = true h_sym = true
			buttons.togg_vsym.toggle = true
			buttons.togg_hsym.toggle = true
		elseif
			v_sym == true and h_sym == true then v_sym = false h_sym = false
			buttons.togg_vsym.toggle = false
			buttons.togg_hsym.toggle = false
		end
	end

	-- Animation Control Shortcuts
	if key == "left" then
		if love.keyboard.isDown("lctrl") then
			currentFrame = 1
		else
			if currentFrame ~= 1 then
				currentFrame = currentFrame - 1
			end
		end
	end

	if key == "right" then
		if love.keyboard.isDown("lctrl") then
				currentFrame = #frames
		else
			if currentFrame ~= #frames then
					currentFrame = currentFrame + 1
			end
		end
	end

	if key == "return" or key == "kpenter" then
		if love.keyboard.isDown("lctrl") then
			table.insert(frames, currentFrame+1, Grid(32, 109, size_x, size_y, grid_size, currentFrame+1))
			for k, v in pairs(framev.frames) do
				if v.frame > currentFrame then
					v.frame = v.frame + 1
					v.x = v.x + 46
				end
			end
			table.insert(framev.frames,currentFrame + 1, FramePreview(framev.x + framev.frames[currentFrame].x + 14 , framev.y + 17, currentFrame+1))
			if #framev.frames > 16 then
				for k, v in pairs(framev.frames) do
					v.x = v.x - 46
				end
			end
			currentFrame = currentFrame+1
		else
			for k, v in pairs(frames) do
				if v.frame > currentFrame then
					v.frame = v.frame + 1
				end
			end
			table.insert(frames, Grid(32, 109, size_x, size_y, grid_size, #frames +1))
			table.insert(framev.frames, FramePreview(framev.x + framev.frames[#framev.frames].x + 14 , framev.y + 17, #frames))
			if #framev.frames > 16 then
				for k, v in pairs(framev.frames) do
					v.x = v.x - 46
				end
			end
			currentFrame = #frames
		end
	end
end


--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------
--------------------------------------------------

function love.mousepressed(x, y, button)

	-- Call our mousepressed functions for each of our buttons on the Edit page.
	if page == "Edit" then
		buttons.export:mousepressed(button)
		buttons.clear:mousepressed(button)
		buttons.m_zoom:mousepressed(button)
		buttons.a_zoom:mousepressed(button)
		buttons.m_width:mousepressed(button)
		buttons.a_width:mousepressed(button)
		buttons.m_height:mousepressed(button)
		buttons.a_height:mousepressed(button)
		buttons.next:mousepressed(button)
	end

	-- Call our mousepressed functions for each of our buttons on the Options page.
	if page == "Options" then
		buttons.togg_grid:mousepressed(button)
		buttons.togg_info:mousepressed(button)
		buttons.togg_vsym:mousepressed(button)
		buttons.togg_hsym:mousepressed(button)
		buttons.folder:mousepressed(button)
		buttons.prev:mousepressed(button)
		buttons.next:mousepressed(button)
	end

	-- --- Call our mousepressed functions for each of our buttons on the Animation page.
	if page == "Animation" then
		buttons.prev:mousepressed(button)
		buttons.next:mousepressed(button)
		buttons.prev_frame:mousepressed(button)
		buttons.next_frame:mousepressed(button)
		buttons.add_frame:mousepressed(button)
		buttons.del_frame:mousepressed(button)
		buttons.dup_frame:mousepressed(button)
		buttons.onionskin:mousepressed(button)
	end

	if page == "Import" then
		buttons.prev:mousepressed(button)
		buttons.import:mousepressed(button)
		buttons.imp_m_zoom:mousepressed(button)
		buttons.imp_a_zoom:mousepressed(button)
		buttons.frame_m_width:mousepressed(button)
		buttons.frame_a_width:mousepressed(button)
		buttons.frame_m_height:mousepressed(button)
		buttons.frame_a_height:mousepressed(button)

		FBrowser:mousepressed(x, y, button)
	end

	for k, v in pairs(framev.frames) do
		v:mousepressed(button)
	end
end

--------------------------------------------------

function love.mousereleased(x, y, button)
	if button == "l" or button == "r" then
		if framev.frames[currentFrame] then
			framev.frames[currentFrame]:change()
		end
	end
end

-------------------------------------------------

function love.update()
	-- Update the frame browser
	framev:update()

	-- Update the canvas for the current frame.
	frames[currentFrame]:update()

	if page ~= "Import" then
		-- Update each of the colour pallette objects.
		Colour:update()
		Lumosity:update()
		Opac:update()

		-- Set our selected primary colour to the primary colour of the colour pallette objects,, if it's different.
		if selectedColour.primary ~= Colour:getPrimary() then
			selectedColour.primary = Colour:getPrimary()
		end

		-- Set our selected primary colour to the secondary colour of the colour pallette objects, if it's different.
		if selectedColour.secondary ~= Colour:getSecondary() then
			selectedColour.secondary = Colour:getSecondary()
		end
	else
		-- FBrowser:update()
	end

	-- If the current page is Options
	if page == "Options" then
		-- Update all the buttons on the page.
		buttons.togg_grid:update()
		buttons.togg_info:update()
		buttons.togg_vsym:update()
		buttons.togg_hsym:update()
		buttons.folder:update()
		buttons.prev:update()
		buttons.next:update()

		-- If the button is pushed, execute the following.
		if buttons.togg_grid:isPressed() then -- If the toggle grid button is pushed,
			settings.showgrid = not settings.showgrid 

		elseif buttons.togg_info:isPressed() then -- If the toggle debug info button is pressed,
			settings.debug = not settings.debug 

		elseif buttons.togg_vsym:isPressed() then -- If the vertical symmetry button is pushed then,
			v_sym = not v_sym

		elseif buttons.togg_hsym:isPressed() then -- If the horizontal symmetry button is pushed then,
			h_sym = not h_sym

		elseif buttons.folder:isPressed() then -- If we push the open save folder button
			--os.execute("C:/windows/explorer.exe /e, C:\\Users\\William\\AppData\\Roaming\\LOVE\\SuperSprite")
			os.execute("C:/windows/explorer.exe /e, %appdata%\\LOVE\\SuperSprite")

		elseif buttons.prev:isPressed() then -- If we push the previous page button then,
			page = "Edit"

		elseif buttons.next:isPressed() then -- If we push the next page button then, 
			page = "Animation"
		end
	end

	-- If the current page is Options
	if page == "Edit" then
		-- Update all the buttons on the page.
		buttons.next:update()
		buttons.export:update()
		buttons.clear:update()
		buttons.m_zoom:update()
		buttons.a_zoom:update()
		buttons.m_width:update()
		buttons.a_width:update()
		buttons.m_height:update()
		buttons.a_height:update()


		-- If the button is pushed, execute the following.
		if buttons.next:isPressed() then -- If the next page button is pressed then,
			page = "Options"
		elseif buttons.clear:isPressed() then -- If the clear frame button is pressed then, 
			frames[currentFrame] = Grid(32, 109, size_x, size_y, grid_size, currentFrame)
		elseif buttons.export:isPressed() then -- If the export button is pressed then,
			export_data = newDataSheet(size_x, size_y, zoom)
			export_png(export_data, "export/" .. os.date("%b %d %Y, %H.%M.%S"))
		elseif buttons.m_zoom:isPressed() then -- If the minus zoom button is pressed then,
			if zoom ~= 1 then
				zoom = zoom - 1
			end
		elseif buttons.a_zoom:isPressed() then -- if the add zoom button is pressed then,
			if zoom ~= 20 then
				zoom = zoom + 1
			end
		elseif buttons.m_width:isPressed() then  -- if the minus width button is pressed then,
			if size_x ~= 1 then
				size_x = size_x -1
				for k,v in pairs(frames) do
 					v:removeRow()
 					v.size_x = size_x
 				end
			end
		elseif buttons.a_width:isPressed() then -- if the add width button is pressed then,
			if size_x ~= 16 then
				size_x = size_x +1
				for k,v in pairs(frames) do
 					v:addRow()
 					v.size_x = size_x
 				end
			end
		elseif buttons.m_height:isPressed() then  -- if the minus height button is pressed then,
			if size_y ~= 1 then
				size_y = size_y -1
				for k,v in pairs(frames) do
 					v:removeColumn()
 					v.size_y = size_y
 				end
			end
		elseif buttons.a_height:isPressed() then -- if the add height button is pressed then,
			if size_y ~= 16 then
				size_y = size_y +1
				for k,v in pairs(frames) do
 					v:addColumn()
 					v.size_y = size_y
 				end
			end
		end
	end

	-- If the current page is Options
	if page == "Animation" then

		-- Update all the buttons on the page.
		buttons.prev:update()
		buttons.next:update()
		buttons.prev_frame:update()
		buttons.next_frame:update()
		buttons.add_frame:update()
		buttons.del_frame:update()
		buttons.dup_frame:update()
		buttons.onionskin:update()

		-- Adjust button labels according to wither CTRL is pressed down, to match the function they would execute.
		if love.keyboard.isDown("lctrl") then
			buttons.next_frame.label = "Last Frame"
			buttons.prev_frame.label = "First Frame"
			buttons.add_frame.label = "Add Frame at Current Position"
			buttons.del_frame.label = "Delete Current Frame"
			buttons.dup_frame.label = "Dup frame to Current Position"
		else
			buttons.next_frame.label = "Next Frame"
			buttons.prev_frame.label = "Prev Frame"
			buttons.add_frame.label = "Add Frame at End"
			buttons.del_frame.label = "Delete Last Frame"
			buttons.dup_frame.label = "Duplicate frame to End"
		end


		-- If the button is pushed, execute the following.
		if buttons.prev:isPressed() then -- if previous page button is pressed then,
			page = "Options"
		elseif buttons.next:isPressed() then
			page = "Import"
		elseif buttons.next_frame:isPressed() then -- if next frame button is pressed then,
			if love.keyboard.isDown("lctrl") then
				currentFrame = #frames
			else
				if currentFrame ~= #frames then
					currentFrame = currentFrame + 1
				end
			end
		elseif buttons.prev_frame:isPressed() then -- if previous frame button is pressed then,
			if love.keyboard.isDown("lctrl") then
				currentFrame = 1
			else
				if currentFrame ~= 1 then
					currentFrame = currentFrame - 1
				end
			end
		elseif buttons.add_frame:isPressed() then -- if add frame button is pressed then,
			if love.keyboard.isDown("lctrl") then
				table.insert(frames, currentFrame+1, Grid(32, 109, size_x, size_y, grid_size, currentFrame+1))
				for k, v in pairs(framev.frames) do
					if v.frame > currentFrame then
						v.frame = v.frame + 1
						v.x = v.x + 46
					end
				end
				table.insert(framev.frames,currentFrame + 1, FramePreview(framev.x + framev.frames[currentFrame].x + 14 , framev.y + 17, currentFrame+1))
				if #framev.frames > 16 then
					for k, v in pairs(framev.frames) do
						v.x = v.x - 46
					end
				end
				currentFrame = currentFrame+1
			else
				for k, v in pairs(frames) do
					if v.frame > currentFrame then
						v.frame = v.frame + 1
					end
				end

				table.insert(frames, Grid(32, 109, size_x, size_y, grid_size, #frames +1))
				table.insert(framev.frames, FramePreview(framev.x + framev.frames[#framev.frames].x + 14 , framev.y + 17, #frames))
				if #framev.frames > 16 then
					for k, v in pairs(framev.frames) do
						v.x = v.x - 46
					end
				end
				currentFrame = #frames
			end

		elseif buttons.dup_frame:isPressed() then -- if duplicate frame button is pressed then, 
			if love.keyboard.isDown("lctrl") then
				table.insert(frames, currentFrame+1, Grid(32, 109, size_x, size_y, grid_size, currentFrame + 1))
				frames[currentFrame+1]:Copy(frames[currentFrame])
				table.insert(framev.frames, FramePreview(framev.x + framev.frames[#framev.frames].x + 14 , framev.y + 17,  #framev.frames + 1))
				for k, v in pairs(framev.frames) do
					v:change()
					if #framev.frames > 16 then
						v.x = v.x - 46
					end
				end
				currentFrame = currentFrame+1
			else
				table.insert(frames, Grid(32, 109, size_x, size_y, grid_size, #frames + 1))
				frames[#frames]:Copy(frames[currentFrame])
				table.insert(framev.frames, FramePreview(framev.x + framev.frames[#framev.frames].x + 14 , framev.y + 17,  #framev.frames + 1))
				for k, v in pairs(framev.frames) do
					v:change()
					if #framev.frames > 16 then
						v.x = v.x - 46
					end
				end
				currentFrame = #frames
			end
		elseif buttons.del_frame:isPressed() then -- if delete frame button is pressed then,
			if #frames ~= 1 then
				if love.keyboard.isDown("lctrl") and currentFrame ~= 1 then
					table.remove(frames, currentFrame)
					table.remove(framev.frames, currentFrame)

					for k,v in pairs(framev.frames) do
						if v.frame > currentFrame then
							v.frame = v.frame - 1
							v.x = v.x - 46
						end
					end
					currentFrame = currentFrame - 1
				end

				if not love.keyboard.isDown("lctrl") then
					if #framev.frames > 16 then
						for k, v in pairs(framev.frames) do
							v.x = v.x + 46
						end
					end
					if currentFrame == #frames then
						currentFrame = #frames - 1
					end
					table.remove(frames, #frames)
					table.remove(framev.frames, #framev.frames)
				end
			end
		elseif buttons.onionskin:isPressed() then -- if onion skin button is pressed then, 
			onionskin = not onionskin
		end
	end

	if page == "Import" then
		if buttons.prev:isPressed() then -- if previous page button is pressed then,
			page = "Animation"
		elseif buttons.import:isPressed() then
			if FBrowser.selected then
				import_image(FBrowser.selected, 16, 16)
			end
		elseif buttons.imp_m_zoom:isPressed() then

		elseif buttons.imp_a_zoom:isPressed() then

		end
	end
end

--------------------------------------------------

function love.draw()
	-- Set font
	love.graphics.setFont(settings.font)

	-- Draw the background of the application
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(img_background, 0, 0)

	-- Draw the frame viewer
	framev:draw()

	-- Draw the previous frame if onion skin is on.
	if onionskin == true and currentFrame ~= 1 then
		frames[currentFrame-1]:draw()
	end

	-- Draw the current frame's canvas.
	love.graphics.setLineStyle("rough")
	frames[currentFrame]:draw()

	if page ~= "Import" then
		-- Draw the main colour picker, and it's frame image.
		Colour:draw()
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(img_frame_rgb, Colour.x-2, Colour.y-2)

		-- Draw the lumosity slider's picker, and it's frame image.
		Lumosity:draw()
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(img_frame_lum, Lumosity.x-2, Lumosity.y-2)

		-- Draw the opacity slider's picker, and it's frame image.
		Opac:draw()
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(img_frame_opa, Opac.x-4, Opac.y-2)

		-- Draw the primary colour display, including the background transparent image, and border.
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(img_transparent_s, 838, 391)
		love.graphics.setColor(selectedColour.secondary.r, selectedColour.secondary.g, selectedColour.secondary.b, selectedColour.secondary.a)
		love.graphics.rectangle("fill", 838, 391, 16, 16)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("line", 838, 391, 16, 16)

		-- Draw the secondary colour display, including the background transparent image, and border.
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(img_transparent_s, 830, 383)
		love.graphics.setColor(selectedColour.primary.r, selectedColour.primary.g, selectedColour.primary.b, selectedColour.primary.a)
		love.graphics.rectangle("fill", 830, 383, 16, 16)
		love.graphics.setColor(0, 0, 0, 255)
		love.graphics.rectangle("line", 830, 383, 16, 16)
	else
		FBrowser:Draw()
	end

	-- Draw the background image of the button area.
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(img_buttonarea, 564, 416)

	-- If the page is options then
	if page == "Options" then
		-- Draw page title.
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print("OPTIONS", 685, 425)

		--Draw all buttons on page.
		buttons.togg_grid:draw()
		buttons.togg_info:draw()
		buttons.togg_vsym:draw()
		buttons.togg_hsym:draw()
		buttons.folder:draw()
		buttons.prev:draw()
		buttons.next:draw()
	end

	-- If the page is edit then
	if page == "Edit" then
		-- Draw page title.
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print("EDIT", 695, 425)

		--Draw export, clear and next buttons.
		buttons.export:draw()
		buttons.clear:draw()
		buttons.next:draw()

		-- Draw the minus and add buttons for Zoom, as well as printing it's value in the middle.
		buttons.m_zoom:draw()
		buttons.a_zoom:draw()
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print(zoom, 705, 525)

		-- Draw the minus and add buttons for Width as well as printing it's value in the middle.
		buttons.m_width:draw()
		buttons.a_width:draw()
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print(size_x, 705, 557)

		-- Draw the minus and add buttons for Height, as well as printing it's value in the middle.
		buttons.m_height:draw()
		buttons.a_height:draw()
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print(size_y, 705, 590)
	end

	-- If the page is Animation then
	if page == "Animation" then
		-- Draw page title.
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print("ANIMATION", 680, 425)

		-- Draw all the buttons on the page.
		buttons.prev:draw()
		buttons.next:draw()
		buttons.next_frame:draw()
		buttons.prev_frame:draw()
		buttons.add_frame:draw()
		buttons.dup_frame:draw()
		buttons.del_frame:draw()
		buttons.onionskin:draw()

		-- Draw the current frame in between the next and previous buttons.
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print(currentFrame, 705, 462)
	end

	if page == "Import" then
		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print("IMPORT", 688, 425)

		buttons.prev:draw()
		buttons.import:draw()
		buttons.imp_m_zoom:draw()
		buttons.imp_a_zoom:draw()
		buttons.frame_m_width:draw()
		buttons.frame_a_width:draw()
		buttons.frame_m_height:draw()
		buttons.frame_a_height:draw()

		love.graphics.setColor(95, 95, 95, 255)
		love.graphics.print("Note: All options are relative to a single frame.", 578, 588)
		love.graphics.print("Zoom defines the num of pixels a single pixel is.", 574, 603)
	end
end