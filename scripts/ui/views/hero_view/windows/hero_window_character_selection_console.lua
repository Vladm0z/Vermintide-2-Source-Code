-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_character_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_character_selection_console_definitions")
local widgets = var_0_0.widgets
local hero_widget = var_0_0.hero_widget
local empty_hero_widget = var_0_0.empty_hero_widget
local hero_icon_widget = var_0_0.hero_icon_widget
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local flag = false

HeroWindowCharacterSelectionConsole = class(HeroWindowCharacterSelectionConsole)
HeroWindowCharacterSelectionConsole.NAME = "HeroWindowCharacterSelectionConsole"

HeroWindowCharacterSelectionConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowCharacterSelectionConsole")

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer
	self._ingame_ui = ingame_ui_context.ingame_ui
	self._parent = arg_1_1.parent
	self._wwise_world = arg_1_1.wwise_world
	self._render_settings = {
		snap_pixel_positions = true
	}
	self._hero_name = arg_1_1.hero_name

	local career_index = arg_1_1.career_index

	career_index = career_index or 0
	self._career_index = career_index

	local profile_index = arg_1_1.profile_index

	profile_index = profile_index or 0
	self._profile_index = profile_index
	self._profile_selectable = false
	self._animations = {}
	self._ui_animations = {}

	local local_player = Managers.player:local_player()

	self._peer_id = local_player:network_id()
	self._local_player_id = local_player:local_player_id()

	local num = UILayer.default + 300
	local window_input_service = self._parent:window_input_service()

	self._menu_input_description = MenuInputDescriptionUI:new(ingame_ui_context, self._ui_top_renderer, window_input_service, 4, num + 100, generic_input_actions.default, true)

	self._menu_input_description:set_input_description(nil)
	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_start_transition_animation("on_enter", "on_enter")

	if not (not (self._profile_index > 0) or not (self._career_index > 0)) then
		self:_select_hero(self._profile_index, self._career_index, true)
	else
		local profile_by_peer, var_1_7 = self._profile_synchronizer:profile_by_peer(self._peer_id, self._local_player_id)

		if not profile_by_peer and not var_1_7 then
			self._profile_index = profile_by_peer
			self._career_index = var_1_7

			local get_interface = Managers.backend:get_interface("hero_attributes")

			self:_select_hero(profile_by_peer, var_1_7, true)
		end
	end
end

HeroWindowCharacterSelectionConsole._select_hero = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	if not arg_2_3 then
		self:_play_sound("play_gui_hero_select_career_click")
	end

	local var_2_0 = SPProfiles[arg_2_1]
	local var_2_1 = var_2_0.careers[arg_2_2]
	local display_name = var_2_0.display_name
	local character_name = var_2_0.character_name
	local display_name_2 = var_2_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", display_name_2 == "bw_necromancer")

	local var_2_5 = Localize(character_name)
	local var_2_6 = Localize(display_name_2)
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)

	self:_set_hero_info(var_2_5, var_2_6, get_level)

	local _hero_widgets = self._hero_widgets
	local _num_max_hero_rows = self._num_max_hero_rows

	self._selected_career_index = arg_2_2
	self._selected_profile_index = arg_2_1
	self._selected_hero_name = display_name
	self._selected_hero_row = ProfileIndexToPriorityIndex[arg_2_1]
	self._selected_hero_column = arg_2_2

	self:_set_hero_icon_selected(self._selected_hero_row)

	local num = 1
	local content = self._widgets_by_name.info_text.content
	local flag = true

	for i = 1, _num_max_hero_rows do
		local var_2_14 = self._num_hero_columns[i]

		for j = 1, var_2_14 do
			local flag_2 = i ~= self._selected_hero_row or j == self._selected_hero_column
			local content_2 = _hero_widgets[num].content

			content_2.button_hotspot.is_selected = flag_2
			num = num + 1

			if not flag_2 then
				local flag_3 = not content_2.locked
				local dlc_name = content_2.dlc_name

				self:_update_selectable(flag_3, dlc_name)

				flag = flag_3
			end
		end
	end

	if not arg_2_3 then
		if not flag then
			Managers.state.event:trigger("respawn_hero", {
				hero_name = display_name,
				career_index = arg_2_2
			})
		else
			Managers.state.event:trigger("despawn_hero")
		end
	end
end

HeroWindowCharacterSelectionConsole._update_selectable = function (self, arg_3_1, arg_3_2)
	-- function 3
	local select_button = self._widgets_by_name.select_button

	select_button.content.button_hotspot.disable_button = not arg_3_1
	select_button.content.dlc_name = not not arg_3_1 or arg_3_2
	self._widgets_by_name.info_text.content.visible = arg_3_1

	local str = "default"

	if not arg_3_1 then
		str = "hero_unavailable"

		if not arg_3_2 then
			str = "dlc_unavailable"
		end
	end

	self._menu_input_description:change_generic_actions(generic_input_actions[str])
end

HeroWindowCharacterSelectionConsole._set_hero_icon_selected = function (self, arg_4_1)
	-- function 4
	for i, v in ipairs(self._hero_icon_widgets) do
		v.content.selected = i == arg_4_1
	end
