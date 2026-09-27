-- chunkname: @scripts/ui/views/hero_view/states/hero_view_state_overview.lua

require("scripts/ui/views/hero_view/windows/hero_window_prestige")
require("scripts/ui/views/hero_view/windows/hero_window_talents")
require("scripts/ui/views/hero_view/windows/hero_window_talents_console")
require("scripts/ui/views/hero_view/windows/hero_window_options")
require("scripts/ui/views/hero_view/windows/hero_window_crafting")
require("scripts/ui/views/hero_view/windows/hero_window_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_inventory")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout")
require("scripts/ui/views/hero_view/windows/hero_window_loadout")
require("scripts/ui/views/hero_view/windows/hero_window_background_console")
require("scripts/ui/views/hero_view/windows/hero_window_panel_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_console")
require("scripts/ui/views/hero_view/windows/hero_window_character_info")
require("scripts/ui/views/hero_view/windows/hero_window_character_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_list_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_console")
require("scripts/ui/views/hero_view/windows/hero_window_crafting_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_hero_power_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_loadout_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_cosmetics_loadout_pose_inventory_console")
require("scripts/ui/views/hero_view/windows/hero_window_dark_pact_character_selection_console")
require("scripts/ui/views/hero_view/windows/hero_window_ingame_view")
require("scripts/ui/views/hero_view/windows/hero_window_character_preview")
require("scripts/ui/views/hero_view/windows/hero_window_item_customization")
require("scripts/ui/views/hero_view/windows/hero_window_character_summary")
DLCUtils.require_list("hero_view_windows")

local var_0_0 = local_require("scripts/ui/views/hero_view/states/definitions/hero_view_state_overview_definitions")
local widgets = var_0_0.widgets
local scenegraph_definition = var_0_0.scenegraph_definition
local animation_definitions = var_0_0.animation_definitions
local flag = false
local tbl = {
	common = 2,
	plentiful = 1,
	exotic = 4,
	rare = 3,
	unique = 5
}
local testify = script_data.testify

testify = not testify and require("scripts/ui/views/hero_view/states/hero_view_state_overview_testify")
HeroViewStateOverview = class(HeroViewStateOverview)
HeroViewStateOverview.NAME = "HeroViewStateOverview"

HeroViewStateOverview.on_enter = function (self, arg_1_1)
	-- function 1
	print("[HeroViewState] Enter Substate HeroViewStateOverview")

	self.parent = arg_1_1.parent
	self._gamepad_style_active = self:_setup_menu_layout(arg_1_1)

	local ingame_ui_context = arg_1_1.ingame_ui_context

	self.ingame_ui_context = ingame_ui_context
	self.ui_renderer = ingame_ui_context.ui_renderer
	self.ui_top_renderer = ingame_ui_context.ui_top_renderer
	self.input_manager = ingame_ui_context.input_manager
	self.voting_manager = ingame_ui_context.voting_manager
	self.profile_synchronizer = ingame_ui_context.profile_synchronizer
	self.statistics_db = ingame_ui_context.statistics_db
	self.render_settings = {
		snap_pixel_positions = true
	}
	self.wwise_world = arg_1_1.wwise_world
	self.ingame_ui = ingame_ui_context.ingame_ui
	self.is_in_inn = ingame_ui_context.is_in_inn
	self.force_ingame_menu = arg_1_1.state_params.force_ingame_menu
	self.world_previewer = arg_1_1.world_previewer
	self.platform = PLATFORM

	local player = Managers.player
	local local_player = player:local_player()

	self._stats_id = local_player:stats_id()
	self.player_manager = player
	self.peer_id = ingame_ui_context.peer_id
	self.local_player_id = ingame_ui_context.local_player_id
	self.player = local_player
	self.is_server = self.parent.is_server

	local profile_by_peer, var_1_4 = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

	self.profile_index = profile_by_peer or 1
	self.career_index = var_1_4 or 1
	self.hero_name = SPProfiles[self.profile_index].display_name
	self._animations = {}
	self._ui_animations = {}
	self.loadout_sync_id = 0
	self.inventory_sync_id = 0
	self.talent_sync_id = 0
	self.skin_sync_id = 0
	self.disabled_backend_ids_sync_id = 0
	self._disabled_backend_ids = {}
	self.character_pose_animation_sync_id = 0
	self._current_pose_animation_event = nil
	self.temporary_loadout_sync_id = 0
	self._temporary_loadout = {}

	if not IS_WINDOWS then
		self._friends_component_ui = FriendsUIComponent:new(ingame_ui_context)
	end

	self:create_ui_elements(arg_1_1)

	if not arg_1_1.initial_state then
		arg_1_1.initial_state = nil

		self:_start_transition_animation("on_enter", "on_enter")
	end

	local tbl = {
		wwise_world = self.wwise_world,
		ingame_ui_context = ingame_ui_context,
		parent = self,
		windows_settings = self._windows_settings,
		input_service = FAKE_INPUT_SERVICE,
		hero_name = self.hero_name,
		career_index = self.career_index,
		profile_index = self.profile_index,
		start_state = arg_1_1.start_state,
		force_ingame_menu = self.force_ingame_menu
	}

	self:_initial_windows_setups(tbl)

	if not self._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_enter()

		if not (not self.is_in_inn and self.force_ingame_menu) then
			self:play_sound("play_gui_amb_hero_screen_loop_begin")
			self:disable_player_world()
		else
			self:enable_ingame_overlay()
		end
	end
