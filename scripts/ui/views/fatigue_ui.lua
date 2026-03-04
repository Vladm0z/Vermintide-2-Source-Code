-- chunkname: @scripts/ui/views/fatigue_ui.lua

local var_0_0 = local_require("scripts/ui/views/fatigue_ui_definitions")

FatigueUI = class(FatigueUI)

FatigueUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.local_player = arg_1_2.player_manager:local_player()

	arg_1_0:create_ui_elements()
end

FatigueUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}

	for iter_2_0 = 1, UISettings.max_fatigue_shields do
		var_2_0[iter_2_0] = UIWidget.init(var_0_0.shield_definition)
	end

	arg_2_0.active_shields = 0
	arg_2_0.shields = var_2_0
end

FatigueUI.destroy = function (arg_3_0)
	return
end

FatigueUI.shield_state = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = arg_4_2 - arg_4_1

	if var_4_0 >= 0 then
		return "state_1"
	elseif var_4_0 == -0.5 then
		return "state_2"
	else
		return "state_3"
	end
end

FatigueUI.setup_hud = function (arg_5_0, arg_5_1)
	local var_5_0, var_5_1 = arg_5_1:current_fatigue_points()
	local var_5_2 = math.clamp(var_5_0, 0, UISettings.max_fatigue_shields * 2)
	local var_5_3 = math.clamp(var_5_1, 0, UISettings.max_fatigue_shields * 2)
	local var_5_4 = math.floor(var_5_3 / 2 + 0.5)
	local var_5_5 = 30
	local var_5_6 = var_5_5 * (var_5_4 - 1) / 2
	local var_5_7 = var_5_3 * 0.5 - var_5_2 * 0.5
	local var_5_8 = arg_5_0.shields

	for iter_5_0 = 1, var_5_4 do
		local var_5_9 = var_5_8[iter_5_0]
		local var_5_10 = var_5_9.style
		local var_5_11 = var_5_6 - var_5_5 * (iter_5_0 - 1)

		var_5_10.offset[1] = var_5_11
		var_5_10.texture_glow_id.offset[1] = var_5_11
		var_5_9.state = arg_5_0:shield_state(iter_5_0, var_5_7)
		var_5_9.content.texture_id = var_5_10.state_textures[var_5_9.state]

		if arg_5_0.active then
			var_5_10.color[1] = 255
			var_5_10.texture_glow_id.color[1] = 255
		end
	end

	arg_5_0.active_shields = var_5_4
	arg_5_0.current_fatigue = var_5_2
	arg_5_0.max_fatigue_points = var_5_3
end

FatigueUI.start_fade_in = function (arg_6_0)
	local var_6_0 = arg_6_0.active_shields
	local var_6_1 = arg_6_0.shields

	for iter_6_0 = 1, var_6_0 do
		local var_6_2 = var_6_1[iter_6_0]
		local var_6_3 = var_6_2.style
		local var_6_4 = 0
		local var_6_5 = 255

		UIWidget.stop_animations(var_6_2)
		UIWidget.animate(var_6_2, UIAnimation.init(UIAnimation.function_by_time, var_6_3.color, 1, var_6_4, var_6_5, 0.2, math.easeInCubic))
		UIWidget.animate(var_6_2, UIAnimation.init(UIAnimation.function_by_time, var_6_3.texture_glow_id.color, 1, var_6_4, var_6_5, 0.2, math.easeInCubic))
	end
end

FatigueUI.start_fade_out = function (arg_7_0)
	local var_7_0 = arg_7_0.active_shields
	local var_7_1 = arg_7_0.shields

	for iter_7_0 = 1, var_7_0 do
		local var_7_2 = var_7_1[iter_7_0]
		local var_7_3 = var_7_2.style
		local var_7_4 = var_7_3.color[1]
		local var_7_5 = 0

		UIWidget.stop_animations(var_7_2)
		UIWidget.animate(var_7_2, UIAnimation.init(UIAnimation.function_by_time, var_7_3.color, 1, var_7_4, var_7_5, 0.2, math.easeInCubic))
		UIWidget.animate(var_7_2, UIAnimation.init(UIAnimation.function_by_time, var_7_3.texture_glow_id.color, 1, var_7_4, var_7_5, 0.2, math.easeInCubic))
	end
