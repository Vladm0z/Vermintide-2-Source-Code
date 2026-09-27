-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_select_weave.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_select_weave_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowWeaveSelectWeave = class(StartGameWindowWeaveSelectWeave)
StartGameWindowWeaveSelectWeave.NAME = "StartGameWindowWeaveSelectWeave"

StartGameWindowWeaveSelectWeave.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveSelectWeave")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self._player_manager = player
	self._peer_id = ingame_ui_context.peer_id

	self:_create_ui_elements(arg_1_1, arg_1_2)
end

StartGameWindowWeaveSelectWeave._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	local init_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	self._ui_scenegraph = init_scenegraph

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_3 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_3
		tbl_2[k] = var_2_3
	end

	self._ui_animations = {}
	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	local overlay_button = tbl_2.overlay_button
	local _animate_pulse = self:_animate_pulse(overlay_button.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(overlay_button, _animate_pulse)

	if not arg_2_2 then
		local local_position = init_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end
end

StartGameWindowWeaveSelectWeave.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveSelectWeave")

	self._ui_animator = nil
end

StartGameWindowWeaveSelectWeave._is_button_hover_enter = function (arg_4_0, arg_4_1)
	-- function 4
	return arg_4_1.content.button_hotspot.on_hover_enter
end

StartGameWindowWeaveSelectWeave._is_button_hover_exit = function (arg_5_0, arg_5_1)
	-- function 5
	return arg_5_1.content.button_hotspot.on_hover_exit
end

StartGameWindowWeaveSelectWeave._update_game_options_hover_effect = function (self)
	-- function 6
	local overlay_button = self._widgets_by_name.overlay_button

	if not self:_is_button_hover_enter(overlay_button) then
		self:_on_option_button_hover_enter(overlay_button, 2)
	elseif not self:_is_button_hover_exit(overlay_button) then
		self:_on_option_button_hover_exit(overlay_button, 2)
	end
end

StartGameWindowWeaveSelectWeave._on_option_button_hover_enter = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	self:_create_style_animation_enter(arg_7_1, 255, "glow", arg_7_2, arg_7_3)
	self:_create_style_animation_exit(arg_7_1, 0, "button_hover_rect", arg_7_2, arg_7_3)
end

StartGameWindowWeaveSelectWeave._on_option_button_hover_exit = function (self, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	self:_create_style_animation_exit(arg_8_1, 0, "glow", arg_8_2, arg_8_3)
	self:_create_style_animation_enter(arg_8_1, 30, "button_hover_rect", arg_8_2, arg_8_3)
end

StartGameWindowWeaveSelectWeave._create_style_animation_enter = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5)
	-- function 9
	local var_9_0 = arg_9_1.style[arg_9_3]

	if not var_9_0 then
		return
	end

	local var_9_1 = var_9_0.color[1]
	local var_9_2 = arg_9_2
	local num = 0.2
	local num_2 = (1 - var_9_1 / var_9_2) * num

	if not (not (num_2 > 0) or arg_9_5) then
		self._ui_animations[("game_option_" .. arg_9_3) .. "_hover_" .. arg_9_4] = self:_animate_element_by_time(var_9_0.color, 1, var_9_1, var_9_2, num_2)
	else
		var_9_0.color[1] = var_9_2
	end
end

StartGameWindowWeaveSelectWeave._animate_pulse = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5))
end

StartGameWindowWeaveSelectWeave._animate_element_by_time = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	-- function 11
	return (UIAnimation.init(UIAnimation.function_by_time, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, math.ease_out_quad))
end

StartGameWindowWeaveSelectWeave._create_style_animation_exit = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	local var_12_0 = arg_12_1.style[arg_12_3]

	if not var_12_0 then
		return
	end

	local var_12_1 = var_12_0.color[1]
	local var_12_2 = arg_12_2
	local num = 0.2
	local num_2 = var_12_1 / 255 * num

	if not (not (num_2 > 0) or arg_12_5) then
		self._ui_animations[("game_option_" .. arg_12_3) .. "_hover_" .. arg_12_4] = self:_animate_element_by_time(var_12_0.color, 1, var_12_1, var_12_2, num_2)
	else
		var_12_0.color[1] = var_12_2
	end
end

StartGameWindowWeaveSelectWeave._play_sound = function (self, arg_13_1)
	-- function 13
	self._parent:play_sound(arg_13_1)
end

StartGameWindowWeaveSelectWeave.update = function (self, arg_14_1, arg_14_2)
	-- function 14
	self:_update_animations(arg_14_1, arg_14_2)
	self:_update_input(arg_14_1, arg_14_2)
	self:_draw(arg_14_1)
end

StartGameWindowWeaveSelectWeave._update_animations = function (self, arg_15_1)
	-- function 15
	self:_update_game_options_hover_effect()

	local _ui_animations = self._ui_animations

	_ui_animations = _ui_animations or {}

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_15_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	self._ui_animator:update(arg_15_1)
end

StartGameWindowWeaveSelectWeave._update_input = function (self, arg_16_1, arg_16_2)
	-- function 16
	local overlay_button = self._widgets_by_name.overlay_button
	local button_hotspot = overlay_button.content.button_hotspot

	if not self:_is_button_hover_enter(overlay_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not button_hotspot.on_pressed then
		self._parent:set_layout_by_name("weave_selection")
	end
end

StartGameWindowWeaveSelectWeave.post_update = function (arg_17_0, arg_17_1, arg_17_2)
	-- function 17
	return
end

StartGameWindowWeaveSelectWeave._draw = function (self, arg_18_1)
	-- function 18
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, window_input_service, arg_18_1, nil, self._render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_18_4 = _widgets[i]

		UIRenderer.draw_widget(_ui_renderer, var_18_4)
	end

	UIRenderer.end_pass(_ui_renderer)
end
