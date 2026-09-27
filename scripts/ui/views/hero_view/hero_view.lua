-- chunkname: @scripts/ui/views/hero_view/hero_view.lua

require("scripts/ui/ui_unit_previewer")
require("scripts/ui/views/menu_world_previewer")
require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/hero_view/states/hero_view_state_overview")
require("scripts/ui/views/hero_view/states/hero_view_state_loot")
require("scripts/ui/views/hero_view/states/hero_view_state_achievements")
require("scripts/ui/views/hero_view/states/hero_view_state_keep_decorations")
require("scripts/ui/views/hero_view/states/hero_view_state_weave_forge")
require("scripts/ui/views/hero_view/states/hero_view_state_handbook")
require("scripts/settings/news_feed_templates")
DLCUtils.map_list("hero_view", function (self)
	-- function 1
	require(self.filename)
end)

local var_0_0 = local_require("scripts/ui/views/hero_view/hero_view_definitions")
local widgets_definitions = var_0_0.widgets_definitions
local scenegraph_definition = var_0_0.scenegraph_definition
local settings_by_screen = var_0_0.settings_by_screen
local attachments = var_0_0.attachments
local flow_events = var_0_0.flow_events

local function fn(...)
	-- function 2
	print("[HeroView]", ...)
end

local flag = true
local flag_2 = false
local flag_3 = true

HeroView = class(HeroView)

HeroView.init = function (self, arg_3_1)
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

	input_manager:create_input_service("hero_view", "IngameMenuKeymaps", "IngameMenuFilters")
	input_manager:map_device_to_service("hero_view", "keyboard")
	input_manager:map_device_to_service("hero_view", "mouse")
	input_manager:map_device_to_service("hero_view", "gamepad")

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

HeroView.initial_profile_view = function (self)
	-- function 4
	return self.ingame_ui.initial_profile_view
end

HeroView._setup_state_machine = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	local flag = arg_5_2 or HeroViewStateOverview
	local flag_2 = false

	arg_5_1.start_state = arg_5_3
	arg_5_1.state_params = arg_5_4
	self._machine = GameStateMachine:new(self, flag, arg_5_1, flag_2)
	self._state_machine_params = arg_5_1
	arg_5_1.state_params = nil
end

HeroView.wanted_state = function (self)
	-- function 6
	return self._wanted_state
end

HeroView.clear_wanted_state = function (self)
	-- function 7
	self._wanted_state = nil
end

HeroView.input_service = function (self)
	-- function 8
	local FAKE_INPUT_SERVICE

	if not self._draw_loading then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self.input_manager:get_service("hero_view")

	::label_8_0::

	return FAKE_INPUT_SERVICE
end

HeroView.set_input_blocked = function (self, arg_9_1)
	-- function 9
	self._input_blocked = arg_9_1
end

HeroView.input_blocked = function (self)
	-- function 10
	return self._input_blocked
end

HeroView.play_sound = function (self, arg_11_1)
	-- function 11
	WwiseWorld.trigger_event(self.wwise_world, arg_11_1)
end

HeroView.create_ui_elements = function (self)
	-- function 12
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self._static_widgets = {}
	self._loading_widgets = {
		background = UIWidget.init(widgets_definitions.loading_bg),
		text = UIWidget.init(widgets_definitions.loading_text)
	}

	UIRenderer.clear_scenegraph_queue(self.ui_renderer)

	self.ui_animator = UIAnimator:new(self.ui_scenegraph, var_0_0.animations)
end

HeroView._setup_hdr_gui = function (self)
	-- function 13
	if not self.is_in_inn then
		local tbl = {}
		local str = "hero_view_hdr"

		if not str then
			local _setup_hdr_renderer, var_13_3, var_13_4 = self:_setup_hdr_renderer(str, 600)

			tbl.bottom = {
				renderer = _setup_hdr_renderer,
				world = var_13_3,
				viewport_name = var_13_4
			}
		end

		local str_2 = "hero_view_hdr_top"

		if not str_2 then
			local _setup_hdr_renderer_2, var_13_7, var_13_8 = self:_setup_hdr_renderer(str_2, 850)

			tbl.top = {
				renderer = _setup_hdr_renderer_2,
				world = var_13_7,
				viewport_name = var_13_8
			}
		end

		self._hdr_gui_data = tbl
	end
end

