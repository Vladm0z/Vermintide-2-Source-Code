-- chunkname: @scripts/ui/views/tutorial_ui_animation_definitions.lua

local tbl = {
	{
		name = "entry",
		start_progress = 0,
		end_progress = 1,
		init = function (self, arg_1_1, arg_1_2, arg_1_3)
			-- function 1
			local position = self[arg_1_3.start_id].position
			local position_2 = self[arg_1_2.scenegraph_id].position

			position_2[1] = position[1]
			position_2[2] = position[2]

			local size = self[arg_1_3.start_id].size
			local size_2 = self[arg_1_2.scenegraph_id].size

			size_2[1] = size[1]
			size_2[2] = size[2]

			local var_1_4 = self[arg_1_2.style.icon_texture.scenegraph_id]

			var_1_4.position[2] = 0
			arg_1_2.content.icon_texture.fraction = 1
			var_1_4.size[1] = 0
			var_1_4.size[2] = 0
			arg_1_2.style.description_text.text_color[1] = 0

			for k, v in pairs(arg_1_2.style) do
				if not v.color then
					local color = v.color
					local flag

					flag = not v.background_component and 0 and v.default_alpha
					color[1] = flag
				end
			end

			arg_1_2.element.dirty = true
		end,
		update = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
			-- function 2
			local flag

			flag = arg_2_3 ~= 1 or not 1 or math.catmullrom(arg_2_3, 2, 0, 1, -1)

			local smoothstep = math.smoothstep(arg_2_3, 0, 1)

			for k, v in pairs(arg_2_2.style) do
				if not v.color and not v.background_component then
					v.color[1] = v.default_alpha * smoothstep
				end
			end

			arg_2_2.element.dirty = true
		end,
		on_complete = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
			-- function 3
			return
		end
	},
	{
		name = "fade_in_text_and_icon",
		start_progress = 1,
		end_progress = 2,
		init = function (self, arg_4_1, arg_4_2, arg_4_3)
			-- function 4
			local var_4_0 = self[arg_4_2.style.icon_texture.scenegraph_id]

			var_4_0.position[3] = var_4_0.position[3] + 10
			arg_4_2.element.dirty = true
		end,
		update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
			-- function 5
			local flag

			flag = arg_5_3 ~= 1 or not 1 or math.catmullrom(arg_5_3, -15, 0, 1, 1)

			local smoothstep = math.smoothstep(arg_5_3, 0, 1)
			local var_5_2 = self[arg_5_2.style.icon_texture.scenegraph_id]

			var_5_2.size[1] = 62 * flag
			var_5_2.size[2] = 62 * flag
			arg_5_2.style.description_text.text_color[1] = math.lerp(0, 255, smoothstep)

			local clamp = math.clamp(math.catmullrom(arg_5_3, -8, 0.4, 0, -1), 0, 1)

			arg_5_2.style.frame_glow_top_texture.color[1] = clamp * 255
			arg_5_2.style.frame_glow_bottom_texture.color[1] = clamp * 255
			arg_5_2.element.dirty = true
		end,
		on_complete = function (self, arg_6_1, arg_6_2, arg_6_3)
			-- function 6
			local var_6_0 = self[arg_6_2.style.icon_texture.scenegraph_id]

			var_6_0.position[3] = var_6_0.position[3] - 10
		end
	}
}
local tbl_2 = {
	{
		name = "exit",
		start_progress = 0,
		end_progress = 1,
		init = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
			-- function 7
			return
		end,
		update = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
			-- function 8
			local smoothstep = math.smoothstep(arg_8_3, 1, 0)

			for k, v in pairs(arg_8_2.style) do
				if not v.color then
					v.color[1] = v.default_alpha * smoothstep
				end
			end

			arg_8_2.style.description_text.text_color[1] = 255 * smoothstep
			arg_8_2.element.dirty = true
		end,
		on_complete = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
			-- function 9
			local random = math.random()
		end
	}
}
local tbl_3 = {
	{
		name = "flash",
		start_progress = 0,
		end_progress = 1,
		init = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
			-- function 10
			return
		end,
		update = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
			-- function 11
			local clamp = math.clamp(math.catmullrom(arg_11_3, -8, 0.4, 0, -1), 0, 1)

			arg_11_2.style.frame_glow_top_texture.color[1] = clamp * 255
			arg_11_2.style.frame_glow_bottom_texture.color[1] = clamp * 255
			arg_11_2.element.dirty = true
		end,
		on_complete = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
			-- function 12
			return
		end
	}
}
local tbl_4 = {
	{
		name = "move_up",
		start_progress = 0,
		end_progress = 2,
		init = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
			-- function 13
			return
		end,
		update = function (self, arg_14_1, arg_14_2, arg_14_3, arg_14_4)
			-- function 14
			local smoothstep = math.smoothstep(arg_14_3, 0, 1)
			local position = self[arg_14_4.start_id].position
			local position_2 = self[arg_14_4.end_id].position

			self[arg_14_2.scenegraph_id].position[2] = math.lerp(position[2], position_2[2], smoothstep)
			arg_14_2.element.dirty = true
		end,
		on_complete = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
			-- function 15
			return
		end
	}
}
local tbl_5 = {
	{
		name = "wait",
		start_progress = 0,
		end_progress = 1,
		init = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
			-- function 16
			return
		end,
		update = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
			-- function 17
			return
		end,
		on_complete = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
			-- function 18
			return
		end
	}
}
local tbl_6 = {
	{
		name = "move_up",
		start_progress = 0,
		end_progress = 2,
		init = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
			-- function 19
			return
		end,
		update = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
			-- function 20
			local smoothstep = math.smoothstep(arg_20_3, 0, 1)
			local position = self.info_slate_slot1_start.position
			local position_2 = self.info_slate_mission_goal_end.position

			self[arg_20_2.scenegraph_id].position[2] = math.lerp(position[2], position_2[2], smoothstep)

			local size = self.info_slate_slot1_start.size
			local size_2 = self.info_slate_mission_goal_end.size
			local size_3 = self[arg_20_2.scenegraph_id].size

			size_3[2] = math.lerp(size[2], size_2[2], smoothstep)

			local num = (size_3[2] - 6) / size[2]
			local var_20_7 = self[arg_20_2.style.icon_texture.scenegraph_id]

			var_20_7.size[2] = 62 * num
			var_20_7.position[2] = math.lerp(0, 15, smoothstep)
			arg_20_2.content.icon_texture.fraction = num
			arg_20_2.style.icon_texture.color[1] = math.lerp(255, 150, smoothstep)
			arg_20_2.element.dirty = true
		end,
		on_complete = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3)
			-- function 21
			return
		end
	}
}

return {
	info_slate_enter = tbl,
	info_slate_exit = tbl_2,
	info_slate_flash = tbl_3,
	info_slate_move_slot = tbl_4,
	mission_goal_wait = tbl_5,
	mission_goal_move_up = tbl_6
}