end

HeroViewStateOverview._setup_menu_layout = function (self, arg_2_1)
	-- function 2
	local IS_CONSOLE = IS_CONSOLE

	if not IS_CONSOLE then
		IS_CONSOLE = Managers.input:is_device_active("gamepad")
		IS_CONSOLE = (IS_CONSOLE or not UISettings.use_pc_menu_layout) and arg_2_1.state_params.force_ingame_menu
	end

	if not IS_CONSOLE then
		self._layout_settings = local_require("scripts/ui/views/hero_view/states/hero_window_layout_console")
	else
		self._layout_settings = local_require("scripts/ui/views/hero_view/states/hero_window_layout")
	end

	self._windows_settings = self._layout_settings.windows
	self._window_layouts = self._layout_settings.window_layouts
	self._max_active_windows = self._layout_settings.max_active_windows

	return IS_CONSOLE
end

HeroViewStateOverview.can_add = function (self, arg_3_1)
	-- function 3
	if not Managers.ui:is_ui_layout_disabled(arg_3_1) then
		return false
	end

	local find_by_key, var_3_1 = table.find_by_key(self._window_layouts, "name", arg_3_1)

	if not var_3_1 and not var_3_1.can_add_function then
		local current_mechanism_name = Managers.mechanism:current_mechanism_name()

		return var_3_1.can_add_function(current_mechanism_name)
	end

	return true
end

HeroViewStateOverview.create_ui_elements = function (self, arg_4_1)
	-- function 4
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)

	local tbl = {}
	local tbl_2 = {}

	for k, v in pairs(widgets) do
		if not v then
			local var_4_2 = UIWidget.init(v)

			tbl[#tbl + 1] = var_4_2
			tbl_2[k] = var_4_2
		end
	end

	self._widgets = tbl
	self._widgets_by_name = tbl_2

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, animation_definitions)
end

HeroViewStateOverview.disable_player_world = function (self)
	-- function 5
	if not self._player_world_disabled then
		self._player_world_disabled = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

HeroViewStateOverview.enable_player_world = function (self)
	-- function 6
	if not self._player_world_disabled then
		self._player_world_disabled = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

HeroViewStateOverview.enable_ingame_overlay = function (self)
	-- function 7
	if not self._ingame_overlay_enabled then
		self._ingame_overlay_enabled = true

		local world = Managers.world:world("level_world")

		World.set_data(world, "fullscreen_blur", 0.5)
		World.set_data(world, "greyscale", 1)
		Managers.state.event:trigger("ingame_menu_opened", "interacting")
	end
end

HeroViewStateOverview.disable_ingame_overlay = function (self)
	-- function 8
	if not self._ingame_overlay_enabled then
		self._ingame_overlay_enabled = false

		local world = Managers.world:world("level_world")

		World.set_data(world, "fullscreen_blur", nil)
		World.set_data(world, "greyscale", nil)
		Managers.state.event:trigger("ingame_menu_closed")
	end
end

HeroViewStateOverview._initial_windows_setups = function (self, arg_9_1)
	-- function 9
	self._active_windows = {}
	self._window_params = arg_9_1

	local start_state = arg_9_1.start_state

	if not start_state then
		self:set_layout_by_name(start_state)
	else
		self:set_layout(1)
	end
end

HeroViewStateOverview.window_input_service = function (self)
	-- function 10
	local FAKE_INPUT_SERVICE

	if not self._input_blocked then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_10_0::

	return FAKE_INPUT_SERVICE
end

HeroViewStateOverview.change_profile = function (self, arg_11_1, arg_11_2)
	-- function 11
	self.profile_index = arg_11_1
	self.hero_name = SPProfiles[arg_11_1].display_name
	self.career_index = arg_11_2
	self._window_params.hero_name = self.hero_name
	self._window_params.profile_index = self.profile_index
	self._window_params.career_index = self.career_index
end

HeroViewStateOverview.currently_selected_profile = function (self)
	-- function 12
	return self.profile_index, self.career_index, self.hero_name
end

HeroViewStateOverview._close_window_at_index = function (self, arg_13_1)
	-- function 13
	local _active_windows = self._active_windows
	local _window_params = self._window_params
	local var_13_2 = _active_windows[arg_13_1]

	if not var_13_2 and not var_13_2.on_exit then
		var_13_2:on_exit(_window_params)
	end

	_active_windows[arg_13_1] = nil
end