HeroView._setup_hdr_renderer = function (self, arg_14_1, arg_14_2)
	-- function 14
	local tbl = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_14_1 = arg_14_1
	local var_14_2 = arg_14_1
	local str = "environment/ui_hdr"
	local create_world = Managers.world:create_world(var_14_1, str, nil, arg_14_2, unpack(tbl))
	local str_2 = "overlay"
	local create_viewport = ScriptWorld.create_viewport(create_world, var_14_2, str_2, 999)

	return self.ingame_ui:create_ui_renderer(create_world, false, self.is_in_inn), create_world, var_14_2
end

HeroView.hdr_renderer = function (self)
	-- function 15
	return self._hdr_gui_data.bottom.renderer
end

HeroView.hdr_top_renderer = function (self)
	-- function 16
	return self._hdr_gui_data.top.renderer
end

HeroView.draw = function (self, arg_17_1, arg_17_2)
	-- function 17
	local ui_renderer = self.ui_renderer
	local ui_top_renderer = self.ui_top_renderer
	local ui_scenegraph = self.ui_scenegraph
	local is_device_active = self.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, arg_17_2, arg_17_1)

	if not flag_2 then
		UISceneGraph.debug_render_scenegraph(ui_renderer, ui_scenegraph)
	end

	for i, v in ipairs(self._static_widgets) do
		UIRenderer.draw_widget(ui_renderer, v)
	end

	if not self._draw_loading then
		UIRenderer.begin_pass(ui_top_renderer, ui_scenegraph, arg_17_2, arg_17_1)

		for k, v_2 in pairs(self._loading_widgets) do
			UIRenderer.draw_widget(ui_top_renderer, v_2)
		end

		UIRenderer.end_pass(ui_top_renderer)
	end

	UIRenderer.end_pass(ui_renderer)
end

HeroView.post_update = function (self, arg_18_1, arg_18_2)
	-- function 18
	self._machine:post_update(arg_18_1, arg_18_2)
end

HeroView.update = function (self, arg_19_1, arg_19_2)
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
	local is_device_active = self.input_manager:is_device_active("gamepad")
	local FAKE_INPUT_SERVICE

	if not self:input_blocked() then
		FAKE_INPUT_SERVICE = FAKE_INPUT_SERVICE

		if not FAKE_INPUT_SERVICE then
			-- Nothing
		end
	end

	FAKE_INPUT_SERVICE = self:input_service()

	::label_19_0::

	self._state_machine_params.input_service = FAKE_INPUT_SERVICE

	local transitioning = self:transitioning()

	self.ui_animator:update(arg_19_1)

	for k, v in pairs(self.ui_animations) do
		UIAnimation.update(v, arg_19_1)

		if not UIAnimation.completed(v) then
			self.ui_animations[k] = nil
		end
	end

	if not transitioning then
		self:_handle_mouse_input(arg_19_1, arg_19_2, FAKE_INPUT_SERVICE)
	end

	self._machine:update(arg_19_1, arg_19_2)
	self:draw(arg_19_1, FAKE_INPUT_SERVICE)
end

HeroView.on_enter = function (self, arg_20_1)
	-- function 20
	self._force_ingame_menu = arg_20_1.force_ingame_menu

	if not self._force_ingame_menu then
		self:_setup_hdr_gui()
	end

	ShowCursorStack.show("HeroView")

	local input_manager = self.input_manager

	input_manager:block_device_except_service("hero_view", "keyboard", 1)
	input_manager:block_device_except_service("hero_view", "mouse", 1)
	input_manager:block_device_except_service("hero_view", "gamepad", 1)

	self._state_machine_params.initial_state = true

	self:create_ui_elements()

	local profile_by_peer = self.profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

	profile_by_peer = profile_by_peer or 1

	self:set_current_hero(profile_by_peer)

	self.waiting_for_post_update_enter = true
	self._loadout_dirty = false
	self._on_enter_transition_params = arg_20_1

	Managers.music:duck_sounds()

	self._draw_loading = false

	self:_handle_new_ui_disclaimer()
	self:_fetch_initial_loadout_index(arg_20_1)
end

HeroView._fetch_initial_loadout_index = function (self, arg_21_1)
	-- function 21
	local ingame_ui_context = self._state_machine_params.ingame_ui_context

	self._is_in_tutorial = ingame_ui_context.is_in_tutorial

	if not self._is_in_tutorial then
		return
	end

	local game_mode_key = Managers.state.game_mode:game_mode_key()

	if not InventorySettings.inventory_loadout_access_supported_game_modes[game_mode_key] then
		return
	end

	self._peer_id = ingame_ui_context.peer_id
	self._local_player_id = ingame_ui_context.local_player_id

	local network_server = ingame_ui_context.network_server

	network_server = network_server or ingame_ui_context.network_client
	self._profile_requester = network_server:profile_requester()
	self._profile_synchronizer = ingame_ui_context.profile_synchronizer

	local profile_by_peer, var_21_4 = self._profile_synchronizer:profile_by_peer(self._peer_id, self._local_player_id)
	local var_21_5 = SPProfiles[profile_by_peer]
	local name = var_21_5.careers[var_21_4].name

	self._profile_name = var_21_5.display_name
	self._career_name = name
	self._initial_loadout_index = Managers.backend:get_interface("items"):get_selected_career_loadout(name)
