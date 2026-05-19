-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_area_selection.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.area_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = "StartGameWindowAreaSelection"

StartGameWindowAreaSelection = class(StartGameWindowAreaSelection)
StartGameWindowAreaSelection.NAME = "StartGameWindowAreaSelection"

function StartGameWindowAreaSelection.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowAreaSelection")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.world_manager = var_1_0.world_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._has_exited = false

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_1.return_layout_name = arg_1_0.parent:get_selected_game_mode_layout_name()
	arg_1_0._widgets_by_name.select_button.content.button_hotspot.disable_button = true

	arg_1_0:_setup_area_widgets()
	arg_1_0:_update_area_option()
	arg_1_0.parent:set_input_description("select_mission")
end

function StartGameWindowAreaSelection.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = UISceneGraph.init_scenegraph(var_0_3)

	arg_2_0.ui_scenegraph = var_2_0

	local var_2_1 = {}
	local var_2_2 = {}

	for iter_2_0, iter_2_1 in pairs(var_0_1) do
		local var_2_3 = UIWidget.init(iter_2_1)

		var_2_1[#var_2_1 + 1] = var_2_3
		var_2_2[iter_2_0] = var_2_3
	end

	arg_2_0._widgets = var_2_1
	arg_2_0._widgets_by_name = var_2_2

	local var_2_4 = {}
	local var_2_5 = {}

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		local var_2_6 = UIWidget.init(iter_2_3)

		var_2_4[#var_2_4 + 1] = var_2_6
		var_2_5[iter_2_2] = var_2_6
	end

	arg_2_0._area_widgets = var_2_4
	arg_2_0._area_widgets_by_name = var_2_5

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_4)

	if arg_2_2 then
		local var_2_7 = var_2_0.window.local_position

		var_2_7[1] = var_2_7[1] + arg_2_2[1]
		var_2_7[2] = var_2_7[2] + arg_2_2[2]
		var_2_7[3] = var_2_7[3] + arg_2_2[3]
	end
end

function StartGameWindowAreaSelection._setup_area_widgets(arg_3_0)
	local var_3_0 = {}

	for iter_3_0, iter_3_1 in pairs(AreaSettings) do
		if not iter_3_1.exclude_from_area_selection then
			var_3_0[#var_3_0 + 1] = iter_3_1
		end
	end

	local function var_3_1(arg_4_0, arg_4_1)
		return arg_4_0.sort_order < arg_4_1.sort_order
	end

	table.sort(var_3_0, var_3_1)

	local var_3_2 = #var_3_0
	local var_3_3 = var_0_3.area_root.size[1]
	local var_3_4 = 25
	local var_3_5 = -((var_3_3 * var_3_2 + var_3_4 * (var_3_2 - 1)) / 2) + var_3_3 / 2
	local var_3_6 = {}
	local var_3_7 = arg_3_0.statistics_db
	local var_3_8 = arg_3_0._stats_id

	for iter_3_2 = 1, var_3_2 do
		local var_3_9 = var_3_0[iter_3_2]
		local var_3_10 = arg_3_0._area_widgets[iter_3_2]

		var_3_6[iter_3_2] = var_3_10

		local var_3_11

		var_3_11.icon, var_3_11 = var_3_9.level_image, var_3_10.content

		local var_3_12 = true
		local var_3_13 = var_3_9.dlc_name

		if var_3_13 then
			var_3_12 = Managers.unlock:is_dlc_unlocked(var_3_13)
		end

		var_3_11.area_name, var_3_11.locked = var_3_9.name, not var_3_12

		local var_3_14 = math.huge
		local var_3_15 = var_3_9.acts
		local var_3_16 = #var_3_15

		for iter_3_3 = 1, var_3_16 do
			local var_3_17 = var_3_15[iter_3_3]
			local var_3_18 = LevelUnlockUtils.highest_completed_difficulty_index_by_act(var_3_7, var_3_8, var_3_17)

			if var_3_18 < var_3_14 then
				var_3_14 = var_3_18
			end
		end

		var_3_11.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(var_3_14)
		var_3_10.offset[1] = var_3_5
		var_3_5 = var_3_5 + var_3_3 + var_3_4
	end

	arg_3_0._active_area_widgets = var_3_6
end

function StartGameWindowAreaSelection._select_area_by_name(arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0._active_area_widgets

	if var_5_0 then
		for iter_5_0 = 1, #var_5_0 do
			local var_5_1 = var_5_0[iter_5_0]
			local var_5_2 = var_5_1.content.area_name == arg_5_1

			var_5_1.content.button_hotspot.is_selected = var_5_2
		end
	end

	arg_5_0._selected_area_name = arg_5_1

	arg_5_0:_set_area_presentation_info(arg_5_1)

	arg_5_0._widgets_by_name.select_button.content.button_hotspot.disable_button = arg_5_1 == nil
end

function StartGameWindowAreaSelection._set_area_presentation_info(arg_6_0, arg_6_1)
	local var_6_0 = ""
	local var_6_1 = ""
	local var_6_2 = true
	local var_6_3 = AreaSettings[arg_6_1]

	if var_6_3 then
		local var_6_4 = var_6_3.dlc_name

		if var_6_4 then
			var_6_2 = Managers.unlock:is_dlc_unlocked(var_6_4)
		end

		var_6_0 = Localize(var_6_3.display_name)
		var_6_1 = Localize(var_6_3.description_text)
	end

	local var_6_5 = arg_6_0._widgets_by_name

	var_6_5.area_title.content.text = var_6_0
	var_6_5.description_text.content.text = var_6_1

	if not var_6_2 then
		var_6_5.not_owned_text.content.visible = true
		var_6_5.select_button.content.visible = true
		var_6_5.requirements_not_met_text.content.visible = false
		var_6_5.select_button.content.title_text = Localize("area_selection_visit_store")
	else
		local var_6_6 = true

		if var_6_3.unlock_requirement_function then
			local var_6_7 = Managers.player:local_player():stats_id()
			local var_6_8 = Managers.player:statistics_db()

			var_6_6 = var_6_3.unlock_requirement_function(var_6_8, var_6_7)
		end

		if var_6_6 then
			var_6_5.select_button.content.visible = true
			var_6_5.requirements_not_met_text.content.visible = false
			var_6_5.select_button.content.title_text = Localize("menu_select")
		else
			var_6_5.select_button.content.visible = false
			var_6_5.requirements_not_met_text.content.visible = true
			var_6_5.requirements_not_met_text.content.text = var_6_3.unlock_requirement_description
		end

		var_6_5.not_owned_text.content.visible = false
	end

	local var_6_9 = var_6_3.video_settings

	if var_6_9 then
		local var_6_10 = var_6_9.material_name
		local var_6_11 = var_6_9.resource

		arg_6_0:_setup_video_player(var_6_10, var_6_11)
	end

	local var_6_12 = var_6_3.menu_sound_event

	arg_6_0:_play_sound(var_6_12)
end

function StartGameWindowAreaSelection.on_exit(arg_7_0, arg_7_1)
	print("[StartGameWindow] Exit Substate StartGameWindowAreaSelection")

	arg_7_0.ui_animator = nil

	arg_7_0.parent:set_input_description(nil)

	arg_7_0._has_exited = true

	arg_7_0:_destroy_video_player()

	arg_7_1.return_layout_name = nil

	arg_7_0:_play_sound("Stop_hud_menu_area_music")
end

function StartGameWindowAreaSelection.update(arg_8_0, arg_8_1, arg_8_2)
	arg_8_0:_update_animations(arg_8_1)
	arg_8_0:_handle_input(arg_8_1, arg_8_2)
	arg_8_0:draw(arg_8_1)
end

function StartGameWindowAreaSelection.post_update(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:draw_video(arg_9_1)
end

function StartGameWindowAreaSelection._update_animations(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0.ui_animator

	var_10_0:update(arg_10_1)

	local var_10_1 = arg_10_0._animations

	for iter_10_0, iter_10_1 in pairs(var_10_1) do
		if var_10_0:is_animation_completed(iter_10_1) then
			var_10_0:stop_animation(iter_10_1)

			var_10_1[iter_10_0] = nil
		end
	end

	local var_10_2 = arg_10_0._active_area_widgets

	if var_10_2 then
		for iter_10_2 = 1, #var_10_2 do
			local var_10_3 = var_10_2[iter_10_2]

			arg_10_0:_animate_area_widget(var_10_3, arg_10_1)
		end
	end
end

function StartGameWindowAreaSelection._is_button_pressed(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_1.content.button_hotspot

	if var_11_0.on_release then
		var_11_0.on_release = false

		return true
	end
end

function StartGameWindowAreaSelection._is_button_hovered(arg_12_0, arg_12_1)
	if arg_12_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function StartGameWindowAreaSelection._update_area_option(arg_13_0)
	local var_13_0 = arg_13_0.parent:get_selected_area_name()

	if var_13_0 ~= arg_13_0._selected_area_name then
		arg_13_0:_select_area_by_name(var_13_0)
	end
end

function StartGameWindowAreaSelection._handle_input(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._active_area_widgets

	if var_14_0 then
		for iter_14_0 = 1, #var_14_0 do
			local var_14_1 = var_14_0[iter_14_0]

			if arg_14_0:_is_button_hovered(var_14_1) then
				arg_14_0:_play_sound("play_gui_lobby_button_02_mission_act_hover")
			end

			if arg_14_0:_is_button_pressed(var_14_1) then
				local var_14_2 = var_14_1.content.area_name

				if arg_14_0._selected_area_name ~= var_14_2 then
					arg_14_0:_select_area_by_name(var_14_2)
				end

				return
			end
		end
	end

	local var_14_3 = arg_14_0._widgets_by_name.select_button

	UIWidgetUtils.animate_default_button(var_14_3, arg_14_1)

	if arg_14_0:_is_button_hovered(var_14_3) then
		arg_14_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_14_0:_is_button_pressed(var_14_3) then
		arg_14_0:_on_select_button_pressed()
	end
end

function StartGameWindowAreaSelection._on_select_button_pressed(arg_15_0)
	local var_15_0 = arg_15_0._selected_area_name
	local var_15_1 = AreaSettings[var_15_0]
	local var_15_2 = true
	local var_15_3 = var_15_1.dlc_name

	if var_15_3 then
		var_15_2 = Managers.unlock:is_dlc_unlocked(var_15_3)
	end

	if var_15_2 then
		local var_15_4 = arg_15_0.parent
		local var_15_5 = var_15_4:get_selected_layout_name()
		local var_15_6

		if var_15_5 == "area_selection_custom" then
			var_15_6 = "mission_selection_custom"
		elseif var_15_5 == "area_selection_twitch" then
			var_15_6 = "mission_selection_twitch"
		end

		var_15_4:set_selected_area_name(var_15_0)
		var_15_4:set_layout_by_name(var_15_6)
	else
		local var_15_7 = var_15_1.store_page_url

		if var_15_7 then
			print("store_page_url", var_15_0, var_15_7)
			arg_15_0:_show_storepage(var_15_7)
		end
	end

	arg_15_0:_play_sound("Play_hud_menu_area_start")
end

function StartGameWindowAreaSelection.draw(arg_16_0, arg_16_1)
	local var_16_0 = arg_16_0.ui_renderer
	local var_16_1 = arg_16_0.ui_scenegraph
	local var_16_2 = arg_16_0.parent:window_input_service()

	UIRenderer.begin_pass(var_16_0, var_16_1, var_16_2, arg_16_1, nil, arg_16_0.render_settings)

	local var_16_3 = arg_16_0._widgets

	for iter_16_0 = 1, #var_16_3 do
		local var_16_4 = var_16_3[iter_16_0]

		UIRenderer.draw_widget(var_16_0, var_16_4)
	end

	local var_16_5 = arg_16_0._active_area_widgets

	if var_16_5 then
		for iter_16_1 = 1, #var_16_5 do
			local var_16_6 = var_16_5[iter_16_1]

			UIRenderer.draw_widget(var_16_0, var_16_6)
		end
	end

	UIRenderer.end_pass(var_16_0)
end

function StartGameWindowAreaSelection.draw_video(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.ui_renderer
	local var_17_1 = arg_17_0.ui_scenegraph
	local var_17_2 = arg_17_0.parent:window_input_service()

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, arg_17_0.render_settings)

	if not arg_17_0._draw_video_next_frame then
		if arg_17_0._video_widget and not arg_17_0._has_exited then
			if not arg_17_0._video_created then
				UIRenderer.draw_widget(var_17_0, arg_17_0._video_widget)
			else
				arg_17_0._video_created = nil
			end
		end
	elseif arg_17_0._draw_video_next_frame then
		arg_17_0._draw_video_next_frame = nil
	end

	UIRenderer.end_pass(var_17_0)
end

function StartGameWindowAreaSelection._play_sound(arg_18_0, arg_18_1)
	arg_18_0.parent:play_sound(arg_18_1)
end

function StartGameWindowAreaSelection._setup_video_player(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0:_destroy_video_player()

	local var_19_0 = arg_19_0.ui_renderer

	if not var_19_0.video_players[var_0_5] then
		local var_19_1 = true

		UIRenderer.create_video_player(var_19_0, var_0_5, var_19_0.world, arg_19_2, var_19_1)
	end

	local var_19_2 = "video"
	local var_19_3 = UIWidgets.create_video(var_19_2, arg_19_1, var_0_5)

	arg_19_0._video_widget = UIWidget.init(var_19_3)
	arg_19_0._video_created = true
	arg_19_0._draw_video_next_frame = true
end

function StartGameWindowAreaSelection._destroy_video_player(arg_20_0)
	local var_20_0 = arg_20_0.ui_renderer
	local var_20_1 = arg_20_0._video_widget

	if var_20_1 then
		UIWidget.destroy(var_20_0, var_20_1)

		arg_20_0._video_widget = nil
	end

	if var_20_0 and var_20_0.video_players[var_0_5] then
		local var_20_2 = var_20_0.world

		UIRenderer.destroy_video_player(var_20_0, var_0_5, var_20_2)
	end

	arg_20_0._video_created = nil
end

function StartGameWindowAreaSelection._animate_area_widget(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1.content
	local var_21_1 = arg_21_1.style
	local var_21_2 = var_21_0.button_hotspot
	local var_21_3 = var_21_2.is_selected
	local var_21_4 = 20
	local var_21_5 = var_21_2.input_progress or 0

	if not var_21_3 and var_21_2.is_clicked and var_21_2.is_clicked == 0 then
		var_21_5 = math.min(var_21_5 + arg_21_2 * var_21_4, 1)
	else
		var_21_5 = math.max(var_21_5 - arg_21_2 * var_21_4, 0)
	end

	local var_21_6 = 8
	local var_21_7 = var_21_2.hover_progress or 0

	if var_21_2.is_hover then
		var_21_7 = math.min(var_21_7 + arg_21_2 * var_21_6, 1)
	else
		var_21_7 = math.max(var_21_7 - arg_21_2 * var_21_6, 0)
	end

	local var_21_8 = var_21_2.selection_progress or 0

	if var_21_3 then
		var_21_8 = math.min(var_21_8 + arg_21_2 * var_21_6, 1)
	else
		var_21_8 = math.max(var_21_8 - arg_21_2 * var_21_6, 0)
	end

	local var_21_9 = 255 * math.max(var_21_7, var_21_8)

	var_21_1.icon_glow.color[1] = var_21_9
	var_21_2.hover_progress = var_21_7
	var_21_2.input_progress = var_21_5
	var_21_2.selection_progress = var_21_8
end

function StartGameWindowAreaSelection._show_storepage(arg_22_0, arg_22_1)
	local var_22_0 = PLATFORM

	if IS_WINDOWS and rawget(_G, "Steam") then
		Steam.open_url(arg_22_1)
	end
end
