-- chunkname: @scripts/ui/mission_vote_ui/mission_voting_ui.lua

local var_0_0 = local_require("scripts/ui/mission_vote_ui/mission_voting_ui_definitions")
local var_0_1 = var_0_0.generic_input_actions
local var_0_2 = var_0_0.deed_game_widgets
local var_0_3 = var_0_0.custom_game_widgets
local var_0_4 = var_0_0.adventure_game_widgets
local var_0_5 = var_0_0.game_mode_widgets
local var_0_6 = var_0_0.event_game_widgets
local var_0_7 = var_0_0.weave_game_widgets
local var_0_8 = var_0_0.weave_quickplay_widgets
local var_0_9 = var_0_0.deus_quickplay_widget
local var_0_10 = var_0_0.deus_custom_widget
local var_0_11 = var_0_0.twitch_mode_widget_funcs
local var_0_12 = var_0_0.switch_mechanism_widgets
local var_0_13 = var_0_0.versus_quickplay_widgets
local var_0_14 = var_0_0.versus_custom_widgets
local var_0_15 = var_0_0.deus_weekly_event_widgets
local var_0_16 = var_0_0.deus_weekly_event_create_header
local var_0_17 = var_0_0.deus_weekly_event_create_entry_widget

MissionVotingUI = class(MissionVotingUI)

function MissionVotingUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ui_top_renderer = arg_1_2.ui_top_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.wwise_world = arg_1_2.wwise_world
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.voting_manager = arg_1_2.voting_manager
	arg_1_0.statistics_db = arg_1_2.statistics_db
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._is_server = arg_1_2.is_server
	arg_1_0._stats_id = Managers.player:local_player():stats_id()

	arg_1_0:create_ui_elements()

	local var_1_0 = arg_1_0.input_manager

	var_1_0:create_input_service("mission_voting", "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_0:map_device_to_service("mission_voting", "keyboard")
	var_1_0:map_device_to_service("mission_voting", "mouse")
	var_1_0:map_device_to_service("mission_voting", "gamepad")

	local var_1_1 = var_1_0:get_service("mission_voting")

	arg_1_0._menu_input_description = MenuInputDescriptionUI:new(arg_1_2, arg_1_0.ui_top_renderer, var_1_1, 3, 900, var_0_1.default)

	arg_1_0._menu_input_description:set_input_description(nil)
end

function MissionVotingUI.create_ui_elements(arg_2_0)
	arg_2_0._ui_animations = {}
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widgets)
	arg_2_0._widgets_deus, arg_2_0._widgets_deus_by_name = UIUtils.create_widgets(var_0_0.widgets_deus)
	arg_2_0._deed_widgets, arg_2_0._deed_widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_2_0._custom_game_widgets, arg_2_0._custom_game_widgets_by_name = UIUtils.create_widgets(var_0_3)
	arg_2_0._event_game_widgets, arg_2_0._event_game_widgets_by_name = UIUtils.create_widgets(var_0_6)
	arg_2_0._weave_game_widgets, arg_2_0._weave_game_widgets_by_name = UIUtils.create_widgets(var_0_7)
	arg_2_0._weave_quickplay_widgets, arg_2_0._weave_quickplay_widgets_by_name = UIUtils.create_widgets(var_0_8)
	arg_2_0._deus_quickplay_widgets, arg_2_0._deus_quickplay_widgets_by_name = UIUtils.create_widgets(var_0_9)
	arg_2_0._deus_custom_widgets, arg_2_0._deus_custom_widgets_by_name = UIUtils.create_widgets(var_0_10)
	arg_2_0._adventure_game_widgets, arg_2_0._adventure_game_widgets_by_name = UIUtils.create_widgets(var_0_4)
	arg_2_0._game_mode_widgets, arg_2_0._game_mode_widgets_by_name = UIUtils.create_widgets(var_0_5)
	arg_2_0._switch_mechanism_widgets, arg_2_0._switch_mechanism_widgets_by_name = UIUtils.create_widgets(var_0_12)
	arg_2_0._versus_quickplay_widgets, arg_2_0._versus_quickplay_widgets_by_name = UIUtils.create_widgets(var_0_13)
	arg_2_0._versus_custom_widgets, arg_2_0._versus_custom_widgets_by_name = UIUtils.create_widgets(var_0_14)
	arg_2_0._deus_weekly_event_widgets, arg_2_0._deus_weekly_event_widgets_by_name = UIUtils.create_widgets(var_0_15)

	local var_2_0 = {}
	local var_2_1 = {}
	local var_2_2 = arg_2_0._is_server

	for iter_2_0, iter_2_1 in pairs(var_0_11) do
		local var_2_3 = UIWidget.init(iter_2_1(var_2_2))

		var_2_0[#var_2_0 + 1] = var_2_3
		var_2_1[iter_2_0] = var_2_3
	end

	arg_2_0._twitch_widgets = var_2_0
	arg_2_0._twitch_widgets_by_name = var_2_1
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0.scenegraph_definition = var_0_0.scenegraph_definition

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_top_renderer)
end

function MissionVotingUI.destroy(arg_3_0)
	if arg_3_0.vote_started then
		arg_3_0:on_vote_ended()
	end
end

function MissionVotingUI.get_chrome_widgets(arg_4_0)
	if arg_4_0._active_mechanism == "deus" then
		return arg_4_0._widgets_deus_by_name, arg_4_0._widgets_deus
	else
		return arg_4_0._widgets_by_name, arg_4_0._widgets
	end
end

function MissionVotingUI.is_active(arg_5_0)
	return arg_5_0.vote_started and not arg_5_0.has_voted
end

