
---------EXPORTING THE IMAGE----------

function findSquareRoot(numtiles)
	local tilesroot = math.sqrt(numtiles)
	return math.ceil(tilesroot)
end

function addBigPixel(data, multi, x, y, r, g, b, a, offset)
	for u = 0, multi-1 do
		for v = 0, multi-1 do
			data:setPixel(x+u+offset, y+v, r, g, b, a)
		end
	end
end

-- This will export a single frame with the given grid.
function newDataSingle(x, y, multi, grid)
	x = x*multi
	y = y*multi
	local data = love.image.newImageData(x, y)
	for u = 0, x-1 do
		for v = 0, y-1 do
			for k, value in pairs(grid.tiles) do 
				if value.coord.x == u and value.coord.y == v then
					local temp_u = u*multi
					local temp_v = v*multi
					addBigPixel(data, multi, temp_u, temp_v, value.colour.r, value.colour.g, value.colour.b, value.colour.a, 0)
				end
			end
		end
	end
	return data
end

-- This will export a sprite sheet with the given settings, using all the frames in the application.
function newDataSheet(x, y, multi)
	local framewidth = x*multi
	x = (x*multi)*#frames
	y = y*multi

	local writeposition = 0
	local data = love.image.newImageData(x, y)
	for keyframe, frame in pairs(frames) do
		for u = 0, x-1 do
			for v = 0, y-1 do
				for k, value in pairs(frame.tiles) do 
					if value.coord.x == u and value.coord.y == v then
						local temp_u = u*multi
						local temp_v = v*multi
						addBigPixel(data, multi, temp_u, temp_v, value.colour.r, value.colour.g, value.colour.b, value.colour.a,writeposition)
					end
				end
			end
		end
		writeposition = writeposition + framewidth
	end
	return data
end

function export_png(data, filename)
	local encoded = data:encode(filename .. ".png")
end


---------IMPORTING THE IMAGE----------

function import_frame(data, frame)
	-- Get the basic details about the image.
	local imgHeight  = data:getHeight()
	local imgWidth = data:getWidth()

	-- Get the grid of the specified frame.
	local grid =  frames[frame]

	if not grid then
		table.insert(frames, frame, Grid(32, 109, size_x, size_y, grid_size, frame))
		table.insert(framev.frames, frame, FramePreview(framev.x + framev.frames[frame-1].x + 14 , framev.y + 17, frame))
	end
	local grid =  frames[frame]
	-- Set up the loops to use as a position in the grid, find tile in same position and set the colour of the tile to that of the same position in the image.
	for x = 0, imgWidth-1 do
		for y = 0, imgHeight-1 do
			local r, g, b, a = data:getPixel(x, y)
			for k, tile in pairs(grid.tiles) do
				if tile.coord.x == x and tile.coord.y == y then
					tile.colour.r = r
					tile.colour.g = g
					tile.colour.b = b
					tile.colour.a = a
				end
			end
		end
	end

	framev.frames[frame]:change()
end

function grab_tile(data, x, y, width, height)
	local tileData = love.image.newImageData(width, height)
	for u = 0,  width-1 do
		for v = 0, height-1 do
			local r, g, b, a = data:getPixel(x+u, y+v)
			tileData:setPixel(u, v, r, g, b, a)
		end
	end
	return tileData
end

function import_image(filename, frameWidth, frameHeight)
	local data = love.image.newImageData("import/" ..  filename)
	local imgHeight  = data:getHeight()
	local imgWidth = data:getWidth()
	local passes = 0
	local frames_w = imgWidth / frameWidth
	local frames_h = imgHeight / frameHeight

	local frameCount = frames_w * frames_h

	if frameCount == 1 then
		import_frame(data, currentFrame)
	else
		for ss_y = 0, frames_h-1 do
			for ss_x = 0, frames_w-1 do
				local img_x = ss_x * frameWidth
				local img_y = ss_y * frameHeight
				local tile = grab_tile(data, img_x, img_y, frameWidth, frameHeight)
				import_frame(tile, currentFrame + passes)
				passes = passes + 1
			end
		end
	end
end