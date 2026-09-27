-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_talents_console.lua

require("scripts/ui/hud_ui/scrollbar_ui")

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_talents_console_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local generic_input_actions = var_0_0.generic_input_actions
local NUM_PERKS = var_0_0.NUM_PERKS
local flag = false

HeroWindowTalentsConsole = class(HeroWindowTalentsConsole)
HeroWindowTalentsConsole.NAME = "HeroWindowTalentsConsole"

HeroWindowTalentsConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowTalentsConsole")

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
	self:_start_transition_animation("on_enter")
end

HeroWindowTalentsConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowTalentsConsole.on_exit = function (self, arg_3_1)
	-- function 3
	print("[HeroViewWindow] Exit Substate HeroWindowTalentsConsole")

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

HeroWindowTalentsConsole._inject_additional_scenegraph_definitions = function (arg_4_0, arg_4_1)
	-- function 4
	for k, v in pairs(CareerSettings) do
		if not v.additional_ui_info_file then
			local var_4_0 = local_require(v.additional_ui_info_file)

			for k_2, v_2 in pairs(var_4_0.scenegraph_definition_to_inject) do
				arg_4_1[k_2] = v_2
			end
		end
	end
end

HeroWindowTalentsConsole.create_ui_elements = function (self, arg_5_1, arg_5_2)
	-- function 5
	self:_inject_additional_scenegraph_definitions(scenegraph_definition)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_5_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_5_2
		tbl_2[k] = var_5_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2
	self._additional_widgets = {}
	self._additional_widgets_by_name = {}

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self.ui_top_renderer, get_service, 7, num, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_5_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_5_2[1]
		local_position[2] = local_position[2] + arg_5_2[2]
		local_position[3] = local_position[3] + arg_5_2[3]
	end
end

HeroWindowTalentsConsole._initialize_talents = function (self)
	-- function 6
	local _career_name = self._career_name
	local get_interface = Managers.backend:get_interface("talents")
	local get_talents = get_interface:get_talents(_career_name)

	self._selected_talents = table.clone(get_talents)
	self._talent_interface = get_interface

	self:_update_talents(true)

	self._initialized = true
	self._talent_sync_id = self.parent.talent_sync_id
end

HeroWindowTalentsConsole._input_service = function (self)
	-- function 7
	local parent = self.parent

	if not parent:is_friends_list_active() then
		return FAKE_INPUT_SERVICE
	end

	return parent:window_input_service()
end

HeroWindowTalentsConsole.update = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_animations(arg_8_1)
	self:_update_talent_sync()
	self:_handle_gamepad_input(arg_8_1, arg_8_2)
	self:_handle_input(arg_8_1, arg_8_2)
	self:draw(arg_8_1, arg_8_2)
end

HeroWindowTalentsConsole.post_update = function (arg_9_0, arg_9_1, arg_9_2)
	-- function 9
	return
end

HeroWindowTalentsConsole._update_talents = function (self, arg_10_1)
	-- function 10
	self:_populate_talents_by_hero(arg_10_1)
	self:_populate_career_info(arg_10_1)
	self:_update_backend_talents(arg_10_1)
end

HeroWindowTalentsConsole._update_backend_talents = function (self, arg_11_1)
	-- function 11
	if not arg_11_1 then
		return
	end

	local _talent_interface = self._talent_interface
	local _career_name = self._career_name

	_talent_interface:set_talents(_career_name, self._selected_talents)
end

HeroWindowTalentsConsole._update_animations = function (self, arg_12_1)
	-- function 12
	self.ui_animator:update(arg_12_1)

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

HeroWindowTalentsConsole._is_button_pressed = function (arg_13_0, arg_13_1)
	-- function 13
	local button_hotspot = arg_13_1.content.button_hotspot

	if not button_hotspot.on_pressed then
		button_hotspot.on_pressed = false

		return true
	end
end

HeroWindowTalentsConsole._is_button_released = function (arg_14_0, arg_14_1)
	-- function 14
	local button_hotspot = arg_14_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroWindowTalentsConsole._is_stepper_button_pressed = function (arg_15_0, arg_15_1)
	-- function 15
	local content = arg_15_1.content
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