HeroViewStateOverview._change_window = function (self, arg_14_1, arg_14_2)
	-- function 14
	local _active_windows = self._active_windows
	local var_14_1 = self._windows_settings[arg_14_2]
	local class_name = var_14_1.class_name
	local var_14_3 = _active_windows[arg_14_1]

	if not var_14_3 then
		if var_14_3.NAME == class_name then
			return
		end

		self:_close_window_at_index(arg_14_1)
	end

	local var_14_4 = rawget(_G, class_name):new()
	local ignore_alignment = var_14_1.ignore_alignment
	local var_14_6

	if not ignore_alignment then
		local alignment_index = var_14_1.alignment_index

		alignment_index = alignment_index or arg_14_1

		local game_start_windows = UISettings.game_start_windows
		local size = game_start_windows.size
		local spacing = game_start_windows.spacing

		spacing = spacing or 10

		local var_14_11 = size[1]
		local num = spacing * 2
		local num_2 = -(3 * var_14_11 / 2 + var_14_11 / 2) - (num / 2 + spacing) + alignment_index * var_14_11 + alignment_index * spacing

		var_14_6 = {
			num_2,
			0,
			3
		}
	end

	if not var_14_4.on_enter then
		local _window_params = self._window_params

		var_14_4:on_enter(_window_params, var_14_6)
	end

	_active_windows[arg_14_1] = var_14_4
end

HeroViewStateOverview.get_selected_layout_name = function (self)
	-- function 15
	return self:get_layout_name()
end

HeroViewStateOverview.get_layout_name = function (self)
	-- function 16
	local _selected_game_mode_index = self._selected_game_mode_index

	for i, v in ipairs(self._window_layouts) do
		if i == _selected_game_mode_index then
			return v.name
		end
	end
end

HeroViewStateOverview.set_layout_by_name = function (self, arg_17_1)
	-- function 17
	local find_by_key = table.find_by_key(self._window_layouts, "name", arg_17_1)

	if not find_by_key then
		self:set_layout(find_by_key)
	end
end

HeroViewStateOverview.close_on_exit = function (self)
	-- function 18
	return self._close_on_exit
end

HeroViewStateOverview.set_layout = function (self, arg_19_1)
	-- function 19
	self._wanted_layout_index = arg_19_1
end

HeroViewStateOverview._update_set_layout = function (self)
	-- function 20
	local _wanted_layout_index = self._wanted_layout_index

	if not _wanted_layout_index then
		return
	end

	self._wanted_layout_index = nil

	local _get_layout_setting = self:_get_layout_setting(_wanted_layout_index)
	local windows = _get_layout_setting.windows
	local sound_event_enter = _get_layout_setting.sound_event_enter
	local close_on_exit = _get_layout_setting.close_on_exit
	local input_focus_window = _get_layout_setting.input_focus_window

	if not sound_event_enter then
		self:play_sound(sound_event_enter)
	end

	self._widgets_by_name.exit_button.content.visible = close_on_exit
	self._widgets_by_name.back_button.content.visible = not close_on_exit
	self._close_on_exit = close_on_exit

	for i = 1, self._max_active_windows do
		local flag = false

		for k, v in pairs(windows) do
			if v == i then
				self:_change_window(v, k)

				flag = true
			end
		end

		if not flag then
			self:_close_window_at_index(i)
		end
	end

	local _get_layout_setting_2 = self:_get_layout_setting(self._selected_game_mode_index)

	if not self._selected_game_mode_index and not _get_layout_setting_2.close_on_exit then
		self._previous_selected_game_mode_index = self._selected_game_mode_index
	end

	self._selected_game_mode_index = _wanted_layout_index

	self:set_window_input_focus(input_focus_window)
end

HeroViewStateOverview.set_window_input_focus = function (self, arg_21_1)
	-- function 21
	local _selected_game_mode_index = self._selected_game_mode_index
	local _get_layout_setting = self:_get_layout_setting(_selected_game_mode_index)
	local var_21_2 = self._windows_settings[arg_21_1]
	local flag = not var_21_2 and var_21_2.class_name
	local flag_2 = false
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		local flag_3 = v.NAME == flag

		if not v.set_focus then
			v:set_focus(flag_3)
		end

		if not flag_3 then
			flag_2 = true
		end
	end

	if not (not arg_21_1 and flag_2) then
		ferror("[HeroViewStateOverview] - (set_window_input_focus) Could not find a window by name: %s", arg_21_1)
	end

	self._window_focused = arg_21_1
end

HeroViewStateOverview.get_selected_game_mode_index = function (self)
	-- function 22
	return self._selected_game_mode_index
end

HeroViewStateOverview.get_previous_selected_game_mode_index = function (self)
	-- function 23
	return self._previous_selected_game_mode_index
end

HeroViewStateOverview._get_layout_setting = function (self, arg_24_1)
	-- function 24
	return self._window_layouts[arg_24_1]
end

HeroViewStateOverview.get_layout_setting_by_name = function (self, arg_25_1)
	-- function 25
	local _window_layouts = self._window_layouts

	for i = 1, #_window_layouts do
		local var_25_1 = _window_layouts[i]

		if arg_25_1 == var_25_1.name then
			return var_25_1
		end
	end
