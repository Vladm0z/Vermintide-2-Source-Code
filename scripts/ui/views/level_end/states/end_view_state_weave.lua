-- chunkname: @scripts/ui/views/level_end/states/end_view_state_weave.lua

require("scripts/helpers/weave_utils")
require("scripts/ui/ui_widgets_weaves")

local var_0_0 = local_require("scripts/ui/views/level_end/states/definitions/end_view_state_weave_definitions")
local widgets = var_0_0.widgets
local hero_widgets = var_0_0.hero_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local update_bar_progress = var_0_0.update_bar_progress
local generic_input_actions = var_0_0.generic_input_actions
local num = 430
local num_2 = num - 20

local function fn(arg_1_0, arg_1_1)
	-- function 1
	for i = 1, #arg_1_1 do
		UIRenderer.draw_widget(arg_1_0, arg_1_1[i])
	end
end

EndViewStateWeave = class(EndViewStateWeave)
EndViewStateWeave.NAME = "EndViewStateWeave"

EndViewStateWeave.on_enter = function (self, arg_2_1)
	-- function 2
	print("[PlayState] Enter Substate EndViewStateWeave")

	self.parent = arg_2_1.parent
	self.game_won = arg_2_1.game_won
	self.game_mode_key = arg_2_1.game_mode_key

	local context = arg_2_1.context

	self._context = context
	self.ui_renderer = context.ui_renderer
	self.ui_top_renderer = context.ui_top_renderer
	self.wwise_world = context.wwise_world
	self.input_manager = context.input_manager
	self.statistics_db = context.statistics_db
	self.render_settings = {
		alpha_multiplier = 0,
		snap_pixel_positions = true
	}
	self.world_previewer = arg_2_1.world_previewer
	self.platform = PLATFORM
	self.peer_id = context.peer_id
	self.weave_personal_best_achieved = context.weave_personal_best_achieved
	self.weave_personal_best_ranking = context.weave_personal_best_ranking
	self._completed_weave = context.completed_weave
	self._animations = {}
	self._ui_animations = {}
	self._player_count = Managers.weave:get_num_players()
	self._exit_timer = nil
	self._screen_done = false
	self._selected_profile = 1

	if not arg_2_1.initial_state then
		self._initial_preview = true
		arg_2_1.initial_state = nil
	end

	self:create_ui_elements(arg_2_1)
	self:_start_transition_animation("on_enter", "transition_enter")
	self:_setup_team_results(self._context.players_session_score)
	self:_play_sound("play_gui_mission_summary_wom_appear")
	self.parent:_push_mouse_cursor()
end

EndViewStateWeave.exit = function (self, arg_3_1)
	-- function 3
	self._exit_started = true

	self:_start_transition_animation("on_enter", "transition_exit")

	local num = 0.5
	local num_2 = 2.5
	local num_3 = 55

	self.parent:start_camera_look_up(num, num_2, num_3)
	self:_play_sound("stop_gui_mission_summary_wom")
end

EndViewStateWeave.exit_done = function (self)
	-- function 4
	local _exit_started = self._exit_started

	_exit_started = not _exit_started and self._animations.on_enter == nil

	return _exit_started
end

EndViewStateWeave.done = function (self)
	-- function 5
	local _screen_done = self._screen_done

	_screen_done = _screen_done or self.parent:get_all_signaled_done()

	return _screen_done
end

EndViewStateWeave.create_ui_elements = function (self, arg_6_1)
	-- function 6
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_6_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_6_2
		tbl_2[k] = var_6_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._hero_widgets = {}
	self._hero_insignias = {}
	self._ready_button_widget = tbl_2.ready_button
	self._ready_timer_widget = tbl_2.ready_timer
	self._player_name_widgets = {}
	tbl_2.highscore_sigil.content.visible = false
	tbl_2.highscore_ribbon.content.visible = false
	tbl_2.highscore_text.content.visible = false

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, Managers.input:get_service("end_of_level"), 4, 900, generic_input_actions.default)

	self._menu_input_description:set_input_description(generic_input_actions.show_profile)
end

EndViewStateWeave._wanted_state = function (self)
	-- function 7
	return (self.parent:wanted_menu_state())
end

EndViewStateWeave.set_input_manager = function (self, arg_8_1)
	-- function 8
	self.input_manager = arg_8_1
end

