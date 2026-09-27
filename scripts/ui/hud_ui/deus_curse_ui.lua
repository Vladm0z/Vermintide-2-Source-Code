-- chunkname: @scripts/ui/hud_ui/deus_curse_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/deus_curse_ui_definitions")
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local scenegraph_methods = var_0_0.scenegraph_methods
local text_background_width = var_0_0.text_background_width
local num = -2

DeusCurseUI = class(DeusCurseUI)

DeusCurseUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	local game_mechanism = Managers.mechanism:game_mechanism()

	self._curse = not game_mechanism and game_mechanism:get_current_node_curse()
	self._theme = not game_mechanism and game_mechanism:get_current_node_theme()

	local _curse = self._curse

	_curse = not _curse and self._theme
	self._has_curse = _curse
	self._world = arg_1_2.world_manager:world("level_world")
	self._player_unit = arg_1_2.player.player_unit
	self._mission_system = Managers.state.entity:system("mission_system")

	Managers.state.event:register(self, "gm_event_round_started", "on_round_started")

	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.wwise_world = Managers.world:wwise_world(self._world)
	self._animations = {}
	self.render_settings = {
		snap_pixel_positions = true
	}

	self:create_ui_elements()

	if not self._has_curse then
		self:show_curse_info(self._theme, self._curse)
	end
end

DeusCurseUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	self._description_widget = UIWidget.init(var_0_0.widget_definitions.description_widget)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

DeusCurseUI.destroy = function (self)
	-- function 3
	Managers.state.event:unregister("gm_event_round_started", self)

	self.ui_animator = nil
end

DeusCurseUI.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not (script_data.debug_enabled or self._has_curse) then
		return
	end

	local _timer = self._timer

	if not _timer then
		local num = _timer - arg_4_1

		if num > 0 then
			self._timer = num
		else
			self._timer = nil

			self:on_timer_ended()
		end
	end

	local _has_curse = self._has_curse

	_has_curse = not _has_curse and RESOLUTION_LOOKUP.modified

	if not (not _has_curse and self._timer == nil) then
		self:show_curse_info(self._theme, self._curse)
	end

	if not self._has_curse then
		self:draw(arg_4_1)
		self:update_animations(arg_4_1)
	end
end

DeusCurseUI.on_timer_ended = function (self)
	-- function 5
	self:_clear_animations()
	self:_start_animation("curse_description_animation", "description_end")

	if not self._player_unit then
		return
	end

	ScriptUnit.extension(self._player_unit, "hud_system"):block_current_location_ui(false)
	self._mission_system:block_mission_ui(false)
end

DeusCurseUI.show_special_message = function (self, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
	-- function 6
	self._timer = arg_6_4

	local var_6_0 = DeusThemeSettings[arg_6_1]
	local curse_description_color = var_6_0.curse_description_color
	local icon = var_6_0.icon

	icon = icon or {
		255,
		255,
		255,
		255
	}

	local var_6_3

	if not var_6_0.curse_title then
		var_6_3 = Localize(var_6_0.curse_title)

		if not var_6_3 then
			-- Nothing
		end
	end

	var_6_3 = ""

	::label_6_0::

	arg_6_2 = Localize(arg_6_2)
	arg_6_3 = Localize(arg_6_3)

	self:_update_description_widget(var_6_3, arg_6_2, arg_6_3, icon, curse_description_color)
	self:_start_animation("curse_description_animation", "description_start")

	self._has_curse = true

	if not self._player_unit then
		return
	end

	ScriptUnit.extension(self._player_unit, "hud_system"):block_current_location_ui(true)
	self._mission_system:block_mission_ui(true)
end

DeusCurseUI.show_curse_info = function (self, arg_7_1, arg_7_2)
	-- function 7
	local is_round_started = Managers.state.game_mode:is_round_started()
	local _get_display_time = self:_get_display_time()

	self._timer = not is_round_started and _get_display_time and math.huge

	local var_7_2 = MutatorTemplates[arg_7_2]
	local var_7_3 = Localize(var_7_2.display_name)
	local var_7_4 = Localize(var_7_2.description)
	local var_7_5 = DeusThemeSettings[arg_7_1]
	local curse_description_color = var_7_5.curse_description_color
	local icon = var_7_5.icon

	icon = icon or {
		255,
		255,
		255,
		255
	}

	local var_7_8

	if not var_7_5.curse_title then
		var_7_8 = Localize(var_7_5.curse_title)

		if not var_7_8 then
			-- Nothing
		end
	end

	var_7_8 = ""

	::label_7_0::

	self:_update_description_widget(var_7_8, var_7_3, var_7_4, icon, curse_description_color)
	self:_start_animation("curse_description_animation", "description_start")

	self._has_curse = true

	if not self._player_unit then
		return
	end

	ScriptUnit.extension(self._player_unit, "hud_system"):block_current_location_ui(true)
	self._mission_system:block_mission_ui(true)
end

DeusCurseUI._update_description_widget = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	local content = self._description_widget.content

	content.theme_icon = arg_8_4
	content.title_text = arg_8_1
	content.curse_name = arg_8_2
	content.area_text_content = arg_8_3

	local get_text_height = UIUtils.get_text_height(self.ui_renderer, {
		text_background_width,
		0
	}, self._description_widget.style.area_text_style, arg_8_3)

	scenegraph_methods.change_widget_height(get_text_height)

	local style = self._description_widget.style

	style.top_detail_glow.color = arg_8_5
	style.bottom_glow.color = arg_8_5
	style.bottom_edge_glow.color = arg_8_5
	style.top_glow.color = arg_8_5
	style.top_edge_glow.color = arg_8_5
end

DeusCurseUI.on_round_started = function (self)
	-- function 9
	self._timer = self:_get_display_time()
end

DeusCurseUI.draw = function (self, arg_10_1)
	-- function 10
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_10_1, nil, render_settings)
	UIRenderer.draw_widget(ui_renderer, self._description_widget)
	UIRenderer.end_pass(ui_renderer)
end

DeusCurseUI._start_animation = function (self, arg_11_1, arg_11_2)
	-- function 11
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local start_animation = self.ui_animator:start_animation(arg_11_2, self._description_widget, scenegraph_definition, tbl)

	self._animations[arg_11_1] = start_animation
end

DeusCurseUI.update_animations = function (self, arg_12_1)
	-- function 12
	local _animations = self._animations
	local ui_animator = self.ui_animator

	ui_animator:update(arg_12_1)

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

DeusCurseUI._get_display_time = function (arg_13_0)
	-- function 13
	return MutatorCommonSettings.deus.initial_activation_delay + num
end

DeusCurseUI._clear_animations = function (self)
	-- function 14
	for k, v in pairs(self._animations) do
		self.ui_animator:stop_animation(v)
	end

	table.clear(self._animations)
end
