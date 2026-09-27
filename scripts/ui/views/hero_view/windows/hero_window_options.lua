-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_options.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_options_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local num = 1

HeroWindowOptions = class(HeroWindowOptions)
HeroWindowOptions.NAME = "HeroWindowOptions"

HeroWindowOptions.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowOptions")

	self.parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_renderer = ingame_ui_context.ui_top_renderer
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

	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_1_4 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_1_4].careers[career_index].name

	self._animations = {}
	self._ui_animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.conditions_params = {
		hero_name = self.hero_name,
		career_name = name,
		rarities_to_ignore = table.enum_safe("magic")
	}

	local _widgets_by_name = self._widgets_by_name

	self.button_widgets_by_news_template = {
		equipment = _widgets_by_name.game_option_1,
		talent = _widgets_by_name.game_option_2,
		cosmetics = _widgets_by_name.game_option_4,
		loot_chest = _widgets_by_name.game_option_5
	}
end

HeroWindowOptions.create_ui_elements = function (self, arg_2_1, arg_2_2)
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

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()

	if not ((GameSettingsDevelopment.read_only_backend or not DamageUtils.is_in_inn) and current_mechanism_name ~= "versus") then
		tbl_2.game_option_3.content.button_hotspot.disable_button = true
		tbl_2.game_option_5.content.button_hotspot.disable_button = true
	end
end

HeroWindowOptions.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowOptions")

	self.ui_animator = nil
end

HeroWindowOptions.update = function (self, arg_4_1, arg_4_2)
	-- function 4
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_sync_news(arg_4_1, arg_4_2)
	self:_update_selected_option()
	self:_update_loadout_sync()
	self:_update_animations(arg_4_1)
	self:_update_hero_power_effect(arg_4_1)
	self:draw(arg_4_1)
end

HeroWindowOptions.post_update = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_handle_input(arg_5_1, arg_5_2)
end

HeroWindowOptions._update_animations = function (self, arg_6_1)
	-- function 6
	self:_update_game_options_hover_effect(arg_6_1)

	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_6_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	ui_animator:update(arg_6_1)

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowOptions._is_button_pressed = function (arg_7_0, arg_7_1)
	-- function 7
	local button_hotspot = arg_7_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		if not button_hotspot.is_selected then
			return true
		end
	end
end

HeroWindowOptions._is_stepper_button_pressed = function (arg_8_0, arg_8_1)
	-- function 8
	local content = arg_8_1.content
	local button_hotspot_left = content.button_hotspot_left
	local button_hotspot_right = content.button_hotspot_right

	if not button_hotspot_left.on_release then
		button_hotspot_left.on_release = false

		return true, -1
	elseif not button_hotspot_right.on_release then
		button_hotspot_right.on_release = false

		return true, 1
	end
end

HeroWindowOptions._is_button_hover_enter = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowOptions._is_button_hover_exit = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot
	local on_hover_exit = button_hotspot.on_hover_exit

	on_hover_exit = not on_hover_exit and not button_hotspot.is_selected

	return on_hover_exit
end

HeroWindowOptions._is_button_selected = function (arg_11_0, arg_11_1)
	-- function 11
	return arg_11_1.content.button_hotspot.is_selected
end

HeroWindowOptions._handle_input = function (self, arg_12_1, arg_12_2)
	-- function 12
	local _widgets_by_name = self._widgets_by_name
	local is_device_active = Managers.input:is_device_active("gamepad")
	local window_input_service = self.parent:window_input_service()

	if not self:_is_button_pressed(_widgets_by_name.game_option_1) then
		self.parent:set_layout(1)
	elseif not self:_is_button_pressed(_widgets_by_name.game_option_2) then
		self.parent:set_layout(2)
	elseif not self:_is_button_pressed(_widgets_by_name.game_option_3) then
		self.parent:set_layout(3)
	elseif not self:_is_button_pressed(_widgets_by_name.game_option_4) then
		self.parent:set_layout(4)
	elseif not self:_is_button_pressed(_widgets_by_name.game_option_5) then
		self:_play_sound("play_gui_lobby_button_00_custom")
		self.parent:requested_screen_change_by_name("loot")
	elseif not is_device_active then
		local get_selected_game_mode_index = self.parent:get_selected_game_mode_index()

		if not (not window_input_service:get("move_up_raw") and not (get_selected_game_mode_index > 1)) then
			self.parent:set_layout(get_selected_game_mode_index - 1)
		elseif not (not window_input_service:get("move_down_raw") and not (get_selected_game_mode_index < 4)) then
			self.parent:set_layout(get_selected_game_mode_index + 1)
		end
	end