function MissionVotingUI.setup_option_input(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_2.text
	local var_6_1 = arg_6_2.input
	local var_6_2 = arg_6_0.input_manager:get_service("mission_voting")
	local var_6_3 = false
	local var_6_4, var_6_5 = UISettings.get_gamepad_input_texture_data(var_6_2, var_6_1, var_6_3)

	if not var_6_3 then
		local var_6_6
	end

	local var_6_7 = Localize(var_6_0)

	arg_6_1.content.title_text = var_6_7
end

function MissionVotingUI.start_vote(arg_7_0, arg_7_1)
	arg_7_0.render_settings.alpha_multiplier = 0
	arg_7_0._scrollbar_ui = nil

	local var_7_0 = arg_7_1.template

	if var_7_0.can_start_vote and not var_7_0.can_start_vote(arg_7_1.data) then
		local var_7_1 = var_7_0.text or "Unknown vote"

		printf("[MissionVotingUI] - Terminating vote request (%s) due to the requirements to start was not fulfilled.", var_7_1)

		return
	end

	local var_7_2 = arg_7_1.data
	local var_7_3 = var_7_2.matchmaking_type
	local var_7_4 = var_7_2.mechanism
	local var_7_5 = var_7_2.switch_mechanism

	arg_7_0._twitch_mode_enabled = var_7_2.twitch_enabled
	arg_7_0._matchmaking_type = var_7_2.matchmaking_type
	arg_7_0._active_mechanism = var_7_4
	arg_7_0._difficulty = var_7_2.difficulty

	if var_7_5 then
		arg_7_0:_set_switch_mechanism_presentation(var_7_2)
	elseif var_7_4 == "weave" then
		if var_7_2.quick_game then
			local var_7_6 = var_7_2.difficulty

			arg_7_0:_set_weave_quickplay_presentation(var_7_6)
		else
			local var_7_7 = var_7_2.mission_id
			local var_7_8 = var_7_2.difficulty
			local var_7_9 = var_7_2.private_game

			arg_7_0:_set_weave_presentation(var_7_8, var_7_7, var_7_9)
		end
	elseif var_7_4 == "deus" then
		if var_7_2.quick_game then
			local var_7_10 = var_7_2.difficulty

			arg_7_0:_set_deus_quickplay_presentation(var_7_10)
		elseif var_7_3 == "event" then
			local var_7_11 = var_7_2.mission_id
			local var_7_12 = var_7_2.difficulty
			local var_7_13 = var_7_2.private_game
			local var_7_14 = var_7_2.always_host
			local var_7_15 = var_7_2.strict_matchmaking
			local var_7_16 = var_7_2.dominant_god
			local var_7_17 = var_7_2.event_data
			local var_7_18 = var_7_17 and var_7_17.mutators or {}
			local var_7_19 = var_7_17 and var_7_17.boons or {}

			arg_7_0:_set_deus_weekly_expedition_presentation(var_7_12, var_7_11, var_7_13, var_7_14, var_7_15, var_7_16, var_7_18, var_7_19)
		else
			local var_7_20 = var_7_2.mission_id
			local var_7_21 = var_7_2.difficulty
			local var_7_22 = var_7_2.private_game
			local var_7_23 = var_7_2.always_host
			local var_7_24 = var_7_2.strict_matchmaking
			local var_7_25 = var_7_2.dominant_god

			arg_7_0:_set_deus_custom_game_presentation(var_7_21, var_7_20, var_7_22, var_7_23, var_7_24, var_7_25)
		end
	elseif var_7_4 == "versus" then
		if not var_7_2.player_hosted then
			local var_7_26 = var_7_2.difficulty

			arg_7_0:_set_versus_quickplay_presentation(var_7_26)
		else
			local var_7_27 = var_7_2.mission_id or "bell_pvp"
			local var_7_28 = var_7_2.difficulty
			local var_7_29 = var_7_2.player_hosted
			local var_7_30 = var_7_2.dedicated_servers_win
			local var_7_31 = var_7_2.dedicated_servers_aws

			arg_7_0:_set_versus_custom_game_presentation(var_7_28, var_7_27, var_7_29, var_7_30, var_7_31)
		end
	elseif var_7_3 == "deed" then
		local var_7_32 = var_7_2.item_name
		local var_7_33 = var_7_2.mission_id
		local var_7_34 = var_7_2.difficulty

		arg_7_0:_set_deed_presentation(var_7_32, var_7_33, var_7_34)
	elseif var_7_3 == "event" then
		local var_7_35 = var_7_2.event_data
		local var_7_36 = var_7_2.mission_id
		local var_7_37 = var_7_2.difficulty
		local var_7_38 = var_7_35 and var_7_35.mutators or {}

		if not var_7_35 or not var_7_35.boons then
			local var_7_39 = {}
		end

		arg_7_0:_set_event_game_presentation(var_7_37, var_7_36, var_7_38)
	elseif var_7_2.quick_game then
		local var_7_40 = var_7_2.difficulty

		arg_7_0:_set_adventure_presentation(var_7_40)
	elseif var_7_2.mechanism_key ~= nil then
		local var_7_41 = var_7_2.mechanism_key

		arg_7_0:_set_game_mode_presentation(var_7_41)
	else
		local var_7_42 = var_7_2.mission_id
		local var_7_43 = var_7_2.difficulty
		local var_7_44 = var_7_2.private_game
		local var_7_45 = var_7_2.always_host
		local var_7_46 = var_7_2.strict_matchmaking

		arg_7_0:_set_custom_game_presentation(var_7_43, var_7_42, var_7_44, var_7_45, var_7_46)
	end

	local var_7_47 = var_7_0.text

	if var_7_0.modify_title_text then
		var_7_47 = var_7_0.modify_title_text(Localize(var_7_47), var_7_2)
	else
		var_7_47 = Localize(var_7_47)
	end

	local var_7_48 = arg_7_0:get_chrome_widgets()

	var_7_48.title_text.content.text = var_7_47
	arg_7_0.voters = {}
	arg_7_0.vote_results = {
		[1] = 0,
		[2] = 0
	}
	arg_7_0.vote_started = true
	arg_7_0.has_voted = false

	local var_7_49 = var_7_0.vote_options

	arg_7_0:setup_option_input(var_7_48.button_confirm, var_7_49[1])
	arg_7_0:setup_option_input(var_7_48.button_abort, var_7_49[2])

	arg_7_0.gamepad_active = arg_7_0.input_manager:is_device_active("gamepad")

	arg_7_0:_acquire_input()

	local var_7_50 = arg_7_0.ui_renderer.world
	local var_7_51 = World.get_data(var_7_50, "shading_environment")

	if var_7_51 then
		ShadingEnvironment.set_scalar(var_7_51, "fullscreen_blur_enabled", 1)
		ShadingEnvironment.set_scalar(var_7_51, "fullscreen_blur_amount", 0.75)
		ShadingEnvironment.apply(var_7_51)
	end

	arg_7_0:_play_sound("play_gui_mission_vote_start")

	arg_7_0._ui_animations.twitch_info = UIAnimation.init(UIAnimation.function_by_time, arg_7_0.ui_scenegraph.twitch_mode_info.local_position, 1, 400, 0, 0.3, math.easeOutCubic)

	arg_7_0:_check_initial_votes()
	arg_7_0:_setup_gamepad_input_desc(var_7_0)
end

function MissionVotingUI._setup_gamepad_input_desc(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1.gamepad_input_desc

	if var_8_0 then
		arg_8_0._menu_input_description:set_input_description(var_0_1[var_8_0])
	else
		arg_8_0._menu_input_description:set_input_description(nil)
	end
end

function MissionVotingUI._check_initial_votes(arg_9_0)
	if arg_9_0.voting_manager:has_voted(Network.peer_id()) then
		arg_9_0:on_vote_casted()
	end
end

function MissionVotingUI.on_vote_casted(arg_10_0, arg_10_1)
	arg_10_0.has_voted = true

	arg_10_0.voting_manager:allow_vote_input(false)

	if arg_10_1 then
		arg_10_0:_play_sound("play_gui_mission_vote_button_accept")
	else
		arg_10_0:_play_sound("play_gui_mission_vote_button_decline")
	end

	arg_10_0:_release_input()

	local var_10_0 = arg_10_0.ui_renderer.world
	local var_10_1 = World.get_data(var_10_0, "shading_environment")

	if var_10_1 then
		ShadingEnvironment.set_scalar(var_10_1, "fullscreen_blur_enabled", 0)
		ShadingEnvironment.set_scalar(var_10_1, "fullscreen_blur_amount", 0)
		ShadingEnvironment.apply(var_10_1)
	end
end

function MissionVotingUI.on_vote_ended(arg_11_0)
	if not arg_11_0.has_voted then
		arg_11_0.voting_manager:allow_vote_input(false)
		arg_11_0:_release_input()

		local var_11_0 = arg_11_0.ui_renderer.world
		local var_11_1 = World.get_data(var_11_0, "shading_environment")

		if var_11_1 then
			ShadingEnvironment.set_scalar(var_11_1, "fullscreen_blur_enabled", 0)
			ShadingEnvironment.set_scalar(var_11_1, "fullscreen_blur_amount", 0)
			ShadingEnvironment.apply(var_11_1)
		end
	end

	local var_11_2 = arg_11_0.ingame_ui

	if var_11_2:is_local_player_ready_for_game() then
		var_11_2:suspend_active_view()
	end

	arg_11_0.has_voted = nil
	arg_11_0.vote_started = nil
end

function MissionVotingUI._set_weave_quickplay_presentation(arg_12_0, arg_12_1)
	local var_12_0 = DifficultySettings[arg_12_1]
	local var_12_1 = var_12_0.display_name
	local var_12_2 = var_12_0.display_image
	local var_12_3 = var_12_0.completed_frame_texture or "map_frame_00"
	local var_12_4 = arg_12_0._weave_quickplay_widgets_by_name.game_option_1

	var_12_4.content.option_text = Localize(var_12_1)
	var_12_4.content.icon = var_12_2
	var_12_4.content.icon_frame = var_12_3
	arg_12_0._presentation_type = "weave_quickplay"
end

function MissionVotingUI._set_adventure_presentation(arg_13_0, arg_13_1)
	local var_13_0 = DifficultySettings[arg_13_1]
	local var_13_1 = var_13_0.display_name
	local var_13_2 = var_13_0.display_image
	local var_13_3 = var_13_0.completed_frame_texture or "map_frame_00"
	local var_13_4 = arg_13_0._adventure_game_widgets_by_name.game_option_1

	var_13_4.content.option_text = Localize(var_13_1)
	var_13_4.content.icon = var_13_2
	var_13_4.content.icon_frame = var_13_3
	arg_13_0._presentation_type = "adventure"
end

function MissionVotingUI._set_game_mode_presentation(arg_14_0, arg_14_1)
	arg_14_0._game_mode_widgets_by_name.game_mode_text.content.text = Localize("vs_game_mode_title_" .. arg_14_1)
	arg_14_0._presentation_type = "game_mode"
end

function MissionVotingUI._set_switch_mechanism_presentation(arg_15_0, arg_15_1)
	local var_15_0 = arg_15_1.mechanism or "adventure"
	local var_15_1 = arg_15_1.level_key or "inn_level"
	local var_15_2 = LevelSettings[var_15_1]
	local var_15_3 = MechanismSettings[var_15_0]
	local var_15_4 = var_15_3.vote_switch_mechanism_background or "icons_placeholder"
	local var_15_5 = var_15_3.vote_switch_mechanism_text or "n/a"
	local var_15_6 = arg_15_0._switch_mechanism_widgets_by_name

	var_15_6.background.content.texture_id = var_15_4
	var_15_6.title.content.text = var_15_3.display_name
	var_15_6.subtitle.content.text = var_15_2.display_name
	var_15_6.description.content.text = var_15_5

	local var_15_7 = arg_15_0._active_mechanism == "deus" and "morris_text_color" or "adventure_text_color"
	local var_15_8 = var_15_6.title.style.text

	Colors.copy_to(var_15_8.text_color, var_15_8[var_15_7])

	local var_15_9 = var_15_6.subtitle.style.text

	Colors.copy_to(var_15_9.text_color, var_15_9[var_15_7])

	arg_15_0._presentation_type = "switch_mechanism"
end

function MissionVotingUI._set_custom_game_presentation(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5)
	local var_16_0 = DifficultySettings[arg_16_1]
	local var_16_1 = var_16_0.display_name
	local var_16_2 = var_16_0.display_image
	local var_16_3 = var_16_0.completed_frame_texture or "map_frame_00"
	local var_16_4 = LevelSettings[arg_16_2]
	local var_16_5 = var_16_4.display_name
	local var_16_6 = var_16_4.level_image
	local var_16_7 = LevelUnlockUtils.completed_level_difficulty_index(arg_16_0.statistics_db, arg_16_0._stats_id, arg_16_2) or 0
	local var_16_8 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_16_7)
	local var_16_9 = arg_16_0._custom_game_widgets_by_name
	local var_16_10 = var_16_9.game_option_1

	var_16_10.content.option_text = Localize(var_16_5)

	local var_16_11 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_16_6)

	var_16_10.content.icon = var_16_6
	var_16_10.content.icon_frame = var_16_8

	local var_16_12 = var_16_10.style.icon.texture_size

	var_16_12[1] = var_16_11.size[1]
	var_16_12[2] = var_16_11.size[2]

	local var_16_13 = var_16_9.game_option_2

	var_16_13.content.option_text = Localize(var_16_1)
	var_16_13.content.icon = var_16_2
	var_16_13.content.icon_frame = var_16_3
	var_16_9.additional_option.content.option_text = ""

	local var_16_14 = var_16_9.private_button

	var_16_14.content.button_hotspot.disable_button = true
	var_16_14.content.button_hotspot.is_selected = arg_16_3
	var_16_14.style.hover_glow.color[1] = 0

	local var_16_15 = var_16_9.host_button

	var_16_15.content.button_hotspot.disable_button = true
	var_16_15.content.button_hotspot.is_selected = arg_16_4
	var_16_15.style.hover_glow.color[1] = 0

	local var_16_16 = var_16_9.strict_matchmaking_button

	var_16_16.content.button_hotspot.disable_button = true
	var_16_16.content.button_hotspot.is_selected = arg_16_5
	var_16_16.style.hover_glow.color[1] = 0
	arg_16_0._presentation_type = "custom"
