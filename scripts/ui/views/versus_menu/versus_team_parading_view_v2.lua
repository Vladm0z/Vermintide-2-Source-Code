-- chunkname: @scripts/ui/views/versus_menu/versus_team_parading_view_v2.lua

require("scripts/ui/views/menu_world_previewer")

local var_0_0 = local_require("scripts/ui/views/versus_menu/versus_team_parading_view_v2_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.bottom_widgets_definitions
local var_0_3 = var_0_0.top_widgets_definitions
local var_0_4 = var_0_0.team_portrait_frame_widgets
local var_0_5 = var_0_0.transition_widget_definitions
local var_0_6 = var_0_0.animation_definitions
local var_0_7 = var_0_0.create_player_name_career_text
local var_0_8 = var_0_0.view_settings
local var_0_9 = DLCSettings.carousel

VersusTeamParadingViewV2 = class(VersusTeamParadingViewV2)
VersusTeamParadingViewV2.NAME = "VersusTeamParadingViewV2"

VersusTeamParadingViewV2.init = function (arg_1_0, arg_1_1)
	local var_1_0 = arg_1_1.player

	arg_1_0._player = var_1_0
	arg_1_0._peer_id = var_1_0:network_id()
	arg_1_0._local_player_id = var_1_0:local_player_id()
	arg_1_0._ingame_ui = arg_1_1.ingame_ui
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._input_manager = arg_1_1.input_manager
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._input_service_name = "ingame_menu"
	arg_1_0._current_state = "none"
	arg_1_0._team_heroes = {}

	local var_1_1 = arg_1_1.world_manager:world("level_world")

	arg_1_0.wwise_world = Managers.world:wwise_world(var_1_1)
end

VersusTeamParadingViewV2.on_enter = function (arg_2_0, arg_2_1)
	print("[VersusTeamParadingViewV2] Enter Versus Team Parading view")

	arg_2_0._party_selection_logic = Managers.state.game_mode:game_mode():party_selection_logic()

	arg_2_0._party_selection_logic:set_ingame_ui(arg_2_0._ingame_ui)
	ShowCursorStack.show("VersusTeamParadingViewV2")

	local var_2_0 = arg_2_0._input_manager
	local var_2_1 = arg_2_0._input_service_name

	var_2_0:block_device_except_service(var_2_1, "keyboard", 1)
	var_2_0:block_device_except_service(var_2_1, "mouse", 1)
	var_2_0:block_device_except_service(var_2_1, "gamepad", 1)

	arg_2_0._animations = {}
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}

	arg_2_0:_create_ui_elements(arg_2_1)
	arg_2_0:_set_transition_widgets_alpha_multiplier(0)
end

VersusTeamParadingViewV2.on_exit = function (arg_3_0)
	print("[VersusTeamParadingViewV2] Exit character selection view")
	ShowCursorStack.hide("VersusTeamParadingViewV2")

	local var_3_0 = arg_3_0._input_manager

	var_3_0:device_unblock_all_services("keyboard", 1)
	var_3_0:device_unblock_all_services("mouse", 1)
	var_3_0:device_unblock_all_services("gamepad", 1)

	if arg_3_0._team_previewer then
		arg_3_0:_destroy_team_previewer()
	end

	if arg_3_0._viewport_widget then
		UIWidget.destroy(arg_3_0.ui_renderer, arg_3_0._viewport_widget)

		arg_3_0._viewport_widget = nil
	end

	arg_3_0:_play_sound("vs_unmute_reset_all")
	arg_3_0:_play_sound("menu_versus_character_amb_loop_stop")
end