end

HeroViewStateOverview.get_layout_setting_by_name = function (self, arg_26_1)
	-- function 26
	local _window_layouts = self._window_layouts

	for i = 1, #_window_layouts do
		local var_26_1 = _window_layouts[i]

		if arg_26_1 == var_26_1.name then
			return var_26_1
		end
	end
end

HeroViewStateOverview._windows_update = function (self, arg_27_1, arg_27_2)
	-- function 27
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		v:update(arg_27_1, arg_27_2)
	end
end

HeroViewStateOverview._windows_post_update = function (self, arg_28_1, arg_28_2)
	-- function 28
	local _active_windows = self._active_windows

	for k, v in pairs(_active_windows) do
		if not v.post_update then
			v:post_update(arg_28_1, arg_28_2)
		end
	end
end

HeroViewStateOverview.enable_widget = function (self, arg_29_1, arg_29_2, arg_29_3)
	-- function 29
	local var_29_0 = self._active_windows[arg_29_1]._widgets_by_name[arg_29_2]

	if not var_29_0 then
		local button_hotspot = var_29_0.content.button_hotspot

		if not button_hotspot then
			button_hotspot.disable_button = not arg_29_3
		end
	end
end

HeroViewStateOverview.transitioning = function (self)
	-- function 30
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroViewStateOverview._wanted_state = function (self)
	-- function 31
	return (self.parent:wanted_state())
end

HeroViewStateOverview.wanted_menu_state = function (self)
	-- function 32
	return self._wanted_menu_state
end

HeroViewStateOverview.clear_wanted_menu_state = function (self)
	-- function 33
	self._wanted_menu_state = nil
end

HeroViewStateOverview.requested_screen_change_by_name = function (self, arg_34_1)
	-- function 34
	self._on_close_next_state = arg_34_1

	self:close_menu()
end

HeroViewStateOverview.on_exit = function (self, arg_35_1)
	-- function 35
	print("[HeroViewState] Exit Substate HeroViewStateOverview")

	self.ui_animator = nil

	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui and not self:is_friends_list_active() then
		_friends_component_ui:deactivate_friends_ui()
	end

	if not self._fullscreen_effect_enabled then
		self:set_fullscreen_effect_enable_state(false)
	end

	self:_close_active_windows()

	if not self._gamepad_style_active then
		UISettings.hero_fullscreen_menu_on_exit()

		if not (not self.is_in_inn and self.force_ingame_menu) then
			self:play_sound("play_gui_amb_hero_screen_loop_end")
			self:enable_player_world()
		else
			self:disable_ingame_overlay()
		end
	end

	local local_player = Managers.player:local_player()

	if not (not local_player and local_player:career_name() ~= "bw_necromancer") then
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", true)
	else
		GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", false)
	end
end

HeroViewStateOverview._close_active_windows = function (self)
	-- function 36
	local _active_windows = self._active_windows
	local _window_params = self._window_params

	for k, v in pairs(_active_windows) do
		if not v.on_exit then
			v:on_exit(_window_params)
		end
	end

	table.clear(_active_windows)
end

HeroViewStateOverview._update_transition_timer = function (self, arg_37_1)
	-- function 37
	if not self._transition_timer then
		return
	end

	if self._transition_timer == 0 then
		self._transition_timer = nil
	else
		self._transition_timer = math.max(self._transition_timer - arg_37_1, 0)
	end
end

HeroViewStateOverview.input_service = function (self)
	-- function 38
	return self.parent:input_service()
end

HeroViewStateOverview.update = function (self, arg_39_1, arg_39_2)
	-- function 39
	if not flag then
		flag = false

		self:create_ui_elements()
	end

	self:_update_set_layout()

	local input_manager = self.input_manager
	local window_input_service = self:window_input_service()
	local _friends_component_ui = self._friends_component_ui
	local is_device_active = input_manager:is_device_active("gamepad")

	if not _friends_component_ui and is_device_active or not Managers.account:is_online() then
		_friends_component_ui:update(arg_39_1, window_input_service)
	end

	if not self._gamepad_style_active then
		self:draw(window_input_service, arg_39_1)
	end

	self:_update_transition_timer(arg_39_1)
	self:_windows_update(arg_39_1, arg_39_2)

	if not script_data.testify then
		Testify:poll_requests_through_handler(testify, self)
	end

	local transitioning = self.parent:transitioning()
	local _wanted_state = self:_wanted_state()

	if not self._transition_timer then
		if not transitioning then
			if not self:_has_active_level_vote() then
				local flag_2 = true

				self:close_menu(flag_2)
			else
				self:_handle_input(arg_39_1, arg_39_2)
			end
		end

		if not _wanted_state then
			self.parent:clear_wanted_state()

			self._new_state = _wanted_state
		else
			return self._new_state
		end
	end
end

HeroViewStateOverview.is_friends_list_active = function (self)
	-- function 40
	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui then
		return _friends_component_ui:is_active()
	end

	return false
