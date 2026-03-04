-- chunkname: @scripts/ui/views/character_selection_view/states/character_selection_state_character.lua

require("scripts/settings/profiles/sp_profiles")
require("scripts/ui/hud_ui/scrollbar_ui")

local var_0_0 = local_require("scripts/ui/views/character_selection_view/states/definitions/character_selection_state_character_definitions")
local var_0_1 = var_0_0.character_selection_widgets
local var_0_2 = var_0_0.widgets
local var_0_3 = var_0_0.info_widgets
local var_0_4 = var_0_0.bot_selection_widgets
local var_0_5 = var_0_0.hero_widget
local var_0_6 = var_0_0.empty_hero_widget
local var_0_7 = var_0_0.hero_icon_widget
local var_0_8 = var_0_0.generic_input_actions
local var_0_9 = var_0_0.animation_definitions
local var_0_10 = var_0_0.scenegraph_definition
local var_0_11 = false
local var_0_12 = 240
local var_0_13 = "CharacterSelectionStateCharacter"

CharacterSelectionStateCharacter = class(CharacterSelectionStateCharacter)
CharacterSelectionStateCharacter.NAME = "CharacterSelectionStateCharacter"

CharacterSelectionStateCharacter.on_enter = function (arg_1_0, arg_1_1)
	arg_1_0.parent:clear_wanted_state()
	print("[HeroViewState] Enter Substate CharacterSelectionStateCharacter")

	local var_1_0 = arg_1_1.state_params

	arg_1_0._hero_name = arg_1_1.hero_name

	local var_1_1 = arg_1_1.ingame_ui_context

	arg_1_0.ui_top_renderer = var_1_1.ui_top_renderer
	arg_1_0.input_manager = var_1_1.input_manager
	arg_1_0.statistics_db = var_1_1.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0.profile_synchronizer = var_1_1.profile_synchronizer
	arg_1_0.is_server = var_1_1.is_server
	arg_1_0._close_on_successful_profile_request = true
	arg_1_0.world_previewer = arg_1_1.world_previewer
	arg_1_0.wwise_world = arg_1_1.wwise_world
	arg_1_0.platform = PLATFORM
	arg_1_0.allow_back_button = arg_1_1.allow_back_button

	if arg_1_1.pick_time then
		arg_1_0.pick_time = arg_1_1.pick_time
	end

	local var_1_2 = Managers.player
	local var_1_3 = var_1_2:local_player()

	arg_1_0._stats_id = var_1_3:stats_id()
	arg_1_0.player_manager = var_1_2
	arg_1_0.peer_id = var_1_1.peer_id
	arg_1_0.local_player_id = var_1_1.local_player_id
	arg_1_0.local_player = var_1_3
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._available_profiles = {}
	arg_1_0._profile_requester = (var_1_1.network_server or var_1_1.network_client):profile_requester()

	local var_1_4 = arg_1_0.parent
	local var_1_5 = arg_1_0:input_service()
	local var_1_6 = UILayer.default + 130
	local var_1_7 = var_1_4:input_service(true)

	arg_1_0.menu_input_description = MenuInputDescriptionUI:new(var_1_1, arg_1_0.ui_top_renderer, var_1_7, 6, var_1_6, arg_1_1.allow_back_button and var_0_8.default_back or var_0_8.default, true)

	arg_1_0.menu_input_description:set_input_description(nil)
	arg_1_0:create_ui_elements(arg_1_1)
	arg_1_0:_start_transition_animation("on_enter", "on_enter")

	arg_1_0._hero_preview_skin = nil
	arg_1_0.use_user_skins = true
	arg_1_0.use_loadout_items = false

	local var_1_8 = arg_1_0._hero_name
	local var_1_9 = arg_1_1.profile_id

	if var_1_9 and var_1_9 > 0 then
		arg_1_0._career_index = arg_1_1.career_id
		arg_1_0._close_on_successful_profile_request = false

		arg_1_0:_select_hero(var_1_9, arg_1_0._career_index, true)
		arg_1_0:_change_profile(var_1_9, arg_1_0._career_index)
	else
		local var_1_10, var_1_11 = arg_1_0.profile_synchronizer:profile_by_peer(arg_1_0.peer_id, arg_1_0.local_player_id)

		if var_1_10 and var_1_8 then
			local var_1_12 = Managers.backend:get_interface("hero_attributes")

			arg_1_0._career_index = var_1_11

			arg_1_0:_select_hero(var_1_10, arg_1_0._career_index, true)
		end
	end

	arg_1_0.parent:set_input_blocked(false)
end

CharacterSelectionStateCharacter._update_video_player_settings = function (arg_2_0)
	local var_2_0 = arg_2_0.world_previewer:character_visible()

	if var_2_0 and not arg_2_0._video_widget then
		local var_2_1 = arg_2_0._current_video_settings.material_name
		local var_2_2 = arg_2_0._current_video_settings.resource

		if var_2_1 and var_2_2 then
			arg_2_0:_setup_video_player(var_2_1, var_2_2)

			arg_2_0._draw_video_next_frame = true
		end
	elseif not var_2_0 then
		arg_2_0:_destroy_video_player()
	end
end

CharacterSelectionStateCharacter._setup_video_player = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0:_destroy_video_player()

	local var_3_0 = arg_3_0.ui_top_renderer
	local var_3_1 = true
	local var_3_2, var_3_3 = arg_3_0.parent:get_background_world()

	UIRenderer.create_video_player(var_3_0, var_0_13, var_3_2, arg_3_2, var_3_1)

	local var_3_4 = "info_window_video"
	local var_3_5 = UIWidgets.create_video(var_3_4, arg_3_1, var_0_13)

	arg_3_0._video_widget = UIWidget.init(var_3_5)
	arg_3_0._video_created = true
end

CharacterSelectionStateCharacter._destroy_video_player = function (arg_4_0)
	local var_4_0 = arg_4_0.ui_top_renderer
	local var_4_1 = arg_4_0._video_widget

	if var_4_1 then
		UIWidget.destroy(var_4_0, var_4_1)

		arg_4_0._video_widget = nil
	end

	if var_4_0 and var_4_0.video_players[var_0_13] then
		local var_4_2, var_4_3 = arg_4_0.parent:get_background_world()

		UIRenderer.destroy_video_player(var_4_0, var_0_13, var_4_2)
	end

	arg_4_0._video_created = nil
end

CharacterSelectionStateCharacter._inject_additional_scenegraph_definitions = function (arg_5_0, arg_5_1)
	for iter_5_0, iter_5_1 in pairs(CareerSettings) do
		if iter_5_1.additional_ui_info_file then
			local var_5_0 = local_require(iter_5_1.additional_ui_info_file)

			for iter_5_2, iter_5_3 in pairs(var_5_0.scenegraph_definition_to_inject) do
				arg_5_1[iter_5_2] = iter_5_3
			end
		end
	end
end

