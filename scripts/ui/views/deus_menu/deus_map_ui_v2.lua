-- chunkname: @scripts/ui/views/deus_menu/deus_map_ui_v2.lua

require("scripts/helpers/ui_atlas_helper")

DeusMapUI = class(DeusMapUI)

local var_0_0 = 1
local var_0_1 = local_require("scripts/ui/views/deus_menu/deus_map_ui_definitions_v2")
local var_0_2 = var_0_1.allow_boon_removal

DeusMapUI.init = function (arg_1_0, arg_1_1)
	arg_1_0._context = arg_1_1
	arg_1_0._ui_renderer = arg_1_1.ui_renderer
	arg_1_0._render_content = false
	arg_1_0._render_full_screen_rect = false
	arg_1_0._deus_run_controller = arg_1_1.deus_run_controller
	arg_1_0._wwise_world = arg_1_1.wwise_world

	arg_1_0:_create_ui_elements()
	Managers.state.event:register(arg_1_0, "ingame_player_list_enabled", "event_ingame_player_list_enabled")
end

DeusMapUI.event_ingame_player_list_enabled = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = arg_2_0._widgets_by_name.console_cursor.content

	if arg_2_1 then
		var_2_0.visible = false

		if not arg_2_2 then
			Managers.input:disable_gamepad_cursor()
		end
	else
		var_2_0.visible = true

		Managers.input:enable_gamepad_cursor()
	end
end

