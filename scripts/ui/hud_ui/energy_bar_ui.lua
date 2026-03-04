-- chunkname: @scripts/ui/hud_ui/energy_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/energy_bar_ui_definitions")

EnergyBarUI = class(EnergyBarUI)

EnergyBarUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()
end

EnergyBarUI._update_energy = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_1.player_unit

	if not Unit.alive(var_2_0) then
		return
	end

	local var_2_1 = ScriptUnit.has_extension(var_2_0, "energy_system")

	if not var_2_1 then
		return
	end

	local var_2_2 = var_2_1:get_fraction()

	if not (var_2_2 >= 1) then
		local var_2_3 = var_2_1:is_drainable()

		arg_2_0:_set_charge_bar_fraction(var_2_2, var_2_3)

		return true
	end

	return false
end

EnergyBarUI.create_ui_elements = function (arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_3_0.charge_bar = UIWidget.init(var_0_0.widget_definitions.charge_bar)
end

EnergyBarUI.update = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = arg_4_0:_update_energy(arg_4_3, arg_4_1)
	local var_4_1 = Managers.twitch:is_activated()

	if var_4_1 ~= arg_4_0._has_twitch then
		arg_4_0.charge_bar.offset[2] = var_4_1 and 140 or 0
		arg_4_0._has_twitch = var_4_1
		var_4_0 = true
	end

	if var_4_0 then
		local var_4_2 = arg_4_0.ui_scenegraph
		local var_4_3 = arg_4_0.input_manager:get_service("ingame_menu")
		local var_4_4, var_4_5 = arg_4_0._parent:get_crosshair_position()

		arg_4_0:_apply_crosshair_position(var_4_4, var_4_5)

		local var_4_6 = arg_4_0.ui_renderer

		UIRenderer.begin_pass(var_4_6, var_4_2, var_4_3, arg_4_1, nil, arg_4_0.render_settings)
		UIRenderer.draw_widget(var_4_6, arg_4_0.charge_bar)
		UIRenderer.end_pass(var_4_6)
	end
end

local var_0_1 = {
	normal = {
		255,
		0,
		255,
		255
	}
}

EnergyBarUI._set_charge_bar_fraction = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = arg_5_0.charge_bar
	local var_5_1 = var_5_0.style
	local var_5_2 = var_5_0.content

	arg_5_1 = math.lerp(var_5_2.internal_gradient_threshold or 1, math.min(arg_5_1, 1), 0.3)
	var_5_2.internal_gradient_threshold = arg_5_1
	var_5_1.bar_1.gradient_threshold = arg_5_1

	local var_5_3
	local var_5_4 = var_5_1.icon.color
	local var_5_5 = var_5_1.bar_1.color
	local var_5_6 = var_0_1.normal

	var_5_5[1] = var_5_6[1]
	var_5_5[2] = var_5_6[2]
	var_5_5[3] = var_5_6[3]
	var_5_5[4] = var_5_6[4]

	local var_5_7 = 10
	local var_5_8 = 0

	if not arg_5_2 then
		local var_5_9 = math.min(math.max(arg_5_1, 0.95) / 0.050000000000000044 * 1.3, 1)

		var_5_8 = (100 + (0.5 + math.sin(Managers.time:time("ui") * var_5_7) * 0.5) * 155) * var_5_9
	end

	var_5_1.frame.color[1] = var_5_8
	var_5_4[1] = 0
	var_5_4[2] = var_5_6[2]
	var_5_4[3] = var_5_6[3]
	var_5_4[4] = var_5_6[4]
end

EnergyBarUI.destroy = function (arg_6_0)
	return
end

EnergyBarUI.set_alpha = function (arg_7_0, arg_7_1)
	arg_7_0.render_settings.alpha_multiplier = arg_7_1
end

EnergyBarUI._apply_crosshair_position = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = "screen_bottom_pivot"
	local var_8_1 = arg_8_0.ui_scenegraph[var_8_0].local_position

	var_8_1[1] = arg_8_1
	var_8_1[2] = arg_8_2
end
