-- chunkname: @scripts/ui/hud_ui/level_countdown_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/level_countdown_ui_definitions")
local flag = true

LevelCountdownUI = class(LevelCountdownUI)

LevelCountdownUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.network_event_delegate = arg_1_2.network_event_delegate
	self.camera_manager = arg_1_2.camera_manager
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.is_in_inn = arg_1_2.is_in_inn
	self.is_server = arg_1_2.is_server
	self.world_manager = arg_1_2.world_manager
	self.input_manager = arg_1_2.input_manager
	self.matchmaking_manager = Managers.matchmaking

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	self:create_ui_elements()

	self.colors = {
		normal = Colors.get_table("font_default"),
		selected = Colors.get_table("font_title")
	}
end

LevelCountdownUI.create_ui_elements = function (self)
	-- function 2
	flag = false
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self.countdown_widget = UIWidget.init(var_0_0.widgets.fullscreen_countdown)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)
end

LevelCountdownUI.update = function (self, arg_3_1)
	-- function 3
	if not flag then
		self:create_ui_elements()

		self.colors = {
			normal = Colors.get_table("font_default"),
			selected = Colors.get_table("font_title")
		}
	end

	if not self.is_in_inn then
		return
	end

	if not self.ingame_ui.menu_suspended then
		return
	end

	local flag_2 = false
	local _get_start_time, var_3_2 = self:_get_start_time()

	if not _get_start_time and not var_3_2 then
		if not self:update_enter_game_counter(_get_start_time, var_3_2, arg_3_1) then
			flag_2 = true

			self:draw(arg_3_1)
		else
			self.last_timer_value = var_3_2
		end
	end

	self._countdown_active = flag_2
end

LevelCountdownUI.is_enter_game = function (self)
	-- function 4
	return self._countdown_active
end

LevelCountdownUI.draw = function (self, arg_5_1)
	-- function 5
	local get_service = self.input_manager:get_service("ingame_menu")
	local ui_renderer = self.ui_renderer

	UIRenderer.begin_pass(ui_renderer, self.ui_scenegraph, get_service, arg_5_1)
	UIRenderer.draw_widget(ui_renderer, self.countdown_widget)
	UIRenderer.end_pass(ui_renderer)
end

LevelCountdownUI.update_enter_game_counter = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	local countdown_widget = self.countdown_widget
	local content = countdown_widget.content
	local style = countdown_widget.style
	local colors = self.colors
	local round = math.round(arg_6_1)
	local flag = round ~= arg_6_2
	local var_6_6

	if round ~= self.last_timer_value then
		if round ~= 0 then
			var_6_6 = "Play_hud_matchmaking_countdown"
			content.timer_text = round
			self.color_timer = 0
		else
			var_6_6 = "Play_hud_matchmaking_countdown_final"
			content.timer_text = ""
		end

		self.last_timer_value = round

		Colors.lerp_color_tables(colors.normal, colors.selected, 0, style.timer_text.text_color)
	else
		local color_timer = self.color_timer

		if not color_timer then
			local num = 0.5
			local min = math.min(color_timer + arg_6_3, num)
			local num_2 = min / num

			self.color_timer = min

			Colors.lerp_color_tables(colors.normal, colors.selected, num_2, style.timer_text.text_color)
		end
	end

	if not flag and not var_6_6 then
		self:play_sound(var_6_6)
	end

	if arg_6_1 <= 0 then
		self.matchmaking_manager:countdown_completed()
	end

	return flag
end

LevelCountdownUI.play_sound = function (self, arg_7_1)
	-- function 7
	WwiseWorld.trigger_event(self.wwise_world, arg_7_1)
end

LevelCountdownUI._get_start_time = function (self)
	-- function 8
	local _get_active_waystone_extension = self:_get_active_waystone_extension()

	if not _get_active_waystone_extension then
		local end_time = _get_active_waystone_extension:end_time()

		return _get_active_waystone_extension:end_time_left(), end_time
	end
end

LevelCountdownUI._get_active_waystone_extension = function (arg_9_0)
	-- function 9
	if not Managers.state.entity then
		return
	end

	local get_entities = Managers.state.entity:get_entities("EndZoneExtension")

	for k, v in pairs(get_entities) do
		if not v:activated() then
			return v
		end
	end
end
