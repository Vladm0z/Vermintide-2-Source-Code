-- chunkname: @scripts/ui/views/start_game_view/start_game_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/start_game_view/states/start_game_state_settings_overview")
require("scripts/ui/views/start_game_view/states/start_game_state_weave_leaderboard")

local var_0_0 = local_require("scripts/ui/views/start_game_view/start_game_view_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local settings_by_screen = var_0_0.settings_by_screen
local attachments = var_0_0.attachments
local flow_events = var_0_0.flow_events

local function fn(...)
	-- function 1
	print("[StartGameView]", ...)
end

local flag = true
local flag_2 = false
local flag_3 = true
local tbl = {}

if not IS_WINDOWS then
	tbl.console_friends_menu = function (self)
		-- function 2
		Managers.input:block_device_except_service("console_friends_menu", "gamepad")
		self:_activate_view("console_friends_view")
	end
end

StartGameView = class(StartGameView)

StartGameView.init = function (self, arg_3_1)
	-- function 3
	self.world = arg_3_1.world
	self.player_manager = arg_3_1.player_manager
	self.ui_renderer = arg_3_1.ui_renderer
	self.ui_top_renderer = arg_3_1.ui_top_renderer
	self.ingame_ui = arg_3_1.ingame_ui
	self.voting_manager = arg_3_1.voting_manager
	self.profile_synchronizer = arg_3_1.profile_synchronizer
	self.peer_id = arg_3_1.peer_id
	self.local_player_id = arg_3_1.local_player_id
	self.is_server = arg_3_1.is_server
	self.is_in_inn = arg_3_1.is_in_inn
	self.world_manager = arg_3_1.world_manager

	local world = self.world_manager:world("level_world")

	self.wwise_world = Managers.world:wwise_world(world)

	local input_manager = arg_3_1.input_manager

	self.input_manager = input_manager

	input_manager:create_input_service("start_game_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("start_game_view", "keyboard")
	input_manager:map_device_to_service("start_game_view", "mouse")
	input_manager:map_device_to_service("start_game_view", "gamepad")

	self._state_machine_params = {
		wwise_world = self.wwise_world,
		ingame_ui_context = arg_3_1,
		parent = self,
		settings_by_screen = settings_by_screen,
		input_service = FAKE_INPUT_SERVICE
	}
	self.units = {}
	self.attachment_units = {}
	self.unit_states = {}
	self.ui_animations = {}
	self.ingame_ui_context = arg_3_1
	flag = false
end

StartGameView._init_menu_views = function (self)
	-- function 4
	local ingame_ui_context = self.ingame_ui_context

	self._views = {
		console_friends_view = ingame_ui_context.ingame_ui.views.console_friends_view
	}

	for k, v in pairs(self._views) do
		v.exit = function ()
			-- function 5
			self:exit_current_view()
		end
	end
end

StartGameView._activate_view = function (self, arg_6_1)
	-- function 6
	self._active_view = arg_6_1

	local _views = self._views

	assert(_views[arg_6_1])

	if not arg_6_1 and not _views[arg_6_1] and not _views[arg_6_1].on_enter then
		_views[arg_6_1]:on_enter()
	end
end

StartGameView.active_view = function (self)
	-- function 7
	return self._active_view
end

StartGameView.exit_current_view = function (self)
	-- function 8
	local _active_view = self._active_view
	local _views = self._views

	assert(_active_view)

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()
	end

	self._active_view = nil

	local name = Managers.input:get_service("start_game_view").name
	local input = Managers.input

	input:block_device_except_service(name, "keyboard")
	input:block_device_except_service(name, "mouse")
	input:block_device_except_service(name, "gamepad")
	input:disable_gamepad_cursor()
end

StartGameView.initial_profile_view = function (self)
	-- function 9
	return self.ingame_ui.initial_profile_view
end

StartGameView._setup_state_machine = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4)
	-- function 10
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local flag = arg_10_2 or StartGameStateSettingsOverview
	local flag_2 = false

	arg_10_1.start_state = arg_10_3
	arg_10_1.state_params = arg_10_4
	self._machine = GameStateMachine:new(self, flag, arg_10_1, flag_2)
	self._state_machine_params = arg_10_1
	arg_10_1.state_params = nil
end

StartGameView.wanted_state = function (self)
	-- function 11
	return self._wanted_state
end

StartGameView.clear_wanted_state = function (self)
	-- function 12
	self._wanted_state = nil
end

StartGameView.input_service = function (self)
	-- function 13
	local FAKE_INPUT_SERVICE

	if not self._draw_loading then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self.input_manager:get_service("start_game_view")

	::label_13_0::

	return FAKE_INPUT_SERVICE
end

StartGameView.set_input_blocked = function (self, arg_14_1)
	-- function 14
	self._input_blocked = arg_14_1
end

StartGameView.input_blocked = function (self)
	-- function 15
	return self._input_blocked
end

StartGameView.play_sound = function (self, arg_16_1)
	-- function 16
	WwiseWorld.trigger_event(self.wwise_world, arg_16_1)
end

StartGameView.play_mechanism_sound = function (self, arg_17_1, arg_17_2)
	-- function 17
	local mechanism_setting = Managers.mechanism:mechanism_setting(arg_17_1)

	mechanism_setting = mechanism_setting or arg_17_2

	if not mechanism_setting then
		self:play_sound(mechanism_setting)
	end
end

StartGameView.create_ui_elements = function (self)
	-- function 18
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._static_widgets = {}
	self._loading_widgets = {
		background = UIWidget.init(widgets_definitions.loading_bg),
		text = UIWidget.init(widgets_definitions.loading_text)
	}
	self._console_cursor_widget = UIWidget.init(widgets_definitions.console_cursor)

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations)
end

