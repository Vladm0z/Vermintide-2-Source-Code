-- chunkname: @scripts/ui/views/level_end/states/end_view_state_weave.lua

require("scripts/helpers/weave_utils")
require("scripts/ui/ui_widgets_weaves")

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_weave_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.hero_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = var_0_0.update_bar_progress
local var_0_6 = var_0_0.generic_input_actions
local var_0_7 = 430
local var_0_8 = var_0_7 - 20

local function var_0_9(arg_1_0, arg_1_1)
	for iter_1_0 = 1, #arg_1_1 do
		UIRenderer.draw_widget(arg_1_0, arg_1_1[iter_1_0])
	end
end

EndViewStateWeave = class(EndViewStateWeave)
EndViewStateWeave.NAME = "EndViewStateWeave"

EndViewStateWeave.on_enter = function (arg_2_0, arg_2_1)
	print("[PlayState] Enter Substate EndViewStateWeave")

	arg_2_0.parent = arg_2_1.parent
	arg_2_0.game_won = arg_2_1.game_won
	arg_2_0.game_mode_key = arg_2_1.game_mode_key

	local var_2_0 = arg_2_1.context

	arg_2_0._context = var_2_0
	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0.ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0.wwise_world = var_2_0.wwise_world
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	arg_2_0.world_previewer = arg_2_1.world_previewer
	arg_2_0.platform = PLATFORM
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0.weave_personal_best_achieved = var_2_0.weave_personal_best_achieved
	arg_2_0.weave_personal_best_ranking = var_2_0.weave_personal_best_ranking
	arg_2_0._completed_weave = var_2_0.completed_weave
	arg_2_0._animations = {}
	arg_2_0._ui_animations = {}
	arg_2_0._player_count = Managers.weave:get_num_players()
	arg_2_0._exit_timer = nil
	arg_2_0._screen_done = false
	arg_2_0._selected_profile = 1

	if arg_2_1.initial_state then
		arg_2_0._initial_preview = true
		arg_2_1.initial_state = nil
	end

	arg_2_0:create_ui_elements(arg_2_1)
	arg_2_0:_start_transition_animation("on_enter", "transition_enter")
	arg_2_0:_setup_team_results(arg_2_0._context.players_session_score)
	arg_2_0:_play_sound("play_gui_mission_summary_wom_appear")
	arg_2_0.parent:_push_mouse_cursor()
end

EndViewStateWeave.exit = function (arg_3_0, arg_3_1)
	arg_3_0._exit_started = true

	arg_3_0:_start_transition_animation("on_enter", "transition_exit")

	local var_3_0 = 0.5
	local var_3_1 = 2.5
	local var_3_2 = 55

	arg_3_0.parent:start_camera_look_up(var_3_0, var_3_1, var_3_2)
	arg_3_0:_play_sound("stop_gui_mission_summary_wom")
end

EndViewStateWeave.exit_done = function (arg_4_0)
	return arg_4_0._exit_started and arg_4_0._animations.on_enter == nil
end

EndViewStateWeave.done = function (arg_5_0)
	return arg_5_0._screen_done or arg_5_0.parent:get_all_signaled_done()
end

EndViewStateWeave.create_ui_elements = function (arg_6_0, arg_6_1)
	arg_6_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_3)

	local var_6_0 = {}
	local var_6_1 = {}

	for iter_6_0, iter_6_1 in pairs(var_0_1) do
		local var_6_2 = UIWidget.init(iter_6_1)

		var_6_0[#var_6_0 + 1] = var_6_2
		var_6_1[iter_6_0] = var_6_2
	end

	arg_6_0._widgets = var_6_0
	arg_6_0._widgets_by_name = var_6_1
	arg_6_0._hero_widgets = {}
	arg_6_0._hero_insignias = {}
	arg_6_0._ready_button_widget = var_6_1.ready_button
	arg_6_0._ready_timer_widget = var_6_1.ready_timer
	arg_6_0._player_name_widgets = {}
	var_6_1.highscore_sigil.content.visible = false
	var_6_1.highscore_ribbon.content.visible = false
	var_6_1.highscore_text.content.visible = false

	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_renderer)

	arg_6_0.ui_animator = UIAnimator:new(arg_6_0.ui_scenegraph, var_0_4)
	arg_6_0._menu_input_description = MenuInputDescriptionUI:new(nil, arg_6_0.ui_top_renderer, Managers.input:get_service("end_of_level"), 4, 900, var_0_6.default)

	arg_6_0._menu_input_description:set_input_description(var_0_6.show_profile)
