-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_custom_game.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_custom_game_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widgets = var_0_0.widgets
local selection_widgets = var_0_0.selection_widgets
local animation_definitions = var_0_0.animation_definitions
local selector_input_definitions = var_0_0.selector_input_definitions

StartGameWindowDeusCustomGame = class(StartGameWindowDeusCustomGame)
StartGameWindowDeusCustomGame.NAME = "StartGameWindowDeusCustomGame"

local str = "refresh_press"

StartGameWindowDeusCustomGame.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusCustomGame")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._mechanism_name = Managers.mechanism:current_mechanism_name()
	self._stats_id = Managers.player:local_player():stats_id()
	self._expeditions_selection_index = 1
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._is_focused = false
	self._play_button_pressed = false
	self._previous_can_play = nil
	self._is_offline = Managers.account:offline_mode()
	self._animations = {}
	self._dlc_name = nil

	local get_difficulty_option = self._parent:get_difficulty_option(true)

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()
	self._current_difficulty = get_difficulty_option
	self._backend_deus = Managers.backend:get_interface("deus")

	self:_create_ui_elements(arg_1_1, arg_1_2)

	local var_1_2 = self
	local _gamepad_selector_input_func = self._gamepad_selector_input_func
	local input_index = arg_1_1.input_index

	input_index = input_index or 1

	_gamepad_selector_input_func(var_1_2, input_index)
	self:_update_expedition_option()
	self:_update_difficulty_option(self._current_difficulty)
	self:_update_can_play()

	if not self._is_offline then
		self._parent:change_generic_actions("default_deus_custom_game_offline")
	else
		self._parent:change_generic_actions("default_deus_custom_game")
	end

	self:_start_transition_animation("on_enter")
	Managers.state.event:register(self, "_update_additional_curse_frame", "_update_additional_curse_frame")
end

StartGameWindowDeusCustomGame._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

local function fn(self, arg_3_1)
	-- function 3
	return self.remaining_time - (arg_3_1 - self.time_of_update) < 0
end

StartGameWindowDeusCustomGame._create_ui_elements = function (self, arg_4_1, arg_4_2)
	-- function 4
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_scenegraph = init_scenegraph
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(widgets)
	self._selection_widgets, self._selection_widgets_by_name = UIUtils.create_widgets(selection_widgets)

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)

	self._ui_animator = UIAnimator:new(init_scenegraph, animation_definitions)

	if not arg_4_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_4_2[1]
		local_position[2] = local_position[2] + arg_4_2[2]
		local_position[3] = local_position[3] + arg_4_2[3]
	end

	self._widgets_by_name.difficulty_info.content.visible = false
	self._widgets_by_name.upsell_button.content.visible = false

	self:_gather_unlocked_journeys()
	self:_setup_journey_widgets()
	self:_refresh_journey_cycle()
end

StartGameWindowDeusCustomGame.on_exit = function (self, arg_5_1)
	-- function 5
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusCustomGame")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_5_1.input_index = nil
	else
		arg_5_1.input_index = self._input_index
	end

	self._parent:set_difficulty_option(self._current_difficulty)
	Managers.state.event:unregister("_update_additional_curse_frame", self)
end

StartGameWindowDeusCustomGame.set_focus = function (self, arg_6_1)
	-- function 6
	self._is_focused = arg_6_1
end

StartGameWindowDeusCustomGame.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowDeusCustomGame._can_play = function (self)
	-- function 8
	local get_selected_level_id = self._parent:get_selected_level_id()

	if not (get_selected_level_id == nil or not self._dlc_locked) then
		return false
	end

	if not LevelUnlockUtils.is_journey_disabled(get_selected_level_id) then
		return false
	end

	local dominant_god = self._journey_cycle.journey_data[get_selected_level_id].dominant_god

	return not LevelUnlockUtils.is_chaos_waste_god_disabled(dominant_god)
end

StartGameWindowDeusCustomGame._update_can_play = function (self)
	-- function 9
	local _can_play = self:_can_play()

	self._selection_widgets_by_name.play_button.content.button_hotspot.disable_button = not _can_play

	local flag

	flag = not self._is_offline and "default_deus_custom_game_offline" and "default_deus_custom_game"

	if not _can_play then
		flag = not self._is_offline and "default_deus_custom_game_offline_play" and "default_deus_custom_game_play"
	elseif not self._dlc_locked then
		flag = not self._is_offline and "default_deus_custom_game_offline_buy" and "default_deus_custom_game_buy"
	end

	if flag ~= self._prev_input_desc then
		self._parent:set_input_description(flag)

		self._prev_input_desc = flag
	end