VersusTeamParadingViewV2._create_ui_elements = function (arg_4_0, arg_4_1)
	arg_4_0._viewport_widget_definition = arg_4_0:_create_viewport_definition()

	if arg_4_0._viewport_widget then
		UIWidget.destroy(arg_4_0.ui_renderer, arg_4_0._viewport_widget)

		arg_4_0._viewport_widget = nil
	end

	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_4_0._bottom_widgets = {}
	arg_4_0._top_widgets = {}
	arg_4_0._transition_widgets = {}
	arg_4_0._team_portrait_frame_widgets = {}
	arg_4_0._team_insignia_widgets = {}
	arg_4_0._player_name_widgets = {}
	arg_4_0._widgets_by_name = {}

	UIUtils.create_widgets(var_0_2, arg_4_0._bottom_widgets, arg_4_0._widgets_by_name)
	UIUtils.create_widgets(var_0_3, arg_4_0._top_widgets, arg_4_0._widgets_by_name)
	UIUtils.create_widgets(var_0_5, arg_4_0._transition_widgets, arg_4_0._widgets_by_name)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_6)

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)
	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)
end

VersusTeamParadingViewV2.draw = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._ui_renderer
	local var_5_1 = arg_5_0._ui_top_renderer
	local var_5_2 = arg_5_0._ui_scenegraph
	local var_5_3 = arg_5_0.input_manager
	local var_5_4 = arg_5_0:input_service()
	local var_5_5 = arg_5_0.render_settings
	local var_5_6 = var_5_5.alpha_multiplier or 1

	if arg_5_0._viewport_widget then
		UIRenderer.begin_pass(var_5_0, var_5_2, var_5_4, arg_5_1, nil, arg_5_0.render_settings)
		UIRenderer.draw_widget(var_5_0, arg_5_0._viewport_widget)
		UIRenderer.end_pass(var_5_0)
	end

	UIRenderer.begin_pass(var_5_1, var_5_2, var_5_4, arg_5_1, nil, var_5_5)
	arg_5_0:_draw_widgets(arg_5_0._bottom_widgets, var_5_5, var_5_1, var_5_6)
	arg_5_0:_draw_widgets(arg_5_0._top_widgets, var_5_5, var_5_1, var_5_6)
	arg_5_0:_draw_widgets(arg_5_0._player_name_widgets, var_5_5, var_5_1, var_5_6)

	if arg_5_0._current_state ~= "none" then
		arg_5_0:_draw_widgets(arg_5_0._transition_widgets, var_5_5, var_5_1, var_5_6)
	end

	if arg_5_0._team_portrait_frame_widgets then
		arg_5_0:_draw_widgets(arg_5_0._team_portrait_frame_widgets, var_5_5, var_5_1, var_5_6)
	end

	if arg_5_0._team_insignia_widgets then
		arg_5_0:_draw_widgets(arg_5_0._team_insignia_widgets, var_5_5, var_5_1, var_5_6)
	end

	UIRenderer.end_pass(var_5_1)

	var_5_5.alpha_multiplier = var_5_6
end

VersusTeamParadingViewV2.update = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0:draw(arg_6_1)
end

VersusTeamParadingViewV2.post_update = function (arg_7_0, arg_7_1, arg_7_2)
	if DO_RELOAD then
		arg_7_0:_destroy_team_previewer()
		arg_7_0:_create_ui_elements(arg_7_0._params)
	end

	if not arg_7_0._party_id then
		if arg_7_0:_setup_teams_party_data() then
			arg_7_0:_create_team_portrait_frames(arg_7_0._party_id, arg_7_0._local_player_party_data)
			arg_7_0:_create_player_name_widgets(arg_7_0._party_id)
			arg_7_0:_set_team_name_widget_colors_and_text(arg_7_0._party_id)
		else
			return
		end
	end

	if not arg_7_0._viewport_widget then
		arg_7_0._viewport_widget = UIWidget.init(arg_7_0._viewport_widget_definition)

		local var_7_0 = arg_7_0:_get_viewport_world(arg_7_0._viewport_widget)
		local var_7_1 = arg_7_0:_get_viewport_camera(arg_7_0._viewport_widget)
		local var_7_2 = arg_7_0:_get_viewport_level(arg_7_0._viewport_widget)

		Level.trigger_level_loaded(var_7_2)
		arg_7_0:_setup_camera_nodes_data(var_7_2)
		arg_7_0:_setup_initial_camera(var_7_0, var_7_1)
	end

	if #arg_7_0._team_heroes == 0 and not arg_7_0._team_previewer then
		arg_7_0:_setup_team_heroes(arg_7_0._party_id, arg_7_0._local_player_party_data)
		arg_7_0:_setup_team_previewer(true)
	end

	if arg_7_0._team_previewer and not DO_RELOAD then
		local var_7_3 = true

		arg_7_0:_update_team_previewer(arg_7_1, arg_7_2)
	end

	arg_7_0:_update_parading_phases(arg_7_1, arg_7_2)
	arg_7_0.ui_animator:update(arg_7_1)
	arg_7_0:_update_animations(arg_7_1, arg_7_2)
