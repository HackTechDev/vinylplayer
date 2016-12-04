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

            handle = minetest.sound_play("vinylplayer_keepyourweeds", { 
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





