-- chunkname: @scripts/ui/views/character_selection_view/character_selection_view.lua

require("scripts/ui/views/hero_view/item_grid_ui")
require("scripts/ui/views/character_selection_view/states/character_selection_state_character")
require("scripts/ui/views/character_selection_view/states/character_selection_state_versus_loadouts")
require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/character_selection_view/character_selection_view_definitions")
local var_0_1 = var_0_0.widgets_definitions
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.settings_by_screen
local var_0_4 = var_0_0.attachments
local var_0_5 = var_0_0.flow_events

local function var_0_6(...)
	print("[CharacterSelectionView]", ...)
end

local var_0_7 = true
local var_0_8 = false
local var_0_9 = true

CharacterSelectionView = class(CharacterSelectionView)

CharacterSelectionView.init = function (arg_2_0, arg_2_1)
	arg_2_0.world = arg_2_1.world
	arg_2_0.player_manager = arg_2_1.player_manager
	arg_2_0.ui_renderer = arg_2_1.ui_renderer
	arg_2_0.ui_top_renderer = arg_2_1.ui_top_renderer
	arg_2_0.ingame_ui = arg_2_1.ingame_ui
	arg_2_0.profile_synchronizer = arg_2_1.profile_synchronizer
	arg_2_0.peer_id = arg_2_1.peer_id
	arg_2_0.local_player_id = arg_2_1.local_player_id
	arg_2_0.is_server = arg_2_1.is_server
	arg_2_0.is_in_inn = arg_2_1.is_in_inn
	arg_2_0.voting_manager = arg_2_1.voting_manager
	arg_2_0.world_manager = arg_2_1.world_manager

	local var_2_0 = arg_2_0.world_manager:world("level_world")

	arg_2_0.wwise_world = Managers.world:wwise_world(var_2_0)

	local var_2_1 = arg_2_1.input_manager

	arg_2_0.input_manager = var_2_1

	var_2_1:create_input_service("character_selection_view", "IngameMenuKeymaps", "IngameMenuFilters")
	var_2_1:map_device_to_service("character_selection_view", "keyboard")
	var_2_1:map_device_to_service("character_selection_view", "mouse")
	var_2_1:map_device_to_service("character_selection_view", "gamepad")

	arg_2_0.world_previewer = MenuWorldPreviewer:new(arg_2_1, UISettings.hero_selection_camera_position_by_character, "CharacterSelectionView")

	arg_2_0.world_previewer:force_stream_highest_mip_levels()

	arg_2_0._state_machine_params = {
		wwise_world = arg_2_0.wwise_world,
		ingame_ui_context = arg_2_1,
		parent = arg_2_0,
		world_previewer = arg_2_0.world_previewer,
		settings_by_screen = var_0_3,
		input_service = FAKE_INPUT_SERVICE
	}
	arg_2_0.units = {}
	arg_2_0.attachment_units = {}
	arg_2_0.unit_states = {}
	arg_2_0.ui_animations = {}
	arg_2_0.ingame_ui_context = arg_2_1
	var_0_7 = false

	arg_2_0:show_hero_panel()
end

CharacterSelectionView.initial_profile_view = function (arg_3_0)
	return arg_3_0.ingame_ui.initial_profile_view
end

CharacterSelectionView._setup_state_machine = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	if arg_4_0._machine then
		arg_4_0._machine:destroy()

		arg_4_0._machine = nil
	end

	local var_4_0 = arg_4_2 or CharacterSelectionStateCharacter
	local var_4_1 = false

	arg_4_1.allow_back_button = not arg_4_0:initial_profile_view()
	arg_4_1.start_state = arg_4_3
	arg_4_1.state_params = arg_4_4

	if arg_4_0._pick_time then
		arg_4_1.pick_time = arg_4_0._pick_time
	end

	if arg_4_0._profile_id then
		arg_4_1.profile_id = arg_4_0._profile_id
		arg_4_1.career_id = arg_4_0._career_id
	end

	arg_4_0._machine = GameStateMachine:new(arg_4_0, var_4_0, arg_4_1, var_4_1)
	arg_4_0._state_machine_params = arg_4_1
	arg_4_1.state_params = nil
