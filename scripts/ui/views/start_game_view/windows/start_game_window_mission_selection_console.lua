-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mission_selection_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.act_widgets
local var_0_3 = var_0_0.node_widgets
local var_0_4 = var_0_0.end_act_widget
local var_0_5 = var_0_0.scenegraph_definition
local var_0_6 = var_0_0.animation_definitions

local function var_0_7(arg_1_0, arg_1_1)
	return arg_1_0.act_presentation_order < arg_1_1.act_presentation_order
end

local var_0_8 = "confirm_press"

StartGameWindowMissionSelectionConsole = class(StartGameWindowMissionSelectionConsole)
StartGameWindowMissionSelectionConsole.NAME = "StartGameWindowMissionSelectionConsole"

StartGameWindowMissionSelectionConsole.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMissionSelectionConsole")

	arg_2_0._parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0._ui_renderer = var_2_0.ui_renderer
	arg_2_0._ui_top_renderer = var_2_0.ui_top_renderer
	arg_2_0._statistics_db = var_2_0.statistics_db
	arg_2_0._render_settings = {
		snap_pixel_positions = true
	}
	arg_2_0._stats_id = Managers.player:local_player():stats_id()
	arg_2_0._animations = {}

	arg_2_0:_create_ui_elements(arg_2_1, arg_2_2)

	local var_2_1 = arg_2_0._parent:get_selected_area_name()

	arg_2_0:_set_presentation_info()
	arg_2_0:_setup_levels_by_area(var_2_1)
	arg_2_0:_setup_grid_navigation()
	arg_2_0:_start_transition_animation("on_enter")
end