end

EndViewStateWeave._wanted_state = function (arg_7_0)
	return (arg_7_0.parent:wanted_menu_state())
end

EndViewStateWeave.set_input_manager = function (arg_8_0, arg_8_1)
	arg_8_0.input_manager = arg_8_1
end

EndViewStateWeave.on_exit = function (arg_9_0, arg_9_1)
	print("[PlayState] Exit Substate EndViewStateWeave")

	arg_9_0.ui_animator = nil
end

EndViewStateWeave._update_transition_timer = function (arg_10_0, arg_10_1)
	if not arg_10_0._transition_timer then
		return
	end

	if arg_10_0._transition_timer == 0 then
		arg_10_0._transition_timer = nil
	else
		arg_10_0._transition_timer = math.max(arg_10_0._transition_timer - arg_10_1, 0)
	end
end

EndViewStateWeave.update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0.input_manager:get_service("end_of_level")

	arg_11_0:draw(var_11_0, arg_11_1)
	arg_11_0:_update_transition_timer(arg_11_1)
	arg_11_0:_update_ready(arg_11_1, arg_11_2)

	local var_11_1 = arg_11_0:_wanted_state()

	if not arg_11_0._transition_timer and (var_11_1 or arg_11_0._new_state) then
		arg_11_0.parent:clear_wanted_menu_state()

		return var_11_1 or arg_11_0._new_state
	end

	arg_11_0.ui_animator:update(arg_11_1)
	arg_11_0:_update_animations(arg_11_1)

	if not arg_11_0.parent:transitioning() and not arg_11_0._transition_timer then
		if Managers.input:is_device_active("gamepad") then
			arg_11_0:_handle_gamepad_input(arg_11_1, arg_11_2)
		else
			arg_11_0:_handle_input(arg_11_1, arg_11_2)
		end
	end
end

EndViewStateWeave._update_ready = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0.parent:is_force_shutdown_active()
	local var_12_1 = arg_12_0._ready_timer_widget

	var_12_1.content.active = var_12_0 == true

	if var_12_0 then
		local var_12_2, var_12_3 = arg_12_0.parent:get_force_shutdown_time()
		local var_12_4 = 0

		if var_12_2 and var_12_3 then
			var_12_4 = 1 - var_12_2 / var_12_3
		end

		var_0_5(var_12_1, var_12_4, arg_12_2)
	end
end

EndViewStateWeave._handle_input = function (arg_13_0, arg_13_1, arg_13_2)
	if UIUtils.is_button_hover_enter(arg_13_0._ready_button_widget) then
		arg_13_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if UIUtils.is_button_pressed(arg_13_0._ready_button_widget) then
		arg_13_0:_play_sound("play_gui_mission_summary_button_return_to_keep_click")

		arg_13_0._ready_button_widget.content.button_hotspot.disable_button = true

		if arg_13_0.parent._left_lobby then
			arg_13_0._screen_done = true
		else
			arg_13_0.parent:signal_done(false)
		end
	end
end