end

StartGameWindowDeusCustomGame._gather_unlocked_journeys = function (self)
	-- function 10
	local tbl = {}

	for i, v in ipairs(LevelUnlockUtils.unlocked_journeys(self._statistics_db, self._stats_id)) do
		tbl[v] = true
	end

	local journey_data = self._backend_deus:get_journey_cycle().journey_data

	for k, v_2 in pairs(tbl) do
		if not LevelUnlockUtils.is_chaos_waste_god_disabled(journey_data[k].dominant_god) then
			tbl[k] = nil
		end
	end

	self._unlocked_journeys = tbl
end

StartGameWindowDeusCustomGame._setup_journey_widgets = function (self)
	-- function 11
	local _node_widgets = self._node_widgets
	local _statistics_db = self._statistics_db
	local _stats_id = self._stats_id
	local _unlocked_journeys = self._unlocked_journeys
	local tbl = {}
	local num = -365
	local journey_widget_settings = var_0_0.journey_widget_settings
	local AvailableJourneyOrder = AvailableJourneyOrder

	for i = 1, #AvailableJourneyOrder do
		local var_11_8 = AvailableJourneyOrder[i]
		local deus_journey_with_belakor = self._backend_deus:deus_journey_with_belakor(var_11_8)
		local var_11_10 = DeusJourneySettings[var_11_8]
		local num_2 = #tbl + 1
		local var_11_12 = AvailableJourneyOrder[num_2 + 1]
		local create_expedition_widget_func = UIWidgets.create_expedition_widget_func("level_root_node", num_2, var_11_10, var_11_8)
		local var_11_14 = UIWidget.init(create_expedition_widget_func)
		local content = var_11_14.content

		content.text = Localize(var_11_10.display_name)
		num = num + (journey_widget_settings.width + journey_widget_settings.spacing_x)

		local offset = var_11_14.offset

		offset[1] = num
		offset[2] = 0

		local completed_journey_difficulty_index = LevelUnlockUtils.completed_journey_difficulty_index(_statistics_db, _stats_id, var_11_8)
		local get_level_frame_by_difficulty_index = UIWidgetUtils.get_level_frame_by_difficulty_index(completed_journey_difficulty_index)
		local var_11_19 = _unlocked_journeys[var_11_8]

		content.level_icon = var_11_10.level_image
		content.locked = not var_11_19
		content.frame = get_level_frame_by_difficulty_index
		content.journey_name = var_11_8

		local flag

		flag = not deus_journey_with_belakor and "morris_expedition_select_border_belakor" and "morris_expedition_select_border"
		content.level_icon_frame = flag
		content.draw_path = var_11_12 ~= nil
		content.draw_path_fill = _unlocked_journeys[var_11_12]
		var_11_14.style.path.texture_size[1] = journey_widget_settings.spacing_x
		var_11_14.style.path_glow.texture_size[1] = journey_widget_settings.spacing_x
		tbl[num_2] = var_11_14
		num = num + journey_widget_settings.spacing_x
	end

	self._expedition_widgets = tbl
end

StartGameWindowDeusCustomGame._set_info_window = function (self, arg_12_1)
	-- function 12
	local var_12_0 = DifficultySettings[arg_12_1]
	local description = var_12_0.description
	local max_chest_power_level = var_12_0.max_chest_power_level
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.difficulty_description = Localize(description)
	difficulty_info.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)
end

StartGameWindowDeusCustomGame._update_difficulty_option = function (self, arg_13_1)
	-- function 13
	if not arg_13_1 then
		local var_13_0 = DifficultySettings[arg_13_1]
		local difficulty_stepper = self._selection_widgets_by_name.difficulty_stepper

		difficulty_stepper.content.selected_difficulty_text = Localize(var_13_0.display_name)

		local display_image = var_13_0.display_image

		difficulty_stepper.content.difficulty_icon = display_image

		self:_set_info_window(arg_13_1)

		self._current_difficulty = arg_13_1
	end
end

