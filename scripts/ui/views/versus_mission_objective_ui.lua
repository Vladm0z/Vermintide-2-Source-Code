-- chunkname: @scripts/ui/views/versus_mission_objective_ui.lua

local var_0_0 = local_require("scripts/ui/views/versus_mission_objective_ui_definitions")
local var_0_1 = DLCSettings.carousel
local var_0_2 = var_0_0.animation_definitions
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.side_colors
local var_0_5 = 0.8
local var_0_6 = 3
local var_0_7 = 120
local var_0_8 = 1
local var_0_9 = false
local var_0_10 = {
	"rpc_update_start_round_countdown_timer",
	"rpc_ui_round_started"
}

VersusMissionObjectiveUI = class(VersusMissionObjectiveUI)

VersusMissionObjectiveUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	local var_1_0 = Managers.state.game_mode:game_mode()

	arg_1_0._active = Managers.state.game_mode:game_mode_key() == "versus" and not var_1_0:in_training_mode()

	if not arg_1_0._active then
		return
	end

	arg_1_0._parent = arg_1_1
	arg_1_0._ingame_ui_context = arg_1_2
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager

	local var_1_1 = arg_1_2.world_manager:world("level_world")

	arg_1_0._world = var_1_1
	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_1)
	arg_1_0._animations = {}
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._world_markers = {}
	arg_1_0._selected_objective_index = 0
	arg_1_0._objectives_widgets = {}

	arg_1_0:_create_ui_elements()

	arg_1_0._round_started = false
	arg_1_0._objective_system = Managers.state.entity:system("objective_system")
	arg_1_0._objectives_initialized = false

	arg_1_0:_register_rpcs()
	arg_1_0:_register_events()

	local var_1_2, var_1_3, var_1_4 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "round_time_limit")

	if var_1_4 and var_1_3 then
		arg_1_0._custom_round_timer_active = true
	end

	arg_1_0._win_conditions = Managers.mechanism:game_mechanism():win_conditions()

	local var_1_5 = Managers.state.game_mode:game_mode():game_mode_state() == "match_running_state" and true or nil

	if var_1_5 then
		arg_1_0:_on_round_started()
	end

	arg_1_0._round_has_started = var_1_5
end

VersusMissionObjectiveUI._register_rpcs = function (arg_2_0)
	arg_2_0._ingame_ui_context.network_event_delegate:register(arg_2_0, unpack(var_0_10))
end

VersusMissionObjectiveUI._unregister_rpcs = function (arg_3_0)
	arg_3_0._ingame_ui_context.network_event_delegate:unregister(arg_3_0)
end

VersusMissionObjectiveUI._is_dark_pact = function (arg_4_0)
	local var_4_0 = arg_4_0:_get_local_player_party_id()
	local var_4_1 = Managers.party:get_party(var_4_0)
	local var_4_2 = Managers.state.side.side_by_party[var_4_1]

	return var_4_2 and var_4_2:name() == "dark_pact"
end

VersusMissionObjectiveUI._start_transition_animation = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = {
		wwise_world = arg_5_0._wwise_world,
		render_settings = arg_5_0._render_settings
	}
	local var_5_1 = arg_5_0._widgets_by_name
	local var_5_2 = arg_5_0._ui_animator:start_animation(arg_5_2, var_5_1, var_0_3, var_5_0)

	arg_5_0._animations[arg_5_1] = var_5_2
end