StartGameView.draw = function (self, arg_19_1, arg_19_2)
	-- function 19
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local is_device_active = self.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_19_2, arg_19_1)

	if not flag_2 then
		UISceneGraph.debug_render_scenegraph(ui_renderer, ui_scenegraph)
	end

	for i, v in ipairs(self._static_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	UIRenderer.draw_widget(ui_renderer, self._console_cursor_widget)

	if not self._draw_loading then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_19_2, arg_19_1)

		for k, v_2 in pairs(self._loading_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end

		UIRenderer.end_pass(ui_top_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

StartGameView.post_update = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._machine then
		self._machine:post_update(arg_20_1, arg_20_2)
	end
end

StartGameView.update = function (self, arg_21_1, arg_21_2)
	-- function 21
	if self.suspended or not self.waiting_for_post_update_enter then
		return
	end

	if not self:_has_active_level_vote() then
		self:close_menu(nil, true)
	end

	local _requested_screen_change_data = self._requested_screen_change_data

	if not _requested_screen_change_data then
		local screen_name = _requested_screen_change_data.screen_name
		local sub_screen_name = _requested_screen_change_data.sub_screen_name

		self:_change_screen_by_name(screen_name, sub_screen_name)

		self._requested_screen_change_data = nil
	end

	local flag = true
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local FAKE_INPUT_SERVICE

	if not self:input_blocked() then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_21_0::

	self._state_machine_params.input_service = FAKE_INPUT_SERVICE

	local transitioning = self:transitioning()

	self.ui_animator:update(arg_21_1)

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_21_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not transitioning then
		self:_handle_mouse_input(arg_21_1, arg_21_2, FAKE_INPUT_SERVICE)

		local _active_view = self._active_view

		if not _active_view then
			self._views[_active_view]:update(arg_21_1, arg_21_2)
		else
			self:_handle_input(arg_21_1, arg_21_2)
		end
	end

	if not self._machine then
		self._machine:update(arg_21_1, arg_21_2)
	end

	self:draw(arg_21_1, FAKE_INPUT_SERVICE)
end

StartGameView.on_enter = function (self, arg_22_1)
	-- function 22
	ShowCursorStack.show("StartGameView")

	local input_manager = self.input_manager

	input_manager:block_device_except_service("start_game_view", "keyboard", 1)
	input_manager:block_device_except_service("start_game_view", "mouse", 1)
	input_manager:block_device_except_service("start_game_view", "gamepad", 1)

	self._state_machine_params.initial_state = true

	self:create_ui_elements()

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

	self:set_current_hero(profile_by_peer)

	self.waiting_for_post_update_enter = true
	self._on_enter_transition_params = arg_22_1
	self._on_enter_sub_state = arg_22_1.menu_sub_state_name

	self:play_mechanism_sound("start_game_open_sound_event")
	Managers.music:duck_sounds()

	self._draw_loading = false

	self:_init_menu_views()
	self:_handle_new_ui_disclaimer()
end

StartGameView._handle_new_ui_disclaimer = function (self)
	-- function 23
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local tbl = {
		deus = {
			play = false,
			default = false
		},
		adventure = {
			default = true,
			leaderboard = false
		},
		default = {
			default = true,
			leaderboard = false
		}
	}
	local var_23_2 = tbl[current_mechanism_name]

	var_23_2 = var_23_2 or tbl.default

	local _on_enter_transition_params = self._on_enter_transition_params
	local menu_state_name

	if not _on_enter_transition_params then
		menu_state_name = _on_enter_transition_params.menu_state_name

		if not menu_state_name then
			-- Nothing
		end
	end

	menu_state_name = "default"

	::label_23_0::

	Managers.ui:handle_new_ui_disclaimer(var_23_2, menu_state_name)
end

StartGameView.on_enter_sub_state = function (self)
	-- function 24
	return self._on_enter_sub_state
end

StartGameView.set_current_hero = function (self, arg_25_1)
	-- function 25
	local var_25_0 = SPProfiles[arg_25_1]
	local display_name = var_25_0.display_name
	local character_name = var_25_0.character_name

	self._hero_name = display_name
	self._state_machine_params.hero_name = display_name
end

StartGameView._get_sorted_players = function (self)
	-- function 26
	local human_players = self.player_manager:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		tbl[#tbl + 1] = v
	end

	table.sort(tbl, function (self, arg_27_1)
		-- function 27
		local local_player = self.local_player

		local_player = not local_player and not arg_27_1.local_player

		return local_player
	end)

	return tbl
end

StartGameView._handle_mouse_input = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	return
end

StartGameView._handle_input = function (self, arg_29_1, arg_29_2)
	-- function 29
	if not Managers.account:offline_mode() then
		return
	end

	if not self:input_service():get("show_gamercard") and not tbl.console_friends_menu then
		local state = self._machine:state()

		if not state.disable_input and not state:disable_input("show_gamercard") then
			return
		end

		tbl.console_friends_menu(self)
	end
end

StartGameView._is_selection_widget_pressed = function (arg_30_0, arg_30_1)
	-- function 30
	local content = arg_30_1.content
	local steps = content.steps

	for i = 1, steps do
		if not content["hotspot_" .. i].on_release then
			return true, i
		end
	end
end

StartGameView.hotkey_allowed = function (self, arg_31_1, arg_31_2)
	-- function 31
	if not self:input_blocked() then
		return false
	end

	local transition_state = arg_31_2.transition_state
	local transition_sub_state = arg_31_2.transition_sub_state
	local _machine = self._machine

	if not _machine then
		local state = _machine:state()
		local NAME = state.NAME

		if not (not state.hotkey_allowed and state:hotkey_allowed(arg_31_1, arg_31_2)) then
			return false
		end

		if self:_get_screen_settings_by_state_name(NAME).name == transition_state then
			local get_selected_layout_name = state.get_selected_layout_name

			get_selected_layout_name = not get_selected_layout_name and state:get_selected_layout_name()

			if not (not transition_sub_state and transition_sub_state ~= get_selected_layout_name) then
				return true
			elseif not transition_sub_state then
				return true
			end
		elseif not transition_state then
			self:requested_screen_change_by_name(transition_state, transition_sub_state)
		else
			return true
		end
	end

	return false
end

StartGameView._get_screen_settings_by_state_name = function (arg_32_0, arg_32_1)
	-- function 32
	for i, v in ipairs(settings_by_screen) do
		if v.state_name == arg_32_1 then
			return v
		end
	end
end

StartGameView.requested_screen_change_by_name = function (self, arg_33_1, arg_33_2)
	-- function 33
	self._requested_screen_change_data = {
		screen_name = arg_33_1,
		sub_screen_name = arg_33_2
	}
end

StartGameView._change_screen_by_name = function (self, arg_34_1, arg_34_2, arg_34_3)
	-- function 34
	local var_34_0
	local var_34_1

	for i, v in ipairs(settings_by_screen) do
		if v.name == arg_34_1 then
			var_34_0 = v
			var_34_1 = i

			break
		end
	end

	assert(var_34_1, "[StartGameView] - Could not find state by name: %s", arg_34_1)

	local state_name = var_34_0.state_name
	local var_34_3 = rawget(_G, state_name)

	if not (not self._machine and arg_34_2) then
		self._wanted_state = var_34_3
	else
		self:_setup_state_machine(self._state_machine_params, var_34_3, arg_34_2, arg_34_3)
	end
end

StartGameView._change_screen_by_index = function (self, arg_35_1)
	-- function 35
	local name = settings_by_screen[arg_35_1].name

	self:_change_screen_by_name(name)
end

StartGameView.post_update_on_enter = function (self)
	-- function 36
	self.waiting_for_post_update_enter = nil

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

StartGameView.post_update_on_exit = function (arg_37_0)
	-- function 37
	return
end

StartGameView.on_exit = function (self)
	-- function 38
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("StartGameView")

	self.exiting = nil

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local _active_view = self._active_view
	local _views = self._views

	if not _views[_active_view] and not _views[_active_view].on_exit then
		_views[_active_view]:on_exit()
	end

	self._active_view = nil

	self:play_mechanism_sound("start_game_close_sound_event")
	Managers.music:unduck_sounds()

	self._draw_loading = false
end

StartGameView.exit = function (self, arg_39_1, arg_39_2)
	-- function 39
	local flag

	flag = not arg_39_1 and "exit_menu" and "ingame_menu"

	self.ingame_ui:transition_with_fade(flag)

	if not self._active_view then
		self:exit_current_view()
	end

	if not arg_39_2 then
		self:play_mechanism_sound("close_start_menu_sound_event", "Play_hud_button_close")
	end

	self.exiting = true
end

StartGameView.transitioning = function (self)
	-- function 40
	if not self.exiting then
		return true
	else
		return false
	end
end

StartGameView.suspend = function (self)
	-- function 41
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.suspended = true
end

StartGameView.unsuspend = function (self)
	-- function 42
	self.input_manager:block_device_except_service("start_game_view", "keyboard", 1)
	self.input_manager:block_device_except_service("start_game_view", "mouse", 1)
	self.input_manager:block_device_except_service("start_game_view", "gamepad", 1)

	self.suspended = nil
end

StartGameView.close_menu = function (self, arg_43_1, arg_43_2)
	-- function 43
	local flag = not arg_43_1

	self:exit(flag, arg_43_2)
end

StartGameView.destroy = function (self)
	-- function 44
	self.ingame_ui_context = nil
	self.ui_animator = nil

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end
end

StartGameView._is_button_pressed = function (arg_45_0, arg_45_1)
	-- function 45
	local button_hotspot = arg_45_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

StartGameView._has_active_level_vote = function (self)
	-- function 46
	local voting_manager = self.voting_manager
	local vote_in_progress = voting_manager:vote_in_progress()

	vote_in_progress = not vote_in_progress and voting_manager:is_mission_vote()

	return not vote_in_progress and not voting_manager:has_voted(Network.peer_id())
end

StartGameView._set_loading_overlay_enabled = function (self, arg_47_1, arg_47_2)
	-- function 47
	local _loading_widgets = self._loading_widgets
	local text = _loading_widgets.text
	local background = _loading_widgets.background
	local flag

	flag = not arg_47_1 and 255 and 0
	background.style.color[1] = flag
	text.style.text.text_color[1] = flag
	text.content.text = arg_47_2 or ""
	self._draw_loading = arg_47_1
end

StartGameView.number_of_players = function (arg_48_0)
	-- function 48
	return Managers.player:num_human_players()
end

StartGameView.start_game = function (self, arg_49_1, arg_49_2)
	-- function 49
	if not arg_49_2 then
		Managers.mechanism:request_vote(arg_49_1)
	end

	self:play_mechanism_sound("start_game_play_sound_event", "play_gui_lobby_button_play")

	if not (arg_49_1.matchmaking_type ~= "custom" or arg_49_1.player_hosted ~= true or arg_49_1.mechanism ~= "versus") then
		return
	end

	self:close_menu()
end

StartGameView.cancel_matchmaking = function (arg_50_0)
	-- function 50
	local matchmaking = Managers.matchmaking

	if not matchmaking:is_game_matchmaking() then
		matchmaking:cancel_matchmaking()
	end
end
