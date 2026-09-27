-- chunkname: @scripts/ui/views/character_selection_view/character_selection_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/character_selection_view/states/character_selection_state_character")
require("scripts/ui/views/character_selection_view/states/character_selection_state_versus_loadouts")
require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/character_selection_view/character_selection_view_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local settings_by_screen = var_0_0.settings_by_screen
local attachments = var_0_0.attachments
local flow_events = var_0_0.flow_events

local function fn(...)
	-- function 1
	print("[CharacterSelectionView]", ...)
end

local flag = true
local flag_2 = false
local flag_3 = true

CharacterSelectionView = class(CharacterSelectionView)

CharacterSelectionView.init = function (self, arg_2_1)
	-- function 2
	self.world = arg_2_1.world
	self.player_manager = arg_2_1.player_manager
	self.ui_renderer = arg_2_1.ui_renderer
	self.ui_top_renderer = arg_2_1.ui_top_renderer
	self.ingame_ui = arg_2_1.ingame_ui
	self.profile_synchronizer = arg_2_1.profile_synchronizer
	self.peer_id = arg_2_1.peer_id
	self.local_player_id = arg_2_1.local_player_id
	self.is_server = arg_2_1.is_server
	self.is_in_inn = arg_2_1.is_in_inn
	self.voting_manager = arg_2_1.voting_manager
	self.world_manager = arg_2_1.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	local input_manager = arg_2_1.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("character_selection_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("character_selection_view", "keyboard")
	input_manager:map_device_to_service("character_selection_view", "mouse")
	input_manager:map_device_to_service("character_selection_view", "gamepad")

	self.world_previewer = MenuWorldPreviewer:new(arg_2_1, UISettings.hero_selection_camera_position_by_character, "CharacterSelectionView")

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

	self:show_hero_panel()
end

CharacterSelectionView.initial_profile_view = function (self)
	-- function 3
	return self.ingame_ui.initial_profile_view
end

CharacterSelectionView._setup_state_machine = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local flag = arg_4_2 or CharacterSelectionStateCharacter
	local flag_2 = false

	arg_4_1.allow_back_button = not self:initial_profile_view()
	arg_4_1.start_state = arg_4_3
	arg_4_1.state_params = arg_4_4

	if not self._pick_time then
		arg_4_1.pick_time = self._pick_time
	end

	if not self._profile_id then
		arg_4_1.profile_id = self._profile_id
		arg_4_1.career_id = self._career_id
	end

	self._machine = GameStateMachine:new(self, flag, arg_4_1, flag_2)
	self._state_machine_params = arg_4_1
	arg_4_1.state_params = nil
end

CharacterSelectionView.wanted_state = function (self)
	-- function 5
	return self._wanted_state
end

CharacterSelectionView.clear_wanted_state = function (self)
	-- function 6
	self._wanted_state = nil
end

CharacterSelectionView.input_service = function (self, arg_7_1)
	-- function 7
	if not arg_7_1 then
		return self.input_manager:get_service("character_selection_view")
	else
		local FAKE_INPUT_SERVICE

		if not self._input_blocked then
			FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

			if not FAKE_INPUT_SERVICE then
				-- Nothing
			end
		end

		FAKE_INPUT_SERVICE = self.input_manager:get_service("character_selection_view")

		::label_7_0::

		return FAKE_INPUT_SERVICE
	end
end

CharacterSelectionView.set_input_blocked = function (self, arg_8_1)
	-- function 8
	self._input_blocked = arg_8_1
end

CharacterSelectionView.input_blocked = function (self)
	-- function 9
	return self._input_blocked
end

CharacterSelectionView.play_sound = function (self, arg_10_1)
	-- function 10
	WwiseWorld.trigger_event(self.wwise_world, arg_10_1)
end

CharacterSelectionView.create_ui_elements = function (self)
	-- function 11
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._static_widgets = {}
	self._title_widget = UIWidget.init(widgets_definitions.title_text)
	self._hero_name_text_widget = UIWidget.init(widgets_definitions.hero_name_text)
	self._hero_level_text_widget = UIWidget.init(widgets_definitions.hero_level_text)
	self._hero_prestige_level_text_widget = UIWidget.init(widgets_definitions.hero_prestige_level_text)
	self._title_description_widget = UIWidget.init(widgets_definitions.title_description_text)
	self._exit_button_widget = UIWidget.init(widgets_definitions.exit_button)

	UIRenderer.clear_scenegraph_queue(self.ui_top_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations)
end

CharacterSelectionView.get_background_world = function (self)
	-- function 12
	local var_12_0 = self.viewport_widget.element.pass_data[1]
	local viewport = var_12_0.viewport

	return var_12_0.world, viewport
end

CharacterSelectionView.show_hero_world = function (self)
	-- function 13
	if not self._draw_menu_world then
		self._draw_menu_world = true

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)
	end
