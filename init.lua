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
	groups = {cracky = 3},
	drop = "vinylplayer:player_fragments",
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local pos = pointed_thing
		if not pos then
			return itemstack
		end
		
		local playerName = player:get_player_name()
		minetest.chat_send_player(playerName, "on_rightclick: play sound")

		handle = minetest.sound_play("vinylplayer_keepyourweeds", {
		gain = 10.0,
		max_hear_distance = 32,
		})

        	return itemstack
	end,
})
