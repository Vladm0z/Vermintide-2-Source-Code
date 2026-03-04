-- chunkname: @scripts/ui/hud_ui/boss_health_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/boss_health_ui_definitions")
local var_0_1 = 0.5
local var_0_2 = 2
local var_0_3 = UISettings.breed_textures
local var_0_4 = {
	sync = 0,
	lord = 2,
	proximity = 1,
	ping = 4,
	damage_taken = 3,
	damage_done = 4,
	forced = 5
}
local var_0_5 = table.set({
	"damage_taken",
	"damage_done",
	"ping"
})
local var_0_6 = {
	"rpc_add_forced_boss_health_ui",
	"rpc_register_detected_boss"
}

BossHealthUI = class(BossHealthUI)
BossHealthUI.MAX_NUM_FORCED_WIDGETS = 2
BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS = 4

BossHealthUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.world = arg_1_2.world_manager:world("level_world")
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}

	arg_1_0:create_ui_elements()

	arg_1_0._animations = {}
	arg_1_0._forced_animations = {}
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._name_pools = {}
	arg_1_0._cached_pool_name_by_unit = {}
	arg_1_0._detected_boss_units = {}

	local var_1_0 = Managers.state.event

	var_1_0:register(arg_1_0, "boss_health_bar_register_unit", "_event_register_boss_unit")
	var_1_0:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_1_0:register(arg_1_0, "force_add_boss_health_ui", "on_force_add_boss_health_ui")

	arg_1_0._proximity_update_time = 0
	arg_1_0._look_at_boss_unit_timer = 0
	arg_1_0._network_event_delegate = arg_1_2.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_6))
end

BossHealthUI.destroy = function (arg_2_0)
	GarbageLeakDetector.register_object(arg_2_0, "boss_health_ui")

	local var_2_0 = Managers.state.event

	var_2_0:unregister("on_spectator_target_changed", arg_2_0)
	var_2_0:unregister("boss_health_bar_register_unit", arg_2_0)
	var_2_0:unregister("force_add_boss_health_ui", arg_2_0)
	arg_2_0._network_event_delegate:unregister(arg_2_0)
end