end

HeroViewStateOverview._handle_friend_joining = function (self)
	-- function 41
	local _friends_component_ui = self._friends_component_ui

	if not _friends_component_ui then
		local join_lobby_data = _friends_component_ui:join_lobby_data()

		if not join_lobby_data and not Managers.matchmaking:allowed_to_initiate_join_lobby() then
			Managers.matchmaking:request_join_lobby(join_lobby_data, {
				friend_join = true
			})
			self:close_menu(true)

			return true
		end
	end
end

HeroViewStateOverview._has_active_level_vote = function (self)
	-- function 42
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

HeroViewStateOverview.post_update = function (self, arg_43_1, arg_43_2)
	-- function 43
	self.ui_animator:update(arg_43_1)
	self:_update_animations(arg_43_1)
	self:_windows_post_update(arg_43_1, arg_43_2)

	if not self._new_state then
		self:_close_active_windows()
	end

	local _equip_request = self._equip_request

	if not _equip_request then
		self._equip_request = nil

		local slot_type = _equip_request.slot_type
		local slot_name = _equip_request.slot_name
		local backend_id = _equip_request.backend_id
		local unit = _equip_request.unit

		if not (slot_type == "melee" or slot_type ~= "ranged") then
			ScriptUnit.extension(unit, "inventory_system"):create_equipment_in_slot(slot_name, backend_id)
		elseif not (slot_type == "hat" or slot_type == "trinket" or slot_type == "ring" or slot_type ~= "necklace") then
			ScriptUnit.extension(unit, "attachment_system"):create_attachment_in_slot(slot_name, backend_id)
		end
	end
end

HeroViewStateOverview._update_animations = function (self, arg_44_1)
	-- function 44
	for k, v in pairs(self._ui_animations) do
		UIAnimation.update(v, arg_44_1)

		if not UIAnimation.completed(v) then
			self._ui_animations[k] = nil
		end
	end

	local _animations = self._animations
	local ui_animator = self.ui_animator

	for k_2, v_2 in pairs(_animations) do
		if not ui_animator:is_animation_completed(v_2) then
			ui_animator:stop_animation(v_2)

			_animations[k_2] = nil
		end
	end
end

HeroViewStateOverview._is_button_hover_enter = function (arg_45_0, arg_45_1)
	-- function 45
	return arg_45_1.content.button_hotspot.on_hover_enter
end

HeroViewStateOverview._handle_input = function (self, arg_46_1, arg_46_2)
	-- function 46
	local _input_blocked = self._input_blocked
	local is_device_active = Managers.input:is_device_active("gamepad")
	local _input_paused = self._input_paused

	_input_paused = not _input_paused and is_device_active

	if _input_blocked or not _input_paused then
		return
	end

	if not self:_handle_friend_joining() then
		return
	end

	local _widgets_by_name = self._widgets_by_name
	local input_service = self.parent:input_service()
	local get = input_service:get("toggle_menu", true)
	local flag = not is_device_active and input_service:get("back_menu", true)
	local _close_on_exit = self._close_on_exit
	local exit_button = _widgets_by_name.exit_button
	local back_button = _widgets_by_name.back_button

	UIWidgetUtils.animate_default_button(exit_button, arg_46_1)
	UIWidgetUtils.animate_default_button(back_button, arg_46_1)

	if self:_is_button_hover_enter(back_button) or not self:_is_button_hover_enter(exit_button) then
		self:play_sound("play_gui_equipment_button_hover")
	end

	if not _close_on_exit and flag and get and not self:_is_button_pressed(exit_button) then
		self:play_sound("Play_hud_hover")
		self:close_menu()

		return
	elseif get or flag or not self:_is_button_pressed(back_button) then
		self:play_sound("Play_hud_hover")

		local get_previous_selected_game_mode_index = self:get_previous_selected_game_mode_index()

		if not get_previous_selected_game_mode_index then
			self:set_layout(get_previous_selected_game_mode_index)
		end
	end
end

HeroViewStateOverview.close_menu = function (self, arg_47_1)
	-- function 47
	if not self._on_close_next_state then
		self.parent:requested_screen_change_by_name(self._on_close_next_state)
	else
		self.parent:close_menu(nil, arg_47_1)
	end
end

HeroViewStateOverview.draw = function (self, arg_48_1, arg_48_2)
	-- function 48
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local input_manager = self.input_manager
	local render_settings = self.render_settings
	local is_device_active = input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_48_1, arg_48_2, nil, render_settings)

	local snap_pixel_positions = render_settings.snap_pixel_positions

	for i, v in ipairs(self._widgets) do
		if v.snap_pixel_positions ~= nil then
			render_settings.snap_pixel_positions = v.snap_pixel_positions
		end

		UIRenderer.draw_widget(ui_renderer, v)

		render_settings.snap_pixel_positions = snap_pixel_positions
	end

	UIRenderer.end_pass(ui_renderer)
end