end

CharacterSelectionView.hide_hero_world = function (self)
	-- function 14
	if not self._draw_menu_world then
		self._draw_menu_world = false

		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.activate_viewport(world, viewport)
	end
end

CharacterSelectionView.show_hero_panel = function (self)
	-- function 15
	self._draw_menu_panel = not self:initial_profile_view()

	self:set_input_blocked(false)
end

CharacterSelectionView.hide_hero_panel = function (self)
	-- function 16
	self._draw_menu_panel = false

	self:set_input_blocked(true)
end

CharacterSelectionView.draw = function (self, arg_17_1, arg_17_2)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local is_device_active = self.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_17_2, arg_17_1)

	if not flag_2 then
		UISceneGraph.debug_render_scenegraph(ui_top_renderer, ui_scenegraph)
	end

	if not self._draw_menu_panel then
		UIRenderer.draw_widget(ui_top_renderer, self._exit_button_widget)

		for i, v in ipairs(self._static_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v)
		end
	end

	if not self.viewport_widget and not self._draw_menu_world then
		UIRenderer.draw_widget(ui_top_renderer, self.viewport_widget)
	end

	UIRenderer.end_pass(ui_top_renderer)
end

CharacterSelectionView.post_update = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._machine:post_update(arg_18_1, arg_18_2)
	self.world_previewer:post_update(arg_18_1, arg_18_2)
end

CharacterSelectionView.update = function (self, arg_19_1, arg_19_2)
	-- function 19
	if self.suspended or not self.waiting_for_post_update_enter then
		return
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

	FAKE_INPUT_SERVICE = input_manager:get_service("character_selection_view")

	::label_19_0::

	self._state_machine_params.input_service = FAKE_INPUT_SERVICE

	local transitioning = self:transitioning()

	self.ui_animator:update(arg_19_1)
	self.world_previewer:update(arg_19_1, arg_19_2)

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_19_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	self._machine:update(arg_19_1, arg_19_2)

	if not transitioning then
		if not self:_has_active_level_vote() then
			self:play_sound("play_gui_start_menu_button_click")
			self:close_menu()
		else
			self:_handle_mouse_input(arg_19_1, arg_19_2, FAKE_INPUT_SERVICE)
			self:_handle_exit(arg_19_1, FAKE_INPUT_SERVICE)
		end
	end

	self:draw(arg_19_1, FAKE_INPUT_SERVICE)
end

CharacterSelectionView._has_active_level_vote = function (self)
	-- function 20
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

CharacterSelectionView.on_enter = function (self, arg_21_1)
	-- function 21
	ShowCursorStack.show("CharacterSelectionView")

	local input_manager = self.input_manager

	input_manager:block_device_except_service("character_selection_view", "keyboard", 1)
	input_manager:block_device_except_service("character_selection_view", "mouse", 1)
	input_manager:block_device_except_service("character_selection_view", "gamepad", 1)

	self._state_machine_params.initial_state = true

	self:create_ui_elements()

	local pick_time = arg_21_1.pick_time

	if not pick_time then
		self._pick_time = pick_time
	end

	local profile_id = arg_21_1.profile_id

	if not (not profile_id and not (profile_id > 0)) then
		self._profile_id = profile_id
		self._career_id = arg_21_1.career_id

		self:set_current_hero(profile_id)
	else
		local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

		if not profile_by_peer then
			self:set_current_hero(profile_by_peer)
		end
	end

	self.waiting_for_post_update_enter = true
	self._on_enter_transition_params = arg_21_1

	if not self:initial_profile_view() then
		self:hide_hero_panel()
	else
		self:show_hero_panel()
	end

	Managers.music:duck_sounds()
	self:play_sound("play_gui_amb_hero_screen_loop_begin")

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag then
		local has_extension = ScriptUnit.has_extension(flag, "inventory_system")

		if not has_extension then
			has_extension:check_and_drop_pickups("enter_inventory")
		end
	end

	UISettings.hero_fullscreen_menu_on_enter()

	self._exit_transition = arg_21_1.exit_transition
	self._exit_transition_params = arg_21_1.exit_transition_params
