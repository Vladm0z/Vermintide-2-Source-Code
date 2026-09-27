-- chunkname: @scripts/ui/views/hero_view/windows/hero_window_loadout_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/hero_view/windows/definitions/hero_window_loadout_selection_console_definitions")
local widgets = var_0_0.widgets
local loadout_button_widgets = var_0_0.loadout_button_widgets
local gamepad_specific_widgets = var_0_0.gamepad_specific_widgets
local context_menu_widgets = var_0_0.context_menu_widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local button_size = var_0_0.button_size
local button_spacing = var_0_0.button_spacing
local equipment_slots = var_0_0.equipment_slots
local cosmetic_slots = var_0_0.cosmetic_slots
local generic_input_actions = var_0_0.generic_input_actions

HeroWindowLoadoutSelectionConsole = class(HeroWindowLoadoutSelectionConsole)
HeroWindowLoadoutSelectionConsole.NAME = "HeroWindowLoadoutSelectionConsole"

HeroWindowLoadoutSelectionConsole.on_enter = function (self, arg_1_1, arg_1_2)
	-- function 1
	print("[HeroViewWindow] Enter Substate HeroWindowLoadoutSelectionConsole")

	self._parent = arg_1_1.parent

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self._ui_renderer = ingame_ui_context.ui_renderer
	self._ui_top_renderer = ingame_ui_context.ui_top_renderer
	self._input_manager = ingame_ui_context.input_manager
	self._statistics_db = ingame_ui_context.statistics_db
	self._render_settings = {
		snap_pixel_positions = true
	}

	local player = Managers.player

	self._stats_id = player:local_player():stats_id()
	self._player_manager = player
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer
	self._peer_id = ingame_ui_context.peer_id
	self._local_player_id = ingame_ui_context.local_player_id
	self._game_mode_key = Managers.state.game_mode:game_mode_key()
	self._hero_name = arg_1_1.hero_name
	self._career_index = arg_1_1.career_index
	self._profile_index = arg_1_1.profile_index
	self._animations = {}
	self._ui_animations = {}
	self._gamepad_loadout_grid = {}
	self._gamepad_grid_index = {}

	self:_create_ui_elements(arg_1_1, arg_1_2)
	self:_hide_context_menu()
	self:_start_transition_animation("on_enter")

	local get_service = Managers.input:get_service("hero_view")
	local num = UILayer.default + 300
	local default = generic_input_actions.default

	if self._num_loadouts <= 1 then
		default = generic_input_actions.default_no_delete
	end

	self._menu_input_description = MenuInputDescriptionUI:new(nil, self._ui_top_renderer, get_service, 7, num, default, true)

	self._menu_input_description:set_input_description(nil)
end

HeroWindowLoadoutSelectionConsole._start_transition_animation = function (self, arg_2_1)
	-- function 2
	local tbl = {
		render_settings = self._render_settings
	}
	local tbl_2 = {}
	local start_animation = self._ui_animator:start_animation(arg_2_1, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_2_1] = start_animation
end

