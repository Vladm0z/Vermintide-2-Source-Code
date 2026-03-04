-- chunkname: @scripts/ui/hud_ui/hud_customizer.lua

HudCustomizer = {}

local var_0_0 = Colors.get_color_table_with_alpha("white", 255)
local var_0_1 = Colors.get_color_table_with_alpha("black", 100)
local var_0_2 = Colors.get_color_table_with_alpha("light_sky_blue", 200)
local var_0_3 = Colors.get_color_table_with_alpha("silver", 230)
local var_0_4 = Colors.get_color_table_with_alpha("cheeseburger", 230)
local var_0_5 = false
local var_0_6 = false
local var_0_7 = {
	0,
	0
}
local var_0_8 = {}

HudCustomizer.offset_registry = var_0_8

local var_0_9 = Application.user_setting("hud_customizer_enabled")

HudCustomizer.is_active = function ()
	return var_0_9 and Managers.chat.chat_gui.chat_focused and Keyboard.button(Keyboard.button_id("left alt")) > 0.5
end

HudCustomizer.reset_button = function (arg_2_0)
	if not HudCustomizer.is_active() then
		return
	end
end

HudCustomizer.run = function (arg_3_0, arg_3_1, arg_3_2)
	if not HudCustomizer.is_active() then
		return
	end

	var_0_6 = false

	local var_3_0 = false
	local var_3_1 = arg_3_2.registry_key or arg_3_2
	local var_3_2 = var_0_8[var_3_1]

	if not var_3_2 then
		var_3_2 = {
			0,
			0
		}
		var_0_8[var_3_1] = var_3_2
		var_3_0 = true
	end

	if not arg_3_2.is_child then
		local var_3_3 = arg_3_1[arg_3_2.drag_scenegraph_id]

		if not var_3_3 then
			return
		end

		local var_3_4 = Vector3(var_3_3.world_position[1], var_3_3.world_position[2], 999)
		local var_3_5 = var_3_3.size
		local var_3_6 = UIInverseScaleVectorToResolution(Mouse.axis(Mouse.axis_id("cursor")))
		local var_3_7 = math.point_is_inside_2d_box(var_3_6, var_3_4, var_3_5)

		if var_0_5 == arg_3_2 then
			Debug.text("Customizing HUD component %q", arg_3_2.label)
			Debug.text("[%s] = Vector2(%6.2f, %6.2f), ", arg_3_2.root_scenegraph_id, var_3_2[1], var_3_2[2])

			if not arg_3_2.lock_x then
				var_3_2[1] = var_3_6[1] - var_0_7[1]
			end

			if not arg_3_2.lock_y then
				var_3_2[2] = var_3_6[2] - var_0_7[2]
			end

			if Mouse.released(Mouse.button_id("left")) then
				var_0_5 = false
			end
		elseif not var_0_5 and not var_0_6 and not arg_3_2.is_child and var_3_7 then
			var_0_6 = arg_3_2

			if Mouse.pressed(Mouse.button_id("left")) then
				var_0_5 = arg_3_2
				var_0_7[1] = var_3_6[1] - var_3_2[1]
				var_0_7[2] = var_3_6[2] - var_3_2[2]
			end
		end

		local var_3_8 = var_0_2

		if var_0_5 == arg_3_2 then
			var_3_8 = var_0_4
		elseif var_0_6 == arg_3_2 then
			var_3_8 = var_0_3
			var_3_8[1] = 200 + 55 * math.sin(5 * Managers.time:time("ui"))
		end

		local var_3_9 = arg_3_2.border or 3
		local var_3_10 = Vector2(var_3_5[1], var_3_9)
		local var_3_11 = Vector2(var_3_9, var_3_5[2] - 2 * var_3_9)
		local var_3_12 = Vector2(var_3_5[1], var_3_5[2])

		UIRenderer.draw_rect(arg_3_0, var_3_4, var_3_12, var_0_1)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(0, var_3_5[2] - var_3_9), var_3_10, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4, var_3_10, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(0, var_3_9), var_3_11, var_3_8)
		UIRenderer.draw_rect(arg_3_0, var_3_4 + Vector2(var_3_5[1] - var_3_9, var_3_9), var_3_11, var_3_8)

		local var_3_13, var_3_14 = UIRenderer.text_alignment_size(arg_3_0, arg_3_2.label, "materials/fonts/arial", 18)
		local var_3_15 = var_3_4 + 0.5 * Vector2(var_3_5[1] - var_3_13, var_3_5[2] - var_3_14)

		UIRenderer.draw_text(arg_3_0, arg_3_2.label, "materials/fonts/arial", 18, nil, var_3_15, var_0_0)
	end

	local var_3_16 = arg_3_1[arg_3_2.root_scenegraph_id]

	var_3_0 = var_3_0 or var_3_16.local_position[1] ~= var_3_2[1] or var_3_16.local_position[2] ~= var_3_2[2]

	if var_3_0 then
		var_3_16.local_position[1] = var_3_2[1]
		var_3_16.local_position[2] = var_3_2[2]
	end

	return var_3_0
end

HudCustomizer.debug_temp = function (arg_4_0, arg_4_1)
	local var_4_0 = arg_4_0[arg_4_1].local_position
	local var_4_1 = arg_4_0[arg_4_1].world_position

	Debug.text("%s|local=V3(%.1f, %.1f, %.1f), world=V3(%.1f, %.1f, %.1f)", arg_4_1, var_4_0[1], var_4_0[2], var_4_0[3], var_4_1[1], var_4_1[2], var_4_1[3])
end

if not IS_WINDOWS then
	HudCustomizer.reset_button = NOP
	HudCustomizer.run = NOP
end
