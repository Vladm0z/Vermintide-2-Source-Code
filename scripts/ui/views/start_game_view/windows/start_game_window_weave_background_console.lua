-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_weave_background_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_weave_background_console_definitions")
local top_widgets = var_0_0.top_widgets
local bottom_widgets = var_0_0.bottom_widgets
local bottom_hdr_widgets = var_0_0.bottom_hdr_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false

StartGameWindowWeaveBackgroundConsole = class(StartGameWindowWeaveBackgroundConsole)
StartGameWindowWeaveBackgroundConsole.NAME = "StartGameWindowWeaveBackgroundConsole"

StartGameWindowWeaveBackgroundConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[StartGameWindow] Enter Substate StartGameWindowWeaveBackgroundConsole")

	self._params = arg_1_1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui = ingame_ui_context.ingame_ui
	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._network_lobby = ingame_ui_context.network_lobby
	self._is_server = ingame_ui_context.is_server
	self._is_in_inn = ingame_ui_context.is_in_inn
	self._ui_hdr_renderer = self._parent:hdr_renderer()
	self._my_player = ingame_ui_context.player
	self._animations = {}
	self._ui_animations = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_play_sound("menu_wind_level_open")
end

StartGameWindowWeaveBackgroundConsole._create_ui_elements = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(top_widgets) do
		local var_2_2 = UIWidget.init(v)

		tbl_2[#tbl_2 + 1] = var_2_2
		tbl[k] = var_2_2
	end

	local tbl_3 = {}

	for k_2, v_2 in pairs(bottom_widgets) do
		local var_2_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_2_4
		tbl[k_2] = var_2_4
	end

	local tbl_4 = {}

	for k_3, v_3 in pairs(bottom_hdr_widgets) do
		local var_2_6 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_2_6
		tbl[k_3] = var_2_6
	end

	self._top_widgets = tbl_2
	self._bottom_widgets = tbl_3
	self._bottom_hdr_widgets = tbl_4
	self._widgets_by_name = tbl

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	self:_set_background_wheel_visibility(true)
end

StartGameWindowWeaveBackgroundConsole.on_exit = function (self, arg_3_1)
	-- function 3
	print("[StartGameWindow] Exit Substate StartGameWindowWeaveBackgroundConsole")

	self.ui_animator = nil

	self:_play_sound("menu_wind_level_close")
end

StartGameWindowWeaveBackgroundConsole.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self:_update_animations(arg_4_1, arg_4_2)
	self:draw(arg_4_1)
end

StartGameWindowWeaveBackgroundConsole.post_update = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	return
end

StartGameWindowWeaveBackgroundConsole._update_animations = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			_ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_6_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	if not self._draw_background_wheel then
		self:_update_background_animations(arg_6_1)
		self:_animate_wheel_position(arg_6_1)
		self:_animate_background_color(arg_6_1)
	end
end

StartGameWindowWeaveBackgroundConsole._set_background_wheel_visibility = function (self, arg_7_1)
	-- function 7
	local _widgets_by_name = self._widgets_by_name
	local background_wheel_1 = _widgets_by_name.background_wheel_1
	local hdr_background_wheel_1 = _widgets_by_name.hdr_background_wheel_1

	background_wheel_1.content.visible = arg_7_1
	hdr_background_wheel_1.content.visible = arg_7_1

	for i = 1, 2 do
		local var_7_3 = _widgets_by_name["wheel_ring_" .. i .. "_1"]
		local var_7_4 = _widgets_by_name["wheel_ring_" .. i .. "_2"]
		local var_7_5 = _widgets_by_name["wheel_ring_" .. i .. "_3"]
		local var_7_6 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_7_7 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_7_8 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]

		var_7_3.content.visible = arg_7_1
		var_7_4.content.visible = arg_7_1
		var_7_5.content.visible = arg_7_1
		var_7_6.content.visible = arg_7_1
		var_7_7.content.visible = arg_7_1
		var_7_8.content.visible = arg_7_1
	end

	self._draw_background_wheel = arg_7_1
end

