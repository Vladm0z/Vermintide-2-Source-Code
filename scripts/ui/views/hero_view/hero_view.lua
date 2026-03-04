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
DLCUtils.map_list("hero_view", function (arg_1_0)
	require(arg_1_0.filename)
end)

local var_0_0 = local_require("scripts/ui/views/hero_view/hero_view_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.settings_by_screen
local var_0_4 = var_0_0.attachments
local var_0_5 = var_0_0.flow_events

local function var_0_6(...)
	print("[HeroView]", ...)
end

local var_0_7 = true
local var_0_8 = false
local var_0_9 = true

HeroView = class(HeroView)

HeroView.init = function (arg_3_0, arg_3_1)
	arg_3_0.world = arg_3_1.world
	arg_3_0.player_manager = arg_3_1.player_manager
	arg_3_0.ui_renderer = arg_3_1.ui_renderer
	arg_3_0.ui_top_renderer = arg_3_1.ui_top_renderer
	arg_3_0.ingame_ui = arg_3_1.ingame_ui
	arg_3_0.voting_manager = arg_3_1.voting_manager
	arg_3_0.profile_synchronizer = arg_3_1.profile_synchronizer
	arg_3_0.peer_id = arg_3_1.peer_id
	arg_3_0.local_player_id = arg_3_1.local_player_id
	arg_3_0.is_server = arg_3_1.is_server
	arg_3_0.is_in_inn = arg_3_1.is_in_inn
	arg_3_0.world_manager = arg_3_1.world_manager

	local var_3_0 = arg_3_0.world_manager:world("level_world")

	arg_3_0.wwise_world = Managers.world:wwise_world(var_3_0)

	local var_3_1 = arg_3_1.input_manager

	arg_3_0.input_manager = var_3_1

	var_3_1:create_input_service("hero_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_3_1:map_device_to_service("hero_view", "keyboard")
	var_3_1:map_device_to_service("hero_view", "mouse")
	var_3_1:map_device_to_service("hero_view", "gamepad")

	arg_3_0._state_machine_params = {
		wwise_world = arg_3_0.wwise_world,
		ingame_ui_context = arg_3_1,
		parent = arg_3_0,
		settings_by_screen = var_0_3,
		input_service = FAKE_INPUT_SERVICE
	}
	arg_3_0.units = {}
	arg_3_0.attachment_units = {}
	arg_3_0.unit_states = {}
	arg_3_0.ui_animations = {}
	arg_3_0.ingame_ui_context = arg_3_1
	var_0_7 = false
end

HeroView.initial_profile_view = function (arg_4_0)
	return arg_4_0.ingame_ui.initial_profile_view
end

HeroView._setup_state_machine = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_0._machine then
		arg_5_0._machine:destroy()

		arg_5_0._machine = nil
	end

	local var_5_0 = arg_5_2 or HeroViewStateOverview
	local var_5_1 = false

	arg_5_1.start_state = arg_5_3
	arg_5_1.state_params = arg_5_4
	arg_5_0._machine = GameStateMachine:new(arg_5_0, var_5_0, arg_5_1, var_5_1)
	arg_5_0._state_machine_params = arg_5_1
	arg_5_1.state_params = nil
end

HeroView.wanted_state = function (arg_6_0)
	return arg_6_0._wanted_state
end

HeroView.clear_wanted_state = function (arg_7_0)
	arg_7_0._wanted_state = nil
end

HeroView.input_service = function (arg_8_0)
	return arg_8_0._draw_loading and FAKE_INPUT_SERVICE or arg_8_0.input_manager:get_service("hero_view")
end

HeroView.set_input_blocked = function (arg_9_0, arg_9_1)
	arg_9_0._input_blocked = arg_9_1
end

HeroView.input_blocked = function (arg_10_0)
	return arg_10_0._input_blocked
end

HeroView.play_sound = function (arg_11_0, arg_11_1)
	WwiseWorld.trigger_event(arg_11_0.wwise_world, arg_11_1)
end

HeroView.create_ui_elements = function (arg_12_0)
	arg_12_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_12_0._static_widgets = {}
	arg_12_0._loading_widgets = {
		background = UIWidget.init(var_0_1.loading_bg),
		text = UIWidget.init(var_0_1.loading_text)
	}

	UIRenderer.clear_scenegraph_queue(arg_12_0.ui_renderer)

	arg_12_0.ui_animator = UIAnimator:new(arg_12_0.ui_scenegraph, var_0_0.animations)
end

HeroView._setup_hdr_gui = function (arg_13_0)
	if arg_13_0.is_in_inn then
		local var_13_0 = {}
		local var_13_1 = "hero_view_hdr"

		if var_13_1 then
			local var_13_2, var_13_3, var_13_4 = arg_13_0:_setup_hdr_renderer(var_13_1, 600)

			var_13_0.bottom = {
				renderer = var_13_2,
				world = var_13_3,
				viewport_name = var_13_4
			}
		end

		local var_13_5 = "hero_view_hdr_top"

		if var_13_5 then
			local var_13_6, var_13_7, var_13_8 = arg_13_0:_setup_hdr_renderer(var_13_5, 850)

			var_13_0.top = {
				renderer = var_13_6,
				world = var_13_7,
				viewport_name = var_13_8
			}
		end

		arg_13_0._hdr_gui_data = var_13_0
	end
end

HeroView._setup_hdr_renderer = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = {
		Application.DISABLE_SOUND,
		Application.DISABLE_ESRAM
	}
	local var_14_1 = arg_14_1
	local var_14_2 = arg_14_1
	local var_14_3 = "environment/ui_hdr"
	local var_14_4 = Managers.world:create_world(var_14_1, var_14_3, nil, arg_14_2, unpack(var_14_0))
	local var_14_5 = "overlay"
	local var_14_6 = ScriptWorld.create_viewport(var_14_4, var_14_2, var_14_5, 999)

	return arg_14_0.ingame_ui:create_ui_renderer(var_14_4, false, arg_14_0.is_in_inn), var_14_4, var_14_2
end

HeroView.hdr_renderer = function (arg_15_0)
	return arg_15_0._hdr_gui_data.bottom.renderer
end

HeroView.hdr_top_renderer = function (arg_16_0)
	return arg_16_0._hdr_gui_data.top.renderer
end

HeroView.draw = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_top_renderer
	local var_17_2 = arg_17_0.ui_scenegraph
	local var_17_3 = arg_17_0.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(var_17_0, var_17_2, arg_17_2, arg_17_1)

	if var_0_8 then
		UISceneGraph.debug_render_scenegraph(var_17_0, var_17_2)
	end

	for iter_17_0, iter_17_1 in ipairs(arg_17_0._static_widgets) do
		UIRenderer.draw_widget(var_17_0, iter_17_1)
	end

	if arg_17_0._draw_loading then
		UIRenderer.begin_pass(var_17_1, var_17_2, arg_17_2, arg_17_1)

		for iter_17_2, iter_17_3 in pairs(arg_17_0._loading_widgets) do
			UIRenderer.draw_widget(var_17_1, iter_17_3)
		end

		UIRenderer.end_pass(var_17_1)
	end

	UIRenderer.end_pass(var_17_0)
end

HeroView.post_update = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._machine:post_update(arg_18_1, arg_18_2)
end

HeroView.update = function (arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0.suspended or arg_19_0.waiting_for_post_update_enter then
		return
	end

	local var_19_0 = arg_19_0._requested_screen_change_data

	if var_19_0 then
		local var_19_1 = var_19_0.screen_name
		local var_19_2 = var_19_0.sub_screen_name

		arg_19_0:_change_screen_by_name(var_19_1, var_19_2)

		arg_19_0._requested_screen_change_data = nil
	end

	local var_19_3 = true
	local var_19_4 = arg_19_0.input_manager:is_device_active("gamepad")
	local var_19_5 = arg_19_0:input_blocked() and FAKE_INPUT_SERVICE or arg_19_0:input_service()

	arg_19_0._state_machine_params.input_service = var_19_5

	local var_19_6 = arg_19_0:transitioning()

	arg_19_0.ui_animator:update(arg_19_1)

	for iter_19_0, iter_19_1 in pairs(arg_19_0.ui_animations) do
		UIAnimation.update(iter_19_1, arg_19_1)

		if UIAnimation.completed(iter_19_1) then
			arg_19_0.ui_animations[iter_19_0] = nil
		end
	end

	if not var_19_6 then
		arg_19_0:_handle_mouse_input(arg_19_1, arg_19_2, var_19_5)
	end

	arg_19_0._machine:update(arg_19_1, arg_19_2)
	arg_19_0:draw(arg_19_1, var_19_5)
end

HeroView.on_enter = function (arg_20_0, arg_20_1)
	arg_20_0._force_ingame_menu = arg_20_1.force_ingame_menu

	if not arg_20_0._force_ingame_menu then
		arg_20_0:_setup_hdr_gui()
	end

	ShowCursorStack.show("HeroView")

	local var_20_0 = arg_20_0.input_manager

	var_20_0:block_device_except_service("hero_view", "keyboard", 1)
	var_20_0:block_device_except_service("hero_view", "mouse", 1)
	var_20_0:block_device_except_service("hero_view", "gamepad", 1)

	arg_20_0._state_machine_params.initial_state = true

	arg_20_0:create_ui_elements()

	local var_20_1 = arg_20_0.profile_synchronizer:profile_by_peer(arg_20_0.peer_id, arg_20_0.local_player_id) or 1

	arg_20_0:set_current_hero(var_20_1)

	arg_20_0.waiting_for_post_update_enter = true
	arg_20_0._loadout_dirty = false
	arg_20_0._on_enter_transition_params = arg_20_1

	Managers.music:duck_sounds()

	arg_20_0._draw_loading = false

	arg_20_0:_handle_new_ui_disclaimer()
	arg_20_0:_fetch_initial_loadout_index(arg_20_1)
end

HeroView._fetch_initial_loadout_index = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._state_machine_params.ingame_ui_context

	arg_21_0._is_in_tutorial = var_21_0.is_in_tutorial

	if arg_21_0._is_in_tutorial then
		return
	end

	local var_21_1 = Managers.state.game_mode:game_mode_key()

	if not InventorySettings.inventory_loadout_access_supported_game_modes[var_21_1] then
		return
	end

	arg_21_0._peer_id = var_21_0.peer_id
	arg_21_0._local_player_id = var_21_0.local_player_id
	arg_21_0._profile_requester = (var_21_0.network_server or var_21_0.network_client):profile_requester()
	arg_21_0._profile_synchronizer = var_21_0.profile_synchronizer

	local var_21_2, var_21_3 = arg_21_0._profile_synchronizer:profile_by_peer(arg_21_0._peer_id, arg_21_0._local_player_id)
	local var_21_4 = SPProfiles[var_21_2]
	local var_21_5 = var_21_4.careers[var_21_3].name

	arg_21_0._profile_name = var_21_4.display_name
	arg_21_0._career_name = var_21_5
	arg_21_0._initial_loadout_index = Managers.backend:get_interface("items"):get_selected_career_loadout(var_21_5)
end

HeroView._handle_new_ui_disclaimer = function (arg_22_0)
	local var_22_0 = Managers.mechanism:current_mechanism_name()
	local var_22_1 = {
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
	local var_22_2 = var_22_1[var_22_0] or var_22_1.default
	local var_22_3 = arg_22_0._on_enter_transition_params
	local var_22_4 = var_22_3 and var_22_3.menu_state_name or "default"
	local var_22_5 = var_22_3 and var_22_3.menu_sub_state_name

	var_22_4 = var_22_2[var_22_5] ~= nil and var_22_5 or var_22_4

	Managers.ui:handle_new_ui_disclaimer(var_22_2, var_22_4)
end

HeroView.set_current_hero = function (arg_23_0, arg_23_1)
	local var_23_0 = SPProfiles[arg_23_1]
	local var_23_1 = var_23_0.display_name
	local var_23_2 = var_23_0.character_name

	arg_23_0._hero_name = var_23_1
	arg_23_0._state_machine_params.hero_name = var_23_1
end

HeroView._get_sorted_players = function (arg_24_0)
	local var_24_0 = arg_24_0.player_manager:human_players()
	local var_24_1 = {}

	for iter_24_0, iter_24_1 in pairs(var_24_0) do
		var_24_1[#var_24_1 + 1] = iter_24_1
	end

	table.sort(var_24_1, function (arg_25_0, arg_25_1)
		return arg_25_0.local_player and not arg_25_1.local_player
	end)

	return var_24_1
end

HeroView._handle_mouse_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	return
end

HeroView._is_selection_widget_pressed = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.content
	local var_27_1 = var_27_0.steps

	for iter_27_0 = 1, var_27_1 do
		if var_27_0["hotspot_" .. iter_27_0].on_release then
			return true, iter_27_0
		end
	end
end

HeroView.hotkey_allowed = function (arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0:input_blocked() then
		return false
	end

	local var_28_0 = arg_28_2.transition_state
	local var_28_1 = arg_28_2.transition_sub_state
	local var_28_2 = arg_28_0._machine

	if var_28_2 then
		local var_28_3 = var_28_2:state()
		local var_28_4 = var_28_3.NAME
		local var_28_5 = arg_28_0:_get_screen_settings_by_state_name(var_28_4)
		local var_28_6 = var_28_5.name

		if var_28_5.hotkey_disabled then
			return false
		end

		if var_28_6 == var_28_0 then
			local var_28_7 = var_28_3.get_selected_layout_name and var_28_3:get_selected_layout_name()

			if not var_28_1 or var_28_1 == var_28_7 then
				return true
			end
		end
	end

	return false
end

HeroView._get_screen_settings_by_state_name = function (arg_29_0, arg_29_1)
	for iter_29_0, iter_29_1 in ipairs(var_0_3) do
		if iter_29_1.state_name == arg_29_1 then
			return iter_29_1
		end
	end
end

HeroView.requested_screen_change_by_name = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._requested_screen_change_data = {
		screen_name = arg_30_1,
		sub_screen_name = arg_30_2
	}
end

HeroView._change_screen_by_name = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0, var_31_1 = table.find_by_key(var_0_3, "name", arg_31_1)

	assert(var_31_0, "[HeroView] - Could not find state by name: %s", arg_31_1)

	local var_31_2 = var_31_1.state_name
	local var_31_3 = rawget(_G, var_31_2)

	if arg_31_0._machine and not arg_31_2 then
		arg_31_0._wanted_state = var_31_3
	else
		arg_31_0:_setup_state_machine(arg_31_0._state_machine_params, var_31_3, arg_31_2, arg_31_3)
	end
end

HeroView._change_screen_by_index = function (arg_32_0, arg_32_1)
	local var_32_0 = var_0_3[arg_32_1].name

	arg_32_0:_change_screen_by_name(var_32_0)
end

HeroView.post_update_on_enter = function (arg_33_0)
	arg_33_0.waiting_for_post_update_enter = nil

	local var_33_0 = arg_33_0._on_enter_transition_params

	if var_33_0 and var_33_0.menu_state_name then
		local var_33_1 = var_33_0.menu_state_name
		local var_33_2 = var_33_0.menu_sub_state_name

		arg_33_0:_change_screen_by_name(var_33_1, var_33_2, var_33_0)

		arg_33_0._on_enter_transition_params = nil
	else
		arg_33_0:_change_screen_by_index(1)
	end
end

HeroView.post_update_on_exit = function (arg_34_0, arg_34_1, arg_34_2)
	if arg_34_0._machine then
		arg_34_0._machine:destroy()

		arg_34_0._machine = nil
	end

	Managers.backend:commit()

	if not arg_34_2 then
		arg_34_0:destroy_hdr_gui()
	end
end

HeroView.on_exit = function (arg_35_0)
	arg_35_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_35_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_35_0.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("HeroView")

	arg_35_0.exiting = nil

	arg_35_0:_handle_view_popups()
	Managers.music:unduck_sounds()

	arg_35_0._draw_loading = false

	if not arg_35_0._is_in_tutorial and arg_35_0._loadout_dirty then
		local var_35_0 = true

		arg_35_0._loadout_dirty = false

		if Managers.state.network:game() then
			arg_35_0._profile_requester:request_profile(arg_35_0._peer_id, arg_35_0._local_player_id, arg_35_0._profile_name, arg_35_0._career_name, var_35_0)
		end
	end
end

HeroView.set_loadout_dirty = function (arg_36_0)
	arg_36_0._loadout_dirty = true
end

HeroView.is_loadout_dirty = function (arg_37_0)
	return arg_37_0._loadout_dirty
end

HeroView._handle_view_popups = function (arg_38_0)
	local var_38_0 = arg_38_0.ingame_ui.views.console_friends_view

	if var_38_0 then
		var_38_0:cleanup_popups()
	end

	local var_38_1 = arg_38_0.ingame_ui.views.options_view

	if var_38_1 then
		var_38_1:cleanup_popups()
	end
end

HeroView.exit = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3)
	local var_39_0 = "exit_menu"

	arg_39_0.exiting = true

	if not arg_39_3 and arg_39_0.is_in_inn and not arg_39_0._force_ingame_menu then
		arg_39_0.ingame_ui:transition_with_fade(var_39_0)
	else
		arg_39_0.ingame_ui:handle_transition(var_39_0)
	end

	if not arg_39_2 then
		arg_39_0:play_sound("Play_hud_button_close")
	end
end

HeroView.transitioning = function (arg_40_0)
	if arg_40_0.exiting then
		return true
	else
		return false
	end
end

HeroView._handle_exit = function (arg_41_0, arg_41_1)
	return
end

HeroView.suspend = function (arg_42_0)
	arg_42_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_42_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_42_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_42_0.suspended = true
end

HeroView.unsuspend = function (arg_43_0)
	arg_43_0.input_manager:block_device_except_service("hero_view", "keyboard", 1)
	arg_43_0.input_manager:block_device_except_service("hero_view", "mouse", 1)
	arg_43_0.input_manager:block_device_except_service("hero_view", "gamepad", 1)

	arg_43_0.suspended = nil
end

HeroView.close_menu = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = not arg_44_1

	arg_44_0:exit(var_44_0, arg_44_2, arg_44_3)
end

HeroView.destroy = function (arg_45_0)
	arg_45_0.ingame_ui_context = nil
	arg_45_0.ui_animator = nil

	if arg_45_0._machine then
		arg_45_0._machine:destroy()

		arg_45_0._machine = nil
	end

	arg_45_0:destroy_hdr_gui()
end

HeroView.destroy_hdr_gui = function (arg_46_0)
	local var_46_0 = arg_46_0._hdr_gui_data

	if var_46_0 then
		for iter_46_0, iter_46_1 in pairs(var_46_0) do
			local var_46_1 = iter_46_1.renderer
			local var_46_2 = iter_46_1.world
			local var_46_3 = iter_46_1.viewport_name

			UIRenderer.destroy(var_46_1, var_46_2)
			ScriptWorld.destroy_viewport(var_46_2, var_46_3)
			Managers.world:destroy_world(var_46_2)
		end

		arg_46_0._hdr_gui_data = nil
	end
end

HeroView._is_button_pressed = function (arg_47_0, arg_47_1)
	local var_47_0 = arg_47_1.content.button_hotspot

	if var_47_0.on_release then
		var_47_0.on_release = false

		return true
	end
end

HeroView._set_loading_overlay_enabled = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0._loading_widgets
	local var_48_1 = var_48_0.text
	local var_48_2 = var_48_0.background
	local var_48_3 = arg_48_1 and 255 or 0

	var_48_2.style.color[1] = var_48_3
	var_48_1.style.text.text_color[1] = var_48_3
	var_48_1.content.text = arg_48_2 or ""
	arg_48_0._draw_loading = arg_48_1
end

HeroView.current_state = function (arg_49_0)
	if not arg_49_0._machine then
		return nil
	end

	return arg_49_0._machine:state()
end
