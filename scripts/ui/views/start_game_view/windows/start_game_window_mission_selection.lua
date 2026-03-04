-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_mission_selection.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_mission_selection_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.large_window_size
local var_0_3 = var_0_0.create_level_widget
local var_0_4 = var_0_0.scenegraph_definition
local var_0_5 = var_0_0.animation_definitions

local function var_0_6(arg_1_0, arg_1_1)
	return arg_1_0.act_presentation_order < arg_1_1.act_presentation_order
end

StartGameWindowMissionSelection = class(StartGameWindowMissionSelection)
StartGameWindowMissionSelection.NAME = "StartGameWindowMissionSelection"

StartGameWindowMissionSelection.on_enter = function (arg_2_0, arg_2_1, arg_2_2)
	print("[StartGameWindow] Enter Substate StartGameWindowMissionSelection")

	arg_2_0.parent = arg_2_1.parent

	local var_2_0 = arg_2_1.ingame_ui_context

	arg_2_0.ui_renderer = var_2_0.ui_renderer
	arg_2_0.input_manager = var_2_0.input_manager
	arg_2_0.statistics_db = var_2_0.statistics_db
	arg_2_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_2_1 = Managers.player

	arg_2_0._stats_id = var_2_1:local_player():stats_id()
	arg_2_0.player_manager = var_2_1
	arg_2_0.peer_id = var_2_0.peer_id
	arg_2_0._animations = {}

	arg_2_0:create_ui_elements(arg_2_1, arg_2_2)

	arg_2_0._widgets_by_name.select_button.content.button_hotspot.disable_button = true

	local var_2_2 = arg_2_0.parent:get_selected_area_name()

	arg_2_0:_set_presentation_info()
	arg_2_0:_setup_levels_by_area(var_2_2)
	arg_2_0:_update_level_option()
	arg_2_0.parent:set_input_description("select_mission")

	arg_2_1.return_layout_name = nil
end