EndViewStateWeave._handle_gamepad_input = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = Managers.input:get_service("end_of_level")

	if var_14_0:get("confirm_press") then
		arg_14_0:_play_sound("play_gui_mission_summary_button_return_to_keep_click")

		arg_14_0._ready_button_widget.content.button_hotspot.disable_button = true

		if arg_14_0.parent._left_lobby then
			arg_14_0._screen_done = true
		else
			arg_14_0.parent:signal_done(false)
		end
	elseif var_14_0:get("move_left") then
		local var_14_1 = arg_14_0._selected_profile
		local var_14_2 = math.clamp(var_14_1 - 1, 1, arg_14_0._player_count)

		if var_14_2 ~= var_14_1 then
			arg_14_0:_play_sound("play_gui_start_menu_button_hover")
			arg_14_0:_move_profile_selector(var_14_2)
		end
	elseif var_14_0:get("move_right") then
		local var_14_3 = arg_14_0._selected_profile
		local var_14_4 = math.clamp(var_14_3 + 1, 1, arg_14_0._player_count)

		if var_14_4 ~= var_14_3 then
			arg_14_0:_play_sound("play_gui_start_menu_button_hover")
			arg_14_0:_move_profile_selector(var_14_4)
		end
	elseif var_14_0:get("special_1_press") then
		local var_14_5 = arg_14_0._context.players_session_score
		local var_14_6 = {}

		for iter_14_0 in pairs(var_14_5) do
			table.insert(var_14_6, iter_14_0)
		end

		table.sort(var_14_6)

		local var_14_7 = var_14_5[var_14_6[arg_14_0._selected_profile]]

		if var_14_7 then
			arg_14_0:_show_profile_by_peer_id(var_14_7.peer_id)
		end
	end
end

EndViewStateWeave._show_profile_by_peer_id = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.platform

	if IS_WINDOWS and rawget(_G, "Steam") then
		local var_15_1 = Steam.id_hex_to_dec(arg_15_1)
		local var_15_2 = "http://steamcommunity.com/profiles/" .. var_15_1

		Steam.open_url(var_15_2)
	elseif IS_XB1 then
		local var_15_3 = arg_15_0._context.lobby:xuid(arg_15_1)

		if var_15_3 then
			XboxLive.show_gamercard(Managers.account:user_id(), var_15_3)
		end
	elseif IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_15_1)
	end
end

EndViewStateWeave._update_animations = function (arg_16_0, arg_16_1)
	for iter_16_0, iter_16_1 in pairs(arg_16_0._ui_animations) do
		UIAnimation.update(iter_16_1, arg_16_1)

		if UIAnimation.completed(iter_16_1) then
			arg_16_0._ui_animations[iter_16_0] = nil
		end
	end

	local var_16_0 = arg_16_0._animations
	local var_16_1 = arg_16_0.ui_animator

	for iter_16_2, iter_16_3 in pairs(var_16_0) do
		if var_16_1:is_animation_completed(iter_16_3) then
			var_16_1:stop_animation(iter_16_3)

			var_16_0[iter_16_2] = nil
		end
	end

	UIWidgetUtils.animate_default_button(arg_16_0._ready_button_widget, arg_16_1)

	local var_16_2 = arg_16_0.score_count_index
	local var_16_3 = arg_16_0.score_count_queue

	if var_16_2 and var_16_0.score_count == nil and var_16_0.total_score_count == nil then
		local var_16_4 = var_16_3 and var_16_3[var_16_2]

		if var_16_4 then
			arg_16_0:_start_score_count_animation("score_count", "score_entry", var_16_4[1])
			arg_16_0:_start_score_count_animation("total_score_count", "score_entry", var_16_4[2])

			arg_16_0.score_count_index = var_16_2 + 1
		else
			arg_16_0.score_count_index = nil

			if arg_16_0.weave_personal_best_achieved then
				arg_16_0:_start_transition_animation("highscore_presentation", "highscore_presentation")
			end
		end
	end
end

EndViewStateWeave.draw = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_top_renderer
	local var_17_2 = arg_17_0.ui_scenegraph
	local var_17_3 = arg_17_0.render_settings
	local var_17_4 = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(var_17_1, var_17_2, arg_17_1, arg_17_2, nil, var_17_3)
	var_0_9(var_17_1, arg_17_0._widgets)
	var_0_9(var_17_1, arg_17_0._hero_widgets)
	var_0_9(var_17_1, arg_17_0._player_name_widgets)
	var_0_9(var_17_1, arg_17_0._hero_insignias)
	UIRenderer.end_pass(var_17_1)

	if var_17_4 then
		arg_17_0._menu_input_description:draw(var_17_1, arg_17_2)
	end