VersusMissionObjectiveUI._create_ui_elements = function (arg_6_0)
	arg_6_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0 = {}
	local var_6_1 = {}
	local var_6_2 = var_0_0.widget_definitions

	for iter_6_0, iter_6_1 in pairs(var_6_2) do
		local var_6_3 = UIWidget.init(iter_6_1)

		var_6_1[iter_6_0] = var_6_3
		var_6_0[#var_6_0 + 1] = var_6_3
	end

	arg_6_0._objective_text_widget = UIWidget.init(var_0_0.objective_text)
	arg_6_0._widgets_by_name = var_6_1
	arg_6_0._widgets = var_6_0
	arg_6_0._objective_text_widget.content.visible = false
	var_0_9 = false

	UIRenderer.clear_scenegraph_queue(arg_6_0._ui_renderer)

	arg_6_0._ui_animator = UIAnimator:new(arg_6_0._ui_scenegraph, var_0_2)
end

VersusMissionObjectiveUI.destroy = function (arg_7_0)
	arg_7_0:_unregister_rpcs()
	arg_7_0:_unregister_events()

	arg_7_0._ui_animator = nil
end

VersusMissionObjectiveUI.update = function (arg_8_0, arg_8_1, arg_8_2)
	if var_0_9 then
		arg_8_0:_create_ui_elements()
	end

	if arg_8_0._active then
		arg_8_0:_update_round_start_timer(arg_8_1, arg_8_2)
		arg_8_0:_update_objectives(arg_8_1, arg_8_2)
		arg_8_0:_update_animations(arg_8_1, arg_8_2)
		arg_8_0:_update_score()
		arg_8_0:_draw(arg_8_1)
	end
end

VersusMissionObjectiveUI._update_objectives = function (arg_9_0, arg_9_1, arg_9_2)
	if not arg_9_0._objective_system:is_active() then
		return
	end

	arg_9_0:_update_world_markers(arg_9_1, arg_9_2)

	if not arg_9_0._objectives_initialized then
		local var_9_0 = arg_9_0:_get_local_player_party_id()
		local var_9_1 = arg_9_0:_get_party_side_name(var_9_0) == "heroes"

		arg_9_0._num_main_objective = arg_9_0._objective_system:num_main_objectives()

		arg_9_0:_set_active_scoring_side_color(var_9_1)

		arg_9_0._objectives_initialized = true
	end

	local var_9_2 = arg_9_0._objective_system:current_objective_index()
	local var_9_3 = arg_9_0._objective_system:num_completed_main_objectives()

	if var_9_2 > arg_9_0._selected_objective_index then
		arg_9_0._selected_objective_index = var_9_2

		arg_9_0:_update_current_objective(var_9_2)

		local var_9_4 = "n/a"

		if not arg_9_0:_is_dark_pact() then
			local var_9_5 = arg_9_0._objective_system:first_active_objective_description()

			arg_9_0:_set_objective_text(var_9_5)

			local var_9_6 = {
				render_settings = arg_9_0._render_settings
			}
			local var_9_7 = arg_9_0._objective_text_widget

			arg_9_0._ui_animator:start_animation("mission_start", var_9_7, var_0_3, var_9_6)
		else
			local var_9_8 = Localize("level_objective_pactsworn")

			arg_9_0:_set_objective_text(var_9_8)
		end
	end

	arg_9_0:_update_objective_progress()
end

VersusMissionObjectiveUI._set_active_scoring_side_color = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_1 and Colors.get_color_table_with_alpha("local_player_team_lighter", 255) or Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	local var_10_1 = arg_10_0._widgets_by_name.objective

	var_10_1.content.is_hero = arg_10_1
	var_10_1.style.progress_bar.color = var_10_0
	var_10_1.style.objective_icon.color = var_10_0
end

VersusMissionObjectiveUI._update_current_objective = function (arg_11_0)
	local var_11_0 = arg_11_0._widgets_by_name.objective
	local var_11_1 = arg_11_0._objective_system:current_objective_icon()

	var_11_0.content.objective_icon = var_11_1
end

VersusMissionObjectiveUI._update_objective_status = function (arg_12_0, arg_12_1)
	if arg_12_0._objectives_widgets then
		for iter_12_0 = 1, #arg_12_0._objectives_widgets do
			local var_12_0 = iter_12_0 == arg_12_1
			local var_12_1 = iter_12_0 < arg_12_1
			local var_12_2 = arg_12_1 < iter_12_0
			local var_12_3 = arg_12_0._objectives_widgets[iter_12_0]
			local var_12_4 = var_12_3.style
			local var_12_5 = var_12_3.content

			var_12_5.objective_progress = var_12_0 and arg_12_0._objective_system:current_objective_progress() or 0
			var_12_5.current_objective = var_12_0
			var_12_5.is_inactive = var_12_2
			var_12_5.completed = var_12_1
		end
	end
end

VersusMissionObjectiveUI._set_round_text = function (arg_13_0)
	local var_13_0 = arg_13_0._widgets_by_name.round_text.content
	local var_13_1 = arg_13_0:_get_round_count()

	var_13_0.text = string.format("Round: %d", var_13_1)
end

VersusMissionObjectiveUI._get_round_count = function (arg_14_0)
	return (Managers.mechanism:game_mechanism():win_conditions():get_current_round())
end

VersusMissionObjectiveUI._update_score = function (arg_15_0)
	local var_15_0 = arg_15_0:_get_local_player_party_id()
	local var_15_1 = arg_15_0:_get_opponent_party_id()
	local var_15_2 = arg_15_0._widgets_by_name.objective

	var_15_2.content.team_1_score = arg_15_0._win_conditions:get_total_score(var_15_0)
	var_15_2.content.team_2_score = arg_15_0._win_conditions:get_total_score(var_15_1)
end

VersusMissionObjectiveUI._get_party_side_name = function (arg_16_0, arg_16_1)
	local var_16_0 = Managers.party:get_party(arg_16_1)

	return (Managers.state.side.side_by_party[var_16_0]:name())
end

VersusMissionObjectiveUI._get_local_player_party_id = function (arg_17_0)
	local var_17_0 = Network.peer_id()
	local var_17_1 = Managers.party
	local var_17_2 = 1

	return var_17_1:get_player_status(var_17_0, var_17_2).party_id
end

VersusMissionObjectiveUI._get_opponent_party_id = function (arg_18_0)
	return arg_18_0:_get_local_player_party_id() == 1 and 2 or 1
end

VersusMissionObjectiveUI._reset_timer_size = function (arg_19_0)
	local var_19_0 = arg_19_0._widgets_by_name.timer_text.style
	local var_19_1 = var_19_0.text.default_font_size

	var_19_0.text.font_size = var_19_1
	var_19_0.text_shadow.font_size = var_19_1
end

VersusMissionObjectiveUI._set_objective_bar_end = function (arg_20_0, arg_20_1)
	arg_20_0._widgets_by_name.progress_bar.content.disabled_progress_bar = arg_20_1
end

VersusMissionObjectiveUI._play_sound = function (arg_21_0, arg_21_1)
	WwiseWorld.trigger_event(arg_21_0._wwise_world, arg_21_1)
end

VersusMissionObjectiveUI._update_animations = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._animations
	local var_22_1 = arg_22_0._ui_animator

	var_22_1:update(arg_22_1)

	for iter_22_0, iter_22_1 in pairs(var_22_0) do
		if var_22_1:is_animation_completed(iter_22_1) then
			var_22_1:stop_animation(iter_22_1)

			var_22_0[iter_22_0] = nil

			if iter_22_0 == "announcement" then
				arg_22_0._bonus_time_timer = var_0_8
			end
		end
	end
end

VersusMissionObjectiveUI._update_round_start_timer = function (arg_23_0, arg_23_1, arg_23_2)
	if arg_23_0._round_has_started then
		return
	end

	if arg_23_0._countdown_timer and arg_23_0._countdown_timer <= 0 then
		arg_23_0:_set_round_starting_text()
	end
end

VersusMissionObjectiveUI._set_pre_round_timer = function (arg_24_0, arg_24_1)
	arg_24_0._widgets_by_name.objective.content.pre_round_timer = arg_24_1

	if arg_24_1 <= 10 and arg_24_1 > 0 then
		local var_24_0 = var_0_1.versus_round_start_safe_zone_countdown_tick[arg_24_1]

		arg_24_0:_play_sound(var_24_0)
	end

	arg_24_0._countdown_timer = arg_24_1
end

VersusMissionObjectiveUI.set_round_timer = function (arg_25_0, arg_25_1)
	arg_25_0._widgets_by_name.objective.content.pre_round_timer = arg_25_1
end

VersusMissionObjectiveUI._set_round_starting_text = function (arg_26_0)
	arg_26_0._widgets_by_name.round_starting_text.content.text = "Round Starting..."
end

VersusMissionObjectiveUI._draw = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_0._ui_renderer
	local var_27_1 = arg_27_0._ui_scenegraph
	local var_27_2 = arg_27_0._input_manager:get_service("ingame_menu")
	local var_27_3 = arg_27_0._render_settings
	local var_27_4 = var_27_3.alpha_multiplier or 1

	UIRenderer.begin_pass(var_27_0, var_27_1, var_27_2, arg_27_1, nil, var_27_3)

	local var_27_5 = arg_27_0._widgets

	if var_27_5 then
		for iter_27_0 = 1, #var_27_5 do
			local var_27_6 = var_27_5[iter_27_0]

			var_27_3.alpha_multiplier = var_27_6.alpha_multiplier or var_27_4

			UIRenderer.draw_widget(var_27_0, var_27_6)
		end
	end

	if arg_27_0._objectives_widgets and arg_27_0._round_has_started then
		UIRenderer.draw_all_widgets(var_27_0, arg_27_0._objectives_widgets)
	end

	if arg_27_0._objective_text_widget then
		var_27_3.alpha_multiplier = arg_27_0._objective_text_widget.alpha_multiplier or var_27_4

		UIRenderer.draw_widget(var_27_0, arg_27_0._objective_text_widget)
	end

	UIRenderer.end_pass(var_27_0)

	var_27_3.alpha_multiplier = var_27_4
end

VersusMissionObjectiveUI._set_objective_text = function (arg_28_0, arg_28_1)
	local var_28_0 = arg_28_0._widgets_by_name
	local var_28_1 = arg_28_0._objective_text_widget
	local var_28_2 = var_28_1.content
	local var_28_3 = var_28_1.style

	var_28_2.area_text_content = arg_28_1

	local var_28_4 = arg_28_0.ui_renderer
	local var_28_5 = 287.5
	local var_28_6 = 40

	var_28_2.text_height = 45
end

VersusMissionObjectiveUI._format_timer = function (arg_29_0, arg_29_1)
	if not arg_29_1 and not (arg_29_1 <= 0) then
		return "00:00"
	end

	return string.format("%02d:%02d", math.floor(arg_29_1 / 60), arg_29_1 % 60)
end

local var_0_11 = {}
local var_0_12 = {}

VersusMissionObjectiveUI._update_world_markers = function (arg_30_0, arg_30_1, arg_30_2)
	if arg_30_0._selected_objective_index < 1 then
		return
	end

	if not arg_30_0._round_has_started then
		return
	end

	table.clear(var_0_12)

	local var_30_0 = arg_30_0._world_markers
	local var_30_1 = arg_30_0:_get_world_marker_targets(var_0_11)

	for iter_30_0 = 1, var_30_1 do
		local var_30_2 = var_0_11[iter_30_0]

		var_0_12[var_30_2] = true

		if not var_30_0[var_30_2] then
			arg_30_0:_request_world_marker(var_30_2)
		end
	end

	for iter_30_1, iter_30_2 in pairs(var_30_0) do
		if not var_0_12[iter_30_1] then
			var_30_0[iter_30_1] = nil

			arg_30_0:_remove_world_marker(iter_30_2)
		end
	end
end

VersusMissionObjectiveUI._get_world_marker_targets = function (arg_31_0, arg_31_1)
	local var_31_0 = Managers.player:local_player().viewport_name
	local var_31_1 = ScriptWorld.viewport(arg_31_0._world, var_31_0)
	local var_31_2 = ScriptViewport.camera(var_31_1)
	local var_31_3 = ScriptCamera.position(var_31_2)
	local var_31_4 = 0
	local var_31_5
	local var_31_6 = math.huge
	local var_31_7 = arg_31_0._objective_system
	local var_31_8 = var_31_7:active_leaf_objectives()

	for iter_31_0 = 1, #var_31_8 do
		local var_31_9 = var_31_8[iter_31_0]
		local var_31_10 = var_31_7:extension_by_objective_name(var_31_9)
		local var_31_11 = var_31_10:unit()

		if Unit.alive(var_31_11) then
			local var_31_12 = Unit.local_position(var_31_11, 0)
			local var_31_13 = Vector3.distance_squared(var_31_3, var_31_12)

			if var_31_13 < var_31_6 then
				var_31_5 = var_31_11
				var_31_6 = var_31_13
			end

			if var_31_10:always_show_objective_marker() then
				var_31_4 = var_31_4 + 1
				arg_31_1[var_31_4] = var_31_11
			end
		end
	end

	local var_31_14 = false

	for iter_31_1 = 1, var_31_4 do
		if arg_31_1[iter_31_1] == var_31_5 then
			var_31_14 = true

			break
		end
	end

	if var_31_5 and not var_31_14 then
		var_31_4 = var_31_4 + 1
		arg_31_1[var_31_4] = var_31_5
	end

	return var_31_4
end

VersusMissionObjectiveUI._remove_world_marker = function (arg_32_0, arg_32_1)
	Managers.state.event:trigger("remove_world_marker", arg_32_1)
end

VersusMissionObjectiveUI._request_world_marker = function (arg_33_0, arg_33_1)
	local var_33_0 = Managers.state.event
	local var_33_1 = "versus_objective"
	local var_33_2 = callback(arg_33_0, "cb_world_marker_spawned", arg_33_1)

	if ScriptUnit.has_extension(arg_33_1, "payload_system") then
		var_33_0:trigger("add_world_marker_unit", var_33_1, arg_33_1, var_33_2)
	else
		local var_33_3 = Unit.world_position(arg_33_1, 0)

		var_33_0:trigger("add_world_marker_position", var_33_1, var_33_3, var_33_2)
	end
end

VersusMissionObjectiveUI.cb_world_marker_spawned = function (arg_34_0, arg_34_1, arg_34_2)
	arg_34_0._world_markers[arg_34_1] = arg_34_2
end

VersusMissionObjectiveUI.rpc_update_start_round_countdown_timer = function (arg_35_0, arg_35_1, arg_35_2)
	arg_35_2 = math.round(arg_35_2)

	Managers.state.event:trigger("ui_update_start_round_counter", arg_35_2)
	Managers.state.event:trigger("ui_tab_update_start_round_counter", arg_35_2)
end

VersusMissionObjectiveUI.rpc_ui_round_started = function (arg_36_0, arg_36_1)
	arg_36_0:_on_round_started()
	Managers.state.event:trigger("ui_tab_round_started")
end

VersusMissionObjectiveUI._on_round_started = function (arg_37_0)
	arg_37_0._round_has_started = true

	local var_37_0 = arg_37_0._widgets_by_name.round_start_timer
	local var_37_1 = arg_37_0._widgets_by_name.round_starting_text
	local var_37_2 = arg_37_0._objective_text_widget
	local var_37_3 = arg_37_0._widgets_by_name.objective
	local var_37_4 = not arg_37_0._custom_round_timer_active

	var_37_0.content.visible = false
	var_37_1.content.visible = false
	var_37_2.content.visible = true
	var_37_3.content.pre_round_timer_done = var_37_4
	var_37_3.style.pre_round_timer.font_size = var_37_4 and 50 or 32

	if not var_37_4 then
		arg_37_0._widgets_by_name.objective.content.pre_round_timer = ""
	end

	local var_37_5 = {
		wwise_world = arg_37_0._wwise_world,
		render_settings = arg_37_0._render_settings
	}

	arg_37_0._ui_animator:start_animation("mission_start", var_37_2, var_0_3, var_37_5)
	arg_37_0:_play_sound("menu_versus_match_start")
end

VersusMissionObjectiveUI._register_events = function (arg_38_0)
	local var_38_0 = Managers.state.event

	if var_38_0 then
		var_38_0:register(arg_38_0, "ui_update_start_round_counter", "update_start_round_counter")
		var_38_0:register(arg_38_0, "ui_update_round_timer", "set_round_timer")
		var_38_0:register(arg_38_0, "ui_round_started", "round_started")
	end
end

VersusMissionObjectiveUI._unregister_events = function (arg_39_0)
	local var_39_0 = Managers.state.event

	if var_39_0 then
		var_39_0:unregister("ui_update_start_round_counter", arg_39_0)
		var_39_0:unregister("ui_update_round_timer", arg_39_0)
		var_39_0:unregister("ui_round_started", arg_39_0)
	end
end

VersusMissionObjectiveUI.update_start_round_counter = function (arg_40_0, arg_40_1)
	arg_40_0:_set_pre_round_timer(arg_40_1)
end

VersusMissionObjectiveUI.round_started = function (arg_41_0)
	arg_41_0:_on_round_started()
end

VersusMissionObjectiveUI._update_objective_progress = function (arg_42_0)
	local var_42_0 = arg_42_0._objective_system:current_objective_progress() or 0
	local var_42_1 = 0
	local var_42_2 = 360 - var_42_1 * 2
	local var_42_3 = 255 * math.min(var_42_0 * 2, 1)
	local var_42_4 = (var_42_1 + var_42_2 * var_42_0) / 360

	arg_42_0._widgets_by_name.objective.style.progress_bar.gradient_threshold = var_42_4

	if var_42_0 == 1 then
		return true
	end
end
