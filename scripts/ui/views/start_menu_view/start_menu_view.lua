-- chunkname: @scripts/ui/views/start_menu_view/start_menu_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/character_selection_view/states/character_selection_state_character")
require("scripts/ui/views/start_menu_view/states/start_menu_state_overview")
require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/start_menu_view/start_menu_view_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local settings_by_screen = var_0_0.settings_by_screen
local attachments = var_0_0.attachments
local flow_events = var_0_0.flow_events

local function fn(...)
	-- function 1
	print("[StartMenuView]", ...)
end

local flag = true
local flag_2 = false
local flag_3 = true

StartMenuView = class(StartMenuView)

StartMenuView.init = function (self, arg_2_1)
	-- function 2
	self.world = arg_2_1.world
	self.player_manager = arg_2_1.player_manager
	self.ui_renderer = arg_2_1.ui_renderer
	self.ui_top_renderer = arg_2_1.ui_top_renderer
	self.ingame_ui = arg_2_1.ingame_ui
	self.voting_manager = arg_2_1.voting_manager
	self.profile_synchronizer = arg_2_1.profile_synchronizer
	self.peer_id = arg_2_1.peer_id
	self.local_player_id = arg_2_1.local_player_id
	self.is_server = arg_2_1.is_server
	self.is_in_inn = arg_2_1.is_in_inn
	self.world_manager = arg_2_1.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	local input_manager = arg_2_1.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("start_menu_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("start_menu_view", "keyboard")
	input_manager:map_device_to_service("start_menu_view", "mouse")
	input_manager:map_device_to_service("start_menu_view", "gamepad")

	self.world_previewer = MenuWorldPreviewer:new(arg_2_1, UISettings.hero_selection_camera_position_by_character, "StartMenuView")

	self.world_previewer:force_stream_highest_mip_levels()

	self._state_machine_params = {
		wwise_world = self.wwise_world,
		ingame_ui_context = arg_2_1,
		parent = self,
		world_previewer = self.world_previewer,
		settings_by_screen = settings_by_screen,
		input_service = FAKE_INPUT_SERVICE
	}
	self.units = {}
	self.attachment_units = {}
	self.unit_states = {}
	self.ui_animations = {}
	self.ingame_ui_context = arg_2_1
	flag = false
end

StartMenuView.initial_profile_view = function (self)
	-- function 3
	return self.ingame_ui.initial_profile_view
end

StartMenuView._setup_state_machine = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local flag = arg_4_2 or StartMenuStateOverview
	local flag_2 = false

	arg_4_1.start_state = arg_4_3
	arg_4_1.state_params = arg_4_4
	self._machine = GameStateMachine:new(self, flag, arg_4_1, flag_2)
	self._state_machine_params = arg_4_1
	arg_4_1.state_params = nil
end

StartMenuView.wanted_state = function (self)
	-- function 5
	return self._wanted_state
end

StartMenuView.clear_wanted_state = function (self)
	-- function 6
	self._wanted_state = nil
end

StartMenuView.input_service = function (self, arg_7_1)
	-- function 7
	if not arg_7_1 then
		local _machine = self._machine

		if not _machine then
			return _machine:state():input_service()
		end
	end

	return self.input_manager:get_service("start_menu_view")
end

StartMenuView.set_input_blocked = function (self, arg_8_1)
	-- function 8
	self._input_blocked = arg_8_1
end

StartMenuView.input_blocked = function (self)
	-- function 9
	return self._input_blocked
end

StartMenuView.play_sound = function (self, arg_10_1)
	-- function 10
	WwiseWorld.trigger_event(self.wwise_world, arg_10_1)
end

StartMenuView.create_ui_elements = function (self)
	-- function 11
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._static_widgets = {}
	self._exit_button_widget = UIWidget.init(widgets_definitions.exit_button)
	self._console_cursor_widget = UIWidget.init(widgets_definitions.console_cursor)

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations)
end

StartMenuView.get_background_world = function (self)
	-- function 12
	local var_12_0 = self.viewport_widget.element.pass_data[1]
	local viewport = var_12_0.viewport

	return var_12_0.world, viewport
end

StartMenuView.show_hero_world = function (self)
	-- function 13
	if not self._draw_menu_world then
		self._draw_menu_world = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

