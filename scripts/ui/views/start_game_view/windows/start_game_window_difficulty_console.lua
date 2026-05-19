-- chunkname: @scripts/ui/views/start_game_view/windows/start_game_window_difficulty_console.lua

local var_0_0 = local_require("scripts/ui/views/start_game_view/windows/definitions/start_game_window_difficulty_console_definitions")
local var_0_1 = var_0_0.widgets
local var_0_2 = var_0_0.scenegraph_definition
local var_0_3 = var_0_0.create_difficulty_button
local var_0_4 = var_0_0.animation_definitions
local var_0_5 = 1
local var_0_6 = "confirm_press"

StartGameWindowDifficultyConsole = class(StartGameWindowDifficultyConsole)
StartGameWindowDifficultyConsole.NAME = "StartGameWindowDifficultyConsole"

function StartGameWindowDifficultyConsole.on_enter(arg_1_0, arg_1_1, arg_1_2)
	print("[StartGameWindow] Enter Substate StartGameWindowDifficultyConsole")

	arg_1_0.parent = arg_1_1.parent

	local var_1_0 = arg_1_1.ingame_ui_context

	arg_1_0.ui_renderer = var_1_0.ui_renderer
	arg_1_0.ui_top_renderer = var_1_0.ui_top_renderer
	arg_1_0.input_manager = var_1_0.input_manager
	arg_1_0.statistics_db = var_1_0.statistics_db
	arg_1_0.render_settings = {
		snap_pixel_positions = true
	}

	local var_1_1 = Managers.player

	arg_1_0._stats_id = var_1_1:local_player():stats_id()
	arg_1_0.player_manager = var_1_1
	arg_1_0.peer_id = var_1_0.peer_id
	arg_1_0._animations = {}

	arg_1_0:create_ui_elements(arg_1_1, arg_1_2)
	arg_1_0:_setup_difficulties()

	local var_1_2 = arg_1_0:_verify_difficulty(arg_1_0.parent:get_difficulty_option() or Managers.state.difficulty:get_difficulty())

	arg_1_0:_update_selected_difficulty_option(var_1_2)

	if var_1_2 then
		arg_1_0._difficulty_navigation_id = arg_1_0:_get_difficulty_navigation_id_from_difficulty_key(var_1_2)
	else
		arg_1_0._difficulty_navigation_id = 1
	end

	arg_1_0:_start_transition_animation("on_enter")
end

function StartGameWindowDifficultyConsole._verify_difficulty(arg_2_0, arg_2_1)
	local var_2_0 = Managers.state.difficulty:get_default_difficulties()

	for iter_2_0, iter_2_1 in pairs(var_2_0) do
		if iter_2_1 == arg_2_1 then
			return arg_2_1
		end
	end

	Application.warning(string.format("Difficulty %q is not valid - Defaulting to %q", arg_2_1, var_2_0[1]))

	return var_2_0[1]
end

function StartGameWindowDifficultyConsole._start_transition_animation(arg_3_0, arg_3_1)
	local var_3_0 = {
		render_settings = arg_3_0.render_settings
	}
	local var_3_1 = {}
	local var_3_2 = arg_3_0.ui_animator:start_animation(arg_3_1, var_3_1, var_0_2, var_3_0)

	arg_3_0._animations[arg_3_1] = var_3_2
end

function StartGameWindowDifficultyConsole.create_ui_elements(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_2)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_1) do
		local var_4_2 = UIWidget.init(iter_4_1)

		var_4_0[#var_4_0 + 1] = var_4_2
		var_4_1[iter_4_0] = var_4_2
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)

	arg_4_0.ui_animator = UIAnimator:new(arg_4_0.ui_scenegraph, var_0_4)

	if arg_4_2 then
		local var_4_3 = arg_4_0.ui_scenegraph.window.local_position

		var_4_3[1] = var_4_3[1] + arg_4_2[1]
		var_4_3[2] = var_4_3[2] + arg_4_2[2]
		var_4_3[3] = var_4_3[3] + arg_4_2[3]
	end
end

