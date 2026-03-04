-- chunkname: @scripts/ui/dlc_versus/views/start_game_view/windows/start_game_window_versus_mission_selection.lua

local var_0_0 = local_require("scripts/ui/dlc_versus/views/start_game_view/windows/definitions/start_game_window_versus_mission_selection_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.animation_definitions
local var_0_4 = var_0_0.widget_functions
local var_0_5 = var_0_0.grid_settings
local var_0_6 = "confirm_press"

StartGameWindowVersusMissionSelection = class(StartGameWindowVersusMissionSelection)
StartGameWindowVersusMissionSelection.NAME = "StartGameWindowVersusMissionSelection"

StartGameWindowVersusMissionSelection.on_enter = function (arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowVersusMissionSelection")

	arg_1_0._parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0._ui_renderer = var_1_0.ui_renderer
	arg_1_0._ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0._input_manager = var_1_0.input_manager
	arg_1_0._statistics_db = var_1_0.statistics_db
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0._player_manager = var_1_1
	arg_1_0._peer_id = var_1_0.peer_id
	arg_1_0._selected_grid_index = {
		1,
		1
	}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_gather_level_information()
	arg_1_0:_create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_handle_input_desc()

	arg_1_0._return_layout_name = arg_1_0._parent:get_selected_layout_name() or "versus_custom_game"

	arg_1_0:_start_transition_animation("on_enter")
end

local function var_0_7(arg_2_0, arg_2_1)
	return arg_2_0.act_presentation_order < arg_2_1.act_presentation_order
end

StartGameWindowVersusMissionSelection._gather_level_information = function (arg_3_0)
	local var_3_0 = UnlockableLevelsByGameMode.versus
	local var_3_1 = {}

	for iter_3_0 = 1, #var_3_0 do
		local var_3_2 = var_3_0[iter_3_0]

		var_3_1[iter_3_0] = LevelSettings[var_3_2]
	end

	table.sort(var_3_1, var_0_7)

	var_3_1.act_name = "act_versus"
	arg_3_0._sorted_level_data = {
		{
			area_display_name = "area_selection_carousel_name",
			levels_by_act = {
				var_3_1
			}
		},
		{
			area_display_name = "random_level",
			levels_by_act = {
				{
					DummyAnyLevel,
					act_name = "act_versus"
				}
			}
		}
	}
end

StartGameWindowVersusMissionSelection._start_transition_animation = function (arg_4_0, arg_4_1)
	local var_4_0 = {
		render_settings = arg_4_0._render_settings
	}
	local var_4_1 = {}
	local var_4_2 = arg_4_0._ui_animator:start_animation(arg_4_1, var_4_1, var_0_2, var_4_0)

	arg_4_0._animations[arg_4_1] = var_4_2
end

StartGameWindowVersusMissionSelection._create_ui_elements = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)
	arg_5_0._widgets, arg_5_0._widgets_by_name = UIUtils.create_widgets(var_0_1)

	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = {}
	local var_5_3 = {}
	local var_5_4 = {
		0,
		0,
		0
	}
	local var_5_5 = 1

	for iter_5_0 = 1, #arg_5_0._sorted_level_data do
		var_5_4[1] = 0

		local var_5_6 = arg_5_0._sorted_level_data[iter_5_0]
		local var_5_7 = var_5_6.area_name
		local var_5_8 = UIWidget.init(var_0_4.create_area_entry(var_5_6, var_5_4))

		var_5_0[#var_5_0 + 1] = var_5_8

		local var_5_9 = var_5_4[2]
		local var_5_10 = var_5_8.style.background
		local var_5_11 = var_5_8.style.frame

		var_5_4[1] = var_5_4[1] + var_0_5.area_spacing[1]
		var_5_4[2] = var_5_4[2] + var_0_5.area_spacing[2]
		var_5_4[3] = var_5_4[3] + var_0_5.area_spacing[3]

		local var_5_12 = {
			0,
			var_5_4[2],
			var_5_4[3]
		}
		local var_5_13 = var_5_6.levels_by_act
		local var_5_14 = #var_5_13 > 1

		for iter_5_1 = 1, #var_5_13 do
			var_5_12[1] = var_0_5.margin
			var_5_4[1] = var_0_5.margin

			local var_5_15 = var_5_13[iter_5_1]
			local var_5_16 = var_5_15.act_name

			if var_5_14 then
				local var_5_17 = UIWidget.init(var_0_4.create_act_entry(var_5_16 .. "_display_name", var_5_12))

				var_5_12[1] = var_5_12[1] + var_0_5.act_spacing[1]
				var_5_12[2] = var_5_12[2] + var_0_5.act_spacing[2]
				var_5_12[3] = var_5_12[3] + var_0_5.act_spacing[3]
				var_5_1[#var_5_1 + 1] = var_5_17

				local var_5_18 = UIWidget.init(var_0_4.create_act_entry(var_5_16 .. "_display_name", var_5_4))

				var_5_4[1] = var_5_4[1] + var_0_5.act_spacing[1]
				var_5_4[2] = var_5_4[2] + var_0_5.act_spacing[2]
				var_5_4[3] = var_5_4[3] + var_0_5.act_spacing[3]
				var_5_0[#var_5_0 + 1] = var_5_18
			end

			local var_5_19 = #var_5_15

			for iter_5_2 = 1, var_5_19 do
				local var_5_20 = table.clone(var_5_12)
				local var_5_21 = iter_5_2 - 1
				local var_5_22 = var_5_15[math.min(iter_5_2, #var_5_15)]
				local var_5_23 = false
				local var_5_24

				if var_5_22.level_id ~= "any" then
					local var_5_25 = var_5_22.dlc_name

					if var_5_25 and not Managers.unlock:is_dlc_unlocked(var_5_25) then
						var_5_23 = true
						var_5_24 = "dlc"
					end

					local var_5_26 = script_data.versus_map_pool or Managers.mechanism:mechanism_setting_for_title("map_pool")

					if var_5_26 and not table.find(var_5_26, var_5_22.level_id) then
						var_5_23 = true
						var_5_24 = "map_pool"
					end
				end

				var_5_20[1] = var_5_20[1] + var_0_5.level_spacing[1] * (var_5_21 % var_0_5.columns)
				var_5_20[2] = var_5_20[2] + var_0_5.level_spacing[2] * math.floor(var_5_21 / var_0_5.columns)
				var_5_20[3] = var_5_20[3] + var_0_5.level_spacing[3]

				local var_5_27 = math.floor(var_5_21 / var_0_5.columns) + 1
				local var_5_28 = var_5_21 % var_0_5.columns + 1
				local var_5_29 = UIWidget.init(var_0_4.create_level_entry(var_5_22, var_5_20, arg_5_0._selected_grid_index, {
					var_5_27,
					var_5_28
				}, var_5_23, var_5_24, arg_5_0._level_preferences))
				local var_5_30 = math.floor(var_5_21 / var_0_5.columns) + 1
				local var_5_31 = var_5_21 % var_0_5.columns + 1

				var_5_3[var_5_30] = var_5_3[var_5_30] or {}
				var_5_3[var_5_30][var_5_31] = var_5_3[var_5_30][var_5_31] or {}
				var_5_3[var_5_30][var_5_31] = var_5_29
				var_5_1[#var_5_1 + 1] = var_5_29

				local var_5_32 = table.clone(var_5_4)

				var_5_32[1] = var_5_32[1] + var_0_5.level_spacing[1] * (var_5_21 % var_0_5.columns)
				var_5_32[2] = var_5_32[2] + var_0_5.level_spacing[2] * math.floor(var_5_21 / var_0_5.columns)
				var_5_32[3] = var_5_32[3] + var_0_5.level_spacing[3]

				local var_5_33 = var_5_5 - 1 + var_5_30
				local var_5_34 = UIWidget.init(var_0_4.create_level_entry(var_5_22, var_5_32, arg_5_0._selected_grid_index, {
					var_5_33,
					var_5_31
				}, var_5_23, var_5_24, arg_5_0._level_preferences))

				var_5_2[var_5_33] = var_5_2[var_5_33] or {}
				var_5_2[var_5_33][var_5_31] = var_5_2[var_5_33][var_5_31] or {}
				var_5_2[var_5_33][var_5_31] = var_5_34
				var_5_0[#var_5_0 + 1] = var_5_34
				var_5_34.content.selected_index = arg_5_0._selected_grid_index
				var_5_34.content.preferred_levels = arg_5_0._level_preferences
			end

			local var_5_35 = 1 + math.floor((var_5_19 - 1) / var_0_5.columns)

			var_5_12[2] = var_5_12[2] + var_0_5.level_spacing[2] * var_5_35
			var_5_4[2] = var_5_4[2] + var_0_5.level_spacing[2] * var_5_35
			var_5_5 = var_5_5 + var_5_35
		end

		var_5_10.texture_size[2] = var_5_4[2] - var_5_9 + var_0_5.section_spacing[2] * 0.5
		var_5_11.area_size[2] = -var_5_10.texture_size[2] + var_5_11.edge_height * 2
		var_5_10.offset[2] = var_5_4[2] - var_5_9 + var_0_5.section_spacing[2] * 0.5
		var_5_12[2] = var_5_12[2] + var_0_5.section_spacing[2]
		var_5_4[2] = var_5_4[2] + var_0_5.section_spacing[2]
	end

	arg_5_0._total_length = var_5_4[2]
	arg_5_0._scroll_multiplier = (UISettings.game_start_windows.size[2] + 20) / math.abs(arg_5_0._total_length)

	local var_5_36 = arg_5_0._widgets_by_name.scroller

	var_5_36.style.scroller.texture_size[2] = (UISettings.game_start_windows.size[2] + 20) * arg_5_0._scroll_multiplier - 6
	var_5_36.content.visible = false
	arg_5_0._current_entries = var_5_0
	arg_5_0._current_grid_entries = var_5_2
	arg_5_0._global_entries = var_5_0
	arg_5_0._area_entries = var_5_1
	arg_5_0._global_grid_entries = var_5_2
	arg_5_0._area_grid_entries = var_5_3

	UIRenderer.clear_scenegraph_queue(arg_5_0._ui_renderer)

	arg_5_0._ui_animator = UIAnimator:new(arg_5_0._ui_scenegraph, var_0_3)

	if arg_5_2 then
		local var_5_37 = arg_5_0._ui_scenegraph.window.local_position

		var_5_37[1] = var_5_37[1] + arg_5_2[1]
		var_5_37[2] = var_5_37[2] + arg_5_2[2]
		var_5_37[3] = var_5_37[3] + arg_5_2[3]
	end

	arg_5_0:_populate_description()
end

StartGameWindowVersusMissionSelection.on_exit = function (arg_6_0, arg_6_1)
	print("[StartGameWindow] Exit Substate StartGameWindowVersusMissionSelection")

	arg_6_0._ui_animator = nil

	arg_6_0._parent:set_input_description(nil)
end

StartGameWindowVersusMissionSelection.update = function (arg_7_0, arg_7_1, arg_7_2)
	arg_7_0:_update_animations(arg_7_1)
	arg_7_0:_handle_input(arg_7_1, arg_7_2)
	arg_7_0:_update_gamepad_scroller(arg_7_1, arg_7_2)
	arg_7_0:_update_scroller(arg_7_1, arg_7_2)
	arg_7_0:_draw(arg_7_1)
end

StartGameWindowVersusMissionSelection._update_gamepad_scroller = function (arg_8_0, arg_8_1, arg_8_2)
	if not Managers.input:is_device_active("gamepad") then
		return
	end

	local var_8_0 = UISettings.game_start_windows.size[2] + 20
	local var_8_1 = arg_8_0._total_length + UISettings.game_start_windows.size[2] + 20
	local var_8_2 = arg_8_0._ui_scenegraph.grid_anchor.local_position[2]
	local var_8_3 = arg_8_0._current_grid_entries
	local var_8_4 = arg_8_0._selected_grid_index
	local var_8_5 = arg_8_0._old_grid_y_selection or 0
	local var_8_6 = var_8_4[1]
	local var_8_7 = var_8_4[2]

	if var_8_6 == var_8_5 then
		return
	end

	local var_8_8 = var_8_3[var_8_6][var_8_7].offset[2]
	local var_8_9 = -var_8_2 - var_8_8
	local var_8_10 = math.clamp(var_8_2 + (var_8_9 - var_8_0 / 2), 0, math.abs(var_8_1))

	arg_8_0._ui_animations.scroll = UIAnimation.init(UIAnimation.function_by_time, arg_8_0._ui_scenegraph.grid_anchor.position, 2, arg_8_0._ui_scenegraph.grid_anchor.position[2], var_8_10, 0.3, math.easeOutCubic)

	local var_8_11 = arg_8_0._widgets_by_name.scroller.style.scroller
	local var_8_12 = 3 + (UISettings.game_start_windows.size[2] - 6) * (1 - arg_8_0._scroll_multiplier) * (var_8_10 / math.abs(var_8_1))

	arg_8_0._ui_animations.scroller = UIAnimation.init(UIAnimation.function_by_time, var_8_11.offset, 2, var_8_11.offset[2], -var_8_12, 0.3, math.easeOutCubic)
	arg_8_0._old_grid_y_selection = var_8_6
end

StartGameWindowVersusMissionSelection._update_scroller = function (arg_9_0, arg_9_1, arg_9_2)
	if Managers.input:is_device_active("gamepad") then
		return
	end
end

StartGameWindowVersusMissionSelection.post_update = function (arg_10_0, arg_10_1, arg_10_2)
	return
end

StartGameWindowVersusMissionSelection._update_animations = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._ui_animator

	var_11_0:update(arg_11_1)

	local var_11_1 = arg_11_0._animations

	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		if var_11_0:is_animation_completed(iter_11_1) then
			var_11_0:stop_animation(iter_11_1)

			var_11_1[iter_11_0] = nil
		end
	end

	local var_11_2 = arg_11_0._ui_animations

	for iter_11_2, iter_11_3 in pairs(var_11_2) do
		UIAnimation.update(iter_11_3, arg_11_1)

		if UIAnimation.completed(iter_11_3) then
			var_11_2[iter_11_2] = nil
		end
	end
end

StartGameWindowVersusMissionSelection._handle_input = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._parent:window_input_service()

	if var_12_0:get("move_right_hold_continuous") then
		arg_12_0:_update_selection(0, 1)
	elseif var_12_0:get("move_left_hold_continuous") then
		arg_12_0:_update_selection(0, -1)
	end

	if var_12_0:get("move_up_hold_continuous") then
		arg_12_0:_update_selection(-1, 0)
	elseif var_12_0:get("move_down_hold_continuous") then
		arg_12_0:_update_selection(1, 0)
	end

	if var_12_0:get("confirm_press", true) then
		local var_12_1 = arg_12_0._current_grid_entries
		local var_12_2 = arg_12_0._selected_grid_index
		local var_12_3 = var_12_2[1]
		local var_12_4 = var_12_2[2]
		local var_12_5 = var_12_1[var_12_3][var_12_4]

		if not var_12_5.content.is_disabled then
			local var_12_6 = var_12_5.content.level_settings.level_id

			arg_12_0._parent:set_selected_level_id(var_12_6)
			arg_12_0._parent:set_layout_by_name(arg_12_0._return_layout_name)

			local var_12_7 = Managers.matchmaking

			if var_12_7:is_in_versus_custom_game_lobby() then
				var_12_7:set_selected_level(var_12_6)
			end

			return
		end
	end

	for iter_12_0, iter_12_1 in pairs(arg_12_0._current_entries) do
		local var_12_8 = iter_12_1.content.level_settings

		if var_12_8 then
			if UIUtils.is_button_hover_enter(iter_12_1) then
				local var_12_9 = iter_12_1.content.index

				arg_12_0:_set_selection(var_12_9[1], var_12_9[2])
			elseif UIUtils.is_button_pressed(iter_12_1) then
				local var_12_10 = var_12_8.level_id

				arg_12_0._parent:set_selected_level_id(var_12_10)
				arg_12_0._parent:set_layout_by_name(arg_12_0._return_layout_name)

				local var_12_11 = Managers.matchmaking

				if var_12_11:is_in_versus_custom_game_lobby() then
					var_12_11:set_selected_level(var_12_10)
				end

				break
			end
		end
	end
end

StartGameWindowVersusMissionSelection._set_selection = function (arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._selected_grid_index

	var_13_0[1] = arg_13_1
	var_13_0[2] = arg_13_2

	arg_13_0:_populate_description()
end

StartGameWindowVersusMissionSelection._update_selection = function (arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._current_grid_entries
	local var_14_1 = arg_14_0._selected_grid_index

	if math.abs(arg_14_1) > 0 then
		local var_14_2 = math.clamp(var_14_1[1] + arg_14_1, 1, table.size(var_14_0))
		local var_14_3 = table.size(var_14_0[var_14_2])

		var_14_1[2], var_14_1[1] = math.min(var_14_1[2], var_14_3), var_14_2
	elseif math.abs(arg_14_2) > 0 then
		local var_14_4 = var_14_1[1]

		var_14_1[2] = math.clamp(var_14_1[2] + arg_14_2, 1, table.size(var_14_0[var_14_4]))
	end

	arg_14_0:_handle_input_desc()
	arg_14_0:_populate_description()
end

StartGameWindowVersusMissionSelection._handle_input_desc = function (arg_15_0)
	local var_15_0 = arg_15_0._current_grid_entries
	local var_15_1 = arg_15_0._selected_grid_index
	local var_15_2 = var_15_1[1]
	local var_15_3 = var_15_1[2]
	local var_15_4 = var_15_0[var_15_2][var_15_3]

	if var_15_4.content.dlc_is_locked then
		arg_15_0._parent:set_input_description(nil)

		return
	end

	local var_15_5 = var_15_4.content.level_settings.level_id

	do return end

	if not arg_15_0._level_preferences[1][var_15_5] and arg_15_0._level_preferences[2][var_15_5] then
		-- Nothing
	end
end

StartGameWindowVersusMissionSelection._populate_description = function (arg_16_0)
	local var_16_0 = arg_16_0._selected_grid_index
	local var_16_1 = var_16_0[1]
	local var_16_2 = var_16_0[2]
	local var_16_3 = arg_16_0._current_grid_entries[var_16_1][var_16_2]
	local var_16_4 = var_16_3.content.level_settings
	local var_16_5 = ""
	local var_16_6 = ""
	local var_16_7 = "map_frame_00"
	local var_16_8 = false
	local var_16_9 = true
	local var_16_10 = ""
	local var_16_11 = arg_16_0._widgets_by_name
	local var_16_12 = var_16_11.selected_level.content

	if var_16_4 then
		local var_16_13 = arg_16_0._statistics_db
		local var_16_14 = arg_16_0._stats_id
		local var_16_15 = var_16_4.level_id
		local var_16_16 = var_16_4.level_image
		local var_16_17 = var_16_4.boss_level
		local var_16_18 = var_16_4.display_name

		var_16_6 = var_16_4.description_text

		local var_16_19 = LevelUnlockUtils.completed_level_difficulty_index(var_16_13, var_16_14, var_16_15)

		var_16_7 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_16_19)
		var_16_9 = var_16_3.content.is_disabled or var_16_15 ~= "any" and not LevelUnlockUtils.level_unlocked(var_16_13, var_16_14, var_16_15)

		if var_16_9 then
			local var_16_20 = var_16_4.dlc_name

			if var_16_20 and not Managers.unlock:is_dlc_unlocked(var_16_20) then
				var_16_10 = Localize("dlc1_2_dlc_level_locked_tooltip")
			end
		end

		var_16_12.icon = var_16_16
		var_16_12.boss_level = var_16_17
		var_16_5 = Localize(var_16_18)
		var_16_6 = var_16_6 and Localize(var_16_6)
		var_16_8 = true
	end

	var_16_12.frame = var_16_7
	var_16_12.locked = var_16_9
	var_16_12.visible = var_16_8
	var_16_12.button_hotspot.disable_button = true
	var_16_11.helper_text.content.visible = not var_16_8
	var_16_11.level_title_divider.content.visible = var_16_8
	var_16_11.level_title.content.text = var_16_5
	var_16_11.description_text.content.text = var_16_6
	var_16_11.description_text.content.visible = not not var_16_6
	var_16_11.locked_text.content.text = var_16_10
end

StartGameWindowVersusMissionSelection._draw = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0._ui_top_renderer
	local var_17_1 = arg_17_0._ui_scenegraph
	local var_17_2 = arg_17_0._parent:window_input_service()

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, arg_17_0._render_settings)
	UIRenderer.draw_all_widgets(var_17_0, arg_17_0._widgets)
	UIRenderer.draw_all_widgets(var_17_0, arg_17_0._global_entries)
	UIRenderer.end_pass(var_17_0)
end