end

function MissionVotingUI._set_deed_presentation(arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = ItemMasterList[arg_17_1]
	local var_17_1 = {
		data = var_17_0,
		difficulty = arg_17_3,
		level_key = arg_17_2
	}

	arg_17_0._deed_widgets_by_name.item_presentation.content.item = var_17_1
	arg_17_0._presentation_type = "deed"
end

function MissionVotingUI._set_event_game_presentation(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = DifficultySettings[arg_18_1]
	local var_18_1 = var_18_0.display_name
	local var_18_2 = var_18_0.display_image
	local var_18_3 = var_18_0.completed_frame_texture or "map_frame_00"
	local var_18_4 = arg_18_0._event_game_widgets_by_name
	local var_18_5 = var_18_4.game_option_1

	var_18_5.content.option_text = Localize(var_18_1)
	var_18_5.content.icon = var_18_2
	var_18_5.content.icon_frame = var_18_3
	var_18_4.event_summary.content.item = {
		level_key = arg_18_2,
		mutators = arg_18_3
	}
	arg_18_0._presentation_type = "event"
end

function MissionVotingUI._set_weave_presentation(arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = 1
	local var_19_1 = arg_19_2
	local var_19_2 = WeaveSettings.templates[var_19_1]
	local var_19_3 = var_19_2.objectives[var_19_0].level_id
	local var_19_4 = arg_19_0._weave_game_widgets_by_name
	local var_19_5 = var_19_4.game_option_1
	local var_19_6 = table.find(WeaveSettings.templates_ordered, var_19_2)
	local var_19_7 = var_19_2.wind
	local var_19_8 = WindSettings[var_19_7]
	local var_19_9 = LevelSettings[var_19_3]
	local var_19_10 = var_19_9.level_image
	local var_19_11 = DifficultySettings[arg_19_1].completed_frame_texture
	local var_19_12 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_19_10)

	var_19_5.content.icon = var_19_10

	local var_19_13 = var_19_5.style.icon.texture_size

	var_19_13[1] = var_19_12.size[1] * 0.8
	var_19_13[2] = var_19_12.size[2] * 0.8
	var_19_5.content.title_text = var_19_6 .. ". " .. Localize(var_19_2.display_name)

	local var_19_14 = Colors.get_color_table_with_alpha(var_19_7, 255)

	var_19_5.style.icon_frame.color = var_19_14

	local var_19_15 = var_19_8.thumbnail_icon
	local var_19_16 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_19_15).size
	local var_19_17 = var_19_5.style.wind_icon_glow
	local var_19_18 = var_19_17.texture_size
	local var_19_19 = var_19_17.offset
	local var_19_20 = var_19_17.color

	var_19_20[1] = 128
	var_19_20[2] = var_19_14[2]
	var_19_20[3] = var_19_14[3]
	var_19_20[4] = var_19_14[4]

	local var_19_21 = var_19_5.style.wind_icon
	local var_19_22 = var_19_21.texture_size
	local var_19_23 = var_19_21.offset

	var_19_22[1] = var_19_16[1] * 0.8
	var_19_22[2] = var_19_16[2] * 0.8
	var_19_23[1] = var_19_19[1] - var_19_18[1] / 2 + var_19_22[1] / 2
	var_19_23[2] = var_19_19[2] + var_19_18[2] / 2 - var_19_22[2] / 2
	var_19_5.content.wind_icon = var_19_15
	var_19_5.content.mission_name = Localize(var_19_9.display_name)
	var_19_5.content.wind_name = Localize(var_19_8.display_name)
	var_19_5.style.wind_name.text_color = var_19_14
	var_19_21.color = var_19_14

	local var_19_24 = var_19_8.mutator
	local var_19_25 = MutatorTemplates[var_19_24]
	local var_19_26 = var_19_4.mutator_icon
	local var_19_27 = var_19_4.mutator_title_text
	local var_19_28 = var_19_4.mutator_description_text

	var_19_26.content.texture_id = var_19_25.icon
	var_19_27.content.text = Localize(var_19_25.display_name)
	var_19_28.content.text = Localize(var_19_25.description)

	local var_19_29 = var_19_4.objective_title
	local var_19_30 = var_19_4.objective_1
	local var_19_31 = var_19_4.objective_2

	var_19_29.content.text = "weave_objective_title"

	local var_19_32 = var_19_2.objectives
	local var_19_33 = 10
	local var_19_34 = 0

	for iter_19_0 = 1, #var_19_32 do
		local var_19_35 = var_19_32[iter_19_0]
		local var_19_36 = var_19_35.display_name
		local var_19_37 = var_19_35.icon

		arg_19_0:_assign_objective(iter_19_0, var_19_36, var_19_37, var_19_33)
	end

	var_19_4.private_checkbox.content.button_hotspot.is_selected = arg_19_3
	arg_19_0._presentation_type = "weave"
end

function MissionVotingUI._assign_objective(arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4)
	local var_20_0 = arg_20_0._weave_game_widgets_by_name["objective_" .. arg_20_1]
	local var_20_1 = var_20_0.content
	local var_20_2 = var_20_0.style

	var_20_1.icon = arg_20_3 or "objective_icon_general"
	var_20_1.text = arg_20_2 or "-"
end

function MissionVotingUI._set_deus_quickplay_presentation(arg_21_0, arg_21_1)
	local var_21_0 = DifficultySettings[arg_21_1]
	local var_21_1 = var_21_0.display_name
	local var_21_2 = var_21_0.display_image
	local var_21_3 = var_21_0.completed_frame_texture or "map_frame_00"
	local var_21_4 = arg_21_0._deus_quickplay_widgets_by_name.game_option_1

	var_21_4.content.option_text = Localize(var_21_1)
	var_21_4.content.icon = var_21_2
	var_21_4.content.icon_frame = var_21_3
	arg_21_0._presentation_type = "deus_quickplay"
end

function MissionVotingUI._set_deus_weekly_expedition_presentation(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8)
	arg_22_0._presentation_type = "deus_weekly"

	local var_22_0 = arg_22_0._deus_weekly_event_widgets_by_name
	local var_22_1 = var_22_0.game_option_1
	local var_22_2 = var_22_1.content
	local var_22_3 = DeusJourneySettings[arg_22_2]
	local var_22_4 = var_22_3.display_name
	local var_22_5 = var_22_3.level_image
	local var_22_6 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_22_5)

	var_22_2.icon = var_22_5
	var_22_2.show_journey_border = true
	var_22_2.with_belakor = Managers.backend:get_interface("deus"):deus_journey_with_belakor(arg_22_2)

	local var_22_7 = var_22_1.style.icon.texture_size

	var_22_7[1] = var_22_6.size[1]
	var_22_7[2] = var_22_6.size[2]
	var_22_0.journey_name.content.text = var_22_4

	local var_22_8 = DeusThemeSettings[arg_22_6]

	var_22_2.theme_icon = var_22_8.icon

	local var_22_9 = var_22_0.journey_theme

	var_22_9.content.text = var_22_8.journey_title
	var_22_9.content.icon = var_22_8.text_icon
	var_22_9.style.text.text_color = var_22_8.color
	var_22_9.style.icon.color = var_22_8.color

	local var_22_10 = DifficultySettings[arg_22_1]
	local var_22_11 = var_22_10.display_name
	local var_22_12 = var_22_10.display_image

	var_22_1.content.difficulty_text = Localize(var_22_11)
	var_22_1.content.difficulty_icon = var_22_12

	local var_22_13 = 10
	local var_22_14 = 0
	local var_22_15 = arg_22_0:_setup_curses(arg_22_7, var_22_13, var_22_14)
	local var_22_16 = arg_22_0:_setup_boons(arg_22_8, var_22_13, var_22_15)
	local var_22_17 = math.abs(arg_22_0.scenegraph_definition.game_option_deus_weekly.size[2] - math.abs(var_22_16))

	if var_22_17 > 0 then
		local var_22_18 = arg_22_0.ui_scenegraph
		local var_22_19 = "game_option_deus_weekly_anchor"
		local var_22_20 = "scrollbar_window"
		local var_22_21 = true
		local var_22_22
		local var_22_23

		arg_22_0._scrollbar_ui = ScrollbarUI:new(var_22_18, var_22_19, var_22_20, var_22_17, var_22_21, var_22_22, var_22_23)
	end