function StartGameWindowDifficultyConsole._setup_difficulties(arg_5_0)
	local var_5_0 = {}
	local var_5_1 = {}
	local var_5_2 = arg_5_0:_get_difficulty_options()
	local var_5_3 = arg_5_0._widgets
	local var_5_4 = arg_5_0._widgets_by_name
	local var_5_5 = 1
	local var_5_6 = "difficulty_option_"
	local var_5_7 = 10
	local var_5_8 = "difficulty_option"
	local var_5_9 = var_0_2[var_5_8].size
	local var_5_10 = var_0_3(var_5_8, var_5_9)

	for iter_5_0 = var_0_5, #var_5_2 do
		local var_5_11 = var_5_2[iter_5_0]
		local var_5_12 = DifficultySettings[var_5_11]
		local var_5_13 = var_5_12.display_name
		local var_5_14 = var_5_12.display_image
		local var_5_15 = var_5_12.completed_frame_texture
		local var_5_16 = UIWidget.init(var_5_10)

		var_5_4[var_5_6 .. var_5_5] = var_5_16
		var_5_3[#var_5_3 + 1] = var_5_16
		var_5_0[#var_5_0 + 1] = var_5_16

		local var_5_17 = var_5_16.offset
		local var_5_18 = var_5_16.content

		var_5_18.difficulty_key = var_5_11
		var_5_18.title_text = Localize(var_5_13)
		var_5_18.icon = var_5_14
		var_5_18.difficulty_key = var_5_11
		var_5_18.text_title = Localize(var_5_13)
		var_5_18.icon_texture = var_5_14
		var_5_18.icon_frame_texture = var_5_15
		var_5_17[2] = -(var_5_9[2] + var_5_7) * (var_5_5 - 1)

		local var_5_19 = arg_5_0:_rewards_by_difficulty(var_5_11)
		local var_5_20 = #var_5_19

		for iter_5_1 = 1, var_5_20 do
			local var_5_21 = var_5_19[iter_5_1]
			local var_5_22 = var_0_0.create_difficulty_reward_widget(var_5_11, var_5_21, iter_5_1, var_5_20)
			local var_5_23 = UIWidget.init(var_5_22)

			var_5_4[string.format("reward_%s_%s", var_5_11, iter_5_1)] = var_5_23
			var_5_3[#var_5_3 + 1] = var_5_23
			var_5_1[#var_5_1 + 1] = var_5_23
		end

		var_5_5 = var_5_5 + 1
	end

	arg_5_0._difficulty_widgets = var_5_0
	arg_5_0._difficulty_reward_widgets = var_5_1
end

function StartGameWindowDifficultyConsole._rewards_by_difficulty(arg_6_0, arg_6_1)
	return LootChestData.chests_by_category[arg_6_1].backend_keys
end

function StartGameWindowDifficultyConsole._get_difficulty_options(arg_7_0)
	return Managers.state.difficulty:get_default_difficulties()
end

function StartGameWindowDifficultyConsole.on_exit(arg_8_0, arg_8_1)
	print("[StartGameWindow] Exit Substate StartGameWindowDifficultyConsole")

	arg_8_0.ui_animator = nil

	arg_8_0.parent:set_input_description(nil)
end

function StartGameWindowDifficultyConsole.update(arg_9_0, arg_9_1, arg_9_2)
	arg_9_0:_update_animations(arg_9_1)
	arg_9_0:_handle_input(arg_9_1, arg_9_2)
	arg_9_0:_update_difficulty_locks()
	arg_9_0:draw(arg_9_1)
end

function StartGameWindowDifficultyConsole.post_update(arg_10_0, arg_10_1, arg_10_2)
	return
end

function StartGameWindowDifficultyConsole._update_animations(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0.ui_animator

	arg_11_0.ui_animator:update(arg_11_1)

	local var_11_1 = arg_11_0._animations

	for iter_11_0, iter_11_1 in pairs(var_11_1) do
		if var_11_0:is_animation_completed(iter_11_1) then
			var_11_0:stop_animation(iter_11_1)

			var_11_1[iter_11_0] = nil
		end
	end
end

function StartGameWindowDifficultyConsole._is_button_pressed(arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.content.button_hotspot

	if var_12_0.on_pressed then
		var_12_0.on_pressed = false

		return true
	end
end

function StartGameWindowDifficultyConsole._is_button_hover_enter(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_1.content.button_hotspot

	return var_13_0.on_hover_enter and not var_13_0.is_selected
end

function StartGameWindowDifficultyConsole._handle_input(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0.parent:window_input_service()
	local var_14_1 = Managers.input:is_device_active("mouse")

	if not var_14_1 then
		if var_14_0:get("move_down_hold_continuous") then
			arg_14_0:_update_difficulty_selection(1)
		elseif var_14_0:get("move_up_hold_continuous") then
			arg_14_0:_update_difficulty_selection(-1)
		end
	end

	local var_14_2 = arg_14_0._difficulty_widgets

	for iter_14_0 = 1, #var_14_2 do
		local var_14_3 = var_14_2[iter_14_0]

		if not var_14_3.content.is_selected and arg_14_0:_is_button_hover_enter(var_14_3) then
			arg_14_0:_update_difficulty_selection(nil, iter_14_0)
		end

		if arg_14_0:_is_button_pressed(var_14_3) and arg_14_0._difficulty_approved then
			arg_14_0:_on_difficulty_selection_confirmed()

			return
		end
	end

	local var_14_4 = arg_14_0._widgets_by_name.buy_button

	UIWidgetUtils.animate_default_button(var_14_4, arg_14_1)

	if arg_14_0:_is_button_hover_enter(var_14_4) then
		arg_14_0:_play_sound("play_gui_lobby_button_01_difficulty_confirm_hover")
	end

	if arg_14_0:_is_button_released(var_14_4) then
		local var_14_5 = var_14_4.content.dlc_name
		local var_14_6 = AreaSettings[var_14_5].store_page_url

		arg_14_0:_show_storepage(var_14_6, var_14_5)
	end

	if not var_14_1 and var_14_0:get(var_0_6, true) then
		if arg_14_0._difficulty_approved then
			arg_14_0:_on_difficulty_selection_confirmed()
		elseif arg_14_0._dlc_locked then
			local var_14_7 = arg_14_0._dlc_locked
			local var_14_8 = AreaSettings[var_14_7].store_page_url

			arg_14_0:_show_storepage(var_14_8, var_14_7)
		end
	end
end

function StartGameWindowDifficultyConsole._on_difficulty_selection_confirmed(arg_15_0)
	local var_15_0 = arg_15_0.parent

	var_15_0:set_difficulty_option(arg_15_0._selected_difficulty_key)

	local var_15_1 = UISettings.difficulties_select_sounds
	local var_15_2 = var_15_1[arg_15_0._difficulty_navigation_id] or var_15_1[#var_15_1]

	arg_15_0:_play_sound(var_15_2)

	local var_15_3 = var_15_0:get_selected_game_mode_layout_name()

	var_15_0:set_layout_by_name(var_15_3)
end

function StartGameWindowDifficultyConsole._update_difficulty_selection(arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_0:_get_difficulty_options()

	if not arg_16_2 then
		arg_16_2 = arg_16_0._difficulty_navigation_id + arg_16_1

		local var_16_1 = #var_16_0

		arg_16_2 = math.clamp(arg_16_2, 1, var_16_1)
	end

	if arg_16_2 ~= arg_16_0._difficulty_navigation_id then
		local var_16_2 = var_16_0[arg_16_2]

		arg_16_0:_update_selected_difficulty_option(var_16_2)
		arg_16_0:_play_sound("play_gui_lobby_button_02_mission_act_click")

		arg_16_0._difficulty_navigation_id = arg_16_2
	end
end

function StartGameWindowDifficultyConsole._get_difficulty_navigation_id_from_difficulty_key(arg_17_0, arg_17_1)
	local var_17_0 = arg_17_0:_get_difficulty_options()

	for iter_17_0 = 1, #var_17_0 do
		if arg_17_1 == var_17_0[iter_17_0] then
			return iter_17_0
		end
	end

	ferror("Difficulty Key not found %s", arg_17_1)
end

function StartGameWindowDifficultyConsole._set_selected_difficulty_option(arg_18_0, arg_18_1)
	local var_18_0 = arg_18_0._difficulty_widgets

	for iter_18_0 = 1, #var_18_0 do
		local var_18_1 = var_18_0[iter_18_0].content

		var_18_1.is_selected = var_18_1.difficulty_key == arg_18_1
	end

	local var_18_2 = arg_18_0._difficulty_reward_widgets

	for iter_18_1 = 1, #var_18_2 do
		local var_18_3 = var_18_2[iter_18_1].content

		var_18_3.visible = var_18_3.difficulty_key == arg_18_1
	end
end

function StartGameWindowDifficultyConsole._set_info_window(arg_19_0, arg_19_1)
	local var_19_0 = DifficultySettings[arg_19_1]
	local var_19_1 = var_19_0.description
	local var_19_2 = var_19_0.display_name
	local var_19_3 = var_19_0.display_image
	local var_19_4 = var_19_0.xp_multiplier or 1
	local var_19_5 = var_19_0.max_chest_power_level
	local var_19_6 = arg_19_0._widgets_by_name

	var_19_6.difficulty_title.content.text = Localize(var_19_2)
	var_19_6.difficulty_texture.content.texture_id = var_19_3
	var_19_6.description_text.content.text = Localize(var_19_1)
	var_19_6.difficulty_chest_info.content.text = Localize("difficulty_chest_max_powerlevel") .. ": " .. tostring(var_19_5)

	local var_19_7 = var_19_4 % 1
	local var_19_8 = var_19_4 - var_19_7

	var_19_6.xp_multiplier.content.text = string.format("%s: %s.%sx", Localize("difficulty_xp_multiplier"), var_19_8, string.pad_right(string.sub(tostring(var_19_7), 3, 4), 2, "0"))
end

function StartGameWindowDifficultyConsole._update_difficulty_locks(arg_20_0)
	local var_20_0 = arg_20_0._widgets_by_name
	local var_20_1 = "difficulty_option_"
	local var_20_2 = Managers.state.difficulty:get_default_difficulties()

	for iter_20_0 = 1, #var_20_2 do
		local var_20_3 = var_20_2[iter_20_0]
		local var_20_4 = DifficultySettings[var_20_3]
		local var_20_5 = arg_20_0.parent:is_difficulty_approved(var_20_3)
		local var_20_6 = var_20_0[var_20_1 .. iter_20_0]

		var_20_6.content.locked = not var_20_5
		var_20_6.style.icon_texture.offset[3] = var_20_5 and var_20_6.content.icon_unlocked_z_offset or var_20_6.content.icon_locked_z_offset
	end

	local var_20_7 = var_20_0.buy_button
	local var_20_8 = var_20_0.difficulty_second_lock_text
	local var_20_9 = var_20_0.difficulty_lock_text
	local var_20_10 = var_20_0.difficulty_is_locked_text
	local var_20_11 = var_20_0.dlc_lock_text
	local var_20_12 = arg_20_0._selected_difficulty_key

	if var_20_12 then
		local var_20_13 = DifficultySettings[var_20_12]
		local var_20_14, var_20_15, var_20_16, var_20_17 = arg_20_0.parent:is_difficulty_approved(var_20_12)

		if not var_20_14 then
			if var_20_16 then
				var_20_7.content.button_hotspot.disable_button = false
				var_20_7.content.visible = true
				var_20_7.content.dlc_name = var_20_16
				var_20_8.offset[2] = 38
				var_20_9.offset[2] = 38
				var_20_10.offset[2] = 38
				var_20_11.content.visible = true
				arg_20_0._dlc_locked = var_20_16
			else
				var_20_7.content.button_hotspot.disable_button = true
				var_20_7.content.visible = false
				var_20_7.content.dlc_name = nil
				var_20_8.offset[2] = 0
				var_20_9.offset[2] = 0
				var_20_10.offset[2] = 0
				var_20_11.content.visible = false
				arg_20_0._dlc_locked = nil
			end

			if var_20_17 or var_20_15 then
				var_20_0.difficulty_is_locked_text.content.text = Localize("required_power_level_not_met_in_party")

				if var_20_17 then
					local var_20_18 = var_20_13.required_power_level
					local var_20_19 = Localize("required_power_level")

					var_20_0.difficulty_lock_text.content.text = string.format("%s: %s", var_20_19, tostring(UIUtils.presentable_hero_power_level(var_20_18)))
					var_20_0.difficulty_second_lock_text.content.text = var_20_15 and Localize(var_20_15) or ""
				else
					var_20_0.difficulty_lock_text.content.text = var_20_15 and Localize(var_20_15) or ""
				end
			end

			if var_20_16 then
				arg_20_0.parent:set_input_description("select_difficulty_buy")
			else
				arg_20_0.parent:set_input_description("select_difficulty")
			end
		else
			var_20_7.content.button_hotspot.disable_button = true
			var_20_7.content.visible = false
			var_20_7.content.dlc_name = nil
			var_20_11.content.visible = false
			var_20_0.difficulty_lock_text.content.text = ""
			var_20_0.difficulty_second_lock_text.content.text = ""
			var_20_0.difficulty_is_locked_text.content.text = ""
			arg_20_0._dlc_locked = nil

			arg_20_0.parent:set_input_description("select_difficulty_confirm")
		end

		arg_20_0._difficulty_approved = var_20_14
	else
		var_20_7.content.button_hotspot.disable_button = true
		var_20_7.content.visible = false
		var_20_7.content.dlc_name = nil
		var_20_11.content.visible = false

		if not arg_20_0._has_exited then
			arg_20_0.parent:set_input_description(nil)
		end
	end
end

function StartGameWindowDifficultyConsole._update_selected_difficulty_option(arg_21_0, arg_21_1)
	arg_21_1 = arg_21_1 or Managers.state.difficulty:get_difficulty()

	if arg_21_1 ~= arg_21_0._selected_difficulty_key then
		arg_21_0:_set_selected_difficulty_option(arg_21_1)

		arg_21_0._selected_difficulty_key = arg_21_1

		arg_21_0:_set_info_window(arg_21_1)
	end
end

function StartGameWindowDifficultyConsole.draw(arg_22_0, arg_22_1)
	local var_22_0 = arg_22_0.ui_top_renderer
	local var_22_1 = arg_22_0.ui_scenegraph
	local var_22_2 = arg_22_0.parent:window_input_service()

	UIRenderer.begin_pass(var_22_0, var_22_1, var_22_2, arg_22_1, nil, arg_22_0.render_settings)

	local var_22_3 = arg_22_0._widgets

	for iter_22_0 = 1, #var_22_3 do
		local var_22_4 = var_22_3[iter_22_0]

		UIRenderer.draw_widget(var_22_0, var_22_4)
	end

	UIRenderer.end_pass(var_22_0)
end

function StartGameWindowDifficultyConsole._play_sound(arg_23_0, arg_23_1)
	arg_23_0.parent:play_sound(arg_23_1)
end

function StartGameWindowDifficultyConsole._is_button_released(arg_24_0, arg_24_1)
	local var_24_0 = arg_24_1.content.button_hotspot

	if var_24_0.on_release then
		var_24_0.on_release = false

		return true
	end
end

function StartGameWindowDifficultyConsole._show_storepage(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = PLATFORM

	if IS_WINDOWS and rawget(_G, "Steam") then
		Steam.open_url(arg_25_1)
	elseif IS_XB1 then
		local var_25_1 = Managers.account:user_id()

		if arg_25_2 then
			local var_25_2 = Managers.unlock:dlc_id(arg_25_2)

			if var_25_2 then
				XboxLive.show_product_details(var_25_1, var_25_2)
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_25_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	elseif IS_PS4 then
		local var_25_3 = Managers.account:user_id()

		if arg_25_2 then
			local var_25_4 = Managers.unlock:ps4_dlc_product_label(arg_25_2)

			if var_25_4 then
				Managers.system_dialog:open_commerce_dialog(NpCommerceDialog.MODE_PRODUCT, var_25_3, {
					var_25_4
				})
			else
				Application.error(string.format("[StartGameWindowAreaSelection:_show_storepage] No product_id for dlc: %s", arg_25_2))
			end
		else
			Application.error("[StartGameWindowAreaSelection:_show_storepage] No dlc name")
		end
	end
end