HeroWindowTalentsConsole._is_button_hover_enter = function (arg_16_0, arg_16_1)
	-- function 16
	local button_hotspot = arg_16_1.content.button_hotspot
	local on_hover_enter = button_hotspot.on_hover_enter

	on_hover_enter = not on_hover_enter and not button_hotspot.is_selected

	return on_hover_enter
end

HeroWindowTalentsConsole._handle_gamepad_input = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _input_service = self:_input_service()
	local _focused_row = self._focused_row
	local _focused_column = self._focused_column

	if not _focused_row and not _focused_column then
		local flag = false

		if not (_focused_column > 1) or not _input_service:get("move_left_hold_continuous") then
			_focused_column = _focused_column - 1
			flag = true
		elseif not (_focused_column < NumTalentColumns) or not _input_service:get("move_right_hold_continuous") then
			_focused_column = _focused_column + 1
			flag = true
		end

		if not (_focused_row > 1) or not _input_service:get("move_up_hold_continuous") then
			_focused_row = _focused_row - 1
			flag = true
		elseif not (_focused_row < NumTalentRows) or not _input_service:get("move_down_hold_continuous") then
			_focused_row = _focused_row + 1
			flag = true
		end

		if not flag then
			self:_set_talent_focused(_focused_row, _focused_column)
			self:_play_sound("play_gui_talents_selection_hover")
		end

		local _can_press_talent, var_17_5 = self:_can_press_talent(_focused_row, _focused_column)

		if not _can_press_talent then
			if var_17_5 or not _input_service:get("confirm", true) then
				self:_set_talent_selected(_focused_row, _focused_column)
			elseif not _input_service:get("refresh", true) then
				self:_set_talent_selected(_focused_row, 0)
			end
		end
	end
end

HeroWindowTalentsConsole._handle_input = function (self, arg_18_1, arg_18_2)
	-- function 18
	local parent = self.parent
	local _widgets_by_name = self._widgets_by_name
	local _is_talent_hovered, var_18_3 = self:_is_talent_hovered()

	if not _is_talent_hovered and not var_18_3 then
		self:_play_sound("play_gui_talents_selection_hover")
		self:_set_talent_focused(_is_talent_hovered, var_18_3)
	end

	if not self:_is_disabled_talent_hovered() then
		self:_play_sound("play_gui_talents_selection_hover_disabled")
	end

	local _is_talent_pressed, var_18_5 = self:_is_talent_pressed()

	if not _is_talent_pressed and not var_18_5 then
		self:_set_talent_selected(_is_talent_pressed, var_18_5)
	end
end

HeroWindowTalentsConsole._set_talent_selected = function (self, arg_19_1, arg_19_2)
	-- function 19
	local _selected_talents = self._selected_talents

	if not (not _selected_talents[arg_19_1] and _selected_talents[arg_19_1] ~= 0 and arg_19_2 == 0) then
		self:_play_sound("play_gui_talent_unlock")
	else
		self:_play_sound("play_gui_talents_selection_click")
	end

	_selected_talents[arg_19_1] = arg_19_2

	self:_update_talents()
	self.parent:update_talent_sync()

	self._talent_sync_id = self.parent.talent_sync_id
end

HeroWindowTalentsConsole._update_talent_sync = function (self)
	-- function 20
	local talent_sync_id = self.parent.talent_sync_id

	if talent_sync_id ~= self._talent_sync_id then
		local _career_name = self._career_name
		local get_interface = Managers.backend:get_interface("talents")
		local get_talents = get_interface:get_talents(_career_name)

		self._selected_talents = table.clone(get_talents)
		self._talent_interface = get_interface

		self:_update_talents(true)

		self._talent_sync_id = talent_sync_id
	end
end

