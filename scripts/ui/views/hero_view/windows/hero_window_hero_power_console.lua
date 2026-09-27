-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_hero_power_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_hero_power_console_definitions")
local widgets = var_0_0.widgets
local category_settings = var_0_0.category_settings
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local num = 1

HeroWindowHeroPowerConsole = class(HeroWindowHeroPowerConsole)
HeroWindowHeroPowerConsole.NAME = "HeroWindowHeroPowerConsole"

HeroWindowHeroPowerConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowHeroPowerConsole")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index
	self.profile_index = arg_1_1.profile_index
	self._animations = {}
	self._ui_animations = {}
	self._hero_power_loadout_selection = {}

	self:create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter")
end

HeroWindowHeroPowerConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowHeroPowerConsole.create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self.ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end
end

HeroWindowHeroPowerConsole.on_exit = function (self, arg_4_1)
	-- function 4
	print("[HeroViewWindow] Exit Substate HeroWindowHeroPowerConsole")

	self.ui_animator = nil
end

HeroWindowHeroPowerConsole.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_loadout_sync()
	self:_update_animations(arg_5_1)
	self:_update_hero_power_effect(arg_5_1)
	self:draw(arg_5_1)
end

HeroWindowHeroPowerConsole.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

HeroWindowHeroPowerConsole._update_animations = function (self, arg_7_1)
	-- function 7
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_7_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_7_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowHeroPowerConsole._is_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local button_hotspot = arg_8_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowHeroPowerConsole.set_focus = function (self, arg_9_1)
	-- function 9
	self._focused = arg_9_1
end

HeroWindowHeroPowerConsole._update_loadout_sync = function (self)
	-- function 10
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id or not self:_has_hero_level_changed() then
		self:_calculate_power_level()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowHeroPowerConsole._has_hero_level_changed = function (self)
	-- function 11
	local get_experience = ExperienceSettings.get_experience(self.hero_name)

	if ExperienceSettings.get_level(get_experience) ~= self._hero_level then
		return true
	end
end

HeroWindowHeroPowerConsole._calculate_power_level = function (self)
	-- function 12
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_12_2 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_12_2].careers[career_index].name
	local get_total_power_level = BackendUtils.get_total_power_level(hero_name, name)
	local presentable_hero_power_level = UIUtils.presentable_hero_power_level(get_total_power_level)
	local content = self._widgets_by_name.power_text.content
	local get_selected_career_loadout = Managers.backend:get_interface("items"):get_selected_career_loadout(name)
	local power = content.power

	power = not power and presentable_hero_power_level > content.power

	if not power then
		self._hero_power_effect_time = num

		local var_12_9 = self._hero_power_loadout_selection[name]

		if not (not var_12_9 and get_selected_career_loadout ~= var_12_9) then
			self:_play_sound("play_gui_equipment_power_level_increase")
		end
	end

	content.power = presentable_hero_power_level
	content.text = tostring(presentable_hero_power_level)
	self._hero_power_loadout_selection[name] = get_selected_career_loadout
end

local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("font_title", 255)

HeroWindowHeroPowerConsole._update_hero_power_effect = function (self, arg_13_1)
	-- function 13
	local _hero_power_effect_time = self._hero_power_effect_time

	if not _hero_power_effect_time then
		local max = math.max(_hero_power_effect_time - arg_13_1, 0)
		local num_2 = 1 - max / num
		local easeOutCubic = math.easeOutCubic(num_2)
		local ease_pulse = math.ease_pulse(easeOutCubic)
		local _widgets_by_name = self._widgets_by_name
		local effect = _widgets_by_name.hero_power_tooltip.style.effect

		effect.angle = math.degrees_to_radians(120 * easeOutCubic)
		effect.color[1] = 255 * ease_pulse

		local text = _widgets_by_name.power_text.style.text

		Colors.lerp_color_tables(get_color_table_with_alpha, get_color_table_with_alpha_2, ease_pulse, text.text_color)

		if num_2 == 1 then
			self._hero_power_effect_time = nil
		else
			self._hero_power_effect_time = max
		end
	end
end

HeroWindowHeroPowerConsole._exit = function (self)
	-- function 14
	self.exit = true
end

HeroWindowHeroPowerConsole.draw = function (self, arg_15_1)
	-- function 15
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, window_input_service, arg_15_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

HeroWindowHeroPowerConsole._play_sound = function (self, arg_16_1)
	-- function 16
	self.parent:play_sound(arg_16_1)
end
