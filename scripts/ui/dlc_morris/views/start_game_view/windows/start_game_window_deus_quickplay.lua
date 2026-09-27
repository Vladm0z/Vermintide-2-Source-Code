-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_quickplay.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_quickplay_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local animation_definitions = var_0_0.animation_definitions
local selector_input_definitions = var_0_0.selector_input_definitions
local str = "refresh_press"
local str_2 = "confirm_press"

StartGameWindowDeusQuickplay = class(StartGameWindowDeusQuickplay)
StartGameWindowDeusQuickplay.NAME = "StartGameWindowDeusQuickplay"

StartGameWindowDeusQuickplay.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowDeusQuickplay")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)

	local input_index = arg_1_1.input_index

	input_index = input_index or 1
	self._input_index = input_index

	self:_handle_new_selection(self._input_index)

	local get_difficulty_option = self._parent:get_difficulty_option(true)

	get_difficulty_option = get_difficulty_option or Managers.state.difficulty:get_difficulty()
	self._current_difficulty = get_difficulty_option
	self._dlc_name = nil

	self:_update_difficulty_option(self._current_difficulty)

	self._is_focused = false
	self._play_button_pressed = false
	self._show_additional_settings = false
	self._previous_can_play = nil

	self._parent:change_generic_actions("deus_default")
	self:_start_transition_animation("on_enter")
end

StartGameWindowDeusQuickplay._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowDeusQuickplay._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._widgets, self._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	self._widgets_by_name.difficulty_info.content.visible = false
end

StartGameWindowDeusQuickplay.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameViewWindow] Exit Substate StartGameWindowDeusQuickplay")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = self._input_index
	end

	self._parent:set_difficulty_option(self._current_difficulty)
end

StartGameWindowDeusQuickplay.set_focus = function (self, arg_5_1)
	-- function 5
	self._is_focused = arg_5_1
end

StartGameWindowDeusQuickplay.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_can_play()
	self:_update_animations(arg_6_1)
	self:_handle_gamepad_activity()
	self:_handle_input(arg_6_1, arg_6_2)
	self:_draw(arg_6_1)
end

StartGameWindowDeusQuickplay.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowDeusQuickplay._handle_gamepad_activity = function (self)
	-- function 8
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self.gamepad_active_last_frame = true
			self._input_index = 1

			local var_8_1 = selector_input_definitions[self._input_index]

			if not var_8_1 and not var_8_1.enter_requirements(self) then
				var_8_1.on_enter(self)
			end
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		selector_input_definitions[self._input_index].on_exit(self)
	end
end

StartGameWindowDeusQuickplay._update_can_play = function (self)
	-- function 9
	local _can_play = self:_can_play()

	self._widgets_by_name.play_button.content.button_hotspot.disable_button = not _can_play

	local str = "deus_default"

	if not _can_play then
		str = "deus_default_play"
	elseif not self._dlc_locked then
		str = "deus_default_buy"
	end

	if str ~= self._prev_input_desc then
		self._parent:set_input_description(str)

		self._prev_input_desc = str
	end
end