end

CharacterSelectionView.wanted_state = function (arg_5_0)
	return arg_5_0._wanted_state
end

CharacterSelectionView.clear_wanted_state = function (arg_6_0)
	arg_6_0._wanted_state = nil
end

CharacterSelectionView.input_service = function (arg_7_0, arg_7_1)
	if arg_7_1 then
		return arg_7_0.input_manager:get_service("character_selection_view")
	else
		return arg_7_0._input_blocked and FAKE_INPUT_SERVICE or arg_7_0.input_manager:get_service("character_selection_view")
	end
end

CharacterSelectionView.set_input_blocked = function (arg_8_0, arg_8_1)
	arg_8_0._input_blocked = arg_8_1
end

CharacterSelectionView.input_blocked = function (arg_9_0)
	return arg_9_0._input_blocked
end

CharacterSelectionView.play_sound = function (arg_10_0, arg_10_1)
	WwiseWorld.trigger_event(arg_10_0.wwise_world, arg_10_1)
end

CharacterSelectionView.create_ui_elements = function (arg_11_0)
	arg_11_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_11_0._static_widgets = {}
	arg_11_0._title_widget = UIWidget.init(var_0_1.title_text)
	arg_11_0._hero_name_text_widget = UIWidget.init(var_0_1.hero_name_text)
	arg_11_0._hero_level_text_widget = UIWidget.init(var_0_1.hero_level_text)
	arg_11_0._hero_prestige_level_text_widget = UIWidget.init(var_0_1.hero_prestige_level_text)
	arg_11_0._title_description_widget = UIWidget.init(var_0_1.title_description_text)
	arg_11_0._exit_button_widget = UIWidget.init(var_0_1.exit_button)

	UIRenderer.clear_scenegraph_queue(arg_11_0.ui_top_renderer)

	arg_11_0.ui_animator = UIAnimator:new(arg_11_0.ui_scenegraph, var_0_0.animations)
end

CharacterSelectionView.get_background_world = function (arg_12_0)
	local var_12_0 = arg_12_0.viewport_widget.element.pass_data[1]
	local var_12_1 = var_12_0.viewport

	return var_12_0.world, var_12_1
end

CharacterSelectionView.show_hero_world = function (arg_13_0)
	if not arg_13_0._draw_menu_world then
		arg_13_0._draw_menu_world = true

		local var_13_0 = "player_1"
		local var_13_1 = Managers.world:world("level_world")
		local var_13_2 = ScriptWorld.viewport(var_13_1, var_13_0)

		ScriptWorld.deactivate_viewport(var_13_1, var_13_2)
	end
end

CharacterSelectionView.hide_hero_world = function (arg_14_0)
	if arg_14_0._draw_menu_world then
		arg_14_0._draw_menu_world = false

		local var_14_0 = "player_1"
		local var_14_1 = Managers.world:world("level_world")
		local var_14_2 = ScriptWorld.viewport(var_14_1, var_14_0)

		ScriptWorld.activate_viewport(var_14_1, var_14_2)
	end
end

CharacterSelectionView.show_hero_panel = function (arg_15_0)
	arg_15_0._draw_menu_panel = not arg_15_0:initial_profile_view()

	arg_15_0:set_input_blocked(false)
end

CharacterSelectionView.hide_hero_panel = function (arg_16_0)
	arg_16_0._draw_menu_panel = false

	arg_16_0:set_input_blocked(true)
end

CharacterSelectionView.draw = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_top_renderer
	local var_17_2 = arg_17_0.ui_scenegraph
	local var_17_3 = arg_17_0.input_manager:is_device_active("gamepad")

	UIRenderer.begin_pass(var_17_1, var_17_2, arg_17_2, arg_17_1)

	if var_0_8 then
		UISceneGraph.debug_render_scenegraph(var_17_1, var_17_2)
	end

	if arg_17_0._draw_menu_panel then
		UIRenderer.draw_widget(var_17_1, arg_17_0._exit_button_widget)

		for iter_17_0, iter_17_1 in ipairs(arg_17_0._static_widgets) do
			UIRenderer.draw_widget(var_17_1, iter_17_1)
		end
	end

	if arg_17_0.viewport_widget and arg_17_0._draw_menu_world then
		UIRenderer.draw_widget(var_17_1, arg_17_0.viewport_widget)
	end

	UIRenderer.end_pass(var_17_1)
