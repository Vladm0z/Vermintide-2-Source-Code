-- chunkname: @scripts/ui/hud_ui/weave_timer_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/weave_timer_ui_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition

WeaveTimerUI = class(WeaveTimerUI)
PROGRESS_CUTOFF = 0.9
BIG_SOUND_REMAINGING_TIME = 10

local flag = false

WeaveTimerUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self._ui_renderer = arg_1_2.ui_renderer
	self._ingame_ui_context = arg_1_2
	self._wwise_world = arg_1_2.wwise_world
	self._render_settings = {}
	self._old_diff = 0
	self._old_time = 0

	self:_create_ui_elements()
end

WeaveTimerUI.destroy = function (arg_2_0)
	-- function 2
	return
end

WeaveTimerUI._create_ui_elements = function (self)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local _render_settings = self._render_settings

	_render_settings = _render_settings or {}
	self._render_settings = _render_settings
	self._widgets = {}

	for k, v in pairs(widgets) do
		local var_3_1 = UIWidget.init(v)

		self._widgets[k] = var_3_1
	end

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)
end

WeaveTimerUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	self:_update_timer(arg_4_1, arg_4_2)
	self:_draw(arg_4_1, arg_4_2)
end

WeaveTimerUI._play_sound = function (self, arg_5_1)
	-- function 5
	WwiseWorld.trigger_event(self._wwise_world, arg_5_1)
end

WeaveTimerUI._update_timer = function (self, arg_6_1, arg_6_2)
	-- function 6
	local weave = Managers.weave

	if not weave:get_active_weave() then
		local get_time_left = weave:get_time_left()
		local max = math.max(get_time_left, 0)
		local floor = math.floor(max / 60)
		local floor_2 = math.floor(floor / 60)
		local format = string.format("%d:%02d", floor - floor_2 * 60, max % 60)
		local content = self._widgets.timer.content
		local progress = content.progress
		local num = 1 - get_time_left / WeaveSettings.max_time
		local time = Managers.time:time("game")

		if not (not (progress < PROGRESS_CUTOFF) or not (num >= PROGRESS_CUTOFF)) then
			self:_play_sound("menu_wind_countdown_warning")
		elseif not (not (num > PROGRESS_CUTOFF) or not (num < 1)) then
			local cos = math.cos(self._old_time * math.pi * 2)
			local num_2 = math.cos(time * math.pi * 2) - cos

			if not (not (self._old_diff > 0) or not (num_2 <= 0)) then
				if get_time_left < BIG_SOUND_REMAINGING_TIME + 1 then
					self:_play_sound("menu_wind_countdown_count_big")
				else
					self:_play_sound("menu_wind_countdown_count_small")
				end
			end

			self._old_diff = num_2
		end

		content.progress = num
		content.progress_cutoff = PROGRESS_CUTOFF
		content.timer_text_id = format
		self._old_time = time
	end
end

WeaveTimerUI._update_bar = function (self, arg_7_1, arg_7_2)
	-- function 7
	local weave = Managers.weave

	if not weave:get_active_weave() then
		local get_time_left = weave:get_time_left()
		local max = math.max(get_time_left, 0)
		local floor = math.floor(max / 60)
		local floor_2 = math.floor(floor / 60)
		local content

		content.timer_text_id, content.progress, content = string.format("%02d:%02d:%02d", floor_2, floor - floor_2 * 60, max % 60), 1 - get_time_left / WeaveSettings.max_time, self._widgets.timer_bar.content
	end
end

WeaveTimerUI._draw = function (self, arg_8_1, arg_8_2)
	-- function 8
	local _ui_renderer = self._ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _render_settings = self._render_settings
	local get_service = Managers.input:get_service("ingame_menu")

	UIRenderer.begin_pass(_ui_renderer, _ui_scenegraph, get_service, arg_8_1, nil, _render_settings)

	for k, v in pairs(self._widgets) do
		UIRenderer.draw_widget(_ui_renderer, v)
	end

	UIRenderer.end_pass(_ui_renderer)
end