StartMenuView.hide_hero_world = function (self)
	-- function 14
	if not self._draw_menu_world then
		self._draw_menu_world = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

StartMenuView.draw = function (self, arg_15_1, arg_15_2)
	-- function 15
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local initial_profile_view = self:initial_profile_view()

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_15_2, arg_15_1)

	if not flag_2 then
		UISceneGraph.debug_render_scenegraph(ui_top_renderer, ui_scenegraph)
	end

	if not initial_profile_view then
		UIRenderer.draw_widget(ui_top_renderer, self._exit_button_widget)
	end

	if not is_device_active then
		UIRenderer.draw_widget(ui_top_renderer, self._console_cursor_widget)
	end

	if not self.viewport_widget and not self._draw_menu_world then
		UIRenderer.draw_widget(ui_top_renderer, self.viewport_widget)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

StartMenuView.post_update = function (self, arg_16_1, arg_16_2)
	-- function 16
	self._machine:post_update(arg_16_1, arg_16_2)
	self.world_previewer:post_update(arg_16_1, arg_16_2)
end

StartMenuView._has_active_level_vote = function (self)
	-- function 17
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

StartMenuView.update = function (self, arg_18_1, arg_18_2)
	-- function 18
	if self.suspended or not self.waiting_for_post_update_enter then
		return
	end

	if not self:_has_active_level_vote() then
		self:close_menu(false)
	end

	local _requested_screen_change_data = self._requested_screen_change_data

	if not _requested_screen_change_data then
		local screen_name = _requested_screen_change_data.screen_name
		local sub_screen_name = _requested_screen_change_data.sub_screen_name

		self:_change_screen_by_name(screen_name, sub_screen_name)

		self._requested_screen_change_data = nil
	end

	local flag = true
	local input_manager = self.input_manager
	local is_device_active = input_manager:is_device_active("gamepad")
	local FAKE_INPUT_SERVICE

	if not (not self:input_blocked() and is_device_active) then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = input_manager:get_service("start_menu_view")

	::label_18_0::

	self._state_machine_params.input_service = FAKE_INPUT_SERVICE

	local transitioning = self:transitioning()

	self.ui_animator:update(arg_18_1)
	self.world_previewer:update(arg_18_1, arg_18_2)

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_18_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not transitioning then
		self:_handle_mouse_input(arg_18_1, arg_18_2, FAKE_INPUT_SERVICE)
		self:_handle_exit(FAKE_INPUT_SERVICE)
	end

	self._machine:update(arg_18_1, arg_18_2)
	self:draw(arg_18_1, FAKE_INPUT_SERVICE)
end

StartMenuView.on_enter = function (self, arg_19_1)
	-- function 19
	ShowCursorStack.show("StartMenuView")

	local input_manager = self.input_manager

	input_manager:block_device_except_service("start_menu_view", "keyboard", 1)
	input_manager:block_device_except_service("start_menu_view", "mouse", 1)
	input_manager:block_device_except_service("start_menu_view", "gamepad", 1)

	self._state_machine_params.initial_state = true

	self:create_ui_elements()

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

	if not profile_by_peer then
		self:set_current_hero(profile_by_peer)
	end

	self.waiting_for_post_update_enter = true
	self._on_enter_transition_params = arg_19_1

	Managers.music:duck_sounds()
	self:play_sound("play_gui_amb_start_screen_enter")
	self:play_sound("play_gui_amb_hero_screen_loop_begin")
	self:play_sound("Play_menu_screen_music")
	UISettings.hero_fullscreen_menu_on_enter()
end

StartMenuView.set_current_hero = function (self, arg_20_1)
	-- function 20
	local var_20_0 = SPProfiles[arg_20_1]
	local display_name = var_20_0.display_name
	local character_name = var_20_0.character_name

	self._hero_name = display_name
	self._state_machine_params.hero_name = display_name
end