BossHealthUI.create_ui_elements = function (arg_3_0)
	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_3_0._forced_widget_names = {}
	arg_3_0._additional_widget_names = {}

	local var_3_0 = {}
	local var_3_1 = {}
	local var_3_2 = var_0_0.widget_create_func()
	local var_3_3 = UIWidget.init(var_3_2)

	var_3_0[#var_3_0 + 1] = var_3_3
	var_3_1.prioritized_bar = var_3_3
	arg_3_0._widgets = var_3_0
	arg_3_0._widgets_by_name = var_3_1

	arg_3_0:_preemptively_hide_widgets()

	if Managers.state.game_mode:game_mode_key() == "versus" then
		arg_3_0.ui_scenegraph.pivot.position[2] = -150
	end
end

BossHealthUI._get_or_create_forced_widget_name = function (arg_4_0, arg_4_1)
	if arg_4_1 > BossHealthUI.MAX_NUM_FORCED_WIDGETS then
		return nil
	end

	local var_4_0 = arg_4_0._forced_widget_names
	local var_4_1 = var_4_0[arg_4_1]

	if not var_4_1 then
		var_4_1 = "forced_widget_" .. arg_4_1
		var_4_0[arg_4_1] = var_4_1
	end

	local var_4_2 = arg_4_0._widgets_by_name

	if not var_4_2[var_4_1] then
		local var_4_3 = arg_4_0._widgets
		local var_4_4 = var_0_0.widget_create_func()
		local var_4_5 = UIWidget.init(var_4_4)

		var_4_3[#var_4_3 + 1] = var_4_5
		var_4_2[var_4_1] = var_4_5
	end

	return var_4_1
end

BossHealthUI._get_or_create_additional_widget_name = function (arg_5_0, arg_5_1)
	if arg_5_1 > BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS then
		return nil
	end

	local var_5_0 = arg_5_0._additional_widget_names
	local var_5_1 = var_5_0[arg_5_1]

	if not var_5_1 then
		var_5_1 = "additional_widget_" .. arg_5_1
		var_5_0[arg_5_1] = var_5_1
	end

	local var_5_2 = arg_5_0._widgets_by_name

	if not var_5_2[var_5_1] then
		local var_5_3 = arg_5_0._widgets
		local var_5_4 = var_0_0.widget_create_func(true)
		local var_5_5 = UIWidget.init(var_5_4)

		var_5_3[#var_5_3 + 1] = var_5_5
		var_5_2[var_5_1] = var_5_5
	end

	return var_5_1
end

BossHealthUI._set_portrait_and_title = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	local var_6_0 = arg_6_1.breed_name
	local var_6_1 = var_0_3[var_6_0] or "icons_placeholder"
	local var_6_2 = arg_6_0._widgets_by_name[arg_6_1.widget_name]

	if var_6_2 then
		local var_6_3 = var_6_2.content.title_cached
		local var_6_4 = var_6_2.content.marked_cached

		if arg_6_1.dirty or var_6_3 ~= arg_6_3 or var_6_4 ~= arg_6_2 then
			var_6_2.content.title_cached, var_6_2.content.marked_cached = arg_6_3, arg_6_2

			if arg_6_2 then
				var_6_2.content.title_text = "{#grad(true);color(255,125,80,255);color2(234,77,29,255)}" .. Utf8.upper(arg_6_3)
			else
				var_6_2.content.title_text = Utf8.upper(Localize(arg_6_3))
			end
		end

		var_6_2.content.portrait = var_6_1
	end
end

local var_0_7 = {
	font_size = 16,
	upper_case = true,
	font_type = "hell_shark",
	divider_icon_width = 22
}
local var_0_8 = {
	upper_case = true,
	divider_icon_width = 22,
	font_size = 20,
	font_type = "hell_shark",
	fallback_style = var_0_7
}

BossHealthUI._generate_attributes = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
	local var_7_0 = arg_7_3.font_size
	local var_7_1 = arg_7_2.content
	local var_7_2 = 0
	local var_7_3 = (var_7_1.attribute_offset_reference or 0) + 4
	local var_7_4 = var_7_3
	local var_7_5 = -40
	local var_7_6 = 24
	local var_7_7 = (var_7_6 - arg_7_3.divider_icon_width) / 2

	for iter_7_0 in pairs(arg_7_1) do
		if iter_7_0 then
			var_7_2 = var_7_2 + 1
			var_7_1.attributes[var_7_2] = true
			var_7_1.num_attributes = var_7_2

			local var_7_8 = "attribute_text_" .. var_7_2
			local var_7_9 = arg_7_2.style[var_7_8]

			if var_7_9 then
				local var_7_10 = BreedEnhancements[iter_7_0]
				local var_7_11 = var_7_1.skull_dividers[var_7_2]

				if var_7_11 then
					local var_7_12 = arg_7_2.style[var_7_11]

					var_7_12.offset[1] = var_7_4 + var_7_7
					var_7_12.offset[2] = var_7_5 - 13
					var_7_4 = var_7_4 + var_7_6
				end

				local var_7_13 = "{#grad(true);color(242,226,187,255);color2(255,125,80,255)}" .. Utf8.upper(Localize(var_7_10.display_name or "missing_grudge_mark_name"))
				local var_7_14 = UIUtils.get_text_width(arg_7_0.ui_renderer, arg_7_3, var_7_13)

				var_7_1[var_7_8] = var_7_13
				var_7_9.offset[1] = var_7_4
				var_7_9.font_size = var_7_0
				var_7_9.text_color = var_7_10.text_color
				var_7_4 = var_7_4 + var_7_14

				if var_7_2 % 3 == 0 then
					var_7_4 = var_7_3
					var_7_5 = var_7_5 - 16
				end
			end
		end
	end

	local var_7_15 = arg_7_2.style.lower_marked_bg

	if var_7_15 then
		if var_7_2 <= 4 then
			var_7_15.offset[2] = -83 + arg_7_3.font_size - 4
		else
			var_7_15.offset[2] = -83
		end
	end

	return true
end

BossHealthUI._update_enemy_portrait_name_and_attributes = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.unit
	local var_8_1 = Managers.state.entity:system("ai_system"):get_attributes(var_8_0)
	local var_8_2 = var_8_1.grudge_marked

	if not arg_8_1.dirty and arg_8_1.cached_name then
		return arg_8_1.cached_name, var_8_2
	end

	local var_8_3 = arg_8_1.breed_name
	local var_8_4
	local var_8_5 = arg_8_0._widgets_by_name[arg_8_1.widget_name]

	if var_8_5 then
		table.clear(var_8_5.content.attributes)
	end

	local var_8_6 = Managers.level_transition_handler:get_current_level_key()
	local var_8_7 = Breeds[var_8_3] or PlayerBreeds[var_8_3]
	local var_8_8 = var_8_7 and var_8_7.name_pool_by_level and var_8_7.name_pool_by_level[var_8_6]

	if var_8_2 then
		local var_8_9 = var_8_2.name_index

		var_8_4 = TerrorEventUtils.get_grudge_marked_name(var_8_3, var_8_9, var_8_1.breed_enhancements)
	elseif var_8_8 then
		if arg_8_0._cached_pool_name_by_unit[var_8_0] then
			var_8_4 = arg_8_0._cached_pool_name_by_unit[var_8_0]
		else
			local var_8_10 = string.format("%s_%s", var_8_6, var_8_3)
			local var_8_11 = arg_8_0._name_pools[var_8_10] or {}

			arg_8_0._name_pools[var_8_10] = var_8_11

			if table.is_empty(var_8_11) then
				table.append(var_8_11, var_8_8)
			end

			local var_8_12 = Managers.state.unit_storage:go_id(arg_8_1.unit) or 0
			local var_8_13, var_8_14 = Math.next_random(var_8_12, 1, #var_8_11)

			var_8_4 = table.remove(var_8_11, var_8_14)
			arg_8_0._cached_pool_name_by_unit[var_8_0] = var_8_4
		end
	else
		var_8_4 = var_8_7.display_name or var_8_3
	end

	if var_8_2 and var_8_5 then
		local var_8_15 = 430

		if var_8_1.breed_enhancements then
			local var_8_16, var_8_17 = arg_8_0:_generate_attributes(var_8_1.breed_enhancements, var_8_5, var_0_8, var_8_15, var_8_4)

			while not var_8_16 do
				var_8_16, var_8_17 = arg_8_0:_generate_attributes(var_8_1.breed_enhancements, var_8_5, var_8_17, var_8_15, var_8_4)
			end
		end
	end

	arg_8_1.cached_name = var_8_4

	return var_8_4, var_8_2
end

local var_0_9 = {
	root_scenegraph_id = "pivot",
	label = "Boss health",
	registry_key = "boss_health",
	drag_scenegraph_id = "pivot_dragger"
}

BossHealthUI.update = function (arg_9_0, arg_9_1, arg_9_2)
	if HudCustomizer.run(arg_9_0.ui_renderer, arg_9_0.ui_scenegraph, var_0_9) then
		UISceneGraph.update_scenegraph(arg_9_0.ui_scenegraph)
	end

	arg_9_0:_update_proximity_boss()
	arg_9_0:_sync_boss_unit_health(arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1, arg_9_2)

	if not script_data.hide_boss_health_ui then
		arg_9_0:_draw(arg_9_1, arg_9_2)
	end
end

BossHealthUI._update_proximity_boss = function (arg_10_0)
	local var_10_0 = Managers.state.entity:system("proximity_system").closest_boss_unit

	arg_10_0:_event_register_boss_unit(var_10_0, "proximity")
end

BossHealthUI._update_name = function (arg_11_0, arg_11_1)
	local var_11_0, var_11_1 = arg_11_0:_update_enemy_portrait_name_and_attributes(arg_11_1)
	local var_11_2 = Breeds[arg_11_1.breed_name]

	if var_11_2 and var_11_2.custom_health_bar_name then
		local var_11_3 = var_11_2.custom_health_bar_name(arg_11_1.unit, var_11_0)

		if var_11_3 then
			var_11_0 = var_11_3
			var_11_1 = true
		end
	end

	arg_11_0:_set_portrait_and_title(arg_11_1, var_11_1, var_11_0)
end

BossHealthUI._is_forced = function (arg_12_0, arg_12_1)
	for iter_12_0, iter_12_1 in ipairs(arg_12_0._detected_boss_units) do
		if iter_12_1.unit == arg_12_1 and iter_12_1.forced then
			return true
		end
	end
end

BossHealthUI._has_forced = function (arg_13_0)
	return table.find_func(arg_13_0._detected_boss_units, function (arg_14_0, arg_14_1)
		return arg_14_1.forced
	end)
end

local var_0_10 = {}

BossHealthUI._num_healthbars = function (arg_15_0)
	local var_15_0, var_15_1 = table.filter_array(arg_15_0._detected_boss_units, function (arg_16_0)
		return arg_16_0.show_health_bar
	end, var_0_10)

	return var_15_1
end

BossHealthUI._update_animations = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._animations

	for iter_17_0, iter_17_1 in pairs(var_17_0) do
		if not UIAnimation.completed(iter_17_1) then
			UIAnimation.update(iter_17_1, arg_17_1)
		else
			var_17_0[iter_17_0] = nil
		end
	end

	local var_17_1 = arg_17_0._forced_animations

	for iter_17_2, iter_17_3 in pairs(var_17_1) do
		if not UIAnimation.completed(iter_17_3) then
			UIAnimation.update(iter_17_3, arg_17_1)
		else
			var_17_1[iter_17_2] = nil
		end
	end
end

BossHealthUI._draw = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = arg_18_0.ui_renderer
	local var_18_1 = arg_18_0.ui_scenegraph
	local var_18_2 = arg_18_0.input_manager:get_service("Player")
	local var_18_3 = arg_18_0.render_settings

	var_18_3.alpha_multiplier = math.min(var_18_3.alpha_multiplier + arg_18_1 * 5, 1)

	UIRenderer.begin_pass(var_18_0, var_18_1, var_18_2, arg_18_1, nil, var_18_3)

	local var_18_4 = var_18_3.alpha_multiplier

	for iter_18_0, iter_18_1 in pairs(arg_18_0._detected_boss_units) do
		if iter_18_1.current_progress then
			local var_18_5 = arg_18_0._widgets_by_name[iter_18_1.widget_name]

			if var_18_5 then
				iter_18_1.alpha_multiplier = math.min(iter_18_1.alpha_multiplier + arg_18_1 * 5, 1)
				var_18_3.alpha_multiplier = iter_18_1.alpha_multiplier

				UIRenderer.draw_widget(var_18_0, var_18_5)
			end
		end
	end

	var_18_3.alpha_multiplier = var_18_4

	UIRenderer.end_pass(var_18_0)
end

BossHealthUI._show_boss_health_bar = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_1.unit
	local var_19_1
	local var_19_2 = Unit.get_data(var_19_0, "breed")

	if var_19_2 and var_19_2.server_controlled_health_bar then
		local var_19_3 = Managers.state
		local var_19_4 = var_19_3.network:game()
		local var_19_5 = var_19_3.unit_storage:go_id(var_19_0)

		var_19_1 = var_19_5 and GameSession.game_object_field(var_19_4, var_19_5, "show_health_bar")
	else
		local var_19_6 = Managers.state.entity:system("ai_system"):get_attributes(var_19_0)

		var_19_1 = var_19_2 and var_19_2.show_health_bar or var_19_6.grudge_marked ~= nil
	end

	if arg_19_1.show_health_bar ~= var_19_1 then
		local var_19_7 = arg_19_0:_num_healthbars()

		arg_19_1.show_health_bar = var_19_1
		arg_19_1.dirty = true
		arg_19_0.render_settings.alpha_multiplier = var_19_7 == 0 and 0 or arg_19_0.render_settings.alpha_multiplier
		arg_19_1.alpha_multiplier = var_19_7 == 0 and 0 or arg_19_0.render_settings.alpha_multiplier

		arg_19_0:_set_healing_amount(arg_19_1, 0, 0)

		arg_19_1.freeze_healing = false
		arg_19_1.next_update_is_instant = true
	end

	return var_19_1
end

BossHealthUI.on_spectator_target_changed = function (arg_20_0, arg_20_1)
	return
end

BossHealthUI.on_force_add_boss_health_ui = function (arg_21_0, arg_21_1)
	arg_21_0:_event_register_boss_unit(arg_21_1, "forced", true)
	arg_21_0:_realign_forced_boss_widgets()

	if Managers.player.is_server then
		if not Managers.state.network:game() then
			return
		end

		local var_21_0 = Managers.state.unit_storage:go_id(arg_21_1)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_add_forced_boss_health_ui", var_21_0)
	end
end

BossHealthUI.rpc_add_forced_boss_health_ui = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = Managers.state.unit_storage:unit(arg_22_2)

	arg_22_0:on_force_add_boss_health_ui(var_22_0)
end

BossHealthUI._event_register_boss_unit = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	if not HEALTH_ALIVE[arg_23_1] then
		return
	end

	local var_23_0, var_23_1 = table.find_func(arg_23_0._detected_boss_units, function (arg_24_0, arg_24_1)
		return arg_24_1.unit == arg_23_1
	end)

	if var_23_1 then
		local var_23_2 = var_23_1.priority
		local var_23_3 = var_0_4[arg_23_2]

		if var_23_2 < var_23_3 or var_23_3 == var_23_2 and var_0_5[arg_23_2] then
			var_23_1.priority = var_23_3
			var_23_1.priority_t = Managers.time:time("ui")
		end

		return var_23_1
	end

	local var_23_4 = {
		alpha_multiplier = 0,
		unit = arg_23_1,
		priority = var_0_4[arg_23_2],
		priority_t = Managers.time:time("ui"),
		forced = arg_23_2 == "forced",
		breed_name = Unit.get_data(arg_23_1, "breed").name
	}

	arg_23_0._detected_boss_units[#arg_23_0._detected_boss_units + 1] = var_23_4

	if var_23_4.forced then
		arg_23_0:_realign_forced_boss_widgets()
	end

	if arg_23_2 ~= "sync" then
		local var_23_5 = Managers.state.unit_storage:go_id(arg_23_1)

		if var_23_5 then
			local var_23_6 = Managers.state.network.network_transmit

			if Managers.player.is_server then
				var_23_6:send_rpc_clients("rpc_register_detected_boss", var_23_5)
			else
				var_23_6:send_rpc_server("rpc_register_detected_boss", var_23_5)
			end
		end
	end

	return var_23_4
end

local var_0_11 = {}

BossHealthUI._realign_forced_boss_widgets = function (arg_25_0, arg_25_1)
	table.clear(arg_25_0._forced_animations)

	local var_25_0 = arg_25_1 and 0 or 0.3
	local var_25_1, var_25_2 = table.filter_array(arg_25_0._detected_boss_units, function (arg_26_0)
		return arg_26_0.forced
	end, var_0_11)
	local var_25_3 = math.min(var_25_2, BossHealthUI.MAX_NUM_FORCED_WIDGETS)
	local var_25_4 = 50
	local var_25_5 = 500
	local var_25_6 = -(var_25_3 - 1) * 0.5 * (var_25_5 + var_25_4)

	for iter_25_0 = 1, var_25_3 do
		local var_25_7 = var_25_1[iter_25_0]
		local var_25_8 = arg_25_0._widgets_by_name[var_25_7.widget_name]

		if var_25_8 then
			arg_25_0._forced_animations["boss_ui_offset_" .. iter_25_0] = UIAnimation.init(UIAnimation.function_by_time, var_25_8.offset, 1, var_25_8.offset[1], var_25_6, var_25_0, math.easeOutCubic)
			var_25_6 = var_25_6 + var_25_5 + var_25_4
		end
	end
end

BossHealthUI._sync_boss_unit_health = function (arg_27_0, arg_27_1, arg_27_2)
	local var_27_0 = arg_27_0:_update_alive_units()
	local var_27_1, var_27_2, var_27_3 = arg_27_0:_update_prioritized_unit(arg_27_2)

	arg_27_0:_preemptively_hide_widgets()

	if var_27_0 or var_27_2 then
		arg_27_0:_realign_forced_boss_widgets(var_27_0)
	end

	local var_27_4 = arg_27_0:_has_forced()
	local var_27_5 = 0
	local var_27_6 = arg_27_0._detected_boss_units

	for iter_27_0 = 1, #var_27_6 do
		local var_27_7 = var_27_6[iter_27_0]

		if var_27_1 then
			var_27_7.dirty = true
		end

		local var_27_8 = var_27_7.unit
		local var_27_9 = var_27_7.dirty

		if var_27_7.prioritized or var_27_7.forced or var_27_9 then
			arg_27_0:_update_name(var_27_7)
		end

		local var_27_10 = arg_27_0._widgets_by_name[var_27_7.widget_name]

		if var_27_10 then
			if var_27_7.forced then
				var_27_10.offset[2] = 0
			elseif not var_27_7.prioritized then
				var_27_10.offset[1] = var_27_5 % 4 * var_0_0.total_bar_length * 0.25
				var_27_5 = var_27_5 + 1

				local var_27_11 = -80
				local var_27_12 = arg_27_0._widgets_by_name[var_27_3.widget_name]

				if var_27_12 and (var_27_12.content.num_attributes or 0) > 3 then
					var_27_11 = -100
				end

				local var_27_13 = var_27_11 + (math.ceil(var_27_5 / 4) - 1) * -60

				var_27_10.offset[2] = var_27_13
			end
		end

		local var_27_14
		local var_27_15
		local var_27_16 = ScriptUnit.extension(var_27_8, "health_system")
		local var_27_17 = var_27_16:current_health_percent()
		local var_27_18 = math.clamp(var_27_17, 0, 1)
		local var_27_19 = var_27_16:current_max_health_percent()
		local var_27_20 = var_27_18 * var_27_19
		local var_27_21 = var_27_19
		local var_27_22 = BreedActions[var_27_7.breed_name]

		var_27_7.freeze_healing = var_27_22 and var_27_22.downed and var_27_22.downed.freeze_healing and var_27_16.state == "down"

		local var_27_23 = var_27_7.current_raw_progress
		local var_27_24 = false

		if var_27_20 and (var_27_23 and var_27_23 < var_27_20 or var_27_9) then
			local var_27_25 = arg_27_0._last_rendered_prioritized_unit ~= var_27_8 and var_27_20 or var_27_7.healing_start_progress or var_27_7.current_progress or var_27_20
			local var_27_26 = var_27_23 and var_27_23 < var_27_20 and arg_27_2

			arg_27_0:_set_healing_amount(var_27_7, var_27_25, var_27_20, var_27_26, arg_27_1)

			var_27_7.healing_start_progress = var_27_25
		end

		if var_27_20 ~= var_27_7.current_progress or var_27_20 ~= var_27_7.current_raw_progress or var_27_21 ~= var_27_7.current_max_health_fraction or var_27_9 then
			arg_27_0:_set_bar_progress(var_27_7, var_27_20, var_27_21, var_27_24, arg_27_1, arg_27_2)
		end

		arg_27_0:_update_healing_bar(var_27_7, arg_27_1, arg_27_2, var_27_7.freeze_healing)
		arg_27_0:_update_healing_effect(var_27_7, arg_27_1, arg_27_2)
		arg_27_0:_set_health_edge_texture_position_progress(var_27_7)

		if var_27_7.prioritized then
			arg_27_0._last_rendered_prioritized_unit = var_27_7.unit
		end

		var_27_7.dirty = false

		if var_27_10 then
			if not var_27_7.prioritized and var_27_5 > BossHealthUI.MAX_NUM_ADDITIONAL_WIDGETS then
				var_27_10.content.visible = false
			else
				var_27_10.content.visible = var_27_7.forced or not var_27_4 and arg_27_0:_show_boss_health_bar(var_27_7)
			end
		end
	end
end

BossHealthUI._update_alive_units = function (arg_28_0)
	local var_28_0 = false
	local var_28_1 = arg_28_0._detected_boss_units

	for iter_28_0 = #var_28_1, 1, -1 do
		local var_28_2 = var_28_1[iter_28_0]

		if not HEALTH_ALIVE[var_28_2.unit] then
			table.remove(var_28_1, iter_28_0)

			var_28_0 = true
		end
	end

	return var_28_0
end

local var_0_12 = {}

BossHealthUI._update_prioritized_unit = function (arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0._detected_boss_units
	local var_29_1 = false
	local var_29_2
	local var_29_3 = -math.huge
	local var_29_4 = -math.huge

	for iter_29_0 = #var_29_0, 1, -1 do
		local var_29_5 = var_29_0[iter_29_0]

		var_29_5.prioritized = false

		local var_29_6 = var_29_5.priority
		local var_29_7 = var_29_5.priority_t
		local var_29_8 = var_29_5.breed_name
		local var_29_9 = Breeds[var_29_8] or PlayerBreeds[var_29_8]

		if (var_29_9 and var_29_9.healthbar_timeout or math.huge) < arg_29_1 - var_29_7 then
			table.swap_delete(var_29_0, iter_29_0)
		elseif arg_29_0:_show_boss_health_bar(var_29_5) then
			if var_29_3 < var_29_6 then
				var_29_2 = var_29_5
				var_29_3 = var_29_6
				var_29_4 = var_29_5.priority_t
			elseif var_29_6 == var_29_3 and var_29_4 < var_29_7 then
				var_29_2 = var_29_5
				var_29_4 = var_29_7
			end
		end
	end

	if var_29_2 then
		var_29_2.prioritized = true

		if not var_29_2.forced and var_29_2.widget_name ~= "prioritized_bar" then
			var_29_2.dirty = true
			var_29_2.widget_name = "prioritized_bar"
			var_29_1 = true
		end
	end

	local var_29_10, var_29_11 = table.filter_array(var_29_0, function (arg_30_0)
		return not arg_30_0.prioritized and not arg_30_0.forced
	end, var_0_12)
	local var_29_12 = 0

	for iter_29_1 = 1, var_29_11 do
		local var_29_13 = var_29_10[iter_29_1]
		local var_29_14 = var_29_13.breed_name
		local var_29_15 = Breeds[var_29_14] or PlayerBreeds[var_29_14]
		local var_29_16 = var_29_13.show_health_bar and not var_29_15.disallow_additional_healthbar

		if var_29_16 then
			var_29_12 = var_29_12 + 1
		end

		local var_29_17 = var_29_16 and arg_29_0:_get_or_create_additional_widget_name(var_29_12) or nil

		if var_29_17 ~= var_29_13.widget_name then
			var_29_13.dirty = true
			var_29_13.widget_name = var_29_17
			var_29_1 = true
		end
	end

	local var_29_18 = false
	local var_29_19, var_29_20 = table.filter_array(var_29_0, function (arg_31_0)
		return arg_31_0.forced
	end, var_0_12)

	for iter_29_2 = 1, var_29_20 do
		local var_29_21 = var_29_19[iter_29_2]
		local var_29_22 = arg_29_0:_get_or_create_forced_widget_name(iter_29_2)

		if var_29_22 ~= var_29_21.widget_name then
			var_29_21.dirty = true
			var_29_21.widget_name = var_29_22
			var_29_18 = true
			var_29_1 = true
		end
	end

	return var_29_1, var_29_18, var_29_2
end

BossHealthUI._preemptively_hide_widgets = function (arg_32_0)
	arg_32_0._widgets_by_name.prioritized_bar.content.visible = false

	local var_32_0 = arg_32_0._additional_widget_names

	for iter_32_0 = 1, #var_32_0 do
		local var_32_1 = arg_32_0:_get_or_create_additional_widget_name(iter_32_0)

		arg_32_0._widgets_by_name[var_32_1].content.visible = false
	end

	local var_32_2 = arg_32_0._forced_widget_names

	for iter_32_1 = 1, #var_32_2 do
		local var_32_3 = arg_32_0:_get_or_create_forced_widget_name(iter_32_1)

		arg_32_0._widgets_by_name[var_32_3].content.visible = false
	end
end

BossHealthUI._set_bar_progress = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5, arg_33_6)
	arg_33_2 = arg_33_2 or 0

	local var_33_0 = arg_33_1.current_progress or 1
	local var_33_1 = arg_33_1.healing_start_progress or var_33_0 + math.sign(arg_33_2 - var_33_0) * (arg_33_5 * 0.3)

	arg_33_4 = arg_33_1.next_update_is_instant or arg_33_4

	if arg_33_4 then
		var_33_1 = arg_33_2
	elseif var_33_0 < arg_33_2 then
		var_33_1 = math.min(var_33_1, arg_33_2)
	else
		var_33_1 = math.max(var_33_1, arg_33_2)
	end

	arg_33_3 = arg_33_3 or 1

	local var_33_2 = arg_33_1.current_max_health_fraction or 1
	local var_33_3 = var_33_2 + math.sign(arg_33_3 - var_33_2) * (arg_33_5 * 0.3)

	if arg_33_4 then
		var_33_3 = arg_33_3
	elseif var_33_2 < arg_33_3 then
		var_33_3 = math.min(var_33_3, arg_33_3)
	else
		var_33_3 = math.max(var_33_3, arg_33_3)
	end

	local var_33_4 = arg_33_0._widgets_by_name[arg_33_1.widget_name]

	if var_33_4 then
		local var_33_5 = var_33_4.content
		local var_33_6 = var_33_4.style
		local var_33_7 = var_33_6.bar
		local var_33_8 = var_33_5.bar.uvs

		var_33_7.size[1] = var_33_7.default_size[1] * (var_33_1 or 1)
		var_33_8[2][1] = var_33_1

		local var_33_9 = var_33_6.dead_space_bar
		local var_33_10 = var_33_5.dead_space_bar.uvs
		local var_33_11 = var_33_9.size
		local var_33_12 = var_33_9.offset
		local var_33_13 = var_33_9.default_size

		var_33_11[1] = var_33_13[1] * (1 - (var_33_3 or 1))
		var_33_10[1][1] = var_33_3
		var_33_12[1] = var_33_5.dead_space_bar_offset_reference + var_33_13[1] - var_33_11[1]

		local var_33_14 = var_33_6.dead_space_bar_divider
		local var_33_15 = var_33_14.offset
		local var_33_16 = var_33_14.default_width_offset

		var_33_15[1] = var_33_5.dead_space_bar_divider_offset_reference + (var_33_13[1] - var_33_16) - var_33_11[1]
		var_33_5.max_health_fraction = var_33_3
		var_33_5.health_fraction = var_33_1
	end

	arg_33_1.current_progress = var_33_1
	arg_33_1.current_raw_progress = arg_33_2
	arg_33_1.current_max_health_fraction = var_33_3
	arg_33_1.next_update_is_instant = nil
end

BossHealthUI._set_healing_amount = function (arg_34_0, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5)
	local var_34_0 = arg_34_0._widgets_by_name[arg_34_1.widget_name]

	if var_34_0 then
		local var_34_1 = var_34_0.content
		local var_34_2 = var_34_0.style
		local var_34_3 = var_34_2.healing_bar

		var_34_3.original_color = var_34_3.original_color or table.shallow_copy(var_34_3.color)

		local var_34_4 = var_34_1.healing_bar
		local var_34_5 = var_34_3.size
		local var_34_6 = var_34_3.offset
		local var_34_7 = var_34_4.uvs
		local var_34_8 = arg_34_3 - arg_34_2
		local var_34_9 = var_34_1.bar_length * var_34_8
		local var_34_10 = var_34_1.healing_bar_offset_reference + var_34_1.bar_length * arg_34_2

		var_34_7[1][1] = arg_34_2
		var_34_7[2][1] = arg_34_3

		local var_34_11 = var_34_2.healing_bar_flash
		local var_34_12 = false
		local var_34_13 = arg_34_1.breed_name
		local var_34_14 = Breeds[var_34_13] or PlayerBreeds[var_34_13]

		if var_34_14 and var_34_14.reflect_regen_reduction_in_hp_bar then
			local var_34_15 = ScriptUnit.has_extension(arg_34_1.unit, "buff_system")

			if var_34_15 then
				var_34_3.flash_time = var_34_3.flash_time or 0

				local var_34_16 = 0.75
				local var_34_17 = 1 - math.clamp01(var_34_15:apply_buffs_to_value(1, "healing_received"))

				if var_34_17 ~= 0 and var_34_17 ~= var_34_3.last_lerp_value then
					var_34_3.flash_time = var_34_16
				end

				local var_34_18 = math.inv_lerp_clamped(var_34_16, 0, var_34_3.flash_time)

				if var_34_18 < 0.5 then
					var_34_11.color[1] = 200 * math.ease_out_quad(var_34_18 * 2)
				elseif var_34_18 < 1 then
					var_34_11.color[1] = 200 * math.ease_out_quad(1 - (var_34_18 - 0.5) * 2)
				end

				local var_34_19 = arg_34_3 - arg_34_2

				var_34_11.offset[1] = var_34_3.offset[1] - UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1] * var_34_19
				var_34_11.size[1] = var_34_11.default_size[1] * var_34_19 + UIFrameSettings.boss_hp_bar_heal_flash.texture_sizes.vertical[1] * 2 * var_34_19
				var_34_3.color[1] = math.lerp(var_34_3.original_color[2], 255, var_34_17)
				var_34_3.color[2] = math.lerp(var_34_3.original_color[2], 200, var_34_17)
				var_34_3.color[3] = math.lerp(var_34_3.original_color[3], 100, var_34_17)
				var_34_3.color[4] = math.lerp(var_34_3.original_color[4], 100, var_34_17)
				var_34_3.last_lerp_value = var_34_17

				if arg_34_5 then
					var_34_3.flash_time = math.max(var_34_3.flash_time - arg_34_5, 0)
				end

				var_34_12 = true
			end
		end

		if not var_34_12 then
			var_34_3.color[2] = var_34_3.original_color[2]
			var_34_3.color[3] = var_34_3.original_color[3]
			var_34_3.color[4] = var_34_3.original_color[4]
			var_34_3.last_lerp_value = 1
			var_34_3.flash_time = 0
		end

		var_34_5[1] = var_34_9
		var_34_6[1] = var_34_10
	end

	if arg_34_4 then
		arg_34_1.healing_life_time = arg_34_4 + var_0_1
		arg_34_1.healing_effect_life_time = arg_34_4 + var_0_2
	end
end

BossHealthUI._update_healing_bar = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3, arg_35_4)
	local var_35_0 = arg_35_1.current_raw_progress
	local var_35_1 = arg_35_1.healing_start_progress

	if not var_35_1 or not var_35_0 then
		return
	end

	local var_35_2 = var_35_1

	if var_35_0 <= var_35_1 then
		var_35_2 = var_35_0
	elseif arg_35_1.healing_life_time and arg_35_3 >= arg_35_1.healing_life_time and not arg_35_4 then
		var_35_2 = math.min(var_35_1 + arg_35_2 * 0.5, var_35_0)
	end

	if arg_35_4 then
		local var_35_3 = arg_35_1.unit
		local var_35_4, var_35_5, var_35_6, var_35_7 = ScriptUnit.extension(var_35_3, "health_system"):respawn_thresholds()

		var_35_2 = var_35_7
	end

	arg_35_0:_set_healing_amount(arg_35_1, var_35_2, var_35_0, nil, arg_35_2)

	arg_35_1.healing_start_progress = var_35_2

	if var_35_2 == var_35_0 then
		arg_35_1.healing_start_progress = nil
		arg_35_1.healing_life_time = nil
	end
end

BossHealthUI._set_health_edge_texture_position_progress = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1.healing_start_progress or arg_36_1.current_progress or 0
	local var_36_1 = arg_36_0._widgets_by_name[arg_36_1.widget_name]

	if var_36_1 then
		local var_36_2 = var_36_1.content
		local var_36_3 = var_36_1.style.bar_edge
		local var_36_4 = var_36_3.offset
		local var_36_5 = var_36_3.default_width_offset

		var_36_4[1] = var_36_2.bar_edge_reference_offset + var_36_2.bar_length * var_36_0 - var_36_5
		var_36_2.bar_edge_fraction = var_36_0
	end
end

BossHealthUI._update_healing_effect = function (arg_37_0, arg_37_1, arg_37_2, arg_37_3)
	local var_37_0 = 0

	if arg_37_1.healing_effect_life_time then
		local var_37_1 = math.inv_lerp_clamped(arg_37_1.healing_effect_life_time - var_0_2, var_0_2, arg_37_3)
		local var_37_2 = 1 - var_37_1

		var_37_0 = 255 * math.ease_pulse(var_37_2)

		if var_37_1 == 0 then
			arg_37_1.healing_effect_life_time = nil
		end
	end

	arg_37_0:_set_health_effect_alpha(arg_37_1, var_37_0)
end

BossHealthUI._set_health_effect_alpha = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_0._widgets_by_name[arg_38_1.widget_name]

	if var_38_0 then
		var_38_0.style.portrait_healing.color[1] = arg_38_2
	end
end

BossHealthUI.rpc_register_detected_boss = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = Managers.state.unit_storage:unit(arg_39_2)

	if ALIVE[var_39_0] then
		arg_39_0:_event_register_boss_unit(var_39_0, "sync")

		if Managers.state.network.is_server then
			Managers.state.network.network_transmit:send_rpc_clients_except("rpc_register_detected_boss", CHANNEL_TO_PEER_ID[arg_39_1], arg_39_2)
		end
	end
end