StartGameWindowDeusQuickplay._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")

	if not is_device_active then
		local _input_index = self._input_index
		local var_10_4

		if not window_input_service:get("move_down") then
			_input_index = _input_index + 1
			var_10_4 = 1
		elseif not window_input_service:get("move_up") then
			_input_index = _input_index - 1
			var_10_4 = -1
		else
			selector_input_definitions[_input_index].update(self, window_input_service, arg_10_1, arg_10_2)
		end

		if _input_index ~= self._input_index then
			self:_gamepad_selector_input_func(_input_index, var_10_4)
		end

		if not window_input_service:get(str_2, true) and not self._dlc_locked then
			Managers.unlock:open_dlc_page(self._dlc_name)
		end

		if not self:_can_play() and not window_input_service:get(str) then
			local get_quickplay_settings = self._parent:get_quickplay_settings(self._mechanism_name)

			get_quickplay_settings = get_quickplay_settings or self._parent:get_quickplay_settings("adventure")

			local game_mode_type = get_quickplay_settings.game_mode_type

			self._parent:set_difficulty_option(self._current_difficulty)

			self._play_button_pressed = true

			self._parent:play(arg_10_2, game_mode_type)
		end
	else
		local _widgets_by_name = self._widgets_by_name

		for i = 1, #selector_input_definitions do
			local widget_name = selector_input_definitions[i].widget_name
			local var_10_9 = _widgets_by_name[widget_name]
			local is_selected = var_10_9.content.is_selected

			if widget_name == "difficulty_stepper" then
				if is_selected or not UIUtils.is_button_hover_enter(var_10_9, "left_arrow_hotspot") then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if is_selected or not UIUtils.is_button_hover_enter(var_10_9, "right_arrow_hotspot") then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if UIUtils.is_button_hover(var_10_9, "info_hotspot") or UIUtils.is_button_hover(self._widgets_by_name.difficulty_info, "widget_hotspot") or is_device_active or not is_selected then
					local tbl = {
						difficulty_info = self._widgets_by_name.difficulty_info,
						upsell_button = self._widgets_by_name.upsell_button
					}

					if not self._diff_info_anim_played then
						self._diff_anim_id = self._ui_animator:start_animation("difficulty_info_enter", tbl, scenegraph_definition)
						self._diff_info_anim_played = true
					end

					self:_handle_difficulty_info(true)
				else
					if not self._diff_anim_id then
						self._ui_animator:stop_animation(self._diff_anim_id)
					end

					self._diff_info_anim_played = false
					self._widgets_by_name.upsell_button.content.visible = false
					self._widgets_by_name.difficulty_info.content.visible = false

					self:_handle_difficulty_info(false)
				end

				if UIUtils.is_button_pressed(var_10_9, "left_arrow_hotspot") or not window_input_service:get("move_left") then
					self:_option_selected(widget_name, "left_arrow", arg_10_2)
				elseif UIUtils.is_button_pressed(var_10_9, "right_arrow_hotspot") or not window_input_service:get("move_right") then
					self:_option_selected(widget_name, "right_arrow", arg_10_2)
				end
			elseif widget_name ~= "play_button" or not self:_can_play() then
				if is_selected or not UIUtils.is_button_hover_enter(_widgets_by_name.play_button) then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if not UIUtils.is_button_pressed(_widgets_by_name.play_button) then
					self:_option_selected(widget_name, "play_button", arg_10_2)
				end
			end
		end

		local upsell_button = self._widgets_by_name.upsell_button

		if not UIUtils.is_button_pressed(upsell_button) then
			Managers.unlock:open_dlc_page(self._dlc_name)
		end
	end

	self:_update_gamemode_info_text(window_input_service)

	local flag = true

	if not DLCSettings.quick_play_preferences and not window_input_service:get("right_stick_press", flag) then
		_parent:set_layout_by_name("adventure_level_preferences")
	end
end

StartGameWindowDeusQuickplay._play_sound = function (self, arg_11_1)
	-- function 11
	return self._parent:play_sound(arg_11_1)
end

StartGameWindowDeusQuickplay._can_play = function (self)
	-- function 12
	return self._current_difficulty == nil or not self._dlc_locked
end

StartGameWindowDeusQuickplay._set_info_window = function (self, arg_13_1)
	-- function 13
	local var_13_0 = DifficultySettings[arg_13_1]
	local description = var_13_0.description
	local max_chest_power_level = var_13_0.max_chest_power_level
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.difficulty_description = Localize(description)
	difficulty_info.content.highest_obtainable_level = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(max_chest_power_level)
end

StartGameWindowDeusQuickplay._update_difficulty_option = function (self, arg_14_1)
	-- function 14
	if not arg_14_1 then
		local var_14_0 = DifficultySettings[arg_14_1]
		local difficulty_stepper = self._widgets_by_name.difficulty_stepper

		difficulty_stepper.content.selected_difficulty_text = Localize(var_14_0.display_name)

		local display_image = var_14_0.display_image

		difficulty_stepper.content.difficulty_icon = display_image

		self:_set_info_window(arg_14_1)

		self._current_difficulty = arg_14_1
	end
end