HeroViewStateOverview._is_button_pressed = function (arg_49_0, arg_49_1)
	-- function 49
	local content = arg_49_1.content
	local button_hotspot = content.button_hotspot

	button_hotspot = button_hotspot or content.hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroViewStateOverview.play_sound = function (self, arg_50_1)
	-- function 50
	self.parent:play_sound(arg_50_1)
end

HeroViewStateOverview._start_transition_animation = function (self, arg_51_1, arg_51_2)
	-- function 51
	local tbl = {
		wwise_world = self.wwise_world,
		render_settings = self.render_settings
	}
	local tbl_2 = {}
	local start_animation = self.ui_animator:start_animation(arg_51_2, tbl_2, scenegraph_definition, tbl)

	self._animations[arg_51_1] = start_animation
end

HeroViewStateOverview.set_auto_fill_rarity = function (self, arg_52_1)
	-- function 52
	self._auto_fill_rarity = arg_52_1
end

HeroViewStateOverview.get_auto_fill_rarity = function (self)
	-- function 53
	local _auto_fill_rarity = self._auto_fill_rarity

	self._auto_fill_rarity = nil

	return _auto_fill_rarity
end

HeroViewStateOverview.set_filter_selected = function (self, arg_54_1)
	-- function 54
	self._filter_selected = arg_54_1
end

HeroViewStateOverview.filter_selected = function (self)
	-- function 55
	return self._filter_selected
end

HeroViewStateOverview.set_filter_active = function (self, arg_56_1)
	-- function 56
	self._filter_active = arg_56_1
end

HeroViewStateOverview.filter_active = function (self)
	-- function 57
	return self._filter_active
end

HeroViewStateOverview.reset_filter = function (self)
	-- function 58
	self._filter_reset = true
end

HeroViewStateOverview.filter_reset = function (self)
	-- function 59
	local _filter_reset = self._filter_reset

	self._filter_reset = nil

	return _filter_reset
end

HeroViewStateOverview.disable_filter = function (self, arg_60_1)
	-- function 60
	self._filter_disabled = arg_60_1
end

HeroViewStateOverview.disable_search = function (self, arg_61_1)
	-- function 61
	self._search_disabled = arg_61_1
end

HeroViewStateOverview.filter_search_disabled = function (self)
	-- function 62
	return self._filter_disabled, self._search_disabled
end

HeroViewStateOverview.set_selected_items_backend_ids = function (self, arg_63_1)
	-- function 63
	self._selected_items_backend_ids = arg_63_1
end

HeroViewStateOverview.get_selected_items_backend_ids = function (self)
	-- function 64
	return self._selected_items_backend_ids
end

HeroViewStateOverview.set_pressed_item_backend_id = function (self, arg_65_1, arg_65_2)
	-- function 65
	self._pressed_item_backend_id = arg_65_1
	self._pressed_item_by_drag = not arg_65_1 and arg_65_2 and nil
end

HeroViewStateOverview.get_disabled_backend_ids = function (self)
	-- function 66
	return self._disabled_backend_ids
end

HeroViewStateOverview.clear_disabled_backend_ids = function (self)
	-- function 67
	self._disabled_backend_ids = {}
	self.disabled_backend_ids_sync_id = self.disabled_backend_ids_sync_id + 1
end

HeroViewStateOverview.disabled_item_icon = function (self)
	-- function 68
	return self._disabled_item_icon
end

HeroViewStateOverview.set_disabled_item_icon = function (self, arg_69_1)
	-- function 69
	self._disabled_item_icon = arg_69_1
end

HeroViewStateOverview.set_disabled_backend_id = function (self, arg_70_1, arg_70_2)
	-- function 70
	if not arg_70_2 then
		self._disabled_backend_ids[arg_70_1] = true
	else
		self._disabled_backend_ids[arg_70_1] = nil
	end

	self.disabled_backend_ids_sync_id = self.disabled_backend_ids_sync_id + 1
end

HeroViewStateOverview.get_pressed_item_backend_id = function (self)
	-- function 71
	return self._pressed_item_backend_id, self._pressed_item_by_drag
end

HeroViewStateOverview.get_inventory_grid = function (self)
	-- function 72
	return self._current_inventory_grid
end

HeroViewStateOverview.set_inventory_grid = function (self, arg_73_1)
	-- function 73
	self._current_inventory_grid = arg_73_1
end

HeroViewStateOverview.set_fullscreen_effect_enable_state = function (self, arg_74_1)
	-- function 74
	local world = self.ui_renderer.world
	local get_data = World.get_data(world, "shading_environment")

	if not get_data then
		local set_scalar = ShadingEnvironment.set_scalar
		local var_74_3 = get_data
		local str = "fullscreen_blur_enabled"
		local flag

		flag = not arg_74_1 and 1 and 0

		set_scalar(var_74_3, str, flag)

		local set_scalar_2 = ShadingEnvironment.set_scalar
		local var_74_7 = get_data
		local str_2 = "fullscreen_blur_amount"
		local flag_2

		flag_2 = not arg_74_1 and 0.75 and 0

		set_scalar_2(var_74_7, str_2, flag_2)
		ShadingEnvironment.apply(get_data)
	end

	self._fullscreen_effect_enabled = arg_74_1