HeroWindowTalentsConsole.draw = function (self, arg_21_1, arg_21_2)
	-- function 21
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _input_service = self:_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, _ui_scenegraph, _input_service, arg_21_1, nil, self.render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	local _active_node_widgets = self._active_node_widgets

	if not _active_node_widgets then
		for i_2, v_2 in ipairs(_active_node_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end
	end

	for i_3, v_3 in ipairs(self._additional_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_3)
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not (not is_device_active and self.parent:input_blocked()) then
		self._menu_input_description:draw(ui_top_renderer, arg_21_1)
	end

	if not self._scrollbar then
		self._scrollbar:update(arg_21_1, arg_21_2, ui_top_renderer, _input_service, self.render_settings)
	end
end

HeroWindowTalentsConsole._play_sound = function (self, arg_22_1)
	-- function 22
	self.parent:play_sound(arg_22_1)
end

HeroWindowTalentsConsole._populate_talents_by_hero = function (self, arg_23_1)
	-- function 23
	self:_clear_talents()

	local _widgets_by_name = self._widgets_by_name
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_23_3 = FindProfileIndex(hero_name)
	local var_23_4 = SPProfiles[var_23_3].careers[career_index]
	local num = (career_index - 1) * NumTalentRows
	local var_23_6 = TalentTrees[hero_name][var_23_4.talent_tree_index]
	local _selected_talents = self._selected_talents
	local get_talent_overrides_by_career = PlayerUtils.get_talent_overrides_by_career(var_23_4.display_name)

	for i = 1, NumTalentRows do
		local var_23_9 = _widgets_by_name["talent_row_" .. i]

		if not var_23_9 then
			local content = var_23_9.content
			local style = var_23_9.style
			local var_23_12 = _selected_talents[i]
			local flag = not var_23_12 and var_23_12 == 0
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

			::label_23_0::

			local get_unlock = ProgressionUnlocks.get_unlock(str)

			content.level_text = tostring(get_unlock.level_requirement)
			style.level_text.text_color = get_color_table_with_alpha

			if not (not is_unlocked and flag) then
				local animations = var_23_9.animations

				table.clear(animations)
			end

			local glow_frame = style.glow_frame

			glow_frame.color[1] = 0

			if not arg_23_1 and not is_unlocked and not flag then
				local _animate_pulse = self:_animate_pulse(glow_frame.color, 1, 255, 100, 2)

				UIWidget.animate(var_23_9, _animate_pulse)
			end

			for j = 1, NumTalentColumns do
				local flag_2 = var_23_12 == j
				local var_23_22 = var_23_6[i][j]
				local talent_id = TalentIDLookup[var_23_22].talent_id
				local get_talent_by_id = TalentUtils.get_talent_by_id(hero_name, talent_id)
				local str_2 = "_" .. tostring(j)
				local str_3 = "icon" .. str_2
				local str_4 = "hotspot" .. str_2
				local str_5 = "title_text" .. str_2
				local str_6 = "background_glow" .. str_2
				local var_23_30 = content[str_4]
				local flag_3 = not is_unlocked

				flag_3 = (flag_3 or not get_talent_overrides_by_career) and get_talent_overrides_by_career[var_23_22] == false

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

				::label_23_1::

				content[str_3] = icon

				local var_23_35

				if not get_talent_by_id then
					local Localize = Localize
					local display_name = get_talent_by_id.display_name

					display_name = display_name or get_talent_by_id.name
					var_23_35 = Localize(display_name)

					if not var_23_35 then
						-- Nothing
					end
				end

				var_23_35 = "Undefined"

				::label_23_2::

				content[str_5] = var_23_35
				var_23_30.is_selected = flag_2
				var_23_30.talent = get_talent_by_id
				var_23_30.talent_id = talent_id
				var_23_30.disabled = flag_3

				if not flag_3 then
					style[str_6].saturated = false
				else
					style[str_6].saturated = true
				end
			end
		end
	end

	local var_23_36 = self
	local _set_talent_focused = self._set_talent_focused
	local _focused_row = self._focused_row

	_focused_row = _focused_row or 1

	local _focused_column = self._focused_column

	_focused_column = _focused_column or 1

	_set_talent_focused(var_23_36, _focused_row, _focused_column)
end

HeroWindowTalentsConsole._clear_talents = function (self)
	-- function 24
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_24_1 = _widgets_by_name["talent_row_" .. i]

		if not var_24_1 then
			local content = var_24_1.content
			local style = var_24_1.style

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

HeroWindowTalentsConsole._set_talent_focused = function (self, arg_25_1, arg_25_2)
	-- function 25
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_25_1 = _widgets_by_name["talent_row_" .. i]

		if not var_25_1 then
			local content = var_25_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_25_4 = content["hotspot" .. str]
				local flag = i ~= arg_25_1 or j == arg_25_2

				var_25_4.focused = flag

				if not flag then
					local talent = var_25_4.talent
					local disabled = var_25_4.disabled
					local is_selected = var_25_4.is_selected

					self:_set_talent_tooltip(talent, is_selected, disabled)
				end
			end
		end
	end

	self._focused_row = arg_25_1
	self._focused_column = arg_25_2
end

HeroWindowTalentsConsole._can_press_talent = function (self, arg_26_1, arg_26_2)
	-- function 26
	local var_26_0 = self._widgets_by_name["talent_row_" .. arg_26_1].content["hotspot_" .. arg_26_2]

	return not var_26_0.disabled, var_26_0.is_selected
end

HeroWindowTalentsConsole._is_talent_pressed = function (self)
	-- function 27
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_27_1 = _widgets_by_name["talent_row_" .. i]

		if not var_27_1 then
			local content = var_27_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_27_4 = content["hotspot" .. str]

				if not var_27_4.disabled then
					if not (not var_27_4.on_pressed and var_27_4.is_selected) then
						return i, j
					elseif not var_27_4.on_right_click then
						return i, 0
					end
				end
			end
		end
	end
end

HeroWindowTalentsConsole._is_talent_hovered = function (self)
	-- function 28
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_28_1 = _widgets_by_name["talent_row_" .. i]

		if not var_28_1 then
			local content = var_28_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_28_4 = content["hotspot" .. str]

				if not (not var_28_4.on_hover_enter and var_28_4.disabled) then
					return i, j
				end
			end
		end
	end
end

HeroWindowTalentsConsole._is_disabled_talent_hovered = function (self)
	-- function 29
	local _widgets_by_name = self._widgets_by_name

	for i = 1, NumTalentRows do
		local var_29_1 = _widgets_by_name["talent_row_" .. i]

		if not var_29_1 then
			local content = var_29_1.content

			for j = 1, NumTalentColumns do
				local str = "_" .. tostring(j)
				local var_29_4 = content["hotspot" .. str]

				if not var_29_4.on_hover_enter and not var_29_4.disabled then
					return i, j
				end
			end
		end
	end
end

HeroWindowTalentsConsole._populate_career_info = function (self, arg_30_1)
	-- function 30
	local ui_renderer = self.ui_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_30_4 = FindProfileIndex(hero_name)
	local var_30_5 = SPProfiles[var_30_4].careers[career_index]
	local name = var_30_5.name
	local character_selection_image = var_30_5.character_selection_image
	local display_name = var_30_5.display_name
	local _widgets_by_name = self._widgets_by_name

	if not (not Colors.color_definitions[name] and Colors.get_color_table_with_alpha(name, 255)) then
		local tbl = {
			255,
			255,
			255,
			255
		}
	end

	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_30_5)
	local get_ability_data_by_career = CareerUtils.get_ability_data_by_career(var_30_5, 1)
	local display_name_2 = get_passive_ability_by_career.display_name
	local icon = get_passive_ability_by_career.icon
	local display_name_3 = get_ability_data_by_career.display_name
	local icon_2 = get_ability_data_by_career.icon

	_widgets_by_name.passive_title_text.content.text = Localize(display_name_2)
	_widgets_by_name.passive_description_text.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	_widgets_by_name.passive_icon.content.texture_id = icon
	_widgets_by_name.active_title_text.content.text = Localize(display_name_3)
	_widgets_by_name.active_description_text.content.text = UIUtils.get_ability_description(get_ability_data_by_career)
	_widgets_by_name.active_icon.content.texture_id = icon_2

	local perks = get_passive_ability_by_career.perks
	local num = 0
	local num_2 = 0

	for i = 1, NUM_PERKS do
		local var_30_20 = _widgets_by_name["career_perk_" .. i]
		local content = var_30_20.content
		local style = var_30_20.style
		local size = _ui_scenegraph[var_30_20.scenegraph_id].size

		var_30_20.offset[2] = -num

		local var_30_24 = perks[i]

		if not var_30_24 then
			local var_30_25 = Localize(var_30_24.display_name)
			local get_perk_description = UIUtils.get_perk_description(var_30_24)
			local title_text = style.title_text
			local description_text = style.description_text
			local description_text_shadow = style.description_text_shadow

			content.title_text = var_30_25
			content.description_text = get_perk_description

			local get_text_height = UIUtils.get_text_height(ui_renderer, size, title_text, var_30_25)
			local get_text_height_2 = UIUtils.get_text_height(ui_renderer, size, description_text, get_perk_description)

			description_text.offset[2] = -get_text_height_2
			description_text_shadow.offset[2] = -(get_text_height_2 + 2)
			num = num + get_text_height + get_text_height_2 + num_2
		end

		content.visible = var_30_24 ~= nil
	end

	local num_3 = 260
	local max = math.max(num - num_3, 0)

	self:_setup_additional_career_info(var_30_5, max)
