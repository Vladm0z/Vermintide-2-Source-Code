-- chunkname: @scripts/settings/dlcs/bless/priest_resource_bar_ui.lua

local var_0_0 = local_require("scripts/settings/dlcs/bless/priest_resource_bar_ui_definition")

PriestResourceBarUI = class(PriestResourceBarUI)

local var_0_1 = {
	material = "overcharge_bar_warrior_priest",
	color = {
		255,
		144,
		54,
		36
	}
}
local var_0_2 = {
	detail_bar_passive_active = 0.2,
	glow_brightness_min = 0.1,
	detail_bar_passive_inactive = -0.4,
	glow_brightness_max = 0.8
}

function PriestResourceBarUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.platform = PLATFORM
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0._gui = arg_1_2.ui_renderer.gui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0._gui = arg_1_2.ui_renderer.gui

	arg_1_0:create_ui_elements()

	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._previous_overcharge_fraction = 0
	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil
	arg_1_0._value = 0.1
	arg_1_0._bar_feedback_state = "increase"
	arg_1_0._active_passive = false
	arg_1_0._animations = {}

	local var_1_0 = Managers.state.event

	var_1_0:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_1_0:register(arg_1_0, "glow_feedback", "glow_feedback")
	var_1_0:register(arg_1_0, "active_passive_feedback", "active_passive_feedback")
end

local function var_0_3(arg_2_0)
	local var_2_0 = ScriptUnit.extension(arg_2_0, "career_system"):get_passive_ability():get_resource_fraction()
	local var_2_1 = 0.8
	local var_2_2 = 0.5

	return var_2_0, var_2_1, 0.8, var_2_2
end

function PriestResourceBarUI.on_spectator_target_changed(arg_3_0, arg_3_1)
	arg_3_0._spectated_player_unit = arg_3_1
	arg_3_0._spectated_player = Managers.player:owner(arg_3_1)
	arg_3_0._is_spectator = true
end

function PriestResourceBarUI._set_player_extensions(arg_4_0, arg_4_1)
	arg_4_0.inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	arg_4_0.initialize_charge_bar = true
end

function PriestResourceBarUI._update_resource_bar(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 then
		return
	end

	local var_5_0 = arg_5_1.player_unit

	if not ALIVE[var_5_0] then
		return
	end

	local var_5_1 = ScriptUnit.extension(var_5_0, "career_system"):get_passive_ability()

	if not var_5_1 or not var_5_1.uses_resource then
		return
	end

	local var_5_2, var_5_3, var_5_4, var_5_5 = var_0_3(var_5_0)

	if var_5_2 > 0 then
		arg_5_0:set_charge_bar_fraction(arg_5_1, var_5_2, 0.3, var_5_4, var_5_5, arg_5_2)

		return true
	end
end

function PriestResourceBarUI.create_ui_elements(arg_6_0)
	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_renderer)

	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0 = var_0_0.inventory_entry_definitions

	arg_6_0.charge_bar = UIWidget.init(var_0_0.widget_definitions.charge_bar)
end

local var_0_4 = {
	root_scenegraph_id = "screen_bottom_pivot_parent",
	label = "Overcharge",
	registry_key = "overcharge",
	drag_scenegraph_id = "charge_bar"
}

function PriestResourceBarUI.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	local var_7_0 = arg_7_0.ui_renderer
	local var_7_1 = arg_7_0.ui_scenegraph
	local var_7_2 = arg_7_0.input_manager
	local var_7_3 = var_7_2:get_service("ingame_menu")
	local var_7_4 = var_7_2:is_device_active("gamepad")
	local var_7_5 = arg_7_0._is_spectator and arg_7_0._spectated_player or arg_7_3

	if HudCustomizer.run(var_7_0, var_7_1, var_0_4) then
		UISceneGraph.update_scenegraph(var_7_1)
	end

	local var_7_6 = arg_7_0:_update_resource_bar(var_7_5, arg_7_1)
	local var_7_7 = Managers.twitch:is_activated()

	if var_7_7 ~= arg_7_0._has_twitch then
		arg_7_0.charge_bar.offset[2] = var_7_7 and 140 or 0
		arg_7_0._has_twitch = var_7_7
		var_7_6 = true
	end

	for iter_7_0, iter_7_1 in pairs(arg_7_0._animations) do
		UIAnimation.update(iter_7_1, arg_7_1)

		if UIAnimation.completed(iter_7_1) then
			arg_7_0._animations[iter_7_0] = nil
		end
	end

	if var_7_6 then
		local var_7_8, var_7_9 = arg_7_0._parent:get_crosshair_position()

		arg_7_0:_apply_crosshair_position(var_7_8, var_7_9)
		UIRenderer.begin_pass(var_7_0, var_7_1, var_7_3, arg_7_1, nil, arg_7_0.render_settings)
		UIRenderer.draw_widget(var_7_0, arg_7_0.charge_bar)
		UIRenderer.end_pass(var_7_0)
	end
end

