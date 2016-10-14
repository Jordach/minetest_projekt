function get_size (w)
	local file = io.open(w)
	if file then
	
		file:seek("set", 16)
		local widthstr, heightstr = file:read(4), file:read(4)
	
		local width=widthstr:sub(1,1):byte()*16777216+widthstr:sub(2,2):byte()*65536+widthstr:sub(3,3):byte()*256+widthstr:sub(4,4):byte()
		local height=heightstr:sub(1,1):byte()*16777216+heightstr:sub(2,2):byte()*65536+heightstr:sub(3,3):byte()*256+heightstr:sub(4,4):byte()
	
		minetest.chat_send_all(tostring(width))
		minetest.chat_send_all(tostring(height))
	
		file:close()
	
		return width, height
	end
end

minetest.register_on_joinplayer(function(player)
	local filename = minetest.get_modpath("player_textures").."/textures/player_"..player:get_player_name()
	local f = io.open(filename..".png")
	if f then
		local png_width, png_height = get_size(filename..".png")
		f:close()
		
		minetest.chat_send_all(tostring(png_width / png_height))
		
		if png_width / png_height == 2 then
			player:set_properties({ -- if rectangle texture; eg 64x32
				textures = {"player_"..player:get_player_name()..".png", "ptextures_transparent.png"}
			})
		elseif png_width / png_height == 1 then
			player:set_properties({ -- if square texture; eg 64x64
				textures = {"ptextures_transparent.png", "player_"..player:get_player_name()..".png"}
			})
		end
	end
end)
