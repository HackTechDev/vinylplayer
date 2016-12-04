vinylplayer_player = {} 


-- /giveme vinylplayer:player 99
minetest.register_node("vinylplayer:player", {
	description = "Vinyl Player",
	tiles = {
		"vinylplayer_player_up.png",
		"vinylplayer_player_down.png",
		"vinylplayer_player_right.png",
		"vinylplayer_player_left.png",
		"vinylplayer_player_back.png",
		"vinylplayer_player_front.png"
	},

	is_ground_content = true,

	groups = {
		cracky = 3
	},

	drop = "vinylplayer:player_fragments",

    on_rightclick = function(pos, node, player, itemstack, pointed_thing)
 
		local node = minetest.get_node(pos)
		local meta = minetest.get_meta(pos)
		local aa = meta:get_string("a")
		local bb = tonumber(meta:get_string("b")) or 5
		local cc = tonumber(meta:get_string("c")) or 3
		local dd = meta:get_string("d")
		local ee = tonumber(meta:get_string("e")) or 10
        local ff = tonumber(meta:get_string("e")) or 1    

		minetest.show_formspec(player:get_player_name(),"fs",
				"size[6,7;]"..
				"background[-0.5,-0.5;7,8;mysoundblocks_bg.png]"..
				"field[1,1;4.5,1;snd;Enter Sound Name;"..aa.."]"..
				"field[1,2;4.5,1;txt;Enter Chat Message;"..dd.."]"..
				"field[1,3;2,1;sndl;Length;"..bb.."]"..
				"field[3.5,3;2,1;sndhd;Radius;"..cc.."]"..
				"label[0.7,3.4;Player or All]"..
				"dropdown[0.7,3.8;2,1;pora;Player,All;]"..
				"field[3.5,4;2,1;snddis;Hear Distance;"..ee.."]"..
				"field[2.75,5;1,1;sndgn;Gain;"..ff.."]"..
				"button_exit[0.75,5.75;1.5,1;ents;Sound]"..
				"button_exit[2.25,5.75;1.5,1;entc;Chat]"..
                "button_exit[3.75,5.75;1.5,1;entb;Both]"
        )
        
		minetest.register_on_player_receive_fields(function(player, formname, fields)

			local meta = minetest.get_meta(pos)
			local inv = meta:get_inventory()
			local thing1 = fields["snd"]
			local thing2 = fields["sndl"]
			local thing3 = fields["sndhd"]
			local thing4 = fields["txt"]
			local thing5 = ""
			local thing6 = fields["pora"]
			local thing7 = fields["snddis"]
			local thing8 = fields["sndgn"]


			if fields["ents"]
			    or fields["entc"]
			    or fields["entb"]
			    or fields["snd"]
			    or fields["txt"] then

				if fields["ents"]
				and fields["snd"] ~= "" then

					meta:set_string("a", thing1)
					meta:set_string("b", thing2)
					meta:set_string("c", thing3)
					meta:set_string("d", thing4)
					meta:set_string("e", "sound")
					meta:set_string("f", thing6)
					meta:set_string("g", thing7)
					meta:set_string("h", thing8)

					return true

				elseif fields["entc"]
				and fields["txt"] ~= "" then

					meta:set_string("a", thing1)
					meta:set_string("b", thing2)
					meta:set_string("c", thing3)
					meta:set_string("d", thing4)
					meta:set_string("e", "chat")

			
					return true

				elseif fields["entb"]
				and fields["txt"] ~= ""
				and fields["snd"] ~= "" then

					meta:set_string("a", thing1)
					meta:set_string("b", thing2)
					meta:set_string("c", thing3)
					meta:set_string("d", thing4)
					meta:set_string("e", "both")
					meta:set_string("f", thing6)
					meta:set_string("g", thing7)
					meta:set_string("h", thing8)

					return true
				end

			else
				return
            end



        end)

    end,

})