DeusMapUI._create_ui_elements = function (arg_3_0)
	local var_3_0 = var_0_1.scenegraph_definition
	local var_3_1 = UISceneGraph.init_scenegraph(var_3_0)

	arg_3_0._ui_animator = UIAnimator:new(var_3_1, var_0_1.animations_definitions)

	local var_3_2, var_3_3 = UIUtils.create_widgets(var_0_1.widget_definitions)
	local var_3_4 = {
		alpha_multiplier = 1,
		snap_pixel_positions = false
	}
	local var_3_5 = {
		alpha_multiplier = 1
	}
	local var_3_6 = table.shallow_copy(arg_3_0._deus_run_controller:get_peers(), true)
	local var_3_7 = table.index_of(var_3_6, Network.peer_id())

	if var_3_7 > 0 then
		table.remove(var_3_6, var_3_7)
	end

	table.insert(var_3_6, 1, Network.peer_id())

	local var_3_8 = {}
	local var_3_9 = {}

	for iter_3_0 = 1, 4 do
		local var_3_10 = "player_portrait_frame_" .. iter_3_0
		local var_3_11
		local var_3_12
		local var_3_13 = "player_insignia_" .. iter_3_0
		local var_3_14
		local var_3_15

		if var_3_6[iter_3_0] then
			local var_3_16, var_3_17 = arg_3_0._deus_run_controller:get_player_profile(var_3_6[iter_3_0], var_0_0)
			local var_3_18 = arg_3_0._deus_run_controller:get_player_level(var_3_6[iter_3_0], var_3_16) or "-"
			local var_3_19 = arg_3_0._deus_run_controller:get_player_frame(var_3_6[iter_3_0], var_3_16, var_3_17)

			var_3_11 = UIWidgets.deus_create_player_portraits_frame("player_" .. iter_3_0 .. "_portrait", var_3_19, var_3_18, false)

			local var_3_20 = arg_3_0._deus_run_controller:get_versus_player_level(var_3_6[iter_3_0])

			var_3_14 = UIWidgets.create_small_insignia("player_" .. iter_3_0 .. "_insignia", var_3_20)

			local var_3_21 = arg_3_0._deus_run_controller:get_server_peer_id()

			if var_3_6[iter_3_0] == var_3_21 then
				local var_3_22 = UIWidgets.create_simple_texture("host_icon", "player_" .. iter_3_0 .. "_portrait", nil, nil, nil, {
					-60,
					-8,
					50
				}, {
					40,
					40
				})
				local var_3_23 = UIWidget.init(var_3_22)

				var_3_3.host_icon = var_3_23
				var_3_2[#var_3_2 + 1] = var_3_23
			end
		else
			var_3_11 = UIWidgets.deus_create_player_portraits_frame("player_" .. iter_3_0 .. "_portrait", "default", " ", false)
			var_3_14 = UIWidgets.create_small_insignia("player_" .. iter_3_0 .. "_insignia", 0)
		end

		local var_3_24 = UIWidget.init(var_3_11)

		var_3_8[#var_3_8 + 1] = var_3_24
		var_3_3[var_3_10] = var_3_24
		var_3_2[#var_3_2 + 1] = var_3_24

		local var_3_25 = UIWidget.init(var_3_14)

		var_3_9[#var_3_9 + 1] = var_3_25
		var_3_3[var_3_13] = var_3_24
	end

	arg_3_0._portrait_frame_widgets = var_3_8
	arg_3_0._insignia_widgets = var_3_9
	arg_3_0._ui_scenegraph = var_3_1
	arg_3_0._widgets_by_name = var_3_3
	arg_3_0._widgets = var_3_2
	arg_3_0._anim_data = var_3_5
	arg_3_0._render_settings = var_3_4
	arg_3_0._portrait_mode = true

	UIRenderer.clear_scenegraph_queue(arg_3_0._ui_renderer)

	arg_3_0._total_num_power_ups = nil

	arg_3_0:_update_power_ups()
end

DeusMapUI.on_enter = function (arg_4_0, arg_4_1)
	arg_4_0._input_service = arg_4_1
end

DeusMapUI.on_exit = function (arg_5_0)
	return
end

DeusMapUI._play_sound = function (arg_6_0, arg_6_1)
	WwiseWorld.trigger_event(arg_6_0._wwise_world, arg_6_1)
end

DeusMapUI.update = function (arg_7_0, arg_7_1, arg_7_2)
	if RESOLUTION_LOOKUP.modified then
		arg_7_0:_on_resolution_changed()
	end

	arg_7_0:_update_animations(arg_7_1, arg_7_2)
	arg_7_0:_update_power_ups()
	arg_7_0:_handle_mode_input(arg_7_1, arg_7_2)
	arg_7_0:_handle_owned_power_up_input(arg_7_1, arg_7_2)
	arg_7_0:_update_input_helper_text(arg_7_1, arg_7_2)
	arg_7_0:_draw(arg_7_1, arg_7_2)
end

DeusMapUI._update_input_helper_text = function (arg_8_0)
	local var_8_0 = 0.5 + math.sin(Managers.time:time("ui") * 5) * 0.5
	local var_8_1 = arg_8_0._widgets_by_name
	local var_8_2 = var_8_1.portrait_input_helper_text
	local var_8_3 = var_8_2.style.text
	local var_8_4 = var_8_1.boon_input_helper_text
	local var_8_5 = var_8_4.style.text

	var_8_3.text_color[1] = 100 + 155 * var_8_0
	var_8_5.text_color[1] = 100 + 155 * var_8_0
	var_8_2.content.visible = not arg_8_0._portrait_mode
	var_8_4.content.visible = arg_8_0._portrait_mode
end

DeusMapUI._handle_owned_power_up_input = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_0._ui_scenegraph
	local var_9_1 = arg_9_0._input_service
	local var_9_2 = arg_9_0._power_up_widgets
	local var_9_3 = arg_9_0._widgets_by_name.power_up_description
	local var_9_4
	local var_9_5

	if arg_9_0._portrait_mode or not var_0_2 then
		var_9_3.content.visible = false
		arg_9_0._current_power_up_name = nil

		return
	end

	local var_9_6 = var_9_3.content
	local var_9_7 = var_9_3.style
	local var_9_8 = false

	for iter_9_0 = 1, #var_9_2 do
		local var_9_9 = var_9_2[iter_9_0]

		if UIUtils.is_button_hover(var_9_9) then
			local var_9_10 = var_9_9.scenegraph_id
			local var_9_11 = UISceneGraph.get_world_position(var_9_0, var_9_10)
			local var_9_12 = var_9_9.offset

			var_9_0.power_up_description_root.local_position[1] = var_9_11[1] + var_9_12[1]
			var_9_0.power_up_description_root.local_position[2] = var_9_11[2] + var_9_12[2]
			var_9_4 = var_9_9.content.power_up_name
			var_9_5 = var_9_9.content.power_up_rarity

			local var_9_13 = var_9_9.content.locked
			local var_9_14 = var_9_9.content.locked_text_id

			var_9_6.visible = true
			var_9_6.locked = var_9_13
			var_9_6.locked_text_id = var_9_14 or var_9_6.locked_text_id
			var_9_8 = true

			if var_9_13 then
				var_9_6.end_time = nil
				var_9_6.progress = nil
				var_9_6.input_made = false
				var_9_7.remove_frame.color[1] = 0

				break
			end

			if var_9_1:get("mouse_middle_press") or var_9_1:get("special_1_press") then
				var_9_6.input_made = true
				var_9_7.remove_frame.color[1] = 0

				arg_9_0:_play_sound("Play_gui_boon_removal_start")

				break
			end

			if var_9_6.input_made and (var_9_1:get("mouse_middle_held") or var_9_1:get("special_1_hold")) then
				local var_9_15 = var_9_6.end_time or arg_9_2 + var_9_6.remove_interaction_duration
				local var_9_16 = (var_9_15 - arg_9_2) / var_9_6.remove_interaction_duration

				var_9_7.remove_frame.color[1] = 255 * (1 - var_9_16)

				if var_9_16 <= 0 then
					var_9_6.end_time = nil
					var_9_6.progress = nil
					var_9_6.input_made = false

					local var_9_17 = Managers.mechanism:game_mechanism():get_deus_run_controller()
					local var_9_18 = Managers.player:local_player():local_player_id()

					arg_9_0._force_update_power_ups = var_9_17:remove_power_ups(var_9_4, var_9_18)

					arg_9_0:_play_sound("Play_gui_boon_removal_end")

					break
				end

				var_9_6.end_time = var_9_15
				var_9_6.progress = var_9_16

				break
			end

			if var_9_6.input_made then
				arg_9_0:_play_sound("Stop_gui_boon_removal_start")
			end

			var_9_6.end_time = nil
			var_9_6.progress = nil
			var_9_6.input_made = false
			var_9_7.remove_frame.color[1] = 0

			break
		end
	end

	if not var_9_8 then
		var_9_6.end_time = nil
		var_9_6.progress = nil
		var_9_6.input_made = false
		var_9_7.remove_frame.color[1] = 0
	end

	if var_9_4 ~= arg_9_0._current_power_up_name then
		arg_9_0:_populate_power_up(var_9_4, var_9_5, var_9_3)
	end

	arg_9_0._current_power_up_name = var_9_4
end

DeusMapUI._populate_power_up = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if not arg_10_1 then
		arg_10_3.content.visible = false

		return
	end

	local var_10_0 = DeusPowerUps[arg_10_2][arg_10_1]
	local var_10_1 = arg_10_3.content
	local var_10_2 = Managers.player:local_player()
	local var_10_3 = var_10_2:profile_index()
	local var_10_4 = var_10_2:career_index()
	local var_10_5 = var_10_0.rarity

	var_10_1.title_text = DeusPowerUpUtils.get_power_up_name_text(var_10_0.name, var_10_0.talent_index, var_10_0.talent_tier, var_10_3, var_10_4)
	var_10_1.rarity_text = Localize(RaritySettings[var_10_5].display_name)
	var_10_1.description_text = DeusPowerUpUtils.get_power_up_description(var_10_0, var_10_3, var_10_4)
	var_10_1.icon = DeusPowerUpUtils.get_power_up_icon(var_10_0, var_10_3, var_10_4)
	var_10_1.extend_left = false
	var_10_1.is_rectangular_icon = DeusPowerUpTemplates[var_10_0.name].rectangular_icon

	local var_10_6 = arg_10_3.style
	local var_10_7 = Colors.get_table(var_10_5)

	var_10_6.rarity_text.text_color = var_10_7
	arg_10_3.content.visible = true

	local var_10_8 = DeusPowerUpSetLookup[var_10_5] and DeusPowerUpSetLookup[var_10_5][var_10_0.name]
	local var_10_9 = false

	if var_10_8 then
		local var_10_10 = var_10_8[1]
		local var_10_11 = 0
		local var_10_12 = var_10_10.pieces
		local var_10_13 = Managers.mechanism:game_mechanism():get_deus_run_controller()

		for iter_10_0, iter_10_1 in ipairs(var_10_12) do
			local var_10_14 = iter_10_1.name
			local var_10_15 = iter_10_1.rarity
			local var_10_16 = var_10_13:get_own_peer_id()

			if var_10_13:has_power_up_by_name(var_10_16, var_10_14, var_10_15) then
				var_10_11 = var_10_11 + 1
			end
		end

		var_10_9 = true

		local var_10_17 = var_10_10.num_required_pieces or #var_10_12

		var_10_1.set_progression = Localize("set_bonus_boons") .. " " .. string.format(Localize("set_counter_boons"), var_10_11, var_10_17)

		if #var_10_12 == var_10_11 then
			var_10_6.set_progression.text_color = var_10_6.set_progression.progression_colors.complete
		end
	end

	var_10_1.is_part_of_set = var_10_9
end

local var_0_3 = {}

DeusMapUI._update_power_ups = function (arg_11_0)
	local var_11_0 = arg_11_0._deus_run_controller
	local var_11_1 = var_11_0:get_own_peer_id()
	local var_11_2, var_11_3 = var_11_0:get_player_profile(var_11_1, var_0_0)
	local var_11_4 = var_11_0:get_party_power_ups()
	local var_11_5 = var_0_3
	local var_11_6 = 0
	local var_11_7 = arg_11_0._power_up_widgets or {}

	if var_11_2 ~= 0 and var_11_3 ~= 0 then
		local var_11_8 = var_11_0:get_player_power_ups(var_11_1, var_0_0)
		local var_11_9 = #var_11_8 + #var_11_4

		if var_11_9 ~= arg_11_0._total_num_power_ups then
			table.clear(var_11_7)

			if var_11_9 > 0 then
				local var_11_10 = Managers.mechanism:game_mechanism():get_deus_run_controller():get_own_initial_talents()[SPProfiles[var_11_2].careers[var_11_3].name]
				local var_11_11 = {}

				for iter_11_0 = 1, #var_11_10 do
					local var_11_12 = var_11_10[iter_11_0]

					if var_11_12 ~= 0 then
						local var_11_13, var_11_14 = DeusPowerUpUtils.get_talent_power_up_from_tier_and_column(iter_11_0, var_11_12)

						var_11_11[var_11_13.name] = true
					end
				end

				local var_11_15 = RaritySettings

				table.sort(var_11_8, function (arg_12_0, arg_12_1)
					local var_12_0 = var_11_15[arg_12_0.rarity].order
					local var_12_1 = var_11_15[arg_12_1.rarity].order

					if var_12_0 == var_12_1 then
						return arg_12_0.name < arg_12_1.name
					else
						return var_12_1 < var_12_0
					end
				end)

				local var_11_16 = DeusPowerUpTemplates
				local var_11_17 = #var_11_8 + #var_11_4

				for iter_11_1 = 1, var_11_17 do
					local var_11_18
					local var_11_19 = false

					if iter_11_1 <= #var_11_8 then
						var_11_18 = var_11_8[iter_11_1]
					else
						var_11_18 = var_11_4[iter_11_1 - #var_11_8]
						var_11_19 = true
					end

					local var_11_20 = DeusPowerUps[var_11_18.rarity][var_11_18.name]
					local var_11_21, var_11_22 = DeusPowerUpUtils.get_power_up_name_text(var_11_20.name, var_11_20.talent_index, var_11_20.talent_tier, var_11_2, var_11_3)
					local var_11_23 = DeusPowerUpUtils.get_power_up_icon(var_11_20, var_11_2, var_11_3)
					local var_11_24 = Colors.get_table(var_11_20.rarity)
					local var_11_25 = var_11_16[var_11_20.name].rectangular_icon
					local var_11_26 = var_11_25 and var_0_1.rectangular_power_up_widget_data or var_0_1.round_power_up_widget_data
					local var_11_27 = true
					local var_11_28 = true
					local var_11_29 = {
						color = {
							255,
							138,
							172,
							235
						},
						offset = var_0_1.rectangular_power_up_widget_data.icon_offset,
						texture_size = var_0_1.rectangular_power_up_widget_data.icon_size
					}
					local var_11_30 = "own_power_up_anchor"
					local var_11_31 = UIWidgets.create_icon_info_box(var_11_30, var_11_23, var_11_26.icon_size, var_11_26.icon_offset, var_11_26.background_icon, var_11_26.background_icon_size, var_11_26.background_icon_offset, var_11_22, var_11_21, var_11_24, var_11_26.width, var_11_25, var_11_27, var_11_28, var_11_29)
					local var_11_32 = UIWidget.init(var_11_31)

					var_11_32.content.power_up_name = var_11_20.name
					var_11_32.content.power_up_rarity = var_11_20.rarity
					var_11_32.content.locked = var_11_19 or var_11_11[var_11_20.name]
					var_11_32.content.locked_text_id = var_11_19 and "party_locked" or var_11_11[var_11_20.name] and "talent_locked" or "search_filter_locked"

					local var_11_33 = (iter_11_1 - 1) % 2

					var_11_32.offset[1] = var_11_33 * (var_0_1.power_up_widget_size[1] + var_0_1.power_up_widget_spacing[1])
					var_11_32.offset[2] = -math.floor((iter_11_1 - 1) / 2) * (var_0_1.power_up_widget_size[2] + var_0_1.power_up_widget_spacing[2])
					var_11_7[#var_11_7 + 1] = var_11_32
					arg_11_0._widgets_by_name[var_11_30] = var_11_32
				end
			end

			arg_11_0._total_num_power_ups = var_11_9
			arg_11_0._power_up_widgets = var_11_7
			arg_11_0._power_ups = var_11_8
			arg_11_0._party_power_ups = var_11_4

			local var_11_34 = math.ceil(arg_11_0._total_num_power_ups / 2) * (var_0_1.power_up_widget_size[2] + var_0_1.power_up_widget_spacing[2]) - arg_11_0._ui_scenegraph.own_power_up_window.size[2]

			if var_11_34 > 0 then
				local var_11_35 = arg_11_0._ui_scenegraph
				local var_11_36 = "own_power_up_anchor"
				local var_11_37 = "own_power_up_window"
				local var_11_38 = var_11_34
				local var_11_39 = false
				local var_11_40
				local var_11_41
				local var_11_42 = true

				arg_11_0._scrollbar_ui = ScrollbarUI:new(var_11_35, var_11_36, var_11_37, var_11_38, var_11_39, var_11_40, var_11_41, var_11_42)
			else
				arg_11_0._scrollbar_ui = nil
			end
		end
	end
end

DeusMapUI._handle_mode_input = function (arg_13_0, arg_13_1, arg_13_2)
	if arg_13_0._input_service:get("cycle_next_raw") then
		if not arg_13_0._ui_animator:is_animation_completed(arg_13_0._anim_id) then
			arg_13_0._ui_animator:stop_animation(arg_13_0._anim_id)
		end

		arg_13_0._anim_id = arg_13_0._ui_animator:start_animation(arg_13_0._portrait_mode and "switch_to_boons" or "switch_to_portraits", arg_13_0._widgets_by_name, var_0_1.scenegraph_definition)
		arg_13_0._portrait_mode = not arg_13_0._portrait_mode
	end
end

DeusMapUI._update_animations = function (arg_14_0, arg_14_1, arg_14_2)
	arg_14_0._ui_animator:update(arg_14_1)

	local var_14_0 = arg_14_0._anim_data

	if not var_14_0.alpha_multiplier_animation_duration then
		return
	end

	if not var_14_0.alpha_multiplier_animation_start_time then
		var_14_0.alpha_multiplier_animation_start_time = arg_14_2
		var_14_0.alpha_multiplier_animation_end_time = arg_14_2 + var_14_0.alpha_multiplier_animation_duration
	end

	local var_14_1
	local var_14_2 = var_14_0.alpha_multiplier_animation_end_time - var_14_0.alpha_multiplier_animation_start_time
	local var_14_3 = var_14_2 <= 0.001 and 1 or math.clamp((arg_14_2 - var_14_0.alpha_multiplier_animation_start_time) / var_14_2, 0, 1)

	var_14_0.alpha_multiplier = math.lerp(var_14_0.source_alpha_multiplier, var_14_0.target_alpha_multiplier, var_14_3)

	if var_14_3 == 1 then
		var_14_0.alpha_multiplier_animation_duration = nil
		var_14_0.alpha_multiplier_animation_start_time = nil
		var_14_0.alpha_multiplier_animation_end_time = nil
		var_14_0.source_alpha_multiplier = nil
		var_14_0.target_alpha_multiplier = nil
	end
end

DeusMapUI._draw = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._input_service
	local var_15_1 = arg_15_0._ui_renderer
	local var_15_2 = arg_15_0._ui_scenegraph
	local var_15_3 = arg_15_0._render_settings
	local var_15_4 = arg_15_0._anim_data
	local var_15_5

	UIRenderer.begin_pass(var_15_1, var_15_2, var_15_0, arg_15_1, var_15_5, var_15_3)

	var_15_3.alpha_multiplier = var_15_4.alpha_multiplier or 0

	if arg_15_0._render_full_screen_rect then
		UIRenderer.draw_rect(var_15_1, Vector2(0, 0), UISceneGraph.get_size_scaled(var_15_2, "screen"), Colors.color_definitions.black)
	end

	if arg_15_0._render_content then
		UIRenderer.draw_all_widgets(var_15_1, arg_15_0._widgets)
	end

	var_15_3.alpha_multiplier = 1

	arg_15_0:_draw_boons(arg_15_1, arg_15_2)
	UIRenderer.end_pass(var_15_1)

	if arg_15_0._scrollbar_ui and not arg_15_0._portrait_mode then
		arg_15_0._scrollbar_ui:update(arg_15_1, arg_15_2, var_15_1, var_15_0, var_15_3)
	end
end

DeusMapUI._draw_boons = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0._ui_scenegraph
	local var_16_1 = arg_16_0._ui_renderer
	local var_16_2 = "own_power_up_anchor"
	local var_16_3 = "own_power_up_window"
	local var_16_4 = UISceneGraph.get_world_position(var_16_0, var_16_2)
	local var_16_5 = UISceneGraph.get_world_position(var_16_0, var_16_3)
	local var_16_6 = var_16_0[var_16_3].size[2]
	local var_16_7 = arg_16_0._power_up_widgets

	for iter_16_0 = 1, #var_16_7 do
		local var_16_8 = var_16_7[iter_16_0]
		local var_16_9 = var_16_8.content.hotspot
		local var_16_10 = var_16_8.offset
		local var_16_11 = var_16_4[2] + var_16_10[2]
		local var_16_12 = var_0_1.power_up_widget_size[2]

		if var_16_11 > var_16_5[2] + var_16_6 then
			table.clear(var_16_9)
		elseif var_16_11 + var_16_12 < var_16_5[2] then
			table.clear(var_16_9)

			break
		else
			UIRenderer.draw_widget(var_16_1, var_16_8)
		end
	end
end

DeusMapUI.enable_hover_text = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5, arg_17_6, arg_17_7, arg_17_8, arg_17_9, arg_17_10, arg_17_11, arg_17_12, arg_17_13)
	local var_17_0 = UIInverseScaleVectorToResolution(arg_17_1)
	local var_17_1 = arg_17_0._ui_scenegraph.node_info_pivot.position

	var_17_1[1] = var_17_0[1]
	var_17_1[2] = var_17_0[2]

	local var_17_2 = arg_17_0._widgets_by_name.node_info

	var_17_2.content.visible = true

	local var_17_3 = var_17_2.content.node_info

	if arg_17_3 then
		var_17_3.none_modifier_info.title = Localize(arg_17_3 .. "_title")
		var_17_3.none_modifier_info.description = Localize(arg_17_3 .. "_desc")
	else
		var_17_3.none_modifier_info.title = Localize("undiscovered_level_title")
		var_17_3.none_modifier_info.description = Localize("undiscovered_level_desc")
	end

	if not arg_17_4 or arg_17_4 == "wastes" then
		var_17_3.curse_text = ""
	else
		var_17_3.curse_text = Localize("deus_map_node_info_god_" .. arg_17_4)
		var_17_3.curse_icon = "deus_icons_map_" .. arg_17_4
		var_17_2.style.node_info.curse_section.curse_icon.color = Colors.get_color_table_with_alpha(arg_17_4, 255)
		var_17_2.style.node_info.curse_section.curse_text.text_color = Colors.get_color_table_with_alpha(arg_17_4, 255)
	end

	if arg_17_5 then
		var_17_3.minor_modifier_1_section.text = arg_17_5[1] and Localize("mutator_" .. arg_17_5[1] .. "_name") or ""
		var_17_3.minor_modifier_2_section.text = arg_17_5[2] and Localize("mutator_" .. arg_17_5[2] .. "_name") or ""
		var_17_3.minor_modifier_3_section.text = arg_17_5[3] and Localize("mutator_" .. arg_17_5[3] .. "_name") or ""
	else
		var_17_3.minor_modifier_1_section.text = ""
		var_17_3.minor_modifier_2_section.text = ""
		var_17_3.minor_modifier_3_section.text = ""
	end

	if arg_17_7 then
		local var_17_4 = DeusPowerUpTemplates[arg_17_7]
		local var_17_5 = DeusPowerUpUtils.get_power_up_name_text(arg_17_7, var_17_4.talent_index, var_17_4.talent_tier, arg_17_12, arg_17_13)
		local var_17_6 = Localize("terror_event_power_up_prefix_suffix")
		local var_17_7 = string.format(var_17_6, var_17_5)

		var_17_2.content.node_info.terror_event_power_up_text = var_17_7
		var_17_2.content.node_info.terror_event_power_up_icon = var_17_4.icon
	elseif arg_17_8 then
		if arg_17_8 > 1 then
			local var_17_8 = Localize("end_of_level_reward_hover_text_random_power_up_multiple")
			local var_17_9 = RaritySettings[arg_17_9]
			local var_17_10 = Localize(var_17_9.display_name)

			var_17_3.terror_event_power_up_text = string.format(var_17_8, arg_17_8, var_17_10)
		else
			local var_17_11 = Localize("end_of_level_reward_hover_text_random_power_up_singular")
			local var_17_12 = RaritySettings[arg_17_9]
			local var_17_13 = Localize(var_17_12.display_name)

			var_17_3.terror_event_power_up_text = string.format(var_17_11, var_17_13)
		end
	else
		var_17_3.terror_event_power_up_text = ""
	end

	var_17_3.shrine_text = ""

	local var_17_14 = ConflictDirectors[arg_17_6]
	local var_17_15 = var_17_14 and var_17_14.description

	if var_17_15 then
		var_17_3.breed_text = Localize(var_17_15) or ""
	else
		var_17_3.breed_text = ""
	end

	var_17_3.none_modifier_info.click_to_vote = arg_17_11 and "deus_map_node_info_click_to_vote" or ""
	var_17_3.frame_settings_name = arg_17_10 and "menu_frame_12_gold" or "menu_frame_12"
end

DeusMapUI._update_portrait_frame = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	local var_18_0 = UIWidgets.deus_create_player_portraits_frame("player_" .. arg_18_3 .. "_portrait", arg_18_1, arg_18_2, false)
	local var_18_1 = UIWidget.init(var_18_0)

	arg_18_0._portrait_frame_widgets[arg_18_3] = var_18_1
	arg_18_0._widgets_by_name["player_portrait_frame_" .. arg_18_3] = var_18_1
end

DeusMapUI._update_insignia = function (arg_19_0, arg_19_1, arg_19_2)
	local var_19_0 = UIWidgets.create_small_insignia("player_" .. arg_19_2 .. "_insignia", arg_19_1)
	local var_19_1 = UIWidget.init(var_19_0)

	arg_19_0._insignia_widgets[arg_19_2] = var_19_1
	arg_19_0._widgets_by_name["player_insignia_" .. arg_19_2] = var_19_1
end

DeusMapUI.update_player_data = function (arg_20_0, arg_20_1)
	arg_20_0._player_data = arg_20_1

	local var_20_0 = arg_20_0._widgets_by_name

	for iter_20_0 = 1, 4 do
		local var_20_1 = arg_20_1[iter_20_0]
		local var_20_2 = var_20_0["player_" .. iter_20_0 .. "_portrait"]
		local var_20_3 = var_20_0["player_" .. iter_20_0 .. "_texts"]
		local var_20_4 = var_20_0["player_portrait_frame_" .. iter_20_0]
		local var_20_5 = var_20_0["player_insignia_" .. iter_20_0]
		local var_20_6 = not not var_20_1

		var_20_2.content.visible = var_20_6
		var_20_3.content.visible = var_20_6
		var_20_4.content.visible = var_20_6

		if var_20_6 then
			local var_20_7 = var_20_1.frame or "default"
			local var_20_8 = var_20_1.level or "-"

			if var_20_4.content.frame_settings_name ~= var_20_7 or var_20_4.content.level ~= var_20_8 then
				arg_20_0:_update_portrait_frame(var_20_7, var_20_8, iter_20_0)

				var_20_4.content.level = var_20_8
			end

			local var_20_9 = var_20_1.versus_level

			if var_20_5.content.level ~= var_20_9 then
				arg_20_0:_update_insignia(var_20_9, iter_20_0)
			end

			var_20_3.content.name_text = var_20_1.name or ""
			var_20_2.content.show_token_icon = not var_20_1.vote

			if var_20_1.profile_index ~= 0 then
				local var_20_10 = SPProfiles[var_20_1.profile_index]
				local var_20_11 = var_20_10.careers[var_20_1.career_index]

				var_20_2.content.character_portrait = var_20_11.portrait_image
				var_20_2.content.token_icon = var_20_10.hero_selection_image
			else
				var_20_2.content.character_portrait = "unit_frame_portrait_default"
				var_20_2.content.token_icon = nil
			end

			var_20_2.content.hp_bar.bar_value = var_20_1.health_percentage
			var_20_2.content.ammo_percentage = var_20_1.ammo_percentage
			var_20_3.content.coins_text = string.format("%d", var_20_1.soft_currency)

			local var_20_12 = var_20_1.healthkit_consumable

			var_20_2.content.healthkit_slot = var_20_12 and ItemMasterList[var_20_12].hud_icon
			var_20_2.style.healthkit_slot_bg.color = UIUtils.get_color_for_consumable_item(var_20_12)

			local var_20_13 = var_20_1.potion_consumable

			var_20_2.content.potion_slot = var_20_13 and ItemMasterList[var_20_13].hud_icon
			var_20_2.style.potion_slot_bg.color = UIUtils.get_color_for_consumable_item(var_20_13)

			local var_20_14 = var_20_1.grenade_consumable

			var_20_2.content.grenade_slot = var_20_14 and ItemMasterList[var_20_14].hud_icon
			var_20_2.style.grenade_slot_bg.color = UIUtils.get_color_for_consumable_item(var_20_14)
		end
	end
end

DeusMapUI.set_journey_name = function (arg_21_0, arg_21_1)
	arg_21_0._widgets_by_name.top_info.content.journey_name_label = arg_21_1 .. "_name"
end

DeusMapUI.set_general_info = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0._widgets_by_name.general_info

	var_22_0.content.title = arg_22_1
	var_22_0.content.description = arg_22_2
end

DeusMapUI._on_resolution_changed = function (arg_23_0)
	local var_23_0 = arg_23_0._player_data

	if var_23_0 then
		arg_23_0:update_player_data(var_23_0)
	end
end

DeusMapUI.update_timer = function (arg_24_0, arg_24_1, arg_24_2)
	local var_24_0 = arg_24_0._widgets_by_name.general_info

	if arg_24_2 then
		var_24_0.content.time = arg_24_2
	else
		local var_24_1 = string.format("%.2d:%.2d", arg_24_1 / 60 % 60, arg_24_1 % 60)

		var_24_0.content.time = var_24_1
	end
end

DeusMapUI.hide_timer = function (arg_25_0)
	arg_25_0._widgets_by_name.general_info.content.time = ""
end

DeusMapUI.disable_hover_text = function (arg_26_0)
	arg_26_0._widgets_by_name.node_info.content.visible = false
end

DeusMapUI.set_alpha_multiplier = function (arg_27_0, arg_27_1)
	arg_27_0._anim_data.alpha_multiplier = arg_27_1
end

DeusMapUI.show_full_screen_rect = function (arg_28_0)
	return arg_28_0:set_full_screen_rect_visibility(true)
end

DeusMapUI.hide_full_screen_rect = function (arg_29_0)
	return arg_29_0:set_full_screen_rect_visibility(false)
end

DeusMapUI.set_full_screen_rect_visibility = function (arg_30_0, arg_30_1)
	arg_30_0._render_full_screen_rect = arg_30_1
end

DeusMapUI.show_content = function (arg_31_0)
	arg_31_0:_set_content_visibility(true)
end

DeusMapUI.hide_content = function (arg_32_0)
	arg_32_0:_set_content_visibility(false)
end

DeusMapUI._set_content_visibility = function (arg_33_0, arg_33_1)
	arg_33_0._render_content = arg_33_1

	local var_33_0 = arg_33_0._ui_renderer

	for iter_33_0, iter_33_1 in pairs(arg_33_0._widgets_by_name) do
		UIRenderer.set_element_visible(var_33_0, iter_33_1.element, arg_33_1)
	end
end

DeusMapUI.fade_out = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._anim_data

	var_34_0.source_alpha_multiplier = var_34_0.alpha_multiplier
	var_34_0.target_alpha_multiplier = 0
	var_34_0.alpha_multiplier_animation_duration = arg_34_1
	var_34_0.alpha_multiplier_animation_start_time = nil
	var_34_0.alpha_multiplier_animation_end_time = nil
end

DeusMapUI.fade_in = function (arg_35_0, arg_35_1)
	local var_35_0 = arg_35_0._anim_data

	var_35_0.source_alpha_multiplier = var_35_0.alpha_multiplier
	var_35_0.target_alpha_multiplier = 1
	var_35_0.alpha_multiplier_animation_duration = arg_35_1
	var_35_0.alpha_multiplier_animation_start_time = nil
	var_35_0.alpha_multiplier_animation_end_time = nil
end

DeusMapUI.destroy = function (arg_36_0)
	Managers.state.event:unregister("ingame_player_list_enabled", arg_36_0)
end
