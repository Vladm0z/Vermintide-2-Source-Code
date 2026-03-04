-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_area_selection_console_v2.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_area_selection_console_v2_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.area_widgets
local var_0_3 = var_0_0.scenegraph_definition
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = true

StartGameWindowAreaSelectionConsoleV2 = class(StartGameWindowAreaSelectionConsoleV2)
StartGameWindowAreaSelectionConsoleV2.NAME = "StartGameWindowAreaSelectionConsoleV2"

function StartGameWindowAreaSelectionConsoleV2.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowAreaSelectionConsoleV2")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.world_manager = var_1_0.world_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}
	arg_1_0._has_exited = false
	arg_1_0._params = arg_1_1
	arg_1_0._offset = arg_1_2

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._ui_animation_callbacks = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)

	arg_1_0._area_unavailable = true

	arg_1_0.parent:set_input_description("select_area_confirm")
	arg_1_0:_setup_area_widgets()
	arg_1_0:_update_area_option()
end

function StartGameWindowAreaSelectionConsoleV2.create_ui_elements(arg_2_0, arg_2_1, arg_2_2)
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
	local var_2_6 = UIWidget.init(var_0_0.main_campaign_widget)

	var_2_4[#var_2_4 + 1] = var_2_6
	var_2_5.main_campaign = var_2_6

	for iter_2_2, iter_2_3 in pairs(var_0_2) do
		local var_2_7 = UIWidget.init(iter_2_3)

		var_2_4[#var_2_4 + 1] = var_2_7
		var_2_5[iter_2_2] = var_2_7
	end

	arg_2_0._area_widgets = var_2_4
	arg_2_0._area_widgets_by_name = var_2_5
	arg_2_0._level_image_widgets = {}

	UIRenderer.clear_scenegraph_queue(arg_2_0.ui_top_renderer)

	arg_2_0.ui_animator = UIAnimator:new(var_2_0, var_0_4)

	if arg_2_2 then
		local var_2_8 = var_2_0.window.local_position

		var_2_8[1] = var_2_8[1] + arg_2_2[1]
		var_2_8[2] = var_2_8[2] + arg_2_2[2]
		var_2_8[3] = var_2_8[3] + arg_2_2[3]
	end
end

function StartGameWindowAreaSelectionConsoleV2._setup_area_widgets(arg_3_0)
	local var_3_0 = {}
	local var_3_1 = var_0_0.grid_settings[1] * var_0_0.grid_settings[2]

	for iter_3_0, iter_3_1 in pairs(AreaSettings) do
		if not iter_3_1.exclude_from_area_selection then
			var_3_0[#var_3_0 + 1] = iter_3_1
		end

		if #var_3_0 == var_3_1 then
			break
		end
	end

	local function var_3_2(arg_4_0, arg_4_1)
		return arg_4_0.sort_order < arg_4_1.sort_order
	end

	table.sort(var_3_0, var_3_2)

	local var_3_3 = #var_3_0
	local var_3_4 = var_0_3.area_root_1.size[1]
	local var_3_5 = 30
	local var_3_6 = -705
	local var_3_7 = 280
	local var_3_8 = var_3_7
	local var_3_9 = var_0_0.grid_settings
	local var_3_10 = {}
	local var_3_11 = arg_3_0.statistics_db
	local var_3_12 = arg_3_0._stats_id
	local var_3_13 = {}

	for iter_3_2 = 1, var_3_3 do
		local var_3_14 = var_3_0[iter_3_2]
		local var_3_15 = iter_3_2 == 1 and arg_3_0._widgets_by_name.main_campaign or arg_3_0._area_widgets[iter_3_2]

		var_3_13[iter_3_2] = var_3_15

		local var_3_16 = var_3_14.level_image
		local var_3_17 = var_3_15.content
		local var_3_18 = var_3_15.style

		var_3_17.icon = var_3_16

		local var_3_19 = true
		local var_3_20 = var_3_14.dlc_name

		if var_3_20 then
			var_3_19 = Managers.unlock:is_dlc_unlocked(var_3_20)
		end

		var_3_17.area_name, var_3_17.locked = var_3_14.name, not var_3_19
		var_3_17.area_desc = var_3_14.long_description_text or arg_3_0:_create_random_desc()

		local var_3_21 = math.huge
		local var_3_22 = var_3_14.acts

		for iter_3_3 = 1, #var_3_22 do
			local var_3_23 = var_3_22[iter_3_3]
			local var_3_24 = LevelUnlockUtils.highest_completed_difficulty_index_by_act(var_3_11, var_3_12, var_3_23)

			if var_3_24 < var_3_21 then
				var_3_21 = var_3_24
			end
		end

		var_3_17.frame = UIWidgetUtils.get_level_frame_by_difficulty_index(var_3_21)

		local var_3_25 = var_3_15.offset

		if iter_3_2 == 1 then
			local var_3_26 = math.floor(math.max(0, var_3_3 - 2) / var_3_9[1])

			var_3_25[1] = var_3_6
			var_3_25[2] = -var_3_26 * (var_3_4 + var_3_5) * 0.5
			var_3_18.divider.texture_size[2] = (var_3_26 + 1) * (var_3_4 + var_3_5)
			var_3_10[iter_3_2] = {}
			var_3_10[iter_3_2][#var_3_10[iter_3_2] + 1] = var_3_15
		else
			local var_3_27 = (iter_3_2 - 2) % var_3_9[1]
			local var_3_28 = math.floor((iter_3_2 - 2) / var_3_9[1])

			var_3_25[1] = var_3_6 + var_3_27 * (var_3_4 + var_3_5) + var_3_7 * math.sign(iter_3_2 - 1)
			var_3_25[2] = -var_3_28 * (var_3_4 + var_3_5)
			var_3_8 = var_3_8 + var_3_4 + var_3_5

			local var_3_29 = 2 + (iter_3_2 - 2) % var_3_9[1]

			var_3_10[var_3_29] = var_3_10[var_3_29] or {}
			var_3_10[var_3_29][#var_3_10[var_3_29] + 1] = var_3_15
		end
	end

	arg_3_0._active_area_widgets = var_3_13
	arg_3_0._selection_grid = var_3_10
	arg_3_0._selected_grid_index = {
		1,
		1
	}
end

function StartGameWindowAreaSelectionConsoleV2._create_random_desc(arg_5_0)
	local var_5_0 = 1 + Math.random(5)
	local var_5_1 = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut fringilla in nulla eu rutrum. "
	local var_5_2 = ""

	for iter_5_0 = 1, var_5_0 do
		var_5_2 = var_5_2 .. var_5_1
	end

	return var_5_2
end

function StartGameWindowAreaSelectionConsoleV2._select_area_by_name(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._selection_grid
	local var_6_1 = " "
	local var_6_2 = arg_6_0._selected_grid_index

	if var_6_0 then
		for iter_6_0 = 1, #var_6_0 do
			local var_6_3 = var_6_0[iter_6_0]

			for iter_6_1 = 1, #var_6_3 do
				local var_6_4 = var_6_3[iter_6_1]
				local var_6_5 = var_6_4.content
				local var_6_6 = var_6_5.area_name == arg_6_1

				var_6_4.content.button_hotspot.is_selected = var_6_6
				var_6_2 = var_6_6 and {
					iter_6_0,
					iter_6_1
				} or var_6_2
				var_6_1 = var_6_6 and var_6_5.area_desc or var_6_1
			end
		end
	end

	arg_6_0._selected_area_name = arg_6_1
	arg_6_0._selected_grid_index = var_6_2

	arg_6_0:_set_area_presentation_info(arg_6_1, var_6_1)

	arg_6_0._area_unavailable = arg_6_1 == nil
end

function StartGameWindowAreaSelectionConsoleV2._set_area_presentation_info(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = ""
	local var_7_1 = ""
	local var_7_2 = ""
	local var_7_3 = true
	local var_7_4 = Managers.player:local_player():stats_id()
	local var_7_5 = Managers.player:statistics_db()
	local var_7_6 = AreaSettings[arg_7_1]

	if var_7_6 then
		local var_7_7 = var_7_6.dlc_name

		if var_7_7 then
			var_7_3 = Managers.unlock:is_dlc_unlocked(var_7_7)
		end

		var_7_0 = Localize(var_7_6.display_name)

		local var_7_8 = Localize(var_7_6.description_text)

		var_7_2 = var_7_3 and (var_7_6.area_type or var_7_6.sort_order == 1 and "area_selection_campaign" or "area_selection_side_quest") or "dlc1_2_dlc_level_locked_tooltip"
	end

	local var_7_9 = arg_7_0._widgets_by_name

	var_7_9.area_title.content.text = var_7_0
	var_7_9.area_desc.content.text = arg_7_2
	var_7_9.area_type.content.text = var_7_2
	var_7_9.area_type.content.dlc_locked = not var_7_3
	var_7_9.area_type.content.locked = not var_7_3

	if var_0_5 then
		local var_7_10 = var_7_9.area_desc.style

		var_7_10.text.area_size = {
			1200,
			225
		}
		var_7_10.text.vertical_alignment = "top"
		var_7_10.text.dynamic_font_size_word_wrap = true
		var_7_10.text_shadow.area_size = {
			1200,
			225
		}
		var_7_10.text_shadow.vertical_alignment = "top"
		var_7_10.text_shadow.dynamic_font_size_word_wrap = true
		var_7_9.area_title.offset[2] = 200
		var_7_9.title_divider.offset[2] = 200
		var_7_9.area_type.offset[2] = 200
	else
		local var_7_11 = UIUtils.get_text_height(arg_7_0.ui_renderer, var_7_9.area_desc.style.text.area_size, var_7_9.area_desc.style.text, arg_7_2)

		var_7_9.area_title.offset[2] = var_7_11
		var_7_9.title_divider.offset[2] = var_7_11
		var_7_9.area_type.offset[2] = var_7_11
	end

	local var_7_12 = 40
	local var_7_13 = 5
	local var_7_14 = var_7_6.acts
	local var_7_15 = 0

	table.clear(arg_7_0._level_image_widgets)

	for iter_7_0, iter_7_1 in ipairs(var_7_14) do
		local var_7_16 = GameActs[iter_7_1]

		for iter_7_2, iter_7_3 in ipairs(var_7_16) do
			local var_7_17 = LevelSettings[iter_7_3]
			local var_7_18 = LevelUnlockUtils.level_unlocked(var_7_5, var_7_4, var_7_17.level_id)
			local var_7_19 = LevelUnlockUtils.completed_level_difficulty_index(var_7_5, var_7_4, var_7_17.level_id)
			local var_7_20 = UIWidget.init(var_0_0.create_level_image_func(var_7_17.small_level_image or var_7_17.level_id .. "_small_image", var_7_19 > 0))

			var_7_20.offset[1] = var_7_15
			var_7_15 = var_7_15 + var_7_13 + var_7_20.style.level_image.texture_size[1]
			var_7_20.style.level_image.saturated = not var_7_18
			var_7_20.style.level_image.color = var_7_18 and var_7_20.style.level_image.unlocked_color or var_7_20.style.level_image.locked_color
			var_7_20.content.completed = var_7_19 > 0
			var_7_20.content.boss_level = var_7_17.boss_level
			arg_7_0._level_image_widgets[#arg_7_0._level_image_widgets + 1] = var_7_20
		end

		var_7_15 = var_7_15 + var_7_12
	end

	if not var_7_3 then
		arg_7_0.parent:set_input_description("select_area_buy")
	else
		local var_7_21 = true

		if var_7_6.unlock_requirement_function then
			local var_7_22 = Managers.player:local_player():stats_id()
			local var_7_23 = Managers.player:statistics_db()

			var_7_21 = var_7_6.unlock_requirement_function(var_7_23, var_7_22)
		end

		if var_7_21 then
			arg_7_0.parent:set_input_description("select_area_confirm")

			var_7_9.area_type.content.locked = false
		else
			arg_7_0.parent:set_input_description("select_area_base")

			var_7_9.area_type.content.text = var_7_6.unlock_requirement_description
			var_7_9.area_type.content.locked = true
		end
	end

	local var_7_24 = arg_7_0.parent:get_video_player_by_name(arg_7_1)
	local var_7_25 = var_7_6.video_settings

	if var_7_25 then
		local var_7_26 = var_7_25.material_name

		arg_7_0:_assign_video_player(var_7_26, var_7_24)
	end

	local var_7_27 = var_7_6.menu_sound_event

	arg_7_0:_play_sound(var_7_27)
end

function StartGameWindowAreaSelectionConsoleV2.on_exit(arg_8_0, arg_8_1)
	print("[StartGameWindow] Exit Substate StartGameWindowAreaSelectionConsoleV2")

	arg_8_0.ui_animator = nil

	arg_8_0.parent:set_input_description(nil)

	arg_8_0._has_exited = true

	arg_8_0:_destroy_video_widget()
	arg_8_0:_play_sound("Stop_hud_menu_area_music")
end

function StartGameWindowAreaSelectionConsoleV2.update(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1)
	arg_9_0:_handle_input(arg_9_1, arg_9_2)
end

function StartGameWindowAreaSelectionConsoleV2.post_update(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:draw(arg_10_1)
end

function StartGameWindowAreaSelectionConsoleV2._update_animations(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_animator

	var_11_0:update(arg_11_1)

	local var_11_1 = arg_11_0._animations

	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		if var_11_0:is_animation_completed(iter_11_1) then
			var_11_0:stop_animation(iter_11_1)

			var_11_1[iter_11_0] = nil
		end
	end

	local var_11_2 = arg_11_0._active_area_widgets

	if var_11_2 then
		for iter_11_2 = 1, #var_11_2 do
			local var_11_3 = var_11_2[iter_11_2]

			arg_11_0:_animate_area_widget(var_11_3, arg_11_1)
		end
	end

	local var_11_4 = arg_11_0._ui_animations
	local var_11_5 = arg_11_0._ui_animation_callbacks

	for iter_11_3, iter_11_4 in pairs(var_11_4) do
		UIAnimation.update(iter_11_4, arg_11_1)

		if UIAnimation.completed(iter_11_4) then
			var_11_4[iter_11_3] = nil

			if var_11_5[iter_11_3] then
				var_11_5[iter_11_3]()

				var_11_5[iter_11_3] = nil
			end
		end
	end
end

function StartGameWindowAreaSelectionConsoleV2._is_button_pressed(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_release then
		var_12_0.on_release = false

		return true
	end
end

function StartGameWindowAreaSelectionConsoleV2._is_button_hovered(arg_13_0, arg_13_1)
	if arg_13_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

function StartGameWindowAreaSelectionConsoleV2._update_area_option(arg_14_0)
	local var_14_0 = arg_14_0.parent:get_selected_area_name()

	if var_14_0 ~= arg_14_0._selected_area_name then
		arg_14_0:_select_area_by_name(var_14_0)
	end
end

function StartGameWindowAreaSelectionConsoleV2._handle_input(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0.parent:window_input_service()
	local var_15_1 = arg_15_0._active_area_widgets
	local var_15_2 = arg_15_0._selection_grid
	local var_15_3 = Managers.input:is_device_active("mouse")

	if not var_15_3 then
		local var_15_4 = arg_15_0._selected_grid_index[1]
		local var_15_5 = arg_15_0._selected_grid_index[2]
		local var_15_6 = #var_15_2
		local var_15_7 = #var_15_2[var_15_4]

		if var_15_0:get("move_left") then
			local var_15_8 = math.clamp(var_15_4 - 1, 1, var_15_6)
			local var_15_9 = #var_15_2[var_15_8]
			local var_15_10 = var_15_2[var_15_8][math.min(var_15_5, var_15_9)].content.area_name

			if arg_15_0._selected_area_name ~= var_15_10 then
				arg_15_0:_select_area_by_name(var_15_10)
			end
		elseif var_15_0:get("move_right") then
			local var_15_11 = math.clamp(var_15_4 + 1, 1, var_15_6)
			local var_15_12 = #var_15_2[var_15_11]
			local var_15_13 = var_15_2[var_15_11][math.min(var_15_5, var_15_12)].content.area_name

			if arg_15_0._selected_area_name ~= var_15_13 then
				arg_15_0:_select_area_by_name(var_15_13)
			end
		elseif var_15_0:get("move_down") then
			local var_15_14 = var_15_5 + 1
			local var_15_15 = var_15_2[var_15_4][var_15_14]

			while not var_15_15 and var_15_4 > 1 do
				var_15_4 = var_15_4 - 1
				var_15_15 = var_15_2[var_15_4][var_15_14]
			end

			local var_15_16 = var_15_15 and var_15_15.content
			local var_15_17 = var_15_16 and var_15_16.area_name or arg_15_0._selected_area_name

			if arg_15_0._selected_area_name ~= var_15_17 then
				arg_15_0:_select_area_by_name(var_15_17)
			end
		elseif var_15_0:get("move_up") then
			local var_15_18 = math.clamp(var_15_5 - 1, 1, var_15_7)
			local var_15_19 = var_15_2[var_15_4][var_15_18].content.area_name

			if arg_15_0._selected_area_name ~= var_15_19 then
				arg_15_0:_select_area_by_name(var_15_19)
			end
		end
	elseif var_15_1 then
		for iter_15_0 = 1, #var_15_1 do
			local var_15_20 = var_15_1[iter_15_0]

			if arg_15_0:_is_button_hovered(var_15_20) then
				local var_15_21 = var_15_20.content.area_name

				if arg_15_0._selected_area_name ~= var_15_21 then
					arg_15_0:_select_area_by_name(var_15_21)
				end
			end

			if arg_15_0:_is_button_pressed(var_15_20) and not arg_15_0._area_unavailable then
				arg_15_0:_on_select_button_pressed()

				return
			end
		end
	end

	local var_15_22 = not var_15_3 and var_15_0:get("confirm_press", true)

	if not arg_15_0._area_unavailable and var_15_22 then
		arg_15_0:_on_select_button_pressed()
	end
end

function StartGameWindowAreaSelectionConsoleV2._on_select_button_pressed(arg_16_0)
	local var_16_0 = arg_16_0._selected_area_name
	local var_16_1 = AreaSettings[var_16_0]
	local var_16_2 = true
	local var_16_3 = var_16_1.dlc_name

	if var_16_3 then
		var_16_2 = Managers.unlock:is_dlc_unlocked(var_16_3)
	end

	if var_16_2 then
		local var_16_4 = true

		if var_16_1.unlock_requirement_function then
			local var_16_5 = Managers.player:local_player():stats_id()
			local var_16_6 = Managers.player:statistics_db()

			var_16_4 = var_16_1.unlock_requirement_function(var_16_6, var_16_5)
		end

		if var_16_4 then
			local var_16_7 = arg_16_0.parent
			local var_16_8 = "mission_selection"

			var_16_7:set_selected_area_name(var_16_0)
			var_16_7:set_layout_by_name(var_16_8)
		end
	else
		local var_16_9 = var_16_1.store_page_url

		arg_16_0:_show_storepage(var_16_9, var_16_3)
	end

	arg_16_0:_play_sound("Play_hud_menu_area_start")
end

function StartGameWindowAreaSelectionConsoleV2.draw(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0.ui_top_renderer
	local var_17_1 = arg_17_0.ui_scenegraph
	local var_17_2 = arg_17_0.parent:window_input_service()

	UIRenderer.begin_pass(var_17_0, var_17_1, var_17_2, arg_17_1, nil, arg_17_0.render_settings)

	local var_17_3 = arg_17_0._widgets

	for iter_17_0 = 1, #var_17_3 do
		local var_17_4 = var_17_3[iter_17_0]

		UIRenderer.draw_widget(var_17_0, var_17_4)
	end

	local var_17_5 = arg_17_0._active_area_widgets

	if var_17_5 then
		for iter_17_1 = 1, #var_17_5 do
			local var_17_6 = var_17_5[iter_17_1]

			UIRenderer.draw_widget(var_17_0, var_17_6)
		end
	end

	local var_17_7 = arg_17_0._level_image_widgets

	if var_17_7 then
		for iter_17_2 = 1, #var_17_7 do
			local var_17_8 = var_17_7[iter_17_2]

			UIRenderer.draw_widget(var_17_0, var_17_8)
		end
	end

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

function StartGameWindowAreaSelectionConsoleV2._play_sound(arg_18_0, arg_18_1)
	arg_18_0.parent:play_sound(arg_18_1)
end

function StartGameWindowAreaSelectionConsoleV2._assign_video_player(arg_19_0, arg_19_1, arg_19_2)
	arg_19_0:_destroy_video_widget()

	local var_19_0 = "video"
	local var_19_1 = UIWidgets.create_fixed_aspect_video(var_19_0, arg_19_1)
	local var_19_2 = UIWidget.init(var_19_1)

	var_19_2.content.video_content.video_player = arg_19_2

	local var_19_3 = arg_19_0.ui_top_renderer.world

	World.add_video_player(var_19_3, arg_19_2)

	arg_19_0._video_widget = var_19_2
	arg_19_0._video_created = true
	arg_19_0._draw_video_next_frame = true

	local var_19_4 = arg_19_0._widgets_by_name.foreground.style.rect.color

	arg_19_0._ui_animations.fade_in = UIAnimation.init(UIAnimation.function_by_time, var_19_4, 1, 255, 0, 0.5, math.easeInCubic)
end

function StartGameWindowAreaSelectionConsoleV2._destroy_video_widget(arg_20_0)
	local var_20_0 = arg_20_0._video_widget

	if var_20_0 then
		local var_20_1 = arg_20_0.ui_top_renderer
		local var_20_2 = var_20_0.content.video_content.video_player
		local var_20_3 = var_20_1.world

		World.remove_video_player(var_20_3, var_20_2)

		arg_20_0._video_widget = nil
	end

	arg_20_0._video_created = nil
end

function StartGameWindowAreaSelectionConsoleV2._animate_area_widget(arg_21_0, arg_21_1, arg_21_2)
	local var_21_0 = arg_21_1.content
	local var_21_1 = arg_21_1.style
	local var_21_2 = var_21_0.button_hotspot
	local var_21_3 = 20
	local var_21_4 = var_21_2.is_selected
	local var_21_5 = var_21_2.input_progress or 0

	if not var_21_4 and var_21_2.is_clicked and var_21_2.is_clicked == 0 then
		var_21_5 = math.min(var_21_5 + arg_21_2 * var_21_3, 1)
	else
		var_21_5 = math.max(var_21_5 - arg_21_2 * var_21_3, 0)
	end

	local var_21_6 = 8
	local var_21_7 = var_21_2.hover_progress or 0

	if var_21_2.is_hover then
		var_21_7 = math.min(var_21_7 + arg_21_2 * var_21_6, 1)
	else
		var_21_7 = math.max(var_21_7 - arg_21_2 * var_21_6, 0)
	end

	local var_21_8 = var_21_2.selection_progress or 0

	if var_21_4 then
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

function StartGameWindowAreaSelectionConsoleV2._show_storepage(arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = PLATFORM

	if IS_WINDOWS and rawget(_G, "Steam") then
		if arg_22_1 then
			Steam.open_url(arg_22_1)
		end
	elseif IS_XB1 then
		local var_22_1 = Managers.account:user_id()

		if arg_22_2 then
			local var_22_2 = Managers.unlock:dlc_id(arg_22_2)

			if var_22_2 then
				XboxLive.show_product_details(var_22_1, var_22_2)
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_22_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	elseif IS_PS4 then
		local var_22_3 = Managers.account:user_id()

		if arg_22_2 then
			local var_22_4 = Managers.unlock:ps4_dlc_product_label(arg_22_2)

			if var_22_4 then
				Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, var_22_3, {
					var_22_4
				})
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_22_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	end
end