end

HeroWindowTalentsConsole._setup_additional_career_info = function (self, arg_31_1, arg_31_2)
	-- function 31
	local flag = arg_31_2 or 0

	if not arg_31_1.additional_ui_info_file then
		local var_31_1 = local_require(arg_31_1.additional_ui_info_file)
		local str = "scrollbar_window"
		local str_2 = "scrollbar_anchor"
		local var_31_4 = self._ui_scenegraph[str].size[2]
		local tbl = {
			0,
			-var_31_4,
			0
		}
		local num = 0
		local var_31_7

		self._additional_widgets, self._additional_widgets_by_name, var_31_7 = var_31_1.setup(str, tbl)

		local var_31_8
		local flag_2 = true

		self._scrollbar = ScrollbarUI:new(self._ui_scenegraph, str, str_2, var_31_7, flag_2, var_31_8)
	else
		table.clear(self._additional_widgets)
		table.clear(self._additional_widgets_by_name)

		if flag > 0 then
			local str_3 = "scrollbar_window"
			local str_4 = "scrollbar_anchor"
			local flag_3 = true
			local var_31_13

			self._scrollbar = ScrollbarUI:new(self._ui_scenegraph, str_3, str_4, flag, flag_3, var_31_13)
		elseif not self._scrollbar then
			self._scrollbar:destroy(self._ui_scenegraph)

			self._scrollbar = nil
		end
	end
end

HeroWindowTalentsConsole._animate_pulse = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	-- function 32
	return (UIAnimation.init(UIAnimation.pulse_animation, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5))
end

HeroWindowTalentsConsole._set_talent_tooltip = function (self, arg_33_1, arg_33_2, arg_33_3)
	-- function 33
	local _widgets_by_name = self._widgets_by_name
	local tooltip_title = _widgets_by_name.tooltip_title
	local tooltip_description = _widgets_by_name.tooltip_description
	local tooltip_info = _widgets_by_name.tooltip_info
	local Localize = Localize
	local display_name = arg_33_1.display_name

	display_name = display_name or arg_33_1.name

	local var_33_6 = Localize(display_name)
	local get_talent_description = UIUtils.get_talent_description(arg_33_1)
	local var_33_8
	local var_33_9

	if not arg_33_3 then
		var_33_8 = Localize("talent_locked_desc")
	elseif not arg_33_2 then
		-- Nothing
	end

	tooltip_title.content.text = var_33_6
	tooltip_description.content.text = get_talent_description
	tooltip_info.content.text = var_33_8 or var_33_9 or ""
end
