-- chunkname: @scripts/ui/dlc_morris/views/start_game_view/windows/start_game_window_deus_chaos_god_information.lua

local var_0_0 = local_require("scripts/ui/dlc_morris/views/start_game_view/windows/definitions/start_game_window_deus_chaos_god_information_definitions")
local widgets = var_0_0.widgets

StartGameWindowDeusChaosGodInformation = class(StartGameWindowDeusChaosGodInformation)

StartGameWindowDeusChaosGodInformation.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ingame_ui_context = ingame_ui_context
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._animations = {}
	self._render_settings = {
		snap_pixel_positions = true
	}

	self:_create_ui_elements(var_0_0, arg_1_1, arg_1_2)

	self._should_draw = false

	self:_start_animation("on_enter", self._widgets_by_name.god_info_widget)
end

StartGameWindowDeusChaosGodInformation.on_exit = function (arg_2_0, arg_2_1)
	-- function 2
	table.clear(arg_2_0)
end

StartGameWindowDeusChaosGodInformation._create_ui_elements = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	self._scenegraph_definition = arg_3_1.scenegraph_definition
	self._ui_scenegraph = UISceneGraph.init_scenegraph(arg_3_1.scenegraph_definition)
	self._ui_animator = UIAnimator:new(self._ui_scenegraph, arg_3_1.animation_definitions)
	self._refresh_time = 0

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_top_renderer)
	self:_setup_belakor_information()
end

StartGameWindowDeusChaosGodInformation._start_animation = function (self, arg_4_1, arg_4_2, arg_4_3)
	-- function 4
	arg_4_3 = arg_4_3 or {}
	arg_4_3.render_settings = self._render_settings
	self._animations[arg_4_1] = self._ui_animator:start_animation(arg_4_1, arg_4_2, self._scenegraph_definition, arg_4_3)
end

StartGameWindowDeusChaosGodInformation.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_update_animations(arg_5_1, arg_5_2)
	self:_update_time_left()
	self:_update_journey()

	if not self._should_draw then
		self:_draw(arg_5_1, arg_5_2)
	end
end

StartGameWindowDeusChaosGodInformation._update_journey = function (self)
	-- function 6
	local get_selected_level_id = self._parent:get_selected_level_id()

	get_selected_level_id = get_selected_level_id or self._journey_name

	if get_selected_level_id ~= self._journey_name then
		self._journey_name = get_selected_level_id

		self:_update_theme()
		self:_update_belakor_status()
	end
end

StartGameWindowDeusChaosGodInformation.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

StartGameWindowDeusChaosGodInformation._update_animations = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _ui_animator = self._ui_animator

	_ui_animator:update(arg_8_1)

	local _animations = self._animations

	for k, v in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v) then
			_animations[k] = nil
		end
	end
end

StartGameWindowDeusChaosGodInformation._draw = function (self, arg_9_1, arg_9_2)
	-- function 9
	local _ui_top_renderer = self._ui_top_renderer
	local window_input_service = self._parent:window_input_service()

	UIRenderer.begin_pass(_ui_top_renderer, self._ui_scenegraph, window_input_service, arg_9_1, nil, self._render_settings)

	for i = 1, #self._widgets do
		local var_9_2 = self._widgets[i]

		UIRenderer.draw_widget(_ui_top_renderer, var_9_2)
	end

	UIRenderer.end_pass(_ui_top_renderer)
end

StartGameWindowDeusChaosGodInformation._refresh_journey_data = function (self)
	-- function 10
	local get_journey_cycle = Managers.backend:get_interface("deus"):get_journey_cycle()

	self._journey_cycle = get_journey_cycle
	self._refresh_time = get_journey_cycle.remaining_time + get_journey_cycle.time_of_update

	self:_update_theme()
end