CharacterSelectionStateCharacter.create_ui_elements = function (arg_6_0, arg_6_1)
	arg_6_0:_inject_additional_scenegraph_definitions(var_0_10)

	arg_6_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_10)

	local var_6_0 = {}
	local var_6_1 = {}
	local var_6_2 = {}
	local var_6_3 = {}

	for iter_6_0, iter_6_1 in pairs(var_0_2) do
		local var_6_4 = UIWidget.init(iter_6_1)

		var_6_0[#var_6_0 + 1] = var_6_4
		var_6_3[iter_6_0] = var_6_4
	end

	for iter_6_2, iter_6_3 in pairs(var_0_3) do
		local var_6_5 = UIWidget.init(iter_6_3)

		var_6_1[#var_6_1 + 1] = var_6_5
		var_6_3[iter_6_2] = var_6_5
	end

	for iter_6_4, iter_6_5 in pairs(var_0_4) do
		local var_6_6 = UIWidget.init(iter_6_5)

		var_6_2[#var_6_2 + 1] = var_6_6
		var_6_3[iter_6_4] = var_6_6
	end

	arg_6_0._widgets = var_6_0
	arg_6_0._info_widgets = var_6_1
	arg_6_0._bot_selection_widgets = var_6_2
	arg_6_0._widgets_by_name = var_6_3
	arg_6_0._additional_widgets = {}
	arg_6_0._additional_widgets_by_name = {}

	arg_6_0:_setup_hero_selection_widgets()
	UIRenderer.clear_scenegraph_queue(arg_6_0.ui_top_renderer)

	arg_6_0.ui_animator = UIAnimator:new(arg_6_0._ui_scenegraph, var_0_9)
end

CharacterSelectionStateCharacter._set_hero_icon_selected = function (arg_7_0, arg_7_1)
	for iter_7_0, iter_7_1 in ipairs(arg_7_0._hero_icon_widgets) do
		iter_7_1.content.selected = iter_7_0 == arg_7_1
	end
end

CharacterSelectionStateCharacter._setup_hero_selection_widgets = function (arg_8_0)
	local var_8_0 = {}

	arg_8_0._hero_widgets = var_8_0

	local var_8_1 = {}

	arg_8_0._hero_icon_widgets = var_8_1

	local var_8_2 = Managers.backend:get_interface("hero_attributes")
	local var_8_3 = Managers.backend:get_interface("dlcs")
	local var_8_4 = #SPProfilesAbbreviation
	local var_8_5 = ProfilePriority
	local var_8_6 = PlayerData.bot_spawn_priority

	if not var_8_6[1] then
		var_8_6 = ProfileIndexToPriorityIndex
	end

	arg_8_0._num_hero_columns = {}

	for iter_8_0, iter_8_1 in ipairs(var_8_6) do
		local var_8_7 = SPProfiles[iter_8_1]
		local var_8_8 = var_8_7.display_name
		local var_8_9 = var_8_2:get(var_8_8, "experience") or 0
		local var_8_10 = ExperienceSettings.get_level(var_8_9)
		local var_8_11 = var_8_7.careers
		local var_8_12 = UIWidget.init(var_0_7)

		var_8_1[#var_8_1 + 1] = var_8_12
		var_8_12.offset[2] = -((iter_8_0 - 1) * 144)
		var_8_12.content.bot_order_texture_id = "bot_order_" .. tostring(iter_8_0)

		local var_8_13 = "hero_icon_large_" .. var_8_8

		var_8_12.content.icon = var_8_13
		var_8_12.content.icon_selected = var_8_13 .. "_glow"

		local var_8_14 = 0

		for iter_8_2 = 1, 4 do
			local var_8_15 = var_8_11[iter_8_2]

			if var_8_15 and not var_8_3:is_unreleased_career(var_8_15.name) then
				var_8_14 = var_8_14 + 1

				local var_8_16 = UIWidget.init(var_0_5)

				var_8_0[#var_8_0 + 1] = var_8_16

				local var_8_17 = var_8_16.offset
				local var_8_18 = var_8_16.content

				var_8_18.career_settings = var_8_15

				local var_8_19 = var_8_15.portrait_image

				var_8_18.portrait = "medium_" .. var_8_19

				local var_8_20, var_8_21, var_8_22, var_8_23 = var_8_15:is_unlocked_function(var_8_8, var_8_10)

				var_8_18.locked = not var_8_20
				var_8_18.locked_reason = not var_8_20 and (var_8_23 and var_8_21 or Localize(var_8_21))
				var_8_18.dlc_name = var_8_22

				if var_8_21 == "dlc_not_owned" then
					var_8_18.lock_texture = var_8_18.lock_texture .. "_gold"
					var_8_18.frame = var_8_18.frame .. "_gold"
				end

				local var_8_24 = var_8_2:get(var_8_8, "career")
				local var_8_25 = var_8_2:get(var_8_8, "bot_career") or var_8_24 or 1
				local var_8_26 = table.find(var_8_6, iter_8_1)

				if var_8_25 == iter_8_2 and var_8_26 <= 5 then
					var_8_18.bot_priority = var_8_26
					var_8_18.bot_selected = true
				end

				var_8_17[1] = (iter_8_2 - 1) * 124
				var_8_17[2] = -((iter_8_0 - 1) * 144)
			else
				local var_8_27 = (iter_8_2 - 1) * 124

				var_8_12.style.bg.offset[1] = var_8_12.style.bg.offset[1] + var_8_27
				var_8_12.style.hourglass_icon.offset[1] = var_8_12.style.hourglass_icon.offset[1] + var_8_27
				var_8_12.content.use_empty_icon = true
			end
		end

		arg_8_0._num_hero_columns[iter_8_0] = var_8_14
	end

	arg_8_0._num_max_hero_rows = var_8_4
end

CharacterSelectionStateCharacter._update_available_profiles = function (arg_9_0)
	local var_9_0 = arg_9_0._available_profiles
	local var_9_1 = arg_9_0._hero_widgets
	local var_9_2 = Managers.player:local_player()
	local var_9_3 = arg_9_0.profile_synchronizer
	local var_9_4 = var_9_2 ~= nil and var_9_2:profile_index()
	local var_9_5

	var_9_5 = var_9_2 ~= nil and var_9_2:career_index()

	local var_9_6 = Managers.backend:get_interface("hero_attributes")
	local var_9_7 = ProfilePriority
	local var_9_8 = PlayerData.bot_spawn_priority

	if not var_9_8[1] then
		var_9_8 = ProfileIndexToPriorityIndex
	end

	local var_9_9 = 1
	local var_9_10 = arg_9_0._selected_career_index
	local var_9_11 = arg_9_0._selected_profile_index
	local var_9_12 = Managers.mechanism

	for iter_9_0, iter_9_1 in ipairs(var_9_8) do
		local var_9_13 = SPProfiles[iter_9_1]
		local var_9_14 = false

		if var_9_2 then
			local var_9_15 = var_9_2:network_id()
			local var_9_16, var_9_17 = Managers.party:get_party_from_unique_id(var_9_2:unique_id())

			var_9_14 = var_9_12:profile_available_for_peer(var_9_17, var_9_15, iter_9_1)
		end

		local var_9_18 = var_9_4 == iter_9_1 or var_9_14
		local var_9_19 = var_9_13.careers

		for iter_9_2, iter_9_3 in ipairs(var_9_19) do
			local var_9_20 = var_9_1[var_9_9]

			if var_9_20 then
				local var_9_21 = var_9_20.content
				local var_9_22 = var_9_21.locked

				var_9_21.taken = not var_9_18

				if iter_9_2 == var_9_10 and var_9_11 == iter_9_1 then
					arg_9_0:_set_select_button_enabled(var_9_18 and not var_9_22, var_9_22 and var_9_21.dlc_name, var_9_21.dlc_name)
				end
			end

			var_9_9 = var_9_9 + 1
		end
	end
end

CharacterSelectionStateCharacter._handle_mouse_selection = function (arg_10_0)
	local var_10_0 = arg_10_0._hero_widgets
	local var_10_1 = arg_10_0._num_max_hero_rows
	local var_10_2 = arg_10_0._selected_hero_row
	local var_10_3 = arg_10_0._selected_hero_column
	local var_10_4 = ProfilePriority
	local var_10_5 = Managers.backend:get_interface("hero_attributes")
	local var_10_6 = PlayerData.bot_spawn_priority
	local var_10_7 = 1

	for iter_10_0 = 1, var_10_1 do
		local var_10_8 = arg_10_0._num_hero_columns[iter_10_0]

		for iter_10_1 = 1, var_10_8 do
			if var_10_0[var_10_7].content.button_hotspot.on_pressed and (iter_10_0 ~= var_10_2 or iter_10_1 ~= var_10_3) then
				local var_10_9 = var_10_6[iter_10_0]
				local var_10_10 = iter_10_1

				arg_10_0:_select_hero(var_10_9, var_10_10)

				return
			end

			var_10_7 = var_10_7 + 1
		end
	end
end

CharacterSelectionStateCharacter._update_equipped_bots = function (arg_11_0)
	local var_11_0 = PlayerData.bot_spawn_priority

	if not var_11_0[1] then
		var_11_0 = ProfileIndexToPriorityIndex
	end

	local var_11_1 = Managers.backend:get_interface("hero_attributes")
	local var_11_2 = arg_11_0._hero_widgets
	local var_11_3 = 1

	for iter_11_0, iter_11_1 in ipairs(var_11_0) do
		local var_11_4 = SPProfiles[iter_11_1]
		local var_11_5 = var_11_4.display_name
		local var_11_6 = var_11_4.careers

		for iter_11_2, iter_11_3 in ipairs(var_11_6) do
			local var_11_7 = arg_11_0._hero_widgets[var_11_3].content
			local var_11_8 = var_11_1:get(var_11_5, "career")
			local var_11_9 = var_11_1:get(var_11_5, "bot_career") or iter_11_2 or 1
			local var_11_10 = table.find(var_11_0, iter_11_1)

			if var_11_9 == iter_11_2 and var_11_10 <= 5 then
				var_11_7.bot_priority = nil
				var_11_7.bot_selected = true
			else
				var_11_7.bot_priority = nil
				var_11_7.bot_selected = nil
			end

			var_11_3 = var_11_3 + 1
		end
	end
end

CharacterSelectionStateCharacter._exit_bot_selection = function (arg_12_0)
	arg_12_0.parent:set_input_blocked(false)
	arg_12_0:_setup_hero_selection_widgets()
	arg_12_0:_select_hero(arg_12_0._selected_profile_index, arg_12_0._selected_career_index, true)

	for iter_12_0, iter_12_1 in pairs(arg_12_0._hero_icon_widgets) do
		iter_12_1.content.bot_selection_active = false
	end

	arg_12_0._spawn_hero = true
	arg_12_0._bot_selection = nil
	arg_12_0._bot_priority_copy = nil
	arg_12_0._current_selected_bot_index = nil
	arg_12_0._current_selected_row = nil
	arg_12_0._x_offset = nil
	arg_12_0._base_y_offset = nil

	local var_12_0 = arg_12_0._widgets_by_name.background.style

	arg_12_0._ui_animations.background = UIAnimation.init(UIAnimation.function_by_time, var_12_0.rect.color, 1, var_12_0.rect.color[1], 0, 0.4, math.easeOutCubic)

	arg_12_0.menu_input_description:change_generic_actions(arg_12_0.allow_back_button and var_0_8.default_back or var_0_8.default)

	arg_12_0.render_settings.info_alpha_multiplier = 0
	arg_12_0.render_settings.bot_selection_alpha_multiplier = 0

	if arg_12_0.parent.show_hero_panel then
		arg_12_0.parent:show_hero_panel()
		arg_12_0.parent:set_input_blocked(false)
	end

	arg_12_0:_start_transition_animation("fade_out", "on_exit_bot_selection")
	arg_12_0:_play_sound("Play_hud_button_close")
end

CharacterSelectionStateCharacter._enter_bot_selection = function (arg_13_0, arg_13_1)
	arg_13_0._bot_selection = true
	arg_13_0._bot_priority_copy = table.clone(PlayerData.bot_spawn_priority)

	local var_13_0 = arg_13_0._hero_widgets
	local var_13_1 = 1

	for iter_13_0 = 1, #PlayerData.bot_spawn_priority do
		local var_13_2 = PlayerData.bot_spawn_priority[iter_13_0]
		local var_13_3 = #SPProfiles[var_13_2].careers

		for iter_13_1 = 1, var_13_3 do
			var_13_0[var_13_1].content.bot_selection_active = true
			var_13_1 = var_13_1 + 1
		end
	end

	for iter_13_2, iter_13_3 in pairs(arg_13_0._hero_icon_widgets) do
		iter_13_3.content.bot_selection_active = true
	end

	local var_13_4 = arg_13_0._widgets_by_name.background.style

	arg_13_0._ui_animations.background = UIAnimation.init(UIAnimation.function_by_time, var_13_4.rect.color, 1, var_13_4.rect.color[1], 128, 0.4, math.easeOutCubic)

	arg_13_0.menu_input_description:change_generic_actions(var_0_8.prioritize_bots)

	arg_13_0.render_settings.main_alpha_multiplier = 1
	arg_13_0.render_settings.info_alpha_multiplier = 0
	arg_13_0.render_settings.bot_selection_alpha_multiplier = 0

	if arg_13_0.parent.hide_hero_panel then
		arg_13_0.parent:hide_hero_panel()
		arg_13_0.parent:set_input_blocked(false)
	end

	arg_13_0:_start_transition_animation("fade_in", "on_enter_bot_selection")
	arg_13_0:_play_sound("Play_hud_button_open")
end

CharacterSelectionStateCharacter._handle_gamepad_selection = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_0._selected_hero_row
	local var_14_1 = arg_14_0._selected_hero_column
	local var_14_2 = arg_14_0._num_max_hero_rows
	local var_14_3 = ProfilePriority[var_14_0]
	local var_14_4 = PlayerData.bot_spawn_priority[var_14_0]
	local var_14_5 = #SPProfiles[var_14_4].careers
	local var_14_6 = true

	if arg_14_1:get("refresh") and not arg_14_0._bot_selection then
		arg_14_0:_enter_bot_selection(arg_14_0._selected_hero_row)
	else
		local var_14_7 = not arg_14_0._current_selected_row

		if var_14_0 and var_14_1 and var_14_7 then
			local var_14_8 = false

			if var_14_1 > 1 and arg_14_1:get("move_left_hold_continuous") then
				var_14_1 = var_14_1 - 1
				var_14_8 = true
			elseif var_14_1 < var_14_5 and arg_14_1:get("move_right_hold_continuous") then
				var_14_1 = var_14_1 + 1
				var_14_8 = true
			end

			if var_14_0 > 1 and arg_14_1:get("move_up_hold_continuous") then
				var_14_0 = var_14_0 - 1
				var_14_5 = arg_14_0._num_hero_columns[var_14_0]
				var_14_8 = true
			elseif var_14_0 < var_14_2 and arg_14_1:get("move_down_hold_continuous") then
				var_14_0 = var_14_0 + 1
				var_14_5 = arg_14_0._num_hero_columns[var_14_0]
				var_14_8 = true
			end

			if var_14_5 < var_14_1 then
				var_14_1 = var_14_5
				var_14_8 = true
			end

			if var_14_8 then
				local var_14_9 = ProfilePriority[var_14_0]
				local var_14_10 = false
				local var_14_11 = PlayerData.bot_spawn_priority[var_14_0]
				local var_14_12 = arg_14_0._bot_selection
				local var_14_13 = var_14_1

				arg_14_0:_select_hero(var_14_11, var_14_13, nil, var_14_12)
			end
		end
	end
end

CharacterSelectionStateCharacter._is_selected_hero_unlocked = function (arg_15_0)
	local var_15_0 = arg_15_0._selected_hero_row
	local var_15_1 = arg_15_0._selected_hero_column
	local var_15_2 = arg_15_0._num_max_hero_rows
	local var_15_3 = 1

	for iter_15_0 = 1, var_15_2 do
		local var_15_4 = arg_15_0._num_hero_columns[iter_15_0]

		for iter_15_1 = 1, var_15_4 do
			if var_15_0 == iter_15_0 and var_15_1 == iter_15_1 then
				local var_15_5 = arg_15_0._hero_widgets[var_15_3].content

				return not var_15_5.locked_reason or not var_15_5.locked
			end

			var_15_3 = var_15_3 + 1
		end
	end

	return false
end

CharacterSelectionStateCharacter._handle_gamepad_bot_selection = function (arg_16_0, arg_16_1)
	arg_16_0:_handle_gamepad_selection(arg_16_1)

	if arg_16_1:get("confirm_press", true) and arg_16_0:_is_selected_hero_unlocked() then
		local var_16_0 = arg_16_0._selected_hero_row
		local var_16_1 = arg_16_0._selected_hero_column
		local var_16_2 = PlayerData.bot_spawn_priority[var_16_0]
		local var_16_3 = SPProfiles[var_16_2].display_name
		local var_16_4 = var_16_1

		Managers.backend:get_interface("hero_attributes"):set(var_16_3, "bot_career", var_16_4)
		arg_16_0:_play_sound("play_gui_equipment_equip")
		arg_16_0:_update_equipped_bots()
	elseif arg_16_1:get("refresh") then
		if arg_16_0._current_selected_row then
			arg_16_0:_reset_bot_selection(true)
			arg_16_0:_play_sound("hud_bot_order_release")
		else
			arg_16_0:_set_bot_selection(arg_16_0._selected_hero_row)
		end
	else
		local var_16_5 = arg_16_0._current_selected_row
		local var_16_6 = arg_16_0._num_max_hero_rows
		local var_16_7 = false

		if not var_16_5 then
			return
		end

		if var_16_5 > 1 and arg_16_1:get("move_up_hold_continuous") then
			var_16_5 = var_16_5 - 1
			var_16_7 = true
		elseif var_16_5 < var_16_6 and arg_16_1:get("move_down_hold_continuous") then
			var_16_5 = var_16_5 + 1
			var_16_7 = true
		end

		if var_16_7 then
			arg_16_0:_play_sound("play_gui_equipment_inventory_hover")
			arg_16_0:_update_bot_order(var_16_5)
		end
	end
end

CharacterSelectionStateCharacter._update_bot_order = function (arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = arg_17_0._current_selected_row

	table.remove(arg_17_0._bot_priority_copy, var_17_0)
	table.insert(arg_17_0._bot_priority_copy, arg_17_1, arg_17_0._current_selected_bot_index)

	arg_17_0._current_selected_row = arg_17_1

	local var_17_1 = arg_17_0._hero_widgets
	local var_17_2 = arg_17_0._hero_icon_widgets
	local var_17_3 = 1

	for iter_17_0 = 1, #PlayerData.bot_spawn_priority do
		local var_17_4 = PlayerData.bot_spawn_priority[iter_17_0]
		local var_17_5 = #SPProfiles[var_17_4].careers
		local var_17_6 = table.find(arg_17_0._bot_priority_copy, var_17_4)
		local var_17_7 = -((var_17_6 - 1) * 144)
		local var_17_8

		var_17_8 = iter_17_0 == var_17_0

		for iter_17_1 = 1, var_17_5 do
			local var_17_9 = var_17_1[var_17_3]
			local var_17_10 = var_17_9.content

			arg_17_0._ui_animations[var_17_4 .. ":" .. iter_17_1] = UIAnimation.init(UIAnimation.function_by_time, var_17_9.offset, 2, var_17_9.offset[2], var_17_7, 0.25, math.easeOutCubic)

			if var_17_10.bot_order_selection and arg_17_2 then
				arg_17_0._ui_animations[var_17_4 .. ":" .. iter_17_1 .. "_x"] = UIAnimation.init(UIAnimation.function_by_time, var_17_9.offset, 1, var_17_9.offset[1], var_17_9.offset[1] - arg_17_0._x_offset, 0.25, math.easeOutCubic)
			end

			var_17_3 = var_17_3 + 1
		end

		local var_17_11 = (iter_17_0 - var_17_6) * 144 + 7
		local var_17_12 = var_17_2[iter_17_0]
		local var_17_13 = var_17_12.style

		arg_17_0._ui_animations["hero_icon_" .. var_17_4 .. "_bg"] = UIAnimation.init(UIAnimation.function_by_time, var_17_13.bg.offset, 2, var_17_13.bg.offset[2], var_17_13.bg.offset[2] * 0 + var_17_11, 0.25, math.easeOutCubic)
		arg_17_0._ui_animations["hero_icon_" .. var_17_4 .. "_hourglass_icon"] = UIAnimation.init(UIAnimation.function_by_time, var_17_13.hourglass_icon.offset, 2, var_17_13.hourglass_icon.offset[2], var_17_13.hourglass_icon.offset[2] * 0 + var_17_11, 0.25, math.easeOutCubic)

		if var_17_12.content.bot_order_selection and arg_17_2 then
			arg_17_0._ui_animations["hero_icon_" .. var_17_4 .. "_bg_x"] = UIAnimation.init(UIAnimation.function_by_time, var_17_13.bg.offset, 1, var_17_13.bg.offset[1], var_17_13.bg.offset[1] - arg_17_0._x_offset, 0.25, math.easeOutCubic)
			arg_17_0._ui_animations["hero_icon_" .. var_17_4 .. "_hourglass_icon_x"] = UIAnimation.init(UIAnimation.function_by_time, var_17_13.hourglass_icon.offset, 1, var_17_13.hourglass_icon.offset[1], var_17_13.hourglass_icon.offset[1] - arg_17_0._x_offset, 0.25, math.easeOutCubic)
		end
	end
end

CharacterSelectionStateCharacter._set_bot_selection = function (arg_18_0, arg_18_1)
	arg_18_0._current_selected_bot_index = PlayerData.bot_spawn_priority[arg_18_1]
	arg_18_0._current_selected_row = arg_18_1
	arg_18_0._x_offset = 50
	arg_18_0._base_y_offset = nil
	arg_18_0._base_icon_y_offset = nil

	local var_18_0 = arg_18_0:input_service():get("cursor")

	if IS_XB1 then
		arg_18_0._base_cursor_y_offset = var_18_0 and 1080 - var_18_0[2]
	else
		arg_18_0._base_cursor_y_offset = var_18_0 and var_18_0[2] * RESOLUTION_LOOKUP.inv_scale
	end

	local var_18_1 = 1

	for iter_18_0 = 1, #PlayerData.bot_spawn_priority do
		local var_18_2 = PlayerData.bot_spawn_priority[iter_18_0]
		local var_18_3 = #SPProfiles[var_18_2].careers

		for iter_18_1 = 1, var_18_3 do
			if iter_18_0 == arg_18_0._current_selected_row then
				arg_18_0._hero_widgets[var_18_1].offset[1] = arg_18_0._hero_widgets[var_18_1].offset[1] + arg_18_0._x_offset
				arg_18_0._hero_widgets[var_18_1].offset[3] = 100
				arg_18_0._hero_widgets[var_18_1].content.bot_order_selection = true
				arg_18_0._base_y_offset = arg_18_0._hero_widgets[var_18_1].offset[2]
			end

			var_18_1 = var_18_1 + 1
		end
	end

	for iter_18_2, iter_18_3 in ipairs(arg_18_0._hero_icon_widgets) do
		iter_18_3.content.bot_change_order_active = true

		if iter_18_2 == arg_18_0._current_selected_row then
			iter_18_3.style.bg.offset[1] = iter_18_3.style.bg.offset[1] + arg_18_0._x_offset
			iter_18_3.style.hourglass_icon.offset[1] = iter_18_3.style.hourglass_icon.offset[1] + arg_18_0._x_offset
			iter_18_3.content.bot_order_selection = true
			arg_18_0._base_icon_y_offset = iter_18_3.style.hourglass_icon.offset[2]
		end
	end

	arg_18_0:_play_sound("hud_bot_order_grab")
end

CharacterSelectionStateCharacter._reset_bot_selection = function (arg_19_0, arg_19_1)
	arg_19_0._current_selected_bot_index = nil
	arg_19_0._current_selected_row = nil
	arg_19_0._x_offset = nil
	arg_19_0._base_y_offset = nil
	arg_19_0._base_icon_y_offset = nil
	arg_19_0._base_cursor_y_offset = nil
	PlayerData.bot_spawn_priority = arg_19_0._bot_priority_copy
	arg_19_0._bot_priority_copy = table.clone(PlayerData.bot_spawn_priority)

	arg_19_0.parent:set_input_blocked(false)
	arg_19_0:_setup_hero_selection_widgets()

	if arg_19_1 then
		local var_19_0 = true
		local var_19_1 = true

		arg_19_0:_select_hero(arg_19_0._selected_profile_index, arg_19_0._selected_career_index, var_19_1, var_19_0)
	end

	local var_19_2 = arg_19_0._hero_widgets
	local var_19_3 = 1

	for iter_19_0 = 1, #PlayerData.bot_spawn_priority do
		local var_19_4 = PlayerData.bot_spawn_priority[iter_19_0]
		local var_19_5 = #SPProfiles[var_19_4].careers

		for iter_19_1 = 1, var_19_5 do
			local var_19_6 = var_19_2[var_19_3]

			var_19_6.content.bot_selection = true
			var_19_6.content.bot_order_selection = false
			var_19_3 = var_19_3 + 1
		end
	end

	for iter_19_2, iter_19_3 in pairs(arg_19_0._hero_icon_widgets) do
		iter_19_3.content.bot_selection_active = true
		iter_19_3.content.bot_order_selection = false
	end
end

CharacterSelectionStateCharacter._handle_mouse_bot_selection = function (arg_20_0, arg_20_1)
	if Managers.input:is_device_active("gamepad") then
		return
	end

	if not arg_20_0.parent:input_blocked() then
		if arg_20_0._current_selected_row then
			if not arg_20_0._base_cursor_y_offset then
				local var_20_0 = true

				arg_20_0:_update_bot_order(arg_20_0._current_selected_row, var_20_0)
				arg_20_0.parent:set_input_blocked(true)

				return
			end

			local var_20_1 = arg_20_1:get("cursor")
			local var_20_2

			if IS_XB1 then
				var_20_2 = 1080 - var_20_1[2]
			else
				var_20_2 = var_20_1[2] * RESOLUTION_LOOKUP.inv_scale
			end

			local var_20_3 = var_20_2 - arg_20_0._base_cursor_y_offset
			local var_20_4 = -((#PlayerData.bot_spawn_priority - 1) * 144)
			local var_20_5 = math.clamp(arg_20_0._base_y_offset + var_20_3, var_20_4, 0)
			local var_20_6 = arg_20_0._base_y_offset + var_20_3 - var_20_5
			local var_20_7 = arg_20_0._hero_widgets
			local var_20_8 = 1

			for iter_20_0 = 1, #arg_20_0._bot_priority_copy do
				local var_20_9 = arg_20_0._bot_priority_copy[iter_20_0]
				local var_20_10 = #SPProfiles[var_20_9].careers

				for iter_20_1 = 1, var_20_10 do
					if var_20_7[var_20_8].content.bot_order_selection then
						var_20_7[var_20_8].offset[2] = var_20_5
					end

					var_20_8 = var_20_8 + 1
				end
			end

			for iter_20_2, iter_20_3 in ipairs(arg_20_0._hero_icon_widgets) do
				if iter_20_3.content.bot_order_selection then
					local var_20_11 = iter_20_3.style

					var_20_11.bg.offset[2] = arg_20_0._base_icon_y_offset + (var_20_3 - var_20_6)
					var_20_11.hourglass_icon.offset[2] = arg_20_0._base_icon_y_offset + (var_20_3 - var_20_6)
				end
			end
		end

		local var_20_12 = true

		for iter_20_4, iter_20_5 in ipairs(arg_20_0._hero_icon_widgets) do
			if UIUtils.is_button_hover_enter(iter_20_5, "bot_change_order_hotspot") then
				if arg_20_0._current_selected_row then
					arg_20_0:_update_bot_order(iter_20_4, false)
				end
			elseif UIUtils.is_button_held(iter_20_5, "bot_change_order_hotspot") then
				if not arg_20_0._current_selected_row then
					arg_20_0:_set_bot_selection(iter_20_4)
				end
			elseif UIUtils.is_left_button_released(iter_20_5, "bot_change_order_hotspot") and arg_20_0._current_selected_row then
				arg_20_0:_update_bot_order(iter_20_4, var_20_12)
				arg_20_0.parent:set_input_blocked(true)
				arg_20_0:_play_sound("hud_bot_order_release")

				break
			end
		end

		local var_20_13 = Managers.backend:get_interface("hero_attributes")
		local var_20_14 = PlayerData.bot_spawn_priority
		local var_20_15 = arg_20_0._hero_widgets
		local var_20_16 = 1

		for iter_20_6 = 1, arg_20_0._num_max_hero_rows do
			local var_20_17 = arg_20_0._num_hero_columns[iter_20_6]

			for iter_20_7 = 1, var_20_17 do
				local var_20_18 = var_20_15[var_20_16].content
				local var_20_19 = var_20_18.button_hotspot

				if not var_20_18.locked and var_20_19.on_right_click then
					local var_20_20 = var_20_14[iter_20_6]
					local var_20_21 = iter_20_7
					local var_20_22 = SPProfiles[var_20_20].display_name

					var_20_13:set(var_20_22, "bot_career", var_20_21)
					arg_20_0:_play_sound("play_gui_equipment_equip")
					arg_20_0:_update_equipped_bots()

					return
				end

				var_20_16 = var_20_16 + 1
			end
		end
	elseif table.size(arg_20_0._ui_animations) == 0 then
		arg_20_0:_reset_bot_selection()
	end
end

CharacterSelectionStateCharacter._select_hero = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	if not arg_21_3 then
		arg_21_0:_play_sound("play_gui_hero_select_career_click")
	end

	local var_21_0 = SPProfiles[arg_21_1]
	local var_21_1 = var_21_0.careers[arg_21_2]
	local var_21_2 = var_21_0.display_name
	local var_21_3 = var_21_0.character_name
	local var_21_4 = var_21_1.display_name

	GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_21_4 == "bw_necromancer")

	local var_21_5 = Localize(var_21_3)
	local var_21_6 = Localize(var_21_4)
	local var_21_7 = Managers.backend:get_interface("hero_attributes"):get(var_21_2, "experience") or 0
	local var_21_8 = ExperienceSettings.get_level(var_21_7)

	arg_21_0:_set_hero_info(var_21_5, var_21_6, var_21_8)
	arg_21_0:_populate_career_info(arg_21_1, arg_21_2)

	local var_21_9 = arg_21_0._hero_widgets
	local var_21_10 = arg_21_0._num_max_hero_rows

	arg_21_0._spawn_hero = true

	if arg_21_4 then
		arg_21_0._spawn_hero = false
	end

	arg_21_0._selected_career_index = arg_21_2
	arg_21_0._selected_profile_index = arg_21_1
	arg_21_0._selected_hero_name = var_21_2
	arg_21_0._selected_hero_row = table.find(PlayerData.bot_spawn_priority, arg_21_1)
	arg_21_0._selected_hero_column = arg_21_2

	arg_21_0:_set_hero_icon_selected(arg_21_0._selected_hero_row)

	local var_21_11 = 1

	for iter_21_0 = 1, var_21_10 do
		local var_21_12 = arg_21_0._num_hero_columns[iter_21_0]

		for iter_21_1 = 1, var_21_12 do
			local var_21_13 = iter_21_0 == arg_21_0._selected_hero_row and iter_21_1 == arg_21_0._selected_hero_column
			local var_21_14 = var_21_9[var_21_11].content

			var_21_14.button_hotspot.is_selected = var_21_13

			if var_21_13 then
				local var_21_15 = arg_21_0._widgets_by_name.locked_info_text.content
				local var_21_16

				if var_21_14.locked_reason or var_21_14.locked then
					var_21_16 = var_21_14.locked_reason
				end

				var_21_15.locked = var_21_14.locked_reason or var_21_14.locked
				var_21_15.text = var_21_16
				var_21_15.visible = var_21_16 ~= nil
			end

			var_21_11 = var_21_11 + 1
		end
	end
end

CharacterSelectionStateCharacter._get_skin_item_data = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = SPProfiles[arg_22_1].careers[arg_22_2].base_skin

	return Cosmetics[var_22_0]
end

CharacterSelectionStateCharacter._wanted_state = function (arg_23_0)
	return (arg_23_0.parent:wanted_state())
end

CharacterSelectionStateCharacter.on_exit = function (arg_24_0, arg_24_1)
	if arg_24_0.menu_input_description then
		arg_24_0.menu_input_description:destroy()

		arg_24_0.menu_input_description = nil
	end

	arg_24_0:_destroy_video_player()
	arg_24_0:_respawn_player()

	arg_24_0.ui_animator = nil

	arg_24_0.parent:set_input_blocked(false)

	local var_24_0 = Managers.player:local_player()

	if var_24_0 then
		local var_24_1 = var_24_0.player_unit
		local var_24_2 = ALIVE[var_24_1] and ScriptUnit.has_extension(var_24_1, "career_system")
		local var_24_3 = arg_24_0._requested_profile_index or var_24_2 and var_24_2:profile_index()
		local var_24_4 = arg_24_0._requested_career_index or var_24_2 and var_24_2:career_index()
		local var_24_5 = var_24_3 and SPProfiles[var_24_3]
		local var_24_6 = var_24_5 and var_24_5.display_name

		if not DEDICATED_SERVER and var_24_6 == "bright_wizard" then
			local var_24_7 = var_24_5.careers[var_24_4].display_name

			GlobalShaderFlags.set_global_shader_flag("NECROMANCER_CAREER_REMAP", var_24_7 == "bw_necromancer")
		end
	end

	print("[HeroViewState] Exit Substate CharacterSelectionStateCharacter")
end

CharacterSelectionStateCharacter._respawn_player = function (arg_25_0)
	if arg_25_0._respawn_player_unit then
		if arg_25_0.is_server then
			Managers.state.network.network_server:peer_respawn_player(arg_25_0.peer_id)
		else
			Managers.state.network.network_transmit:send_rpc_server("rpc_client_respawn_player")
		end

		arg_25_0._respawn_player_unit = nil
	end
end

CharacterSelectionStateCharacter._update_transition_timer = function (arg_26_0, arg_26_1)
	if not arg_26_0._transition_timer then
		return
	end

	if arg_26_0._transition_timer == 0 then
		arg_26_0._transition_timer = nil
	else
		arg_26_0._transition_timer = math.max(arg_26_0._transition_timer - arg_26_1, 0)
	end
end

CharacterSelectionStateCharacter.update = function (arg_27_0, arg_27_1, arg_27_2)
	if var_0_11 then
		var_0_11 = false

		arg_27_0:create_ui_elements()
	end

	for iter_27_0, iter_27_1 in pairs(arg_27_0._ui_animations) do
		UIAnimation.update(iter_27_1, arg_27_1)

		if UIAnimation.completed(iter_27_1) then
			arg_27_0._ui_animations[iter_27_0] = nil
		end
	end

	arg_27_0:_update_available_profiles()
	arg_27_0:_update_profile_request()
	arg_27_0:_update_video_player_settings()

	if not arg_27_0._prepare_exit then
		arg_27_0:_handle_input(arg_27_1, arg_27_2)
	end

	arg_27_0:draw(arg_27_1, arg_27_2)

	return arg_27_0:_handle_transitions()
end

CharacterSelectionStateCharacter._handle_transitions = function (arg_28_0)
	local var_28_0 = arg_28_0:_wanted_state()

	if not arg_28_0._transition_timer and not arg_28_0:pending_profile_request() and (var_28_0 or arg_28_0._new_state) then
		if arg_28_0.world_previewer:has_units_spawned() then
			arg_28_0._prepare_exit = true
		elseif not arg_28_0._prepare_exit then
			return var_28_0 or arg_28_0._new_state
		end
	end
end

CharacterSelectionStateCharacter.post_update = function (arg_29_0, arg_29_1, arg_29_2)
	arg_29_0.ui_animator:update(arg_29_1)
	arg_29_0:_update_animations(arg_29_1)

	if not arg_29_0.parent:transitioning() and not arg_29_0._transition_timer then
		if arg_29_0._prepare_exit then
			arg_29_0._prepare_exit = false

			arg_29_0.world_previewer:prepare_exit()
		elseif arg_29_0._spawn_hero then
			arg_29_0._spawn_hero = nil

			local var_29_0 = arg_29_0._selected_hero_name or arg_29_0._hero_name

			arg_29_0:_spawn_hero_unit(var_29_0)
		end
	end

	local var_29_1 = Managers.state.network.profile_synchronizer
	local var_29_2 = arg_29_0.local_player:network_id()
	local var_29_3 = arg_29_0.local_player:local_player_id()

	if arg_29_0._despawning_player_unit_career_change and not Unit.alive(arg_29_0._despawning_player_unit_career_change) and var_29_1:all_ingame_synced_for_peer(var_29_2, var_29_3) then
		local var_29_4 = arg_29_0._respawn_position:unbox()
		local var_29_5 = arg_29_0._respawn_rotation:unbox()

		arg_29_0.local_player:spawn(var_29_4, var_29_5)

		arg_29_0._despawning_player_unit_career_change = nil
		arg_29_0._resyncing_loadout = nil

		arg_29_0.parent:close_menu()
	end
end

CharacterSelectionStateCharacter.draw = function (arg_30_0, arg_30_1, arg_30_2)
	local var_30_0 = arg_30_0.ui_top_renderer
	local var_30_1 = arg_30_0._ui_scenegraph
	local var_30_2 = arg_30_0.input_manager
	local var_30_3 = arg_30_0.parent
	local var_30_4 = arg_30_0:input_service()
	local var_30_5 = arg_30_0.render_settings
	local var_30_6 = Managers.input:is_device_active("gamepad")

	arg_30_0._widgets_by_name.bottom_panel.content.visible = var_30_6

	UIRenderer.begin_pass(var_30_0, var_30_1, var_30_4, arg_30_1, nil, var_30_5)

	var_30_5.alpha_multiplier = var_30_5.main_alpha_multiplier

	for iter_30_0, iter_30_1 in ipairs(arg_30_0._widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_1)
	end

	for iter_30_2, iter_30_3 in ipairs(arg_30_0._hero_widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_3)
	end

	for iter_30_4, iter_30_5 in ipairs(arg_30_0._hero_icon_widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_5)
	end

	for iter_30_6, iter_30_7 in ipairs(arg_30_0._additional_widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_7)
	end

	if not arg_30_0._draw_video_next_frame then
		if arg_30_0._video_widget and not arg_30_0._prepare_exit then
			if not arg_30_0._video_created then
				UIRenderer.draw_widget(var_30_0, arg_30_0._video_widget)
			else
				arg_30_0._video_created = nil
			end
		end
	elseif arg_30_0._draw_video_next_frame then
		arg_30_0._draw_video_next_frame = nil
	end

	var_30_5.alpha_multiplier = var_30_5.info_alpha_multiplier

	for iter_30_8, iter_30_9 in ipairs(arg_30_0._info_widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_9)
	end

	var_30_5.alpha_multiplier = var_30_5.bot_selection_alpha_multiplier

	for iter_30_10, iter_30_11 in ipairs(arg_30_0._bot_selection_widgets) do
		UIRenderer.draw_widget(var_30_0, iter_30_11)
	end

	UIRenderer.end_pass(var_30_0)

	if var_30_6 then
		arg_30_0.menu_input_description:draw(var_30_0, arg_30_1)
	end

	if arg_30_0._scrollbar then
		var_30_5.alpha_multiplier = var_30_5.main_alpha_multiplier

		arg_30_0._scrollbar:update(arg_30_1, arg_30_2, var_30_0, var_30_4, var_30_5)
	end
end

CharacterSelectionStateCharacter._update_animations = function (arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(var_31_0, arg_31_1)

	local var_31_1 = arg_31_0._widgets_by_name.bot_priority_button
	local var_31_2 = arg_31_0._widgets_by_name.back_button

	UIWidgetUtils.animate_default_button(var_31_1, arg_31_1)
	UIWidgetUtils.animate_default_button(var_31_2, arg_31_1)

	if arg_31_0.pick_time then
		arg_31_0.pick_time = math.clamp(arg_31_0.pick_time - arg_31_1, 0, 100)
		var_31_0.content.title_text = string.format(Localize("confirm_menu_button_name") .. " %.1f", arg_31_0.pick_time)
		var_31_0.element.dirty = true
	end

	if arg_31_0:_is_button_hover_enter(var_31_0) then
		arg_31_0:_play_sound("play_gui_start_menu_button_hover")
	end

	if arg_31_0:_is_button_hover_enter(var_31_1) then
		arg_31_0:_play_sound("play_gui_start_menu_button_hover")
	end

	local var_31_3 = arg_31_0._animations
	local var_31_4 = arg_31_0.ui_animator

	for iter_31_0, iter_31_1 in pairs(var_31_3) do
		if var_31_4:is_animation_completed(iter_31_1) then
			var_31_4:stop_animation(iter_31_1)

			var_31_3[iter_31_0] = nil
		end
	end
end

CharacterSelectionStateCharacter._spawn_hero_unit = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0.world_previewer
	local var_32_1 = arg_32_0._selected_career_index
	local var_32_2 = callback(arg_32_0, "cb_hero_unit_spawned", arg_32_1)

	var_32_0:request_spawn_hero_unit(arg_32_1, var_32_1, not arg_32_0.use_user_skins, var_32_2, nil, 0.5)
end

CharacterSelectionStateCharacter.cb_hero_unit_spawned = function (arg_33_0, arg_33_1)
	local var_33_0 = arg_33_0.world_previewer
	local var_33_1 = arg_33_0._selected_career_index
	local var_33_2 = FindProfileIndex(arg_33_1)
	local var_33_3 = SPProfiles[var_33_2].careers[var_33_1]
	local var_33_4 = var_33_3.preview_animation
	local var_33_5 = var_33_3.preview_wield_slot
	local var_33_6 = table.clone(var_33_3.preview_items)
	local var_33_7 = var_33_3.name

	if arg_33_0.use_loadout_items then
		table.clear(var_33_6)

		var_33_5 = var_33_5 or "melee"

		local var_33_8 = InventorySettings.slot_names_by_type[var_33_5][1]
		local var_33_9 = BackendUtils.get_loadout_item(var_33_7, var_33_8).key
		local var_33_10 = BackendUtils.get_loadout_item(var_33_7, "slot_hat").key

		var_33_6[#var_33_6 + 1] = {
			item_name = var_33_9
		}
		var_33_6[#var_33_6 + 1] = {
			item_name = var_33_10
		}
	end

	if var_33_6 then
		for iter_33_0, iter_33_1 in ipairs(var_33_6) do
			local var_33_11 = iter_33_1.item_name
			local var_33_12 = ItemMasterList[var_33_11].slot_type
			local var_33_13 = InventorySettings.slot_names_by_type[var_33_12][1]
			local var_33_14 = InventorySettings.slots_by_name[var_33_13]

			var_33_0:equip_item(var_33_11, var_33_14)
		end

		if var_33_5 then
			var_33_0:wield_weapon_slot(var_33_5)
		end
	end

	local var_33_15 = var_33_3.preview_props

	if var_33_15 then
		var_33_0:spawn_all_props(var_33_15)
	end

	if arg_33_0.use_user_skins then
		local var_33_16 = BackendUtils.get_loadout_item(var_33_7, "slot_hat")

		if var_33_16 then
			local var_33_17 = var_33_16.data.name
			local var_33_18 = var_33_16.backend_id
			local var_33_19 = InventorySettings.slots_by_name.slot_hat

			var_33_0:equip_item(var_33_17, var_33_19, var_33_18)
		elseif var_33_3.required_dlc and Managers.unlock:is_dlc_unlocked(var_33_3.required_dlc) then
			Crashify.print_exception("[Cosmetic] Failed to equip item in slot \"slot_hat\" for career %q in character selection state character", var_33_7)
		end

		local var_33_20 = BackendUtils.get_loadout_item(var_33_7, "slot_skin")
		local var_33_21 = var_33_20 and var_33_20.data

		var_33_4 = var_33_21 and var_33_21.career_select_preview_animation or var_33_4
	end

	if var_33_4 and not arg_33_0.use_loadout_items then
		arg_33_0.world_previewer:play_character_animation(var_33_4)
	end
end

CharacterSelectionStateCharacter._is_button_pressed = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_1.content.button_hotspot

	if var_34_0.on_release then
		var_34_0.on_release = false

		return true
	end
end

CharacterSelectionStateCharacter._is_button_hover_enter = function (arg_35_0, arg_35_1)
	return arg_35_1.content.button_hotspot.on_hover_enter
end

CharacterSelectionStateCharacter._is_button_hover_exit = function (arg_36_0, arg_36_1)
	return arg_36_1.content.button_hotspot.on_hover_exit
end

CharacterSelectionStateCharacter._populate_career_info = function (arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = arg_37_0._ui_scenegraph
	local var_37_1 = arg_37_0.ui_top_renderer
	local var_37_2 = arg_37_0._widgets_by_name
	local var_37_3 = SPProfiles[arg_37_1]
	local var_37_4 = var_37_3.display_name
	local var_37_5 = var_37_3.careers[arg_37_2]
	local var_37_6 = var_37_5.name
	local var_37_7 = CareerUtils.get_passive_ability_by_career(var_37_5)
	local var_37_8 = CareerUtils.get_ability_data(arg_37_1, arg_37_2, 1)
	local var_37_9 = var_37_7.display_name
	local var_37_10 = var_37_7.icon
	local var_37_11 = var_37_8.display_name
	local var_37_12 = var_37_8.icon

	var_37_2.passive_title_text.content.text = Localize(var_37_9)
	var_37_2.passive_description_text.content.text = UIUtils.get_ability_description(var_37_7)
	var_37_2.passive_icon.content.texture_id = var_37_10
	var_37_2.active_title_text.content.text = Localize(var_37_11)
	var_37_2.active_description_text.content.text = UIUtils.get_ability_description(var_37_8)
	var_37_2.active_icon.content.texture_id = var_37_12

	local var_37_13 = var_37_7.perks
	local var_37_14 = 0
	local var_37_15 = 0

	for iter_37_0 = 1, 3 do
		local var_37_16 = var_37_2["career_perk_" .. iter_37_0]
		local var_37_17 = var_37_16.content
		local var_37_18 = var_37_16.style
		local var_37_19 = var_37_0[var_37_16.scenegraph_id].size

		var_37_16.offset[2] = -var_37_14

		local var_37_20 = var_37_13[iter_37_0]

		if var_37_20 then
			local var_37_21 = Localize(var_37_20.display_name)
			local var_37_22 = UIUtils.get_perk_description(var_37_20)
			local var_37_23 = var_37_18.title_text
			local var_37_24 = var_37_18.description_text
			local var_37_25 = var_37_18.description_text_shadow

			var_37_17.title_text = var_37_21
			var_37_17.description_text = var_37_22

			local var_37_26 = UIUtils.get_text_height(var_37_1, var_37_19, var_37_23, var_37_21)
			local var_37_27 = UIUtils.get_text_height(var_37_1, var_37_19, var_37_24, var_37_22)

			var_37_24.offset[2] = -var_37_27
			var_37_25.offset[2] = -(var_37_27 + 2)
			var_37_14 = var_37_14 + var_37_26 + var_37_27 + var_37_15
		end

		var_37_17.visible = var_37_20 ~= nil
	end

	local var_37_28 = math.max(var_37_14 - var_0_12, 0)

	arg_37_0:_setup_additional_career_info(var_37_5, var_37_28)

	local var_37_29 = var_37_5.video
	local var_37_30 = var_37_29.material_name
	local var_37_31 = var_37_29.resource

	arg_37_0._current_video_settings = {
		video = var_37_29,
		material_name = var_37_30,
		resource = var_37_31
	}

	arg_37_0:_destroy_video_player()
end

CharacterSelectionStateCharacter._setup_additional_career_info = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = arg_38_2 or 0

	if arg_38_1.additional_ui_info_file then
		local var_38_1 = local_require(arg_38_1.additional_ui_info_file)
		local var_38_2 = "scrollbar_window"
		local var_38_3 = "scrollbar_anchor"
		local var_38_4 = arg_38_0._ui_scenegraph[var_38_2].size[2]
		local var_38_5 = {
			0,
			-var_38_4,
			0
		}
		local var_38_6
		local var_38_7

		arg_38_0._additional_widgets, arg_38_0._additional_widgets_by_name, var_38_7 = var_38_1.setup(var_38_2, var_38_5)

		local var_38_8
		local var_38_9 = true

		arg_38_0._scrollbar = ScrollbarUI:new(arg_38_0._ui_scenegraph, var_38_2, var_38_3, var_38_7 + var_38_0, var_38_9, var_38_8)
	else
		table.clear(arg_38_0._additional_widgets)
		table.clear(arg_38_0._additional_widgets_by_name)

		if var_38_0 > 0 then
			local var_38_10 = "scrollbar_window"
			local var_38_11 = "scrollbar_anchor"
			local var_38_12 = true
			local var_38_13

			arg_38_0._scrollbar = ScrollbarUI:new(arg_38_0._ui_scenegraph, var_38_10, var_38_11, var_38_0, var_38_12, var_38_13)
		elseif arg_38_0._scrollbar then
			arg_38_0._scrollbar:destroy(arg_38_0._ui_scenegraph)

			arg_38_0._scrollbar = nil
		end
	end
end

CharacterSelectionStateCharacter._handle_input = function (arg_39_0, arg_39_1, arg_39_2)
	local var_39_0 = arg_39_0:input_service()
	local var_39_1 = Managers.input:is_device_active("gamepad")

	if arg_39_0._bot_selection then
		arg_39_0:_handle_gamepad_bot_selection(var_39_0)
		arg_39_0:_handle_mouse_bot_selection(var_39_0)

		local var_39_2 = arg_39_0._widgets_by_name.back_button

		if var_39_1 and var_39_0:get("back_menu_alt", true) or var_39_0:get("toggle_menu", true) or var_39_0:get("back", true) or UIUtils.is_button_pressed(var_39_2) then
			arg_39_0:_exit_bot_selection()
		end
	else
		arg_39_0:_handle_gamepad_selection(var_39_0)
		arg_39_0:_handle_mouse_selection()

		local var_39_3, var_39_4 = arg_39_0.profile_synchronizer:profile_by_peer(arg_39_0.peer_id, arg_39_0.local_player_id)
		local var_39_5 = arg_39_0._widgets_by_name.select_button
		local var_39_6 = not var_39_5.content.button_hotspot.disable_button
		local var_39_7 = arg_39_0._widgets_by_name.bot_priority_button
		local var_39_8 = var_39_6 and var_39_0:get("confirm_press", true)
		local var_39_9 = arg_39_0.allow_back_button and var_39_0:get("back_menu_alt", true) or var_39_0:get("back", true)

		if arg_39_0:_is_button_pressed(var_39_5) or var_39_8 then
			arg_39_0:_play_sound("play_gui_start_menu_button_click")

			if var_39_5.content.dlc_name then
				Managers.state.event:trigger("ui_show_popup", var_39_5.content.dlc_name, "upsell")
			elseif var_39_3 ~= arg_39_0._selected_profile_index or var_39_4 ~= arg_39_0._selected_career_index then
				local var_39_10 = var_39_5.content.verify_dlc_name

				if var_39_10 and Managers.unlock:dlc_requires_restart(var_39_10) then
					arg_39_0.parent:close_menu()

					return
				end

				if not Network.game_session() then
					return
				end

				arg_39_0:_change_profile(arg_39_0._selected_profile_index, arg_39_0._selected_career_index)
				arg_39_0.parent:set_input_blocked(true)
			else
				arg_39_0.parent:close_menu()
			end
		elseif var_39_9 then
			arg_39_0.parent:close_menu()
		elseif arg_39_0:_is_button_pressed(var_39_7) then
			arg_39_0:_enter_bot_selection()
		end
	end
end

CharacterSelectionStateCharacter._set_hero_info = function (arg_40_0, arg_40_1, arg_40_2, arg_40_3)
	local var_40_0 = arg_40_0._widgets_by_name

	var_40_0.info_hero_name.content.text = arg_40_1
	var_40_0.info_career_name.content.text = arg_40_2
	var_40_0.info_hero_level.content.text = tostring(arg_40_3)
end

CharacterSelectionStateCharacter._set_select_button_enabled = function (arg_41_0, arg_41_1, arg_41_2, arg_41_3)
	if arg_41_0._bot_selection then
		local var_41_0 = arg_41_0._widgets_by_name.select_button.content

		if arg_41_1 then
			arg_41_0.menu_input_description:set_input_description(var_0_8.bot_selection_available)
		else
			arg_41_0.menu_input_description:set_input_description(nil)
		end
	else
		local var_41_1 = arg_41_0._widgets_by_name.select_button.content

		if arg_41_1 then
			var_41_1.title_text = Localize("input_description_confirm")
			var_41_1.button_hotspot.disable_button = false
			var_41_1.verify_dlc_name = arg_41_3
			var_41_1.dlc_name = nil

			arg_41_0.menu_input_description:set_input_description(var_0_8.available)
		elseif arg_41_2 then
			var_41_1.title_text = Localize("menu_store_purchase_button_unlock")
			var_41_1.button_hotspot.disable_button = false
			var_41_1.dlc_name = arg_41_2
			var_41_1.verify_dlc_name = nil

			arg_41_0.menu_input_description:set_input_description(var_0_8.purchase)
		else
			var_41_1.title_text = Localize("dlc1_2_difficulty_unavailable")
			var_41_1.button_hotspot.disable_button = true
			var_41_1.dlc_name = nil
			var_41_1.verify_dlc_name = nil

			arg_41_0.menu_input_description:set_input_description(nil)
		end
	end
end

CharacterSelectionStateCharacter._play_sound = function (arg_42_0, arg_42_1)
	arg_42_0.parent:play_sound(arg_42_1)
end

CharacterSelectionStateCharacter.get_camera_position = function (arg_43_0)
	local var_43_0, var_43_1 = arg_43_0.parent:get_background_world()
	local var_43_2 = ScriptViewport.camera(var_43_1)

	return ScriptCamera.position(var_43_2)
end

CharacterSelectionStateCharacter.get_camera_rotation = function (arg_44_0)
	local var_44_0, var_44_1 = arg_44_0.parent:get_background_world()
	local var_44_2 = ScriptViewport.camera(var_44_1)

	return ScriptCamera.rotation(var_44_2)
end

CharacterSelectionStateCharacter.trigger_unit_flow_event = function (arg_45_0, arg_45_1, arg_45_2)
	if arg_45_1 and Unit.alive(arg_45_1) then
		Unit.flow_event(arg_45_1, arg_45_2)
	end
end

CharacterSelectionStateCharacter._start_transition_animation = function (arg_46_0, arg_46_1, arg_46_2)
	local var_46_0 = {
		wwise_world = arg_46_0.wwise_world,
		render_settings = arg_46_0.render_settings
	}
	local var_46_1 = arg_46_0._widgets_by_name
	local var_46_2 = arg_46_0.ui_animator:start_animation(arg_46_2, var_46_1, var_0_10, var_46_0)

	arg_46_0._animations[arg_46_1] = var_46_2
end

CharacterSelectionStateCharacter._change_profile = function (arg_47_0, arg_47_1, arg_47_2)
	local var_47_0 = arg_47_0.peer_id
	local var_47_1 = 1
	local var_47_2 = SPProfiles[arg_47_1]
	local var_47_3 = var_47_2.display_name
	local var_47_4 = var_47_2.careers[arg_47_2].display_name
	local var_47_5 = true

	arg_47_0._profile_requester:request_profile(var_47_0, var_47_1, var_47_3, var_47_4, var_47_5)

	arg_47_0._pending_profile_request = true
	arg_47_0._requested_profile_index = arg_47_1
	arg_47_0._requested_career_index = arg_47_2
end

CharacterSelectionStateCharacter._change_career = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_0.local_player
	local var_48_1 = var_48_0.player_unit

	if var_48_0.player_unit then
		arg_48_0._despawning_player_unit_career_change = var_48_1

		Managers.state.spawn:delayed_despawn(var_48_0)

		arg_48_0._respawn_position = Vector3Box(POSITION_LOOKUP[var_48_1])
		arg_48_0._respawn_rotation = QuaternionBox(Unit.local_rotation(var_48_1, 0))
	end

	local var_48_2 = SPProfiles[arg_48_1].display_name

	arg_48_0:_save_selected_profile(arg_48_1)

	local var_48_3 = var_48_0:network_id()
	local var_48_4 = var_48_0:local_player_id()
	local var_48_5 = var_48_0.bot_player
	local var_48_6 = false

	arg_48_0._profile_synchronizer:resync_loadout(var_48_3, var_48_4, var_48_5, var_48_6)
	CosmeticUtils.sync_local_player_cosmetics(var_48_0, arg_48_1, arg_48_2)

	arg_48_0._resyncing_loadout = true
end

CharacterSelectionStateCharacter.pending_profile_request = function (arg_49_0)
	return arg_49_0._pending_profile_request
end

CharacterSelectionStateCharacter._save_selected_profile = function (arg_50_0, arg_50_1)
	if not SaveData.first_hero_selection_made then
		SaveData.first_hero_selection_made = true
	end

	SaveData.wanted_profile_index = arg_50_1

	Managers.save:auto_save(SaveFileName, SaveData, nil)
end

CharacterSelectionStateCharacter._update_profile_request = function (arg_51_0)
	if arg_51_0._pending_profile_request then
		local var_51_0 = arg_51_0._profile_requester:result()

		if var_51_0 == "success" then
			arg_51_0._pending_profile_request = nil

			local var_51_1 = arg_51_0._requested_profile_index
			local var_51_2 = arg_51_0._requested_career_index

			arg_51_0:_save_selected_profile(var_51_1)
			arg_51_0.parent:set_current_hero(var_51_1)

			if arg_51_0._close_on_successful_profile_request then
				arg_51_0.parent:close_menu()
			end

			arg_51_0._close_on_successful_profile_request = true
		elseif var_51_0 == "failure" then
			arg_51_0._pending_profile_request = nil

			arg_51_0.parent:set_input_blocked(false)
		end
	end
end

CharacterSelectionStateCharacter._on_option_button_hover = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0._ui_animations
	local var_52_1 = "option_button_" .. arg_52_2
	local var_52_2 = arg_52_1.style[arg_52_2]
	local var_52_3 = var_52_2.color[2]
	local var_52_4 = 255
	local var_52_5 = UISettings.scoreboard.topic_hover_duration
	local var_52_6 = (1 - var_52_3 / var_52_4) * var_52_5

	for iter_52_0 = 2, 4 do
		if var_52_6 > 0 then
			var_52_0[var_52_1 .. "_hover_" .. iter_52_0] = arg_52_0:_animate_element_by_time(var_52_2.color, iter_52_0, var_52_3, var_52_4, var_52_6)
		else
			var_52_2.color[iter_52_0] = var_52_4
		end
	end
end

CharacterSelectionStateCharacter._on_option_button_dehover = function (arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_0._ui_animations
	local var_53_1 = "option_button_" .. arg_53_2
	local var_53_2 = arg_53_1.style[arg_53_2]
	local var_53_3 = var_53_2.color[1]
	local var_53_4 = 100
	local var_53_5 = UISettings.scoreboard.topic_hover_duration
	local var_53_6 = var_53_3 / 255 * var_53_5

	for iter_53_0 = 2, 4 do
		if var_53_6 > 0 then
			var_53_0[var_53_1 .. "_hover_" .. iter_53_0] = arg_53_0:_animate_element_by_time(var_53_2.color, iter_53_0, var_53_3, var_53_4, var_53_6)
		else
			var_53_2.color[1] = var_53_4
		end
	end
end

CharacterSelectionStateCharacter.play_sound = function (arg_54_0, arg_54_1)
	return
end

CharacterSelectionStateCharacter._animate_element_by_time = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5)
	return (UIAnimation.init(UIAnimation.function_by_time, arg_55_1, arg_55_2, arg_55_3, arg_55_4, arg_55_5, math.ease_out_quad))
end

CharacterSelectionStateCharacter._animate_element_by_catmullrom = function (arg_56_0, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8)
	return (UIAnimation.init(UIAnimation.catmullrom, arg_56_1, arg_56_2, arg_56_3, arg_56_4, arg_56_5, arg_56_6, arg_56_7, arg_56_8))
end

CharacterSelectionStateCharacter.input_service = function (arg_57_0)
	return (arg_57_0._pending_profile_request or arg_57_0._resyncing_loadout or arg_57_0.parent:input_blocked()) and FAKE_INPUT_SERVICE or arg_57_0.parent:input_service(true)
end