end

HeroWindowOptions._update_game_options_hover_effect = function (self, arg_13_1)
	-- function 13
	local _widgets_by_name = self._widgets_by_name
	local str = "game_option_"

	for i = 1, 4 do
		local var_13_2 = _widgets_by_name[str .. i]

		UIWidgetUtils.animate_option_button(var_13_2, arg_13_1)

		if not self:_is_button_hover_enter(var_13_2) then
			self:_play_sound("play_gui_equipment_button_hover")
		end
	end

	UIWidgetUtils.animate_default_button(_widgets_by_name.game_option_5, arg_13_1)

	if self:_is_button_hover_enter(_widgets_by_name.game_option_5) or not self:_is_button_hover_enter(_widgets_by_name.hero_power_tooltip) then
		self:_play_sound("play_gui_equipment_button_hover")
	end
end

HeroWindowOptions._set_selected_option = function (self, arg_14_1)
	-- function 14
	local _widgets_by_name = self._widgets_by_name
	local str = "game_option_"

	for i = 1, 4 do
		_widgets_by_name[str .. i].content.button_hotspot.is_selected = arg_14_1 == i
	end
end

HeroWindowOptions._update_selected_option = function (self)
	-- function 15
	local get_selected_game_mode_index = self.parent:get_selected_game_mode_index()

	if get_selected_game_mode_index ~= self._selected_index then
		self:_set_selected_option(get_selected_game_mode_index)

		self._selected_index = get_selected_game_mode_index
	end
end

HeroWindowOptions._update_loadout_sync = function (self)
	-- function 16
	local loadout_sync_id = self.parent.loadout_sync_id

	if loadout_sync_id ~= self._loadout_sync_id or not self:_has_hero_level_changed() then
		self:_calculate_power_level()
		self:_update_experience_presentation()
		self:_update_hero_portrait_frame()

		self._loadout_sync_id = loadout_sync_id
	end
end

HeroWindowOptions._has_hero_level_changed = function (self)
	-- function 17
	local get_experience = ExperienceSettings.get_experience(self.hero_name)

	if ExperienceSettings.get_level(get_experience) ~= self._hero_level then
		return true
	end
end

HeroWindowOptions._update_experience_presentation = function (self)
	-- function 18
	local _widgets_by_name = self._widgets_by_name
	local get_experience = ExperienceSettings.get_experience(self.hero_name)
	local get_level, var_18_3 = ExperienceSettings.get_level(get_experience)
	local get_experience_pool = ExperienceSettings.get_experience_pool(self.hero_name)
	local get_extra_level, var_18_6 = ExperienceSettings.get_extra_level(get_experience_pool)
	local size = scenegraph_definition.experience_bar.size
	local size_2 = self.ui_scenegraph.experience_bar.size

	size_2[1] = math.ceil(size[1])

	if var_18_3 > 0 then
		size_2[1] = math.ceil(size_2[1] * var_18_3)
	elseif var_18_6 > 0 then
		size_2[1] = math.ceil(size_2[1] * var_18_6)
	end

	local str = Localize("level") .. " " .. tostring(get_level)

	if not (not get_extra_level and not (get_extra_level > 0)) then
		str = str .. " (+" .. tostring(get_extra_level) .. ")"
	end

	_widgets_by_name.level_text.content.text = str
	self._hero_level = get_level
end

HeroWindowOptions._calculate_power_level = function (self)
	-- function 19
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_19_2 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_19_2].careers[career_index].name
	local get_total_power_level = BackendUtils.get_total_power_level(hero_name, name)
	local presentable_hero_power_level = UIUtils.presentable_hero_power_level(get_total_power_level)
	local content = self._widgets_by_name.power_text.content
	local power = content.power

	power = not power and presentable_hero_power_level > content.power

	if not power then
		self._hero_power_effect_time = num

		self:_play_sound("play_gui_equipment_power_level_increase")
	end

	content.power = presentable_hero_power_level
	content.text = tostring(presentable_hero_power_level)
end

local get_color_table_with_alpha = Colors.get_color_table_with_alpha("white", 255)
local get_color_table_with_alpha_2 = Colors.get_color_table_with_alpha("font_title", 255)

HeroWindowOptions._update_hero_power_effect = function (self, arg_20_1)
	-- function 20
	local _hero_power_effect_time = self._hero_power_effect_time

	if not _hero_power_effect_time then
		local max = math.max(_hero_power_effect_time - arg_20_1, 0)
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