StartGameWindowDeusCustomGame._option_selected = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	local _parent = self._parent
	local get_custom_game_settings = _parent:get_custom_game_settings(self._mechanism_name)

	get_custom_game_settings = get_custom_game_settings or _parent:get_custom_game_settings("adventure")

	if arg_14_1 == "difficulty_stepper" then
		local _current_difficulty = self._current_difficulty
		local difficulties = GameModeSettings.deus.difficulties
		local find = table.find(difficulties, _current_difficulty)
		local num = 0

		if arg_14_2 == "left_arrow" then
			if find - 1 >= 1 then
				num = find - 1

				self._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif not (arg_14_2 ~= "right_arrow" or not (find + 1 <= #difficulties)) then
			num = find + 1

			self._parent:play_sound("hud_morris_start_menu_set")
		end

		self:_update_difficulty_option(difficulties[num])
	elseif arg_14_1 == "play_button" then
		self._play_button_pressed = true

		self._parent:set_difficulty_option(self._current_difficulty)
		self._parent:play(arg_14_3, get_custom_game_settings.game_mode_type)
	end
end

StartGameWindowDeusCustomGame._update_modifiers = function (self, arg_15_1)
	-- function 15
	local _journey_cycle = self._journey_cycle

	if not _journey_cycle and not fn(_journey_cycle, arg_15_1) then
		self:_refresh_journey_cycle()
	end
end

StartGameWindowDeusCustomGame._update_modifier_timer = function (self, arg_16_1)
	-- function 16
	local _journey_cycle = self._journey_cycle
	local num = _journey_cycle.remaining_time - (arg_16_1 - _journey_cycle.time_of_update)

	if num < 0 then
		num = 0
	end

	local floor = math.floor
	local var_16_3 = floor(num / 86400)
	local var_16_4 = floor(num / 3600)
	local num_2 = floor(num / 60) % 60
	local content = self._widgets_by_name.modifier_timer.content

	if num_2 > 0 then
		local var_16_7 = Localize("deus_start_game_mod_timer")

		content.time_text = string.format(var_16_7, var_16_3, var_16_4, num_2)
	else
		local var_16_8 = floor(num)
		local var_16_9 = Localize("deus_start_game_mod_timer_seconds")

		content.time_text = string.format(var_16_9, var_16_8)
	end
end

StartGameWindowDeusCustomGame._refresh_journey_cycle = function (self)
	-- function 17
	self._journey_cycle = self._backend_deus:get_journey_cycle()

	self:_update_journey_god_icons()
end

StartGameWindowDeusCustomGame._update_additional_curse_frame = function (self, arg_18_1)
	-- function 18
	for i, v in ipairs(self._expedition_widgets) do
		local content = v.content
		local flag

		flag = not (content.journey_name == arg_18_1) and "morris_expedition_select_border_belakor" and "morris_expedition_select_border"
		content.level_icon_frame = flag
	end
end

StartGameWindowDeusCustomGame._update_journey_god_icons = function (self)
	-- function 19
	local _journey_cycle = self._journey_cycle

	for i, v in ipairs(self._expedition_widgets) do
		local content = v.content
		local dominant_god = _journey_cycle.journey_data[content.journey_name].dominant_god

		content.theme_icon = DeusThemeSettings[dominant_god].text_icon
	end
end

StartGameWindowDeusCustomGame.update = function (self, arg_20_1, arg_20_2)
	-- function 20
	local time = Managers.time:time("main")

	self:_update_modifiers(time)
	self:_update_can_play()
	self:_update_animations(arg_20_1, arg_20_2)
	self:_handle_gamepad_activity()

	if not self._is_focused then
		self:_handle_input(arg_20_1, arg_20_2)
	end

	self:_draw(arg_20_1)
end

StartGameWindowDeusCustomGame._verify_selection_index = function (self, arg_21_1, arg_21_2)
	-- function 21
	local _input_index = self._input_index
	local count = #selector_input_definitions

	arg_21_1 = math.clamp(arg_21_1, 1, count)

	if not arg_21_2 then
		return arg_21_1
	end

	local var_21_2 = selector_input_definitions[arg_21_1]

	while not (not var_21_2 and not (arg_21_1 < count) or var_21_2.enter_requirements(self)) do
		arg_21_1 = arg_21_1 + arg_21_2
		var_21_2 = selector_input_definitions[arg_21_1]
	end

	if not var_21_2 and not var_21_2.enter_requirements(self) then
		_input_index = arg_21_1
	end

	return _input_index
end

StartGameWindowDeusCustomGame._gamepad_selector_input_func = function (self, arg_22_1, arg_22_2)
	-- function 22
	local is_device_active = Managers.input:is_device_active("mouse")

	arg_22_1 = self:_verify_selection_index(arg_22_1, arg_22_2)

	if not (self._input_index == arg_22_1 or is_device_active) then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if not self._input_index then
			selector_input_definitions[self._input_index].on_exit(self)
		end

		selector_input_definitions[arg_22_1].on_enter(self)
	end

	self._input_index = arg_22_1
end

StartGameWindowDeusCustomGame._update_animations = function (self, arg_23_1, arg_23_2)
	-- function 23
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_23_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _selection_widgets_by_name = self._selection_widgets_by_name
	local _expedition_widgets = self._expedition_widgets

	for k_2 = 1, #_expedition_widgets do
		local var_23_4 = _expedition_widgets[k_2]

		self:_animate_expedition_widget(var_23_4, arg_23_1)
	end
end

StartGameWindowDeusCustomGame._draw = function (self, arg_24_1)
	-- function 24
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_24_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_24_1, var_24_4, _render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_24_6 = _widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_24_6)
	end

	local _expedition_widgets = self._expedition_widgets

	for j = 1, #_expedition_widgets do
		local var_24_8 = _expedition_widgets[j]

		UIRenderer.draw_widget(_ui_top_renderer, var_24_8)
	end

	local _selection_widgets = self._selection_widgets

	for k = 1, #_selection_widgets do
		local var_24_10 = _selection_widgets[k]

		UIRenderer.draw_widget(_ui_top_renderer, var_24_10)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowDeusCustomGame._animate_expedition_widget = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	local button_hotspot = arg_25_1.content.button_hotspot
	local is_selected = button_hotspot.is_selected
	local selected_progress = button_hotspot.selected_progress

	selected_progress = selected_progress or 0

	local num = 1.5

	if not is_selected then
		selected_progress = math.min(selected_progress + num * arg_25_2, 1)
	else
		selected_progress = math.max(selected_progress - num * arg_25_2, 0)
	end

	arg_25_1.style.purple_glow.color[1] = 255 * selected_progress
	button_hotspot.selected_progress = selected_progress
end

StartGameWindowDeusCustomGame._handle_input = function (self, arg_26_1, arg_26_2)
	-- function 26
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()

	if not Managers.input:is_device_active("mouse") then
		local _input_index = self._input_index
		local var_26_3

		if not window_input_service:get("move_down") then
			_input_index = _input_index + 1
			var_26_3 = 1
		elseif not window_input_service:get("move_up") then
			_input_index = _input_index - 1
			var_26_3 = -1
		else
			selector_input_definitions[_input_index].update(self, window_input_service, arg_26_1, arg_26_2)
		end

		if _input_index ~= self._input_index then
			self:_gamepad_selector_input_func(_input_index, var_26_3)
		end

		local flag = true

		if not (not window_input_service:get("right_stick_press", flag) and self._is_offline) then
			_parent:set_window_input_focus("deus_additional_settings")
		end
	else
		local _selection_widgets_by_name = self._selection_widgets_by_name

		for k, v in pairs(_selection_widgets_by_name) do
			if k == "difficulty_stepper" then
				if not UIUtils.is_button_pressed(v, "left_arrow_hotspot") then
					self:_option_selected(k, "left_arrow", arg_26_2)
				elseif not UIUtils.is_button_pressed(v, "right_arrow_hotspot") then
					self:_option_selected(k, "right_arrow", arg_26_2)
				end

				if UIUtils.is_button_hover(v, "info_hotspot") or not UIUtils.is_button_hover(self._widgets_by_name.difficulty_info, "widget_hotspot") then
					local tbl = {
						difficulty_info = self._widgets_by_name.difficulty_info,
						upsell_button = self._widgets_by_name.upsell_button
					}

					if not self.diff_info_anim_played then
						self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, scenegraph_definition)
						self.diff_info_anim_played = true
					end

					self:_update_difficulty_lock()
				else
					if not self._diff_anim_id then
						self._ui_animator:stop_animation(self._diff_anim_id)
					end

					self.diff_info_anim_played = false
					self._widgets_by_name.upsell_button.content.visible = false
					self._widgets_by_name.difficulty_info.content.visible = false
				end
			elseif not UIUtils.is_button_pressed(v) then
				self:_option_selected(k, nil, arg_26_2)
			end

			if k == "difficulty_stepper" then
				local content = v.content
				local is_button_hover = UIUtils.is_button_hover(v, "left_arrow_hotspot")

				is_button_hover = is_button_hover or UIUtils.is_button_hover(v, "right_arrow_hotspot")
				content.is_selected = is_button_hover
			else
				v.content.is_selected = UIUtils.is_button_hover(v)
			end
		end

		local var_26_9 = self._expedition_widgets[self._expeditions_selection_index]

		for k_2 = 1, #self._expedition_widgets do
			local var_26_10 = self._expedition_widgets[k_2]

			if not UIUtils.is_button_pressed(var_26_10) then
				if not var_26_9 then
					var_26_9.content.button_hotspot.is_selected = nil
				end

				var_26_10.content.button_hotspot.is_selected = true

				local journey_name = var_26_10.content.journey_name

				_parent:set_selected_level_id(journey_name)

				self._expeditions_selection_index = k_2

				self:_play_sound("play_gui_lobby_button_01_difficulty_select_normal")
			end

			if not UIUtils.is_button_hover_enter(var_26_10) then
				self._parent:play_sound("Play_hud_hover")
			end
		end
	end

	self:_update_gamemode_info_text(window_input_service)

	local upsell_button = self._widgets_by_name.upsell_button

	if not UIUtils.is_button_pressed(upsell_button) then
		Managers.unlock:open_dlc_page(self._dlc_name)
	end

	if not self:_can_play() then
		local play_button = self._selection_widgets_by_name.play_button

		if not UIUtils.is_button_hover_enter(play_button) then
			self._parent:play_sound("Play_hud_hover")
		end

		if window_input_service:get(str) or not UIUtils.is_button_pressed(play_button) then
			self._play_button_pressed = true

			local get_custom_game_settings = _parent:get_custom_game_settings(self._mechanism_name)

			get_custom_game_settings = get_custom_game_settings or _parent:get_custom_game_settings("adventure")

			self._parent:set_difficulty_option(self._current_difficulty)
			_parent:play(arg_26_2, get_custom_game_settings.game_mode_type)
		end
	end
