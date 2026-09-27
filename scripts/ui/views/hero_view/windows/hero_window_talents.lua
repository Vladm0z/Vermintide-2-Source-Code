-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_talents.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_talents_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local flag = false

HeroWindowTalents = class(HeroWindowTalents)
HeroWindowTalents.NAME = "HeroWindowTalents"

HeroWindowTalents.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowTalents")

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
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.player = local_player
	self.peer_id = ingame_ui_context.peer_id
	self._animations = {}

	self:create_ui_elements(arg_1_1, arg_1_2)

	self.hero_name = arg_1_1.hero_name
	self.career_index = arg_1_1.career_index

	local var_1_3 = FindProfileIndex(self.hero_name)

	self._career_name = SPProfiles[var_1_3].careers[self.career_index].name

	local get_experience = ExperienceSettings.get_experience(self.hero_name)

	self.hero_level = ExperienceSettings.get_level(get_experience)

	self:_initialize_talents()
end

HeroWindowTalents.on_exit = function (self, arg_2_1)
	-- function 2
	print("[HeroViewWindow] Exit Substate HeroWindowTalents")

	self.ui_animator = nil

	local _talent_interface = self._talent_interface
	local _career_name = self._career_name

	_talent_interface:set_talents(_career_name, self._selected_talents)

	local player_unit = self.player.player_unit

	if not Unit.alive(player_unit) then
		ScriptUnit.extension(player_unit, "talent_system"):talents_changed()
		ScriptUnit.extension(player_unit, "inventory_system"):apply_buffs_to_ammo()
	end
end

HeroWindowTalents.create_ui_elements = function (self, arg_3_1, arg_3_2)
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

HeroWindowTalents._initialize_talents = function (self)
	-- function 4
	local _career_name = self._career_name
	local get_interface = Managers.backend:get_interface("talents")
	local get_talents = get_interface:get_talents(_career_name)

	self._selected_talents = table.clone(get_talents)
	self._talent_interface = get_interface

	self:_update_talent_sync(true)

	self._initialized = true
end

HeroWindowTalents.update = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_5_1)
	self:_handle_input(arg_5_1, arg_5_2)
	self:draw(arg_5_1)
end

HeroWindowTalents.post_update = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	return
end

HeroWindowTalents._update_talent_sync = function (self, arg_7_1)
	-- function 7
	self:_populate_talents_by_hero(arg_7_1)
	self:_populate_career_info(arg_7_1)
end