EndViewStateWeave.on_exit = function (self, arg_9_1)
	-- function 9
	print("[PlayState] Exit Substate EndViewStateWeave")

	self.ui_animator = nil
end

EndViewStateWeave._update_transition_timer = function (self, arg_10_1)
	-- function 10
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_10_1, 0)
	end
end

EndViewStateWeave.update = function (self, arg_11_1, arg_11_2)
	-- function 11
	local get_service = self.input_manager:get_service("end_of_level")

	self:draw(get_service, arg_11_1)
	self:_update_transition_timer(arg_11_1)
	self:_update_ready(arg_11_1, arg_11_2)

	local _wanted_state = self:_wanted_state()

	if self._transition_timer or _wanted_state or not self._new_state then
		self.parent:clear_wanted_menu_state()

		return _wanted_state or self._new_state
	end

	self.ui_animator:update(arg_11_1)
	self:_update_animations(arg_11_1)

	if not (self.parent:transitioning() or self._transition_timer) then
		if not Managers.input:is_device_active("gamepad") then
			self:_handle_gamepad_input(arg_11_1, arg_11_2)
		else
			self:_handle_input(arg_11_1, arg_11_2)
		end
	end
end

EndViewStateWeave._update_ready = function (self, arg_12_1, arg_12_2)
	-- function 12
	local is_force_shutdown_active = self.parent:is_force_shutdown_active()
	local _ready_timer_widget = self._ready_timer_widget

	_ready_timer_widget.content.active = is_force_shutdown_active == true

	if not is_force_shutdown_active then
		local get_force_shutdown_time, var_12_3 = self.parent:get_force_shutdown_time()
		local num = 0

		if not get_force_shutdown_time and not var_12_3 then
			num = 1 - get_force_shutdown_time / var_12_3
		end

		update_bar_progress(_ready_timer_widget, num, arg_12_2)
	end
end

EndViewStateWeave._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	if not UIUtils.is_button_hover_enter(self._ready_button_widget) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not UIUtils.is_button_pressed(self._ready_button_widget) then
		self:_play_sound("play_gui_mission_summary_button_return_to_keep_click")

		self._ready_button_widget.content.button_hotspot.disable_button = true

		if not self.parent._left_lobby then
			self._screen_done = true
		else
			self.parent:signal_done(false)
		end
	end
end

EndViewStateWeave._handle_gamepad_input = function (self, arg_14_1, arg_14_2)
	-- function 14
	local get_service = Managers.input:get_service("end_of_level")

	if not get_service:get("confirm_press") then
		self:_play_sound("play_gui_mission_summary_button_return_to_keep_click")

		self._ready_button_widget.content.button_hotspot.disable_button = true

		if not self.parent._left_lobby then
			self._screen_done = true
		else
			self.parent:signal_done(false)
		end
	elseif not get_service:get("move_left") then
		local _selected_profile = self._selected_profile
		local clamp = math.clamp(_selected_profile - 1, 1, self._player_count)

		if clamp ~= _selected_profile then
			self:_play_sound("play_gui_start_menu_button_hover")
			self:_move_profile_selector(clamp)
		end
	elseif not get_service:get("move_right") then
		local _selected_profile_2 = self._selected_profile
		local clamp_2 = math.clamp(_selected_profile_2 + 1, 1, self._player_count)

		if clamp_2 ~= _selected_profile_2 then
			self:_play_sound("play_gui_start_menu_button_hover")
			self:_move_profile_selector(clamp_2)
		end
	elseif not get_service:get("special_1_press") then
		local players_session_score = self._context.players_session_score
		local tbl = {}

		for k in pairs(players_session_score) do
			table.insert(tbl, k)
		end

		table.sort(tbl)

		local var_14_7 = players_session_score[tbl[self._selected_profile]]

		if not var_14_7 then
			self:_show_profile_by_peer_id(var_14_7.peer_id)
		end
	end
end

EndViewStateWeave._show_profile_by_peer_id = function (self, arg_15_1)
	-- function 15
	local platform = self.platform

	if not IS_WINDOWS and not rawget(_G, "Steam") then
		local id_hex_to_dec = Steam.id_hex_to_dec(arg_15_1)
		local str = "http://steamcommunity.com/profiles/" .. id_hex_to_dec

		Steam.open_url(str)
	elseif not IS_XB1 then
		local xuid = self._context.lobby:xuid(arg_15_1)

		if not xuid then
			XboxLive.show_gamercard(Managers.account:user_id(), xuid)
		end
	elseif not IS_PS4 then
		Managers.account:show_player_profile_with_account_id(arg_15_1)
	end