end

local var_0_18 = {}

function MissionVotingUI._setup_curses(arg_23_0, arg_23_1, arg_23_2, arg_23_3)
	local var_23_0 = "curse"
	local var_23_1 = var_0_16("cw_weekly_expedition_modifier_negative", arg_23_3, var_23_0)
	local var_23_2 = UIWidget.init(var_23_1)

	arg_23_0._deus_weekly_event_widgets[#arg_23_0._deus_weekly_event_widgets + 1] = var_23_2
	arg_23_0._deus_weekly_event_widgets_by_name.curse_header = var_23_2
	arg_23_3 = arg_23_3 - 40 - arg_23_2

	local var_23_3 = arg_23_1 or var_0_18
	local var_23_4 = RESOLUTION_LOOKUP.inv_scale

	for iter_23_0, iter_23_1 in ipairs(var_23_3) do
		local var_23_5 = MutatorTemplates[iter_23_1]
		local var_23_6 = var_23_5.display_name
		local var_23_7 = var_23_5.icon
		local var_23_8 = Localize(var_23_5.description)
		local var_23_9 = var_0_17(var_23_7, var_23_6, var_23_8, arg_23_3, arg_23_2)
		local var_23_10 = UIWidget.init(var_23_9)

		arg_23_0._deus_weekly_event_widgets[#arg_23_0._deus_weekly_event_widgets + 1] = var_23_10
		arg_23_0._deus_weekly_event_widgets_by_name["curse_" .. iter_23_0] = var_23_10

		local var_23_11 = var_23_10.style.desc
		local var_23_12, var_23_13 = UIFontByResolution(var_23_11)
		local var_23_14 = var_23_12[1]
		local var_23_15 = var_23_13
		local var_23_16 = arg_23_0.ui_top_renderer.gui
		local var_23_17, var_23_18, var_23_19 = UIGetFontHeight(var_23_16, var_23_11.font_type, var_23_15)
		local var_23_20 = (var_23_19 - var_23_18) * var_23_4
		local var_23_21, var_23_22 = UIRenderer.word_wrap(arg_23_0.ui_top_renderer, var_23_8, var_23_14, var_23_15, var_23_11.area_size[1])

		arg_23_3 = arg_23_3 - var_23_20 * #var_23_21

		local var_23_23 = var_23_10.style.title
		local var_23_24, var_23_25 = UIFontByResolution(var_23_23)
		local var_23_26 = var_23_24[1]
		local var_23_27 = var_23_25
		local var_23_28, var_23_29, var_23_30 = UIGetFontHeight(var_23_16, var_23_23.font_type, var_23_27)
		local var_23_31 = (var_23_30 - var_23_29) * var_23_4
		local var_23_32, var_23_33 = UIRenderer.word_wrap(arg_23_0.ui_top_renderer, Localize(var_23_6), var_23_26, var_23_27, var_23_23.area_size[1])

		arg_23_3 = arg_23_3 - var_23_31 * #var_23_32 - arg_23_2
	end

	return arg_23_3 - arg_23_2
end

function MissionVotingUI._setup_boons(arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = "boon"
	local var_24_1 = var_0_16("cw_weekly_expedition_modifier_positive", arg_24_3, var_24_0)
	local var_24_2 = UIWidget.init(var_24_1)

	arg_24_0._deus_weekly_event_widgets[#arg_24_0._deus_weekly_event_widgets + 1] = var_24_2
	arg_24_0._deus_weekly_event_widgets_by_name.boon_header = var_24_2
	arg_24_3 = arg_24_3 - 40 - arg_24_2

	local var_24_3 = Managers.player:local_player()
	local var_24_4 = var_24_3:profile_index()
	local var_24_5 = var_24_3:career_index()
	local var_24_6 = arg_24_1 or var_0_18
	local var_24_7 = RESOLUTION_LOOKUP.inv_scale

	for iter_24_0, iter_24_1 in ipairs(var_24_6) do
		local var_24_8 = DeusPowerUpsLookup[iter_24_1]
		local var_24_9 = var_24_8.display_name
		local var_24_10 = DeusPowerUpUtils.get_power_up_icon(var_24_8, var_24_4, var_24_5)
		local var_24_11 = DeusPowerUpUtils.get_power_up_description(var_24_8, var_24_4, var_24_5)
		local var_24_12 = var_0_17(var_24_10, var_24_9, var_24_11, arg_24_3)
		local var_24_13 = UIWidget.init(var_24_12)

		arg_24_0._deus_weekly_event_widgets[#arg_24_0._deus_weekly_event_widgets + 1] = var_24_13
		arg_24_0._deus_weekly_event_widgets_by_name["boon_" .. iter_24_0] = var_24_13

		local var_24_14 = var_24_13.style.desc
		local var_24_15, var_24_16 = UIFontByResolution(var_24_14)
		local var_24_17 = var_24_15[1]
		local var_24_18 = var_24_16
		local var_24_19 = arg_24_0.ui_top_renderer.gui
		local var_24_20, var_24_21, var_24_22 = UIGetFontHeight(var_24_19, var_24_14.font_type, var_24_18)
		local var_24_23 = (var_24_22 - var_24_21) * var_24_7
		local var_24_24, var_24_25 = UIRenderer.word_wrap(arg_24_0.ui_top_renderer, var_24_11, var_24_17, var_24_18, var_24_14.area_size[1])

		arg_24_3 = arg_24_3 - var_24_23 * #var_24_24

		local var_24_26 = var_24_13.style.title
		local var_24_27, var_24_28 = UIFontByResolution(var_24_26)
		local var_24_29 = var_24_27[1]
		local var_24_30 = var_24_28
		local var_24_31, var_24_32, var_24_33 = UIGetFontHeight(var_24_19, var_24_26.font_type, var_24_30)
		local var_24_34 = (var_24_33 - var_24_32) * var_24_7
		local var_24_35, var_24_36 = UIRenderer.word_wrap(arg_24_0.ui_top_renderer, Localize(var_24_9), var_24_29, var_24_30, var_24_26.area_size[1])

		arg_24_3 = arg_24_3 - var_24_34 * #var_24_35 - arg_24_2
	end

	return arg_24_3 - arg_24_2
end

function MissionVotingUI._set_deus_custom_game_presentation(arg_25_0, arg_25_1, arg_25_2, arg_25_3, arg_25_4, arg_25_5, arg_25_6)
	arg_25_0._presentation_type = "deus_custom"

	local var_25_0 = arg_25_0._deus_custom_widgets_by_name
	local var_25_1 = var_25_0.game_option_1
	local var_25_2 = var_25_1.content
	local var_25_3 = DeusJourneySettings[arg_25_2]
	local var_25_4 = var_25_3.display_name
	local var_25_5 = var_25_3.level_image

	if not LevelUnlockUtils.completed_journey_difficulty_index(arg_25_0.statistics_db, arg_25_0._stats_id, arg_25_2) then
		local var_25_6 = 0
	end

	local var_25_7 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_25_5)

	var_25_2.icon = var_25_5
	var_25_2.show_journey_border = true
	var_25_2.with_belakor = Managers.backend:get_interface("deus"):deus_journey_with_belakor(arg_25_2)

	local var_25_8 = var_25_1.style.icon.texture_size

	var_25_8[1] = var_25_7.size[1]
	var_25_8[2] = var_25_7.size[2]
	var_25_0.journey_name.content.text = var_25_4

	local var_25_9 = DeusThemeSettings[arg_25_6]

	var_25_2.theme_icon = var_25_9.icon

	local var_25_10 = var_25_0.journey_theme

	var_25_10.content.text = var_25_9.journey_title
	var_25_10.content.icon = var_25_9.text_icon
	var_25_10.style.text.text_color = var_25_9.color
	var_25_10.style.icon.color = var_25_9.color

	local var_25_11 = DifficultySettings[arg_25_1]
	local var_25_12 = var_25_11.display_name
	local var_25_13 = var_25_11.display_image
	local var_25_14 = var_25_0.game_option_2

	var_25_14.content.option_text = Localize(var_25_12)
	var_25_14.content.icon = var_25_13
	var_25_0.additional_option.content.option_text = ""

	local var_25_15 = var_25_0.private_button

	var_25_15.content.button_hotspot.disable_button = true
	var_25_15.content.button_hotspot.is_selected = arg_25_3
	var_25_15.style.hover_glow.color[1] = 0

	local var_25_16 = var_25_0.host_button

	var_25_16.content.button_hotspot.disable_button = true
	var_25_16.content.button_hotspot.is_selected = arg_25_4
	var_25_16.style.hover_glow.color[1] = 0

	local var_25_17 = var_25_0.strict_matchmaking_button

	var_25_17.content.button_hotspot.disable_button = true
	var_25_17.content.button_hotspot.is_selected = arg_25_5
	var_25_17.style.hover_glow.color[1] = 0
end

function MissionVotingUI._set_versus_quickplay_presentation(arg_26_0, arg_26_1)
	arg_26_0._presentation_type = "versus_quickplay"
end

function MissionVotingUI._set_versus_custom_game_presentation(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5)
	local var_27_0 = arg_27_0._versus_custom_widgets_by_name
	local var_27_1 = var_27_0.game_option_1
	local var_27_2 = var_27_1.content
	local var_27_3
	local var_27_4
	local var_27_6

	if arg_27_2 == "any" then
		local var_27_5 = "random_level"

		var_27_6 = "level_image_any"
	else
		local var_27_7 = LevelSettings[arg_27_2]
		local var_27_8 = var_27_7.display_name

		var_27_6 = var_27_7.level_image
	end

	local var_27_9 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_27_6)

	var_27_2.icon = var_27_6

	local var_27_10 = var_27_1.style.icon.texture_size

	var_27_10[1] = var_27_9.size[1]
	var_27_10[2] = var_27_9.size[2]

	local var_27_11 = DifficultySettings[arg_27_1]
	local var_27_12 = var_27_11.display_name
	local var_27_13 = var_27_11.display_image
	local var_27_14 = var_27_0.game_option_2

	var_27_14.content.option_text = Localize(var_27_12)
	var_27_14.content.icon = var_27_13
	var_27_0.additional_option.content.option_text = ""

	local var_27_15 = var_27_0.player_hosted_button

	var_27_15.content.button_hotspot.disable_button = true
	var_27_15.content.button_hotspot.is_selected = arg_27_3
	var_27_15.style.hover_glow.color[1] = 0

	local var_27_16 = var_27_0.dedicated_server_win_button

	var_27_16.content.button_hotspot.disable_button = true
	var_27_16.content.button_hotspot.is_selected = arg_27_4
	var_27_16.style.hover_glow.color[1] = 0

	local var_27_17 = var_27_0.dedicated_server_aws_button

	var_27_17.content.button_hotspot.disable_button = true
	var_27_17.content.button_hotspot.is_selected = arg_27_5
	var_27_17.style.hover_glow.color[1] = 0
	arg_27_0._presentation_type = "versus_custom"
end

function MissionVotingUI._update_vote_timer(arg_28_0)
	local var_28_0 = arg_28_0.voting_manager
	local var_28_1 = var_28_0:active_vote_template().duration
	local var_28_2 = var_28_0:vote_time_left()
	local var_28_3 = math.max(var_28_2 / var_28_1, 0)

	arg_28_0:_set_vote_time_progress(var_28_3)
end

function MissionVotingUI._set_vote_time_progress(arg_29_0, arg_29_1)
	local var_29_0 = arg_29_0:get_chrome_widgets().timer_fg
	local var_29_1 = var_29_0.content.texture_id.uvs
	local var_29_2 = var_29_0.scenegraph_id
	local var_29_3 = arg_29_0.scenegraph_definition[var_29_2].size

	arg_29_0.ui_scenegraph[var_29_2].size[1] = var_29_3[1] * arg_29_1
	var_29_1[2][1] = arg_29_1
end

function MissionVotingUI._update_animations(arg_30_0, arg_30_1, arg_30_2)
	for iter_30_0, iter_30_1 in pairs(arg_30_0._ui_animations) do
		UIAnimation.update(iter_30_1, arg_30_1)

		if UIAnimation.completed(iter_30_1) then
			arg_30_0._ui_animations[iter_30_0] = nil
		end
	end
end

function MissionVotingUI.update(arg_31_0, arg_31_1, arg_31_2)
	local var_31_0 = arg_31_0._parent:parent()
	local var_31_1 = var_31_0.menu_active or var_31_0.current_view or var_31_0._transition_fade_data

	arg_31_0.menu_active = var_31_1

	arg_31_0:_update_animations(arg_31_1, arg_31_2)

	local var_31_2 = arg_31_0.voting_manager

	if var_31_2:vote_in_progress() and var_31_2:is_mission_vote() and not var_31_2:has_voted(Network.peer_id()) then
		if not var_31_1 then
			if not arg_31_0.vote_started then
				arg_31_0:start_vote(var_31_2.active_voting)
			end

			arg_31_0:_update_vote_timer()

			local var_31_3 = arg_31_0:get_chrome_widgets()

			UIWidgetUtils.animate_default_button(var_31_3.button_abort, arg_31_1)

			if not arg_31_0.has_voted then
				local var_31_4 = Managers.input:is_device_active("gamepad")
				local var_31_5 = var_31_2.active_voting
				local var_31_6 = var_31_5 and var_31_5.template

				if var_31_6 then
					local var_31_7 = arg_31_0.input_manager:get_service("mission_voting")

					if var_31_4 and var_31_6.gamepad_support then
						local var_31_8 = var_31_6.vote_options

						for iter_31_0 = 1, #var_31_8 do
							local var_31_9 = var_31_8[iter_31_0]

							if var_31_7:get(var_31_9.gamepad_input) then
								var_31_2:vote(var_31_9.vote)
								arg_31_0:on_vote_casted(var_31_8.vote == 1)

								break
							end
						end
					elseif UIUtils.is_button_pressed(var_31_3.button_confirm) or var_31_7:get("confirm_press") then
						var_31_2:vote(1)
						arg_31_0:on_vote_casted(true)
					elseif UIUtils.is_button_pressed(var_31_3.button_abort) or var_31_7:get("toggle_menu") then
						var_31_2:vote(2)
						arg_31_0:on_vote_casted(false)
					elseif UIUtils.is_button_hover_enter(var_31_3.button_confirm) or UIUtils.is_button_hover_enter(var_31_3.button_abort) then
						arg_31_0:_play_sound("Play_hud_hover")
					end
				end

				if arg_31_0.gamepad_active ~= var_31_4 and var_31_6 then
					local var_31_10 = var_31_6.vote_options

					arg_31_0:setup_option_input(var_31_3.button_confirm, var_31_10[1])
					arg_31_0:setup_option_input(var_31_3.button_abort, var_31_10[2])

					arg_31_0.gamepad_active = var_31_4
				end
			end
		end
	elseif arg_31_0.vote_started then
		arg_31_0:on_vote_ended()
	end

	if arg_31_0.vote_started and not arg_31_0.has_voted then
		arg_31_0:draw(arg_31_1, arg_31_2)
	end
end

function MissionVotingUI.draw(arg_32_0, arg_32_1, arg_32_2)
	arg_32_0:_update_pulse_animations(arg_32_1)

	local var_32_0 = arg_32_0.ui_top_renderer
	local var_32_1 = arg_32_0.render_settings
	local var_32_2 = arg_32_0.ui_scenegraph
	local var_32_3 = arg_32_0.input_manager:get_service("mission_voting")
	local var_32_4 = 1

	var_32_1.alpha_multiplier = var_32_4
	var_32_2.window.local_position[2] = -50 + var_32_4 * 50

	UIRenderer.begin_pass(var_32_0, var_32_2, var_32_3, arg_32_1, nil, var_32_1)

	local var_32_5 = var_32_1.snap_pixel_positions
	local var_32_6, var_32_7 = arg_32_0:get_chrome_widgets()

	for iter_32_0 = 1, #var_32_7 do
		local var_32_8 = var_32_7[iter_32_0]

		if var_32_8.snap_pixel_positions ~= nil then
			var_32_1.snap_pixel_positions = var_32_8.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_32_0, var_32_8)

		var_32_1.snap_pixel_positions = var_32_5
	end

	if not arg_32_0._twitch_mode_enabled and (Managers.twitch:is_connecting() or Managers.twitch:is_connected()) and not Managers.twitch:game_mode_supported(arg_32_0._matchmaking_type, arg_32_0._difficulty) then
		local var_32_9 = arg_32_0._twitch_widgets_by_name.twitch_disclaimer

		UIRenderer.draw_widget(var_32_0, var_32_9)
	elseif arg_32_0._twitch_mode_enabled then
		local var_32_10 = arg_32_0._twitch_widgets_by_name.twitch_mode

		UIRenderer.draw_widget(var_32_0, var_32_10)
	end

	local var_32_11 = arg_32_0._presentation_type

	if var_32_11 then
		if var_32_11 == "adventure" then
			local var_32_12 = arg_32_0._adventure_game_widgets

			for iter_32_1 = 1, #var_32_12 do
				local var_32_13 = var_32_12[iter_32_1]

				if var_32_13.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_13.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_13)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "custom" then
			local var_32_14 = arg_32_0._custom_game_widgets

			for iter_32_2 = 1, #var_32_14 do
				local var_32_15 = var_32_14[iter_32_2]

				if var_32_15.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_15.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_15)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "deed" then
			local var_32_16 = arg_32_0._deed_widgets

			for iter_32_3 = 1, #var_32_16 do
				local var_32_17 = var_32_16[iter_32_3]

				if var_32_17.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_17.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_17)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "event" then
			local var_32_18 = arg_32_0._event_game_widgets

			for iter_32_4 = 1, #var_32_18 do
				local var_32_19 = var_32_18[iter_32_4]

				if var_32_19.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_19.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_19)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "weave" then
			local var_32_20 = arg_32_0._weave_game_widgets

			for iter_32_5 = 1, #var_32_20 do
				local var_32_21 = var_32_20[iter_32_5]

				if var_32_21.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_21.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_21)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "weave_quickplay" then
			local var_32_22 = arg_32_0._weave_quickplay_widgets

			for iter_32_6 = 1, #var_32_22 do
				local var_32_23 = var_32_22[iter_32_6]

				if var_32_23.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_23.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_23)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "deus_quickplay" then
			local var_32_24 = arg_32_0._deus_quickplay_widgets

			for iter_32_7 = 1, #var_32_24 do
				local var_32_25 = var_32_24[iter_32_7]

				if var_32_25.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_25.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_25)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "deus_custom" then
			local var_32_26 = arg_32_0._deus_custom_widgets

			for iter_32_8 = 1, #var_32_26 do
				local var_32_27 = var_32_26[iter_32_8]

				if var_32_27.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_27.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_27)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "game_mode" then
			local var_32_28 = arg_32_0._game_mode_widgets

			for iter_32_9 = 1, #var_32_28 do
				local var_32_29 = var_32_28[iter_32_9]

				if var_32_29.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_29.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_29)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "switch_mechanism" then
			local var_32_30 = arg_32_0._switch_mechanism_widgets

			for iter_32_10 = 1, #var_32_30 do
				local var_32_31 = var_32_30[iter_32_10]

				if var_32_31.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_31.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_31)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "versus_quickplay" then
			local var_32_32 = arg_32_0._versus_quickplay_widgets

			for iter_32_11 = 1, #var_32_32 do
				local var_32_33 = var_32_32[iter_32_11]

				if var_32_33.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_33.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_33)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "versus_custom" then
			local var_32_34 = arg_32_0._versus_custom_widgets

			for iter_32_12 = 1, #var_32_34 do
				local var_32_35 = var_32_34[iter_32_12]

				if var_32_35.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_35.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_35)

				var_32_1.snap_pixel_positions = var_32_5
			end
		elseif var_32_11 == "deus_weekly" then
			local var_32_36 = arg_32_0._deus_weekly_event_widgets

			for iter_32_13 = 1, #var_32_36 do
				local var_32_37 = var_32_36[iter_32_13]

				if var_32_37.snap_pixel_positions ~= nil then
					var_32_1.snap_pixel_positions = var_32_37.snap_pixel_positions
				end

				UIRenderer.draw_widget(var_32_0, var_32_37)

				var_32_1.snap_pixel_positions = var_32_5
			end
		end
	end

	UIRenderer.end_pass(var_32_0)

	if arg_32_0.input_manager:is_device_active("gamepad") then
		arg_32_0._menu_input_description:draw(var_32_0, arg_32_1)
	end

	if arg_32_0._scrollbar_ui then
		arg_32_0._scrollbar_ui:update(arg_32_1, arg_32_2, var_32_0, var_32_3, var_32_1)
	end