end

StartGameWindowDeusCustomGame.handle_expedition_input = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	return
end

StartGameWindowDeusCustomGame.handle_difficulty_input = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	return
end

StartGameWindowDeusCustomGame._play_sound = function (self, arg_29_1)
	-- function 29
	self._parent:play_sound(arg_29_1)
end

StartGameWindowDeusCustomGame._update_expedition_option = function (self)
	-- function 30
	local get_selected_level_id = self._parent:get_selected_level_id()

	if not get_selected_level_id then
		return
	end

	local var_30_1 = LevelSettings[get_selected_level_id]
	local display_name = var_30_1.display_name
	local level_image = var_30_1.level_image
	local get_completed_level_difficulty_index = self._parent:get_completed_level_difficulty_index(self._statistics_db, self._stats_id, get_selected_level_id)

	for i = 1, #self._expedition_widgets do
		local content = self._expedition_widgets[i].content

		if get_selected_level_id == content.journey_name then
			content.button_hotspot.is_selected = true
			self._expeditions_selection_index = i

			break
		end
	end
end

StartGameWindowDeusCustomGame._handle_gamepad_activity = function (self)
	-- function 31
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true
			self._input_index = 1

			local var_31_1 = selector_input_definitions[self._input_index]

			if not var_31_1 and not var_31_1.enter_requirements(self) then
				var_31_1.on_enter(self)
			end
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		selector_input_definitions[self._input_index].on_exit(self)
	end
