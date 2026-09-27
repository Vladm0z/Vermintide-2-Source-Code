-- chunkname: @scripts/ui/hud_ui/hud_customizer.lua

HudCustomizer = {}

local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("black", 100)
local get_color_table_with_alpha_3 = Colors.get_color_table_with_alpha("light_sky_blue", 200)
local get_color_table_with_alpha_4 = Colors.get_color_table_with_alpha("silver", 230)
local get_color_table_with_alpha_5 = Colors.get_color_table_with_alpha("cheeseburger", 230)
local flag = false
local flag_2 = false
local tbl = {
	0,
	0
}
local tbl_2 = {}

HudCustomizer.offset_registry = tbl_2

local user_setting = Application.user_setting("hud_customizer_enabled")

HudCustomizer.is_active = function ()
	-- function 1
	local var_1_0 = user_setting

	if not var_1_0 then
		var_1_0 = Managers.chat.chat_gui.chat_focused
		var_1_0 = not var_1_0 and Keyboard.button(Keyboard.button_id("left alt")) > 0.5
	end

	return var_1_0
end

HudCustomizer.reset_button = function (arg_2_0)
	-- function 2
	if not HudCustomizer.is_active() then
		return
	end
end

HudCustomizer.run = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	if not HudCustomizer.is_active() then
		return
	end

	flag_2 = false

	local flag_3 = false
	local registry_key = arg_3_2.registry_key

	registry_key = registry_key or arg_3_2

	local var_3_2 = tbl_2[registry_key]

	if not var_3_2 then
		var_3_2 = {
			0,
			0
		}
		tbl_2[registry_key] = var_3_2
		flag_3 = true
	end

	if not arg_3_2.is_child then
		local var_3_3 = arg_3_1[arg_3_2.drag_scenegraph_id]

		if not var_3_3 then
			return
		end

		local var_3_4 = Vector3(var_3_3.world_position[1], var_3_3.world_position[2], 999)
		local size = var_3_3.size
		local var_3_6 = UIInverseScaleVectorToResolution(Mouse.axis(Mouse.axis_id("cursor")))
		local point_is_inside_2d_box = math.point_is_inside_2d_box(var_3_6, var_3_4, size)

		if flag == arg_3_2 then
			Debug.text("Customizing HUD component %q", arg_3_2.label)
			Debug.text("[%s] = Vector2(%6.2f, %6.2f), ", arg_3_2.root_scenegraph_id, var_3_2[1], var_3_2[2])

			if not arg_3_2.lock_x then
				var_3_2[1] = var_3_6[1] - tbl[1]
			end

			if not arg_3_2.lock_y then
				var_3_2[2] = var_3_6[2] - tbl[2]
			end

			if not Mouse.released(Mouse.button_id("left")) then
				flag = false
			end
		elseif flag or flag_2 or arg_3_2.is_child or not point_is_inside_2d_box then
			flag_2 = arg_3_2

			if not Mouse.pressed(Mouse.button_id("left")) then
				flag = arg_3_2
				tbl[1] = var_3_6[1] - var_3_2[1]
				tbl[2] = var_3_6[2] - var_3_2[2]
			end
		end

		local var_3_8 = get_color_table_with_alpha_3

		if flag == arg_3_2 then
			var_3_8 = get_color_table_with_alpha_5
		elseif flag_2 == arg_3_2 then
			var_3_8 = get_color_table_with_alpha_4
			var_3_8[1] = 200 + 55 * math.sin(5 * Managers.time:time("ui"))
		end

		local border = arg_3_2.border

		border = border or 3

		local var_3_10 = Vector2(size[1], border)
		local var_3_11 = Vector2(border, size[2] - 2 * border)
		local var_3_12 = Vector2(size[1], size[2])

		UIRenderer.draw_rect(arg_3_0, var_3_4, var_3_12, get_color_table_with_alpha_2)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(0, size[2] - border), var_3_10, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4, var_3_10, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(0, border), var_3_11, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(size[1] - border, border), var_3_11, var_3_8)

		local text_alignment_size, var_3_14 = UIRenderer.text_alignment_size(arg_3_0, arg_3_2.label, "materials/fonts/arial", 18)
		local num = var_3_4 + 0.5 * Vector2(size[1] - text_alignment_size, size[2] - var_3_14)

		UIRenderer.draw_text(arg_3_0, arg_3_2.label, "materials/fonts/arial", 18, nil, num, get_color_table_with_alpha)
	end

	local var_3_16 = arg_3_1[arg_3_2.root_scenegraph_id]

	flag_3 = flag_3 or var_3_16.local_position[1] ~= var_3_2[1] or var_3_16.local_position[2] ~= var_3_2[2]

	if not flag_3 then
		var_3_16.local_position[1] = var_3_2[1]
		var_3_16.local_position[2] = var_3_2[2]
	end

	return flag_3
end

HudCustomizer.debug_temp = function (self, arg_4_1)
	-- function 4
	local local_position = self[arg_4_1].local_position
	local world_position = self[arg_4_1].world_position

	Debug.text("%s|local=V3(%.1f, %.1f, %.1f), world=V3(%.1f, %.1f, %.1f)", arg_4_1, local_position[1], local_position[2], local_position[3], world_position[1], world_position[2], world_position[3])
end

if not IS_WINDOWS then
	HudCustomizer.reset_button = NOP
	HudCustomizer.run = NOP
end