StartGameWindowDeusQuickplay._option_selected = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	if arg_15_1 == "difficulty_stepper" then
		local _current_difficulty = self._current_difficulty
		local difficulties = GameModeSettings.deus.difficulties
		local find = table.find(difficulties, _current_difficulty)

		find = find or 1

		local num = 0

		if arg_15_2 == "left_arrow" then
			if find - 1 >= 1 then
				num = find - 1

				self._parent:play_sound("hud_morris_start_menu_set")
			end
		elseif not (arg_15_2 ~= "right_arrow" or not (find + 1 <= #difficulties)) then
			num = find + 1

			self._parent:play_sound("hud_morris_start_menu_set")
		end

		self:_update_difficulty_option(difficulties[num])
	elseif arg_15_1 == "play_button" then
		local get_quickplay_settings = self._parent:get_quickplay_settings(self._mechanism_name)

		get_quickplay_settings = get_quickplay_settings or self._parent:get_quickplay_settings("adventure")

		local game_mode_type = get_quickplay_settings.game_mode_type

		self._parent:set_difficulty_option(self._current_difficulty)

		self._play_button_pressed = true

		self._parent:play(arg_15_3, game_mode_type)
	else
		ferror("Unknown selector_input_definition: %s", arg_15_1)
	end
end

StartGameWindowDeusQuickplay._verify_selection_index = function (self, arg_16_1, arg_16_2)
	-- function 16
	local _input_index = self._input_index
	local count = #selector_input_definitions

	arg_16_1 = math.clamp(arg_16_1, 1, count)

	if not arg_16_2 then
		return arg_16_1
	end

	local var_16_2 = selector_input_definitions[arg_16_1]

	while not (not var_16_2 and not (arg_16_1 < count) or var_16_2.enter_requirements()) do
		arg_16_1 = arg_16_1 + arg_16_2
		var_16_2 = selector_input_definitions[arg_16_1]
	end

	if not var_16_2 and not var_16_2.enter_requirements() then
		_input_index = arg_16_1
	end

	return _input_index
end

StartGameWindowDeusQuickplay._gamepad_selector_input_func = function (self, arg_17_1, arg_17_2)
	-- function 17
	local is_device_active = Managers.input:is_device_active("mouse")

	arg_17_1 = self:_verify_selection_index(arg_17_1, arg_17_2)

	if not (self._input_index == arg_17_1 or is_device_active) then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if not self._input_index then
			selector_input_definitions[self._input_index].on_exit(self)
		end

		selector_input_definitions[arg_17_1].on_enter(self)
	end

	self._input_index = arg_17_1
end

StartGameWindowDeusQuickplay._handle_new_selection = function (self, arg_18_1, arg_18_2)
	-- function 18
	local count = #selector_input_definitions

	arg_18_1 = math.clamp(arg_18_1, 1, count)

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #selector_input_definitions do
		local var_18_2 = _widgets_by_name[selector_input_definitions[i].widget_name]
		local flag = i == arg_18_1

		var_18_2.content.is_selected = flag
	end

	self._input_index = arg_18_1
end

StartGameWindowDeusQuickplay._update_animations = function (self, arg_19_1)
	-- function 19
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_19_1)

	if not Managers.input:is_device_active("gamepad") then
		self:_update_button_animations(arg_19_1)
	end

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

StartGameWindowDeusQuickplay._update_button_animations = function (self, arg_20_1)
	-- function 20
	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_default_button(_widgets_by_name.upsell_button, arg_20_1)
end

StartGameWindowDeusQuickplay._draw = function (self, arg_21_1)
	-- function 21
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_21_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_21_1, var_21_4, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowDeusQuickplay._update_difficulty_lock = function (self)
	-- function 22
	local _current_difficulty = self._current_difficulty
	local difficulty_info = self._widgets_by_name.difficulty_info
	local upsell_button = self._widgets_by_name.upsell_button

	if not _current_difficulty then
		local is_difficulty_approved, var_22_4, var_22_5, var_22_6 = self._parent:is_difficulty_approved(_current_difficulty)

		if not is_difficulty_approved then
			if not var_22_4 then
				difficulty_info.content.should_show_diff_lock_text = true

				local content = difficulty_info.content
				local var_22_8

				if not var_22_4 then
					var_22_8 = Localize(var_22_4)

					if not var_22_8 then
						-- Nothing
					end
				end

				var_22_8 = ""

				::label_22_0::

				content.difficulty_lock_text = var_22_8
			else
				difficulty_info.content.should_show_diff_lock_text = false
			end

			if not var_22_5 then
				difficulty_info.content.should_show_dlc_lock = true
				self._dlc_locked = var_22_5
				self._dlc_name = var_22_5
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

StartGameWindowDeusQuickplay._handle_difficulty_info = function (self, arg_23_1)
	-- function 23
	if not arg_23_1 then
		self:_update_difficulty_lock()
	end
end

StartGameWindowDeusQuickplay._calculate_difficulty_info_widget_size = function (self, arg_24_1)
	-- function 24
	local num = 20
	local difficulty_description = arg_24_1.style.difficulty_description
	local difficulty_description_2 = arg_24_1.content.difficulty_description
	local get_text_height = UIUtils.get_text_height(self._ui_renderer, difficulty_description.size, difficulty_description, difficulty_description_2)

	arg_24_1.content.difficulty_description_text_size = get_text_height

	local highest_obtainable_level = arg_24_1.style.highest_obtainable_level
	local highest_obtainable_level_2 = arg_24_1.content.highest_obtainable_level
	local num_2 = UIUtils.get_text_height(self._ui_renderer, highest_obtainable_level.size, highest_obtainable_level, highest_obtainable_level_2) + num
	local difficulty_lock_text = arg_24_1.style.difficulty_lock_text
	local difficulty_lock_text_2 = arg_24_1.content.difficulty_lock_text
	local num_3 = 0

	if not arg_24_1.content.should_show_diff_lock_text then
		num_3 = UIUtils.get_text_height(self._ui_renderer, difficulty_lock_text.size, difficulty_lock_text, difficulty_lock_text_2) + num
		arg_24_1.content.difficulty_lock_text_height = num_3
	end

	local dlc_lock_text = arg_24_1.style.dlc_lock_text
	local dlc_lock_text_2 = arg_24_1.content.dlc_lock_text
	local num_4 = 0

	if not arg_24_1.content.should_show_dlc_lock then
		num_4 = UIUtils.get_text_height(self._ui_renderer, dlc_lock_text.size, dlc_lock_text, dlc_lock_text_2) + num
	end

	return num_2 + get_text_height + num_3 + num_4 + 50
end

StartGameWindowDeusQuickplay._resize_difficulty_info = function (self, arg_25_1, arg_25_2)
	-- function 25
	local difficulty_info = self._widgets_by_name.difficulty_info

	difficulty_info.content.should_resize = true
	difficulty_info.content.resize_size = arg_25_1
	difficulty_info.content.resize_offset = arg_25_2
	difficulty_info.style.widget_hotspot.size = arg_25_1
	difficulty_info.style.widget_hotspot.offset = arg_25_2
end

StartGameWindowDeusQuickplay._update_gamemode_info_text = function (self, arg_26_1)
	-- function 26
	local quickplay_gamemode_info_box = self._widgets_by_name.quickplay_gamemode_info_box

	if not (not arg_26_1:get("trigger_cycle_next") and quickplay_gamemode_info_box.content.is_showing_info) then
		self._ui_animator:start_animation("gamemode_text_swap", quickplay_gamemode_info_box, scenegraph_definition)

		quickplay_gamemode_info_box.content.is_showing_info = true
	elseif not arg_26_1:get("trigger_cycle_next") and not quickplay_gamemode_info_box.content.is_showing_info then
		self._ui_animator:start_animation("gamemode_text_swap", quickplay_gamemode_info_box, scenegraph_definition)

		quickplay_gamemode_info_box.content.is_showing_info = false
	end

	if not UIUtils.is_button_pressed(quickplay_gamemode_info_box, "info_hotspot") then
		if not quickplay_gamemode_info_box.content.is_showing_info then
			self._ui_animator:start_animation("gamemode_text_swap", quickplay_gamemode_info_box, scenegraph_definition)

			quickplay_gamemode_info_box.content.is_showing_info = true
		else
			self._ui_animator:start_animation("gamemode_text_swap", quickplay_gamemode_info_box, scenegraph_definition)

			quickplay_gamemode_info_box.content.is_showing_info = false
		end
	end
end

StartGameWindowDeusQuickplay._handle_difficulty_stepper_gamepad = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	local tbl = {}

	if not arg_27_2:get("move_left") and not arg_27_1.content.is_selected then
		self:_option_selected(self._input_index, "left_arrow", arg_27_3)

		arg_27_1.content.left_arrow_pressed = true
		tbl.left_key = arg_27_1.style.left_arrow_gamepad_highlight

		if not self._arrow_anim_id then
			self._ui_animator:stop_animation(self._arrow_anim_id)

			arg_27_1.style.right_arrow_gamepad_highlight.color[1] = 0
		end

		self._arrow_anim_id = self._ui_animator:start_animation("left_arrow_flick", arg_27_1, scenegraph_definition, tbl)
	elseif not arg_27_2:get("move_right") and not arg_27_1.content.is_selected then
		self:_option_selected(self._input_index, "right_arrow", arg_27_3)

		arg_27_1.content.right_arrow_pressed = true
		tbl.right_key = arg_27_1.style.right_arrow_gamepad_highlight

		if not self._arrow_anim_id then
			self._ui_animator:stop_animation(self._arrow_anim_id)

			arg_27_1.style.left_arrow_gamepad_highlight.color[1] = 0
		end

		self._arrow_anim_id = self._ui_animator:start_animation("right_arrow_flick", arg_27_1, scenegraph_definition, tbl)
	end
end