end

EndViewStateWeave._start_transition_animation = function (arg_18_0, arg_18_1, arg_18_2)
	local var_18_0 = {
		wwise_world = arg_18_0.wwise_world,
		render_settings = arg_18_0.render_settings
	}
	local var_18_1 = arg_18_0._widgets_by_name
	local var_18_2 = arg_18_0.ui_animator:start_animation(arg_18_2, var_18_1, var_0_3, var_18_0)

	arg_18_0._animations[arg_18_1] = var_18_2
end

EndViewStateWeave._start_score_count_animation = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = {}

	arg_19_3.start_font_size = arg_19_3.widget.style.text.font_size
	arg_19_3.peak_font_size = arg_19_3.widget.style.text.font_size * 1.5
	arg_19_3.wwise_world = arg_19_0.wwise_world

	local var_19_1 = arg_19_0.ui_animator:start_animation(arg_19_2, var_19_0, var_0_3, arg_19_3)

	arg_19_0._animations[arg_19_1] = var_19_1
end

EndViewStateWeave._animate_element_by_time = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, math.ease_out_quad))
end

EndViewStateWeave._animate_element_by_catmullrom = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8))
end

EndViewStateWeave._setup_team_results = function (arg_22_0, arg_22_1)
	local var_22_0 = {}

	for iter_22_0 in pairs(arg_22_1) do
		table.insert(var_22_0, iter_22_0)
	end

	table.sort(var_22_0)

	for iter_22_1 = 1, #var_22_0 do
		local var_22_1 = arg_22_1[var_22_0[iter_22_1]]
		local var_22_2 = var_22_1.peer_id
		local var_22_3 = var_22_1.profile_index
		local var_22_4 = var_22_1.career_index
		local var_22_5 = SPProfiles[var_22_3].careers[var_22_4].portrait_image
		local var_22_6 = var_22_1.portrait_frame
		local var_22_7 = var_22_1.player_level
		local var_22_8 = var_22_1.is_player_controlled
		local var_22_9 = var_22_8 and (var_22_7 and tostring(var_22_7) or "-") or "BOT"
		local var_22_10 = var_22_8 and Application.user_setting("toggle_versus_level_in_all_game_modes") and var_22_1.versus_player_level or 0

		arg_22_0:_fill_portrait(iter_22_1, var_22_6, var_22_9, var_22_5, var_22_1.name, var_22_10)
	end

	for iter_22_2 = #var_22_0 + 1, arg_22_0._player_count do
		arg_22_0:_fill_portrait(iter_22_2)
	end

	arg_22_0:_setup_score_panel()
	arg_22_0:_move_profile_selector(1)
end

EndViewStateWeave._move_profile_selector = function (arg_23_0, arg_23_1)
	local var_23_0 = arg_23_0._player_count
	local var_23_1 = arg_23_0._widgets_by_name.profile_selector
	local var_23_2 = var_0_7 * (arg_23_1 - var_23_0 / 2 - 0.5)

	var_23_1.offset = {
		var_23_2,
		0,
		0
	}
	arg_23_0._selected_profile = arg_23_1

	local var_23_3 = arg_23_0._context.players_session_score
	local var_23_4 = {}

	for iter_23_0 in pairs(var_23_3) do
		table.insert(var_23_4, iter_23_0)
	end

	table.sort(var_23_4)

	if var_23_3[var_23_4[arg_23_0._selected_profile]] then
		arg_23_0._menu_input_description:set_input_description(var_0_6.show_profile)
	else
		arg_23_0._menu_input_description:set_input_description(nil)
	end
end