end

local var_0_1 = {
	root_scenegraph_id = "background",
	label = "Stamina",
	registry_key = "fatigue",
	drag_scenegraph_id = "background_dragger"
}

FatigueUI.update = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.local_player.player_unit

	if not Unit.alive(var_8_0) then
		return
	end

	HudCustomizer.run(arg_8_0.ui_renderer, arg_8_0.ui_scenegraph, var_0_1)

	local var_8_1 = ScriptUnit.extension(var_8_0, "status_system")
	local var_8_2 = arg_8_0:check_active(var_8_1)

	if not arg_8_0.active and var_8_2 then
		arg_8_0.active = true

		arg_8_0:setup_hud(var_8_1)
		arg_8_0:start_fade_in()
	elseif arg_8_0.active then
		local var_8_3, var_8_4 = var_8_1:current_fatigue_points()

		if var_8_3 / var_8_4 < 0.6 and not var_8_2 then
			arg_8_0.active = false

			arg_8_0:start_fade_out()
		end
	end

	if arg_8_0.active then
		arg_8_0:update_shields(var_8_1, arg_8_1)
	end

	local var_8_5 = arg_8_0.active_shields
	local var_8_6 = arg_8_0.shields

	for iter_8_0 = 1, var_8_5 do
		local var_8_7 = var_8_6[iter_8_0]
		local var_8_8 = var_8_7.style

		if var_8_1.has_bonus_fatigue_active then
			var_8_7.content.show_glow = false
		else
			var_8_7.content.show_glow = false
		end
	end

	arg_8_0:draw(arg_8_1)
end

FatigueUI.check_active = function (arg_9_0, arg_9_1)
	return arg_9_1:is_blocking() or arg_9_1.show_fatigue_gui
end

FatigueUI.update_shields = function (arg_10_0, arg_10_1, arg_10_2)
	local var_10_0 = arg_10_0.current_fatigue
	local var_10_1, var_10_2 = arg_10_1:current_fatigue_points()

	if var_10_2 ~= arg_10_0.max_fatigue_points then
		arg_10_0:setup_hud(arg_10_1)
	end

	if var_10_1 == var_10_0 then
		return
	end

	local var_10_3 = var_10_2 * 0.5 - var_10_1 * 0.5
	local var_10_4 = arg_10_0.active_shields
	local var_10_5 = arg_10_0.shields

	for iter_10_0 = 1, var_10_4 do
		local var_10_6 = var_10_5[iter_10_0]
		local var_10_7 = var_10_6.style
		local var_10_8 = var_10_6.state
		local var_10_9 = arg_10_0:shield_state(iter_10_0, var_10_3)

		if var_10_8 ~= var_10_9 then
			local var_10_10 = var_10_7.state_animations[var_10_8]

			if var_10_10 and var_10_10[var_10_9] then
				local var_10_11 = var_10_10[var_10_9]

				UIWidget.animate(var_10_6, UIAnimation.init(UIAnimation.picture_sequence, var_10_6.content, "texture_id", var_10_11.pictures, var_10_11.time))
			else
				var_10_6.content.texture_id = var_10_7.state_textures[var_10_9]
			end
		end

		var_10_6.state = var_10_9
	end

	arg_10_0.current_fatigue = var_10_1
end

FatigueUI.draw = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_renderer
	local var_11_1 = arg_11_0.ui_scenegraph
	local var_11_2 = arg_11_0.input_manager:get_service("ingame_menu")

	UIRenderer.begin_pass(var_11_0, var_11_1, var_11_2, arg_11_1)

	local var_11_3 = arg_11_0.shields
	local var_11_4 = arg_11_0.active_shields

	for iter_11_0 = 1, var_11_4 do
		local var_11_5 = var_11_3[iter_11_0]

		UIRenderer.draw_widget(var_11_0, var_11_5)
	end

	UIRenderer.end_pass(var_11_0)
end
