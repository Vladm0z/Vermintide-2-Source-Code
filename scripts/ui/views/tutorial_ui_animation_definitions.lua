-- chunkname: @scripts/ui/views/tutorial_ui_animation_definitions.lua

local var_0_0 = {
	{
		name = "entry",
		start_progress = 0,
		end_progress = 1,
		init = function(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
			local var_1_0 = arg_1_0[arg_1_3.start_id].position
			local var_1_1 = arg_1_0[arg_1_2.scenegraph_id].position

			var_1_1[1] = var_1_0[1]
			var_1_1[2] = var_1_0[2]

			local var_1_2 = arg_1_0[arg_1_3.start_id].size
			local var_1_3 = arg_1_0[arg_1_2.scenegraph_id].size

			var_1_3[1] = var_1_2[1]
			var_1_3[2] = var_1_2[2]

			local var_1_4 = arg_1_0[arg_1_2.style.icon_texture.scenegraph_id]

			var_1_4.position[2] = 0
			arg_1_2.content.icon_texture.fraction = 1
			var_1_4.size[1] = 0
			var_1_4.size[2] = 0
			arg_1_2.style.description_text.text_color[1] = 0

			for iter_1_0, iter_1_1 in pairs(arg_1_2.style) do
				if iter_1_1.color then
					iter_1_1.color[1] = iter_1_1.background_component and 0 or iter_1_1.default_alpha
				end
			end

			arg_1_2.element.dirty = true
		end,
		update = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
			local var_2_0

			var_2_0 = arg_2_3 == 1 and 1 or math.catmullrom(arg_2_3, 2, 0, 1, -1)

			local var_2_1 = math.smoothstep(arg_2_3, 0, 1)

			for iter_2_0, iter_2_1 in pairs(arg_2_2.style) do
				if iter_2_1.color and iter_2_1.background_component then
					iter_2_1.color[1] = iter_2_1.default_alpha * var_2_1
				end
			end

			arg_2_2.element.dirty = true
		end,
		on_complete = function(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			return
		end
	},
	{
		name = "fade_in_text_and_icon",
		start_progress = 1,
		end_progress = 2,
		init = function(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
			local var_4_0 = arg_4_0[arg_4_2.style.icon_texture.scenegraph_id]

			var_4_0.position[3] = var_4_0.position[3] + 10
			arg_4_2.element.dirty = true
		end,
		update = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			local var_5_0 = arg_5_3 == 1 and 1 or math.catmullrom(arg_5_3, -15, 0, 1, 1)
			local var_5_1 = math.smoothstep(arg_5_3, 0, 1)
			local var_5_2 = arg_5_0[arg_5_2.style.icon_texture.scenegraph_id]

			var_5_2.size[1] = 62 * var_5_0
			var_5_2.size[2] = 62 * var_5_0
			arg_5_2.style.description_text.text_color[1] = math.lerp(0, 255, var_5_1)

			local var_5_3 = math.clamp(math.catmullrom(arg_5_3, -8, 0.4, 0, -1), 0, 1)

			arg_5_2.style.frame_glow_top_texture.color[1] = var_5_3 * 255
			arg_5_2.style.frame_glow_bottom_texture.color[1] = var_5_3 * 255
			arg_5_2.element.dirty = true
		end,
		on_complete = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
			local var_6_0 = arg_6_0[arg_6_2.style.icon_texture.scenegraph_id]

			var_6_0.position[3] = var_6_0.position[3] - 10
		end
	}
}
local var_0_1 = {
	{
		name = "exit",
		start_progress = 0,
		end_progress = 1,
		init = function(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			return
		end,
		update = function(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
			local var_8_0 = math.smoothstep(arg_8_3, 1, 0)

			for iter_8_0, iter_8_1 in pairs(arg_8_2.style) do
				if iter_8_1.color then
					iter_8_1.color[1] = iter_8_1.default_alpha * var_8_0
				end
			end

			arg_8_2.style.description_text.text_color[1] = 255 * var_8_0
			arg_8_2.element.dirty = true
		end,
		on_complete = function(arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			local var_9_0 = math.random()
		end
	}
}
local var_0_2 = {
	{
		name = "flash",
		start_progress = 0,
		end_progress = 1,
		init = function(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			return
		end,
		update = function(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			local var_11_0 = math.clamp(math.catmullrom(arg_11_3, -8, 0.4, 0, -1), 0, 1)

			arg_11_2.style.frame_glow_top_texture.color[1] = var_11_0 * 255
			arg_11_2.style.frame_glow_bottom_texture.color[1] = var_11_0 * 255
			arg_11_2.element.dirty = true
		end,
		on_complete = function(arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			return
		end
	}
}
local var_0_3 = {
	{
		name = "move_up",
		start_progress = 0,
		end_progress = 2,
		init = function(arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			return
		end,
		update = function(arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			local var_14_0 = math.smoothstep(arg_14_3, 0, 1)
			local var_14_1 = arg_14_0[arg_14_4.start_id].position
			local var_14_2 = arg_14_0[arg_14_4.end_id].position

			arg_14_0[arg_14_2.scenegraph_id].position[2] = math.lerp(var_14_1[2], var_14_2[2], var_14_0)
			arg_14_2.element.dirty = true
		end,
		on_complete = function(arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			return
		end
	}
}
local var_0_4 = {
	{
		name = "wait",
		start_progress = 0,
		end_progress = 1,
		init = function(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			return
		end,
		update = function(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
			return
		end,
		on_complete = function(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			return
		end
	}
}
local var_0_5 = {
	{
		name = "move_up",
		start_progress = 0,
		end_progress = 2,
		init = function(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			return
		end,
		update = function(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
			local var_20_0 = math.smoothstep(arg_20_3, 0, 1)
			local var_20_1 = arg_20_0.info_slate_slot1_start.position
			local var_20_2 = arg_20_0.info_slate_mission_goal_end.position

			arg_20_0[arg_20_2.scenegraph_id].position[2] = math.lerp(var_20_1[2], var_20_2[2], var_20_0)

			local var_20_3 = arg_20_0.info_slate_slot1_start.size
			local var_20_4 = arg_20_0.info_slate_mission_goal_end.size
			local var_20_5 = arg_20_0[arg_20_2.scenegraph_id].size

			var_20_5[2] = math.lerp(var_20_3[2], var_20_4[2], var_20_0)

			local var_20_6 = (var_20_5[2] - 6) / var_20_3[2]
			local var_20_7 = arg_20_0[arg_20_2.style.icon_texture.scenegraph_id]

			var_20_7.size[2] = 62 * var_20_6
			var_20_7.position[2] = math.lerp(0, 15, var_20_0)
			arg_20_2.content.icon_texture.fraction = var_20_6
			arg_20_2.style.icon_texture.color[1] = math.lerp(255, 150, var_20_0)
			arg_20_2.element.dirty = true
		end,
		on_complete = function(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			return
		end
	}
}

return {
	info_slate_enter = var_0_0,
	info_slate_exit = var_0_1,
	info_slate_flash = var_0_2,
	info_slate_move_slot = var_0_3,
	mission_goal_wait = var_0_4,
	mission_goal_move_up = var_0_5
}