end

StartGameWindowDeusCustomGame._update_gamemode_info_text = function (self, arg_32_1)
	-- function 32
	local custom_gamemode_info_box = self._widgets_by_name.custom_gamemode_info_box

	if not (not arg_32_1:get("trigger_cycle_next") and custom_gamemode_info_box.content.is_showing_info) then
		self._ui_animator:start_animation("gamemode_text_swap", custom_gamemode_info_box, scenegraph_definition)

		custom_gamemode_info_box.content.is_showing_info = true
	elseif not arg_32_1:get("trigger_cycle_next") and not custom_gamemode_info_box.content.is_showing_info then
		self._ui_animator:start_animation("gamemode_text_swap", custom_gamemode_info_box, scenegraph_definition)

		custom_gamemode_info_box.content.is_showing_info = false
	end

	if not UIUtils.is_button_pressed(custom_gamemode_info_box, "info_hotspot") then
		if not custom_gamemode_info_box.content.is_showing_info then
			self._ui_animator:start_animation("gamemode_text_swap", custom_gamemode_info_box, scenegraph_definition)

			custom_gamemode_info_box.content.is_showing_info = true
		else
			self._ui_animator:start_animation("gamemode_text_swap", custom_gamemode_info_box, scenegraph_definition)

			custom_gamemode_info_box.content.is_showing_info = false
		end
	end
end