end

HeroWindowCharacterSelectionConsole._set_hero_info = function (self, arg_5_1, arg_5_2, arg_5_3)
	-- function 5
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.info_hero_name.content.text = arg_5_1
	_widgets_by_name.info_career_name.content.text = arg_5_2
	_widgets_by_name.info_hero_level.content.text = arg_5_3
end

HeroWindowCharacterSelectionConsole._start_transition_animation = function (self, arg_6_1, arg_6_2)
	-- function 6
	local tbl = {
		wwise_world = self._wwise_world,
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_6_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_6_1] = start_animation
end

HeroWindowCharacterSelectionConsole._create_ui_elements = function (self, arg_7_1, arg_7_2)
	-- function 7
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_7_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_7_2
		tbl_2[k] = var_7_2
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	self:_setup_hero_selection_widgets()
	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_7_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_7_2[1]
		local_position[2] = local_position[2] + arg_7_2[2]
		local_position[3] = local_position[3] + arg_7_2[3]
	end
end

HeroWindowCharacterSelectionConsole._setup_hero_selection_widgets = function (self)
	-- function 8
	local tbl = {}

	self._hero_widgets = tbl

	local tbl_2 = {}

	self._hero_icon_widgets = tbl_2

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local profile_by_peer, var_8_4 = self._profile_synchronizer:profile_by_peer(self._peer_id, self._local_player_id)
	local count = #SPProfilesAbbreviation

	if not PlayerData.bot_spawn_priority[1] then
		local ProfileIndexToPriorityIndex = ProfileIndexToPriorityIndex
	end

	self._num_hero_columns = {}

	for i, v in ipairs(ProfilePriority) do
		local var_8_7 = SPProfiles[v]
		local display_name = var_8_7.display_name
		local get = get_interface:get(display_name, "experience")

		get = get or 0

		local get_level = ExperienceSettings.get_level(get)
		local careers = var_8_7.careers

		self._num_hero_columns[i] = #careers

		local var_8_12 = UIWidget.init(hero_icon_widget)

		tbl_2[#tbl_2 + 1] = var_8_12
		var_8_12.offset[2] = -((i - 1) * 144)

		local str = "hero_icon_large_" .. display_name

		var_8_12.content.icon = str
		var_8_12.content.icon_selected = str .. "_glow"

		for i_2, v_2 in ipairs(careers) do
			local var_8_14 = UIWidget.init(hero_widget)

			tbl[#tbl + 1] = var_8_14

			local offset = var_8_14.offset
			local content = var_8_14.content

			content.career_settings = v_2

			local portrait_image = v_2.portrait_image

			content.portrait = "medium_" .. portrait_image

			local is_unlocked_function, var_8_19, var_8_20, var_8_21 = v_2:is_unlocked_function(display_name, get_level)

			content.locked = not is_unlocked_function
			content.locked_reason = (not not is_unlocked_function or not var_8_21) and var_8_19 and Localize(var_8_19)
			content.dlc_name = var_8_20

			if var_8_19 == "dlc_not_owned" then
				content.lock_texture = content.lock_texture .. "_gold"
				content.frame = content.frame .. "_gold"
			end

			local get_2 = get_interface:get(display_name, "career")
			local get_3 = get_interface:get(display_name, "bot_career")

			get_3 = get_3 or get_2 or 1

			if get_3 == i_2 then
				content.bot_selected = true
			end

			if not (profile_by_peer ~= v or var_8_4 ~= i_2) then
				content.is_currently_selected_character = true
			end

			offset[1] = (i_2 - 1) * 124
			offset[2] = -((i - 1) * 144)
		end

		local _widgets = self._widgets

		for i4 = #careers + 1, 4 do
			local var_8_25 = UIWidget.init(empty_hero_widget)
			local offset_2 = var_8_25.offset

			offset_2[1] = offset_2[1] + 124 * (i4 - 1)
			offset_2[2] = offset_2[2] - 144 * (i - 1)
			_widgets[#_widgets + 1] = var_8_25
		end
	end

	self._num_max_hero_rows = count
end

HeroWindowCharacterSelectionConsole.on_exit = function (self, arg_9_1)
	-- function 9
	print("[HeroViewWindow] Exit Substate HeroWindowCharacterSelectionConsole")

	self._ui_animator = nil

	local currently_selected_profile, var_9_1, var_9_2 = self._parent:currently_selected_profile()

	if not (self._selected_profile_index ~= currently_selected_profile or self._selected_career_index == var_9_1) then
		Managers.state.event:trigger("respawn_hero", {
			hero_name = var_9_2,
			career_index = var_9_1
		})

		local name = SPProfiles[currently_selected_profile].careers[var_9_1].name

		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", name == "bw_necromancer")
	end
end

HeroWindowCharacterSelectionConsole.update = function (self, arg_10_1, arg_10_2)
	-- function 10
	if not flag then
		flag = false

		self:_create_ui_elements()
	end

	self:_update_animations(arg_10_1)
	self:_update_input(arg_10_1)
	self:_draw(arg_10_1)
end

HeroWindowCharacterSelectionConsole.post_update = function (arg_11_0, arg_11_1, arg_11_2)
	-- function 11
	return
end

HeroWindowCharacterSelectionConsole._update_animations = function (self, arg_12_1)
	-- function 12
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_12_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_12_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroWindowCharacterSelectionConsole._update_input = function (self, arg_13_1)
	-- function 13
	local window_input_service = self._parent:window_input_service()

	self:_handle_gamepad_selection(window_input_service)
	self:_handle_mouse_selection()

	local profile_by_peer, var_13_2 = self._profile_synchronizer:profile_by_peer(self._peer_id, self._local_player_id)
	local select_button = self._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(select_button, arg_13_1)

	if not UIUtils.is_button_hover_enter(select_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	local is_device_active = Managers.input:is_device_active("gamepad")
	local flag = not select_button.content.button_hotspot.disable_button
	local get = window_input_service:get("confirm", true)

	if not is_device_active and not self.allow_back_button then
		local get_2 = window_input_service:get("back_menu", true)
	end

	if UIUtils.is_button_pressed(select_button) or not get or not flag then
		self:_play_sound("play_gui_start_menu_button_click")

		local verify_dlc_name = select_button.content.verify_dlc_name

		if not verify_dlc_name and not Managers.unlock:dlc_requires_restart(verify_dlc_name) then
			self._parent:close_menu()

			return
		end

		self._parent:change_profile(self._selected_profile_index, self._selected_career_index)

		local get_previous_selected_game_mode_index = self._parent:get_previous_selected_game_mode_index()

		self._parent:set_layout(get_previous_selected_game_mode_index or 1)
	elseif not get and not select_button.content.dlc_name then
		self:_play_sound("play_gui_start_menu_button_click")
		Managers.state.event:trigger("ui_show_popup", select_button.content.dlc_name, "upsell")
	end
end

HeroWindowCharacterSelectionConsole._handle_mouse_selection = function (self)
	-- function 14
	local _hero_widgets = self._hero_widgets
	local _num_max_hero_rows = self._num_max_hero_rows
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local num = 1

	for i = 1, _num_max_hero_rows do
		local var_14_5 = self._num_hero_columns[i]

		for j = 1, var_14_5 do
			local content = _hero_widgets[num].content
			local button_hotspot = content.button_hotspot

			if not ((content.locked or not button_hotspot.on_pressed) and i ~= _selected_hero_row or j == _selected_hero_column) then
				local var_14_8 = ProfilePriority[i]
				local var_14_9 = j

				self:_select_hero(var_14_8, var_14_9)

				return
			elseif not (not content.dlc_name and not button_hotspot.on_pressed and i ~= _selected_hero_row or j == _selected_hero_column) then
				Managers.state.event:trigger("ui_show_popup", content.dlc_name, "upsell")
			end

			num = num + 1
		end
	end
end

HeroWindowCharacterSelectionConsole._handle_gamepad_selection = function (self, arg_15_1)
	-- function 15
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local _num_max_hero_rows = self._num_max_hero_rows
	local var_15_3 = self._num_hero_columns[_selected_hero_row]

	if not _selected_hero_row and not _selected_hero_column then
		local flag = false

		if not (_selected_hero_column > 1) or not arg_15_1:get("move_left_hold_continuous") then
			_selected_hero_column = _selected_hero_column - 1
			flag = true
		elseif not (_selected_hero_column < var_15_3) or not arg_15_1:get("move_right_hold_continuous") then
			_selected_hero_column = _selected_hero_column + 1
			flag = true
		end

		if not (_selected_hero_row > 1) or not arg_15_1:get("move_up_hold_continuous") then
			_selected_hero_row = _selected_hero_row - 1
			var_15_3 = self._num_hero_columns[_selected_hero_row]
			flag = true
		elseif not (_selected_hero_row < _num_max_hero_rows) or not arg_15_1:get("move_down_hold_continuous") then
			_selected_hero_row = _selected_hero_row + 1
			var_15_3 = self._num_hero_columns[_selected_hero_row]
			flag = true
		end

		if var_15_3 < _selected_hero_column then
			_selected_hero_column = var_15_3
			flag = true
		end

		if not flag then
			local var_15_5 = ProfilePriority[_selected_hero_row]
			local var_15_6 = _selected_hero_column

			self:_select_hero(var_15_5, var_15_6)
		end
	end
end

HeroWindowCharacterSelectionConsole.set_focus = function (self, arg_16_1)
	-- function 16
	self._focused = arg_16_1
end

HeroWindowCharacterSelectionConsole._exit = function (self, arg_17_1)
	-- function 17
	self.exit = true
	self.exit_level_id = arg_17_1
end

HeroWindowCharacterSelectionConsole._draw = function (self, arg_18_1)
	-- function 18
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local window_input_service = self._parent:window_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, window_input_service, arg_18_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._hero_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	for i_3, v_3 in ipairs(self._hero_icon_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_3)
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active then
		self._menu_input_description:draw(_ui_top_renderer, arg_18_1)
	end
end

HeroWindowCharacterSelectionConsole._play_sound = function (self, arg_19_1)
	-- function 19
	self._parent:play_sound(arg_19_1)
end