StartGameWindowDeusChaosGodInformation._update_time_left = function (self)
	-- function 11
	local time = Managers.time:time("main")
	local num = self._refresh_time - time
	local content = self._widgets_by_name.god_info_widget.content

	if num > 120 then
		local num_2 = num / 86400
		local num_3 = num / 3600 % 24
		local num_4 = num / 60 % 60
		local var_11_6 = Localize("deus_start_game_mod_timer")

		content.subtitle = string.format(var_11_6, num_2, num_3, num_4)
	else
		local var_11_7 = Localize("deus_start_game_mod_timer_seconds")

		if num < 0 then
			num = 0

			self:_refresh_journey_data()
		end

		content.subtitle = string.format(var_11_7, num)
	end

	self:_update_belakor_time_left()
end

StartGameWindowDeusChaosGodInformation._update_theme = function (self, arg_12_1)
	-- function 12
	local _journey_name = self._journey_name
	local var_12_1 = self._journey_cycle.journey_data[_journey_name]
	local flag = not var_12_1 and var_12_1.dominant_god
	local flag_2 = not flag and DeusThemeSettings[flag]

	if not flag_2 then
		self._should_draw = false

		return
	end

	self._should_draw = true

	local get_current_window_layout_settings = self._parent:get_current_window_layout_settings()

	if not get_current_window_layout_settings and not get_current_window_layout_settings.should_draw_god_info then
		self._should_draw = get_current_window_layout_settings.should_draw_god_info(self._ingame_ui_context)
	end

	self:_start_animation("set_theme", self._widgets_by_name.god_info_widget, {
		theme_settings = flag_2
	})
end

StartGameWindowDeusChaosGodInformation._setup_belakor_information = function (self)
	-- function 13
	self._belakor_refresh_time = 0
	self._is_refreshing_belakor = false
	self._widgets_by_name.belakor_info_widget.content.visible = false

	self:_refresh_belakor_curse_data()
end

StartGameWindowDeusChaosGodInformation._refresh_belakor_curse_data = function (self)
	-- function 14
	local get_belakor_cycle = Managers.backend:get_interface("deus"):get_belakor_cycle()

	if not get_belakor_cycle then
		return false
	end

	self._belakor_data = get_belakor_cycle
	self._belakor_refresh_time = get_belakor_cycle.remaining_time + get_belakor_cycle.time_of_update

	Managers.state.event:trigger("_update_additional_curse_frame", self._belakor_data.journey_name)
end

StartGameWindowDeusChaosGodInformation._update_belakor_time_left = function (self)
	-- function 15
	local time = Managers.time:time("main")
	local get_interface = Managers.backend:get_interface("deus")
	local deus_journey_with_belakor = get_interface:deus_journey_with_belakor(self._journey_name)
	local max = math.max(self._belakor_refresh_time - time, 0)

	if not deus_journey_with_belakor then
		local content = self._widgets_by_name.belakor_info_widget.content

		if max > 120 then
			local num = max / 3600 % 24
			local num_2 = max / 60 % 60
			local var_15_7 = Localize("datetime_hours_short")
			local var_15_8 = Localize("datetime_minutes_short")

			content.subtitle = string.format(var_15_7, num) .. " " .. string.format(var_15_8, num_2)
		else
			local var_15_9 = Localize("deus_start_game_mod_timer_seconds")

			content.subtitle = string.format(var_15_9, max)
		end
	end

	if max <= 0 then
		if not self._is_refreshing_belakor then
			if not get_interface:has_loaded_belakor_data() then
				self._is_refreshing_belakor = false

				self:_refresh_belakor_curse_data()
				self:_update_belakor_status()
			end
		else
			self._is_refreshing_belakor = true

			get_interface:refresh_belakor_cycle()
		end
	end
end

StartGameWindowDeusChaosGodInformation._update_belakor_status = function (self)
	-- function 16
	local deus_journey_with_belakor = Managers.backend:get_interface("deus"):deus_journey_with_belakor(self._journey_name)
	local belakor_info_widget = self._widgets_by_name.belakor_info_widget

	if not deus_journey_with_belakor then
		self:_start_animation("set_theme_belakor", belakor_info_widget, {
			theme_settings = DeusThemeSettings.belakor
		})
	end

	belakor_info_widget.content.visible = deus_journey_with_belakor
end