StartMenuView._get_sorted_players = function (self)
	-- function 21
	local human_players = self.player_manager:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		tbl[#tbl + 1] = v
	end

	table.sort(tbl, function (self, arg_22_1)
		-- function 22
		local local_player = self.local_player

		local_player = not local_player and not arg_22_1.local_player

		return local_player
	end)

	return tbl
end

StartMenuView._handle_mouse_input = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	-- function 23
	return
end

StartMenuView._is_selection_widget_pressed = function (arg_24_0, arg_24_1)
	-- function 24
	local content = arg_24_1.content
	local steps = content.steps

	for i = 1, steps do
		if not content["hotspot_" .. i].on_release then
			return true, i
		end
	end
end

StartMenuView.hotkey_allowed = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not self:input_blocked() then
		return false
	end

	local transition_state = arg_25_2.transition_state
	local transition_sub_state = arg_25_2.transition_sub_state
	local _machine = self._machine

	if not _machine then
		local state = _machine:state()
		local NAME = state.NAME

		if self:_get_screen_settings_by_state_name(NAME).name == transition_state then
			local get_selected_layout_name = state.get_selected_layout_name

			get_selected_layout_name = not get_selected_layout_name and state:get_selected_layout_name()

			if not (not transition_sub_state and transition_sub_state ~= get_selected_layout_name) then
				return true
			elseif not transition_sub_state then
				state:requested_screen_change_by_name(transition_sub_state)
			end
		elseif not transition_state then
			self:requested_screen_change_by_name(transition_state, transition_sub_state)
		else
			return true
		end
	end

	return false
end

StartMenuView._get_screen_settings_by_state_name = function (arg_26_0, arg_26_1)
	-- function 26
	for i, v in ipairs(settings_by_screen) do
		if v.state_name == arg_26_1 then
			return v
		end
	end
end

StartMenuView.requested_screen_change_by_name = function (self, arg_27_1, arg_27_2)
	-- function 27
	self._requested_screen_change_data = {
		screen_name = arg_27_1,
		sub_screen_name = arg_27_2
	}
end

StartMenuView._change_screen_by_name = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	local var_28_0
	local var_28_1

	for i, v in ipairs(settings_by_screen) do
		if v.name == arg_28_1 then
			var_28_0 = v
			var_28_1 = i

			break
		end
	end

	fassert(var_28_1, "[StartMenuView] - Could not find state by name %s", arg_28_1)

	local state_name = var_28_0.state_name
	local var_28_3 = rawget(_G, state_name)

	if not (not self._machine and arg_28_2) then
		self._wanted_state = var_28_3
	else
		self:_setup_state_machine(self._state_machine_params, var_28_3, arg_28_2, arg_28_3)
	end

	if not var_28_0.draw_background_world then
		self:show_hero_world()
	else
		self:hide_hero_world()
	end

	local camera_position = var_28_0.camera_position

	if not camera_position then
		self.world_previewer:set_camera_axis_offset("x", camera_position[1], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_axis_offset("y", camera_position[2], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_axis_offset("z", camera_position[3], 0.5, math.easeOutCubic)
	end

	local camera_rotation = var_28_0.camera_rotation

	if not camera_rotation then
		self.world_previewer:set_camera_rotation_axis_offset("x", camera_rotation[1], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_rotation_axis_offset("y", camera_rotation[2], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_rotation_axis_offset("z", camera_rotation[3], 0.5, math.easeOutCubic)
	end
end

StartMenuView._change_screen_by_index = function (self, arg_29_1)
	-- function 29
	local name = settings_by_screen[arg_29_1].name

	self:_change_screen_by_name(name)
end

StartMenuView.post_update_on_enter = function (self)
	-- function 30
	assert(self.viewport_widget == nil)

	self.viewport_widget = UIWidget.init(widgets_definitions.viewport)
	self.waiting_for_post_update_enter = nil

	self.world_previewer:on_enter(self.viewport_widget, self._hero_name)

	local _on_enter_transition_params = self._on_enter_transition_params

	if not _on_enter_transition_params and not _on_enter_transition_params.menu_state_name then
		local menu_state_name = _on_enter_transition_params.menu_state_name
		local menu_sub_state_name = _on_enter_transition_params.menu_sub_state_name

		self:_change_screen_by_name(menu_state_name, menu_sub_state_name, _on_enter_transition_params)

		self._on_enter_transition_params = nil
	else
		self:_change_screen_by_index(1)
	end
end

StartMenuView.post_update_on_exit = function (self)
	-- function 31
	self.world_previewer:prepare_exit()
	self.world_previewer:on_exit()

	if not self.viewport_widget then
		UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

		self.viewport_widget = nil
	end

	if not self:initial_profile_view() then
		local world = Managers.world

		if not world:has_world("level_world") then
			local world_2 = world:world("level_world")
			local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()
			local level_name = LevelSettings[get_hub_level_key].level_name
			local level = ScriptWorld.level(world_2, level_name)

			if not level then
				Level.trigger_event(level, "play_keep_intro_cutscene")
			end
		end
	end
end

StartMenuView.on_exit = function (self)
	-- function 32
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.exiting = nil

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	ShowCursorStack.hide("StartMenuView")
	self:hide_hero_world()
	Managers.music:unduck_sounds()
	self:play_sound("play_gui_amb_hero_screen_loop_end")
	self:play_sound("Stop_menu_screen_music")
	UISettings.hero_fullscreen_menu_on_exit()
end

StartMenuView.exit = function (self, arg_33_1)
	-- function 33
	local flag

	flag = not self:initial_profile_view() and "exit_initial_start_menu_view" and not arg_33_1 or "exit_menu" and "ingame_menu"

	self.ingame_ui:transition_with_fade(flag)
	self:play_sound("Play_hud_button_close")

	self.exiting = true
	self._public_game_search_time = nil
end

StartMenuView.transitioning = function (self)
	-- function 34
	if not self.exiting then
		return true
	else
		return false
	end
end

StartMenuView.suspend = function (self)
	-- function 35
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.suspended = true

	local str = "player_1"
	local world = Managers.world:world("level_world")
	local viewport = ScriptWorld.viewport(world, str)

	ScriptWorld.activate_viewport(world, viewport)

	local var_35_3 = self.viewport_widget.element.pass_data[1]
	local viewport_2 = var_35_3.viewport
	local world_2 = var_35_3.world

	ScriptWorld.deactivate_viewport(world_2, viewport_2)
end

StartMenuView.unsuspend = function (self)
	-- function 36
	self.input_manager:block_device_except_service("start_menu_view", "keyboard", 1)
	self.input_manager:block_device_except_service("start_menu_view", "mouse", 1)
	self.input_manager:block_device_except_service("start_menu_view", "gamepad", 1)

	self.suspended = nil

	if not self.viewport_widget then
		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)

		local var_36_3 = self.viewport_widget.element.pass_data[1]
		local viewport_2 = var_36_3.viewport
		local world_2 = var_36_3.world

		ScriptWorld.activate_viewport(world_2, viewport_2)
	end
end

StartMenuView._handle_exit = function (self, arg_37_1)
	-- function 37
	if not self:initial_profile_view() then
		local _exit_button_widget = self._exit_button_widget

		if not _exit_button_widget.content.button_hotspot.on_hover_enter then
			self:play_sound("Play_hud_hover")
		end

		if not ((_exit_button_widget.content.button_hotspot.on_release or not arg_37_1:get("toggle_menu")) and self:_game_popup_active()) then
			self:play_sound("Play_hud_hover")
			self:close_menu(not self.exit_to_game)
		end
	end
end

StartMenuView._game_popup_active = function (self)
	-- function 38
	local _machine = self._machine

	if not _machine then
		local state = _machine:state()

		if state.NAME ~= "StartMenuStateOverview" or not state:game_popup_active() then
			return true
		end
	end
end

StartMenuView.close_menu = function (self, arg_39_1)
	-- function 39
	local _machine = self._machine

	if not _machine then
		local NAME = _machine:state().NAME

		if not ((GameSettingsDevelopment.skip_start_screen or not Development.parameter("skip_start_screen")) and NAME == "StartMenuStateOverview") then
			self:_change_screen_by_name("overview")

			return
		end
	end

	local flag = not arg_39_1

	self:exit(flag)
end

StartMenuView.destroy = function (self)
	-- function 40
	if not self.viewport_widget then
		UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

		self.viewport_widget = nil
	end

	self.ingame_ui_context = nil
	self.ui_animator = nil

	local str = "level_world"
	local world = Managers.world

	if not world:has_world(str) then
		local world_2 = world:world(str)
		local viewport = ScriptWorld.viewport(world_2, "player_1")

		ScriptWorld.activate_viewport(world_2, viewport)
	end

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end
end

StartMenuView._is_button_pressed = function (arg_41_0, arg_41_1)
	-- function 41
	local button_hotspot = arg_41_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end