end

VersusTeamParadingViewV2._update_animations = function (arg_8_0, arg_8_1, arg_8_2)
	local var_8_0 = arg_8_0._animations
	local var_8_1 = arg_8_0.ui_animator

	for iter_8_0, iter_8_1 in pairs(var_8_0) do
		if var_8_1:is_animation_completed(iter_8_1) then
			var_8_1:stop_animation(iter_8_1)

			var_8_0[iter_8_0] = nil
		end
	end
end

VersusTeamParadingViewV2._set_transition_widgets_alpha_multiplier = function (arg_9_0, arg_9_1)
	local var_9_0 = arg_9_0._transition_widgets

	for iter_9_0, iter_9_1 in ipairs(var_9_0) do
		iter_9_1.alpha_multiplier = arg_9_1
	end
end

VersusTeamParadingViewV2._setup_teams_party_data = function (arg_10_0)
	local var_10_0 = arg_10_0._peer_id
	local var_10_1 = arg_10_0._local_player_id
	local var_10_2, var_10_3 = Managers.party:get_party_from_player_id(var_10_0, var_10_1)

	if var_10_3 == 0 then
		return false
	end

	arg_10_0._slot_id = Managers.party:get_player_status(var_10_0, var_10_1).slot_id
	arg_10_0._party = var_10_2
	arg_10_0._party_id = var_10_3
	arg_10_0._is_spectator = var_10_2.name == "spectators"

	local var_10_4 = Managers.party:get_party(var_10_3)
	local var_10_5 = arg_10_0:_get_opponent_party_id()

	arg_10_0._opponents_party_id = var_10_5
	arg_10_0._opponents_party_data, arg_10_0._local_player_party_data = Managers.party:get_party(var_10_5), var_10_4

	return true
end

VersusTeamParadingViewV2._draw_widgets = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4)
	if not arg_11_1 then
		return
	end

	for iter_11_0, iter_11_1 in ipairs(arg_11_1) do
		arg_11_2.alpha_multiplier = iter_11_1.alpha_multiplier or arg_11_4

		UIRenderer.draw_widget(arg_11_3, iter_11_1)
	end
end

VersusTeamParadingViewV2._set_new_camera_pose = function (arg_12_0, arg_12_1, arg_12_2)
	ScriptCamera.set_local_pose(arg_12_1, arg_12_2:unbox())
end