end

EndViewStateWeave._update_animations = function (self, arg_16_1)
	-- function 16
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_16_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	UIWidgetUtils.animate_default_button(self._ready_button_widget, arg_16_1)

	local score_count_index = self.score_count_index
	local score_count_queue = self.score_count_queue

	if not score_count_index and not (_animations.score_count ~= nil or _animations.total_score_count == nil) then
		local flag = not score_count_queue and score_count_queue[score_count_index]

		if not flag then
			self:_start_score_count_animation("score_count", "score_entry", flag[1])
			self:_start_score_count_animation("total_score_count", "score_entry", flag[2])

			self.score_count_index = score_count_index + 1
		else
			self.score_count_index = nil

			if not self.weave_personal_best_achieved then
				self:_start_transition_animation("highscore_presentation", "highscore_presentation")
			end
		end
	end
end

EndViewStateWeave.draw = function (self, arg_17_1, arg_17_2)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local render_settings = self.render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_17_1, arg_17_2, nil, render_settings)
	fn(ui_top_renderer, self._widgets)
	fn(ui_top_renderer, self._hero_widgets)
	fn(ui_top_renderer, self._player_name_widgets)
	fn(ui_top_renderer, self._hero_insignias)
	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(ui_top_renderer, arg_17_2)
	end
end

EndViewStateWeave._start_transition_animation = function (self, arg_18_1, arg_18_2)
	-- function 18
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation(arg_18_2, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_18_1] = start_animation
end

EndViewStateWeave._start_score_count_animation = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local tbl = {}

	arg_19_3.start_font_size = arg_19_3.widget.style.text.font_size
	arg_19_3.peak_font_size = arg_19_3.widget.style.text.font_size * 1.5
	arg_19_3.wwise_world = self.wwise_world

	local start_animation = self.ui_animator:start_animation(arg_19_2, tbl, scenegraph_definition, arg_19_3)

	self._animations[arg_19_1] = start_animation
end

EndViewStateWeave._animate_element_by_time = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	return (UIAnimation.init(UIAnimation.function_by_time, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, math.ease_out_quad))
end

EndViewStateWeave._animate_element_by_catmullrom = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8)
	-- function 21
	return (UIAnimation.init(UIAnimation.catmullrom, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5, arg_21_6, arg_21_7, arg_21_8))
end

EndViewStateWeave._setup_team_results = function (self, arg_22_1)
	-- function 22
	local tbl = {}

	for k in pairs(arg_22_1) do
		table.insert(tbl, k)
	end

	table.sort(tbl)

	for j = 1, #tbl do
		local var_22_1 = arg_22_1[tbl[j]]
		local peer_id = var_22_1.peer_id
		local profile_index = var_22_1.profile_index
		local career_index = var_22_1.career_index
		local portrait_image = SPProfiles[profile_index].careers[career_index].portrait_image
		local portrait_frame = var_22_1.portrait_frame
		local player_level = var_22_1.player_level
		local is_player_controlled = var_22_1.is_player_controlled
		local var_22_9

		if not is_player_controlled then
			if not player_level then
				var_22_9 = tostring(player_level)

				if not var_22_9 then
					-- Nothing
				end
			end

			var_22_9 = "-"
		else
			var_22_9 = "BOT"
		end

		do
			local versus_player_level
		end

		::label_22_0::

		if not is_player_controlled and not Application.user_setting("toggle_versus_level_in_all_game_modes") then
			versus_player_level = var_22_1.versus_player_level

			if not versus_player_level then
				-- Nothing
			end
		end

		versus_player_level = 0

		::label_22_1::

		self:_fill_portrait(j, portrait_frame, var_22_9, portrait_image, var_22_1.name, versus_player_level)
	end

	for k_2 = #tbl + 1, self._player_count do
		self:_fill_portrait(k_2)
	end

	self:_setup_score_panel()
	self:_move_profile_selector(1)
end