end

HeroViewStateOverview.block_input = function (self)
	-- function 75
	self._input_blocked = true
end

HeroViewStateOverview.unblock_input = function (self)
	-- function 76
	self._input_blocked = false
end

HeroViewStateOverview.input_blocked = function (self)
	-- function 77
	return self._input_blocked
end

HeroViewStateOverview.set_selected_craft_page = function (self, arg_78_1)
	-- function 78
	self._selected_craft_page_name = arg_78_1
end

HeroViewStateOverview.get_selected_craft_page = function (self)
	-- function 79
	return self._selected_craft_page_name
end

HeroViewStateOverview.set_craft_optional_item_filter = function (self, arg_80_1)
	-- function 80
	self._craft_optional_item_filter = arg_80_1
end

HeroViewStateOverview.get_craft_optional_item_filter = function (self)
	-- function 81
	return self._craft_optional_item_filter
end

HeroViewStateOverview.set_selected_loadout_slot_index = function (self, arg_82_1)
	-- function 82
	self._selected_loadout_slot_index = arg_82_1
end

HeroViewStateOverview.get_selected_loadout_slot_index = function (self)
	-- function 83
	local _selected_loadout_slot_index = self._selected_loadout_slot_index

	_selected_loadout_slot_index = _selected_loadout_slot_index or 1

	return _selected_loadout_slot_index
end

HeroViewStateOverview.set_selected_cosmetic_slot_index = function (self, arg_84_1)
	-- function 84
	self._selected_cosmetic_slot_index = arg_84_1
end

HeroViewStateOverview.get_selected_cosmetic_slot_index = function (self)
	-- function 85
	local _selected_cosmetic_slot_index = self._selected_cosmetic_slot_index

	_selected_cosmetic_slot_index = _selected_cosmetic_slot_index or 1

	return _selected_cosmetic_slot_index
end

HeroViewStateOverview.set_temporary_loadout_item = function (self, arg_86_1, arg_86_2)
	-- function 86
	local slot_type = arg_86_1.data.slot_type

	self._temporary_loadout[slot_type] = arg_86_1
	self._skip_wield_anim = arg_86_2
	self.temporary_loadout_sync_id = self.temporary_loadout_sync_id + 1
	self.character_pose_animation_sync_id = self.character_pose_animation_sync_id + 1
end

HeroViewStateOverview.clear_temporary_loadout = function (self)
	-- function 87
	table.clear(self._temporary_loadout)

	self._skip_wield_anim = nil
	self.loadout_sync_id = self.loadout_sync_id + 1
end

HeroViewStateOverview.get_temporary_loadout_item = function (self, arg_88_1)
	-- function 88
	return self._temporary_loadout[arg_88_1], self._skip_wield_anim
end

HeroViewStateOverview.set_character_pose_animation = function (self, arg_89_1)
	-- function 89
	self._current_pose_animation_event = arg_89_1
	self.character_pose_animation_sync_id = self.character_pose_animation_sync_id + 1
end

local tbl_2 = {}

HeroViewStateOverview.clear_character_animation = function (self, arg_90_1)
	-- function 90
	self._current_pose_animation_event = nil

	local get_interface = Managers.backend:get_interface("items")
	local hero_name = self.hero_name
	local career_index = self.career_index
	local var_90_3 = FindProfileIndex(hero_name)
	local name = SPProfiles[var_90_3].careers[career_index].name
	local get_loadout_item_id = get_interface:get_loadout_item_id(name, "slot_pose")
	local var_90_6 = get_interface:get_unlocked_weapon_poses()[arg_90_1]

	var_90_6 = var_90_6 or tbl_2

	if not table.find(var_90_6, get_loadout_item_id) then
		self._current_pose_animation_event = get_interface:get_item_from_id(get_loadout_item_id).data.data.anim_event
	else
		self._current_pose_animation_event = nil
	end

	self.character_pose_animation_sync_id = self.character_pose_animation_sync_id + 1
end

HeroViewStateOverview.get_character_animation_event = function (self)
	-- function 91
	return self._current_pose_animation_event
end