VersusTeamParadingViewV2._create_team_portrait_frames = function (arg_13_0, arg_13_1, arg_13_2)
	table.clear(arg_13_0._team_portrait_frame_widgets)
	table.clear(arg_13_0._team_insignia_widgets)

	if not arg_13_2 then
		return
	end

	local var_13_0 = arg_13_0._party_selection_logic:get_party_data(arg_13_1).picker_list
	local var_13_1 = arg_13_2.slots_data

	for iter_13_0, iter_13_1 in ipairs(var_13_0) do
		local var_13_2 = var_13_1[iter_13_1.slot_id]
		local var_13_3 = iter_13_1.status

		if var_13_3 then
			local var_13_4 = var_13_3.selected_profile_index
			local var_13_5 = var_13_3.selected_career_index
			local var_13_6 = SPProfiles[var_13_4]
			local var_13_7 = "player_portrait_anchor_" .. iter_13_0
			local var_13_8 = "player_insignia_anchor_" .. iter_13_0

			if var_13_6 then
				local var_13_9 = var_13_6.careers[var_13_5]
				local var_13_10 = iter_13_1.is_bot
				local var_13_11 = var_13_2.slot_frame ~= "n/a" and var_13_2.slot_frame or "frame_0000"
				local var_13_12 = var_13_10 and "BOT" or var_13_3.level or "-"
				local var_13_13 = var_13_9.portrait_image
				local var_13_14 = UIWidgets.create_portrait_frame(var_13_7, var_13_11, var_13_12, 1, nil, var_13_13)
				local var_13_15 = UIWidget.init(var_13_14, arg_13_0._ui_top_renderer)

				var_13_15.content.frame_settings_name = var_13_11
				var_13_15.offset = {
					0,
					0,
					20
				}
				arg_13_0._team_portrait_frame_widgets[#arg_13_0._team_portrait_frame_widgets + 1] = var_13_15

				local var_13_16 = UIWidgets.create_small_insignia(var_13_8, var_13_3.versus_level or 0)
				local var_13_17 = UIWidget.init(var_13_16, arg_13_0._ui_top_renderer)

				var_13_17.offset = {
					0,
					0,
					20
				}
				arg_13_0._team_insignia_widgets[#arg_13_0._team_insignia_widgets + 1] = var_13_17
			end
		end
	end
end

VersusTeamParadingViewV2._create_player_name_widgets = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._party_selection_logic:get_party_data(arg_14_1).picker_list

	for iter_14_0, iter_14_1 in ipairs(var_14_0) do
		local var_14_1 = iter_14_1.status
		local var_14_2
		local var_14_3
		local var_14_4 = var_14_1.selected_profile_index
		local var_14_5 = var_14_1.selected_career_index
		local var_14_6 = SPProfiles[var_14_4]
		local var_14_7 = "player_portrait_anchor_" .. iter_14_0

		if var_14_6 then
			var_14_3 = var_14_6.careers[var_14_5].display_name
		end

		local var_14_8 = var_14_1.player and arg_14_0:_set_player_name(var_14_1.player) or "BOT"

		var_14_3 = var_14_3 or "NO_CAREER"

		local var_14_9 = var_0_7(var_14_7)
		local var_14_10 = UIWidget.init(var_14_9)
		local var_14_11 = var_14_10.content

		var_14_11.player_name = var_14_8
		var_14_11.career_name = var_14_3
		arg_14_0._player_name_widgets[#arg_14_0._player_name_widgets + 1] = var_14_10
	end
end

VersusTeamParadingViewV2._update_parading_phases = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._current_state

	if var_15_0 == "none" then
		arg_15_0:_change_state("parade_local_player_team")
	elseif var_15_0 == "parade_local_player_team" then
		if not arg_15_0._parading_duration then
			arg_15_0._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").local_player

			arg_15_0:_start_animation("on_enter", "on_enter_local_player")
			arg_15_0:_play_parading_sfx(true)
		end

		if arg_15_2 > arg_15_0._parading_duration then
			arg_15_0._parading_duration = nil

			arg_15_0:_change_state("team_transition")
			arg_15_0:_play_sound("Play_menu_versus_parading_versus_whoosh")
		end
	elseif var_15_0 == "team_transition" then
		if not arg_15_0._parading_duration then
			arg_15_0._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").team_transition

			arg_15_0:_start_animation("transition", "team_transition_fade_in")
		end

		if arg_15_2 > arg_15_0._parading_duration - 0.25 then
			arg_15_0:_start_animation("transition", "team_transition_fade_out")
		end

		if arg_15_2 > arg_15_0._parading_duration then
			arg_15_0._parading_duration = nil

			arg_15_0:_change_state("parade_opponent_team")
			arg_15_0:_play_parading_sfx(false)
		end
	elseif var_15_0 == "parade_opponent_team" then
		if not arg_15_0._parading_duration then
			arg_15_0._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").opponent_transition

			arg_15_0:_start_animation("opponent_parading", "on_enter_opponent_team")
		end

		if arg_15_2 > arg_15_0._parading_duration then
			arg_15_0._parading_duration = nil

			arg_15_0:_change_state("show_match_info")
		end
	elseif var_15_0 == "show_match_info" and not arg_15_0._parading_duration then
		arg_15_0._parading_duration = arg_15_2 + Managers.state.game_mode:setting("parading_times").show_match_info
	end
end

VersusTeamParadingViewV2._get_heroes_spawn_locations = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_1 == arg_16_0._party_id and "character_slot_0" or "character_slot_enemy_0"
	local var_16_1 = "units/hub_elements/versus_podium_character_spawn"
	local var_16_2 = arg_16_0:_get_viewport_level_name()
	local var_16_3 = LevelResource.unit_indices(var_16_2, var_16_1)
	local var_16_4 = {}

	for iter_16_0 = 1, 4 do
		for iter_16_1, iter_16_2 in pairs(var_16_3) do
			local var_16_5 = LevelResource.unit_data(var_16_2, iter_16_2)
			local var_16_6 = DynamicData.get(var_16_5, "name")

			if var_16_6 and var_16_6 == var_16_0 .. iter_16_0 then
				local var_16_7 = LevelResource.unit_position(var_16_2, iter_16_2)
				local var_16_8, var_16_9, var_16_10 = Vector3.to_elements(var_16_7)
				local var_16_11 = {
					var_16_8,
					var_16_9,
					var_16_10
				}

				var_16_4[#var_16_4 + 1] = var_16_11
			end
		end
	end

	fassert(#var_16_4 ~= 0, "[VersusTeamParadingViewV2:_get_heroes_spawn_locations], No hero locations have been found. Check if unit: %s is present in level: %s and has the script data varaible \"name\" set to the correct name.", var_16_1, var_16_2)

	return var_16_4
end

VersusTeamParadingViewV2._setup_initial_camera = function (arg_17_0, arg_17_1, arg_17_2)
	if arg_17_1 then
		local var_17_0 = arg_17_0._cameras.parading_camera_01

		arg_17_0._camera = arg_17_2

		local var_17_1 = Camera.vertical_fov(var_17_0.camera)

		Camera.set_vertical_fov(arg_17_2, var_17_1)
		ScriptCamera.set_local_pose(arg_17_2, var_17_0.camera_pose:unbox())
		ScriptCamera.force_update(arg_17_1, arg_17_2)
	end
end

VersusTeamParadingViewV2._setup_camera_nodes_data = function (arg_18_0, arg_18_1)
	local var_18_0 = {}
	local var_18_1 = Level.flow_variable(arg_18_1, "initial_camera")
	local var_18_2 = Level.flow_variable(arg_18_1, "parading_position_01")
	local var_18_3 = Level.flow_variable(arg_18_1, "parading_position_02")
	local var_18_4 = Matrix4x4Box(Unit.local_pose(var_18_1, 0))
	local var_18_5 = Matrix4x4Box(Unit.local_pose(var_18_2, 0))
	local var_18_6 = Matrix4x4Box(Unit.local_pose(var_18_3, 0))
	local var_18_7 = Unit.camera(var_18_1, "camera")
	local var_18_8 = Unit.camera(var_18_2, "camera")
	local var_18_9 = Unit.camera(var_18_3, "camera")

	var_18_0.initial_camera = {
		camera_unit = var_18_1,
		camera_pose = var_18_4,
		camera = var_18_7
	}
	var_18_0.parading_camera_01 = {
		camera_unit = var_18_2,
		camera_pose = var_18_5,
		camera = var_18_8
	}
	var_18_0.parading_camera_02 = {
		camera_unit = var_18_3,
		camera_pose = var_18_6,
		camera = var_18_9
	}
	arg_18_0._cameras = var_18_0
end

VersusTeamParadingViewV2._setup_team_previewer = function (arg_19_0, arg_19_1)
	if arg_19_0._team_previewer then
		return
	end

	local var_19_0 = arg_19_1 or false
	local var_19_1 = arg_19_0:_get_viewport_world(arg_19_0._viewport_widget)
	local var_19_2 = arg_19_0:_get_viewport(arg_19_0._viewport_widget)

	arg_19_0._team_previewer = TeamPreviewer:new(arg_19_0._ingame_ui_context, var_19_1, var_19_2)

	local var_19_3 = arg_19_0._team_heroes
	local var_19_4 = arg_19_0:_get_heroes_spawn_locations(arg_19_0._party_id)

	arg_19_0._team_previewer:setup_team(var_19_3, var_19_4, var_19_0)
end

VersusTeamParadingViewV2._setup_team_heroes = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._party_selection_logic:get_party_data(arg_20_1).picker_list
	local var_20_1 = arg_20_0._team_heroes

	table.clear(var_20_1)

	for iter_20_0, iter_20_1 in ipairs(var_20_0) do
		local var_20_2 = arg_20_0:_get_hero_previewer_data(iter_20_1, arg_20_2)

		var_20_1[#var_20_1 + 1] = var_20_2 or true
	end
end

VersusTeamParadingViewV2._update_team_previewer = function (arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_0._team_previewer

	if var_21_0 then
		var_21_0:update(arg_21_1, arg_21_2)
		var_21_0:post_update(arg_21_1, arg_21_2)
	end
end

VersusTeamParadingViewV2._destroy_team_previewer = function (arg_22_0)
	if arg_22_0._team_previewer and arg_22_0._viewport_widget then
		arg_22_0._team_previewer:on_exit()

		arg_22_0._team_previewer = nil

		table.clear(arg_22_0._team_heroes)
	end
end

VersusTeamParadingViewV2._create_viewport_definition = function (arg_23_0)
	return {
		scenegraph_id = "screen",
		element = UIElements.Viewport,
		style = {
			viewport = {
				layer = 990,
				shading_environment = "environment/ui_end_screen",
				viewport_name = "versus_parading_preview_viewport",
				clear_screen_on_create = true,
				enable_sub_gui = false,
				fov = 50,
				world_name = "versus_parading_preview",
				world_flags = {
					Application.DISABLE_SOUND,
					Application.DISABLE_ESRAM,
					Application.ENABLE_VOLUMETRICS
				},
				level_name = var_0_8.level_name,
				object_sets = LevelResource.object_set_names(var_0_8.level_name),
				camera_position = {
					0,
					0,
					0
				},
				camera_lookat = {
					0,
					0,
					0
				}
			}
		},
		content = {
			button_hotspot = {
				allow_multi_hover = true
			}
		}
	}
end

VersusTeamParadingViewV2._get_hero_previewer_data = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_1.status
	local var_24_1 = var_24_0.selected_profile_index
	local var_24_2 = var_24_0.selected_career_index
	local var_24_3 = SPProfiles[var_24_1]

	if not var_24_3 or var_24_3.affiliation == "dark_pact" then
		return nil
	end

	local var_24_4 = arg_24_1.slot_id
	local var_24_5 = arg_24_2.slots_data[var_24_4]
	local var_24_6 = SPProfiles[var_24_1]

	if var_24_6 then
		local var_24_7 = var_24_6.careers[var_24_2]
		local var_24_8 = var_24_7.versus_preview_animation or var_24_7.preview_animation
		local var_24_9 = var_24_7.preview_wield_slot
		local var_24_10 = var_24_7.profile_name
		local var_24_11 = var_24_5["slot_" .. var_24_9]
		local var_24_12 = var_24_5.slot_hat
		local var_24_13 = {
			var_24_7.preview_items[1],
			{
				item_name = var_24_12 ~= "n/a" and var_24_12 or var_24_7.preview_items[2].item_name
			}
		}
		local var_24_14 = var_24_5.slot_skin ~= "n/a" and var_24_5.slot_skin or var_24_7.base_skin

		return {
			profile_index = var_24_1,
			career_index = var_24_2,
			skin_name = var_24_14,
			hero_name = var_24_10,
			weapon_slot = var_24_9,
			preview_items = var_24_13,
			preview_animation = var_24_8
		}
	end

	return nil
end

VersusTeamParadingViewV2._get_viewport = function (arg_25_0, arg_25_1)
	return arg_25_1.element.pass_data[1].viewport
end

VersusTeamParadingViewV2._get_viewport_world = function (arg_26_0, arg_26_1)
	local var_26_0 = arg_26_1.element.pass_data[1]

	return var_26_0.world, var_26_0.world_name
end

VersusTeamParadingViewV2._get_viewport_level = function (arg_27_0, arg_27_1)
	return arg_27_1.element.pass_data[1].level
end

VersusTeamParadingViewV2._get_viewport_level_name = function (arg_28_0)
	return var_0_8.level_name
end

VersusTeamParadingViewV2._get_viewport_camera = function (arg_29_0, arg_29_1)
	return arg_29_1.element.pass_data[1].camera
end

VersusTeamParadingViewV2._get_viewport_name = function (arg_30_0, arg_30_1)
	return arg_30_1.element.pass_data[1].viewport_name
end

VersusTeamParadingViewV2._get_opponent_party_id = function (arg_31_0)
	return arg_31_0._party_id == 1 and 2 or 1
end

VersusTeamParadingViewV2._set_camera_pose = function (arg_32_0, arg_32_1, arg_32_2, arg_32_3)
	ScriptCamera.set_local_pose(arg_32_2, arg_32_3:unbox())
	ScriptCamera.force_update(arg_32_1, arg_32_2)
end

VersusTeamParadingViewV2.input_service = function (arg_33_0)
	return arg_33_0._input_manager:get_service(arg_33_0._input_service_name)
end

VersusTeamParadingViewV2._change_state = function (arg_34_0, arg_34_1)
	arg_34_0._current_state = arg_34_1
end

VersusTeamParadingViewV2._start_animation = function (arg_35_0, arg_35_1, arg_35_2)
	local var_35_0 = {
		wwise_world = arg_35_0._wwise_world,
		render_settings = arg_35_0.render_settings,
		self = arg_35_0
	}
	local var_35_1 = {}
	local var_35_2 = arg_35_0.ui_animator:start_animation(arg_35_2, var_35_1, var_0_1, var_35_0)

	arg_35_0._animations[arg_35_1] = var_35_2
end

VersusTeamParadingViewV2._set_player_name = function (arg_36_0, arg_36_1)
	local var_36_0 = arg_36_1:name()

	if UTF8Utils.string_length(var_36_0) > 18 then
		var_36_0 = string.sub(var_36_0, 1, 18) .. "..."
	end

	return var_36_0
end

VersusTeamParadingViewV2._change_team_info = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0:_get_opponent_party_id()

	arg_37_0:_setup_team_heroes(var_37_0, arg_37_1)

	local var_37_1 = arg_37_0:_get_heroes_spawn_locations(var_37_0)

	arg_37_0._team_previewer:setup_team(arg_37_0._team_heroes, var_37_1, true)

	local var_37_2 = arg_37_0._cameras.parading_camera_02
	local var_37_3 = arg_37_0:_get_viewport_world(arg_37_0._viewport_widget)
	local var_37_4 = arg_37_0._camera
	local var_37_5 = var_37_2.camera_pose

	arg_37_0:_set_camera_pose(var_37_3, var_37_4, var_37_5)
	arg_37_0:_set_opponent_team_names_and_portraits(var_37_0, arg_37_1)
end

VersusTeamParadingViewV2._set_team_names_and_careers = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._party_selection_logic:get_party_data(arg_38_1).picker_list

	for iter_38_0, iter_38_1 in ipairs(var_38_0) do
		local var_38_1 = iter_38_1.status
		local var_38_2
		local var_38_3
		local var_38_4 = var_38_1.selected_profile_index
		local var_38_5 = var_38_1.selected_career_index
		local var_38_6 = SPProfiles[var_38_4]

		if var_38_6 then
			var_38_3 = var_38_6.careers[var_38_5].display_name
		end

		local var_38_7 = var_38_1.player and arg_38_0:_set_player_name(var_38_1.player) or "BOT"

		var_38_3 = var_38_3 or "NO_CAREER"

		local var_38_8 = arg_38_0._player_name_widgets[iter_38_0]
		local var_38_9 = var_38_8.style
		local var_38_10 = var_38_8.content

		var_38_10.player_name = var_38_7
		var_38_10.career_name = var_38_3
		var_38_9.player_name.text_color = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	end
end

VersusTeamParadingViewV2._set_opponent_team_names_and_portraits = function (arg_39_0, arg_39_1, arg_39_2)
	arg_39_0:_create_team_portrait_frames(arg_39_1, arg_39_2)
	arg_39_0:_set_team_names_and_careers(arg_39_1)
	arg_39_0:_set_team_name_widget_colors_and_text(arg_39_1)
end

VersusTeamParadingViewV2._set_team_name_widget_colors_and_text = function (arg_40_0, arg_40_1)
	local var_40_0 = Managers.state.game_mode:setting("party_names_lookup_by_id")[arg_40_1]
	local var_40_1 = arg_40_0._party_id == arg_40_1
	local var_40_2 = var_0_9.teams_ui_assets[var_40_0]

	if not var_40_1 or not Colors.get_color_table_with_alpha("local_player_team_lighter", 255) then
		local var_40_3 = Colors.get_color_table_with_alpha("opponent_team_lighter", 255)
	end

	local var_40_4 = arg_40_0._widgets_by_name.top_background_detail

	var_40_4.content.divider_edge_left = var_40_1 and "divider_horizontal_hero_end_blue" or "divider_horizontal_hero_end_red"
	var_40_4.content.divider_mid = var_40_1 and "divider_horizontal_hero_middle_blue" or "divider_horizontal_hero_middle_red"
	var_40_4.content.divider_edge_right.texture_id = var_40_1 and "divider_horizontal_hero_end_blue" or "divider_horizontal_hero_end_red"

	local var_40_5 = arg_40_0._widgets_by_name.team_flag

	var_40_5.content.texture_id = var_40_1 and var_40_2.local_flag_long_texture or var_40_2.opponent_flag_long_texture
	var_40_5.offset[1] = var_40_1 and 30 or 1658

	local var_40_6 = arg_40_0._widgets_by_name.bottom_background_detail

	var_40_6.content.divider_edge_left = var_40_1 and "divider_horizontal_hero_end_blue" or "divider_horizontal_hero_end_red"
	var_40_6.content.divider_mid = var_40_1 and "divider_horizontal_hero_middle_blue" or "divider_horizontal_hero_middle_red"
	var_40_6.content.divider_edge_right.texture_id = var_40_1 and "divider_horizontal_hero_end_blue" or "divider_horizontal_hero_end_red"
end

VersusTeamParadingViewV2._play_sound = function (arg_41_0, arg_41_1)
	WwiseWorld.trigger_event(arg_41_0.wwise_world, arg_41_1)
end

VersusTeamParadingViewV2._play_parading_sfx = function (arg_42_0, arg_42_1)
	local var_42_0 = arg_42_1 and arg_42_0._party_id or arg_42_0:_get_opponent_party_id()
	local var_42_1 = Managers.state.game_mode:setting("party_names_lookup_by_id")[var_42_0]
	local var_42_2 = "Play_menu_versus_parading_" .. (var_42_1 == "team_hammers" and "hammers" or "skulls")

	arg_42_0:_play_sound(var_42_2)
end