end

CharacterSelectionView.post_update = function (arg_18_0, arg_18_1, arg_18_2)
	arg_18_0._machine:post_update(arg_18_1, arg_18_2)
	arg_18_0.world_previewer:post_update(arg_18_1, arg_18_2)
end

CharacterSelectionView.update = function (arg_19_0, arg_19_1, arg_19_2)
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
	local var_19_4 = arg_19_0.input_manager
	local var_19_5 = var_19_4:is_device_active("gamepad")
	local var_19_6 = arg_19_0:input_blocked() and not var_19_5 and FAKE_INPUT_SERVICE or var_19_4:get_service("character_selection_view")

	arg_19_0._state_machine_params.input_service = var_19_6

	local var_19_7 = arg_19_0:transitioning()

	arg_19_0.ui_animator:update(arg_19_1)
	arg_19_0.world_previewer:update(arg_19_1, arg_19_2)

	for iter_19_0, iter_19_1 in pairs(arg_19_0.ui_animations) do
		UIAnimation.update(iter_19_1, arg_19_1)

		if UIAnimation.completed(iter_19_1) then
			arg_19_0.ui_animations[iter_19_0] = nil
		end
	end

	arg_19_0._machine:update(arg_19_1, arg_19_2)

	if not var_19_7 then
		if arg_19_0:_has_active_level_vote() then
			arg_19_0:play_sound("play_gui_start_menu_button_click")
			arg_19_0:close_menu()
		else
			arg_19_0:_handle_mouse_input(arg_19_1, arg_19_2, var_19_6)
			arg_19_0:_handle_exit(arg_19_1, var_19_6)
		end
	end

	arg_19_0:draw(arg_19_1, var_19_6)
end

CharacterSelectionView._has_active_level_vote = function (arg_20_0)
	local var_20_0 = arg_20_0.voting_manager

	return var_20_0:vote_in_progress() and var_20_0:is_mission_vote() and not var_20_0:has_voted(Network.peer_id())
end

CharacterSelectionView.on_enter = function (arg_21_0, arg_21_1)
	ShowCursorStack.show("CharacterSelectionView")

	local var_21_0 = arg_21_0.input_manager

	var_21_0:block_device_except_service("character_selection_view", "keyboard", 1)
	var_21_0:block_device_except_service("character_selection_view", "mouse", 1)
	var_21_0:block_device_except_service("character_selection_view", "gamepad", 1)

	arg_21_0._state_machine_params.initial_state = true

	arg_21_0:create_ui_elements()

	local var_21_1 = arg_21_1.pick_time

	if var_21_1 then
		arg_21_0._pick_time = var_21_1
	end

	local var_21_2 = arg_21_1.profile_id

	if var_21_2 and var_21_2 > 0 then
		arg_21_0._profile_id = var_21_2
		arg_21_0._career_id = arg_21_1.career_id

		arg_21_0:set_current_hero(var_21_2)
	else
		local var_21_3 = arg_21_0.profile_synchronizer:profile_by_peer(arg_21_0.peer_id, arg_21_0.local_player_id)

		if var_21_3 then
			arg_21_0:set_current_hero(var_21_3)
		end
	end

	arg_21_0.waiting_for_post_update_enter = true
	arg_21_0._on_enter_transition_params = arg_21_1

	if arg_21_0:initial_profile_view() then
		arg_21_0:hide_hero_panel()
	else
		arg_21_0:show_hero_panel()
	end

	Managers.music:duck_sounds()
	arg_21_0:play_sound("play_gui_amb_hero_screen_loop_begin")

	local var_21_4 = Managers.player:local_player()
	local var_21_5 = var_21_4 and var_21_4.player_unit

	if var_21_5 then
		local var_21_6 = ScriptUnit.has_extension(var_21_5, "inventory_system")

		if var_21_6 then
			var_21_6:check_and_drop_pickups("enter_inventory")
		end
	end

	UISettings.hero_fullscreen_menu_on_enter()

	arg_21_0._exit_transition = arg_21_1.exit_transition
	arg_21_0._exit_transition_params = arg_21_1.exit_transition_params