StartGameWindowDeusCustomGame._update_difficulty_lock = function (self)
	-- function 33
	local _current_difficulty = self._current_difficulty
	local difficulty_info = self._widgets_by_name.difficulty_info
	local upsell_button = self._widgets_by_name.upsell_button

	if not _current_difficulty then
		local is_difficulty_approved, var_33_4, var_33_5, var_33_6 = self._parent:is_difficulty_approved(_current_difficulty)

		if not is_difficulty_approved then
			if not var_33_4 then
				difficulty_info.content.should_show_diff_lock_text = true

				local content = difficulty_info.content
				local var_33_8

				if not var_33_4 then
					var_33_8 = Localize(var_33_4)

					if not var_33_8 then
						-- Nothing
					end
				end

				var_33_8 = ""

				::label_33_0::

				content.difficulty_lock_text = var_33_8
			else
				difficulty_info.content.should_show_diff_lock_text = false
			end

			if not var_33_5 then
				difficulty_info.content.should_show_dlc_lock = true
				self._dlc_locked = var_33_5
				self._dlc_name = var_33_5
				upsell_button.content.visible = true
			else
				difficulty_info.content.should_show_dlc_lock = false
				upsell_button.content.visible = false
				self._dlc_locked = nil
				self._dlc_name = nil
			end
		else
			difficulty_info.content.should_show_dlc_lock = false
			difficulty_info.content.should_show_diff_lock_text = false
			difficulty_info.content.should_resize = false
			upsell_button.content.visible = false
			self._dlc_locked = nil
			self._dlc_name = nil
		end

		self._difficulty_approved = is_difficulty_approved
	else
		difficulty_info.content.should_show_dlc_lock = false
		upsell_button.content.visible = false
	end

	local _calculate_difficulty_info_widget_size = self:_calculate_difficulty_info_widget_size(difficulty_info)
	local num = (math.floor(_calculate_difficulty_info_widget_size) - scenegraph_definition.difficulty_info.size[2]) / 2

	self:_resize_difficulty_info({
		math.floor(scenegraph_definition.difficulty_info.size[1]),
		math.floor(_calculate_difficulty_info_widget_size)
	}, {
		0,
		-num,
		1
	})

	upsell_button.offset[2] = -math.floor(_calculate_difficulty_info_widget_size) / 2 + 24
end

StartGameWindowDeusCustomGame._calculate_difficulty_info_widget_size = function (self, arg_34_1)
	-- function 34
	local num = 20
	local difficulty_description = arg_34_1.style.difficulty_description
	local difficulty_description_2 = arg_34_1.content.difficulty_description
	local get_text_height = UIUtils.get_text_height(self._ui_renderer, difficulty_description.size, difficulty_description, difficulty_description_2)

	arg_34_1.content.difficulty_description_text_size = get_text_height

	local highest_obtainable_level = arg_34_1.style.highest_obtainable_level
	local highest_obtainable_level_2 = arg_34_1.content.highest_obtainable_level
	local num_2 = UIUtils.get_text_height(self._ui_renderer, highest_obtainable_level.size, highest_obtainable_level, highest_obtainable_level_2) + num
	local difficulty_lock_text = arg_34_1.style.difficulty_lock_text
	local difficulty_lock_text_2 = arg_34_1.content.difficulty_lock_text
	local num_3 = 0

	if not arg_34_1.content.should_show_diff_lock_text then
		num_3 = UIUtils.get_text_height(self._ui_renderer, difficulty_lock_text.size, difficulty_lock_text, difficulty_lock_text_2) + num
		arg_34_1.content.difficulty_lock_text_height = num_3
	end

	local dlc_lock_text = arg_34_1.style.dlc_lock_text
	local dlc_lock_text_2 = arg_34_1.content.dlc_lock_text
	local num_4 = 0

	if not arg_34_1.content.should_show_dlc_lock then
		num_4 = UIUtils.get_text_height(self._ui_renderer, dlc_lock_text.size, dlc_lock_text, dlc_lock_text_2) + num
	end

	return num_2 + get_text_height + num_3 + num_4 + 50
end

StartGameWindowDeusCustomGame._resize_difficulty_info = function (self, arg_35_1, arg_35_2)
	-- function 35
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.should_resize = true
	difficulty_info.content.resize_size = arg_35_1
	difficulty_info.content.resize_offset = arg_35_2
	difficulty_info.style.widget_hotspot.size = arg_35_1
	difficulty_info.style.widget_hotspot.offset = arg_35_2
end
