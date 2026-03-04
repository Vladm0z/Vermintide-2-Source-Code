-- chunkname: @scripts/ui/views/deus_menu/deus_run_stats_ui.lua

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_run_stats_ui_definitions")
local var_0_1 = var_0_0.animations_definitions
local var_0_2 = var_0_0.reminder_widgets
local var_0_3 = var_0_0.generic_input_actions
local var_0_4 = var_0_0.allow_boon_removal

DeusRunStatsUi = class(DeusRunStatsUi)

DeusRunStatsUi.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._ui_top_renderer = arg_1_1.ui_top_renderer
	arg_1_0._wwise_world = arg_1_1.wwise_world
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._ingame_ui_context = arg_1_1
	arg_1_0._parent = arg_1_2
	arg_1_0._gamepad_row_index = 1
	arg_1_0._gamepad_column_index = 1
	arg_1_0._active = false
	arg_1_0._blessing_widgets = {}
	arg_1_0._power_up_widgets = {}
	arg_1_0._reminders = {}
	arg_1_0._animations = {}
	arg_1_0._ui_animations = {}
	arg_1_0._force_update_power_ups = false

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "present_rewards", "show_info_message")
end

DeusRunStatsUi.show_info_message = function (arg_2_0, arg_2_1)
	for iter_2_0 = 1, #arg_2_1 do
		local var_2_0 = arg_2_1[iter_2_0]

		if table.size(arg_2_0._animations) == 0 then
			arg_2_0:_start_animation("reminder", var_2_0.type)
		else
			arg_2_0._reminders[#arg_2_0._reminders + 1] = var_2_0.type
		end
	end
end

DeusRunStatsUi._start_animation = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = {}
	local var_3_1 = arg_3_0._reminder_widgets_by_name.reminder_text

	var_3_1.content.info_type = arg_3_2

	local var_3_2 = arg_3_0._ui_animator:start_animation(arg_3_1, var_3_1, var_0_0.scenegraph, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

DeusRunStatsUi._create_ui_elements = function (arg_4_0)
	arg_4_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_0.widgets) do
		if iter_4_1 then
			local var_4_2 = UIWidget.init(iter_4_1)

			var_4_0[#var_4_0 + 1] = var_4_2
			var_4_1[iter_4_0] = var_4_2
		end
	end

	local var_4_3 = {}
	local var_4_4 = {}

	for iter_4_2, iter_4_3 in pairs(var_0_0.equipment_widgets) do
		if iter_4_3 then
			local var_4_5 = UIWidget.init(iter_4_3)

			var_4_3[#var_4_3 + 1] = var_4_5
			var_4_4[iter_4_2] = var_4_5
		end
	end

	local var_4_6 = {}
	local var_4_7 = {}

	for iter_4_4, iter_4_5 in pairs(var_0_2) do
		if iter_4_5 then
			local var_4_8 = UIWidget.init(iter_4_5)

			var_4_6[#var_4_6 + 1] = var_4_8
			var_4_7[iter_4_4] = var_4_8
		end
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1
	arg_4_0._reminder_widgets = var_4_6
	arg_4_0._reminder_widgets_by_name = var_4_7
	arg_4_0._equipment_widgets = var_4_3
	arg_4_0._equipment_widgets_by_name = var_4_4

	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_renderer)
	UIRenderer.clear_scenegraph_queue(arg_4_0._ui_top_renderer)

	arg_4_0._ui_animator = UIAnimator:new(arg_4_0._ui_scenegraph, var_0_1)

	local var_4_9 = arg_4_0._parent:input_service()

	arg_4_0._menu_input_description = MenuInputDescriptionUI:new(arg_4_0._ingame_ui_context, arg_4_0._ui_top_renderer, var_4_9, 6, nil, var_0_3.default, false)

	arg_4_0._menu_input_description:set_input_description(nil)
end

DeusRunStatsUi.update = function (arg_5_0, arg_5_1, arg_5_2)
	arg_5_0:_update_animations(arg_5_1, arg_5_2)
	arg_5_0:_handle_gamepad_input(arg_5_1, arg_5_2)
	arg_5_0:_handle_input(arg_5_1, arg_5_2)
	arg_5_0:_draw(arg_5_1, arg_5_2)
	arg_5_0:_draw_reminder(arg_5_1, arg_5_2)
end

DeusRunStatsUi._update_animations = function (arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._ui_animator:update(arg_6_1)

	local var_6_0 = arg_6_0._animations
	local var_6_1 = arg_6_0._ui_animator

	for iter_6_0, iter_6_1 in pairs(var_6_0) do
		if var_6_1:is_animation_completed(iter_6_1) then
			var_6_1:stop_animation(iter_6_1)

			var_6_0[iter_6_0] = nil
		end
	end

	local var_6_2 = arg_6_0._ui_animations

	for iter_6_2, iter_6_3 in pairs(var_6_2) do
		UIAnimation.update(iter_6_3, arg_6_1)

		if UIAnimation.completed(iter_6_3) then
			arg_6_0._ui_animations[iter_6_2] = nil
		end
	end

	if arg_6_0._ui_animations.move_scrollbar and arg_6_0._scrollbar_ui then
		arg_6_0._scrollbar_ui:force_update_progress(2)
	end
end

DeusRunStatsUi.lock = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._locked

	arg_7_0._locked = arg_7_1
	arg_7_0._widgets_by_name.fullscreen_fade.content.visible = arg_7_2

	local var_7_1 = Managers.input

	if not var_7_0 and arg_7_1 then
		ShowCursorStack.show("DeusRunStatsUi")
		var_7_1:block_device_except_service("deus_run_stats_view", "keyboard")
		var_7_1:block_device_except_service("deus_run_stats_view", "mouse")
		var_7_1:block_device_except_service("deus_run_stats_view", "gamepad")
	elseif var_7_0 and not arg_7_1 then
		ShowCursorStack.hide("DeusRunStatsUi")
		var_7_1:device_unblock_all_services("keyboard")
		var_7_1:device_unblock_all_services("mouse")
		var_7_1:device_unblock_all_services("gamepad")

		arg_7_0._gamepad_row_index = 1
		arg_7_0._gamepad_column_index = 1
	end
end

DeusRunStatsUi.locked = function (arg_8_0)
	return arg_8_0._locked
end

DeusRunStatsUi.set_active = function (arg_9_0, arg_9_1)
	if arg_9_1 ~= arg_9_0._active then
		Managers.state.event:trigger("ingame_player_list_enabled", arg_9_1)
	end

	arg_9_0._active = arg_9_1
end

DeusRunStatsUi.active = function (arg_10_0)
	return arg_10_0._active
end

DeusRunStatsUi._handle_input = function (arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0._active then
		return
	end

	local var_11_0 = arg_11_0._parent:input_service()
	local var_11_1 = Managers.input:is_device_active("gamepad")

	if not var_11_1 and var_11_0:get("hotkey_inventory", false) or var_11_0:get("toggle_menu") or var_11_0:get("back") then
		arg_11_0:lock(false)
	end

	local var_11_2 = arg_11_0._ui_scenegraph
	local var_11_3 = arg_11_0._power_up_widgets
	local var_11_4 = arg_11_0._widgets_by_name.power_up_description
	local var_11_5
	local var_11_6
	local var_11_7 = true

	for iter_11_0 = 1, #var_11_3 do
		local var_11_8 = arg_11_0._power_up_widgets[iter_11_0]
		local var_11_9 = math.ceil(iter_11_0 / 2)
		local var_11_10 = iter_11_0 % 2 == 0 and 2 or 1

		if UIUtils.is_button_hover(var_11_8) or var_11_1 and arg_11_0._gamepad_row_index == var_11_9 and arg_11_0._gamepad_column_index == var_11_10 then
			local var_11_11 = var_11_8.scenegraph_id
			local var_11_12 = UISceneGraph.get_world_position(var_11_2, var_11_11)
			local var_11_13 = var_11_8.offset

			var_11_2.power_up_description_root.local_position[1] = var_11_12[1] + var_11_13[1]
			var_11_2.power_up_description_root.local_position[2] = var_11_12[2] + var_11_13[2]
			var_11_5 = var_11_8.content.power_up_name
			var_11_6 = var_11_8.content.power_up_rarity

			local var_11_14 = var_11_8.content.locked
			local var_11_15 = var_11_8.content.locked_text_id
			local var_11_16 = var_11_4.content
			local var_11_17 = var_11_4.style

			var_11_16.visible = true
			var_11_16.locked = var_11_14
			var_11_16.locked_text_id = var_11_15 or var_11_16.locked_text_id

			if var_11_14 then
				var_11_16.end_time = nil
				var_11_16.progress = nil
				var_11_16.input_made = false
				var_11_17.remove_frame.color[1] = 0

				break
			end

			if var_0_4 then
				if var_11_0:get("mouse_middle_press") or var_11_0:get("special_1_press") then
					var_11_16.input_made = true
					var_11_17.remove_frame.color[1] = 0

					arg_11_0:_play_sound("Play_gui_boon_removal_start")

					break
				end

				if var_11_16.input_made and (var_11_0:get("mouse_middle_held") or var_11_0:get("special_1_hold")) then
					local var_11_18 = var_11_16.end_time or arg_11_2 + var_11_16.remove_interaction_duration
					local var_11_19 = (var_11_18 - arg_11_2) / var_11_16.remove_interaction_duration

					var_11_17.remove_frame.color[1] = 255 * (1 - var_11_19)

					if var_11_19 <= 0 then
						var_11_16.end_time = nil
						var_11_16.progress = nil
						var_11_16.input_made = false

						local var_11_20 = Managers.mechanism:game_mechanism():get_deus_run_controller()
						local var_11_21 = Managers.player:local_player():local_player_id()

						arg_11_0._force_update_power_ups = var_11_20:remove_power_ups(var_11_5, var_11_21)

						arg_11_0:_play_sound("Play_gui_boon_removal_end")

						break
					end

					var_11_16.end_time = var_11_18
					var_11_16.progress = var_11_19

					break
				end

				if var_11_16.input_made then
					arg_11_0:_play_sound("Stop_gui_boon_removal_start")
				end

				var_11_16.end_time = nil
				var_11_16.progress = nil
				var_11_16.input_made = false
				var_11_17.remove_frame.color[1] = 0
			end

			break
		end
	end

	if var_11_5 ~= arg_11_0._current_power_up_name then
		arg_11_0:_populate_power_up(var_11_5, var_11_6, var_11_4, var_11_7)
	end

	arg_11_0._current_power_up_name = var_11_5
end

local var_0_5 = {}

DeusRunStatsUi._handle_gamepad_input = function (arg_12_0, arg_12_1, arg_12_2)
	local var_12_0 = arg_12_0._gamepad_active
	local var_12_1 = Managers.input:is_device_active("gamepad")

	arg_12_0._gamepad_active = var_12_1

	if not var_12_1 or not arg_12_0._active then
		return
	end

	local var_12_2 = arg_12_0._parent:input_service()
	local var_12_3 = #arg_12_0._power_up_widgets
	local var_12_4 = 2

	table.clear(var_0_5)

	var_0_5[1] = math.ceil(var_12_3 / var_12_4)
	var_0_5[2] = math.floor(var_12_3 / var_12_4)

	local var_12_5 = arg_12_0._gamepad_row_index
	local var_12_6 = arg_12_0._gamepad_column_index

	if var_12_2:get("move_down_hold_continuous") then
		arg_12_0._gamepad_row_index = math.min(arg_12_0._gamepad_row_index + 1, var_0_5[arg_12_0._gamepad_column_index])
	elseif var_12_2:get("move_up_hold_continuous") then
		arg_12_0._gamepad_row_index = math.max(arg_12_0._gamepad_row_index - 1, 1)
	elseif var_12_2:get("move_right") then
		local var_12_7 = math.min(arg_12_0._gamepad_column_index + 1, var_12_4)

		if var_0_5[var_12_7] >= arg_12_0._gamepad_row_index then
			arg_12_0._gamepad_column_index = var_12_7
		end
	elseif var_12_2:get("move_left") then
		arg_12_0._gamepad_column_index = math.max(arg_12_0._gamepad_column_index - 1, 1)
	end

	if var_12_6 ~= arg_12_0._gamepad_column_index or var_12_5 ~= arg_12_0._gamepad_row_index or var_12_0 ~= var_12_1 then
		local var_12_8 = arg_12_0._ui_scenegraph.power_up_window.size[2]
		local var_12_9 = math.min(arg_12_0._gamepad_row_index + 3, var_0_5[1]) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
		local var_12_10 = math.max(var_12_9 - var_12_8, 0)

		arg_12_0._ui_animations.move_scrollbar = UIAnimation.init(UIAnimation.function_by_time, arg_12_0._ui_scenegraph.power_up_anchor.local_position, 2, arg_12_0._ui_scenegraph.power_up_anchor.local_position[2], var_12_10, 0.5, math.easeOutCubic)
	end
end

DeusRunStatsUi._populate_power_up = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4)
	if not arg_13_1 then
		arg_13_3.content.visible = false

		return
	end

	local var_13_0 = DeusPowerUps[arg_13_2][arg_13_1]
	local var_13_1 = arg_13_3.content
	local var_13_2 = Managers.player:local_player()
	local var_13_3 = var_13_2:profile_index()
	local var_13_4 = var_13_2:career_index()
	local var_13_5 = var_13_0.rarity

	var_13_1.title_text = DeusPowerUpUtils.get_power_up_name_text(var_13_0.name, var_13_0.talent_index, var_13_0.talent_tier, var_13_3, var_13_4)
	var_13_1.rarity_text = Localize(RaritySettings[var_13_5].display_name)
	var_13_1.description_text = DeusPowerUpUtils.get_power_up_description(var_13_0, var_13_3, var_13_4)
	var_13_1.icon = DeusPowerUpUtils.get_power_up_icon(var_13_0, var_13_3, var_13_4)
	var_13_1.extend_left = true
	var_13_1.is_rectangular_icon = DeusPowerUpTemplates[var_13_0.name].rectangular_icon

	local var_13_6 = arg_13_3.style
	local var_13_7 = Colors.get_table(var_13_5)

	var_13_6.rarity_text_left.text_color = var_13_7
	arg_13_3.content.visible = true

	local var_13_8 = DeusPowerUpSetLookup[var_13_5] and DeusPowerUpSetLookup[var_13_5][var_13_0.name]
	local var_13_9 = false

	if var_13_8 then
		local var_13_10 = var_13_8[1]
		local var_13_11 = 0
		local var_13_12 = var_13_10.pieces
		local var_13_13 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		for iter_13_0, iter_13_1 in ipairs(var_13_12) do
			local var_13_14 = iter_13_1.name
			local var_13_15 = iter_13_1.rarity
			local var_13_16 = var_13_13:get_own_peer_id()

			if var_13_13:has_power_up_by_name(var_13_16, var_13_14, var_13_15) then
				var_13_11 = var_13_11 + 1
			end
		end

		var_13_9 = true

		local var_13_17 = var_13_10.num_required_pieces or #var_13_12

		var_13_1.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), var_13_11, var_13_17)

		if #var_13_12 == var_13_11 then
			var_13_6.set_progression.text_color = var_13_6.set_progression.progression_colors.complete
		end
	end

	var_13_1.is_part_of_set = var_13_9
end

DeusRunStatsUi._draw_reminder = function (arg_14_0, arg_14_1, arg_14_2)
	if arg_14_0._active or table.size(arg_14_0._animations) == 0 then
		return
	end

	local var_14_0 = arg_14_0._ui_top_renderer
	local var_14_1 = arg_14_0._ui_scenegraph
	local var_14_2 = arg_14_0._render_settings
	local var_14_3 = arg_14_0._parent:input_service()

	UIRenderer.begin_pass(var_14_0, var_14_1, var_14_3, arg_14_1, nil, var_14_2)

	local var_14_4 = arg_14_0._reminder_widgets

	for iter_14_0 = 1, #var_14_4 do
		local var_14_5 = var_14_4[iter_14_0]

		UIRenderer.draw_widget(var_14_0, var_14_5)
	end

	UIRenderer.end_pass(var_14_0)
end

DeusRunStatsUi._draw = function (arg_15_0, arg_15_1, arg_15_2)
	if not arg_15_0._active then
		return
	end

	local var_15_0 = arg_15_0._ui_top_renderer
	local var_15_1 = arg_15_0._ui_scenegraph
	local var_15_2 = arg_15_0._render_settings
	local var_15_3 = arg_15_0._parent:input_service()

	UIRenderer.begin_pass(var_15_0, var_15_1, var_15_3, arg_15_1, nil, var_15_2)

	local var_15_4 = var_15_2.snap_pixel_positions
	local var_15_5 = arg_15_0._blessing_widgets

	for iter_15_0 = 1, #var_15_5 do
		local var_15_6 = var_15_5[iter_15_0]

		if var_15_6.snap_pixel_positions ~= nil then
			var_15_2.snap_pixel_positions = var_15_6.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_15_0, var_15_6)

		var_15_2.snap_pixel_positions = var_15_4
	end

	local var_15_7 = arg_15_0._power_up_widgets

	for iter_15_1 = 1, #var_15_7 do
		local var_15_8 = var_15_7[iter_15_1]

		if var_15_8.snap_pixel_positions ~= nil then
			var_15_2.snap_pixel_positions = var_15_8.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_15_0, var_15_8)

		var_15_2.snap_pixel_positions = var_15_4
	end

	local var_15_9 = arg_15_0._widgets

	for iter_15_2 = 1, #var_15_9 do
		local var_15_10 = var_15_9[iter_15_2]

		if var_15_10.snap_pixel_positions ~= nil then
			var_15_2.snap_pixel_positions = var_15_10.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_15_0, var_15_10)

		var_15_2.snap_pixel_positions = var_15_4
	end

	local var_15_11 = arg_15_0._equipment_widgets

	for iter_15_3 = 1, #var_15_11 do
		local var_15_12 = var_15_11[iter_15_3]

		if var_15_12.snap_pixel_positions ~= nil then
			var_15_2.snap_pixel_positions = var_15_12.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_15_0, var_15_12)

		var_15_2.snap_pixel_positions = var_15_4
	end

	UIRenderer.end_pass(var_15_0)

	if Managers.input:is_device_active("gamepad") then
		arg_15_0._menu_input_description:draw(arg_15_0._ui_top_renderer, arg_15_1)
	end

	if arg_15_0._scrollbar_ui then
		arg_15_0._scrollbar_ui:update(arg_15_1, arg_15_2, var_15_0, var_15_3, var_15_2)
	end