EndViewStateWeave._move_profile_selector = function (self, arg_23_1)
	-- function 23
	local _player_count = self._player_count
	local profile_selector = self._widgets_by_name.profile_selector
	local num_2 = num * (arg_23_1 - _player_count / 2 - 0.5)

	profile_selector.offset = {
		num_2,
		0,
		0
	}
	self._selected_profile = arg_23_1

	local players_session_score = self._context.players_session_score
	local tbl = {}

	for k in pairs(players_session_score) do
		table.insert(tbl, k)
	end

	table.sort(tbl)

	if not players_session_score[tbl[self._selected_profile]] then
		self._menu_input_description:set_input_description(generic_input_actions.show_profile)
	else
		self._menu_input_description:set_input_description(nil)
	end
end

EndViewStateWeave._fill_portrait = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	local _player_count = self._player_count
	local num_3 = num * (arg_24_1 - _player_count / 2 - 0.5)
	local flag = arg_24_2 or "default"
	local flag_2 = arg_24_3 or ""
	local flag_3 = arg_24_4 or "eor_empty_player"
	local create_portrait_frame = UIWidgets.create_portrait_frame("player_frame", flag, flag_2, 1, nil, flag_3)
	local var_24_6 = self._hero_widgets[arg_24_1]
	local var_24_7 = UIWidget.init(create_portrait_frame, self.ui_top_renderer)

	var_24_7.offset = {
		num_3,
		0,
		0
	}
	self._hero_widgets[arg_24_1] = var_24_7

	local create_small_insignia = UIWidgets.create_small_insignia("player_insignia", arg_24_6 or 0)
	local var_24_9 = UIWidget.init(create_small_insignia, self.ui_top_renderer)

	var_24_9.offset = {
		num_3,
		0,
		0
	}
	self._hero_insignias[arg_24_1] = var_24_9

	if not arg_24_5 then
		local crop_text_width = UIRenderer.crop_text_width(self.ui_renderer, arg_24_5, num_2, hero_widgets.player_name.style.text)
		local var_24_11 = UIWidget.init(hero_widgets.player_name)

		var_24_11.offset = {
			num_3,
			0,
			0
		}
		var_24_11.content.text = crop_text_width
		self._player_name_widgets[#self._player_name_widgets + 1] = var_24_11
	end
end

EndViewStateWeave._setup_score_panel = function (self)
	-- function 25
	local weave = Managers.weave
	local game_won = self.game_won
	local _completed_weave = self._completed_weave

	_completed_weave = not _completed_weave and WeaveSettings.templates[self._completed_weave]

	local str = ""
	local str_2 = ""

	if not _completed_weave then
		str_2 = tostring(_completed_weave.tier)
		str = Localize(_completed_weave.display_name)
	end

	local get_time_left = weave:get_time_left()
	local max = math.max(WeaveSettings.max_time - math.floor(get_time_left), 0)
	local num = max % 60
	local floor = math.floor(max / 60)
	local get_score

	if not game_won then
		get_score = weave:get_score()

		if not get_score then
			-- Nothing
		end
	end

	get_score = 0

	::label_25_0::

	local get_time_score = weave:get_time_score()
	local get_damage_score = weave:get_damage_score()
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.score_weave_num.content.text = Localize("lb_game_type_weave") .. " " .. str_2 .. ": " .. str
	_widgets_by_name.total_time_value.content.text = string.format("%d %s %02d %s", floor, Localize("weave_endscreen_min"), num, Localize("weave_endscreen_sec"))

	if not game_won then
		_widgets_by_name.time_score_value.content.text = UIUtils.comma_value(0)
		_widgets_by_name.damage_bonus_value.content.text = UIUtils.comma_value(0)
		_widgets_by_name.total_score_value.content.text = UIUtils.comma_value(0)
		self.score_count_queue = {
			{
				{
					start_value = 0,
					widget = _widgets_by_name.time_score_value,
					end_value = get_time_score
				},
				{
					start_value = 0,
					widget = _widgets_by_name.total_score_value,
					end_value = get_time_score
				}
			},
			{
				{
					start_value = 0,
					widget = _widgets_by_name.damage_bonus_value,
					end_value = get_damage_score
				},
				{
					widget = _widgets_by_name.total_score_value,
					start_value = get_time_score,
					end_value = get_score
				}
			}
		}
		self.score_count_index = 1
	else
		_widgets_by_name.time_score_value.content.text = "-"
		_widgets_by_name.damage_bonus_value.content.text = "-"
		_widgets_by_name.total_score_value.content.text = UIUtils.comma_value(get_score)
	end
end

EndViewStateWeave._play_sound = function (self, arg_26_1)
	-- function 26
	self.parent:play_sound(arg_26_1)
end
