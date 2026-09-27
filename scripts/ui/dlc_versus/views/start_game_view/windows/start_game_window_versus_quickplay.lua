-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_quickplay.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_quickplay_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local widget_definitions = var_0_0.widget_definitions
local animation_definitions = var_0_0.animation_definitions
local selector_input_definitions = var_0_0.selector_input_definitions
local str = "refresh_press"
local str_2 = "confirm_press"

StartGameWindowVersusQuickplay = class(StartGameWindowVersusQuickplay)
StartGameWindowVersusQuickplay.NAME = "StartGameWindowVersusQuickplay"

StartGameWindowVersusQuickplay.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameViewWindow] Enter Substate StartGameWindowVersusQuickplay")

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

	self._is_focused = false
	self._play_button_pressed = false
	self._previous_can_play = nil

	self._parent:change_generic_actions("versus_quickplay_default")
	self:_start_transition_animation("on_enter")
end

StartGameWindowVersusQuickplay._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

StartGameWindowVersusQuickplay._create_ui_elements = function (self, arg_3_1, arg_3_2)
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
end

StartGameWindowVersusQuickplay.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameViewWindow] Exit Substate StartGameWindowVersusQuickplay")

	self._ui_animator = nil

	if not self._play_button_pressed then
		arg_4_1.input_index = nil
	else
		arg_4_1.input_index = self._input_index
	end
end

StartGameWindowVersusQuickplay.set_focus = function (self, arg_5_1)
	-- function 5
	self._is_focused = arg_5_1
end

StartGameWindowVersusQuickplay.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	local is_device_active = Managers.input:is_device_active("gamepad")

	self:_update_can_play()
	self:_update_animations(arg_6_1)
	self:_handle_gamepad_activity()
	self:_handle_input(arg_6_1, arg_6_2)
	self:_update_play_button_texture(is_device_active)
	self:_draw(arg_6_1)
end

StartGameWindowVersusQuickplay.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowVersusQuickplay._handle_gamepad_activity = function (self)
	-- function 8
	local flag = self.gamepad_active_last_frame == nil

	if not Managers.input:is_device_active("mouse") then
		if not self.gamepad_active_last_frame and not flag then
			self._input_index = 1

			local var_8_1 = selector_input_definitions[self._input_index]

			if not var_8_1 and not var_8_1.enter_requirements(self) then
				var_8_1.on_enter(self)
			end

			self.gamepad_active_last_frame = true
		end
	elseif self.gamepad_active_last_frame or not flag then
		self.gamepad_active_last_frame = false

		selector_input_definitions[self._input_index].on_exit(self)
	end
end

StartGameWindowVersusQuickplay._update_can_play = function (self)
	-- function 9
	local _can_play, var_9_1 = self:_can_play()

	self._widgets_by_name.play_button.content.button_hotspot.disable_button = not _can_play

	local quickplay_disabled_disclaimer = self._widgets_by_name.quickplay_disabled_disclaimer

	quickplay_disabled_disclaimer.content.visible = not _can_play
	quickplay_disabled_disclaimer.content.text = var_9_1

	if not var_9_1 then
		local exists = Managers.localizer:exists(var_9_1)

		quickplay_disabled_disclaimer.style.text.localize = exists
		quickplay_disabled_disclaimer.style.text_shadow.localize = exists
	end

	local str = "versus_quickplay_default"

	if not _can_play then
		str = "versus_quickplay_play"
	end

	if str ~= self._prev_input_desc then
		self._parent:set_input_description(str)

		self._prev_input_desc = str
	end
end

StartGameWindowVersusQuickplay._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not self._is_focused then
		return
	end

	local _parent = self._parent
	local window_input_service = _parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("mouse")
	local _can_play = self:_can_play()

	if not is_device_active then
		local _input_index = self._input_index
		local var_10_5

		if not window_input_service:get("move_down") then
			_input_index = _input_index + 1
			var_10_5 = 1
		elseif not window_input_service:get("move_up") then
			_input_index = _input_index - 1
			var_10_5 = -1
		else
			selector_input_definitions[_input_index].update(self, window_input_service, _can_play, arg_10_1, arg_10_2)
		end

		if _input_index ~= self._input_index then
			self:_gamepad_selector_input_func(_input_index, var_10_5)
		end

		if not _can_play and not window_input_service:get(str) then
			self._parent:play(arg_10_2, "versus_quickplay")
		end
	else
		local _widgets_by_name = self._widgets_by_name

		for i = 1, #selector_input_definitions do
			local widget_name = selector_input_definitions[i].widget_name
			local is_selected = _widgets_by_name[widget_name].content.is_selected

			if widget_name ~= "play_button" or not self:_can_play() then
				if is_selected or not UIUtils.is_button_hover_enter(_widgets_by_name.play_button) then
					self:_handle_new_selection(i)
					self:_play_sound("Play_hud_hover")
				end

				if not UIUtils.is_button_pressed(_widgets_by_name.play_button) then
					self:_option_selected(widget_name, "play_button", arg_10_2)
				end
			end
		end
	end

	local flag = true

	if not window_input_service:get("right_stick_press", flag) then
		_parent:set_window_input_focus("versus_additional_quickplay_settings")
	end