HeroWindowTalents._update_animations = function (self, arg_8_1)
	-- function 8
	self.ui_animator:update(arg_8_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

HeroWindowTalents._is_button_pressed = function (arg_9_0, arg_9_1)
	-- function 9
	local button_hotspot = arg_9_1.content.button_hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

HeroWindowTalents._is_button_released = function (arg_10_0, arg_10_1)
	-- function 10
	local button_hotspot = arg_10_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowTalents._is_stepper_button_pressed = function (arg_11_0, arg_11_1)
	-- function 11
	local content = arg_11_1.content
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

HeroWindowTalents._is_button_hover_enter = function (arg_12_0, arg_12_1)
	-- function 12
	local button_hotspot = arg_12_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowTalents._handle_input = function (self, arg_13_1, arg_13_2)
	-- function 13
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name

	if self:_is_button_hover_enter(_widgets_by_name.career_perk_1) or self:_is_button_hover_enter(_widgets_by_name.career_perk_2) or not self:_is_button_hover_enter(_widgets_by_name.career_perk_3) then
		self:_play_sound("play_gui_equipment_button_hover")
	end

	if not self:_is_talent_hovered() then
		self:_play_sound("play_gui_talents_selection_hover")
	end

	if not self:_is_disabled_talent_hovered() then
		self:_play_sound("play_gui_talents_selection_hover_disabled")
	end

	local _is_talent_pressed, var_13_3 = self:_is_talent_pressed()

	if not _is_talent_pressed and not var_13_3 then
		if not (not self._selected_talents[_is_talent_pressed] and self._selected_talents[_is_talent_pressed] ~= 0) then
			self:_play_sound("play_gui_talent_unlock")
		else
			self:_play_sound("play_gui_talents_selection_click")
		end

		self._selected_talents[_is_talent_pressed] = var_13_3

		self:_update_talent_sync()
		parent:update_talent_sync()
	end
end

HeroWindowTalents.draw = function (self, arg_14_1)
	-- function 14
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local window_input_service = self.parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, window_input_service, arg_14_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_2, v_2 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(ui_renderer, v_2)
		end
	end

	UIRenderer.end_pass(ui_renderer)
end

HeroWindowTalents._play_sound = function (self, arg_15_1)
	-- function 15
	self.parent:play_sound(arg_15_1)
end

HeroWindowTalents._populate_talents_by_hero = function (self, arg_16_1)
	-- function 16
	self:_clear_talents()

	local _widgets_by_name = self._widgets_by_name
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_16_3 = FindProfileIndex(hero_name)
	local var_16_4 = SPProfiles[var_16_3].careers[career_index]
	local num = (career_index - 1) * NumTalentRows
	local var_16_6 = TalentTrees[hero_name][var_16_4.talent_tree_index]
	local _selected_talents = self._selected_talents
	local get_talent_overrides_by_career = PlayerUtils.get_talent_overrides_by_career(var_16_4.display_name)

	for i = 1, NumTalentRows do
		local var_16_9 = _widgets_by_name["talent_row_" .. i]

		if not var_16_9 then
			local content = var_16_9.content
			local style = var_16_9.style
			local var_16_12 = _selected_talents[i]
			local flag = not var_16_12 and var_16_12 == 0
			local str = "talent_point_" .. i
			local is_unlocked = ProgressionUnlocks.is_unlocked(str, self.hero_level)
			local get_color_table_with_alpha

			if not is_unlocked then
				get_color_table_with_alpha = Colors.get_color_table_with_alpha("green", 255)

				if not get_color_table_with_alpha then
					-- Nothing
				end
			end

			get_color_table_with_alpha = Colors.get_color_table_with_alpha("red", 255)

			::label_16_0::

			local get_unlock = ProgressionUnlocks.get_unlock(str)

			content.level_text = tostring(get_unlock.level_requirement)
			style.level_text.text_color = get_color_table_with_alpha

			if not (not is_unlocked and flag) then
				local animations = var_16_9.animations

				table.clear(animations)
			end

			local glow_frame = style.glow_frame

			glow_frame.color[1] = 0

			if not arg_16_1 and not is_unlocked and not flag then
				local _animate_pulse = self:_animate_pulse(glow_frame.color, 1, 255, 100, 2)

				UIWidget.animate(var_16_9, _animate_pulse)
			end

			for j = 1, NumTalentColumns do
				local flag_2 = var_16_12 == j
				local var_16_22 = var_16_6[i][j]
				local talent_id = TalentIDLookup[var_16_22].talent_id
				local get_talent_by_id = TalentUtils.get_talent_by_id(hero_name, talent_id)
				local str_2 = "_" .. tostring(j)
				local str_3 = "icon" .. str_2
				local str_4 = "hotspot" .. str_2
				local str_5 = "title_text" .. str_2
				local str_6 = "background_glow" .. str_2
				local var_16_30 = content[str_4]
				local flag_3 = not is_unlocked

				flag_3 = (flag_3 or not get_talent_overrides_by_career) and get_talent_overrides_by_career[var_16_22] == false

				if not ((flag_2 or not flag) and flag_3) then
					style[str_3].saturated = false
				else
					style[str_3].saturated = true
				end

				local icon

				if not get_talent_by_id then
					icon = get_talent_by_id.icon

					if not icon then
						-- Nothing
					end
				end

				icon = "icons_placeholder"

				::label_16_1::

				content[str_3] = icon

				local var_16_35

				if not get_talent_by_id then
					local Localize = Localize
					local display_name = get_talent_by_id.display_name

					display_name = display_name or get_talent_by_id.name
					var_16_35 = Localize(display_name)

					if not var_16_35 then
						-- Nothing
					end
				end

				var_16_35 = "Undefined"

				::label_16_2::

				content[str_5] = var_16_35
				var_16_30.is_selected = flag_2
				var_16_30.talent = get_talent_by_id
				var_16_30.talent_id = talent_id
				var_16_30.disabled = flag_3

				if not flag_3 then
					style[str_6].saturated = false
				else
					style[str_6].saturated = true
				end
			end
		end
	end
end

HeroWindowTalents._clear_talents = function (self)
	-- function 17
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_17_1 = _widgets_by_name["talent_row_" .. i]

		if not var_17_1 then
			local content = var_17_1.content
			local style = var_17_1.style

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local str_2 = "icon" .. str
				local str_3 = "hotspot" .. str
				local str_4 = "title_text" .. str

				content[str_2] = "icons_placeholder"
				content[str_4] = "Undefined"
				content[str_3].is_selected = false
				content[str_3].disabled = true
			end
		end
	end
end

HeroWindowTalents._is_talent_pressed = function (self)
	-- function 18
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_18_1 = _widgets_by_name["talent_row_" .. i]

		if not var_18_1 then
			local content = var_18_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_18_4 = content["hotspot" .. str]

				if not var_18_4.disabled then
					if not var_18_4.on_pressed then
						return i, j
					elseif not var_18_4.on_right_click and not var_18_4.is_selected then
						return i, 0
					end
				end
			end
		end
	end
end

HeroWindowTalents._is_talent_hovered = function (self)
	-- function 19
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_19_1 = _widgets_by_name["talent_row_" .. i]

		if not var_19_1 then
			local content = var_19_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_19_4 = content["hotspot" .. str]

				if not (not var_19_4.on_hover_enter and var_19_4.disabled) then
					return i, j
				end
			end
		end
	end
end

HeroWindowTalents._is_disabled_talent_hovered = function (self)
	-- function 20
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_20_1 = _widgets_by_name["talent_row_" .. i]

		if not var_20_1 then
			local content = var_20_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_20_4 = content["hotspot" .. str]

				if not var_20_4.on_hover_enter and not var_20_4.disabled then
					return i, j
				end
			end
		end
	end
end

HeroWindowTalents._populate_career_info = function (self, arg_21_1)
	-- function 21
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_21_2 = FindProfileIndex(hero_name)
	local var_21_3 = SPProfiles[var_21_2].careers[career_index]
	local name = var_21_3.name
	local character_selection_image = var_21_3.character_selection_image
	local _widgets_by_name = self._widgets_by_name
	local get_color_table_with_alpha

	if not Colors.color_definitions[name] then
		get_color_table_with_alpha = Colors.get_color_table_with_alpha(name, 255)

		if not get_color_table_with_alpha then
			-- Nothing
		end
	end

	get_color_table_with_alpha = {
		255,
		255,
		255,
		255
	}

	::label_21_0::

	_widgets_by_name.career_background.style.background.color = get_color_table_with_alpha

	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_21_3)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_21_3, 1)
	local display_name = get_passive_ability_by_career.display_name
	local icon = get_passive_ability_by_career.icon
	local display_name_2 = get_ability_data_by_career.display_name
	local icon_2 = get_ability_data_by_career.icon

	_widgets_by_name.passive_title_text.content.text = Localize(display_name)
	_widgets_by_name.passive_description_text.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	_widgets_by_name.passive_icon.content.texture_id = icon
	_widgets_by_name.active_title_text.content.text = Localize(display_name_2)
	_widgets_by_name.active_description_text.content.text = UIUtils.get_ability_description(get_ability_data_by_career)
	_widgets_by_name.active_icon.content.texture_id = icon_2

	local perks = get_passive_ability_by_career.perks

	for i, v in ipairs(perks) do
		local var_21_15 = _widgets_by_name["career_perk_" .. i]

		if not var_21_15 then
			local display_name_3 = v.display_name

			var_21_15.content.text = Localize(display_name_3)
			var_21_15.content.tooltip_data = v
		end
	end
end

HeroWindowTalents._animate_pulse = function (arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	-- function 22
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5))
end