HeroWindowLoadoutSelectionConsole._create_ui_elements = function (self, arg_3_1, arg_3_2)
	-- function 3
	self._ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		local var_3_2 = UIWidget.init(v)

		tbl[#tbl + 1] = var_3_2
		tbl_2[k] = var_3_2
	end

	self._widgets = tbl

	local tbl_3 = {}

	for k_2, v_2 in pairs(loadout_button_widgets) do
		local var_3_4 = UIWidget.init(v_2)

		tbl_3[#tbl_3 + 1] = var_3_4
		tbl_2[k_2] = var_3_4
	end

	self._loadout_button_widgets = tbl_3

	local tbl_4 = {}

	for k_3, v_3 in pairs(context_menu_widgets) do
		local var_3_6 = UIWidget.init(v_3)

		tbl_4[#tbl_4 + 1] = var_3_6
		tbl_2[k_3] = var_3_6
	end

	tbl_2.delete_button_bar.content.visible = false
	tbl_2.delete_button_bar_edge.content.visible = false
	self._context_menu_widgets = tbl_4

	local tbl_5 = {}

	for k_4, v_4 in pairs(gamepad_specific_widgets) do
		local var_3_8 = UIWidget.init(v_4)

		tbl_5[#tbl_5 + 1] = var_3_8
		tbl_2[k_4] = var_3_8
	end

	self._gamepad_specific_widgets = tbl_5

	local content = tbl_2.bot_checkbox.content
	local var_3_10 = InventorySettings.bot_loadout_allowed_game_modes[self._game_mode_key]

	var_3_10 = var_3_10 or false
	content.visible = var_3_10
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self._ui_renderer)

	self._ui_animator = UIAnimator:new(self._ui_scenegraph, animation_definitions)

	if not arg_3_2 then
		local local_position = self._ui_scenegraph.window.local_position

		local_position[1] = local_position[1] + arg_3_2[1]
		local_position[2] = local_position[2] + arg_3_2[2]
		local_position[3] = local_position[3] + arg_3_2[3]
	end

	self:_populate_loadout_buttons()
end

HeroWindowLoadoutSelectionConsole._populate_loadout_buttons = function (self)
	-- function 4
	local name = SPProfiles[self._profile_index].careers[self._career_index].name
	local get_interface = Managers.backend:get_interface("items")
	local get_career_loadouts = get_interface:get_career_loadouts(name)
	local get_selected_career_loadout = get_interface:get_selected_career_loadout(name)

	self._num_loadouts = #get_career_loadouts

	if get_selected_career_loadout > self._num_loadouts then
		get_selected_career_loadout = 1
	end

	self._max_loadouts = 0

	for i, v in ipairs(InventorySettings.loadouts) do
		if v.loadout_type == "custom" then
			self._max_loadouts = self._max_loadouts + 1
		end
	end

	self._widgets_by_name.add_loadout_button.content.button_hotspot.disable_button = self._num_loadouts >= self._max_loadouts
	self._selected_loadout_index = get_selected_career_loadout

	if not InventorySettings.bot_loadout_allowed_game_modes[self._game_mode_key] then
		local PlayerData = PlayerData
		local loadout_selection = PlayerData.loadout_selection

		loadout_selection = loadout_selection or {}
		PlayerData.loadout_selection = loadout_selection

		local loadout_selection_2 = PlayerData.loadout_selection
		local bot_equipment = PlayerData.loadout_selection.bot_equipment

		bot_equipment = bot_equipment or {}
		loadout_selection_2.bot_equipment = bot_equipment

		local var_4_8 = PlayerData.loadout_selection.bot_equipment[name]

		if not (not var_4_8 and not (var_4_8 > self._num_loadouts)) then
			PlayerData.loadout_selection.bot_equipment[name] = get_selected_career_loadout
		end
	end

	for i_2, v_2 in ipairs(self._loadout_button_widgets) do
		local content = v_2.content

		content.visible = get_career_loadouts[i_2] ~= nil
		content.is_selected = i_2 == self._selected_loadout_index
		content.loadout = get_career_loadouts[i_2]
		content.loadout_index = i_2
		content.career_name = name
	end

	local loadout_frame = self._widgets_by_name.loadout_frame
	local offset = self._loadout_button_widgets[get_selected_career_loadout].offset

	loadout_frame.offset[1] = offset[1]
	loadout_frame.offset[3] = -10
	self._ui_scenegraph.button.offset[1] = -(button_size[1] + button_spacing) * (self._num_loadouts - 1)
end

HeroWindowLoadoutSelectionConsole.on_exit = function (self, arg_5_1)
	-- function 5
	print("[HeroViewWindow] Exit Substate HeroWindowLoadoutSelectionConsole")

	self._ui_animator = nil

	if not InventorySettings.save_local_loadout_selection[self._game_mode_key] then
		return
	end

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player:career_name()

	if not flag and not self._selected_loadout_index then
		local var_5_2

		for i, v in ipairs(InventorySettings.loadouts) do
			local loadout_index = v.loadout_index

			if not (v.loadout_type ~= "custom" or loadout_index ~= self._selected_loadout_index) then
				var_5_2 = i

				break
			end
		end

		if not var_5_2 then
			return
		end

		local current_mechanism_name = Managers.mechanism:current_mechanism_name()
		local PlayerData = PlayerData
		local loadout_selection = PlayerData.loadout_selection

		loadout_selection = loadout_selection or {}
		PlayerData.loadout_selection = loadout_selection

		local loadout_selection_2 = PlayerData.loadout_selection
		local var_5_8 = PlayerData.loadout_selection[current_mechanism_name]

		var_5_8 = var_5_8 or {}
		loadout_selection_2[current_mechanism_name] = var_5_8
		PlayerData.loadout_selection[current_mechanism_name][flag] = var_5_2

		Managers.save:auto_save(SaveFileName, SaveData, nil)
	end
end

HeroWindowLoadoutSelectionConsole.update = function (self, arg_6_1, arg_6_2)
	-- function 6
	self:_update_animations(arg_6_1)
	self:_handle_input(arg_6_1, arg_6_2)
	self:_draw(arg_6_1)
end

HeroWindowLoadoutSelectionConsole.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	return
end

HeroWindowLoadoutSelectionConsole._update_animations = function (self, arg_8_1)
	-- function 8
	local _ui_animations = self._ui_animations
	local _animations = self._animations
	local _ui_animator = self._ui_animator

	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_8_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	_ui_animator:update(arg_8_1)

	for k_2, v_2 in pairs(_animations) do
		if not _ui_animator:is_animation_completed(v_2) then
			_ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end

	for i, v_3 in ipairs(self._loadout_button_widgets) do
		UIWidgetUtils.animate_default_button(v_3, arg_8_1)
	end

	local add_loadout_button = self._widgets_by_name.add_loadout_button

	UIWidgetUtils.animate_default_button(add_loadout_button, arg_8_1)

	if not InventorySettings.bot_loadout_allowed_game_modes[self._game_mode_key] then
		local bot_checkbox = self._widgets_by_name.bot_checkbox

		UIWidgetUtils.animate_default_checkbox_button(bot_checkbox, arg_8_1)
	end

	if not self._context_menu_active then
		local delete_button = self._widgets_by_name.delete_button

		UIWidgetUtils.animate_default_button(delete_button, arg_8_1)
	end
end

HeroWindowLoadoutSelectionConsole._handle_gamepad_activity = function (self)
	-- function 9
	local is_device_active = Managers.input:is_device_active("gamepad")

	if is_device_active ~= self._gamepad_active_last_frame then
		self:_hide_context_menu()
	end

	self._gamepad_active_last_frame = is_device_active
end

HeroWindowLoadoutSelectionConsole._handle_input = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:_handle_gamepad_activity(arg_10_1, arg_10_2)

	local _get_input_service = self:_get_input_service()

	if not Managers.input:is_device_active("mouse") then
		self:_handle_mouse_input(_get_input_service, arg_10_1, arg_10_2)
	else
		self:_handle_gamepad_input(_get_input_service, arg_10_1, arg_10_2)
	end
end

HeroWindowLoadoutSelectionConsole._get_input_service = function (self)
	-- function 11
	local get_service

	if self._context_menu_active or not self._on_add_loadout_button then
		get_service = Managers.input:get_service("hero_view")

		if not get_service then
			-- Nothing
		end
	end

	get_service = self._parent:window_input_service()

	::label_11_0::

	return get_service
end

HeroWindowLoadoutSelectionConsole._update_selection_frame = function (self, arg_12_1)
	-- function 12
	local loadout_index = arg_12_1.content.loadout_index
	local hover_loadout_frame = self._widgets_by_name.hover_loadout_frame

	if loadout_index ~= self._selected_loadout_index then
		local offset = arg_12_1.offset

		hover_loadout_frame.offset = table.clone(offset)
		hover_loadout_frame.content.visible = true
		hover_loadout_frame.content.loadout_index = loadout_index
	else
		hover_loadout_frame.content.visible = false
	end
end

HeroWindowLoadoutSelectionConsole._update_button_hover = function (self, arg_13_1, arg_13_2)
	-- function 13
	self:_update_selection_frame(arg_13_1)

	local hover_enter_time = arg_13_1.content.hover_enter_time

	hover_enter_time = hover_enter_time or math.huge

	if not (not (hover_enter_time < arg_13_2) or self._context_menu_active) then
		self:_show_context_menu(arg_13_1)
	end
end

HeroWindowLoadoutSelectionConsole._reset_hover_frame = function (self)
	-- function 14
	local hover_loadout_frame = self._widgets_by_name.hover_loadout_frame

	if not self._context_menu_active then
		if hover_loadout_frame.content.loadout_index ~= self._context_menu_loadout_index then
			hover_loadout_frame.content.visible = false
		end
	else
		hover_loadout_frame.content.visible = false
	end
end

HeroWindowLoadoutSelectionConsole._handle_mouse_input = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	local var_15_0

	self:_reset_hover_frame()

	for i, v in ipairs(self._loadout_button_widgets) do
		if not UIUtils.is_button_hover_enter(v) then
			v.content.hover_enter_time = arg_15_3 + 0

			self:_play_sound("Play_hud_hover")
		elseif not UIUtils.is_button_hover(v) then
			self:_update_button_hover(v, arg_15_3)

			var_15_0 = i
		end

		if not UIUtils.is_button_pressed(v) then
			local content = v.content

			self:_change_loadout(i)

			return
		end
	end

	local context_menu_hotspot = self._widgets_by_name.context_menu_hotspot

	if not (not self._context_menu_active and UIUtils.is_button_hover(context_menu_hotspot) or var_15_0 ~= self._context_menu_loadout_index) then
		self:_handle_context_menu_input(arg_15_1, arg_15_2, arg_15_3)

		context_menu_hotspot.content.hover_timer = arg_15_3 + 0.1
	elseif not self._context_menu_active then
		if not var_15_0 then
			local hover_timer = context_menu_hotspot.content.hover_timer

			hover_timer = hover_timer or 0

			if hover_timer < arg_15_3 then
				-- Nothing
			end
		end

		self:_hide_context_menu()
	end

	::label_15_0::

	local add_loadout_button = self._widgets_by_name.add_loadout_button

	if not UIUtils.is_button_hover_enter(add_loadout_button) then
		self:_play_sound("Play_hud_hover")
	elseif not UIUtils.is_button_pressed(add_loadout_button) then
		self:_add_loadout()
	end
end

HeroWindowLoadoutSelectionConsole._handle_gamepad_input = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	if not self._inside_context_menu then
		self:_handle_context_menu_gamepad_input(arg_16_1, arg_16_2, arg_16_3)
	elseif not self._on_add_loadout_button then
		self:_handle_add_loadout_gamepad_input(arg_16_1, arg_16_2, arg_16_3)
	elseif not self._context_menu_active then
		if arg_16_1:get("move_left") or not arg_16_1:get("trigger_cycle_previous") then
			local _context_menu_loadout_index = self._context_menu_loadout_index
			local max = math.max(_context_menu_loadout_index - 1, 1)

			if _context_menu_loadout_index ~= max then
				self:_hide_context_menu()

				local var_16_2 = self._loadout_button_widgets[max]

				self:_show_context_menu(var_16_2)
				self:_update_selection_frame(var_16_2)
			end
		elseif arg_16_1:get("move_right") or not arg_16_1:get("trigger_cycle_next") then
			local _context_menu_loadout_index_2 = self._context_menu_loadout_index
			local min = math.min(_context_menu_loadout_index_2 + 1, self._num_loadouts)

			if _context_menu_loadout_index_2 ~= min then
				self:_hide_context_menu()

				local var_16_5 = self._loadout_button_widgets[min]

				self:_show_context_menu(var_16_5)
				self:_update_selection_frame(var_16_5)
			elseif self._num_loadouts < self._max_loadouts then
				self:_on_enter_add_loadout_gamepad()
			end
		elseif not arg_16_1:get("special_1") then
			self:_enter_details_menu()
		elseif arg_16_1:get("back") or arg_16_1:get("right_stick_press") or not arg_16_1:get("toggle_menu") then
			self:_hide_context_menu()
		elseif not arg_16_1:get("confirm") then
			self:_change_loadout(self._context_menu_loadout_index)
		elseif not arg_16_1:get("left_stick_press") then
			if not InventorySettings.bot_loadout_allowed_game_modes[self._game_mode_key] then
				local content = self._widgets_by_name.bot_checkbox.content

				content.button_hotspot.is_selected = true
				content.button_hotspot.disable_button = true

				self:_save_bot_equipment()
			end
		else
			self:_handle_delete_input(arg_16_1, arg_16_2, arg_16_3)
		end
	elseif not arg_16_1:get("right_stick_press") then
		local var_16_7 = self._loadout_button_widgets[self._selected_loadout_index]

		if not var_16_7 then
			return
		end

		self:_show_context_menu(var_16_7)
		self:_update_selection_frame(var_16_7)

		local flag = true

		self:_update_gamepad_selections(flag)

		self._inside_context_menu = false

		self._parent:block_input()
	elseif not arg_16_1:get("trigger_cycle_next") then
		local min_2 = math.min(self._selected_loadout_index + 1, self._num_loadouts)

		self:_change_loadout(min_2)
	elseif not arg_16_1:get("trigger_cycle_previous") then
		local max_2 = math.max(self._selected_loadout_index - 1, 1)

		self:_change_loadout(max_2)
	end
end

HeroWindowLoadoutSelectionConsole._handle_add_loadout_gamepad_input = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	if not arg_17_1:get("confirm") then
		self:_add_loadout()

		local flag = true

		self:_update_gamepad_selections(flag)

		self._inside_context_menu = false

		self:_hide_context_menu()
	elseif arg_17_1:get("back") or arg_17_1:get("right_stick_press") or not arg_17_1:get("toggle_menu") then
		self:_hide_context_menu()
	elseif arg_17_1:get("move_left") or not arg_17_1:get("trigger_cycle_previous") then
		local var_17_1 = self._loadout_button_widgets[self._num_loadouts]

		self:_show_context_menu(var_17_1)
		self:_update_selection_frame(var_17_1)

		local flag_2 = true

		self:_update_gamepad_selections(flag_2)

		self._inside_context_menu = false

		if self._num_loadouts > 1 then
			self._menu_input_description:change_generic_actions(generic_input_actions.default)
		else
			self._menu_input_description:change_generic_actions(generic_input_actions.default_no_delete)
		end

		self._parent:block_input()
	end
end

HeroWindowLoadoutSelectionConsole._on_enter_add_loadout_gamepad = function (self)
	-- function 18
	self:_hide_context_menu()

	self._on_add_loadout_button = true

	local hover_loadout_frame = self._widgets_by_name.hover_loadout_frame

	hover_loadout_frame.content.visible = true
	hover_loadout_frame.offset[1] = self._num_loadouts * (button_size[1] + button_spacing)

	if self._num_loadouts >= self._max_loadouts then
		self._menu_input_description:change_generic_actions(generic_input_actions.add_loadout_no_add)
	else
		self._menu_input_description:change_generic_actions(generic_input_actions.add_loadout)
	end

	self._parent:block_input()
end

HeroWindowLoadoutSelectionConsole._enter_details_menu = function (self)
	-- function 19
	self._inside_context_menu = true

	table.clear(self._gamepad_grid_index)
	self:_update_gamepad_selections()
	self._menu_input_description:change_generic_actions(generic_input_actions.details)
end

HeroWindowLoadoutSelectionConsole._exit_details_menu = function (self)
	-- function 20
	self._inside_context_menu = nil

	table.clear(self._gamepad_grid_index)

	local flag = true

	self:_update_gamepad_selections(flag)

	if self._num_loadouts > 1 then
		self._menu_input_description:change_generic_actions(generic_input_actions.default)
	else
		self._menu_input_description:change_generic_actions(generic_input_actions.default_no_delete)
	end
end

HeroWindowLoadoutSelectionConsole._handle_context_menu_gamepad_input = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local flag = false
	local var_21_1 = self._gamepad_grid_index[1]
	local var_21_2 = self._gamepad_grid_index[2]
	local flag_2 = var_21_1 or #self._gamepad_loadout_grid
	local flag_3 = var_21_2 or 1

	if not arg_21_1:get("move_left") then
		flag_3 = math.max(var_21_2 - 1, 1)
	elseif not arg_21_1:get("move_right") then
		local var_21_5 = self._gamepad_loadout_grid[var_21_1]

		flag_3 = math.min(var_21_2 + 1, #var_21_5)
	elseif not arg_21_1:get("move_up") then
		local count = #self._gamepad_loadout_grid

		flag_2 = math.min(var_21_1 + 1, count)
	elseif not arg_21_1:get("move_down") then
		local count_2 = #self._gamepad_loadout_grid

		flag_2 = math.max(var_21_1 - 1, 1)
	elseif arg_21_1:get("special_1") or not arg_21_1:get("back") then
		self:_exit_details_menu()

		return
	elseif not arg_21_1:get("right_stick_press") then
		self:_exit_details_menu()
		self:_hide_context_menu()
	elseif not arg_21_1:get("toggle_menu") then
		self:_exit_details_menu()
		self:_hide_context_menu()
	else
		self:_handle_delete_input(arg_21_1, arg_21_2, arg_21_3)
	end

	if flag_2 ~= var_21_1 then
		self._gamepad_grid_index[1] = flag_2

		local var_21_8 = self._gamepad_loadout_grid[flag_2]

		self._gamepad_grid_index[2] = math.clamp(flag_3, 1, #var_21_8)

		self:_update_gamepad_selections()
	elseif flag_3 ~= var_21_2 then
		self._gamepad_grid_index[2] = flag_3

		self:_update_gamepad_selections()
	end
end

HeroWindowLoadoutSelectionConsole._handle_delete_input = function (self, arg_22_1, arg_22_2, arg_22_3)
	-- function 22
	if self._num_loadouts == 1 then
		return
	end

	local delete_button = self._widgets_by_name.delete_button
	local num = 1
	local _delete_progress = self._delete_progress

	_delete_progress = _delete_progress or 0

	if arg_22_1:get("refresh_hold") or not UIUtils.is_button_held(delete_button) or not UIUtils.is_button_hover(delete_button) then
		if not self._delete_started then
			self._delete_started = true

			self:_play_sound("Play_gui_loadout_delete_start")
		end

		_delete_progress = math.min(_delete_progress + arg_22_2 / num, 1)
	else
		_delete_progress = math.max(_delete_progress - arg_22_2 * num, 0)

		if not self._delete_started then
			self._delete_started = false

			self:_play_sound("Stop_gui_loadout_delete_start")
		end
	end

	local easeOutCubic = math.easeOutCubic(_delete_progress)

	self._ui_scenegraph.delete_button_bar.size[1] = 172 * easeOutCubic
	self._widgets_by_name.delete_button_bar.content.texture_id.uvs[2][1] = easeOutCubic

	if _delete_progress >= 1 then
		self:_delete_loadout()
	else
		self._delete_progress = _delete_progress
	end
end

HeroWindowLoadoutSelectionConsole._handle_bot_checkbox_input = function (self, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	if not InventorySettings.bot_loadout_allowed_game_modes[self._game_mode_key] then
		local bot_checkbox = self._widgets_by_name.bot_checkbox

		if not UIUtils.is_button_pressed(bot_checkbox) then
			local content = bot_checkbox.content

			content.button_hotspot.is_selected = true
			content.button_hotspot.disable_button = true

			self:_save_bot_equipment()
		end
	end
end

HeroWindowLoadoutSelectionConsole._save_bot_equipment = function (self)
	-- function 24
	local _profile_index = self._profile_index
	local _career_index = self._career_index
	local name = SPProfiles[_profile_index].careers[_career_index].name

	PlayerData.loadout_selection.bot_equipment[name] = self._context_menu_loadout_index

	Managers.backend:get_interface("items"):refresh_bot_loadouts()
end

HeroWindowLoadoutSelectionConsole._update_gamepad_selections = function (self, arg_25_1)
	-- function 25
	local flag

	flag = not arg_25_1 and 0 and self._gamepad_grid_index[1]

	local flag_2

	flag_2 = not arg_25_1 and 0 and self._gamepad_grid_index[2]

	for i, v in ipairs(self._gamepad_loadout_grid) do
		for i_2, v_2 in ipairs(v) do
			v_2.is_selected = i_2 ~= flag_2 or i == flag
		end
	end
end

HeroWindowLoadoutSelectionConsole._handle_context_menu_input = function (self, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	local delete_button = self._widgets_by_name.delete_button
	local context_menu_hotspot = self._widgets_by_name.context_menu_hotspot

	if not arg_26_1:get("toggle_menu", true) then
		self:_hide_context_menu()

		return
	end

	local get = arg_26_1:get("left_press")
	local get_2 = arg_26_1:get("right_press")
	local var_26_4 = self._loadout_button_widgets[self._context_menu_loadout_index]

	if not ((UIUtils.is_button_hover(context_menu_hotspot) or get or not get_2) and UIUtils.is_button_hover(var_26_4)) then
		self:_hide_context_menu()
	else
		self:_handle_delete_input(arg_26_1, arg_26_2, arg_26_3)
		self:_handle_bot_checkbox_input(arg_26_1, arg_26_2, arg_26_3)
	end
end

HeroWindowLoadoutSelectionConsole._delete_loadout = function (self)
	-- function 27
	local name = SPProfiles[self._profile_index].careers[self._career_index].name
	local flag = self._context_menu_loadout_index == self._selected_loadout_index

	Managers.backend:get_interface("items"):delete_loadout(name, self._context_menu_loadout_index)
	self:_populate_loadout_buttons()
	self._parent:update_full_loadout()

	if not flag then
		self._parent:set_loadout_dirty()
	end

	self._delete_progress = 0

	self:_exit_details_menu()
	self:_hide_context_menu()
	self:_play_sound("Play_gui_loadout_delete_finish")
end

HeroWindowLoadoutSelectionConsole._hide_context_menu = function (self)
	-- function 28
	self._context_menu_active = false
	self._inside_context_menu = false
	self._on_add_loadout_button = false

	local flag = true

	self:_update_gamepad_selections(flag)
	self:_reset_hover_frame()
	self._parent:unblock_input()
end

HeroWindowLoadoutSelectionConsole._show_context_menu = function (self, arg_29_1)
	-- function 29
	self._context_menu_active = true
	self._on_add_loadout_button = false

	local offset = arg_29_1.offset

	self._ui_scenegraph.context_menu.offset[1] = offset[1]

	local content = arg_29_1.content
	local loadout_index = content.loadout_index
	local loadout = content.loadout

	self:_populate_context_menu_loadout(loadout, loadout_index)

	local context_menu_bg = self._widgets_by_name.context_menu_bg
	local context_menu_bg_white = self._widgets_by_name.context_menu_bg_white

	if loadout_index == self._selected_loadout_index then
		context_menu_bg.content.visible = true
		context_menu_bg_white.content.visible = false
	else
		context_menu_bg.content.visible = false
		context_menu_bg_white.content.visible = true
	end

	for i, v in ipairs(self._loadout_button_widgets) do
		local offset_2 = v.offset
		local flag

		flag = i ~= loadout_index or not -20 or -100
		offset_2[3] = flag
	end

	self._delete_progress = 0
	self._ui_scenegraph.delete_button_bar.size[1] = 0

	local delete_button = self._widgets_by_name.delete_button

	delete_button.content.visible = self._num_loadouts > 1
	delete_button.content.title_text = Localize("input_description_delete_loadout") .. " " .. loadout_index

	local delete_button_bar = self._widgets_by_name.delete_button_bar

	delete_button_bar.content.texture_id.uvs[2][1] = 0
	delete_button_bar.content.visible = self._num_loadouts > 1
	self._widgets_by_name.delete_button_bar_edge.content.visible = self._num_loadouts > 1
	self._context_menu_loadout_index = loadout_index

	self._parent:block_input()

	if self._num_loadouts > 1 then
		self._menu_input_description:change_generic_actions(generic_input_actions.default)
	else
		self._menu_input_description:change_generic_actions(generic_input_actions.default_no_delete)
	end
end

local tbl = {}

HeroWindowLoadoutSelectionConsole._populate_context_menu_loadout = function (self, arg_30_1, arg_30_2)
	-- function 30
	self._gamepad_loadout_grid = {}

	local _profile_index = self._profile_index
	local _career_index = self._career_index
	local var_30_2 = SPProfiles[_profile_index]
	local var_30_3 = var_30_2.careers[_career_index]
	local display_name = var_30_2.display_name
	local name = var_30_3.name
	local tbl = {}

	for i, v in ipairs(InventorySettings.loadouts) do
		if v.loadout_type == "custom" then
			tbl[#tbl + 1] = v
		end
	end

	local var_30_7 = tbl[arg_30_2]
	local icon = self._widgets_by_name.icon
	local header = self._widgets_by_name.header
	local content = icon.content
	local loadout_icon = var_30_7.loadout_icon

	loadout_icon = loadout_icon or "icons_placeholder"
	content.texture_id = loadout_icon
	header.content.text = Localize("custom_loadout_" .. var_30_7.loadout_index .. "_title")

	local get_interface = Managers.backend:get_interface("items")
	local content_2 = self._widgets_by_name.cosmetics.content
	local var_30_14

	for i_2, v_2 in ipairs(cosmetic_slots) do
		local var_30_15

		if not CosmeticUtils.is_cosmetic_slot(v_2) then
			local var_30_16 = arg_30_1[v_2]
			local get_backend_id_from_cosmetic_item = get_interface:get_backend_id_from_cosmetic_item(var_30_16)

			var_30_15 = get_interface:get_item_from_id(get_backend_id_from_cosmetic_item)
		elseif v_2 == "slot_pose" then
			local var_30_18 = arg_30_1[v_2]
			local flag = not var_30_18 and get_interface:get_backend_id_from_unlocked_weapon_poses(var_30_18)

			var_30_15 = not flag and get_interface:get_item_from_id(flag)
		else
			var_30_15 = BackendUtils.get_loadout_item(name, v_2)
		end

		if not var_30_15 then
			content_2[v_2].item = var_30_15

			local var_30_20 = content_2[v_2]
			local inventory_icon = var_30_15.data.inventory_icon

			inventory_icon = inventory_icon or var_30_15.data.hud_icon
			var_30_20.icon = inventory_icon
			content_2[v_2].profile_index = self._profile_index
			content_2[v_2].career_index = self._career_index
			content_2[v_2].rarity = UISettings.item_rarity_textures[var_30_15.rarity]
			var_30_14 = var_30_14 or {}
			var_30_14[#var_30_14 + 1] = content_2[v_2]
		else
			Application.warning(string.format("[HeroWindowLoadoutSelectionConsole] Missing %q for loadout_index: %q", v_2, arg_30_2))
		end
	end

	self._gamepad_loadout_grid[#self._gamepad_loadout_grid + 1] = var_30_14

	local get_interface_2 = Managers.backend:get_interface("talents")
	local var_30_23 = get_interface_2:get_career_talents(name)[arg_30_2]
	local get_career_talent_ids = get_interface_2:get_career_talent_ids(name, arg_30_2)
	local content_3 = self._widgets_by_name.talents.content
	local var_30_26
	local num = 1

	for i4 = 1, MaxTalentPoints do
		local var_30_28 = content_3["talent_" .. i4]

		if var_30_23[i4] ~= 0 then
			local var_30_29 = get_career_talent_ids[num]
			local get_talent_by_id = TalentUtils.get_talent_by_id(display_name, var_30_29)
			local flag_2 = not get_talent_by_id and get_talent_by_id.icon

			if not flag_2 then
				get_talent_by_id = nil
			end

			var_30_28.icon = flag_2
			var_30_28.talent = get_talent_by_id
			num = num + 1

			if not get_talent_by_id then
				var_30_26 = var_30_26 or {}
				var_30_26[#var_30_26 + 1] = var_30_28
			end
		else
			var_30_28.talent = nil
		end
	end

	self._gamepad_loadout_grid[#self._gamepad_loadout_grid + 1] = var_30_26

	local content_4 = self._widgets_by_name.equipment.content
	local var_30_33

	for i_3, v_3 in ipairs(equipment_slots) do
		local var_30_34

		if not arg_30_1 then
			local var_30_35 = arg_30_1[v_3]

			var_30_34 = get_interface:get_item_from_id(var_30_35)
		else
			var_30_34 = BackendUtils.get_loadout_item(name, v_3)
		end

		local get_ui_information_from_item, var_30_37, var_30_38 = UIUtils.get_ui_information_from_item(var_30_34)

		content_4[v_3].item = var_30_34
		content_4[v_3].rarity = UISettings.item_rarity_textures[var_30_34.rarity]
		content_4[v_3].icon = get_ui_information_from_item
		content_4[v_3].profile_index = self._profile_index
		content_4[v_3].career_index = self._career_index
		var_30_33 = var_30_33 or {}
		var_30_33[#var_30_33 + 1] = content_4[v_3]
	end

	self._gamepad_loadout_grid[#self._gamepad_loadout_grid + 1] = var_30_33

	local loadout_selection = PlayerData.loadout_selection

	loadout_selection = not loadout_selection and PlayerData.loadout_selection.bot_equipment

	local var_30_40
	local flag_3 = not loadout_selection and loadout_selection[name]

	if not flag_3 then
		var_30_40 = flag_3 == arg_30_2
	else
		var_30_40 = arg_30_2 == self._selected_loadout_index
	end

	local content_5 = self._widgets_by_name.bot_checkbox.content

	content_5.button_hotspot.is_selected = var_30_40
	content_5.button_hotspot.disable_button = var_30_40
end

HeroWindowLoadoutSelectionConsole._change_loadout = function (self, arg_31_1)
	-- function 31
	if not (not arg_31_1 and arg_31_1 == self._selected_loadout_index) then
		local name = SPProfiles[self._profile_index].careers[self._career_index].name
		local get_interface = Managers.backend:get_interface("items")

		get_interface:set_loadout_index(name, arg_31_1)

		local get_selected_career_loadout = get_interface:get_selected_career_loadout(name)

		if get_selected_career_loadout > self._num_loadouts then
			get_selected_career_loadout = 1
		end

		self._selected_loadout_index = get_selected_career_loadout

		local loadout_frame = self._widgets_by_name.loadout_frame
		local offset = self._loadout_button_widgets[arg_31_1].offset

		loadout_frame.offset = table.clone(offset)

		self._parent:update_full_loadout()
		self:_play_sound("Play_gui_loadout_select")
		self:_hide_context_menu()
		self._parent:set_loadout_dirty()
	end
end

HeroWindowLoadoutSelectionConsole._add_loadout = function (self)
	-- function 32
	if #self._loadout_button_widgets >= self._num_loadouts + 1 then
		local name = SPProfiles[self._profile_index].careers[self._career_index].name

		Managers.backend:get_interface("items"):add_loadout(name)
		self:_play_sound("Play_gui_loadout_add")
		self._parent:update_full_loadout()
		self:_populate_loadout_buttons()
	end
end

HeroWindowLoadoutSelectionConsole.set_focus = function (self, arg_33_1)
	-- function 33
	self._focused = arg_33_1
end

HeroWindowLoadoutSelectionConsole._exit = function (self)
	-- function 34
	self.exit = true
end

HeroWindowLoadoutSelectionConsole._draw = function (self, arg_35_1)
	-- function 35
	local _ui_renderer = self._ui_renderer
	local _ui_top_renderer = self._ui_top_renderer
	local _ui_scenegraph = self._ui_scenegraph
	local _get_input_service = self:_get_input_service()
	local is_device_active = Managers.input:is_device_active("gamepad")

	UIRenderer.begin_pass(_ui_top_renderer, _ui_scenegraph, _get_input_service, arg_35_1, nil, self._render_settings)

	for i, v in ipairs(self._widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v)
	end

	for i_2, v_2 in ipairs(self._loadout_button_widgets) do
		UIRenderer.draw_widget(_ui_top_renderer, v_2)
	end

	if not self._context_menu_active then
		for i_3, v_3 in ipairs(self._context_menu_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_3)
		end
	end

	if not is_device_active and self._context_menu_active and not self._on_add_loadout_button then
		for i_4, v_4 in ipairs(self._gamepad_specific_widgets) do
			UIRenderer.draw_widget(_ui_top_renderer, v_4)
		end
	end

	UIRenderer.end_pass(_ui_top_renderer)

	if not is_device_active and self._context_menu_active and not self._on_add_loadout_button then
		self._menu_input_description:draw(_ui_top_renderer, arg_35_1)
	end
end

HeroWindowLoadoutSelectionConsole._play_sound = function (self, arg_36_1)
	-- function 36
	self._parent:play_sound(arg_36_1)
end
