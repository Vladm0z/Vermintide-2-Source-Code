-- chunkname: @scripts/ui/views/deus_menu/deus_cursed_chest_view.lua

require("scripts/utils/hash_utils")

local var_0_0 = local_require("scripts/ui/views/deus_menu/deus_cursed_chest_view_definitions")
local var_0_1 = 1
local var_0_2 = 40
local var_0_3 = 0
local var_0_4 = 1
local var_0_5 = 12
local var_0_6 = 2.5
local var_0_7 = {
	close_ui = "hud_morris_weapon_chest_close",
	button_hover = "hud_morris_hover",
	power_up_unlocked = "hud_morris_cursed_chest_activate_powerup",
	open_ui = "hud_morris_cursed_chest_open"
}

DeusCursedChestView = class(DeusCursedChestView)

DeusCursedChestView.init = function (arg_1_0, arg_1_1)
	arg_1_0.ui_renderer = arg_1_1.ui_renderer
	arg_1_0.ingame_ui = arg_1_1.ingame_ui
	arg_1_0.input_manager = arg_1_1.input_manager
	arg_1_0.render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._wwise_world = arg_1_1.wwise_world

	local var_1_0 = "deus_cursed_chest_view"
	local var_1_1 = arg_1_1.input_manager

	arg_1_0._input_manager = var_1_1
	arg_1_0._input_service_name = var_1_0
	arg_1_0.ingame_ui = arg_1_1.ingame_ui

	var_1_1:create_input_service(var_1_0, "IngameMenuKeymaps", "IngameMenuFilters")
	var_1_1:map_device_to_service(var_1_0, "keyboard")
	var_1_1:map_device_to_service(var_1_0, "mouse")
	var_1_1:map_device_to_service(var_1_0, "gamepad")
end

DeusCursedChestView.destroy = function (arg_2_0)
	return
end

DeusCursedChestView.on_enter = function (arg_3_0, arg_3_1)
	arg_3_0._interactable = arg_3_1 and arg_3_1.interactable_unit
	arg_3_0._deus_run_controller = Managers.mechanism:game_mechanism():get_deus_run_controller()
	arg_3_0._circle_speed_modifier = var_0_4
	arg_3_0._circle_max_speed_modifier = var_0_4
	arg_3_0._power_up_data = Unit.get_data(arg_3_0._interactable, "power_ups")

	if not arg_3_0._power_up_data then
		local var_3_0 = Unit.world_position(arg_3_0._interactable, 0)
		local var_3_1 = HashUtils.fnv32_hash(var_3_0.x .. "_" .. var_3_0.y .. "_" .. var_3_0.z)
		local var_3_2 = arg_3_0._deus_run_controller:generate_random_power_ups(DeusPowerUpSettings.cursed_chest_choice_amount, DeusPowerUpAvailabilityTypes.cursed_chest, var_3_1)

		arg_3_0._power_up_data = {}

		for iter_3_0, iter_3_1 in ipairs(var_3_2) do
			arg_3_0._power_up_data[iter_3_0] = {
				selected = false,
				power_up = iter_3_1
			}
		end

		Unit.set_data(arg_3_0._interactable, "power_ups", arg_3_0._power_up_data)
	end

	arg_3_0:_acquire_input()
	arg_3_0:create_ui_elements()
	arg_3_0:_play_sound(var_0_7.open_ui)
end

