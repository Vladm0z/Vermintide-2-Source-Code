-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mutator_list.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mutator_list_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions

StartGameWindowMutatorList = class(StartGameWindowMutatorList)
StartGameWindowMutatorList.NAME = "StartGameWindowMutatorList"

StartGameWindowMutatorList.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowMutatorList")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self._active_mutator_widgets = {}
end

StartGameWindowMutatorList.create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_2_2
		tbl_2[k] = var_2_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_2_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_2_2[1]
		local_position[2] = local_position[2] + arg_2_2[2]
		local_position[3] = local_position[3] + arg_2_2[3]
	end

	tbl_2.play_button.content.button_hotspot.disable_button = true

	local overlay_button = tbl_2.overlay_button
	local _animate_pulse = self:_animate_pulse(overlay_button.style.glow_frame.color, 1, 255, 100, 2)

	UIWidget.animate(overlay_button, _animate_pulse)

	if not self:_has_deed_items() then
		overlay_button.content.button_hotspot.disable_button = false
	else
		overlay_button.content.button_hotspot.disable_button = true
	end
end

StartGameWindowMutatorList._has_deed_items = function (arg_3_0)
	-- function 3
	local get_interface = Managers.backend:get_interface("items")
	local str = "item_type == deed"
	local get_filtered_items = get_interface:get_filtered_items(str)

	return not get_filtered_items and #get_filtered_items > 0
end

StartGameWindowMutatorList.on_exit = function (self, arg_4_1)
	-- function 4
	print("[StartGameWindow] Exit Substate StartGameWindowMutatorList")

	self.ui_animator = nil
end

StartGameWindowMutatorList.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:_update_selected_item_backend_id()
	self:draw(arg_5_1)
end

StartGameWindowMutatorList.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

StartGameWindowMutatorList._update_animations = function (self, arg_7_1)
	-- function 7
	self:_update_game_options_hover_effect()

	local _ui_animations = self._ui_animations

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	self.ui_animator:update(arg_7_1)
end

StartGameWindowMutatorList._is_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameWindowMutatorList._is_button_hover_enter = function (arg_9_0, arg_9_1)
	-- function 9
	return arg_9_1.content.button_hotspot.on_hover_enter
end

StartGameWindowMutatorList._is_button_hover_exit = function (arg_10_0, arg_10_1)
	-- function 10
	return arg_10_1.content.button_hotspot.on_hover_exit
end

StartGameWindowMutatorList._handle_input = function (self, arg_11_1, arg_11_2)
	-- function 11
	local _widgets_by_name = self._widgets_by_name

	if self:_is_button_hover_enter(_widgets_by_name.overlay_button) or not self:_is_button_hover_enter(_widgets_by_name.play_button) then
		self:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if not self:_is_button_pressed(_widgets_by_name.overlay_button) then
		self.parent:set_layout_by_name("heroic_deed_selection")
	elseif not self:_is_button_pressed(_widgets_by_name.play_button) and not self._selected_backend_id then
		self.parent:play(arg_11_2, "deed")
	end
end

StartGameWindowMutatorList._update_selected_item_backend_id = function (self)
	-- function 12
	local get_selected_heroic_deed_backend_id = self.parent:get_selected_heroic_deed_backend_id()

	if get_selected_heroic_deed_backend_id ~= self._selected_backend_id then
		self._selected_backend_id = get_selected_heroic_deed_backend_id

		self:_present_item_by_backend_id(get_selected_heroic_deed_backend_id)
	end

	if not self._selected_backend_id then
		self.parent:set_input_description("play_available")
	else
		self.parent:set_input_description(nil)
	end
end

StartGameWindowMutatorList._present_item_by_backend_id = function (self, arg_13_1)
	-- function 13
	if not arg_13_1 then
		return
	end

	local get_item_from_id = Managers.backend:get_interface("items"):get_item_from_id(arg_13_1)
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.item_presentation.content.item = get_item_from_id
	_widgets_by_name.play_button.content.button_hotspot.disable_button = false
	_widgets_by_name.overlay_button.content.has_item = true
end

StartGameWindowMutatorList.draw = function (self, arg_14_1)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_14_1, nil, self.render_settings)

	local _widgets = self._widgets

	for i = 1, #_widgets do
		local var_14_4 = _widgets[i]

		UIRenderer.draw_widget(ui_renderer, var_14_4)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameWindowMutatorList._play_sound = function (self, arg_15_1)
	-- function 15
	self.parent:play_sound(arg_15_1)
end

StartGameWindowMutatorList._update_game_options_hover_effect = function (self)
	-- function 16
	local overlay_button = self._widgets_by_name.overlay_button

	if not self:_is_button_hover_enter(overlay_button) then
		self:_on_option_button_hover_enter(overlay_button, 2)
	elseif not self:_is_button_hover_exit(overlay_button) then
		self:_on_option_button_hover_exit(overlay_button, 2)
	end
end

StartGameWindowMutatorList._on_option_button_hover_enter = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	self:_create_style_animation_enter(arg_17_1, 255, "glow", arg_17_2, arg_17_3)
	self:_create_style_animation_exit(arg_17_1, 0, "button_hover_rect", arg_17_2, arg_17_3)
end

StartGameWindowMutatorList._on_option_button_hover_exit = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	self:_create_style_animation_exit(arg_18_1, 0, "glow", arg_18_2, arg_18_3)
	self:_create_style_animation_enter(arg_18_1, 30, "button_hover_rect", arg_18_2, arg_18_3)
end

StartGameWindowMutatorList._create_style_animation_enter = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
	-- function 19
	local var_19_0 = arg_19_1.style[arg_19_3]

	if not var_19_0 then
		return
	end

	local var_19_1 = var_19_0.color[1]
	local var_19_2 = arg_19_2
	local num = 0.2
	local num_2 = (1 - var_19_1 / var_19_2) * num

	if not (not (num_2 > 0) or arg_19_5) then
		self._ui_animations[("game_option_" .. arg_19_3) .. "_hover_" .. arg_19_4] = self:_animate_element_by_time(var_19_0.color, 1, var_19_1, var_19_2, num_2)
	else
		var_19_0.color[1] = var_19_2
	end
end

StartGameWindowMutatorList._create_style_animation_exit = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5)
	-- function 20
	local var_20_0 = arg_20_1.style[arg_20_3]

	if not var_20_0 then
		return
	end

	local var_20_1 = var_20_0.color[1]
	local var_20_2 = arg_20_2
	local num = 0.2
	local num_2 = var_20_1 / 255 * num

	if not (not (num_2 > 0) or arg_20_5) then
		self._ui_animations[("game_option_" .. arg_20_3) .. "_hover_" .. arg_20_4] = self:_animate_element_by_time(var_20_0.color, 1, var_20_1, var_20_2, num_2)
	else
		var_20_0.color[1] = var_20_2
	end
end

StartGameWindowMutatorList._animate_pulse = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5))
end

StartGameWindowMutatorList._animate_element_by_time = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	return (UIAnimation.init(UIAnimation.function_by_time, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, math.ease_out_quad))
end