end

StartGameWindowVersusQuickplay._play_sound = function (self, arg_11_1)
	-- function 11
	return self._parent:play_sound(arg_11_1)
end

StartGameWindowVersusQuickplay._can_play = function (arg_12_0)
	-- function 12
	if not MODDED_REALM then
		return false, "versus_disabled_in_modded_realm_disclaimer"
	end

	local matchmaking_enabled, var_12_1 = Managers.backend:get_interface("versus"):matchmaking_enabled("quickplay")

	if not matchmaking_enabled then
		var_12_1 = var_12_1 or "Temporarily disabled"

		return false, var_12_1
	end

	return true
end

StartGameWindowVersusQuickplay._option_selected = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	if arg_13_1 == "play_button" then
		self._parent:play(arg_13_3, "versus_quickplay")
	else
		ferror("Unknown selector_input_definition: %s", arg_13_1)
	end
end

StartGameWindowVersusQuickplay._verify_selection_index = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _input_index = self._input_index
	local count = #selector_input_definitions

	arg_14_1 = math.clamp(arg_14_1, 1, count)

	if not arg_14_2 then
		return arg_14_1
	end

	local var_14_2 = selector_input_definitions[arg_14_1]

	while not (not var_14_2 and not (arg_14_1 < count) or var_14_2.enter_requirements(self)) do
		arg_14_1 = arg_14_1 + arg_14_2
		var_14_2 = selector_input_definitions[arg_14_1]
	end

	if not var_14_2 and not var_14_2.enter_requirements(self) then
		_input_index = arg_14_1
	end

	return _input_index
end

StartGameWindowVersusQuickplay._gamepad_selector_input_func = function (self, arg_15_1, arg_15_2)
	-- function 15
	local is_device_active = Managers.input:is_device_active("mouse")

	arg_15_1 = self:_verify_selection_index(arg_15_1, arg_15_2)

	if not (self._input_index == arg_15_1 or is_device_active) then
		self._parent:play_sound("play_gui_lobby_button_02_mission_act_click")

		if not self._input_index then
			selector_input_definitions[self._input_index].on_exit(self)
		end

		selector_input_definitions[arg_15_1].on_enter(self)
	end

	self._input_index = arg_15_1
end

StartGameWindowVersusQuickplay._handle_new_selection = function (self, arg_16_1, arg_16_2)
	-- function 16
	local count = #selector_input_definitions

	arg_16_1 = math.clamp(arg_16_1, 1, count)

	local _widgets_by_name = self._widgets_by_name

	for i = 1, #selector_input_definitions do
		local var_16_2 = _widgets_by_name[selector_input_definitions[i].widget_name]
		local flag = i ~= arg_16_1 or self._gamepad_active

		var_16_2.content.is_selected = flag
	end

	self._input_index = arg_16_1
end

StartGameWindowVersusQuickplay._update_animations = function (self, arg_17_1)
	-- function 17
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_17_1)

	if not Managers.input:is_device_active("gamepad") then
		self:_update_button_animations(arg_17_1)
	end

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end

	local _widgets_by_name = self._widgets_by_name

	UIWidgetUtils.animate_play_button(_widgets_by_name.play_button, arg_17_1)
end

StartGameWindowVersusQuickplay._update_button_animations = function (self, arg_18_1)
	-- function 18
	local _widgets_by_name = self._widgets_by_name
end

StartGameWindowVersusQuickplay._draw = function (self, arg_19_1)
	-- function 19
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local _render_settings = self._render_settings
	local var_19_4

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_19_1, var_19_4, _render_settings)
	UIRenderer.draw_all_widgets(_ui_top_renderer, self._widgets)
	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowVersusQuickplay._update_play_button_texture = function (self, arg_20_1)
	-- function 20
	local _widgets_by_name = self._widgets_by_name

	if self._gamepad_active ~= arg_20_1 then
		self._gamepad_active = arg_20_1

		if not arg_20_1 then
			local window_input_service = self._parent:window_input_service()
			local str = "refresh"
			local get_gamepad_input_texture_data = UISettings.get_gamepad_input_texture_data(window_input_service, str, arg_20_1)

			if not get_gamepad_input_texture_data then
				_widgets_by_name.play_button.content.texture_icon_id = get_gamepad_input_texture_data.texture
			end
		else
			_widgets_by_name.play_button.content.texture_icon_id = "options_button_icon_quickplay"
		end

		self:_handle_new_selection(self._input_index)
	end
end