end

HeroView._handle_new_ui_disclaimer = function (self)
	-- function 22
	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local tbl = {
		deus = {
			store = false,
			default = true,
			loot = false,
			system = false,
			achievements = false,
			keep_decorations = false
		},
		adventure = {
			store = false,
			default = true,
			loot = false,
			system = false,
			achievements = false,
			keep_decorations = false
		},
		default = {
			store = false,
			default = true,
			loot = false,
			system = false,
			achievements = false,
			keep_decorations = false
		}
	}
	local var_22_2 = tbl[current_mechanism_name]

	var_22_2 = var_22_2 or tbl.default

	local _on_enter_transition_params = self._on_enter_transition_params
	local menu_state_name

	if not _on_enter_transition_params then
		menu_state_name = _on_enter_transition_params.menu_state_name

		if not menu_state_name then
			-- Nothing
		end
	end

	menu_state_name = "default"

	::label_22_0::

	local flag = not _on_enter_transition_params and _on_enter_transition_params.menu_sub_state_name

	menu_state_name = var_22_2[flag] == nil or not flag or menu_state_name

	Managers.ui:handle_new_ui_disclaimer(var_22_2, menu_state_name)
end

HeroView.set_current_hero = function (self, arg_23_1)
	-- function 23
	local var_23_0 = SPProfiles[arg_23_1]
	local display_name = var_23_0.display_name
	local character_name = var_23_0.character_name

	self._hero_name = display_name
	self._state_machine_params.hero_name = display_name
end