StartGameWindowWeaveBackgroundConsole._update_background_animations = function (self, arg_8_1)
	-- function 8
	local _widgets_by_name = self._widgets_by_name

	for i = 1, 2 do
		local var_8_1 = _widgets_by_name["wheel_ring_" .. i .. "_1"]
		local var_8_2 = _widgets_by_name["wheel_ring_" .. i .. "_2"]
		local var_8_3 = _widgets_by_name["wheel_ring_" .. i .. "_3"]
		local var_8_4 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_8_5 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_8_6 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]
		local num = 360
		local degrees_to_radians = math.degrees_to_radians(num)
		local num_2 = arg_8_1 * 0.01
		local num_3 = arg_8_1 * 0.008
		local num_4 = arg_8_1 * 0.006

		var_8_1.style.texture_id.angle = (var_8_1.style.texture_id.angle + degrees_to_radians * num_2) % degrees_to_radians
		var_8_2.style.texture_id.angle = (var_8_2.style.texture_id.angle - degrees_to_radians * num_3) % -degrees_to_radians
		var_8_3.style.texture_id.angle = (var_8_3.style.texture_id.angle + degrees_to_radians * num_4) % degrees_to_radians
		var_8_4.style.texture_id.angle = var_8_1.style.texture_id.angle
		var_8_5.style.texture_id.angle = var_8_2.style.texture_id.angle
		var_8_6.style.texture_id.angle = var_8_3.style.texture_id.angle
	end

	local is_game_matchmaking = Managers.matchmaking:is_game_matchmaking()
	local flag

	flag = not is_game_matchmaking and 4 and 2.5

	local num_5 = 0.5 + math.sin(Managers.time:time("ui") * flag) * 0.5

	self:_set_background_bloom_intensity(num_5, is_game_matchmaking)
end

StartGameWindowWeaveBackgroundConsole._set_background_bloom_intensity = function (self, arg_9_1, arg_9_2)
	-- function 9
	local num = 1.39
	local flag

	flag = not arg_9_2 and 10 and 2

	local num_2 = num + math.clamp(arg_9_1, 0, 1) * flag
	local gui = self._ui_hdr_renderer.gui
	local _widgets_by_name = self._widgets_by_name
	local texture_id = _widgets_by_name.hdr_background_wheel_1.content.texture_id
	local material = Gui.material(gui, texture_id)

	Material.set_scalar(material, "noise_intensity", num_2)

	for i = 1, 2 do
		local var_9_7 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_1"]
		local var_9_8 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_2"]
		local var_9_9 = _widgets_by_name["hdr_wheel_ring_" .. i .. "_3"]
		local texture_id_2 = var_9_7.content.texture_id
		local texture_id_3 = var_9_8.content.texture_id
		local texture_id_4 = var_9_9.content.texture_id
		local material_2 = Gui.material(gui, texture_id_2)
		local material_3 = Gui.material(gui, texture_id_3)
		local material_4 = Gui.material(gui, texture_id_4)

		Material.set_scalar(material_2, "noise_intensity", num_2)
		Material.set_scalar(material_3, "noise_intensity", num_2)
		Material.set_scalar(material_4, "noise_intensity", num_2)
	end
end

StartGameWindowWeaveBackgroundConsole._play_sound = function (self, arg_10_1)
	-- function 10
	self._parent:play_sound(arg_10_1)
end

StartGameWindowWeaveBackgroundConsole._exit = function (self, arg_11_1)
	-- function 11
	self.exit = true
	self.exit_level_id = arg_11_1
end

StartGameWindowWeaveBackgroundConsole.draw = function (self, arg_12_1)
	-- function 12
	local ui_renderer = self._parent:ui_renderer()
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_hdr_renderer = self._ui_hdr_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_12_1, nil, _render_settings)

	for i, v in ipairs(self._top_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	UIRenderer.end_pass(_ui_top_renderer)
	UIRenderer.begin_pass(ui_renderer, _ui_scenegraph, window_input_service, arg_12_1, nil, _render_settings)

	for i_2, v_2 in ipairs(self._bottom_widgets) do
		UIRenderer.draw_widget(ui_renderer, v_2)
	end

	UIRenderer.end_pass(ui_renderer)
	UIRenderer.begin_pass(_ui_hdr_renderer, _ui_scenegraph, window_input_service, arg_12_1, nil, _render_settings)

	for i_3, v_3 in ipairs(self._bottom_hdr_widgets) do
		UIRenderer.draw_widget(_ui_hdr_renderer, v_3)
	end

	UIRenderer.end_pass(_ui_hdr_renderer)
end

StartGameWindowWeaveBackgroundConsole._play_sound = function (self, arg_13_1)
	-- function 13
	self._parent:play_sound(arg_13_1)
end

StartGameWindowWeaveBackgroundConsole._animate_pulse = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5)
	-- function 14
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_14_1, arg_14_2, arg_14_3, arg_14_4, arg_14_5))
end