StartGameWindowMissionSelectionConsole._start_transition_animation = function (arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0._render_settings
	}
	local var_3_1 = {}
	local var_3_2 = arg_3_0._ui_animator:start_animation(arg_3_1, var_3_1, var_0_5, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

StartGameWindowMissionSelectionConsole._create_ui_elements = function (arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = UISceneGraph.init_scenegraph(var_0_5)

	arg_4_0._ui_scenegraph = var_4_0
	arg_4_0._widgets, arg_4_0._widgets_by_name = UIUtils.create_widgets(var_0_1)
	arg_4_0._node_widgets, arg_4_0._node_widgets_by_name = UIUtils.create_widgets(var_0_3)
	arg_4_0._act_widgets, arg_4_0._act_widgets_by_name = UIUtils.create_widgets(var_0_2)
	arg_4_0._end_act_widget = UIWidget.init(var_0_4)
	arg_4_0._loot_object_widgets = {}

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)

	arg_4_0._ui_animator = UIAnimator:new(var_4_0, var_0_6)

	if arg_4_2 then
		local var_4_1 = var_4_0.window.local_position

		var_4_1[1] = var_4_1[1] + arg_4_2[1]
		var_4_1[2] = var_4_1[2] + arg_4_2[2]
		var_4_1[3] = var_4_1[3] + arg_4_2[3]
	end
end

StartGameWindowMissionSelectionConsole._setup_levels_by_area = function (arg_5_0, arg_5_1)
	local var_5_0 = AreaSettings[arg_5_1]
	local var_5_1 = var_5_0.acts

	arg_5_0._is_dlc = var_5_0.dlc_name ~= nil

	arg_5_0:_setup_level_acts(var_5_1)
	arg_5_0:_present_act_levels()
	arg_5_0:_update_level_option()
end

StartGameWindowMissionSelectionConsole._setup_level_acts = function (arg_6_0, arg_6_1)
	local var_6_0 = {}
	local var_6_1 = 0

	for iter_6_0, iter_6_1 in pairs(UnlockableLevels) do
		if not table.find(NoneActLevels, iter_6_1) then
			local var_6_2 = LevelSettings[iter_6_1]
			local var_6_3 = var_6_2.act

			if table.find(arg_6_1, var_6_3) then
				if not var_6_0[var_6_3] then
					var_6_0[var_6_3] = {}
				end

				local var_6_4 = var_6_0[var_6_3]

				var_6_4[#var_6_4 + 1] = var_6_2
				var_6_1 = var_6_1 + 1
			end
		end
	end

	for iter_6_2, iter_6_3 in pairs(var_6_0) do
		table.sort(iter_6_3, var_0_7)
	end

	arg_6_0._levels_by_act = var_6_0
end

StartGameWindowMissionSelectionConsole._verify_act = function (arg_7_0, arg_7_1)
	if not arg_7_1 then
		return false
	end

	for iter_7_0 = 1, #MapPresentationActs do
		if arg_7_1 == MapPresentationActs[iter_7_0] then
			return true
		end
	end

	return false
end

StartGameWindowMissionSelectionConsole._present_act_levels = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._node_widgets
	local var_8_1 = arg_8_0._statistics_db
	local var_8_2 = arg_8_0._stats_id
	local var_8_3 = {}
	local var_8_4 = {}
	local var_8_5 = 190
	local var_8_6 = 190
	local var_8_7 = 4
	local var_8_8 = arg_8_0._levels_by_act

	for iter_8_0, iter_8_1 in pairs(var_8_8) do
		if arg_8_0:_verify_act(iter_8_0) and (not arg_8_1 or arg_8_1 == iter_8_0) then
			local var_8_9 = ActSettings[iter_8_0]
			local var_8_10 = var_8_9.sorting
			local var_8_11 = (var_8_10 - 1) % var_8_7 + 1
			local var_8_12 = var_8_7 < var_8_10
			local var_8_13 = 0
			local var_8_14

			if not var_8_12 then
				var_8_13 = -var_8_6 + (var_8_7 - var_8_11) * var_8_6
				var_8_14 = arg_8_0._act_widgets[var_8_11]
			else
				var_8_14 = arg_8_0._end_act_widget
			end

			var_8_4[#var_8_4 + 1] = var_8_14
			var_8_14.offset[2] = var_8_13

			local var_8_15 = var_8_9.display_name

			var_8_14.content.background = var_8_9.banner_texture
			var_8_14.content.text = var_8_15 and Localize(var_8_15) or ""

			local var_8_16 = UIUtils.get_text_width(arg_8_0._ui_renderer, var_8_14.style.text, var_8_14.content.text)
			local var_8_17 = #iter_8_1
			local var_8_18 = var_8_16 - 50
			local var_8_19 = 0

			for iter_8_2 = 1, var_8_17 do
				local var_8_20 = iter_8_1[iter_8_2]

				if var_8_12 then
					var_8_18 = var_8_5 * 4
				end

				local var_8_21 = #var_8_3 + 1
				local var_8_22 = var_8_0[var_8_21]
				local var_8_23 = var_8_22.content
				local var_8_24 = var_8_20.level_id
				local var_8_25 = var_8_20.boss_level
				local var_8_26 = var_8_20.display_name

				var_8_23.text = Localize(var_8_26)

				local var_8_27 = LevelUnlockUtils.level_unlocked(var_8_1, var_8_2, var_8_24)
				local var_8_28 = LevelUnlockUtils.completed_level_difficulty_index(var_8_1, var_8_2, var_8_24)

				var_8_23.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(var_8_28)
				var_8_23.locked = not var_8_27
				var_8_23.act_key = iter_8_0
				var_8_23.level_key = var_8_24

				local var_8_29 = var_8_20.level_image

				if var_8_29 then
					var_8_23.icon = var_8_29
				else
					var_8_23.icon = "icons_placeholder"
				end

				var_8_23.level_data = var_8_20
				var_8_23.boss_level = var_8_25

				local var_8_30 = var_8_22.offset

				var_8_30[1] = var_8_18
				var_8_30[2] = var_8_13 + var_8_19
				var_8_3[var_8_21] = var_8_22
				var_8_18 = var_8_18 + var_8_5
			end
		end
	end

	arg_8_0._active_node_widgets = var_8_3
	arg_8_0._active_act_widgets = var_8_4
end

StartGameWindowMissionSelectionConsole._select_level = function (arg_9_0, arg_9_1)
	local var_9_0 = LevelUnlockUtils.get_required_completed_levels(arg_9_0._statistics_db, arg_9_0._stats_id, arg_9_1)
	local var_9_1 = arg_9_0._active_node_widgets

	if var_9_1 then
		for iter_9_0 = 1, #var_9_1 do
			local var_9_2 = var_9_1[iter_9_0]
			local var_9_3 = var_9_2.content
			local var_9_4 = var_9_3.level_data
			local var_9_5 = var_9_4.level_id == arg_9_1

			var_9_2.content.button_hotspot.is_selected = var_9_5
			var_9_3.unlock_guidance = var_9_0[var_9_4.level_id]
		end
	end

	arg_9_0._selected_level_id = arg_9_1

	arg_9_0:_set_presentation_info(arg_9_1)
end

StartGameWindowMissionSelectionConsole._set_presentation_info = function (arg_10_0, arg_10_1)
	local var_10_0 = ""
	local var_10_1 = ""
	local var_10_2 = "map_frame_00"
	local var_10_3 = false
	local var_10_4 = ""
	local var_10_5 = arg_10_0._widgets_by_name
	local var_10_6 = var_10_5.selected_level.content

	if arg_10_1 then
		local var_10_7 = arg_10_0._statistics_db
		local var_10_8 = arg_10_0._stats_id
		local var_10_9 = LevelSettings[arg_10_1]
		local var_10_10 = var_10_9.level_image
		local var_10_11 = var_10_9.boss_level
		local var_10_12 = var_10_9.display_name

		var_10_1 = var_10_9.description_text

		local var_10_13 = LevelUnlockUtils.completed_level_difficulty_index(var_10_7, var_10_8, arg_10_1)

		var_10_2 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_10_13)

		if not LevelUnlockUtils.level_unlocked(var_10_7, var_10_8, arg_10_1) then
			arg_10_0._parent:set_input_description("select_mission")
		else
			arg_10_0._parent:set_input_description("select_mission_confirm")
		end

		var_10_6.icon = var_10_10
		var_10_6.boss_level = var_10_11
		var_10_0 = Localize(var_10_12)
		var_10_1 = Localize(var_10_1)
		var_10_3 = true

		arg_10_0:_setup_mission_data(var_10_9)
	end

	var_10_6.frame = var_10_2
	var_10_6.locked = not var_10_3
	var_10_6.visible = var_10_3
	var_10_6.button_hotspot.disable_button = true
	var_10_5.helper_text.content.visible = not var_10_3
	var_10_5.level_title.content.text = var_10_0
	var_10_5.description_text.content.text = var_10_1
	var_10_5.locked_text.content.text = var_10_4
end

StartGameWindowMissionSelectionConsole._setup_mission_data = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.loot_objectives
	local var_11_1 = arg_11_0._widgets_by_name
	local var_11_2 = not not var_11_0

	var_11_1.hero_tabs.content.visible = var_11_2
	var_11_1.heros_completed_text.content.visible = var_11_2

	if not var_11_0 then
		return
	end

	local var_11_3 = arg_11_0._ui_renderer
	local var_11_4 = var_0_0.create_loot_widget
	local var_11_5 = arg_11_0._loot_object_widgets
	local var_11_6 = {}

	table.clear(var_11_5)

	local var_11_7 = 2
	local var_11_8 = 150
	local var_11_9 = 25
	local var_11_10 = 0
	local var_11_11 = 0
	local var_11_12 = 0
	local var_11_13 = 0
	local var_11_14 = var_0_0.mission_settings

	for iter_11_0, iter_11_1 in ipairs(var_11_14) do
		local var_11_15 = iter_11_1.key
		local var_11_16 = iter_11_1.total_amount_func and arg_11_0[iter_11_1.total_amount_func](arg_11_0, arg_11_1) or var_11_0[var_11_15]

		if var_11_16 then
			local var_11_17 = iter_11_1.stat_name
			local var_11_18 = iter_11_1.widget_name
			local var_11_19 = iter_11_1.texture
			local var_11_20 = Localize(iter_11_1.title_text)
			local var_11_21 = var_11_4(var_11_19, var_11_20)
			local var_11_22 = UIWidget.init(var_11_21)
			local var_11_23 = {
				name = var_11_15,
				total_amount = var_11_16 > 0 and var_11_16,
				stat_name = var_11_17,
				widget = var_11_22
			}
			local var_11_24 = UIAtlasHelper.get_atlas_settings_by_texture_name(var_11_19).size
			local var_11_25 = var_11_22.style.text
			local var_11_26 = math.floor(var_11_13 / var_11_7)

			if var_11_13 % var_11_7 > 0 then
				var_11_10 = var_11_10 + (var_11_24[1] + var_11_8 + var_11_9)
			else
				var_11_10 = 0
			end

			local var_11_27 = var_11_22.offset

			var_11_27[1] = var_11_10
			var_11_27[2] = -(var_11_26 - 1) * var_11_24[2]
			var_11_6[var_11_15] = var_11_23
			var_11_5[var_11_18] = var_11_22
			var_11_13 = var_11_13 + 1
		end
	end

	if var_11_13 > 0 then
		arg_11_0:_sync_missions(var_11_6, arg_11_1)
	end

	arg_11_0:_sync_completed_difficulty(var_11_13, var_11_8 + var_11_9, arg_11_1)
	arg_11_0:_sync_hero_completion(arg_11_1)
end

local var_0_9 = {}

StartGameWindowMissionSelectionConsole._sync_completed_difficulty = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3)
	local var_12_0 = arg_12_3.level_id
	local var_12_1 = LevelUnlockUtils.completed_level_difficulty_index(arg_12_0._statistics_db, arg_12_0._stats_id, var_12_0)

	if var_12_1 == 0 then
		return
	end

	local var_12_2 = DefaultDifficulties[var_12_1]
	local var_12_3 = DifficultySettings[var_12_2]
	local var_12_4 = var_12_3.display_name
	local var_12_5 = Localize("map_difficulty_setting")
	local var_12_6 = var_12_3.display_image
	local var_12_7 = var_0_0.create_difficulty_widget(var_12_6, var_12_5, var_12_4)
	local var_12_8 = UIWidget.init(var_12_7)
	local var_12_9 = var_12_8.style.text
	local var_12_10 = UIUtils.get_text_width(arg_12_0._ui_renderer, var_12_9, var_12_5) + 20
	local var_12_11 = {
		80,
		90
	}
	local var_12_12 = 0
	local var_12_13 = 0
	local var_12_14 = 2
	local var_12_15 = 20
	local var_12_16 = math.floor(arg_12_1 / var_12_14)

	if arg_12_1 % var_12_14 > 0 then
		var_12_15 = var_12_15 + (var_12_11[1] + arg_12_2 - 20)
	else
		var_12_15 = 0
	end

	var_12_8.content.completed_difficulty_index = var_12_1

	local var_12_17 = var_12_8.offset

	var_12_17[1] = var_12_15
	var_12_17[2] = -(var_12_16 - 1) * var_12_11[2]
	arg_12_0._loot_object_widgets.difficulty = var_12_8
end

StartGameWindowMissionSelectionConsole._calculate_paint_scrap_amount = function (arg_13_0, arg_13_1)
	if not GameModeSettings[arg_13_1.game_mode or "adventure"].has_art_scraps then
		return 0
	end

	local var_13_0 = arg_13_1.level_id

	table.clear(var_0_9)

	local var_13_1 = Managers.state.achievement:get_entries_from_category("achv_menu_levels_gecko_category_title")
	local var_13_2 = #QuestSettings.scrap_count_level
	local var_13_3 = 0

	for iter_13_0 = 1, var_13_2 do
		local var_13_4 = "gecko_scraps_" .. var_13_0 .. "_" .. iter_13_0

		if table.find(var_13_1, var_13_4) then
			var_13_3 = QuestSettings.scrap_count_level[iter_13_0]
		end
	end

	return var_13_3
end

local var_0_10 = {}

StartGameWindowMissionSelectionConsole._sync_hero_completion = function (arg_14_0, arg_14_1)
	local var_14_0 = arg_14_1.level_id
	local var_14_1 = arg_14_0._widgets_by_name.hero_tabs
	local var_14_2 = var_14_1.content
	local var_14_3 = var_14_1.style

	for iter_14_0 = 1, #ProfilePriority do
		local var_14_4 = ProfilePriority[iter_14_0]
		local var_14_5 = SPProfiles[var_14_4]
		local var_14_6 = var_14_5.display_name
		local var_14_7 = arg_14_0._statistics_db:get_persistent_stat(arg_14_0._stats_id, "completed_levels_" .. var_14_6, var_14_0)

		if var_0_0.use_career_completion then
			local var_14_8, var_14_9 = arg_14_0:_profile_difficulty_index_completed(var_14_5, var_14_0)
			local var_14_10 = "icon_data_" .. iter_14_0
			local var_14_11 = "icon_" .. iter_14_0
			local var_14_12 = var_14_11 .. "_disabled"
			local var_14_13 = "frame_" .. iter_14_0

			var_14_2[var_14_10][var_14_13] = "map_frame_0" .. var_14_8
			var_14_2[var_14_10][var_14_11] = var_14_9.picking_image
			var_14_2[var_14_10][var_14_12] = var_14_9.picking_image
			var_14_2[var_14_10].icon_disabled = not (var_14_7 > 0)

			local var_14_14 = var_14_3[var_14_12]

			var_14_14.color = var_14_7 > 0 and var_14_14.default_color or var_14_14.disabled_color
		else
			var_14_2["hotspot_" .. iter_14_0].disable_button = not (var_14_7 > 0)

			local var_14_15 = var_14_3["icon_" .. iter_14_0 .. "_saturated"]

			var_14_15.color = var_14_7 > 0 and var_14_15.default_color or var_14_15.disabled_color
		end
	end
end

StartGameWindowMissionSelectionConsole._profile_difficulty_index_completed = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._statistics_db
	local var_15_1 = arg_15_0._stats_id
	local var_15_2 = arg_15_1.careers
	local var_15_3 = var_15_2[1]
	local var_15_4 = 0

	for iter_15_0 = #DefaultDifficulties, 1, -1 do
		local var_15_5 = DefaultDifficulties[iter_15_0]

		for iter_15_1 = 1, #var_15_2 do
			local var_15_6 = var_15_2[iter_15_1].display_name

			if var_15_0:get_persistent_stat(var_15_1, "completed_career_levels", var_15_6, arg_15_2, var_15_5) > 0 then
				return iter_15_0, CareerSettings[var_15_6]
			end
		end
	end

	return var_15_4, var_15_3
end

StartGameWindowMissionSelectionConsole._sync_missions = function (arg_16_0, arg_16_1, arg_16_2)
	if not arg_16_1 then
		return
	end

	local var_16_0 = arg_16_2.level_id

	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_1 = iter_16_1.stat_name
		local var_16_2 = arg_16_0._statistics_db:get_persistent_stat(arg_16_0._stats_id, var_16_1, var_16_0)
		local var_16_3 = iter_16_1.amount
		local var_16_4 = iter_16_1.total_amount
		local var_16_5 = iter_16_1.widget

		if var_16_3 ~= var_16_2 then
			iter_16_1.previous_amount = var_16_3 or 0
			iter_16_1.amount = var_16_2

			local var_16_6 = var_16_5.content
			local var_16_7 = var_16_5.style.counter_text

			var_16_6.amount = var_16_2
			var_16_6.total_amount = var_16_4 or 0

			if var_16_4 then
				var_16_6.counter_text = tostring(var_16_2) .. "/" .. tostring(var_16_4)
				var_16_7.text_color = var_16_4 <= var_16_2 and var_16_7.completed_color or var_16_7.default_color
			else
				var_16_6.counter_text = "x" .. tostring(var_16_2)
				var_16_7.text_color = var_16_7.completed_color
			end
		end
	end
end

StartGameWindowMissionSelectionConsole._setup_grid_navigation = function (arg_17_0)
	local var_17_0 = {}
	local var_17_1 = arg_17_0._levels_by_act

	for iter_17_0, iter_17_1 in pairs(var_17_1) do
		if iter_17_0 then
			local var_17_2 = {}

			for iter_17_2 = 1, #iter_17_1 do
				var_17_2[iter_17_2] = iter_17_1[iter_17_2].level_id
			end

			var_17_0[ActSettings[iter_17_0].sorting] = var_17_2
		end
	end

	arg_17_0._navigation_grid = var_17_0

	local var_17_3, var_17_4 = arg_17_0:_find_level_location_in_grid(arg_17_0._selected_level_id)

	arg_17_0._current_row = var_17_3
	arg_17_0._current_column = var_17_4
end

StartGameWindowMissionSelectionConsole._find_level_location_in_grid = function (arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._navigation_grid
	local var_18_1 = 0

	for iter_18_0, iter_18_1 in pairs(var_18_0) do
		if var_18_1 < iter_18_0 then
			var_18_1 = iter_18_0
		end
	end

	local var_18_2
	local var_18_3

	if arg_18_1 then
		for iter_18_2 = 1, var_18_1 do
			local var_18_4 = var_18_0[iter_18_2]

			if var_18_4 then
				local var_18_5 = #var_18_4

				for iter_18_3 = 1, var_18_5 do
					if var_18_4[iter_18_3] == arg_18_1 then
						var_18_2 = iter_18_2
						var_18_3 = iter_18_3

						break
					end
				end

				if var_18_2 and var_18_3 then
					break
				end
			end
		end
	else
		var_18_2, var_18_3 = 1, 1
	end

	if not IS_XB1 then
		-- Nothing
	end

	if not var_18_2 or not var_18_3 then
		for iter_18_4 = 1, var_18_1 do
			if var_18_0[iter_18_4] then
				var_18_2 = iter_18_4
				var_18_3 = 1

				break
			end
		end

		arg_18_0._selected_level_id = nil
	end

	fassert(var_18_2 and var_18_3, "level_id %s does not exist in navigation grid", arg_18_1)

	return var_18_2, var_18_3
end

StartGameWindowMissionSelectionConsole.on_exit = function (arg_19_0, arg_19_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMissionSelectionConsole")

	arg_19_0._ui_animator = nil

	arg_19_0._parent:set_input_description(nil)
end

StartGameWindowMissionSelectionConsole.update = function (arg_20_0, arg_20_1, arg_20_2)
	arg_20_0:_update_animations(arg_20_1)
	arg_20_0:_handle_input(arg_20_1, arg_20_2)
	arg_20_0:_draw(arg_20_1)
end

StartGameWindowMissionSelectionConsole.post_update = function (arg_21_0, arg_21_1, arg_21_2)
	return
end

StartGameWindowMissionSelectionConsole._update_animations = function (arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0._ui_animator

	var_22_0:update(arg_22_1)

	local var_22_1 = arg_22_0._animations

	for iter_22_0, iter_22_1 in pairs(var_22_1) do
		if var_22_0:is_animation_completed(iter_22_1) then
			var_22_0:stop_animation(iter_22_1)

			var_22_1[iter_22_0] = nil
		end
	end

	local var_22_2 = arg_22_0._node_widgets

	for iter_22_2 = 1, #var_22_2 do
		local var_22_3 = var_22_2[iter_22_2]

		arg_22_0:_animate_node_widget(var_22_3, arg_22_1)
	end
end

StartGameWindowMissionSelectionConsole._update_level_option = function (arg_23_0)
	local var_23_0 = arg_23_0._parent:get_selected_level_id()

	if var_23_0 ~= arg_23_0._selected_level_id or not var_23_0 then
		if var_23_0 and arg_23_0:_is_level_presented(var_23_0) then
			arg_23_0:_select_level(var_23_0)
		elseif not arg_23_0._selected_level_id then
			local var_23_1 = arg_23_0:_get_first_level_id()

			arg_23_0:_select_level(var_23_1)
		end
	end
end

StartGameWindowMissionSelectionConsole._is_level_presented = function (arg_24_0, arg_24_1)
	local var_24_0 = arg_24_0._active_node_widgets

	if var_24_0 then
		for iter_24_0 = 1, #var_24_0 do
			if var_24_0[iter_24_0].content.level_data.level_id == arg_24_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowMissionSelectionConsole._get_first_level_id = function (arg_25_0)
	local var_25_0 = arg_25_0._parent:get_selected_area_name()
	local var_25_1 = AreaSettings[var_25_0].acts[1]

	return arg_25_0._levels_by_act[var_25_1][1].level_id
end

StartGameWindowMissionSelectionConsole._update_selection_from_grid = function (arg_26_0)
	local var_26_0 = arg_26_0._current_row
	local var_26_1 = arg_26_0._current_column
	local var_26_2 = arg_26_0._navigation_grid[var_26_0][var_26_1]

	fassert(var_26_2, "No level id at %s-%s", tostring(var_26_0), tostring(var_26_1))
	arg_26_0:_select_level(var_26_2)
	arg_26_0:_play_sound("play_gui_lobby_button_02_mission_act_click")
end

StartGameWindowMissionSelectionConsole._update_grid_row = function (arg_27_0, arg_27_1)
	local var_27_0 = #arg_27_0._navigation_grid

	arg_27_0._current_row = math.clamp(arg_27_1, 1, var_27_0)

	arg_27_0:_update_grid_column(arg_27_0._current_column)
	arg_27_0:_update_selection_from_grid()
end

StartGameWindowMissionSelectionConsole._update_grid_column = function (arg_28_0, arg_28_1)
	local var_28_0 = #arg_28_0._navigation_grid[arg_28_0._current_row]

	arg_28_0._current_column = math.clamp(arg_28_1, 1, var_28_0)

	arg_28_0:_update_selection_from_grid()
end

StartGameWindowMissionSelectionConsole._update_grid_navigation = function (arg_29_0, arg_29_1, arg_29_2)
	local var_29_0 = arg_29_0:_find_row(arg_29_1)

	if var_29_0 ~= arg_29_0._current_row then
		arg_29_0:_update_grid_row(var_29_0)
	end

	local var_29_1 = arg_29_0:_find_column(arg_29_2)

	if var_29_1 ~= arg_29_0._current_column then
		arg_29_0:_update_grid_column(var_29_1)
	end
end

StartGameWindowMissionSelectionConsole._find_row = function (arg_30_0, arg_30_1)
	if arg_30_1 == 0 then
		return arg_30_0._current_row
	end

	local var_30_0 = arg_30_0._current_row
	local var_30_1 = arg_30_0._current_row
	local var_30_2 = arg_30_0._navigation_grid

	if arg_30_1 < 0 then
		for iter_30_0, iter_30_1 in pairs(var_30_2) do
			if iter_30_0 < var_30_1 then
				var_30_0 = iter_30_0
			else
				break
			end
		end
	else
		for iter_30_2, iter_30_3 in pairs(var_30_2) do
			if var_30_1 < iter_30_2 then
				var_30_0 = iter_30_2

				break
			end
		end
	end

	return var_30_0
end

StartGameWindowMissionSelectionConsole._find_column = function (arg_31_0, arg_31_1)
	if arg_31_1 == 0 then
		return arg_31_0._current_column
	end

	local var_31_0 = arg_31_0._current_column
	local var_31_1 = arg_31_0._current_column
	local var_31_2 = arg_31_0._navigation_grid[arg_31_0._current_row]

	if arg_31_1 < 0 then
		for iter_31_0, iter_31_1 in pairs(var_31_2) do
			if iter_31_0 < var_31_1 then
				var_31_0 = iter_31_0
			else
				break
			end
		end
	else
		for iter_31_2, iter_31_3 in pairs(var_31_2) do
			if var_31_1 < iter_31_2 then
				var_31_0 = iter_31_2

				break
			end
		end
	end

	return var_31_0
end

StartGameWindowMissionSelectionConsole._level_is_unlocked = function (arg_32_0, arg_32_1)
	local var_32_0 = arg_32_0._statistics_db
	local var_32_1 = arg_32_0._stats_id

	return LevelUnlockUtils.level_unlocked(var_32_0, var_32_1, arg_32_1)
end

StartGameWindowMissionSelectionConsole._handle_input = function (arg_33_0, arg_33_1, arg_33_2)
	local var_33_0 = arg_33_0._parent
	local var_33_1 = var_33_0:window_input_service()
	local var_33_2 = Managers.input:is_device_active("mouse")

	if not var_33_2 then
		if var_33_1:get("move_down_hold_continuous") then
			arg_33_0:_update_grid_navigation(1, 0)
		elseif var_33_1:get("move_up_hold_continuous") then
			arg_33_0:_update_grid_navigation(-1, 0)
		elseif var_33_1:get("move_right_hold_continuous") then
			arg_33_0:_update_grid_navigation(0, 1)
		elseif var_33_1:get("move_left_hold_continuous") then
			arg_33_0:_update_grid_navigation(0, -1)
		end
	end

	local var_33_3 = arg_33_0._active_node_widgets

	if var_33_3 then
		for iter_33_0 = 1, #var_33_3 do
			local var_33_4 = var_33_3[iter_33_0]
			local var_33_5 = var_33_4.content.level_data.level_id

			if UIUtils.is_button_hover_enter(var_33_4) and arg_33_0._selected_level_id ~= var_33_5 then
				arg_33_0:_play_sound("play_gui_lobby_button_02_mission_act_click")
				arg_33_0:_select_level(var_33_5)
			end

			if UIUtils.is_button_pressed(var_33_4) then
				var_33_0:set_selected_level_id(var_33_5)

				local var_33_6 = var_33_0:get_selected_game_mode_layout_name()

				var_33_0:set_layout_by_name(var_33_6)

				return
			end
		end
	end

	if not var_33_2 and var_33_1:get(var_0_8, true) and arg_33_0:_level_is_unlocked(arg_33_0._selected_level_id) then
		arg_33_0:_play_sound("play_gui_lobby_button_02_mission_select")
		var_33_0:set_selected_level_id(arg_33_0._selected_level_id)

		local var_33_7 = var_33_0:get_selected_game_mode_layout_name()

		var_33_0:set_layout_by_name(var_33_7)
	end
end

StartGameWindowMissionSelectionConsole._draw = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._ui_top_renderer
	local var_34_1 = arg_34_0._ui_scenegraph
	local var_34_2 = arg_34_0._parent:window_input_service()

	UIRenderer.begin_pass(var_34_0, var_34_1, var_34_2, arg_34_1, nil, arg_34_0._render_settings)
	UIRenderer.draw_all_widgets(var_34_0, arg_34_0._widgets)
	UIRenderer.draw_all_widgets(var_34_0, arg_34_0._loot_object_widgets)

	local var_34_3 = arg_34_0._active_node_widgets

	if var_34_3 then
		UIRenderer.draw_all_widgets(var_34_0, var_34_3)
	end

	local var_34_4 = arg_34_0._active_act_widgets

	if var_34_4 then
		UIRenderer.draw_all_widgets(var_34_0, var_34_4)
	end

	UIRenderer.end_pass(var_34_0)
end

StartGameWindowMissionSelectionConsole._play_sound = function (arg_35_0, arg_35_1)
	arg_35_0._parent:play_sound(arg_35_1)
end

StartGameWindowMissionSelectionConsole._animate_node_widget = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = arg_36_1.content
	local var_36_1 = var_36_0.button_hotspot
	local var_36_2 = var_36_1.is_selected
	local var_36_3 = var_36_1.selected_progress or 0
	local var_36_4 = 9

	if var_36_2 then
		var_36_3 = math.min(var_36_3 + var_36_4 * arg_36_2, 1)
	else
		var_36_3 = math.max(var_36_3 - var_36_4 * arg_36_2, 0)
	end

	local var_36_5 = var_36_0.unlock_guidance
	local var_36_6 = var_36_0.unlock_guidance_progress or 0
	local var_36_7 = 2

	if var_36_5 then
		var_36_6 = math.min(var_36_6 + arg_36_2 * var_36_7, 1)
	else
		var_36_6 = math.max(var_36_6 - arg_36_2 * var_36_7, 0)
	end

	local var_36_8 = arg_36_1.style

	var_36_8.icon_glow.color[1] = 255 * var_36_3

	local var_36_9 = math.max(math.lerp(-2.5, 1, var_36_6), 0)

	var_36_8.icon_unlock_guidance_glow.color[1] = 255 * var_36_9
	var_36_1.selected_progress = var_36_3
	var_36_0.unlock_guidance_progress = var_36_6
end