DeusCursedChestView.create_ui_elements = function (arg_4_0)
	arg_4_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_4_0 = {}
	local var_4_1 = {}

	for iter_4_0, iter_4_1 in pairs(var_0_0.background_widgets) do
		if iter_4_1 then
			local var_4_2 = UIWidget.init(iter_4_1)

			var_4_0[#var_4_0 + 1] = var_4_2
			var_4_1[iter_4_0] = var_4_2
		end
	end

	local var_4_3 = arg_4_0._deus_run_controller:get_own_peer_id()
	local var_4_4, var_4_5 = arg_4_0._deus_run_controller:get_player_profile(var_4_3, var_0_1)
	local var_4_6 = DeusPowerUpTemplates
	local var_4_7 = {}
	local var_4_8 = #arg_4_0._power_up_data

	for iter_4_2 = 1, var_4_8 do
		local var_4_9 = arg_4_0._power_up_data[iter_4_2].power_up
		local var_4_10 = var_4_6[var_4_9.name].rectangular_icon
		local var_4_11 = var_0_0.scenegraph_definition.power_up_root.size
		local var_4_12 = var_0_0.create_power_up_shop_item("power_up_root", var_4_11, false, var_4_10)
		local var_4_13 = UIWidget.init(var_4_12)
		local var_4_14 = iter_4_2 - 1
		local var_4_15 = var_4_8 - 1
		local var_4_16 = math.rad(var_4_14 / var_4_15 * 180)
		local var_4_17 = ((var_4_11[2] + var_0_3) * var_4_8 + var_4_11[2]) / 2

		var_4_13.offset = {
			var_0_2 * math.sin(var_4_16),
			var_4_17 - (var_0_3 + var_4_11[2]) * iter_4_2,
			0
		}

		local var_4_18
		local var_4_19 = 0

		arg_4_0:_init_power_up_widget(var_4_13, var_4_9, nil, var_4_19, var_4_18, var_4_4, var_4_5)

		arg_4_0._power_up_data[iter_4_2].widget = var_4_13
		var_4_0[#var_4_0 + 1] = var_4_13
		var_4_7[#var_4_7 + 1] = var_4_13
		var_4_1["power_up_item_" .. iter_4_2] = var_4_13
	end

	arg_4_0._widgets = var_4_0
	arg_4_0._power_up_widgets = var_4_7
	arg_4_0._widgets_by_name = var_4_1

	UIRenderer.clear_scenegraph_queue(arg_4_0.ui_renderer)
end

DeusCursedChestView.post_update_on_enter = function (arg_5_0)
	return
end

DeusCursedChestView.on_exit = function (arg_6_0)
	arg_6_0._power_up_data = nil
	arg_6_0._interactable = nil

	arg_6_0:_release_input()
end

DeusCursedChestView.post_update_on_exit = function (arg_7_0)
	return
end

DeusCursedChestView._init_power_up_widget = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7)
	local var_8_0 = DeusPowerUps[arg_8_2.rarity][arg_8_2.name]
	local var_8_1 = var_8_0.rarity
	local var_8_2 = arg_8_1.content

	var_8_2.title_text = DeusPowerUpUtils.get_power_up_name_text(var_8_0.name, var_8_0.talent_index, var_8_0.talent_tier, arg_8_6, arg_8_7)
	var_8_2.rarity_text = Localize(RaritySettings[var_8_1].display_name)
	var_8_2.sub_text = DeusPowerUpUtils.get_power_up_description(var_8_0, arg_8_6, arg_8_7)
	var_8_2.has_discount = arg_8_3
	var_8_2.icon = DeusPowerUpUtils.get_power_up_icon(var_8_0, arg_8_6, arg_8_7)
	var_8_2.max_value_text = nil
	var_8_2.current_value_text = nil

	local var_8_3 = arg_8_1.style
	local var_8_4 = DeusPowerUpSetLookup[arg_8_2.rarity] and DeusPowerUpSetLookup[arg_8_2.rarity][arg_8_2.name]
	local var_8_5 = false

	if var_8_4 then
		local var_8_6 = var_8_4[1]
		local var_8_7 = 0
		local var_8_8 = var_8_6.pieces

		for iter_8_0, iter_8_1 in ipairs(var_8_8) do
			local var_8_9 = iter_8_1.name
			local var_8_10 = iter_8_1.rarity
			local var_8_11 = arg_8_0._deus_run_controller:get_own_peer_id()

			if arg_8_0._deus_run_controller:has_power_up_by_name(var_8_11, var_8_9, var_8_10) then
				var_8_7 = var_8_7 + 1
			end
		end

		var_8_5 = true

		local var_8_12 = var_8_6.num_required_pieces or #var_8_8

		var_8_2.set_progression = string.format(Localize("set_counter_boons"), var_8_7, var_8_12)

		if #var_8_8 == var_8_7 then
			var_8_3.set_progression.text_color = arg_8_1.style.set_progression.progression_colors.complete
		end
	end

	var_8_2.is_part_of_set = var_8_5

	local var_8_13 = Colors.get_table(var_8_1)

	var_8_3.rarity_text.text_color = var_8_13
	var_8_3.price_icon.color[1] = 0
	var_8_3.price_text.text_color[1] = 0
	var_8_3.price_text_shadow.text_color[1] = 0
	var_8_3.price_text_disabled.text_color[1] = 0

	local var_8_14 = 22

	var_8_3.current_value_title_text.offset[2] = var_8_3.current_value_title_text.offset[2] + var_8_14
	var_8_3.current_value_title_text_shadow.offset[2] = var_8_3.current_value_title_text_shadow.offset[2] + var_8_14
	var_8_3.current_value_text.offset[2] = var_8_3.current_value_text.offset[2] + var_8_14
	var_8_3.current_value_text_shadow.offset[2] = var_8_3.current_value_text_shadow.offset[2] + var_8_14
	var_8_3.max_value_title_text.offset[2] = var_8_3.max_value_title_text.offset[2] + var_8_14
	var_8_3.max_value_title_text_shadow.offset[2] = var_8_3.max_value_title_text_shadow.offset[2] + var_8_14
	var_8_3.max_value_text.offset[2] = var_8_3.max_value_text.offset[2] + var_8_14
	var_8_3.max_value_text_shadow.offset[2] = var_8_3.max_value_text_shadow.offset[2] + var_8_14
end

DeusCursedChestView.draw = function (arg_9_0, arg_9_1)
	for iter_9_0, iter_9_1 in ipairs(arg_9_0._power_up_widgets) do
		arg_9_0:_animate_power_up_widget(arg_9_1, iter_9_1)
	end

	local var_9_0 = arg_9_0._widgets_by_name

	UIWidgetUtils.animate_default_button(var_9_0.exit_button, arg_9_1)

	local var_9_1 = arg_9_0.ui_renderer
	local var_9_2 = arg_9_0.ui_scenegraph
	local var_9_3 = arg_9_0:input_service()
	local var_9_4 = arg_9_0.render_settings

	UIRenderer.begin_pass(var_9_1, var_9_2, var_9_3, arg_9_1, nil, var_9_4)

	local var_9_5 = var_9_4.snap_pixel_positions
	local var_9_6 = arg_9_0._widgets

	for iter_9_2 = 1, #var_9_6 do
		local var_9_7 = var_9_6[iter_9_2]

		if var_9_7.snap_pixel_positions ~= nil then
			var_9_4.snap_pixel_positions = var_9_7.snap_pixel_positions
		end

		UIRenderer.draw_widget(var_9_1, var_9_7)

		var_9_4.snap_pixel_positions = var_9_5
	end

	UIRenderer.end_pass(var_9_1)
end

DeusCursedChestView._get_selected_power_up_count = function (arg_10_0)
	local var_10_0 = 0

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._power_up_data) do
		if iter_10_1.selected then
			var_10_0 = var_10_0 + 1
		end
	end

	return var_10_0
end

DeusCursedChestView.update = function (arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = arg_11_0._deus_run_controller:get_own_peer_id()
	local var_11_1 = DeusPowerUpSettings.cursed_chest_max_picks
	local var_11_2 = arg_11_0:_get_selected_power_up_count()
	local var_11_3 = var_11_1 <= var_11_2

	for iter_11_0, iter_11_1 in ipairs(arg_11_0._power_up_data) do
		local var_11_4 = iter_11_1.widget
		local var_11_5 = iter_11_1.power_up
		local var_11_6 = arg_11_0._deus_run_controller:reached_max_power_ups(var_11_0, var_11_5.name)
		local var_11_7 = var_11_4.content

		if iter_11_1.selected then
			var_11_7.is_bought = true
			var_11_7.button_hotspot.disable_button = true
			var_11_2 = var_11_2 + 1
		elseif var_11_3 or var_11_6 then
			var_11_7.button_hotspot.disable_button = true
		else
			var_11_7.is_bought = false
			var_11_7.button_hotspot.disable_button = false
		end
	end

	arg_11_0:_handle_input(arg_11_1)
	arg_11_0:_update_background_animations(arg_11_1)
	arg_11_0:draw(arg_11_1)
end

DeusCursedChestView._on_button_pressed = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_1.power_up

	arg_12_1.selected = true

	Unit.set_data(arg_12_0._interactable, "power_ups", arg_12_0._power_up_data)
	arg_12_0._deus_run_controller:add_power_ups({
		var_12_0
	}, var_0_1, true)

	arg_12_0._circle_max_speed_modifier = var_0_5

	arg_12_0:_play_sound(var_0_7.power_up_unlocked)

	local var_12_1 = ScriptUnit.has_extension(arg_12_0._interactable, "deus_cursed_chest_system")

	if var_12_1 then
		var_12_1:on_reward_collected(var_12_0)
	end

	arg_12_0:_close()
end

DeusCursedChestView._handle_input = function (arg_13_0, arg_13_1)
	for iter_13_0, iter_13_1 in ipairs(arg_13_0._power_up_data) do
		local var_13_0 = iter_13_1.widget

		if arg_13_0:_is_button_pressed(var_13_0) then
			Managers.state.entity:system("animation_system"):add_safe_animation_callback(function ()
				arg_13_0:_on_button_pressed(iter_13_1)
			end)
		end

		arg_13_0:_update_button_hover_sound(var_13_0)
	end

	local var_13_1 = arg_13_0._widgets_by_name
	local var_13_2 = arg_13_0._input_manager:get_service(arg_13_0._input_service_name)
	local var_13_3 = var_13_1.exit_button

	if arg_13_0:_is_button_pressed(var_13_3) or var_13_2:get("toggle_menu", true) or var_13_2:get("back", true) then
		arg_13_0:_close()
	end

	arg_13_0:_update_button_hover_sound(var_13_3)
end

DeusCursedChestView.disable_toggle_menu = function (arg_15_0)
	return true
end

DeusCursedChestView.input_service = function (arg_16_0)
	return arg_16_0._input_manager:get_service(arg_16_0._input_service_name)
end

DeusCursedChestView._close = function (arg_17_0)
	arg_17_0:_play_sound(var_0_7.close_ui)
	arg_17_0.ingame_ui:handle_transition("exit_menu")
end

DeusCursedChestView._acquire_input = function (arg_18_0, arg_18_1)
	arg_18_0:_release_input(true)

	local var_18_0 = arg_18_0._input_manager
	local var_18_1 = arg_18_0._input_service_name

	var_18_0:capture_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, var_18_1, "DeusCursedChestView")
	var_18_0:block_device_except_service(var_18_1, "keyboard")
	var_18_0:block_device_except_service(var_18_1, "mouse")
	var_18_0:block_device_except_service(var_18_1, "gamepad")

	if not arg_18_1 then
		ShowCursorStack.show("DeusCursedChestView")
		var_18_0:enable_gamepad_cursor()
	end
end

DeusCursedChestView._release_input = function (arg_19_0, arg_19_1)
	local var_19_0 = arg_19_0._input_manager

	var_19_0:release_input({
		"keyboard",
		"gamepad",
		"mouse"
	}, 1, arg_19_0._input_service_name, "DeusCursedChestView")

	if not arg_19_1 then
		ShowCursorStack.hide("DeusCursedChestView")
		var_19_0:disable_gamepad_cursor()
	end
end

DeusCursedChestView._is_button_pressed = function (arg_20_0, arg_20_1)
	local var_20_0 = arg_20_1.content.button_hotspot

	if var_20_0.on_release then
		var_20_0.on_release = false

		return true
	end
end

DeusCursedChestView._is_button_hovered = function (arg_21_0, arg_21_1)
	if arg_21_1.content.button_hotspot.on_hover_enter then
		return true
	end
end

DeusCursedChestView._update_button_hover_sound = function (arg_22_0, arg_22_1)
	if arg_22_0:_is_button_hovered(arg_22_1) then
		arg_22_0:_play_sound(var_0_7.button_hover)
	end
end

DeusCursedChestView._animate_power_up_widget = function (arg_23_0, arg_23_1, arg_23_2)
	local var_23_0 = arg_23_2.content
	local var_23_1 = arg_23_2.style
	local var_23_2 = var_23_0.hotspot or var_23_0.button_hotspot
	local var_23_3 = var_23_2.is_hover
	local var_23_4 = var_23_0.is_bought
	local var_23_5 = var_23_2.is_selected
	local var_23_6 = var_23_2.hover_progress or 0
	local var_23_7 = var_23_2.highlight_progress or 0
	local var_23_8 = var_23_2.selection_progress or 0
	local var_23_9 = 15

	if var_23_4 then
		var_23_3 = false
	end

	if var_23_3 then
		var_23_6 = math.min(var_23_6 + arg_23_1 * var_23_9, 1)
	else
		var_23_6 = math.max(var_23_6 - arg_23_1 * var_23_9, 0)
	end

	if var_23_4 then
		var_23_7 = math.min(var_23_7 + arg_23_1 * var_23_9, 1)
	else
		var_23_7 = math.max(var_23_7 - arg_23_1 * var_23_9, 0)
	end

	if var_23_5 then
		var_23_8 = math.min(var_23_8 + arg_23_1 * var_23_9, 1)
	else
		var_23_8 = math.max(var_23_8 - arg_23_1 * var_23_9, 0)
	end

	if var_23_0.bought_glow_style_ids then
		for iter_23_0, iter_23_1 in ipairs(var_23_0.bought_glow_style_ids) do
			var_23_1[iter_23_1].color[1] = 255 * var_23_7
		end
	end

	var_23_1.hover.color[1] = 255 * var_23_6
	var_23_1.icon_hover_frame.color[1] = 255 * var_23_6

	local var_23_10 = var_23_2.value_progress or 0
	local var_23_11 = math.max(var_23_10 - arg_23_1 * var_23_9, 0)

	if var_23_1.icon_equipped_frame then
		var_23_1.icon_equipped_frame.color[1] = 255 * var_23_11
	end

	var_23_2.value_progress = var_23_11
	var_23_2.hover_progress = var_23_6
	var_23_2.highlight_progress = var_23_7
	var_23_2.selection_progress = var_23_8
end

DeusCursedChestView._play_sound = function (arg_24_0, arg_24_1)
	WwiseWorld.trigger_event(arg_24_0._wwise_world, arg_24_1)
end

DeusCursedChestView._update_background_animations = function (arg_25_0, arg_25_1)
	local var_25_0 = arg_25_0._widgets_by_name
	local var_25_1 = arg_25_0._circle_speed_modifier
	local var_25_2 = arg_25_0._circle_max_speed_modifier

	if math.value_inside_range(var_25_1, var_25_2 - 0.2, var_25_2 + 0.2) then
		arg_25_0._circle_max_speed_modifier = var_0_4
	end

	local var_25_3 = math.lerp(var_25_1, var_25_2, var_0_6 * arg_25_1)

	for iter_25_0 = 1, 3 do
		local var_25_4 = var_25_0["background_wheel_0" .. iter_25_0]
		local var_25_5 = var_25_4.style.texture_id.angle
		local var_25_6 = 0
		local var_25_7
		local var_25_8 = var_25_5 + arg_25_1 * (iter_25_0 == 1 and 0.2 or iter_25_0 == 2 and -0.1 or 0.05) * var_25_3

		var_25_4.style.texture_id.angle = var_25_8
	end

	arg_25_0._circle_speed_modifier = var_25_3
end