HeroWindowOptions._update_hero_portrait_frame = function (self)
	-- function 21
	local career_index = self.career_index
	local profile_index = self.profile_index
	local var_21_2 = SPProfiles[profile_index]
	local var_21_3 = var_21_2.careers[career_index]
	local portrait_image = var_21_3.portrait_image
	local display_name = var_21_3.display_name
	local character_name = var_21_2.character_name
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.hero_name.content.text = character_name
	_widgets_by_name.career_name.content.text = display_name

	local var_21_8

	if not self._hero_level then
		var_21_8 = tostring(self._hero_level)

		if not var_21_8 then
			-- Nothing
		end
	end

	var_21_8 = "-"

	::label_21_0::

	local _get_portrait_frame = self:_get_portrait_frame()

	self._portrait_widget = self:_create_portrait_frame_widget(_get_portrait_frame, portrait_image, var_21_8)
end

HeroWindowOptions.draw = function (self, arg_22_1)
	-- function 22
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_22_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not self._portrait_widget then
		UIRenderer.draw_widget(ui_renderer, self._portrait_widget)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_2, v_2 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_2)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

HeroWindowOptions._play_sound = function (self, arg_23_1)
	-- function 23
	self.parent:play_sound(arg_23_1)
end

HeroWindowOptions._create_portrait_frame_widget = function (self, arg_24_1, arg_24_2, arg_24_3)
	-- function 24
	local create_portrait_frame = UIWidgets.create_portrait_frame("portrait_root", arg_24_1, arg_24_3, 1, nil, arg_24_2)
	local var_24_1 = UIWidget.init(create_portrait_frame, self.ui_renderer)

	var_24_1.content.frame_settings_name = arg_24_1

	return var_24_1
end

HeroWindowOptions._get_portrait_frame = function (self)
	-- function 25
	local profile_index = self.profile_index
	local career_index = self.career_index
	local hero_name = self.hero_name
	local name = SPProfiles[profile_index].careers[career_index].name
	local str = "default"
	local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_frame")

	str = not get_loadout_item and get_loadout_item.data.temporary_template and str

	return str
end

HeroWindowOptions._create_style_animation_enter = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	local _ui_animations = self._ui_animations
	local str = "game_option_" .. arg_26_3
	local var_26_2 = arg_26_1.style[arg_26_3]
	local var_26_3 = var_26_2.color[1]
	local var_26_4 = arg_26_2
	local num = 0.2
	local num_2 = (1 - var_26_3 / var_26_4) * num

	if not (not (num_2 > 0) or arg_26_5) then
		_ui_animations[str .. "_hover_" .. arg_26_4] = self:_animate_element_by_time(var_26_2.color, 1, var_26_3, var_26_4, num_2)
	else
		var_26_2.color[1] = var_26_4
	end
end

HeroWindowOptions._create_style_animation_exit = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	-- function 27
	local _ui_animations = self._ui_animations
	local str = "game_option_" .. arg_27_3
	local var_27_2 = arg_27_1.style[arg_27_3]
	local var_27_3 = var_27_2.color[1]
	local var_27_4 = arg_27_2
	local num = 0.2
	local num_2 = var_27_3 / 255 * num

	if not (not (num_2 > 0) or arg_27_5) then
		_ui_animations[str .. "_hover_" .. arg_27_4] = self:_animate_element_by_time(var_27_2.color, 1, var_27_3, var_27_4, num_2)
	else
		var_27_2.color[1] = var_27_4
	end
end

HeroWindowOptions._animate_element_by_time = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	return (UIAnimation.init(UIAnimation.function_by_time, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5, math.ease_out_quad))
end

HeroWindowOptions._animate_element_by_catmullrom = function (arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8)
	-- function 29
	return (UIAnimation.init(UIAnimation.catmullrom, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5, arg_29_6, arg_29_7, arg_29_8))
end

HeroWindowOptions._sync_news = function (self, arg_30_1, arg_30_2)
	-- function 30
	local _sync_delay = self._sync_delay

	if not _sync_delay then
		local max = math.max(0, _sync_delay - arg_30_1)

		if max == 0 then
			self._sync_delay = nil
		else
			self._sync_delay = max
		end

		return
	end

	local local_player = Managers.player:local_player(1)

	if not local_player and not local_player.player_unit then
		local NewsFeedTemplates = NewsFeedTemplates
		local conditions_params = self.conditions_params
		local button_widgets_by_news_template = self.button_widgets_by_news_template

		for k, v in pairs(button_widgets_by_news_template) do
			local condition_func = NewsFeedTemplates[FindNewsTemplateIndex(k)].condition_func

			v.content.new = condition_func(conditions_params)
		end
	end

	self._sync_delay = 4
end