end

DeusRunStatsUi._play_sound = function (arg_16_0, arg_16_1)
	WwiseWorld.trigger_event(arg_16_0._wwise_world, arg_16_1)
end

DeusRunStatsUi.destroy = function (arg_17_0)
	arg_17_0:lock(false)
end

DeusRunStatsUi.update_dynamic_values = function (arg_18_0, arg_18_1)
	arg_18_0:_update_blessings(arg_18_1.blessings)
	arg_18_0:_update_power_ups(arg_18_1.party_power_ups, arg_18_1.power_ups, arg_18_1.profile_index, arg_18_1.career_index)

	arg_18_0._force_update_power_ups = false
end

DeusRunStatsUi.force_update_power_ups = function (arg_19_0)
	return arg_19_0._force_update_power_ups
end

DeusRunStatsUi._update_blessings = function (arg_20_0, arg_20_1)
	local var_20_0 = #arg_20_1 > 0

	arg_20_0._widgets_by_name.no_blessings_text.content.text = var_20_0 and "" or Localize("no_active_blessings_text")

	local var_20_1 = "blessing_"

	for iter_20_0, iter_20_1 in pairs(arg_20_0._widgets_by_name) do
		if string.starts_with(iter_20_0, var_20_1) then
			arg_20_0._widgets_by_name[iter_20_0] = nil
		end
	end

	local var_20_2 = {}

	if var_20_0 then
		local var_20_3 = var_0_0.blessing_widget_data
		local var_20_4 = math.min(#arg_20_1, var_20_3.max_blessing_amount)

		for iter_20_2 = 1, var_20_4 do
			local var_20_5 = arg_20_1[iter_20_2]
			local var_20_6 = DeusBlessingSettings[var_20_5]
			local var_20_7 = Localize(var_20_6.display_name)
			local var_20_8 = Localize(var_20_6.description)
			local var_20_9 = var_20_6.icon
			local var_20_10 = "blessing_" .. iter_20_2
			local var_20_11 = UIWidgets.create_framed_info_box(var_20_10, var_20_3.title_frame_name, var_20_3.info_frame_name, nil, nil, var_20_9, var_20_3.icon_size, var_20_3.icon_frame_name, var_20_7, var_20_8, var_20_3.bottom_panel_size)
			local var_20_12 = UIWidget.init(var_20_11)

			var_20_2[iter_20_2] = var_20_12
			arg_20_0._widgets_by_name[var_20_1 .. iter_20_2] = var_20_12
		end
	end

	arg_20_0._blessing_widgets = var_20_2
end

DeusRunStatsUi._update_power_ups = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = #arg_21_2 > 0 or #arg_21_1 > 0
	local var_21_1 = {}

	if var_21_0 then
		local var_21_2 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[arg_21_3].careers[arg_21_4].name]
		local var_21_3 = {}

		for iter_21_0 = 1, #var_21_2 do
			local var_21_4 = var_21_2[iter_21_0]

			if var_21_4 ~= 0 then
				local var_21_5, var_21_6 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(iter_21_0, var_21_4)

				var_21_3[var_21_5.name] = true
			end
		end

		local var_21_7 = RaritySettings

		table.sort(arg_21_2, function (arg_22_0, arg_22_1)
			local var_22_0 = var_21_7[arg_22_0.rarity].order
			local var_22_1 = var_21_7[arg_22_1.rarity].order

			if var_22_0 == var_22_1 then
				return arg_22_0.name < arg_22_1.name
			else
				return var_22_1 < var_22_0
			end
		end)

		local var_21_8 = DeusPowerUpTemplates
		local var_21_9 = #arg_21_2 + #arg_21_1

		for iter_21_1 = 1, var_21_9 do
			local var_21_10
			local var_21_11 = false

			if iter_21_1 <= #arg_21_2 then
				var_21_10 = arg_21_2[iter_21_1]
			else
				var_21_10 = arg_21_1[iter_21_1 - #arg_21_2]
				var_21_11 = true
			end

			local var_21_12 = DeusPowerUps[var_21_10.rarity][var_21_10.name]
			local var_21_13, var_21_14 = DeusPowerUpUtils.get_power_up_name_text(var_21_12.name, var_21_12.talent_index, var_21_12.talent_tier, arg_21_3, arg_21_4)
			local var_21_15 = DeusPowerUpUtils.get_power_up_icon(var_21_12, arg_21_3, arg_21_4)
			local var_21_16 = Colors.get_table(var_21_12.rarity)
			local var_21_17 = var_21_8[var_21_12.name].rectangular_icon
			local var_21_18 = var_21_17 and var_0_0.rectangular_power_up_widget_data or var_0_0.round_power_up_widget_data
			local var_21_19 = true
			local var_21_20 = true
			local var_21_21 = {
				color = {
					255,
					138,
					172,
					235
				},
				offset = var_0_0.rectangular_power_up_widget_data.icon_offset,
				texture_size = var_0_0.rectangular_power_up_widget_data.icon_size
			}
			local var_21_22 = "power_up_anchor"
			local var_21_23 = UIWidgets.create_icon_info_box(var_21_22, var_21_15, var_21_18.icon_size, var_21_18.icon_offset, var_21_18.background_icon, var_21_18.background_icon_size, var_21_18.background_icon_offset, var_21_14, var_21_13, var_21_16, var_21_18.width, var_21_17, var_21_19, var_21_20, var_21_21)
			local var_21_24 = UIWidget.init(var_21_23)

			var_21_24.content.power_up_name = var_21_12.name
			var_21_24.content.power_up_rarity = var_21_12.rarity
			var_21_24.content.locked = var_21_11 or var_21_3[var_21_12.name]
			var_21_24.content.locked_text_id = var_21_11 and "party_locked" or var_21_3[var_21_12.name] and "talent_locked" or "search_filter_locked"

			local var_21_25 = (iter_21_1 - 1) % 2

			var_21_24.offset[1] = var_21_25 * (var_0_0.power_up_widget_size[1] + var_0_0.power_up_widget_spacing[1])
			var_21_24.offset[2] = -math.floor((iter_21_1 - 1) / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
			var_21_1[#var_21_1 + 1] = var_21_24
			arg_21_0._widgets_by_name[var_21_22] = var_21_24
		end

		local var_21_26 = 2

		if var_21_9 < (arg_21_0._gamepad_row_index - 1) * var_21_26 + arg_21_0._gamepad_column_index then
			arg_21_0._gamepad_row_index = math.ceil(var_21_9 / var_21_26)
			arg_21_0._gamepad_column_index = var_21_26 - var_21_9 % var_21_26
		end

		if Managers.input:is_device_active("gamepad") then
			local var_21_27 = arg_21_0._ui_scenegraph.power_up_window.size[2]
			local var_21_28 = arg_21_0._gamepad_row_index * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2])
			local var_21_29 = math.max(var_21_28 - var_21_27, 0)

			arg_21_0._ui_animations.move_scrollbar = UIAnimation.init(UIAnimation.function_by_time, arg_21_0._ui_scenegraph.power_up_anchor.local_position, 2, arg_21_0._ui_scenegraph.power_up_anchor.local_position[2], var_21_29, 0.5, math.easeOutCubic)
		end

		local var_21_30 = math.ceil(var_21_9 / 2) * (var_0_0.power_up_widget_size[2] + var_0_0.power_up_widget_spacing[2]) - arg_21_0._ui_scenegraph.power_up_window.size[2]

		if var_21_30 > 0 then
			local var_21_31 = arg_21_0._ui_scenegraph
			local var_21_32 = "power_up_anchor"
			local var_21_33 = "power_up_window"
			local var_21_34 = var_21_30
			local var_21_35 = false
			local var_21_36
			local var_21_37
			local var_21_38 = false

			arg_21_0._scrollbar_ui = ScrollbarUI:new(var_21_31, var_21_32, var_21_33, var_21_34, var_21_35, var_21_36, var_21_37, var_21_38)

			arg_21_0._scrollbar_ui:disable_gamepad_input(true)
		else
			arg_21_0._scrollbar_ui = nil
		end
	end

	arg_21_0._power_up_widgets = var_21_1
	arg_21_0._power_ups = arg_21_2
	arg_21_0._party_power_ups = arg_21_1
end

DeusRunStatsUi.set_loadout = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
	arg_23_0._equipment_widgets_by_name.weapon_melee.content.item = arg_23_1
	arg_23_0._equipment_widgets_by_name.weapon_ranged.content.item = arg_23_2

	local var_23_0 = arg_23_0._equipment_widgets_by_name.healing_slot
	local var_23_1 = arg_23_0._equipment_widgets_by_name.potion_slot
	local var_23_2 = arg_23_0._equipment_widgets_by_name.grenade_slot
	local var_23_3 = arg_23_3 and ItemMasterList[arg_23_3]

	var_23_0.content.icon = var_23_3 and var_23_3.hud_icon or "consumables_empty_medpack"
	var_23_0.content.title_text = var_23_3 and Localize(arg_23_3) or Localize("deus_weapon_inspect_title_unavailable")
	var_23_0.content.info_text = var_23_3 and Localize(var_23_3.description) or Localize("deus_weapon_inspect_info_unavailable")
	var_23_0.content.visible = var_23_3 ~= nil

	local var_23_4 = arg_23_4 and ItemMasterList[arg_23_4]
	local var_23_5 = "consumables_empty_potion"
	local var_23_6 = Localize("deus_weapon_inspect_title_unavailable")
	local var_23_7 = Localize("deus_weapon_inspect_info_unavailable")

	if var_23_4 then
		var_23_5 = var_23_4.hud_icon or var_23_5
		var_23_6 = Localize(arg_23_4)
		var_23_7 = UIUtils.format_localized_description(var_23_4.description, var_23_4.description_values)
	end

	var_23_1.content.icon = var_23_5
	var_23_1.content.title_text = var_23_6
	var_23_1.content.info_text = var_23_7
	var_23_1.content.visible = var_23_4 ~= nil

	local var_23_8 = arg_23_5 and ItemMasterList[arg_23_5]

	var_23_2.content.icon = var_23_8 and var_23_8.hud_icon or "consumables_empty_grenade"
	var_23_2.content.title_text = var_23_8 and Localize(arg_23_5) or Localize("deus_weapon_inspect_title_unavailable")
	var_23_2.content.info_text = var_23_8 and Localize(var_23_8.description) or Localize("deus_weapon_inspect_info_unavailable")
	var_23_2.content.visible = var_23_8 ~= nil
end

DeusRunStatsUi._create_player_portrait = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3)
	local var_24_0 = UIWidgets.create_portrait_frame("player_portrait", arg_24_1, arg_24_3, 1, nil, arg_24_2)
	local var_24_1 = UIWidget.init(var_24_0, arg_24_0._ui_top_renderer)

	table.insert(arg_24_0._widgets, var_24_1)

	arg_24_0._widgets_by_name.player_portrait = var_24_1
end

DeusRunStatsUi._set_widget_text = function (arg_25_0, arg_25_1, arg_25_2)
	arg_25_0._widgets_by_name[arg_25_1].content.text = arg_25_2
end