function vinylplayer_get_handle(pos)
    print("vinylplayer_get_handle: begin")
    local i = 0
    while vinylplayer_player[i] ~= nil do
        local mypos = minetest.pos_to_string(vinylplayer_player[i].pos)
        print( "[ " .. tostring(i) .." ] at " .. mypos)

        print("    " .. tostring(vinylplayer_player[i].pos.x) .. " " .. tostring(pos.x))
        print("    " .. tostring(vinylplayer_player[i].pos.y) .. " " .. tostring(pos.y))
        print("    " .. tostring(vinylplayer_player[i].pos.z) .. " " .. tostring(pos.z))

        if vinylplayer_player[i].pos.x == pos.x and 
	   vinylplayer_player[i].pos.y == pos.y and 
           vinylplayer_player[i].pos.z == pos.z then
                print("   return an exact and existing handle")
           	return vinylplayer_player[i].handle
        end
        i = i + 1
    end
    print("vinylplayer_get_handle: end")
    return 0
end


function vinylplayer_set_handle(pos, handle)
    print("vinylplayer_set_handle: begin")


    local i = 0
    while vinylplayer_player[i] ~= nil do
    
        local mypos = minetest.pos_to_string(vinylplayer_player[i].pos)
        print( "[ " .. tostring(i) .." ] at " .. mypos)

        print("    " .. tostring(vinylplayer_player[i].pos.x) .. " " .. tostring(pos.x))
        print("    " .. tostring(vinylplayer_player[i].pos.y) .. " " .. tostring(pos.y))
        print("    " .. tostring(vinylplayer_player[i].pos.z) .. " " .. tostring(pos.z))


        if vinylplayer_player[i].pos.x == pos.x and 
           vinylplayer_player[i].pos.y == pos.y and 
           vinylplayer_player[i].pos.z == pos.z then
                print("          pos is equal => set handle")
           	vinylplayer_player[i].handle = handle
           return
        end
        i = i + 1
    end
    vinylplayer_player[i] = {}
    vinylplayer_player[i].pos = pos

    print("handle: " .. dump(handle))

    vinylplayer_player[i].handle = handle
    print("          set handle")
    print("vinylplayer_set_handle: end")
end


-- Stop sound when node is dig
minetest.register_on_dignode(function(pos, oldnode, digger)
    if oldnode.name == "vinylplayer:player" then
        local mypos = minetest.pos_to_string(pos)
        print( "Destruct Node/block at ".. mypos)	
        
        print("vinylplayer_get_handle: begin")
        local i = 0
        while vinylplayer_player[i] ~= nil do
            local mypos = minetest.pos_to_string(vinylplayer_player[i].pos)
            print( "[ " .. tostring(i) .." ] at " .. mypos)

            print("    " .. tostring(vinylplayer_player[i].pos.x) .. " " .. tostring(pos.x))
            print("    " .. tostring(vinylplayer_player[i].pos.y) .. " " .. tostring(pos.y))
            print("    " .. tostring(vinylplayer_player[i].pos.z) .. " " .. tostring(pos.z))

            if vinylplayer_player[i].pos.x == pos.x and 
	           vinylplayer_player[i].pos.y == pos.y and 
               vinylplayer_player[i].pos.z == pos.z then
                print("   return an exact and existing handle")
                minetest.sound_stop(vinylplayer_player[i].handle)
           	    return vinylplayer_player[i].handle
            end
            i = i + 1
        end
        print("vinylplayer_get_handle: end")
    end
    return 0
end)


minetest.register_on_punchnode(function(pos, node, player, pointed_thing)
    if node.name == "vinylplayer:player" then
        
        local player_name = player:get_player_name()

        local mypos = minetest.pos_to_string(pos)

        if vinylplayer_get_handle(pos) == 0 then
            
            minetest.sound_stop(0) -- Fix: Force to stop the 1st sound node
            

            local handle = 0
            print( "Play sound Node/block at ".. mypos)	

            local meta = minetest.get_meta(pos)
            local vinyl_name = meta:get_string("a")
            print("vinyl name: " ..  vinyl_name)          

            handle = minetest.sound_play(vinyl_name, { 
            	pos = pos,
            	gain = 1.0,
            	max_hear_distance = 32,
		}) 

            vinylplayer_set_handle(pos, handle)

        else

            print( "Stop sound Node/block at ".. mypos)	
            minetest.sound_stop(vinylplayer_get_handle(pos))
            vinylplayer_set_handle(pos, 0)

        end
    end
end)





