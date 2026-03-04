-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_custom_game_settings.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_custom_game_settings_definitions")
local var_0_1 = var_0_0.animation_definitions
local var_0_2 = var_0_0.scenegraph_definition

StartGameWindowVersusCustomGameSettings = class(StartGameWindowVersusCustomGameSettings)
StartGameWindowVersusCustomGameSettings.NAME = "StartGameWindowVersusCustomGameSettings"

local var_0_3 = {
	default = UIWidgets.create_settings_stepper_widget,
	stepper = UIWidgets.create_settings_stepper_widget,
	slider = UIWidgets.create_settings_slider_widget
}
local var_0_4 = {
	default = 36,
	slider = 36,
	stepper = 36
}

function StartGameWindowVersusCustomGameSettings.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("Entered Substate StartGameWindowVersusCustomGameSettings")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ingame_ui_context = var_1_0
	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._matchmaking_manager = var_1_0.matchmaking_manager
	arg_1_0._peer_id = var_1_0.peer_id
	arg_1_0._is_server = var_1_0.is_server

	local var_1_1 = Managers.mechanism:game_mechanism()
	local var_1_2 = var_1_1 and var_1_1:get_custom_game_settings_handler()

	arg_1_0._settings_templates = var_1_2 and var_1_2:get_settings_template()
	arg_1_0._custom_game_settings_handler = var_1_2
	arg_1_0._game_mechanism = var_1_1
	arg_1_0._selected_setting_index = nil
	arg_1_0._input_focused = false
	arg_1_0._is_loading = true
	arg_1_0._custom_settings_toggled = var_1_1 and var_1_1:custom_settings_enabled() or false

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "event_focus_custom_game_settings_input", "focus_custom_game_settings_input")
	Managers.state.event:register(arg_1_0, "event_reset_host_settings", "_reset_host_settings")
end

function StartGameWindowVersusCustomGameSettings._create_ui_elements(arg_2_0)
	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_top_renderer)

	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = var_0_0.widget_definitions

	UIUtils.create_widgets(var_2_2, var_2_0, var_2_1)

	arg_2_0._widgets = var_2_0
	arg_2_0._widgets_by_name = var_2_1
	arg_2_0._ui_animator = UIAnimator:new(arg_2_0._ui_scenegraph, var_0_1)
	arg_2_0._animations = {}
	arg_2_0._ui_animations = {}
end