function PriestResourceBarUI.set_charge_bar_fraction(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6)
	local var_8_0 = arg_8_0.charge_bar
	local var_8_1 = var_8_0.style
	local var_8_2 = var_8_0.content
	local var_8_3 = var_8_2.size

	arg_8_2 = math.lerp(var_8_2.internal_gradient_threshold or 0, math.min(arg_8_2, 1), 0.3)
	var_8_2.internal_gradient_threshold = arg_8_2
	var_8_1.bar_1.gradient_threshold = arg_8_2

	local var_8_4 = var_8_1.bar_1.color
	local var_8_5 = var_0_1
	local var_8_6 = var_8_5.color

	var_8_2.bar_1 = var_8_5.material

	local var_8_7 = var_8_1.glow
	local var_8_8 = var_8_7.size

	var_8_7.offset[1] = var_8_3[1] * arg_8_2 - var_8_8[1] / 2 + 2

	arg_8_0:handle_glow_feedback(var_8_0, arg_8_6)

	var_8_1.bar_detail.gradient_threshold = arg_8_2

	local var_8_9 = var_8_0.content.bar_detail
	local var_8_10 = Gui.material(arg_8_0._gui, var_8_9)

	Material.set_scalar(var_8_10, "gradient_threshold", arg_8_2)

	if arg_8_0._active_passive then
		local var_8_11 = 0 + 0.5 * math.sin(2.5 * Managers.time:time("ui"))
		local var_8_12 = var_8_0.content.bar_active
		local var_8_13 = Gui.material(arg_8_0._gui, var_8_12)

		Material.set_scalar(var_8_13, "detail_offset", var_8_11)
		Material.set_scalar(var_8_13, "gradient_threshold", arg_8_2)

		var_8_7.size = {
			150,
			150
		}
		var_8_7.offset[2] = -75 + var_8_2.size[2] / 2

		arg_8_0:handle_active_passive_feedback(var_0_2.detail_bar_passive_active)
	else
		var_8_7.size = {
			75,
			75
		}
		var_8_7.offset[2] = -37.5 + var_8_2.size[2] / 2

		arg_8_0:handle_active_passive_feedback(var_0_2.detail_bar_passive_inactive)
	end

	var_8_4[2] = var_8_6[2]
	var_8_4[3] = var_8_6[3]
	var_8_4[4] = var_8_6[4]
end

function PriestResourceBarUI.destroy(arg_9_0)
	Managers.state.event:unregister("on_spectator_target_changed", arg_9_0)
	Managers.state.event:unregister("glow_feedback", arg_9_0)
	Managers.state.event:unregister("activate_passive_feedback", arg_9_0)
end

function PriestResourceBarUI.set_alpha(arg_10_0, arg_10_1)
	arg_10_0.render_settings.alpha_multiplier = arg_10_1
end

function PriestResourceBarUI._apply_crosshair_position(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = "screen_bottom_pivot"
	local var_11_1 = arg_11_0.ui_scenegraph[var_11_0].local_position

	var_11_1[1] = arg_11_1
	var_11_1[2] = arg_11_2
end

function PriestResourceBarUI.glow_feedback(arg_12_0)
	if not arg_12_0._play_glow_feedback then
		arg_12_0._play_glow_feedback = true
	end
end

function PriestResourceBarUI.handle_glow_feedback(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0._play_glow_feedback then
		return
	end

	local var_13_0 = var_0_2.glow_brightness_min
	local var_13_1 = var_0_2.glow_brightness_max
	local var_13_2 = arg_13_0._value

	if arg_13_0._bar_feedback_state == "increase" then
		var_13_2 = var_13_2 + 5 * arg_13_2

		if var_13_1 <= var_13_2 then
			arg_13_0._bar_feedback_state = "decrease"
		end
	elseif arg_13_0._bar_feedback_state == "decrease" then
		var_13_2 = var_13_2 - 2.5 * arg_13_2

		if var_13_2 <= var_13_0 then
			arg_13_0._bar_feedback_state = "done"
		end
	elseif arg_13_0._bar_feedback_state == "done" then
		arg_13_0._value = var_13_0
		arg_13_0._play_glow_feedback = false
		arg_13_0._bar_feedback_state = "increase"
	end

	arg_13_0._value = var_13_2

	local var_13_3 = arg_13_1.content.glow
	local var_13_4 = Gui.material(arg_13_0._gui, var_13_3)

	Material.set_scalar(var_13_4, "detail_offset", var_13_2)
end

function PriestResourceBarUI.active_passive_feedback(arg_14_0, arg_14_1)
	arg_14_0._active_passive = arg_14_1

	if arg_14_1 then
		arg_14_0._animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, arg_14_0.charge_bar.style.bar_active.color, 1, 0, 255, 0.3, math.ease_in_exp)
	else
		arg_14_0._animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, arg_14_0.charge_bar.style.bar_active.color, 1, 255, 0, 0.3, math.ease_in_exp)
	end
end

function PriestResourceBarUI.handle_active_passive_feedback(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.charge_bar.content.bar_detail
	local var_15_1 = Gui.material(arg_15_0._gui, var_15_0)

	Material.set_scalar(var_15_1, "detail_offset", arg_15_1)
end
