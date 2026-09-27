-- chunkname: @scripts/ui/views/character_selection_view/states/character_selection_state_character.lua

require("scripts/settings/profiles/sp_profiles")
require("scripts/ui/hud_ui/scrollbar_ui")

local var_0_0 = local_require("scripts/ui/views/character_selection_view/states/definitions/character_selection_state_character_definitions")
local character_selection_widgets = var_0_0.character_selection_widgets
local widgets = var_0_0.widgets
local info_widgets = var_0_0.info_widgets
local bot_selection_widgets = var_0_0.bot_selection_widgets
local hero_widget = var_0_0.hero_widget
local empty_hero_widget = var_0_0.empty_hero_widget
local hero_icon_widget = var_0_0.hero_icon_widget
local generic_input_actions = var_0_0.generic_input_actions
local animation_definitions = var_0_0.animation_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local NUM_PERKS = var_0_0.NUM_PERKS
local flag = false
local num = 240
local str = "CharacterSelectionStateCharacter"

CharacterSelectionStateCharacter = class(CharacterSelectionStateCharacter)
CharacterSelectionStateCharacter.NAME = "CharacterSelectionStateCharacter"

CharacterSelectionStateCharacter.on_enter = function (self, arg_1_1)
	-- function 1
	self.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate CharacterSelectionStateCharacter")

	local state_params = arg_1_1.state_params

	self._hero_name = arg_1_1.hero_name

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.is_server = ingame_ui_context.is_server
	self._close_on_successful_profile_request = true
	self.world_previewer = arg_1_1.world_previewer
	self.wwise_world = arg_1_1.wwise_world
	self.platform = PLATFORM
	self.allow_back_button = arg_1_1.allow_back_button

	if not arg_1_1.pick_time then
		self.pick_time = arg_1_1.pick_time
	end

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.local_player = local_player
	self._animations = {}
	self._ui_animations = {}
	self._available_profiles = {}

	local network_server = ingame_ui_context.network_server

	network_server = network_server or ingame_ui_context.network_client
	self._profile_requester = network_server:profile_requester()

	local parent = self.parent
	local input_service = self:input_service()
	local num = UILayer.default + 130
	local input_service_2 = parent:input_service(true)
	local MenuInputDescriptionUI = MenuInputDescriptionUI
	local var_1_10 = MenuInputDescriptionUI
	local new = MenuInputDescriptionUI.new
	local var_1_12 = ingame_ui_context
	local ui_top_renderer = self.ui_top_renderer
	local var_1_14 = input_service_2
	local num_2 = 6
	local var_1_16 = num
	local default_back

	if not arg_1_1.allow_back_button then
		default_back = generic_input_actions.default_back

		if not default_back then
			-- Nothing
		end
	end

	default_back = generic_input_actions.default

	::label_1_0::

	self.menu_input_description = new(var_1_10, var_1_12, ui_top_renderer, var_1_14, num_2, var_1_16, default_back, true)

	self.menu_input_description:set_input_description(nil)
	self:create_ui_elements(arg_1_1)
	self:_start_transition_animation("on_enter", "on_enter")

	self._hero_preview_skin = nil
	self.use_user_skins = true
	self.use_loadout_items = false

	local _hero_name = self._hero_name
	local profile_id = arg_1_1.profile_id

	if not (not profile_id and not (profile_id > 0)) then
		self._career_index = arg_1_1.career_id
		self._close_on_successful_profile_request = false

		self:_select_hero(profile_id, self._career_index, true)
		self:_change_profile(profile_id, self._career_index)
	else
		local profile_by_peer, var_1_21 = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

		if not profile_by_peer and not _hero_name then
			local get_interface = Managers.backend:get_interface("hero_attributes")

			self._career_index = var_1_21

			self:_select_hero(profile_by_peer, self._career_index, true)
		end
	end

	self.parent:set_input_blocked(false)
end

CharacterSelectionStateCharacter._update_video_player_settings = function (self)
	-- function 2
	local character_visible = self.world_previewer:character_visible()

	if not (not character_visible and self._video_widget) then
		local material_name = self._current_video_settings.material_name
		local resource = self._current_video_settings.resource

		if not material_name and not resource then
			self:_setup_video_player(material_name, resource)

			self._draw_video_next_frame = true
		end
	elseif not character_visible then
		self:_destroy_video_player()
	end
end

CharacterSelectionStateCharacter._setup_video_player = function (self, arg_3_1, arg_3_2)
	-- function 3
	self:_destroy_video_player()

	local ui_top_renderer = self.ui_top_renderer
	local flag = true
	local get_background_world, var_3_3 = self.parent:get_background_world()

	UIRenderer.create_video_player(ui_top_renderer, str, get_background_world, arg_3_2, flag)

	local str_2 = "info_window_video"
	local create_video = UIWidgets.create_video(str_2, arg_3_1, str)

	self._video_widget = UIWidget.init(create_video)
	self._video_created = true
end

CharacterSelectionStateCharacter._destroy_video_player = function (self)
	-- function 4
	local ui_top_renderer = self.ui_top_renderer
	local _video_widget = self._video_widget

	if not _video_widget then
		UIWidget.destroy(ui_top_renderer, _video_widget)

		self._video_widget = nil
	end

	if not ui_top_renderer and not ui_top_renderer.video_players[str] then
		local get_background_world, var_4_3 = self.parent:get_background_world()

		UIRenderer.destroy_video_player(ui_top_renderer, str, get_background_world)
	end

	self._video_created = nil
end

CharacterSelectionStateCharacter._inject_additional_scenegraph_definitions = function (arg_5_0, arg_5_1)
	-- function 5
	for k, v in pairs(CareerSettings) do
		if not v.additional_ui_info_file then
			local var_5_0 = local_require(v.additional_ui_info_file)

			for k_2, v_2 in pairs(var_5_0.scenegraph_definition_to_inject) do
				arg_5_1[k_2] = v_2
			end
		end
	end
end