function StartGameWindowVersusCustomGameSettings._populate_settings(arg_3_0)
	local var_3_0 = arg_3_0._is_server and arg_3_0._game_mechanism:is_hosting_versus_custom_game()
	local var_3_1 = arg_3_0._custom_game_settings_handler:get_settings()
	local var_3_2 = arg_3_0._settings_templates
	local var_3_3 = DLCSettings.carousel.custom_game_ui_settings
	local var_3_4 = {}
	local var_3_5 = {}
	local var_3_6 = 0

	for iter_3_0, iter_3_1 in ipairs(var_3_1) do
		local var_3_7 = var_3_2[iter_3_0]
		local var_3_8 = var_3_7.setting_name
		local var_3_9 = var_3_7.values
		local var_3_10 = var_3_3[var_3_8]
		local var_3_11 = var_3_10 and var_3_10.widget_type or "default"
		local var_3_12 = var_0_4[var_3_11]
		local var_3_13 = var_3_7.values_reverse_lookup[iter_3_1]
		local var_3_14 = var_3_7.default
		local var_3_15 = var_3_7.values_reverse_lookup[var_3_14]
		local var_3_16 = callback(arg_3_0, "on_setting_changed_cb")
		local var_3_17 = var_0_3[var_3_11]("settings_anchor", var_3_7, var_3_10, iter_3_1, var_3_13, iter_3_0, var_3_16)
		local var_3_18 = UIWidget.init(var_3_17)

		var_3_6 = var_3_6 + var_3_12
		var_3_18.offset = {
			20,
			-var_3_6,
			1
		}
		var_3_18.content.is_server = var_3_0
		var_3_18.content.default_value = var_3_14
		var_3_18.content.default_idx = var_3_15
		var_3_18.content.widget_type = var_3_11
		var_3_4[#var_3_4 + 1] = var_3_18
		var_3_5[var_3_8] = var_3_18
	end

	arg_3_0._settings_widgets = var_3_4
	arg_3_0._settings_widgets_by_name = var_3_5
	arg_3_0._num_settings = #var_3_1, arg_3_0:_setup_scrollbar(var_3_6)
	arg_3_0._settings = var_3_1
end

function StartGameWindowVersusCustomGameSettings.on_exit(arg_4_0, arg_4_1)
	print("Exited Substate StartGameWindowVersusCustomGameSettings")

	arg_4_0._ui_animator = nil

	Managers.state.event:unregister("event_focus_custom_game_settings_input", arg_4_0)
	Managers.state.event:unregister("event_reset_host_settings", arg_4_0)
end

function StartGameWindowVersusCustomGameSettings.update(arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._ui_animator:update(arg_5_1)
	arg_5_0:_update_animations(arg_5_1)
	arg_5_0:_draw(arg_5_1, arg_5_2)

	local var_5_0 = Managers.mechanism:network_handler():get_match_handler():get_match_owner()

	arg_5_0._is_loading = not Managers.mechanism:mechanism_try_call("get_all_reservation_handlers_by_owner", var_5_0) or not Managers.matchmaking:is_in_versus_custom_game_lobby()
end

function StartGameWindowVersusCustomGameSettings._update_animations(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._animations
	local var_6_1 = arg_6_0._ui_animator
	local var_6_2 = arg_6_0._ui_animations

	for iter_6_0, iter_6_1 in pairs(arg_6_0._ui_animations) do
		UIAnimation.update(iter_6_1, arg_6_1)

		if UIAnimation.completed(iter_6_1) then
			arg_6_0._ui_animations[iter_6_0] = nil
		end
	end

	for iter_6_2, iter_6_3 in pairs(var_6_0) do
		if var_6_1:is_animation_completed(iter_6_3) then
			var_6_1:stop_animation(iter_6_3)

			var_6_0[iter_6_2] = nil
		end
	end

	if arg_6_0._ui_animations.move_up or arg_6_0._ui_animations.move_down then
		arg_6_0._scrollbar_ui:force_update_progress(2)
	end
end

function StartGameWindowVersusCustomGameSettings.post_update(arg_7_0, arg_7_1, arg_7_2)
	if not arg_7_0._settings_initialized then
		arg_7_0._settings_initialized = true

		arg_7_0:_populate_settings()
	end

	if arg_7_0._settings_initialized and not arg_7_0._game_mechanism:is_hosting_versus_custom_game() then
		arg_7_0:_client_sync_settings()
	end

	if arg_7_0._settings_is_dirty then
		arg_7_0:_update_lobby_data(arg_7_1, arg_7_2)
	end

	local var_7_0 = Managers.input:is_device_active("gamepad")

	if var_7_0 and arg_7_0._input_focused then
		arg_7_0:_handle_gamepad_input(arg_7_1, arg_7_2)
	else
		arg_7_0:_handle_input(arg_7_1, arg_7_2)
	end

	arg_7_0:_update_focus_overlay(arg_7_1, arg_7_2, var_7_0)
end

function StartGameWindowVersusCustomGameSettings._update_lobby_data(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_0._custom_settings_toggled then
		local var_8_0 = arg_8_0._custom_game_settings_handler:get_packed_custom_settings()

		Managers.matchmaking:set_versus_custom_lobby_data(var_8_0)
	else
		Managers.matchmaking:set_versus_custom_lobby_data("n/a")
	end

	arg_8_0._settings_is_dirty = false
end

function StartGameWindowVersusCustomGameSettings._draw(arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._ui_top_renderer
	local var_9_1 = arg_9_0._ui_scenegraph
	local var_9_2 = arg_9_0._parent:window_input_service()
	local var_9_3 = arg_9_0._render_settings

	UIRenderer.begin_pass(var_9_0, var_9_1, var_9_2, arg_9_1, nil, var_9_3)

	if not arg_9_0._is_loading then
		UIRenderer.draw_all_widgets(var_9_0, arg_9_0._widgets)

		if arg_9_0._settings_widgets then
			UIRenderer.draw_all_widgets(var_9_0, arg_9_0._settings_widgets)
		end
	end

	UIRenderer.end_pass(var_9_0)

	if not arg_9_0._is_loading and arg_9_0._scrollbar_ui then
		arg_9_0._scrollbar_ui:update(arg_9_1, arg_9_2, var_9_0, var_9_2, var_9_3)
	end
end

function StartGameWindowVersusCustomGameSettings.on_setting_changed_cb(arg_10_0, arg_10_1, arg_10_2)
	if arg_10_0._is_server and arg_10_0._game_mechanism:is_hosting_versus_custom_game() then
		local var_10_0 = arg_10_0._settings_templates[arg_10_1]
		local var_10_1 = var_10_0.values[arg_10_2]
		local var_10_2 = var_10_0.setting_name

		arg_10_0._custom_game_settings_handler:server_set_setting(var_10_2, var_10_1)

		arg_10_0._settings_is_dirty = true
	end
end

function StartGameWindowVersusCustomGameSettings._client_sync_settings(arg_11_0)
	local var_11_0 = arg_11_0._custom_game_settings_handler:get_settings()
	local var_11_1 = arg_11_0._settings_templates

	for iter_11_0 = 1, #var_11_0 do
		local var_11_2 = var_11_1[iter_11_0]
		local var_11_3 = arg_11_0._settings_widgets_by_name[var_11_2.setting_name]
		local var_11_4 = var_11_3.content.setting_idx
		local var_11_5 = var_11_0[iter_11_0]
		local var_11_6 = var_11_2.values_reverse_lookup[var_11_5]
		local var_11_7 = var_11_3.content

		if var_11_4 ~= var_11_6 then
			var_11_7.setting_idx = var_11_6

			if var_11_7.widget_type == "slider" then
				var_11_7.current_slider_value = math.clamp(var_11_6 / var_11_7.num_settings, 0, 1)
			end
		end
	end
end

function StartGameWindowVersusCustomGameSettings._setup_scrollbar(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1 - var_0_0.scenegraph_definition.container.size[2]

	if var_12_0 > 0 then
		local var_12_1 = arg_12_0._ui_scenegraph
		local var_12_2 = "settings_anchor"
		local var_12_3 = "container"
		local var_12_4 = false
		local var_12_5
		local var_12_6

		arg_12_0._scrollbar_ui = ScrollbarUI:new(var_12_1, var_12_2, var_12_3, var_12_0, var_12_4, var_12_5, var_12_6)
	end
end

function StartGameWindowVersusCustomGameSettings.focus_custom_game_settings_input(arg_13_0, arg_13_1)
	arg_13_0._input_focused = arg_13_1

	arg_13_0._parent:pause_input(arg_13_1)
	arg_13_0._parent:set_input_description("versus_player_hosted_lobby_custom_settings")

	arg_13_0._custom_settings_toggled = arg_13_1
	arg_13_0._settings_is_dirty = true
end

function StartGameWindowVersusCustomGameSettings._reset_host_settings(arg_14_0, arg_14_1)
	if arg_14_1 then
		local var_14_0 = arg_14_0._custom_game_settings_handler:get_settings()
		local var_14_1 = arg_14_0._settings_templates

		for iter_14_0 = 1, #var_14_0 do
			local var_14_2 = var_14_1[iter_14_0]
			local var_14_3 = arg_14_0._settings_widgets_by_name[var_14_2.setting_name]
			local var_14_4 = var_14_2.default
			local var_14_5 = var_14_2.values_reverse_lookup[var_14_4]
			local var_14_6 = var_14_3.content

			var_14_6.setting_idx = var_14_5

			if var_14_6.widget_type == "slider" then
				var_14_6.current_slider_value = math.clamp(var_14_5 / var_14_6.num_settings, 0, 1)
			end
		end
	end
end

local function var_0_5(arg_15_0, arg_15_1)
	local var_15_0 = 0
	local var_15_1 = 0

	for iter_15_0 = 1, arg_15_1 do
		local var_15_2 = arg_15_0[iter_15_0].content.widget_type

		var_15_0 = var_15_0 + var_0_4[var_15_2]

		if var_15_0 > 350 then
			var_15_1 = var_15_1 + var_0_4[var_15_2]
		end
	end

	return var_15_1
end

function StartGameWindowVersusCustomGameSettings._handle_gamepad_input(arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_0._settings_widgets then
		return
	end

	local var_16_0 = arg_16_0._parent:window_input_service()
	local var_16_1 = arg_16_0._selected_setting_index or 1
	local var_16_2 = arg_16_0._settings_widgets

	if var_16_0:get("move_up") then
		if var_16_1 - 1 >= 1 then
			var_16_1 = var_16_1 - 1
		else
			var_16_1 = #var_16_2
		end

		local var_16_3 = var_16_2[1]

		if arg_16_0._ui_scenegraph.settings_anchor.local_position[2] > 0 then
			local var_16_4 = var_0_5(var_16_2, var_16_1)

			arg_16_0._ui_animations.move_down = UIAnimation.init(UIAnimation.function_by_time, arg_16_0._ui_scenegraph.settings_anchor.local_position, 2, arg_16_0._ui_scenegraph.settings_anchor.local_position[2], var_16_4, 0.5, math.easeOutCubic)
		end
	elseif var_16_0:get("move_down") then
		if var_16_1 + 1 <= #var_16_2 then
			var_16_1 = var_16_1 + 1
		else
			var_16_1 = 1
		end

		local var_16_5 = var_16_2[var_16_1]

		if math.abs(var_16_5.offset[2]) > 380 then
			local var_16_6 = var_0_5(var_16_2, var_16_1)

			arg_16_0._ui_animations.move_up = UIAnimation.init(UIAnimation.function_by_time, arg_16_0._ui_scenegraph.settings_anchor.local_position, 2, arg_16_0._ui_scenegraph.settings_anchor.local_position[2], var_16_6, 0.5, math.easeOutCubic)
		end
	end

	if var_16_1 ~= arg_16_0._selected_setting_index then
		arg_16_0._selected_setting_index = var_16_1

		for iter_16_0 = 1, #var_16_2 do
			var_16_2[iter_16_0].content.is_selected = var_16_1 == iter_16_0
		end
	end

	if arg_16_0._is_server and arg_16_0._game_mechanism:is_hosting_versus_custom_game() then
		local var_16_7 = var_16_2[var_16_1]
		local var_16_8 = var_16_7.content
		local var_16_9 = var_16_8.input_cooldown_multiplier
		local var_16_10 = false
		local var_16_11 = false

		if var_16_8.input_cooldown then
			var_16_10 = true

			local var_16_12 = var_16_8.input_cooldown
			local var_16_13 = math.max(var_16_12 - arg_16_1, 0)

			var_16_8.input_cooldown = var_16_13 > 0 and var_16_13 or nil
		end

		if var_16_7 and not var_16_8.input_cooldown then
			if var_16_0:get("move_left") or var_16_8.widget_type == "slider" and var_16_0:get("move_left_hold") then
				local var_16_14 = var_16_8.setting_idx - 1

				if var_16_14 < 1 then
					var_16_14 = var_16_8.widget_type == "slider" and 1 or var_16_8.num_settings
				end

				var_16_8.setting_idx = var_16_14

				if var_16_8.widget_type == "slider" then
					local var_16_15 = 1 / var_16_8.num_settings
					local var_16_16 = var_16_8.current_slider_value - var_16_15

					var_16_8.current_slider_value = math.clamp(var_16_16, 0, 1)
				end

				var_16_8.on_setting_changed_cb(var_16_8.id, var_16_14)

				var_16_11 = true
			elseif var_16_0:get("move_right") or var_16_8.widget_type == "slider" and var_16_0:get("move_right_hold") then
				local var_16_17 = var_16_8.setting_idx + 1

				if var_16_17 > var_16_8.num_settings then
					var_16_17 = var_16_8.widget_type == "slider" and var_16_8.num_settings or 1
				end

				var_16_8.setting_idx = var_16_17

				if var_16_8.widget_type == "slider" then
					local var_16_18 = 1 / var_16_8.num_settings
					local var_16_19 = var_16_8.current_slider_value + var_16_18

					var_16_8.current_slider_value = math.clamp(var_16_19, 0, 1)
				end

				var_16_8.on_setting_changed_cb(var_16_8.id, var_16_17)

				var_16_11 = true
			elseif var_16_0:get("special_1") then
				local var_16_20 = var_16_8.default_idx

				var_16_8.setting_idx = var_16_20
				var_16_8.current_slider_value = math.clamp(var_16_20 / var_16_8.num_settings, 0, 1)

				var_16_8.on_setting_changed_cb(var_16_8.id, var_16_20)

				var_16_11 = true
			end
		end

		if var_16_7 and var_16_11 then
			if var_16_10 then
				local var_16_21 = math.max(var_16_9 - 0.1, 0.1)

				var_16_8.input_cooldown = 0.2 * math.ease_in_exp(var_16_21)
				var_16_8.input_cooldown_multiplier = var_16_21
			else
				local var_16_22 = 1

				var_16_8.input_cooldown = 0.2 * math.ease_in_exp(var_16_22)
				var_16_8.input_cooldown_multiplier = var_16_22
			end
		end
	end

	if var_16_0:get("back") then
		Managers.state.event:trigger("event_focus_versus_hosted_lobby_input")
		arg_16_0._parent:pause_input(false)

		arg_16_0._input_focused = false
		arg_16_0._custom_settings_toggled = false
	end
end

function StartGameWindowVersusCustomGameSettings._handle_input(arg_17_0, arg_17_1, arg_17_2)
	if not arg_17_0._settings_widgets then
		return
	end

	local var_17_0 = arg_17_0._settings_widgets

	for iter_17_0 = 1, #var_17_0 do
		local var_17_1 = var_17_0[iter_17_0]
		local var_17_2 = var_17_1.content
		local var_17_3 = var_17_2.widget_type
		local var_17_4 = arg_17_0:_is_list_hovered()

		var_17_2.can_hover = var_17_4

		if var_17_3 == "stepper" or var_17_3 == "default" then
			if var_17_4 then
				if UIUtils.is_button_pressed(var_17_1, "left_arrow_hotspot") then
					local var_17_5 = var_17_2.setting_idx - 1

					if var_17_5 < 1 then
						var_17_5 = var_17_2.num_settings
					end

					var_17_2.setting_idx = var_17_5

					var_17_2.on_setting_changed_cb(var_17_2.id, var_17_5)
				elseif UIUtils.is_button_pressed(var_17_1, "right_arrow_hotspot") then
					local var_17_6 = var_17_2.setting_idx + 1

					if var_17_6 > var_17_2.num_settings then
						var_17_6 = 1
					end

					var_17_2.setting_idx = var_17_6

					var_17_2.on_setting_changed_cb(var_17_2.id, var_17_6)
				elseif UIUtils.is_button_pressed(var_17_1, "reset_setting_button_hotspot") then
					local var_17_7 = var_17_2.default_idx

					var_17_2.setting_idx = var_17_7

					var_17_2.on_setting_changed_cb(var_17_2.id, var_17_7)
				end
			end
		elseif var_17_3 == "slider" and var_17_4 and UIUtils.is_button_pressed(var_17_1, "reset_setting_button_hotspot") then
			local var_17_8 = var_17_2.default_idx

			var_17_2.setting_idx = var_17_8
			var_17_2.current_slider_value = var_17_8 / var_17_2.num_settings

			var_17_2.on_setting_changed_cb(var_17_2.id, var_17_8)
		end
	end

	local var_17_9 = arg_17_0._parent:window_input_service()

	if arg_17_0._custom_settings_toggled and var_17_9:get("toggle_menu", true) then
		arg_17_0._parent:close_menu()
	end
end

function StartGameWindowVersusCustomGameSettings._is_list_hovered(arg_18_0)
	return arg_18_0._widgets_by_name.mask.content.hotspot.is_hover
end

function StartGameWindowVersusCustomGameSettings._update_focus_overlay(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	if not arg_19_0._settings_widgets then
		return
	end

	local var_19_0 = arg_19_0._settings_widgets

	for iter_19_0 = 1, #var_19_0 do
		local var_19_1 = var_19_0[iter_19_0].content
		local var_19_2 = arg_19_0._custom_settings_toggled or arg_19_0._input_focused

		var_19_1.focused = var_19_2

		local var_19_3 = var_19_1.fade_progress or 0
		local var_19_4 = 25

		if var_19_2 then
			var_19_3 = math.min(var_19_3 + arg_19_1 * var_19_4, 1)
		else
			var_19_3 = math.max(var_19_3 - arg_19_1 * var_19_4, 0)
		end

		var_19_1.fade_progress = var_19_3
	end
end