end

CharacterSelectionView.set_current_hero = function (self, arg_22_1)
	-- function 22
	local var_22_0 = SPProfiles[arg_22_1]
	local display_name = var_22_0.display_name
	local character_name = var_22_0.character_name

	self._hero_name = display_name
	self._state_machine_params.hero_name = display_name
	self._hero_name_text_widget.content.text = Localize(character_name)
	self._hero_level_text_widget.content.text = Localize(display_name)

	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "prestige")

	if not get then
		self:set_prestige_level(get)
	end
end

CharacterSelectionView._get_sorted_players = function (self)
	-- function 23
	local human_players = self.player_manager:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		tbl[#tbl + 1] = v
	end

	table.sort(tbl, function (self, arg_24_1)
		-- function 24
		local local_player = self.local_player

		local_player = not local_player and not arg_24_1.local_player

		return local_player
	end)

	return tbl
end

CharacterSelectionView.set_prestige_level = function (arg_25_0, arg_25_1)
	-- function 25
	if arg_25_1 > 0 then
		arg_25_0._hero_prestige_level_text_widget.content.text = "Prestige level: " .. arg_25_1
	else
		arg_25_0._hero_prestige_level_text_widget.content.text = ""
	end
end

CharacterSelectionView._handle_mouse_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	return
end

CharacterSelectionView._is_selection_widget_pressed = function (arg_27_0, arg_27_1)
	-- function 27
	local content = arg_27_1.content
	local steps = content.steps

	for i = 1, steps do
		if not content["hotspot_" .. i].on_release then
			return true, i
		end
	end
end

CharacterSelectionView.hotkey_allowed = function (self, arg_28_1, arg_28_2)
	-- function 28
	if not self:input_blocked() then
		return false
	end

	local transition_state = arg_28_2.transition_state
	local transition_sub_state = arg_28_2.transition_sub_state
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

CharacterSelectionView._get_screen_settings_by_state_name = function (arg_29_0, arg_29_1)
	-- function 29
	for i, v in ipairs(settings_by_screen) do
		if v.state_name == arg_29_1 then
			return v
		end
	end
end

CharacterSelectionView.requested_screen_change_by_name = function (self, arg_30_1, arg_30_2)
	-- function 30
	self._requested_screen_change_data = {
		screen_name = arg_30_1,
		sub_screen_name = arg_30_2
	}
end

CharacterSelectionView._change_screen_by_name = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local var_31_0
	local var_31_1

	for i, v in ipairs(settings_by_screen) do
		if v.name == arg_31_1 then
			var_31_0 = v
			var_31_1 = i

			break
		end
	end

	fassert(var_31_1, "[CharacterSelectionView] - Could not find state by name %s", arg_31_1)

	self._title_widget.content.text = var_31_0.display_name
	self._title_description_widget.content.text = var_31_0.description

	local state_name = var_31_0.state_name
	local var_31_3 = rawget(_G, state_name)

	if not (not self._machine and arg_31_2) then
		self._wanted_state = var_31_3
	else
		self:_setup_state_machine(self._state_machine_params, var_31_3, arg_31_2, arg_31_3)
	end

	if not var_31_0.draw_background_world then
		self:show_hero_world()
	else
		self:hide_hero_world()
	end

	local camera_position = var_31_0.camera_position

	if not camera_position then
		self.world_previewer:set_camera_axis_offset("x", camera_position[1], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_axis_offset("y", camera_position[2], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_axis_offset("z", camera_position[3], 0.5, math.easeOutCubic)
	end

	local camera_rotation = var_31_0.camera_rotation

	if not camera_rotation then
		self.world_previewer:set_camera_rotation_axis_offset("x", camera_rotation[1], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_rotation_axis_offset("y", camera_rotation[2], 0.5, math.easeOutCubic)
		self.world_previewer:set_camera_rotation_axis_offset("z", camera_rotation[3], 0.5, math.easeOutCubic)
	end
end

CharacterSelectionView._change_screen_by_index = function (self, arg_32_1)
	-- function 32
	local name = settings_by_screen[arg_32_1].name

	self:_change_screen_by_name(name)
end

CharacterSelectionView.post_update_on_enter = function (self)
	-- function 33
	fassert(self.viewport_widget == nil, "[CharacterSelectionView:post_update_on_enter] viewport already created")

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

CharacterSelectionView.post_update_on_exit = function (self)
	-- function 34
	self.world_previewer:prepare_exit()
	self.world_previewer:on_exit()

	if not self.viewport_widget then
		UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

		self.viewport_widget = nil
	end
end

CharacterSelectionView.on_exit = function (self, arg_35_1)
	-- function 35
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("CharacterSelectionView")

	self.exiting = nil

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	self:hide_hero_world()
	Managers.music:unduck_sounds()
	self:play_sound("play_gui_amb_hero_screen_loop_end")
	UISettings.hero_fullscreen_menu_on_exit()
end

CharacterSelectionView.exit = function (self, arg_36_1)
	-- function 36
	local _exit_transition = self._exit_transition

	_exit_transition = _exit_transition or not self:initial_profile_view() or "exit_initial_character_selection" or "exit_menu"

	self.ingame_ui:transition_with_fade(_exit_transition, self._exit_transition_params)

	if not IS_WINDOWS and not self:initial_profile_view() then
		self:play_sound("Play_hero_selected_game_start")
	else
		self:play_sound("Play_hud_button_close")
	end

	self.exiting = true

	Managers.save:auto_save(SaveFileName, SaveData)
	Managers.backend:commit()
end

CharacterSelectionView.transitioning = function (self)
	-- function 37
	if not self.exiting then
		return true
	else
		return false
	end
end

CharacterSelectionView.suspend = function (self)
	-- function 38
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.suspended = true

	local str = "player_1"
	local world = Managers.world:world("level_world")
	local viewport = ScriptWorld.viewport(world, str)

	ScriptWorld.activate_viewport(world, viewport)

	local var_38_3 = self.viewport_widget.element.pass_data[1]
	local viewport_2 = var_38_3.viewport
	local world_2 = var_38_3.world

	ScriptWorld.deactivate_viewport(world_2, viewport_2)
end

CharacterSelectionView.unsuspend = function (self)
	-- function 39
	self.input_manager:block_device_except_service("character_selection_view", "keyboard", 1)
	self.input_manager:block_device_except_service("character_selection_view", "mouse", 1)
	self.input_manager:block_device_except_service("character_selection_view", "gamepad", 1)

	self.suspended = nil

	if not self.viewport_widget then
		local str = "player_1"
		local world = Managers.world:world("level_world")
		local viewport = ScriptWorld.viewport(world, str)

		ScriptWorld.deactivate_viewport(world, viewport)

		local var_39_3 = self.viewport_widget.element.pass_data[1]
		local viewport_2 = var_39_3.viewport
		local world_2 = var_39_3.world

		ScriptWorld.activate_viewport(world_2, viewport_2)
	end
end

CharacterSelectionView._handle_exit = function (self, arg_40_1, arg_40_2)
	-- function 40
	local initial_profile_view = self:initial_profile_view()
	local _exit_button_widget = self._exit_button_widget

	UIWidgetUtils.animate_default_button(_exit_button_widget, arg_40_1)

	if not initial_profile_view then
		if not _exit_button_widget.content.button_hotspot.on_hover_enter then
			self:play_sound("play_gui_start_menu_button_hover")
		end

		if _exit_button_widget.content.button_hotspot.on_release or not arg_40_2:get("toggle_menu") then
			self:play_sound("play_gui_start_menu_button_click")
			self:close_menu(not self.exit_to_game)
		end
	end
end

CharacterSelectionView.get_exit_button_widget = function (self)
	-- function 41
	return self._exit_button_widget
end

CharacterSelectionView.close_menu = function (self, arg_42_1)
	-- function 42
	local flag = not arg_42_1

	self:exit(flag)
end

CharacterSelectionView.destroy = function (self)
	-- function 43
	if not self.viewport_widget then
		UIWidget.destroy(self.ui_top_renderer, self.viewport_widget)

		self.viewport_widget = nil
	end

	self.ingame_ui_context = nil
	self.ui_animator = nil

	local str = "player_1"
	local world = Managers.world:world("level_world")
	local viewport = ScriptWorld.viewport(world, str)

	ScriptWorld.activate_viewport(world, viewport)

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end
end

CharacterSelectionView._is_button_pressed = function (arg_44_0, arg_44_1)
	-- function 44
	local button_hotspot = arg_44_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end