CharacterSelectionStateCharacter.create_ui_elements = function (self, arg_6_1)
	-- function 6
	self:_inject_additional_scenegraph_definitions(scenegraph_definition)

	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}
	local tbl_3 = {}
	local tbl_4 = {}

	for k, v in pairs(widgets) do
		local var_6_4 = UIWidget.init(v)

		tbl[#tbl + 1] = var_6_4
		tbl_4[k] = var_6_4
	end

	for k_2, v_2 in pairs(info_widgets) do
		local var_6_5 = UIWidget.init(v_2)

		tbl_2[#tbl_2 + 1] = var_6_5
		tbl_4[k_2] = var_6_5
	end

	for k_3, v_3 in pairs(bot_selection_widgets) do
		local var_6_6 = UIWidget.init(v_3)

		tbl_3[#tbl_3 + 1] = var_6_6
		tbl_4[k_3] = var_6_6
	end

	self._widgets = tbl
	self._info_widgets = tbl_2
	self._bot_selection_widgets = tbl_3
	self._widgets_by_name = tbl_4
	self._additional_widgets = {}
	self._additional_widgets_by_name = {}

	self:_setup_hero_selection_widgets()
	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)
end

CharacterSelectionStateCharacter._set_hero_icon_selected = function (self, arg_7_1)
	-- function 7
	for i, v in ipairs(self._hero_icon_widgets) do
		v.content.selected = i == arg_7_1
	end
end

CharacterSelectionStateCharacter._setup_hero_selection_widgets = function (self)
	-- function 8
	local tbl = {}

	self._hero_widgets = tbl

	local tbl_2 = {}

	self._hero_icon_widgets = tbl_2

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local get_interface_2 = Managers.backend:get_interface("dlcs")
	local count = #SPProfilesAbbreviation
	local ProfilePriority = ProfilePriority
	local bot_spawn_priority = PlayerData.bot_spawn_priority

	if not bot_spawn_priority[1] then
		bot_spawn_priority = ProfileIndexToPriorityIndex
	end

	self._num_hero_columns = {}

	for i, v in ipairs(bot_spawn_priority) do
		local var_8_7 = SPProfiles[v]
		local display_name = var_8_7.display_name
		local get = get_interface:get(display_name, "experience")

		get = get or 0

		local get_level = ExperienceSettings.get_level(get)
		local careers = var_8_7.careers
		local var_8_12 = UIWidget.init(hero_icon_widget)

		tbl_2[#tbl_2 + 1] = var_8_12
		var_8_12.offset[2] = -((i - 1) * 144)
		var_8_12.content.bot_order_texture_id = "bot_order_" .. tostring(i)

		local str = "hero_icon_large_" .. display_name

		var_8_12.content.icon = str
		var_8_12.content.icon_selected = str .. "_glow"

		local num = 0

		for k = 1, 4 do
			local var_8_15 = careers[k]

			if not (not var_8_15 and get_interface_2:is_unreleased_career(var_8_15.name)) then
				num = num + 1

				local var_8_16 = UIWidget.init(hero_widget)

				tbl[#tbl + 1] = var_8_16

				local offset = var_8_16.offset
				local content = var_8_16.content

				content.career_settings = var_8_15

				local portrait_image = var_8_15.portrait_image

				content.portrait = "medium_" .. portrait_image

				local is_unlocked_function, var_8_21, var_8_22, var_8_23 = var_8_15:is_unlocked_function(display_name, get_level)

				content.locked = not is_unlocked_function
				content.locked_reason = (not not is_unlocked_function or not var_8_23) and var_8_21 and Localize(var_8_21)
				content.dlc_name = var_8_22

				if var_8_21 == "dlc_not_owned" then
					content.lock_texture = content.lock_texture .. "_gold"
					content.frame = content.frame .. "_gold"
				end

				local get_2 = get_interface:get(display_name, "career")
				local get_3 = get_interface:get(display_name, "bot_career")

				get_3 = get_3 or get_2 or 1

				local find = table.find(bot_spawn_priority, v)

				if not (get_3 ~= k or not (find <= 5)) then
					content.bot_priority = find
					content.bot_selected = true
				end

				offset[1] = (k - 1) * 124
				offset[2] = -((i - 1) * 144)
			else
				local num_2 = (k - 1) * 124

				var_8_12.style.bg.offset[1] = var_8_12.style.bg.offset[1] + num_2
				var_8_12.style.hourglass_icon.offset[1] = var_8_12.style.hourglass_icon.offset[1] + num_2
				var_8_12.content.use_empty_icon = true
			end
		end

		self._num_hero_columns[i] = num
	end

	self._num_max_hero_rows = count
end

CharacterSelectionStateCharacter._update_available_profiles = function (self)
	-- function 9
	local _available_profiles = self._available_profiles
	local _hero_widgets = self._hero_widgets
	local local_player = Managers.player:local_player()
	local profile_synchronizer = self.profile_synchronizer
	local flag = local_player == nil or local_player:profile_index()
	local flag_2

	flag_2 = local_player == nil or local_player:career_index()

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local ProfilePriority = ProfilePriority
	local bot_spawn_priority = PlayerData.bot_spawn_priority

	if not bot_spawn_priority[1] then
		bot_spawn_priority = ProfileIndexToPriorityIndex
	end

	local num = 1
	local _selected_career_index = self._selected_career_index
	local _selected_profile_index = self._selected_profile_index
	local mechanism = Managers.mechanism

	for i, v in ipairs(bot_spawn_priority) do
		local var_9_13 = SPProfiles[v]
		local flag_3 = false

		if not local_player then
			local network_id = local_player:network_id()
			local get_party_from_unique_id, var_9_17 = Managers.party:get_party_from_unique_id(local_player:unique_id())

			flag_3 = mechanism:profile_available_for_peer(var_9_17, network_id, v)
		end

		local flag_4 = flag == v or flag_3
		local careers = var_9_13.careers

		for i_2, v_2 in ipairs(careers) do
			local var_9_20 = _hero_widgets[num]

			if not var_9_20 then
				local content = var_9_20.content
				local locked = content.locked

				content.taken = not flag_4

				if not (i_2 ~= _selected_career_index or _selected_profile_index ~= v) then
					self:_set_select_button_enabled(not flag_4 and not locked, not locked and content.dlc_name, content.dlc_name)
				end
			end

			num = num + 1
		end
	end
end

CharacterSelectionStateCharacter._handle_mouse_selection = function (self)
	-- function 10
	local _hero_widgets = self._hero_widgets
	local _num_max_hero_rows = self._num_max_hero_rows
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local ProfilePriority = ProfilePriority
	local get_interface = Managers.backend:get_interface("hero_attributes")
	local bot_spawn_priority = PlayerData.bot_spawn_priority
	local num = 1

	for i = 1, _num_max_hero_rows do
		local var_10_8 = self._num_hero_columns[i]

		for j = 1, var_10_8 do
			if not (not _hero_widgets[num].content.button_hotspot.on_pressed and i ~= _selected_hero_row or j == _selected_hero_column) then
				local var_10_9 = bot_spawn_priority[i]
				local var_10_10 = j

				self:_select_hero(var_10_9, var_10_10)

				return
			end

			num = num + 1
		end
	end
end

CharacterSelectionStateCharacter._update_equipped_bots = function (self)
	-- function 11
	local bot_spawn_priority = PlayerData.bot_spawn_priority

	if not bot_spawn_priority[1] then
		bot_spawn_priority = ProfileIndexToPriorityIndex
	end

	local get_interface = Managers.backend:get_interface("hero_attributes")
	local _hero_widgets = self._hero_widgets
	local num = 1

	for i, v in ipairs(bot_spawn_priority) do
		local var_11_4 = SPProfiles[v]
		local display_name = var_11_4.display_name
		local careers = var_11_4.careers

		for i_2, v_2 in ipairs(careers) do
			local content = self._hero_widgets[num].content
			local get = get_interface:get(display_name, "career")
			local get_2 = get_interface:get(display_name, "bot_career")

			get_2 = get_2 or i_2 or 1

			local find = table.find(bot_spawn_priority, v)

			if not (get_2 ~= i_2 or not (find <= 5)) then
				content.bot_priority = nil
				content.bot_selected = true
			else
				content.bot_priority = nil
				content.bot_selected = nil
			end

			num = num + 1
		end
	end
end

CharacterSelectionStateCharacter._exit_bot_selection = function (self)
	-- function 12
	self.parent:set_input_blocked(false)
	self:_setup_hero_selection_widgets()
	self:_select_hero(self._selected_profile_index, self._selected_career_index, true)

	for k, v in pairs(self._hero_icon_widgets) do
		v.content.bot_selection_active = false
	end

	self._spawn_hero = true
	self._bot_selection = nil
	self._bot_priority_copy = nil
	self._current_selected_bot_index = nil
	self._current_selected_row = nil
	self._x_offset = nil
	self._base_y_offset = nil

	local style = self._widgets_by_name.background.style

	self._ui_animations.background = UIAnimation.init(UIAnimation.function_by_time, style.rect.color, 1, style.rect.color[1], 0, 0.4, math.easeOutCubic)

	local menu_input_description = self.menu_input_description
	local var_12_2 = menu_input_description
	local change_generic_actions = menu_input_description.change_generic_actions
	local default_back

	if not self.allow_back_button then
		default_back = generic_input_actions.default_back

		if not default_back then
			-- Nothing
		end
	end

	default_back = generic_input_actions.default

	::label_12_0::

	change_generic_actions(var_12_2, default_back)

	self.render_settings.info_alpha_multiplier = 0
	self.render_settings.bot_selection_alpha_multiplier = 0

	if not self.parent.show_hero_panel then
		self.parent:show_hero_panel()
		self.parent:set_input_blocked(false)
	end

	self:_start_transition_animation("fade_out", "on_exit_bot_selection")
	self:_play_sound("Play_hud_button_close")
end

CharacterSelectionStateCharacter._enter_bot_selection = function (self, arg_13_1)
	-- function 13
	self._bot_selection = true
	self._bot_priority_copy = table.clone(PlayerData.bot_spawn_priority)

	local _hero_widgets = self._hero_widgets
	local num = 1

	for i = 1, #PlayerData.bot_spawn_priority do
		local var_13_2 = PlayerData.bot_spawn_priority[i]
		local count = #SPProfiles[var_13_2].careers

		for j = 1, count do
			_hero_widgets[num].content.bot_selection_active = true
			num = num + 1
		end
	end

	for k, v in pairs(self._hero_icon_widgets) do
		v.content.bot_selection_active = true
	end

	local style = self._widgets_by_name.background.style

	self._ui_animations.background = UIAnimation.init(UIAnimation.function_by_time, style.rect.color, 1, style.rect.color[1], 128, 0.4, math.easeOutCubic)

	self.menu_input_description:change_generic_actions(generic_input_actions.prioritize_bots)

	self.render_settings.main_alpha_multiplier = 1
	self.render_settings.info_alpha_multiplier = 0
	self.render_settings.bot_selection_alpha_multiplier = 0

	if not self.parent.hide_hero_panel then
		self.parent:hide_hero_panel()
		self.parent:set_input_blocked(false)
	end

	self:_start_transition_animation("fade_in", "on_enter_bot_selection")
	self:_play_sound("Play_hud_button_open")
end

CharacterSelectionStateCharacter._handle_gamepad_selection = function (self, arg_14_1)
	-- function 14
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local _num_max_hero_rows = self._num_max_hero_rows
	local var_14_3 = ProfilePriority[_selected_hero_row]
	local var_14_4 = PlayerData.bot_spawn_priority[_selected_hero_row]
	local count = #SPProfiles[var_14_4].careers
	local flag = true

	if not (not arg_14_1:get("refresh") and self._bot_selection) then
		self:_enter_bot_selection(self._selected_hero_row)
	else
		local flag_2 = not self._current_selected_row

		if not _selected_hero_row and not _selected_hero_column and not flag_2 then
			local flag_3 = false

			if not (_selected_hero_column > 1) or not arg_14_1:get("move_left_hold_continuous") then
				_selected_hero_column = _selected_hero_column - 1
				flag_3 = true
			elseif not (_selected_hero_column < count) or not arg_14_1:get("move_right_hold_continuous") then
				_selected_hero_column = _selected_hero_column + 1
				flag_3 = true
			end

			if not (_selected_hero_row > 1) or not arg_14_1:get("move_up_hold_continuous") then
				_selected_hero_row = _selected_hero_row - 1
				count = self._num_hero_columns[_selected_hero_row]
				flag_3 = true
			elseif not (_selected_hero_row < _num_max_hero_rows) or not arg_14_1:get("move_down_hold_continuous") then
				_selected_hero_row = _selected_hero_row + 1
				count = self._num_hero_columns[_selected_hero_row]
				flag_3 = true
			end

			if count < _selected_hero_column then
				_selected_hero_column = count
				flag_3 = true
			end

			if not flag_3 then
				local var_14_9 = ProfilePriority[_selected_hero_row]
				local flag_4 = false
				local var_14_11 = PlayerData.bot_spawn_priority[_selected_hero_row]
				local _bot_selection = self._bot_selection
				local var_14_13 = _selected_hero_column

				self:_select_hero(var_14_11, var_14_13, nil, _bot_selection)
			end
		end
	end
end

CharacterSelectionStateCharacter._is_selected_hero_unlocked = function (self)
	-- function 15
	local _selected_hero_row = self._selected_hero_row
	local _selected_hero_column = self._selected_hero_column
	local _num_max_hero_rows = self._num_max_hero_rows
	local num = 1

	for i = 1, _num_max_hero_rows do
		local var_15_4 = self._num_hero_columns[i]

		for j = 1, var_15_4 do
			if not (_selected_hero_row ~= i or _selected_hero_column ~= j) then
				local content = self._hero_widgets[num].content

				return not content.locked_reason and not content.locked
			end

			num = num + 1
		end
	end

	return false
end

CharacterSelectionStateCharacter._handle_gamepad_bot_selection = function (self, arg_16_1)
	-- function 16
	self:_handle_gamepad_selection(arg_16_1)

	if not arg_16_1:get("confirm_press", true) and not self:_is_selected_hero_unlocked() then
		local _selected_hero_row = self._selected_hero_row
		local _selected_hero_column = self._selected_hero_column
		local var_16_2 = PlayerData.bot_spawn_priority[_selected_hero_row]
		local display_name = SPProfiles[var_16_2].display_name
		local var_16_4 = _selected_hero_column

		Managers.backend:get_interface("hero_attributes"):set(display_name, "bot_career", var_16_4)
		self:_play_sound("play_gui_equipment_equip")
		self:_update_equipped_bots()
	elseif not arg_16_1:get("refresh") then
		if not self._current_selected_row then
			self:_reset_bot_selection(true)
			self:_play_sound("hud_bot_order_release")
		else
			self:_set_bot_selection(self._selected_hero_row)
		end
	else
		local _current_selected_row = self._current_selected_row
		local _num_max_hero_rows = self._num_max_hero_rows
		local flag = false

		if not _current_selected_row then
			return
		end

		if not (_current_selected_row > 1) or not arg_16_1:get("move_up_hold_continuous") then
			_current_selected_row = _current_selected_row - 1
			flag = true
		elseif not (_current_selected_row < _num_max_hero_rows) or not arg_16_1:get("move_down_hold_continuous") then
			_current_selected_row = _current_selected_row + 1
			flag = true
		end

		if not flag then
			self:_play_sound("play_gui_equipment_inventory_hover")
			self:_update_bot_order(_current_selected_row)
		end
	end
end

CharacterSelectionStateCharacter._update_bot_order = function (self, arg_17_1, arg_17_2)
	-- function 17
	local _current_selected_row = self._current_selected_row

	table.remove(self._bot_priority_copy, _current_selected_row)
	table.insert(self._bot_priority_copy, arg_17_1, self._current_selected_bot_index)

	self._current_selected_row = arg_17_1

	local _hero_widgets = self._hero_widgets
	local _hero_icon_widgets = self._hero_icon_widgets
	local num = 1

	for i = 1, #PlayerData.bot_spawn_priority do
		local var_17_4 = PlayerData.bot_spawn_priority[i]
		local count = #SPProfiles[var_17_4].careers
		local find = table.find(self._bot_priority_copy, var_17_4)
		local num_2 = -((find - 1) * 144)
		local flag

		flag = i == _current_selected_row

		for j = 1, count do
			local var_17_9 = _hero_widgets[num]
			local content = var_17_9.content

			self._ui_animations[var_17_4 .. ":" .. j] = UIAnimation.init(UIAnimation.function_by_time, var_17_9.offset, 2, var_17_9.offset[2], num_2, 0.25, math.easeOutCubic)

			if not content.bot_order_selection and not arg_17_2 then
				self._ui_animations[var_17_4 .. ":" .. j .. "_x"] = UIAnimation.init(UIAnimation.function_by_time, var_17_9.offset, 1, var_17_9.offset[1], var_17_9.offset[1] - self._x_offset, 0.25, math.easeOutCubic)
			end

			num = num + 1
		end

		local num_3 = (i - find) * 144 + 7
		local var_17_12 = _hero_icon_widgets[i]
		local style = var_17_12.style

		self._ui_animations["hero_icon_" .. var_17_4 .. "_bg"] = UIAnimation.init(UIAnimation.function_by_time, style.bg.offset, 2, style.bg.offset[2], style.bg.offset[2] * 0 + num_3, 0.25, math.easeOutCubic)
		self._ui_animations["hero_icon_" .. var_17_4 .. "_hourglass_icon"] = UIAnimation.init(UIAnimation.function_by_time, style.hourglass_icon.offset, 2, style.hourglass_icon.offset[2], style.hourglass_icon.offset[2] * 0 + num_3, 0.25, math.easeOutCubic)

		if not var_17_12.content.bot_order_selection and not arg_17_2 then
			self._ui_animations["hero_icon_" .. var_17_4 .. "_bg_x"] = UIAnimation.init(UIAnimation.function_by_time, style.bg.offset, 1, style.bg.offset[1], style.bg.offset[1] - self._x_offset, 0.25, math.easeOutCubic)
			self._ui_animations["hero_icon_" .. var_17_4 .. "_hourglass_icon_x"] = UIAnimation.init(UIAnimation.function_by_time, style.hourglass_icon.offset, 1, style.hourglass_icon.offset[1], style.hourglass_icon.offset[1] - self._x_offset, 0.25, math.easeOutCubic)
		end
	end
end

CharacterSelectionStateCharacter._set_bot_selection = function (self, arg_18_1)
	-- function 18
	self._current_selected_bot_index = PlayerData.bot_spawn_priority[arg_18_1]
	self._current_selected_row = arg_18_1
	self._x_offset = 50
	self._base_y_offset = nil
	self._base_icon_y_offset = nil

	local get = self:input_service():get("cursor")

	if not IS_XB1 then
		self._base_cursor_y_offset = not get and 1080 - get[2]
	else
		self._base_cursor_y_offset = not get and get[2] * RESOLUTION_LOOKUP.inv_scale
	end

	local num = 1

	for i = 1, #PlayerData.bot_spawn_priority do
		local var_18_2 = PlayerData.bot_spawn_priority[i]
		local count = #SPProfiles[var_18_2].careers

		for j = 1, count do
			if i == self._current_selected_row then
				self._hero_widgets[num].offset[1] = self._hero_widgets[num].offset[1] + self._x_offset
				self._hero_widgets[num].offset[3] = 100
				self._hero_widgets[num].content.bot_order_selection = true
				self._base_y_offset = self._hero_widgets[num].offset[2]
			end

			num = num + 1
		end
	end

	for i_2, v in ipairs(self._hero_icon_widgets) do
		v.content.bot_change_order_active = true

		if i_2 == self._current_selected_row then
			v.style.bg.offset[1] = v.style.bg.offset[1] + self._x_offset
			v.style.hourglass_icon.offset[1] = v.style.hourglass_icon.offset[1] + self._x_offset
			v.content.bot_order_selection = true
			self._base_icon_y_offset = v.style.hourglass_icon.offset[2]
		end
	end

	self:_play_sound("hud_bot_order_grab")
end

CharacterSelectionStateCharacter._reset_bot_selection = function (self, arg_19_1)
	-- function 19
	self._current_selected_bot_index = nil
	self._current_selected_row = nil
	self._x_offset = nil
	self._base_y_offset = nil
	self._base_icon_y_offset = nil
	self._base_cursor_y_offset = nil
	PlayerData.bot_spawn_priority = self._bot_priority_copy
	self._bot_priority_copy = table.clone(PlayerData.bot_spawn_priority)

	self.parent:set_input_blocked(false)
	self:_setup_hero_selection_widgets()

	if not arg_19_1 then
		local flag = true
		local flag_2 = true

		self:_select_hero(self._selected_profile_index, self._selected_career_index, flag_2, flag)
	end

	local _hero_widgets = self._hero_widgets
	local num = 1

	for i = 1, #PlayerData.bot_spawn_priority do
		local var_19_4 = PlayerData.bot_spawn_priority[i]
		local count = #SPProfiles[var_19_4].careers

		for j = 1, count do
			local var_19_6 = _hero_widgets[num]

			var_19_6.content.bot_selection = true
			var_19_6.content.bot_order_selection = false
			num = num + 1
		end
	end

	for k, v in pairs(self._hero_icon_widgets) do
		v.content.bot_selection_active = true
		v.content.bot_order_selection = false
	end
end

CharacterSelectionStateCharacter._handle_mouse_bot_selection = function (self, arg_20_1)
	-- function 20
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	if not self.parent:input_blocked() then
		if not self._current_selected_row then
			if not self._base_cursor_y_offset then
				local flag = true

				self:_update_bot_order(self._current_selected_row, flag)
				self.parent:set_input_blocked(true)

				return
			end

			local get = arg_20_1:get("cursor")
			local var_20_2

			if not IS_XB1 then
				var_20_2 = 1080 - get[2]
			else
				var_20_2 = get[2] * RESOLUTION_LOOKUP.inv_scale
			end

			local num = var_20_2 - self._base_cursor_y_offset
			local num_2 = -((#PlayerData.bot_spawn_priority - 1) * 144)
			local clamp = math.clamp(self._base_y_offset + num, num_2, 0)
			local num_3 = self._base_y_offset + num - clamp
			local _hero_widgets = self._hero_widgets
			local num_4 = 1

			for i = 1, #self._bot_priority_copy do
				local var_20_9 = self._bot_priority_copy[i]
				local count = #SPProfiles[var_20_9].careers

				for j = 1, count do
					if not _hero_widgets[num_4].content.bot_order_selection then
						_hero_widgets[num_4].offset[2] = clamp
					end

					num_4 = num_4 + 1
				end
			end

			for i_2, v in ipairs(self._hero_icon_widgets) do
				if not v.content.bot_order_selection then
					local style = v.style

					style.bg.offset[2] = self._base_icon_y_offset + (num - num_3)
					style.hourglass_icon.offset[2] = self._base_icon_y_offset + (num - num_3)
				end
			end
		end

		local flag_2 = true

		for i_3, v_2 in ipairs(self._hero_icon_widgets) do
			if not UIUtils.is_button_hover_enter(v_2, "bot_change_order_hotspot") then
				if not self._current_selected_row then
					self:_update_bot_order(i_3, false)
				end
			elseif not UIUtils.is_button_held(v_2, "bot_change_order_hotspot") then
				if not self._current_selected_row then
					self:_set_bot_selection(i_3)
				end
			elseif not UIUtils.is_left_button_released(v_2, "bot_change_order_hotspot") and not self._current_selected_row then
				self:_update_bot_order(i_3, flag_2)
				self.parent:set_input_blocked(true)
				self:_play_sound("hud_bot_order_release")

				break
			end
		end

		local get_interface = Managers.backend:get_interface("hero_attributes")
		local bot_spawn_priority = PlayerData.bot_spawn_priority
		local _hero_widgets_2 = self._hero_widgets
		local num_5 = 1

		for i6 = 1, self._num_max_hero_rows do
			local var_20_17 = self._num_hero_columns[i6]

			for i7 = 1, var_20_17 do
				local content = _hero_widgets_2[num_5].content
				local button_hotspot = content.button_hotspot

				if content.locked or not button_hotspot.on_right_click then
					local var_20_20 = bot_spawn_priority[i6]
					local var_20_21 = i7
					local display_name = SPProfiles[var_20_20].display_name

					get_interface:set(display_name, "bot_career", var_20_21)
					self:_play_sound("play_gui_equipment_equip")
					self:_update_equipped_bots()

					return
				end

				num_5 = num_5 + 1
			end
		end
	elseif table.size(self._ui_animations) == 0 then
		self:_reset_bot_selection()
	end
end

CharacterSelectionStateCharacter._select_hero = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	if not arg_21_3 then
		self:_play_sound("play_gui_hero_select_career_click")
	end

	local var_21_0 = SPProfiles[arg_21_1]
	local var_21_1 = var_21_0.careers[arg_21_2]
	local display_name = var_21_0.display_name
	local character_name = var_21_0.character_name
	local display_name_2 = var_21_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", display_name_2 == "bw_necromancer")

	local var_21_5 = Localize(character_name)
	local var_21_6 = Localize(display_name_2)
	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")

	get = get or 0

	local get_level = ExperienceSettings.get_level(get)

	self:_set_hero_info(var_21_5, var_21_6, get_level)
	self:_populate_career_info(arg_21_1, arg_21_2)

	local _hero_widgets = self._hero_widgets
	local _num_max_hero_rows = self._num_max_hero_rows

	self._spawn_hero = true

	if not arg_21_4 then
		self._spawn_hero = false
	end

	self._selected_career_index = arg_21_2
	self._selected_profile_index = arg_21_1
	self._selected_hero_name = display_name
	self._selected_hero_row = table.find(PlayerData.bot_spawn_priority, arg_21_1)
	self._selected_hero_column = arg_21_2

	self:_set_hero_icon_selected(self._selected_hero_row)

	local num = 1

	for i = 1, _num_max_hero_rows do
		local var_21_12 = self._num_hero_columns[i]

		for j = 1, var_21_12 do
			local flag = i ~= self._selected_hero_row or j == self._selected_hero_column
			local content = _hero_widgets[num].content

			content.button_hotspot.is_selected = flag

			if not flag then
				local content_2 = self._widgets_by_name.locked_info_text.content
				local var_21_16

				if content.locked_reason or not content.locked then
					var_21_16 = content.locked_reason
				end

				local locked_reason = content.locked_reason

				locked_reason = locked_reason or content.locked
				content_2.locked = locked_reason
				content_2.text = var_21_16
				content_2.visible = var_21_16 ~= nil
			end

			num = num + 1
		end
	end
end

CharacterSelectionStateCharacter._get_skin_item_data = function (arg_22_0, arg_22_1, arg_22_2)
	-- function 22
	local base_skin = SPProfiles[arg_22_1].careers[arg_22_2].base_skin

	return Cosmetics[base_skin]
end

CharacterSelectionStateCharacter._wanted_state = function (self)
	-- function 23
	return (self.parent:wanted_state())
end

CharacterSelectionStateCharacter.on_exit = function (self, arg_24_1)
	-- function 24
	if not self.menu_input_description then
		self.menu_input_description:destroy()

		self.menu_input_description = nil
	end

	self:_destroy_video_player()
	self:_respawn_player()

	self.ui_animator = nil

	self.parent:set_input_blocked(false)

	local local_player = Managers.player:local_player()

	if not local_player then
		local player_unit = local_player.player_unit
		local var_24_2 = ALIVE[player_unit]

		var_24_2 = not var_24_2 and ScriptUnit.has_extension(player_unit, "career_system")

		local flag = not var_24_2 and var_24_2:profile_index() and self._requested_profile_index
		local flag_2 = not var_24_2 and var_24_2:career_index() and self._requested_career_index
		local flag_3 = not flag and SPProfiles[flag]
		local flag_4 = not flag_3 and flag_3.display_name

		if not (DEDICATED_SERVER or flag_4 ~= "bright_wizard") then
			local display_name = flag_3.careers[flag_2].display_name

			GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", display_name == "bw_necromancer")
		end
	end

	print("[HeroViewState] Exit Substate CharacterSelectionStateCharacter")
end

CharacterSelectionStateCharacter._respawn_player = function (self)
	-- function 25
	if not self._respawn_player_unit then
		if not self.is_server then
			Managers.state.network.network_server:peer_respawn_player(self.peer_id)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_client_respawn_player")
		end

		self._respawn_player_unit = nil
	end
end

CharacterSelectionStateCharacter._update_transition_timer = function (self, arg_26_1)
	-- function 26
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_26_1, 0)
	end
end

CharacterSelectionStateCharacter.update = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_27_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	self:_update_available_profiles()
	self:_update_profile_request()
	self:_update_video_player_settings()

	if not self._prepare_exit then
		self:_handle_input(arg_27_1, arg_27_2)
	end

	self:draw(arg_27_1, arg_27_2)

	return self:_handle_transitions()
end

CharacterSelectionStateCharacter._handle_transitions = function (self)
	-- function 28
	local _wanted_state = self:_wanted_state()

	if self._transition_timer or self:pending_profile_request() or _wanted_state or not self._new_state then
		if not self.world_previewer:has_units_spawned() then
			self._prepare_exit = true
		elseif not self._prepare_exit then
			return _wanted_state or self._new_state
		end
	end
end

CharacterSelectionStateCharacter.post_update = function (self, arg_29_1, arg_29_2)
	-- function 29
	self.ui_animator:update(arg_29_1)
	self:_update_animations(arg_29_1)

	if not (self.parent:transitioning() or self._transition_timer) then
		if not self._prepare_exit then
			self._prepare_exit = false

			self.world_previewer:prepare_exit()
		elseif not self._spawn_hero then
			self._spawn_hero = nil

			local _selected_hero_name = self._selected_hero_name

			_selected_hero_name = _selected_hero_name or self._hero_name

			self:_spawn_hero_unit(_selected_hero_name)
		end
	end

	local profile_synchronizer = Managers.state.network.profile_synchronizer
	local network_id = self.local_player:network_id()
	local local_player_id = self.local_player:local_player_id()

	if not self._despawning_player_unit_career_change and Unit.alive(self._despawning_player_unit_career_change) or not profile_synchronizer:all_ingame_synced_for_peer(network_id, local_player_id) then
		local unbox = self._respawn_position:unbox()
		local unbox_2 = self._respawn_rotation:unbox()

		self.local_player:spawn(unbox, unbox_2)

		self._despawning_player_unit_career_change = nil
		self._resyncing_loadout = nil

		self.parent:close_menu()
	end
end

CharacterSelectionStateCharacter.draw = function (self, arg_30_1, arg_30_2)
	-- function 30
	local ui_top_renderer = self.ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local input_manager = self.input_manager
	local parent = self.parent
	local input_service = self:input_service()
	local render_settings = self.render_settings
	local is_device_active = Managers.input:is_device_active("gamepad")

	self._widgets_by_name.bottom_panel.content.visible = is_device_active

	UIRenderer.begin_pass(ui_top_renderer, _ui_scenegraph, input_service, arg_30_1, nil, render_settings)

	render_settings.alpha_multiplier = render_settings.main_alpha_multiplier

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._hero_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_2)
	end

	for i_3, v_3 in ipairs(self._hero_icon_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_3)
	end

	for i_4, v_4 in ipairs(self._additional_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_4)
	end

	if not self._draw_video_next_frame then
		if not (not self._video_widget and self._prepare_exit) then
			if not self._video_created then
				UIRenderer.draw_widget(ui_top_renderer, self._video_widget)
			else
				self._video_created = nil
			end
		end
	elseif not self._draw_video_next_frame then
		self._draw_video_next_frame = nil
	end

	render_settings.alpha_multiplier = render_settings.info_alpha_multiplier

	for i_5, v_5 in ipairs(self._info_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_5)
	end

	render_settings.alpha_multiplier = render_settings.bot_selection_alpha_multiplier

	for i_6, v_6 in ipairs(self._bot_selection_widgets) do
		UIRenderer.draw_widget(ui_top_renderer, v_6)
	end

	UIRenderer.end_pass(ui_top_renderer)

	if not is_device_active then
		self.menu_input_description:draw(ui_top_renderer, arg_30_1)
	end

	if not self._scrollbar then
		render_settings.alpha_multiplier = render_settings.main_alpha_multiplier

		self._scrollbar:update(arg_30_1, arg_30_2, ui_top_renderer, input_service, render_settings)
	end
end

CharacterSelectionStateCharacter._update_animations = function (self, arg_31_1)
	-- function 31
	local select_button = self._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(select_button, arg_31_1)

	local bot_priority_button = self._widgets_by_name.bot_priority_button
	local back_button = self._widgets_by_name.back_button

	UIWidgetUtils.animate_default_button(bot_priority_button, arg_31_1)
	UIWidgetUtils.animate_default_button(back_button, arg_31_1)

	if not self.pick_time then
		self.pick_time = math.clamp(self.pick_time - arg_31_1, 0, 100)
		select_button.content.title_text = string.format(Localize("confirm_menu_button_name") .. " %.1f", self.pick_time)
		select_button.element.dirty = true
	end

	if not self:_is_button_hover_enter(select_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	if not self:_is_button_hover_enter(bot_priority_button) then
		self:_play_sound("play_gui_start_menu_button_hover")
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k, v in pairs(_animations) do
		if not ui_animator:is_animation_completed(v) then
			ui_animator:stop_animation(v)

			_animations[k] = nil
		end
	end
end

CharacterSelectionStateCharacter._spawn_hero_unit = function (self, arg_32_1)
	-- function 32
	local world_previewer = self.world_previewer
	local _selected_career_index = self._selected_career_index
	local var_32_2 = callback(self, "cb_hero_unit_spawned", arg_32_1)

	world_previewer:request_spawn_hero_unit(arg_32_1, _selected_career_index, not self.use_user_skins, var_32_2, nil, 0.5)
end

CharacterSelectionStateCharacter.cb_hero_unit_spawned = function (self, arg_33_1)
	-- function 33
	local world_previewer = self.world_previewer
	local _selected_career_index = self._selected_career_index
	local var_33_2 = FindProfileIndex(arg_33_1)
	local var_33_3 = SPProfiles[var_33_2].careers[_selected_career_index]
	local preview_animation = var_33_3.preview_animation
	local preview_wield_slot = var_33_3.preview_wield_slot
	local clone = table.clone(var_33_3.preview_items)
	local name = var_33_3.name

	if not self.use_loadout_items then
		table.clear(clone)

		preview_wield_slot = preview_wield_slot or "melee"

		local var_33_8 = InventorySettings.slot_names_by_type[preview_wield_slot][1]
		local key = BackendUtils.get_loadout_item(name, var_33_8).key
		local key_2 = BackendUtils.get_loadout_item(name, "slot_hat").key

		clone[#clone + 1] = {
			item_name = key
		}
		clone[#clone + 1] = {
			item_name = key_2
		}
	end

	if not clone then
		for i, v in ipairs(clone) do
			local item_name = v.item_name
			local slot_type = ItemMasterList[item_name].slot_type
			local var_33_13 = InventorySettings.slot_names_by_type[slot_type][1]
			local var_33_14 = InventorySettings.slots_by_name[var_33_13]

			world_previewer:equip_item(item_name, var_33_14)
		end

		if not preview_wield_slot then
			world_previewer:wield_weapon_slot(preview_wield_slot)
		end
	end

	local preview_props = var_33_3.preview_props

	if not preview_props then
		world_previewer:spawn_all_props(preview_props)
	end

	if not self.use_user_skins then
		local get_loadout_item = BackendUtils.get_loadout_item(name, "slot_hat")

		if not get_loadout_item then
			local name_2 = get_loadout_item.data.name
			local backend_id = get_loadout_item.backend_id
			local slot_hat = InventorySettings.slots_by_name.slot_hat

			world_previewer:equip_item(name_2, slot_hat, backend_id)
		elseif not var_33_3.required_dlc and not Managers.unlock:is_dlc_unlocked(var_33_3.required_dlc) then
			Crashify.print_exception("[Cosmetic] Failed to equip item in slot \"slot_hat\" for career %q in character selection state character", name)
		end

		local get_loadout_item_2 = BackendUtils.get_loadout_item(name, "slot_skin")
		local flag = not get_loadout_item_2 and get_loadout_item_2.data

		preview_animation = not flag and flag.career_select_preview_animation and preview_animation
	end

	if not (not preview_animation and self.use_loadout_items) then
		self.world_previewer:play_character_animation(preview_animation)
	end
end

CharacterSelectionStateCharacter._is_button_pressed = function (arg_34_0, arg_34_1)
	-- function 34
	local button_hotspot = arg_34_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

CharacterSelectionStateCharacter._is_button_hover_enter = function (arg_35_0, arg_35_1)
	-- function 35
	return arg_35_1.content.button_hotspot.on_hover_enter
end

CharacterSelectionStateCharacter._is_button_hover_exit = function (arg_36_0, arg_36_1)
	-- function 36
	return arg_36_1.content.button_hotspot.on_hover_exit
end

CharacterSelectionStateCharacter._populate_career_info = function (self, arg_37_1, arg_37_2)
	-- function 37
	local _ui_scenegraph = self._ui_scenegraph
	local ui_top_renderer = self.ui_top_renderer
	local _widgets_by_name = self._widgets_by_name
	local var_37_3 = SPProfiles[arg_37_1]
	local display_name = var_37_3.display_name
	local var_37_5 = var_37_3.careers[arg_37_2]
	local name = var_37_5.name
	local get_passive_ability_by_career = CareerUtils.get_passive_ability_by_career(var_37_5)
	local get_ability_data = CareerUtils.get_ability_data(arg_37_1, arg_37_2, 1)
	local display_name_2 = get_passive_ability_by_career.display_name
	local icon = get_passive_ability_by_career.icon
	local display_name_3 = get_ability_data.display_name
	local icon_2 = get_ability_data.icon

	_widgets_by_name.passive_title_text.content.text = Localize(display_name_2)
	_widgets_by_name.passive_description_text.content.text = UIUtils.get_ability_description(get_passive_ability_by_career)
	_widgets_by_name.passive_icon.content.texture_id = icon
	_widgets_by_name.active_title_text.content.text = Localize(display_name_3)
	_widgets_by_name.active_description_text.content.text = UIUtils.get_ability_description(get_ability_data)
	_widgets_by_name.active_icon.content.texture_id = icon_2

	local perks = get_passive_ability_by_career.perks
	local num_2 = 0
	local num_3 = 0

	for i = 1, NUM_PERKS do
		local var_37_16 = _widgets_by_name["career_perk_" .. i]
		local content = var_37_16.content
		local style = var_37_16.style
		local size = _ui_scenegraph[var_37_16.scenegraph_id].size

		var_37_16.offset[2] = -num_2

		local var_37_20 = perks[i]

		if not var_37_20 then
			local var_37_21 = Localize(var_37_20.display_name)
			local get_perk_description = UIUtils.get_perk_description(var_37_20)
			local title_text = style.title_text
			local description_text = style.description_text
			local description_text_shadow = style.description_text_shadow

			content.title_text = var_37_21
			content.description_text = get_perk_description

			local get_text_height = UIUtils.get_text_height(ui_top_renderer, size, title_text, var_37_21)
			local get_text_height_2 = UIUtils.get_text_height(ui_top_renderer, size, description_text, get_perk_description)

			description_text.offset[2] = -get_text_height_2
			description_text_shadow.offset[2] = -(get_text_height_2 + 2)
			num_2 = num_2 + get_text_height + get_text_height_2 + num_3
		end

		content.visible = var_37_20 ~= nil
	end

	local max = math.max(num_2 - num, 0)

	self:_setup_additional_career_info(var_37_5, max)

	local video = var_37_5.video
	local material_name = video.material_name
	local resource = video.resource

	self._current_video_settings = {
		video = video,
		material_name = material_name,
		resource = resource
	}

	self:_destroy_video_player()
end

CharacterSelectionStateCharacter._setup_additional_career_info = function (self, arg_38_1, arg_38_2)
	-- function 38
	local flag = arg_38_2 or 0

	if not arg_38_1.additional_ui_info_file then
		local var_38_1 = local_require(arg_38_1.additional_ui_info_file)
		local str = "scrollbar_window"
		local str_2 = "scrollbar_anchor"
		local var_38_4 = self._ui_scenegraph[str].size[2]
		local tbl = {
			0,
			-var_38_4,
			0
		}
		local var_38_6
		local var_38_7

		self._additional_widgets, self._additional_widgets_by_name, var_38_7 = var_38_1.setup(str, tbl)

		local var_38_8
		local flag_2 = true

		self._scrollbar = ScrollbarUI:new(self._ui_scenegraph, str, str_2, var_38_7 + flag, flag_2, var_38_8)
	else
		table.clear(self._additional_widgets)
		table.clear(self._additional_widgets_by_name)

		if flag > 0 then
			local str_3 = "scrollbar_window"
			local str_4 = "scrollbar_anchor"
			local flag_3 = true
			local var_38_13

			self._scrollbar = ScrollbarUI:new(self._ui_scenegraph, str_3, str_4, flag, flag_3, var_38_13)
		elseif not self._scrollbar then
			self._scrollbar:destroy(self._ui_scenegraph)

			self._scrollbar = nil
		end
	end
end

CharacterSelectionStateCharacter._handle_input = function (self, arg_39_1, arg_39_2)
	-- function 39
	local input_service = self:input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	if not self._bot_selection then
		self:_handle_gamepad_bot_selection(input_service)
		self:_handle_mouse_bot_selection(input_service)

		local back_button = self._widgets_by_name.back_button
		local get

		if not is_device_active then
			get = input_service:get("back_menu_alt", true)

			if not get then
				-- Nothing
			end
		end

		get = input_service:get("toggle_menu", true)
		get = get or input_service:get("back", true)

		::label_39_0::

		if get or not UIUtils.is_button_pressed(back_button) then
			self:_exit_bot_selection()
		end
	else
		self:_handle_gamepad_selection(input_service)
		self:_handle_mouse_selection()

		local profile_by_peer, var_39_5 = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)
		local select_button = self._widgets_by_name.select_button
		local flag = not select_button.content.button_hotspot.disable_button
		local bot_priority_button = self._widgets_by_name.bot_priority_button
		local flag_2 = not flag and input_service:get("confirm_press", true)
		local get_2

		if not self.allow_back_button then
			get_2 = input_service:get("back_menu_alt", true)

			if not get_2 then
				-- Nothing
			end
		end

		get_2 = input_service:get("back", true)

		::label_39_1::

		if self:_is_button_pressed(select_button) or not flag_2 then
			self:_play_sound("play_gui_start_menu_button_click")

			if not select_button.content.dlc_name then
				Managers.state.event:trigger("ui_show_popup", select_button.content.dlc_name, "upsell")
			elseif not (profile_by_peer ~= self._selected_profile_index or var_39_5 == self._selected_career_index) then
				local verify_dlc_name = select_button.content.verify_dlc_name

				if not verify_dlc_name and not Managers.unlock:dlc_requires_restart(verify_dlc_name) then
					self.parent:close_menu()

					return
				end

				if not Network.game_session() then
					return
				end

				self:_change_profile(self._selected_profile_index, self._selected_career_index)
				self.parent:set_input_blocked(true)
			else
				self.parent:close_menu()
			end
		elseif not get_2 then
			self.parent:close_menu()
		elseif not self:_is_button_pressed(bot_priority_button) then
			self:_enter_bot_selection()
		end
	end
end

CharacterSelectionStateCharacter._set_hero_info = function (self, arg_40_1, arg_40_2, arg_40_3)
	-- function 40
	local _widgets_by_name = self._widgets_by_name

	_widgets_by_name.info_hero_name.content.text = arg_40_1
	_widgets_by_name.info_career_name.content.text = arg_40_2
	_widgets_by_name.info_hero_level.content.text = tostring(arg_40_3)
end

CharacterSelectionStateCharacter._set_select_button_enabled = function (self, arg_41_1, arg_41_2, arg_41_3)
	-- function 41
	if not self._bot_selection then
		local content = self._widgets_by_name.select_button.content

		if not arg_41_1 then
			self.menu_input_description:set_input_description(generic_input_actions.bot_selection_available)
		else
			self.menu_input_description:set_input_description(nil)
		end
	else
		local content_2 = self._widgets_by_name.select_button.content

		if not arg_41_1 then
			content_2.title_text = Localize("input_description_confirm")
			content_2.button_hotspot.disable_button = false
			content_2.verify_dlc_name = arg_41_3
			content_2.dlc_name = nil

			self.menu_input_description:set_input_description(generic_input_actions.available)
		elseif not arg_41_2 then
			content_2.title_text = Localize("menu_store_purchase_button_unlock")
			content_2.button_hotspot.disable_button = false
			content_2.dlc_name = arg_41_2
			content_2.verify_dlc_name = nil

			self.menu_input_description:set_input_description(generic_input_actions.purchase)
		else
			content_2.title_text = Localize("dlc1_2_difficulty_unavailable")
			content_2.button_hotspot.disable_button = true
			content_2.dlc_name = nil
			content_2.verify_dlc_name = nil

			self.menu_input_description:set_input_description(nil)
		end
	end
end

CharacterSelectionStateCharacter._play_sound = function (self, arg_42_1)
	-- function 42
	self.parent:play_sound(arg_42_1)
end

CharacterSelectionStateCharacter.get_camera_position = function (self)
	-- function 43
	local get_background_world, var_43_1 = self.parent:get_background_world()
	local camera = ScriptViewport.camera(var_43_1)

	return ScriptCamera.position(camera)
end

CharacterSelectionStateCharacter.get_camera_rotation = function (self)
	-- function 44
	local get_background_world, var_44_1 = self.parent:get_background_world()
	local camera = ScriptViewport.camera(var_44_1)

	return ScriptCamera.rotation(camera)
end

CharacterSelectionStateCharacter.trigger_unit_flow_event = function (arg_45_0, arg_45_1, arg_45_2)
	-- function 45
	if not arg_45_1 and not Unit.alive(arg_45_1) then
		Unit.flow_event(arg_45_1, arg_45_2)
	end
end

CharacterSelectionStateCharacter._start_transition_animation = function (self, arg_46_1, arg_46_2)
	-- function 46
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local _widgets_by_name = self._widgets_by_name
	local start_animation = self.ui_animator:start_animation(arg_46_2, _widgets_by_name, scenegraph_definition, tbl)

	self._animations[arg_46_1] = start_animation
end

CharacterSelectionStateCharacter._change_profile = function (self, arg_47_1, arg_47_2)
	-- function 47
	local peer_id = self.peer_id
	local num = 1
	local var_47_2 = SPProfiles[arg_47_1]
	local display_name = var_47_2.display_name
	local display_name_2 = var_47_2.careers[arg_47_2].display_name
	local flag = true

	self._profile_requester:request_profile(peer_id, num, display_name, display_name_2, flag)

	self._pending_profile_request = true
	self._requested_profile_index = arg_47_1
	self._requested_career_index = arg_47_2
end

CharacterSelectionStateCharacter._change_career = function (self, arg_48_1, arg_48_2)
	-- function 48
	local local_player = self.local_player
	local player_unit = local_player.player_unit

	if not local_player.player_unit then
		self._despawning_player_unit_career_change = player_unit

		Managers.state.spawn:delayed_despawn(local_player)

		self._respawn_position = Vector3Box(POSITION_LOOKUP[player_unit])
		self._respawn_rotation = QuaternionBox(Unit.local_rotation(player_unit, 0))
	end

	local display_name = SPProfiles[arg_48_1].display_name

	self:_save_selected_profile(arg_48_1)

	local network_id = local_player:network_id()
	local local_player_id = local_player:local_player_id()
	local bot_player = local_player.bot_player
	local flag = false

	self._profile_synchronizer:resync_loadout(network_id, local_player_id, bot_player, flag)
	CosmeticUtils.sync_local_player_cosmetics(local_player, arg_48_1, arg_48_2)

	self._resyncing_loadout = true
end

CharacterSelectionStateCharacter.pending_profile_request = function (self)
	-- function 49
	return self._pending_profile_request
end

CharacterSelectionStateCharacter._save_selected_profile = function (arg_50_0, arg_50_1)
	-- function 50
	if not SaveData.first_hero_selection_made then
		SaveData.first_hero_selection_made = true
	end

	SaveData.wanted_profile_index = arg_50_1

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

CharacterSelectionStateCharacter._update_profile_request = function (self)
	-- function 51
	if not self._pending_profile_request then
		local result = self._profile_requester:result()

		if result == "success" then
			self._pending_profile_request = nil

			local _requested_profile_index = self._requested_profile_index
			local _requested_career_index = self._requested_career_index

			self:_save_selected_profile(_requested_profile_index)
			self.parent:set_current_hero(_requested_profile_index)

			if not self._close_on_successful_profile_request then
				self.parent:close_menu()
			end

			self._close_on_successful_profile_request = true
		elseif result == "failure" then
			self._pending_profile_request = nil

			self.parent:set_input_blocked(false)
		end
	end
end

CharacterSelectionStateCharacter._on_option_button_hover = function (self, arg_52_1, arg_52_2)
	-- function 52
	local _ui_animations = self._ui_animations
	local str = "option_button_" .. arg_52_2
	local var_52_2 = arg_52_1.style[arg_52_2]
	local var_52_3 = var_52_2.color[2]
	local num = 255
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = (1 - var_52_3 / num) * topic_hover_duration

	for i = 2, 4 do
		if num_2 > 0 then
			_ui_animations[str .. "_hover_" .. i] = self:_animate_element_by_time(var_52_2.color, i, var_52_3, num, num_2)
		else
			var_52_2.color[i] = num
		end
	end
end

CharacterSelectionStateCharacter._on_option_button_dehover = function (self, arg_53_1, arg_53_2)
	-- function 53
	local _ui_animations = self._ui_animations
	local str = "option_button_" .. arg_53_2
	local var_53_2 = arg_53_1.style[arg_53_2]
	local var_53_3 = var_53_2.color[1]
	local num = 100
	local topic_hover_duration = UISettings.scoreboard.topic_hover_duration
	local num_2 = var_53_3 / 255 * topic_hover_duration

	for i = 2, 4 do
		if num_2 > 0 then
			_ui_animations[str .. "_hover_" .. i] = self:_animate_element_by_time(var_53_2.color, i, var_53_3, num, num_2)
		else
			var_53_2.color[1] = num
		end
	end
end

CharacterSelectionStateCharacter.play_sound = function (arg_54_0, arg_54_1)
	-- function 54
	return
end

CharacterSelectionStateCharacter._animate_element_by_time = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	-- function 55
	return (UIAnimation.init(UIAnimation.function_by_time, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, math.ease_out_quad))
end

CharacterSelectionStateCharacter._animate_element_by_catmullrom = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8)
	-- function 56
	return (UIAnimation.init(UIAnimation.catmullrom, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8))
end

CharacterSelectionStateCharacter.input_service = function (self)
	-- function 57
	local FAKE_INPUT_SERVICE

	if self._pending_profile_request or self._resyncing_loadout or not self.parent:input_blocked() then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self.parent:input_service(true)

	::label_57_0::

	return FAKE_INPUT_SERVICE
end