HeroView._get_sorted_players = function (self)
	-- function 24
	local human_players = self.player_manager:human_players()
	local tbl = {}

	for k, v in pairs(human_players) do
		tbl[#tbl + 1] = v
	end

	table.sort(tbl, function (self, arg_25_1)
		-- function 25
		local local_player = self.local_player

		local_player = not local_player and not arg_25_1.local_player

		return local_player
	end)

	return tbl
end

HeroView._handle_mouse_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	-- function 26
	return
end

HeroView._is_selection_widget_pressed = function (arg_27_0, arg_27_1)
	-- function 27
	local content = arg_27_1.content
	local steps = content.steps

	for i = 1, steps do
		if not content["hotspot_" .. i].on_release then
			return true, i
		end
	end
end

HeroView.hotkey_allowed = function (self, arg_28_1, arg_28_2)
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
		local _get_screen_settings_by_state_name = self:_get_screen_settings_by_state_name(NAME)
		local name = _get_screen_settings_by_state_name.name

		if not _get_screen_settings_by_state_name.hotkey_disabled then
			return false
		end

		if name == transition_state then
			local get_selected_layout_name = state.get_selected_layout_name

			get_selected_layout_name = not get_selected_layout_name and state:get_selected_layout_name()

			if not (not transition_sub_state and transition_sub_state ~= get_selected_layout_name) then
				return true
			end
		end
	end

	return false
end

HeroView._get_screen_settings_by_state_name = function (arg_29_0, arg_29_1)
	-- function 29
	for i, v in ipairs(settings_by_screen) do
		if v.state_name == arg_29_1 then
			return v
		end
	end
end

HeroView.requested_screen_change_by_name = function (self, arg_30_1, arg_30_2)
	-- function 30
	self._requested_screen_change_data = {
		screen_name = arg_30_1,
		sub_screen_name = arg_30_2
	}
end

HeroView._change_screen_by_name = function (self, arg_31_1, arg_31_2, arg_31_3)
	-- function 31
	local find_by_key, var_31_1 = table.find_by_key(settings_by_screen, "name", arg_31_1)

	assert(find_by_key, "[HeroView] - Could not find state by name: %s", arg_31_1)

	local state_name = var_31_1.state_name
	local var_31_3 = rawget(_G, state_name)

	if not (not self._machine and arg_31_2) then
		self._wanted_state = var_31_3
	else
		self:_setup_state_machine(self._state_machine_params, var_31_3, arg_31_2, arg_31_3)
	end
end

HeroView._change_screen_by_index = function (self, arg_32_1)
	-- function 32
	local name = settings_by_screen[arg_32_1].name

	self:_change_screen_by_name(name)
end

HeroView.post_update_on_enter = function (self)
	-- function 33
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

HeroView.post_update_on_exit = function (self, arg_34_1, arg_34_2)
	-- function 34
	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	Managers.backend:commit()

	if not arg_34_2 then
		self:destroy_hdr_gui()
	end
end

HeroView.on_exit = function (self)
	-- function 35
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("HeroView")

	self.exiting = nil

	self:_handle_view_popups()
	Managers.music:unduck_sounds()

	self._draw_loading = false

	if self._is_in_tutorial or not self._loadout_dirty then
		local flag = true

		self._loadout_dirty = false

		if not Managers.state.network:game() then
			self._profile_requester:request_profile(self._peer_id, self._local_player_id, self._profile_name, self._career_name, flag)
		end
	end
end

HeroView.set_loadout_dirty = function (self)
	-- function 36
	self._loadout_dirty = true
end

HeroView.is_loadout_dirty = function (self)
	-- function 37
	return self._loadout_dirty
end

HeroView._handle_view_popups = function (self)
	-- function 38
	local console_friends_view = self.ingame_ui.views.console_friends_view

	if not console_friends_view then
		console_friends_view:cleanup_popups()
	end

	local options_view = self.ingame_ui.views.options_view

	if not options_view then
		options_view:cleanup_popups()
	end
end

HeroView.exit = function (self, arg_39_1, arg_39_2, arg_39_3)
	-- function 39
	local str = "exit_menu"

	self.exiting = true

	if not ((arg_39_3 or not self.is_in_inn) and self._force_ingame_menu) then
		self.ingame_ui:transition_with_fade(str)
	else
		self.ingame_ui:handle_transition(str)
	end

	if not arg_39_2 then
		self:play_sound("Play_hud_button_close")
	end
end

HeroView.transitioning = function (self)
	-- function 40
	if not self.exiting then
		return true
	else
		return false
	end
end

HeroView._handle_exit = function (arg_41_0, arg_41_1)
	-- function 41
	return
end

HeroView.suspend = function (self)
	-- function 42
	self.input_manager:device_unblock_all_services("keyboard", 1)
	self.input_manager:device_unblock_all_services("mouse", 1)
	self.input_manager:device_unblock_all_services("gamepad", 1)

	self.suspended = true
end

HeroView.unsuspend = function (self)
	-- function 43
	self.input_manager:block_device_except_service("hero_view", "keyboard", 1)
	self.input_manager:block_device_except_service("hero_view", "mouse", 1)
	self.input_manager:block_device_except_service("hero_view", "gamepad", 1)

	self.suspended = nil
end

HeroView.close_menu = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local flag = not arg_44_1

	self:exit(flag, arg_44_2, arg_44_3)
end

HeroView.destroy = function (self)
	-- function 45
	self.ingame_ui_context = nil
	self.ui_animator = nil

	if not self._machine then
		self._machine:destroy()

		self._machine = nil
	end

	self:destroy_hdr_gui()
end

HeroView.destroy_hdr_gui = function (self)
	-- function 46
	local _hdr_gui_data = self._hdr_gui_data

	if not _hdr_gui_data then
		for k, v in pairs(_hdr_gui_data) do
			local renderer = v.renderer
			local world = v.world
			local viewport_name = v.viewport_name

			UIRenderer.destroy(renderer, world)
			ScriptWorld.destroy_viewport(world, viewport_name)
			Managers.world:destroy_world(world)
		end

		self._hdr_gui_data = nil
	end
end

HeroView._is_button_pressed = function (arg_47_0, arg_47_1)
	-- function 47
	local button_hotspot = arg_47_1.content.button_hotspot

	if not button_hotspot.on_release then
		button_hotspot.on_release = false

		return true
	end
end

HeroView._set_loading_overlay_enabled = function (self, arg_48_1, arg_48_2)
	-- function 48
	local _loading_widgets = self._loading_widgets
	local text = _loading_widgets.text
	local background = _loading_widgets.background
	local flag

	flag = not arg_48_1 and 255 and 0
	background.style.color[1] = flag
	text.style.text.text_color[1] = flag
	text.content.text = arg_48_2 or ""
	self._draw_loading = arg_48_1
end

HeroView.current_state = function (self)
	-- function 49
	if not self._machine then
		return nil
	end

	return self._machine:state()
end