HeroViewStateOverview._set_loadout_item = function (self, arg_92_1, arg_92_2)
	-- function 92
	local hero_name = self.hero_name
	local career_index = self.career_index
	local player_manager = self.player_manager
	local peer_id = self.peer_id
	local player_unit = player_manager:player_from_peer_id(peer_id).player_unit

	if not (not player_unit and Unit.alive(player_unit)) then
		return
	end

	if not Managers.state.network:game() then
		return
	end

	if not LoadoutUtils.is_item_disabled(arg_92_1.ItemId) then
		return
	end

	local backend_id = arg_92_1.backend_id
	local data = arg_92_1.data
	local var_92_7
	local var_92_8

	if not arg_92_2 then
		var_92_7 = InventorySettings.slots_by_name[arg_92_2]
		var_92_8 = var_92_7.type
	else
		var_92_8 = data.slot_type
		var_92_7 = self:_get_slot_by_type(var_92_8)
	end

	local name = var_92_7.name
	local var_92_10 = FindProfileIndex(hero_name)
	local name_2 = SPProfiles[var_92_10].careers[career_index].name

	BackendUtils.set_loadout_item(backend_id, name_2, name)

	if not self:is_bot_career() then
		if not self.parent:is_loadout_dirty() then
			if var_92_8 == "frame" then
				Managers.state.entity:system("cosmetic_system"):set_equipped_frame(player_unit, data.key)
			elseif not (var_92_8 == "skin" or var_92_8 == "weapon_pose") then
				self._equip_request = {
					slot_type = var_92_8,
					slot_name = name,
					backend_id = backend_id,
					unit = player_unit
				}
			end
		end
	elseif var_92_8 == "hat" then
		self.skin_sync_id = self.skin_sync_id + 1
	end

	self.loadout_sync_id = self.loadout_sync_id + 1
	self.inventory_sync_id = self.inventory_sync_id + 1

	local get_persistent_stat = self.statistics_db:get_persistent_stat(self._stats_id, "highest_equipped_rarity", var_92_8)
	local var_92_13 = tbl[arg_92_1.rarity]

	if not (not var_92_13 and not (get_persistent_stat < var_92_13)) then
		self.statistics_db:set_stat(self._stats_id, "highest_equipped_rarity", var_92_8, var_92_13)
	end

	Managers.state.event:trigger("event_set_loadout_items")
end

HeroViewStateOverview.is_bot_career = function (self)
	-- function 93
	local local_player = Managers.player:local_player()
	local profile_index = local_player:profile_index()
	local career_index = local_player:career_index()

	return profile_index ~= self.profile_index or career_index ~= self.career_index, self.profile_index, self.career_index
end

HeroViewStateOverview.get_career_data = function (self)
	-- function 94
	return self.profile_index, self.career_index
end

HeroViewStateOverview.update_talent_sync = function (self)
	-- function 95
	self.talent_sync_id = self.talent_sync_id + 1
end

HeroViewStateOverview.update_skin_sync = function (self)
	-- function 96
	self.skin_sync_id = self.skin_sync_id + 1

	self.ingame_ui:respawn()
end

HeroViewStateOverview.unequip_item_in_slot = function (self, arg_97_1)
	-- function 97
	local hero_name = self.hero_name
	local career_index = self.career_index
	local _get_slot_by_type = self:_get_slot_by_type(arg_97_1)

	if not _get_slot_by_type.unequippable then
		return false
	end

	local name = _get_slot_by_type.name
	local slot_index = _get_slot_by_type.slot_index
	local var_97_5 = FindProfileIndex(hero_name)
	local name_2 = SPProfiles[var_97_5].careers[career_index].name

	if not BackendUtils.get_loadout_item(name_2, name) then
		return false
	end

	BackendUtils.set_loadout_item(nil, name_2, name)

	self.loadout_sync_id = self.loadout_sync_id + 1
	self.inventory_sync_id = self.inventory_sync_id + 1

	return true
end

HeroViewStateOverview.update_full_loadout = function (self)
	-- function 98
	self.loadout_sync_id = self.loadout_sync_id + 1
	self.inventory_sync_id = self.inventory_sync_id + 1
	self.talent_sync_id = self.talent_sync_id + 1
	self.skin_sync_id = self.skin_sync_id + 1
end

HeroViewStateOverview.update_inventory_items = function (self)
	-- function 99
	self.inventory_sync_id = self.inventory_sync_id + 1
end

HeroViewStateOverview._get_slot_by_type = function (arg_100_0, arg_100_1)
	-- function 100
	local slots_by_slot_index = InventorySettings.slots_by_slot_index

	for k, v in pairs(slots_by_slot_index) do
		if arg_100_1 == v.type then
			return v
		end
	end
end

HeroViewStateOverview.window_layout_on_exit = function (self, arg_101_1)
	-- function 101
	local get_layout_setting_by_name = self:get_layout_setting_by_name(arg_101_1)

	if not get_layout_setting_by_name and not get_layout_setting_by_name.on_exit then
		get_layout_setting_by_name.on_exit(self)
	end
end

HeroViewStateOverview.pause_input = function (self, arg_102_1)
	-- function 102
	self._input_paused = arg_102_1
end

HeroViewStateOverview.input_paused = function (self)
	-- function 103
	return self._input_paused
end

HeroViewStateOverview.set_background_mood = function (arg_104_0, arg_104_1)
	-- function 104
	local str = "character_preview"
	local world = Managers.world:world(str)

	World.set_data(world, "shading_settings", {
		arg_104_1,
		1
	})
end

HeroViewStateOverview.set_loadout_dirty = function (self)
	-- function 105
	self.parent:set_loadout_dirty()
end