end

CharacterSelectionView.set_current_hero = function (arg_22_0, arg_22_1)
	local var_22_0 = SPProfiles[arg_22_1]
	local var_22_1 = var_22_0.display_name
	local var_22_2 = var_22_0.character_name

	arg_22_0._hero_name = var_22_1
	arg_22_0._state_machine_params.hero_name = var_22_1
	arg_22_0._hero_name_text_widget.content.text = Localize(var_22_2)
	arg_22_0._hero_level_text_widget.content.text = Localize(var_22_1)

	local var_22_3 = Managers.backend:get_interface("hero_attributes"):get(var_22_1, "prestige")

	if var_22_3 then
		arg_22_0:set_prestige_level(var_22_3)
	end
end

CharacterSelectionView._get_sorted_players = function (arg_23_0)
	local var_23_0 = arg_23_0.player_manager:human_players()
	local var_23_1 = {}

	for iter_23_0, iter_23_1 in pairs(var_23_0) do
		var_23_1[#var_23_1 + 1] = iter_23_1
	end

	table.sort(var_23_1, function (arg_24_0, arg_24_1)
		return arg_24_0.local_player and not arg_24_1.local_player
	end)

	return var_23_1
end

CharacterSelectionView.set_prestige_level = function (arg_25_0, arg_25_1)
	if arg_25_1 > 0 then
		arg_25_0._hero_prestige_level_text_widget.content.text = "Prestige level: " .. arg_25_1
	else
		arg_25_0._hero_prestige_level_text_widget.content.text = ""
	end
end

CharacterSelectionView._handle_mouse_input = function (arg_26_0, arg_26_1, arg_26_2, arg_26_3)
	return
end

CharacterSelectionView._is_selection_widget_pressed = function (arg_27_0, arg_27_1)
	local var_27_0 = arg_27_1.content
	local var_27_1 = var_27_0.steps

	for iter_27_0 = 1, var_27_1 do
		if var_27_0["hotspot_" .. iter_27_0].on_release then
			return true, iter_27_0
		end
	end
end

CharacterSelectionView.hotkey_allowed = function (arg_28_0, arg_28_1, arg_28_2)
	if arg_28_0:input_blocked() then
		return false
	end

	local var_28_0 = arg_28_2.transition_state
	local var_28_1 = arg_28_2.transition_sub_state
	local var_28_2 = arg_28_0._machine

	if var_28_2 then
		local var_28_3 = var_28_2:state()
		local var_28_4 = var_28_3.NAME

		if arg_28_0:_get_screen_settings_by_state_name(var_28_4).name == var_28_0 then
			local var_28_5 = var_28_3.get_selected_layout_name and var_28_3:get_selected_layout_name()

			if not var_28_1 or var_28_1 == var_28_5 then
				return true
			elseif var_28_1 then
				var_28_3:requested_screen_change_by_name(var_28_1)
			end
		elseif var_28_0 then
			arg_28_0:requested_screen_change_by_name(var_28_0, var_28_1)
		else
			return true
		end
	end

	return false
end

CharacterSelectionView._get_screen_settings_by_state_name = function (arg_29_0, arg_29_1)
	for iter_29_0, iter_29_1 in ipairs(var_0_3) do
		if iter_29_1.state_name == arg_29_1 then
			return iter_29_1
		end
	end
end

CharacterSelectionView.requested_screen_change_by_name = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_0._requested_screen_change_data = {
		screen_name = arg_30_1,
		sub_screen_name = arg_30_2
	}
end

CharacterSelectionView._change_screen_by_name = function (arg_31_0, arg_31_1, arg_31_2, arg_31_3)
	local var_31_0
	local var_31_1

	for iter_31_0, iter_31_1 in ipairs(var_0_3) do
		if iter_31_1.name == arg_31_1 then
			var_31_0 = iter_31_1
			var_31_1 = iter_31_0

			break
		end
	end

	fassert(var_31_1, "[CharacterSelectionView] - Could not find state by name %s", arg_31_1)

	arg_31_0._title_widget.content.text = var_31_0.display_name
	arg_31_0._title_description_widget.content.text = var_31_0.description

	local var_31_2 = var_31_0.state_name
	local var_31_3 = rawget(_G, var_31_2)

	if arg_31_0._machine and not arg_31_2 then
		arg_31_0._wanted_state = var_31_3
	else
		arg_31_0:_setup_state_machine(arg_31_0._state_machine_params, var_31_3, arg_31_2, arg_31_3)
	end

	if var_31_0.draw_background_world then
		arg_31_0:show_hero_world()
	else
		arg_31_0:hide_hero_world()
	end

	local var_31_4 = var_31_0.camera_position

	if var_31_4 then
		arg_31_0.world_previewer:set_camera_axis_offset("x", var_31_4[1], 0.5, math.easeOutCubic)
		arg_31_0.world_previewer:set_camera_axis_offset("y", var_31_4[2], 0.5, math.easeOutCubic)
		arg_31_0.world_previewer:set_camera_axis_offset("z", var_31_4[3], 0.5, math.easeOutCubic)
	end

	local var_31_5 = var_31_0.camera_rotation

	if var_31_5 then
		arg_31_0.world_previewer:set_camera_rotation_axis_offset("x", var_31_5[1], 0.5, math.easeOutCubic)
		arg_31_0.world_previewer:set_camera_rotation_axis_offset("y", var_31_5[2], 0.5, math.easeOutCubic)
		arg_31_0.world_previewer:set_camera_rotation_axis_offset("z", var_31_5[3], 0.5, math.easeOutCubic)
	end
end

CharacterSelectionView._change_screen_by_index = function (arg_32_0, arg_32_1)
	local var_32_0 = var_0_3[arg_32_1].name

	arg_32_0:_change_screen_by_name(var_32_0)
end

CharacterSelectionView.post_update_on_enter = function (arg_33_0)
	fassert(arg_33_0.viewport_widget == nil, "[CharacterSelectionView:post_update_on_enter] viewport already created")

	arg_33_0.viewport_widget = UIWidget.init(var_0_1.viewport)
	arg_33_0.waiting_for_post_update_enter = nil

	arg_33_0.world_previewer:on_enter(arg_33_0.viewport_widget, arg_33_0._hero_name)

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

CharacterSelectionView.post_update_on_exit = function (arg_34_0)
	arg_34_0.world_previewer:prepare_exit()
	arg_34_0.world_previewer:on_exit()

	if arg_34_0.viewport_widget then
		UIWidget.destroy(arg_34_0.ui_top_renderer, arg_34_0.viewport_widget)

		arg_34_0.viewport_widget = nil
	end
end

CharacterSelectionView.on_exit = function (arg_35_0, arg_35_1)
	arg_35_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_35_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_35_0.input_manager:device_unblock_all_services("gamepad", 1)
	ShowCursorStack.hide("CharacterSelectionView")

	arg_35_0.exiting = nil

	if arg_35_0._machine then
		arg_35_0._machine:destroy()

		arg_35_0._machine = nil
	end

	arg_35_0:hide_hero_world()
	Managers.music:unduck_sounds()
	arg_35_0:play_sound("play_gui_amb_hero_screen_loop_end")
	UISettings.hero_fullscreen_menu_on_exit()
end

CharacterSelectionView.exit = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_0._exit_transition or arg_36_0:initial_profile_view() and "exit_initial_character_selection" or "exit_menu"

	arg_36_0.ingame_ui:transition_with_fade(var_36_0, arg_36_0._exit_transition_params)

	if IS_WINDOWS and arg_36_0:initial_profile_view() then
		arg_36_0:play_sound("Play_hero_selected_game_start")
	else
		arg_36_0:play_sound("Play_hud_button_close")
	end

	arg_36_0.exiting = true

	Managers.save:auto_save(SaveFileName, SaveData)
	Managers.backend:commit()
end

CharacterSelectionView.transitioning = function (arg_37_0)
	if arg_37_0.exiting then
		return true
	else
		return false
	end
end

CharacterSelectionView.suspend = function (arg_38_0)
	arg_38_0.input_manager:device_unblock_all_services("keyboard", 1)
	arg_38_0.input_manager:device_unblock_all_services("mouse", 1)
	arg_38_0.input_manager:device_unblock_all_services("gamepad", 1)

	arg_38_0.suspended = true

	local var_38_0 = "player_1"
	local var_38_1 = Managers.world:world("level_world")
	local var_38_2 = ScriptWorld.viewport(var_38_1, var_38_0)

	ScriptWorld.activate_viewport(var_38_1, var_38_2)

	local var_38_3 = arg_38_0.viewport_widget.element.pass_data[1]
	local var_38_4 = var_38_3.viewport
	local var_38_5 = var_38_3.world

	ScriptWorld.deactivate_viewport(var_38_5, var_38_4)
end

CharacterSelectionView.unsuspend = function (arg_39_0)
	arg_39_0.input_manager:block_device_except_service("character_selection_view", "keyboard", 1)
	arg_39_0.input_manager:block_device_except_service("character_selection_view", "mouse", 1)
	arg_39_0.input_manager:block_device_except_service("character_selection_view", "gamepad", 1)

	arg_39_0.suspended = nil

	if arg_39_0.viewport_widget then
		local var_39_0 = "player_1"
		local var_39_1 = Managers.world:world("level_world")
		local var_39_2 = ScriptWorld.viewport(var_39_1, var_39_0)

		ScriptWorld.deactivate_viewport(var_39_1, var_39_2)

		local var_39_3 = arg_39_0.viewport_widget.element.pass_data[1]
		local var_39_4 = var_39_3.viewport
		local var_39_5 = var_39_3.world

		ScriptWorld.activate_viewport(var_39_5, var_39_4)
	end
end

CharacterSelectionView._handle_exit = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0:initial_profile_view()
	local var_40_1 = arg_40_0._exit_button_widget

	UIWidgetUtils.animate_default_button(var_40_1, arg_40_1)

	if not var_40_0 then
		if var_40_1.content.button_hotspot.on_hover_enter then
			arg_40_0:play_sound("play_gui_start_menu_button_hover")
		end

		if var_40_1.content.button_hotspot.on_release or arg_40_2:get("toggle_menu") then
			arg_40_0:play_sound("play_gui_start_menu_button_click")
			arg_40_0:close_menu(not arg_40_0.exit_to_game)
		end
	end
end

CharacterSelectionView.get_exit_button_widget = function (arg_41_0)
	return arg_41_0._exit_button_widget
end

CharacterSelectionView.close_menu = function (arg_42_0, arg_42_1)
	local var_42_0 = not arg_42_1

	arg_42_0:exit(var_42_0)
end

CharacterSelectionView.destroy = function (arg_43_0)
	if arg_43_0.viewport_widget then
		UIWidget.destroy(arg_43_0.ui_top_renderer, arg_43_0.viewport_widget)

		arg_43_0.viewport_widget = nil
	end

	arg_43_0.ingame_ui_context = nil
	arg_43_0.ui_animator = nil

	local var_43_0 = "player_1"
	local var_43_1 = Managers.world:world("level_world")
	local var_43_2 = ScriptWorld.viewport(var_43_1, var_43_0)

	ScriptWorld.activate_viewport(var_43_1, var_43_2)

	if arg_43_0._machine then
		arg_43_0._machine:destroy()

		arg_43_0._machine = nil
	end
end

CharacterSelectionView._is_button_pressed = function (arg_44_0, arg_44_1)
	local var_44_0 = arg_44_1.content.button_hotspot

	if var_44_0.on_release then
		var_44_0.on_release = false

		return true
	end
end