end

function MissionVotingUI._update_pulse_animations(arg_33_0, arg_33_1)
	if arg_33_0.has_voted then
		return
	end

	local var_33_0 = arg_33_0.menu_active

	if not var_33_0 then
		local var_33_1 = var_33_0 and 5 or 8
		local var_33_2 = 100 + (var_33_0 and 0 or 0.5 + math.sin(Managers.time:time("ui") * var_33_1) * 0.5) * 155
		local var_33_3 = arg_33_0._widgets_by_name

		var_33_3.timer_fg.style.texture_id.color[1] = var_33_2
		var_33_3.timer_glow.style.texture_id.color[1] = var_33_2
	end
end

function MissionVotingUI._acquire_input(arg_34_0, arg_34_1)
	arg_34_0:_release_input(true)
	arg_34_0.input_manager:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "mission_voting", "MissionVotingUI")

	if not arg_34_1 then
		ShowCursorStack.show("MissionVotingUI")
	end
end

function MissionVotingUI._release_input(arg_35_0, arg_35_1)
	arg_35_0.input_manager:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, "mission_voting", "MissionVotingUI")

	if not arg_35_1 then
		ShowCursorStack.hide("MissionVotingUI")
	end
end

function MissionVotingUI.active_input_service(arg_36_0)
	local var_36_0 = arg_36_0.input_manager
	local var_36_1 = "mission_voting"

	return (var_36_0:get_service(var_36_1))
end

function MissionVotingUI._play_sound(arg_37_0, arg_37_1)
	WwiseWorld.trigger_event(arg_37_0.wwise_world, arg_37_1)
end