StartGameWindowMissionSelection.create_ui_elements = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = UISceneGraph.init_scenegraph(var_0_4)

	arg_3_0.ui_scenegraph = var_3_0

	local var_3_1 = {}
	local var_3_2 = {}

	for iter_3_0, iter_3_1 in pairs(var_0_1) do
		local var_3_3 = UIWidget.init(iter_3_1)

		var_3_1[#var_3_1 + 1] = var_3_3
		var_3_2[iter_3_0] = var_3_3
	end

	arg_3_0._widgets = var_3_1
	arg_3_0._widgets_by_name = var_3_2

	UIRenderer.clear_scenegraph_queue(arg_3_0.ui_renderer)

	arg_3_0.ui_animator = UIAnimator:new(var_3_0, var_0_5)

	if arg_3_2 then
		local var_3_4 = var_3_0.window.local_position

		var_3_4[1] = var_3_4[1] + arg_3_2[1]
		var_3_4[2] = var_3_4[2] + arg_3_2[2]
		var_3_4[3] = var_3_4[3] + arg_3_2[3]
	end
end

StartGameWindowMissionSelection._setup_levels_by_area = function (arg_4_0, arg_4_1)
	local var_4_0 = AreaSettings[arg_4_1]
	local var_4_1 = var_4_0.acts

	arg_4_0._is_dlc = var_4_0.dlc_name ~= nil

	arg_4_0:_setup_level_acts()
	arg_4_0:_present_acts(var_4_1)

	local var_4_2 = var_4_0.create_mission_background_widget

	if var_4_2 then
		local var_4_3 = var_4_2()

		arg_4_0._dlc_background_widget = UIWidget.init(var_4_3)
	else
		arg_4_0._dlc_background_widget = nil
	end
end

StartGameWindowMissionSelection._setup_level_acts = function (arg_5_0)
	local var_5_0 = {}
	local var_5_1 = 0

	for iter_5_0, iter_5_1 in pairs(UnlockableLevels) do
		if not table.find(NoneActLevels, iter_5_1) then
			local var_5_2 = LevelSettings[iter_5_1]
			local var_5_3 = var_5_2.act

			if not var_5_0[var_5_3] then
				var_5_0[var_5_3] = {}
			end

			local var_5_4 = var_5_0[var_5_3]

			var_5_4[#var_5_4 + 1] = var_5_2
			var_5_1 = var_5_1 + 1
		end
	end

	for iter_5_2, iter_5_3 in pairs(var_5_0) do
		table.sort(iter_5_3, var_0_6)
	end

	arg_5_0._levels_by_act = var_5_0
end

StartGameWindowMissionSelection._present_acts = function (arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._is_dlc

	if var_6_0 then
		local var_6_1 = arg_6_0.ui_scenegraph.level_root_node
		local var_6_2 = var_0_2[1]

		var_6_1.local_position[1] = var_6_2 / 2
	end

	local var_6_3 = arg_6_0.statistics_db
	local var_6_4 = arg_6_0._stats_id
	local var_6_5 = {}
	local var_6_6 = 180
	local var_6_7 = var_6_0 and 80 or 34
	local var_6_8 = 250
	local var_6_9 = 3
	local var_6_10 = arg_6_0._levels_by_act

	for iter_6_0, iter_6_1 in pairs(var_6_10) do
		if not arg_6_1 or table.contains(arg_6_1, iter_6_0) then
			local var_6_11 = ActSettings[iter_6_0]
			local var_6_12 = var_6_11.sorting
			local var_6_13 = (var_6_12 - 1) % var_6_9 + 1
			local var_6_14 = #iter_6_1
			local var_6_15 = 0
			local var_6_16 = 0
			local var_6_17 = 0
			local var_6_18 = var_6_9 < var_6_12

			if not var_6_18 then
				if var_6_0 then
					var_6_15 = -((var_6_6 + var_6_7) * var_6_14) / 2 + (var_6_6 + var_6_7) / 2
				else
					var_6_17 = -var_6_8 + (var_6_9 - var_6_13) * var_6_8
				end
			end

			for iter_6_2 = 1, #iter_6_1 do
				local var_6_19 = iter_6_1[iter_6_2]

				if not var_6_0 then
					if var_6_18 then
						var_6_15 = (var_6_6 + var_6_7) * 4
					elseif var_6_13 ~= 2 and iter_6_2 == 1 then
						var_6_15 = var_6_15 + (var_6_6 + var_6_7) / 2
					end
				end

				local var_6_20 = #var_6_5 + 1
				local var_6_21 = "level_root_" .. var_6_20
				local var_6_22 = var_6_19.mission_selection_offset
				local var_6_23 = var_0_3(var_6_21, var_6_22)
				local var_6_24 = UIWidget.init(var_6_23)
				local var_6_25 = var_6_24.content
				local var_6_26 = var_6_24.style
				local var_6_27 = var_6_19.level_id
				local var_6_28 = var_6_19.display_name

				var_6_25.text = Localize(var_6_28)

				local var_6_29 = LevelUnlockUtils.level_unlocked(var_6_3, var_6_4, var_6_27)
				local var_6_30 = LevelUnlockUtils.completed_level_difficulty_index(var_6_3, var_6_4, var_6_27)

				var_6_25.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(var_6_30)
				var_6_25.locked = not var_6_29
				var_6_25.act_key = iter_6_0
				var_6_25.level_key = var_6_27

				local var_6_31 = var_6_19.level_image

				if var_6_31 then
					var_6_25.icon = var_6_31
				else
					var_6_25.icon = "icons_placeholder"
				end

				var_6_25.boss_level, var_6_25.level_data = var_6_19.boss_level, var_6_19

				if not var_6_22 then
					local var_6_32 = var_6_24.offset

					var_6_32[1] = var_6_15
					var_6_32[2] = var_6_17 + var_6_16
				end

				if iter_6_2 < var_6_14 then
					local var_6_33 = iter_6_1[iter_6_2 + 1].level_id

					var_6_25.draw_path_fill, var_6_25.draw_path = LevelUnlockUtils.level_unlocked(var_6_3, var_6_4, var_6_33), var_6_11.draw_path or not var_6_0
					var_6_26.path.texture_size[1] = var_6_6 + var_6_7
					var_6_26.path_glow.texture_size[1] = var_6_6 + var_6_7
				end

				var_6_5[var_6_20] = var_6_24
				var_6_15 = var_6_15 + (var_6_6 + var_6_7)
			end
		end
	end

	arg_6_0._active_node_widgets = var_6_5

	arg_6_0:_setup_required_act_connections()
end

StartGameWindowMissionSelection._setup_required_act_connections = function (arg_7_0)
	local var_7_0 = arg_7_0.statistics_db
	local var_7_1 = arg_7_0._stats_id
	local var_7_2 = arg_7_0.ui_scenegraph
	local var_7_3 = arg_7_0._active_node_widgets

	for iter_7_0 = 1, #var_7_3 do
		local var_7_4 = var_7_3[iter_7_0]
		local var_7_5 = LevelSettings[var_7_4.content.level_key].required_acts

		if var_7_5 then
			local var_7_6 = var_7_2[var_7_4.scenegraph_id].world_position
			local var_7_7 = var_7_4.offset
			local var_7_8 = var_7_6[1] + var_7_7[1]
			local var_7_9 = var_7_6[2] + var_7_7[2]

			for iter_7_1 = 1, #var_7_5 do
				local var_7_10 = var_7_5[iter_7_1]
				local var_7_11 = arg_7_0:_get_last_level_in_act(var_7_10)

				for iter_7_2 = 1, #var_7_3 do
					local var_7_12 = var_7_3[iter_7_2]

					if var_7_12.content.level_key == var_7_11 then
						local var_7_13 = LevelUnlockUtils.completed_level_difficulty_index(var_7_0, var_7_1, var_7_11)
						local var_7_14 = var_7_13 and var_7_13 > 0
						local var_7_15 = var_7_2[var_7_12.scenegraph_id].world_position
						local var_7_16 = var_7_12.style.path
						local var_7_17 = var_7_12.style.path_glow
						local var_7_18 = var_7_12.offset
						local var_7_19 = var_7_15[1] + var_7_18[1]
						local var_7_20 = var_7_15[2] + var_7_18[2]
						local var_7_21 = math.distance_2d(var_7_19, var_7_20, var_7_8, var_7_9)
						local var_7_22 = math.angle(var_7_19, var_7_20, var_7_8, var_7_9)

						var_7_22 = var_7_9 < var_7_20 and math.abs(var_7_22) or -var_7_22
						var_7_16.angle = var_7_22
						var_7_16.texture_size[1] = var_7_21
						var_7_17.texture_size[1] = var_7_21
						var_7_17.angle = var_7_22
						var_7_12.content.draw_path = true
						var_7_12.content.draw_path_fill = var_7_14
					end
				end
			end

			return
		end
	end
end

StartGameWindowMissionSelection._get_last_level_in_act = function (arg_8_0, arg_8_1)
	local var_8_0 = GameActs[arg_8_1]
	local var_8_1
	local var_8_2 = 0

	for iter_8_0 = 1, #var_8_0 do
		local var_8_3 = var_8_0[iter_8_0]
		local var_8_4 = LevelSettings[var_8_3].act_presentation_order

		if var_8_2 < var_8_4 then
			var_8_2 = var_8_4
			var_8_1 = var_8_3
		end
	end

	return var_8_1, var_8_2
end

StartGameWindowMissionSelection._get_first_level_id = function (arg_9_0)
	local var_9_0 = arg_9_0._active_node_widgets

	if var_9_0 then
		return var_9_0[1].content.level_data.level_id
	end
end

StartGameWindowMissionSelection._is_level_presented = function (arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._active_node_widgets

	if var_10_0 then
		for iter_10_0 = 1, #var_10_0 do
			if var_10_0[iter_10_0].content.level_data.level_id == arg_10_1 then
				return true
			end
		end
	end

	return false
end

StartGameWindowMissionSelection._select_level = function (arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._active_node_widgets

	if var_11_0 then
		for iter_11_0 = 1, #var_11_0 do
			local var_11_1 = var_11_0[iter_11_0]
			local var_11_2 = var_11_1.content.level_data.level_id == arg_11_1

			var_11_1.content.button_hotspot.is_selected = var_11_2
		end
	end

	arg_11_0._selected_level_id = arg_11_1

	arg_11_0:_set_presentation_info(arg_11_1)

	arg_11_0._widgets_by_name.select_button.content.button_hotspot.disable_button = arg_11_1 == nil
end

StartGameWindowMissionSelection._set_presentation_info = function (arg_12_0, arg_12_1)
	local var_12_0 = ""
	local var_12_1 = ""
	local var_12_2 = "map_frame_00"
	local var_12_3 = false
	local var_12_4 = arg_12_0._widgets_by_name
	local var_12_5 = var_12_4.selected_level.content

	if arg_12_1 then
		local var_12_6 = arg_12_0.statistics_db
		local var_12_7 = arg_12_0._stats_id
		local var_12_8 = LevelSettings[arg_12_1]
		local var_12_9 = var_12_8.level_image
		local var_12_10 = var_12_8.boss_level
		local var_12_11 = var_12_8.display_name

		var_12_1 = var_12_8.description_text

		local var_12_12 = LevelUnlockUtils.completed_level_difficulty_index(var_12_6, var_12_7, arg_12_1)

		var_12_2 = UIWidgetUtils.get_level_frame_by_difficulty_index(var_12_12)
		var_12_5.icon = var_12_9
		var_12_5.boss_level = var_12_10
		var_12_0 = Localize(var_12_11)
		var_12_1 = Localize(var_12_1)
		var_12_3 = true
	end

	var_12_5.frame = var_12_2
	var_12_5.locked = not var_12_3
	var_12_5.visible = var_12_3
	var_12_5.button_hotspot.disable_button = true
	var_12_4.helper_text.content.visible = not var_12_3
	var_12_4.level_title_divider.content.visible = var_12_3
	var_12_4.level_title.content.text = var_12_0
	var_12_4.description_text.content.text = var_12_1
end

StartGameWindowMissionSelection.on_exit = function (arg_13_0, arg_13_1)
	print("[StartGameWindow] Exit Substate StartGameWindowMissionSelection")

	arg_13_0.ui_animator = nil

	arg_13_0.parent:set_input_description(nil)
end

StartGameWindowMissionSelection.update = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0:_update_animations(arg_14_1)
	arg_14_0:draw(arg_14_1)
end

StartGameWindowMissionSelection.post_update = function (arg_15_0, arg_15_1, arg_15_2)
	arg_15_0:_handle_input(arg_15_1, arg_15_2)
end

StartGameWindowMissionSelection._update_animations = function (arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.ui_animator

	var_16_0:update(arg_16_1)

	local var_16_1 = arg_16_0._animations

	for iter_16_0, iter_16_1 in pairs(var_16_1) do
		if var_16_0:is_animation_completed(iter_16_1) then
			var_16_0:stop_animation(iter_16_1)

			var_16_1[iter_16_0] = nil
		end
	end
end

StartGameWindowMissionSelection._is_button_pressed = function (arg_17_0, arg_17_1)
	local var_17_0 = arg_17_1.content.button_hotspot

	if var_17_0.on_release then
		var_17_0.on_release = false

		return true
	end
end

StartGameWindowMissionSelection._is_button_hovered = function (arg_18_0, arg_18_1)
	if arg_18_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

StartGameWindowMissionSelection._update_level_option = function (arg_19_0)
	local var_19_0 = arg_19_0.parent:get_selected_level_id()

	if var_19_0 ~= arg_19_0._selected_level_id then
		if arg_19_0:_is_level_presented(var_19_0) then
			arg_19_0:_select_level(var_19_0)
		elseif not arg_19_0._selected_level_id then
			local var_19_1 = arg_19_0:_get_first_level_id()

			arg_19_0:_select_level(var_19_1)
		end
	end
end

StartGameWindowMissionSelection._handle_input = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._active_node_widgets

	if var_20_0 then
		for iter_20_0 = 1, #var_20_0 do
			local var_20_1 = var_20_0[iter_20_0]

			if arg_20_0:_is_button_hovered(var_20_1) then
				arg_20_0:_play_sound("play_gui_lobby_button_02_mission_act_hover")
			end

			if arg_20_0:_is_button_pressed(var_20_1) then
				local var_20_2 = var_20_1.content.level_data.level_id

				if arg_20_0._selected_level_id ~= var_20_2 then
					arg_20_0:_play_sound("play_gui_lobby_button_02_mission_act_click")
					arg_20_0:_select_level(var_20_2)
				end

				return
			end
		end
	end

	local var_20_3 = arg_20_0._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(var_20_3, arg_20_1)

	if arg_20_0:_is_button_hovered(var_20_3) then
		arg_20_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_20_0:_is_button_pressed(var_20_3) then
		arg_20_0:_play_sound("play_gui_lobby_button_02_mission_select")

		local var_20_4 = arg_20_0.parent
		local var_20_5 = var_20_4:get_selected_game_mode_layout_name()

		var_20_4:set_layout_by_name(var_20_5)
		var_20_4:set_selected_level_id(arg_20_0._selected_level_id)
	end
end

StartGameWindowMissionSelection.draw = function (arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0.ui_renderer
	local var_21_1 = arg_21_0.ui_scenegraph
	local var_21_2 = arg_21_0.parent:window_input_service()

	UIRenderer.begin_pass(var_21_0, var_21_1, var_21_2, arg_21_1, nil, arg_21_0.render_settings)

	local var_21_3 = arg_21_0._widgets

	for iter_21_0 = 1, #var_21_3 do
		local var_21_4 = var_21_3[iter_21_0]

		UIRenderer.draw_widget(var_21_0, var_21_4)
	end

	local var_21_5 = arg_21_0._active_node_widgets

	if var_21_5 then
		for iter_21_1 = 1, #var_21_5 do
			local var_21_6 = var_21_5[iter_21_1]

			UIRenderer.draw_widget(var_21_0, var_21_6)
		end
	end

	local var_21_7 = arg_21_0._dlc_background_widget

	if var_21_7 then
		UIRenderer.draw_widget(var_21_0, var_21_7)
	end

	UIRenderer.end_pass(var_21_0)
end

StartGameWindowMissionSelection._play_sound = function (arg_22_0, arg_22_1)
	arg_22_0.parent:play_sound(arg_22_1)
end