StartGameWindowWeaveBackgroundConsole._animate_element_by_time = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
	-- function 15
	return (UIAnimation.init(UIAnimation.function_by_time, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5, math.ease_out_quad))
end

StartGameWindowWeaveBackgroundConsole._animate_element_by_catmullrom = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8)
	-- function 16
	return (UIAnimation.init(UIAnimation.catmullrom, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7, arg_16_8))
end

StartGameWindowWeaveBackgroundConsole._animate_wheel_position = function (self, arg_17_1)
	-- function 17
	local get_selected_layout_name = self._parent:get_selected_layout_name()
	local _current_offset = self._current_offset

	_current_offset = _current_offset or {
		0,
		0
	}
	self._current_offset = _current_offset

	local _starting_point = self._starting_point

	_starting_point = _starting_point or {
		0,
		0
	}
	self._starting_point = _starting_point

	local _offset_destinations = self._offset_destinations

	_offset_destinations = _offset_destinations or {
		weave_ranked = {
			300,
			120
		},
		weave_quickplay = {
			0,
			220
		},
		default = {
			0,
			0
		}
	}
	self._offset_destinations = _offset_destinations

	if self._old_selection_layout_name ~= get_selected_layout_name then
		self._starting_point[1] = self._current_offset[1]
		self._starting_point[2] = self._current_offset[2]
		self._old_selection_layout_name = get_selected_layout_name
		self._wheel_position_progress = 0
	end

	local num = 2
	local _wheel_position_progress = self._wheel_position_progress

	_wheel_position_progress = _wheel_position_progress or 0

	local min = math.min(_wheel_position_progress + num * arg_17_1, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local var_17_8 = self._offset_destinations[get_selected_layout_name]

	var_17_8 = var_17_8 or self._offset_destinations.default
	self._current_offset[1] = math.lerp(self._starting_point[1], var_17_8[1], easeOutCubic)
	self._current_offset[2] = math.lerp(self._starting_point[2], var_17_8[2], easeOutCubic)

	local str = "background_wheel"
	local num_2 = 1
	local var_17_11 = self._ui_scenegraph[str]
	local var_17_12 = scenegraph_definition[str]
	local position = var_17_11.position
	local position_2 = var_17_12.position

	position[num_2] = position_2[num_2] + self._current_offset[1]
	position[2] = position_2[2] + self._current_offset[2]
	self._wheel_position_progress = min
end

StartGameWindowWeaveBackgroundConsole._animate_background_color = function (self, arg_18_1, arg_18_2)
	-- function 18
	local get_selected_layout_name = self._parent:get_selected_layout_name()
	local _current_alpha = self._current_alpha

	_current_alpha = _current_alpha or 0
	self._current_alpha = _current_alpha

	local _starting_alpha = self._starting_alpha

	_starting_alpha = _starting_alpha or 0
	self._starting_alpha = _starting_alpha
	self._alpha_destinations = {
		lobby_browser_weave = 0.3,
		default = 0.1
	}

	if self._old_color_selection_layout_name ~= get_selected_layout_name then
		self._starting_alpha = self._current_alpha
		self._old_color_selection_layout_name = get_selected_layout_name
		self._alpha_progress = 0
	end

	local num = 0.5
	local _alpha_progress = self._alpha_progress

	_alpha_progress = _alpha_progress or 0

	local min = math.min(_alpha_progress + num * arg_18_1, 1)
	local easeOutCubic = math.easeOutCubic(min)
	local _starting_alpha_2 = self._starting_alpha
	local var_18_8 = self._alpha_destinations[get_selected_layout_name]

	var_18_8 = var_18_8 or self._alpha_destinations.default
	self._current_alpha = math.lerp(_starting_alpha_2, var_18_8, easeOutCubic)

	local window_background = self._widgets_by_name.window_background
	local style = window_background.style
	local content = window_background.content

	style.rect.color[2] = var_0_0.window_background_color[2] * self._current_alpha
	style.rect.color[3] = var_0_0.window_background_color[3] * self._current_alpha
	style.rect.color[4] = var_0_0.window_background_color[4] * self._current_alpha
	self._alpha_progress = min
end