EndViewStateWeave._fill_portrait = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	local var_24_0 = arg_24_0._player_count
	local var_24_1 = var_0_7 * (arg_24_1 - var_24_0 / 2 - 0.5)
	local var_24_2 = arg_24_2 or "default"
	local var_24_3 = arg_24_3 or ""
	local var_24_4 = arg_24_4 or "eor_empty_player"
	local var_24_5 = UIWidgets.create_portrait_frame("player_frame", var_24_2, var_24_3, 1, nil, var_24_4)
	local var_24_6 = arg_24_0._hero_widgets[arg_24_1]
	local var_24_7 = UIWidget.init(var_24_5, arg_24_0.ui_top_renderer)

	var_24_7.offset = {
		var_24_1,
		0,
		0
	}
	arg_24_0._hero_widgets[arg_24_1] = var_24_7

	local var_24_8 = UIWidgets.create_small_insignia("player_insignia", arg_24_6 or 0)
	local var_24_9 = UIWidget.init(var_24_8, arg_24_0.ui_top_renderer)

	var_24_9.offset = {
		var_24_1,
		0,
		0
	}
	arg_24_0._hero_insignias[arg_24_1] = var_24_9

	if arg_24_5 then
		local var_24_10 = UIRenderer.crop_text_width(arg_24_0.ui_renderer, arg_24_5, var_0_8, var_0_2.player_name.style.text)
		local var_24_11 = UIWidget.init(var_0_2.player_name)

		var_24_11.offset = {
			var_24_1,
			0,
			0
		}
		var_24_11.content.text = var_24_10
		arg_24_0._player_name_widgets[#arg_24_0._player_name_widgets + 1] = var_24_11
	end
end

EndViewStateWeave._setup_score_panel = function (arg_25_0)
	local var_25_0 = Managers.weave
	local var_25_1 = arg_25_0.game_won
	local var_25_2 = arg_25_0._completed_weave and WeaveSettings.templates[arg_25_0._completed_weave]
	local var_25_3 = ""
	local var_25_4 = ""

	if var_25_2 then
		var_25_4 = tostring(var_25_2.tier)
		var_25_3 = Localize(var_25_2.display_name)
	end

	local var_25_5 = var_25_0:get_time_left()
	local var_25_6 = math.max(WeaveSettings.max_time - math.floor(var_25_5), 0)
	local var_25_7 = var_25_6 % 60
	local var_25_8 = math.floor(var_25_6 / 60)
	local var_25_9 = var_25_1 and var_25_0:get_score() or 0
	local var_25_10 = var_25_0:get_time_score()
	local var_25_11 = var_25_0:get_damage_score()
	local var_25_12 = arg_25_0._widgets_by_name

	var_25_12.score_weave_num.content.text = Localize("lb_game_type_weave") .. " " .. var_25_4 .. ": " .. var_25_3
	var_25_12.total_time_value.content.text = string.format("%d %s %02d %s", var_25_8, Localize("weave_endscreen_min"), var_25_7, Localize("weave_endscreen_sec"))

	if var_25_1 then
		var_25_12.time_score_value.content.text = UIUtils.comma_value(0)
		var_25_12.damage_bonus_value.content.text = UIUtils.comma_value(0)
		var_25_12.total_score_value.content.text = UIUtils.comma_value(0)
		arg_25_0.score_count_queue = {
			{
				{
					start_value = 0,
					widget = var_25_12.time_score_value,
					end_value = var_25_10
				},
				{
					start_value = 0,
					widget = var_25_12.total_score_value,
					end_value = var_25_10
				}
			},
			{
				{
					start_value = 0,
					widget = var_25_12.damage_bonus_value,
					end_value = var_25_11
				},
				{
					widget = var_25_12.total_score_value,
					start_value = var_25_10,
					end_value = var_25_9
				}
			}
		}
		arg_25_0.score_count_index = 1
	else
		var_25_12.time_score_value.content.text = "-"
		var_25_12.damage_bonus_value.content.text = "-"
		var_25_12.total_score_value.content.text = UIUtils.comma_value(var_25_9)
	end
end

EndViewStateWeave._play_sound = function (arg_26_0, arg_26_1)
	arg_26_0.parent:play_sound(arg_26_1)
end
