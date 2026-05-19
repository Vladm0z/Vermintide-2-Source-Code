-- chunkname: @scripts/ui/hud_ui/ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/ability_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition

AbilityUI = class(AbilityUI)

function AbilityUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._player = arg_1_2.player
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()

	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil
	arg_1_0._hide_effects = false
	arg_1_0._ability_charge_widgets = {}

	local var_1_0 = Managers.state.event

	var_1_0:register(arg_1_0, "input_changed", "event_input_changed")
	var_1_0:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
end

function AbilityUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
	arg_2_0:event_input_changed()
end

function AbilityUI._get_player_unit(arg_3_0)
	if arg_3_0._is_spectator then
		return arg_3_0._spectated_player, arg_3_0._spectated_player_unit
	end

	local var_3_0 = arg_3_0._player

	return var_3_0, var_3_0.player_unit
end

function AbilityUI._update_ability_widget(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0, var_4_1 = arg_4_0:_get_player_unit()

	if not var_4_1 then
		return false
	end

	local var_4_2 = arg_4_0._hide_effects
	local var_4_3 = ScriptUnit.extension(var_4_1, "career_system")
	local var_4_4 = var_4_3:career_name()

	if arg_4_0._career_name ~= var_4_4 then
		local var_4_5 = var_4_3:profile_index()
		local var_4_6 = var_4_3:career_index()

		var_4_2 = CareerUtils.get_ability_data(var_4_5, var_4_6, 1).hide_ability_ui_effects
		arg_4_0._hide_effects = var_4_2
		arg_4_0._career_name = var_4_4
		arg_4_0._ability_cooldowns = nil

		table.clear(arg_4_0._ability_charge_widgets)
	end

	local var_4_7 = UISettings.ability_ui_data[var_4_4] or UISettings.ability_ui_data.default
	local var_4_8 = arg_4_0._widgets_by_name.ability
	local var_4_9 = var_4_8.content
	local var_4_10 = var_4_8.style

	var_4_9.ability_effect.texture_id = var_4_7.ability_effect
	var_4_9.ability_effect_top.texture_id = var_4_7.ability_effect_top
	var_4_9.ability_bar_highlight = var_4_7.ability_bar_highlight

	local var_4_11 = var_4_3:can_use_activated_ability()
	local var_4_12, var_4_13 = var_4_3:get_extra_ability_uses()
	local var_4_14 = var_4_12 > 0

	if var_4_14 then
		var_4_9.ability_effect.texture_id = var_4_7.ability_effect_thorn
		var_4_9.ability_effect_top.texture_id = var_4_7.ability_effect_top_thorn
	else
		var_4_9.ability_effect.texture_id = var_4_7.ability_effect
		var_4_9.ability_effect_top.texture_id = var_4_7.ability_effect_top
	end

	if var_4_14 then
		local var_4_15 = 220 + 35 * (0.5 + 0.5 * math.sin(arg_4_2 * 5))

		var_4_10.ability_effect_right.color[1] = var_4_15
		var_4_10.ability_effect_top_right.color[1] = var_4_15
		var_4_10.ability_effect_left.color[1] = var_4_15
		var_4_10.ability_effect_top_left.color[1] = var_4_15
	end

	if var_4_11 then
		var_4_9.can_use = true
		var_4_9.on_cooldown = var_4_3:current_ability_cooldown() > 0

		local var_4_16 = 0.5 + 0.5 * math.sin(arg_4_2 * 5)
		local var_4_17 = math.min(var_4_10.ability_effect_left.color[1] + arg_4_1 * 200, 255)

		if var_4_2 then
			var_4_17 = 0
			var_4_16 = 0.5
		end

		local var_4_18 = 100 + var_4_16 * 155

		var_4_10.ability_effect_right.color[1] = var_4_17
		var_4_10.ability_effect_top_right.color[1] = var_4_17
		var_4_10.ability_effect_left.color[1] = var_4_17
		var_4_10.ability_effect_top_left.color[1] = var_4_17
		var_4_10.ability_bar_highlight.color[1] = var_4_18

		return true
	elseif var_4_9.can_use then
		var_4_9.can_use = false
		var_4_9.on_cooldown = true
		var_4_10.ability_effect_right.color[1] = 0
		var_4_10.ability_effect_top_right.color[1] = 0
		var_4_10.ability_effect_left.color[1] = 0
		var_4_10.ability_effect_top_left.color[1] = 0
		var_4_10.ability_bar_highlight.color[1] = 0

		return true
	end
end

function AbilityUI.destroy(arg_5_0)
	local var_5_0 = Managers.state.event

	var_5_0:unregister("input_changed", arg_5_0)
	var_5_0:unregister("on_spectator_target_changed", arg_5_0)
	UIUtils.destroy_widgets(arg_5_0._ui_renderer, arg_5_0._widgets)
	print("[AbilityUI] - Destroy")
end

function AbilityUI.set_visible(arg_6_0, arg_6_1)
	arg_6_0._is_visible = arg_6_1

	arg_6_0:_set_elements_visible(arg_6_1)
end

function AbilityUI._set_elements_visible(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._ui_renderer

	for iter_7_0, iter_7_1 in pairs(arg_7_0._widgets) do
		UIRenderer.set_element_visible(var_7_0, iter_7_1.element, arg_7_1)
	end

	arg_7_0._are_elements_visible = arg_7_1
	arg_7_0._dirty = true
end

function AbilityUI._smudge(arg_8_0)
	UIUtils.mark_dirty(arg_8_0._widgets)

	if arg_8_0._ability_charge_widgets and not table.is_empty(arg_8_0._ability_charge_widgets) then
		UIUtils.mark_dirty(arg_8_0._ability_charge_widgets)
	end

	arg_8_0._dirty = true
end

function AbilityUI._handle_gamepad(arg_9_0)
	local var_9_0 = Managers.input:is_device_active("gamepad")
	local var_9_1 = (UISettings.use_gamepad_hud_layout ~= "auto" or not var_9_0) and UISettings.use_gamepad_hud_layout ~= "always" and not IS_CONSOLE

	if var_9_1 ~= arg_9_0._are_elements_visible then
		arg_9_0:_set_elements_visible(var_9_1)

		return var_9_1
	end

	return var_9_1
end

local var_0_2 = {
	root_scenegraph_id = "ability_root",
	is_child = true,
	registry_key = "player_status"
}

function AbilityUI.update(arg_10_0, arg_10_1, arg_10_2)
	if not arg_10_0._is_visible then
		return
	end

	if not arg_10_0:_handle_gamepad() then
		return
	end

	local var_10_0 = false

	if HudCustomizer.run(arg_10_0._ui_renderer, arg_10_0._ui_scenegraph, var_0_2) then
		var_10_0 = true
	end

	if RESOLUTION_LOOKUP.modified then
		var_10_0 = true
	end

	if arg_10_0:_update_ability_widget(arg_10_1, arg_10_2) then
		var_10_0 = true
	end

	if arg_10_0:_update_ability_charges_widgets(arg_10_1, arg_10_2) then
		var_10_0 = true
	end

	if var_10_0 then
		arg_10_0:_smudge()
	end

	arg_10_0:_update_numeric_ui_ability_cooldown()
	arg_10_0:draw(arg_10_1, arg_10_2)
end

function AbilityUI.draw(arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0._is_visible or not arg_11_0._dirty then
		return
	end

	local var_11_0 = arg_11_0._ui_renderer

	UIRenderer.begin_pass(var_11_0, arg_11_0._ui_scenegraph, FAKE_INPUT_SERVICE, arg_11_1, nil, arg_11_0._render_settings)
	UIRenderer.draw_all_widgets(var_11_0, arg_11_0._widgets)

	if arg_11_0._ability_charge_widgets and not table.is_empty(arg_11_0._ability_charge_widgets) and arg_11_0._ability_cooldowns > 1 then
		UIRenderer.draw_all_widgets(var_11_0, arg_11_0._ability_charge_widgets)
	end

	UIRenderer.end_pass(var_11_0)

	arg_11_0._dirty = false
end

function AbilityUI.set_alpha(arg_12_0, arg_12_1)
	arg_12_0._render_settings.alpha_multiplier = arg_12_1

	arg_12_0:_smudge()
end

function AbilityUI._get_input_texture_data(arg_13_0, arg_13_1)
	local var_13_0 = arg_13_0._input_manager
	local var_13_1 = var_13_0:get_service("Player")
	local var_13_2 = var_13_0:is_device_active("gamepad")

	return UISettings.get_gamepad_input_texture_data(var_13_1, arg_13_1, var_13_2)
end

function AbilityUI.event_input_changed(arg_14_0)
	local var_14_0 = Managers.input:is_device_active("gamepad")
	local var_14_1 = #InventorySettings.slots
	local var_14_2 = var_14_0 and "ability" or "action_career"
	local var_14_3 = arg_14_0._widgets_by_name.ability
	local var_14_4, var_14_5 = arg_14_0:_get_input_texture_data(var_14_2)

	if not var_14_5 or not UTF8Utils.string_length(var_14_5) then
		local var_14_6 = 0
	end

	if var_14_5 then
		local var_14_7 = arg_14_0._ui_renderer
		local var_14_8 = 40
		local var_14_9 = var_14_3.style.input_text

		var_14_5 = UIRenderer.crop_text_width(var_14_7, var_14_5, var_14_8, var_14_9)
	end

	var_14_3.content.input_text = var_14_5 or ""
	var_14_3.content.input_action = var_14_2

	arg_14_0:_smudge()
end

function AbilityUI.on_spectator_target_changed(arg_15_0, arg_15_1)
	arg_15_0._spectated_player_unit = arg_15_1
	arg_15_0._spectated_player = Managers.player:owner(arg_15_1)
	arg_15_0._is_spectator = true

	local var_15_0 = Managers.state.side:get_side_from_player_unique_id(arg_15_0._spectated_player:unique_id()):name() == "heroes"

	arg_15_0:set_visible(var_15_0)
end

function AbilityUI._update_numeric_ui_ability_cooldown(arg_16_0)
	local var_16_0 = Managers.player:local_player()

	if not var_16_0 then
		return
	end

	local var_16_1 = var_16_0.player_unit

	if not ALIVE[var_16_1] then
		return
	end

	local var_16_2 = arg_16_0._widgets_by_name.ability

	if not var_16_2 then
		return
	end

	local var_16_3 = ScriptUnit.extension(var_16_1, "career_system")
	local var_16_4 = var_16_3:can_use_activated_ability(1)

	var_16_2.content.can_use_ability = var_16_4

	if var_16_4 then
		return
	end

	local var_16_5, var_16_6 = var_16_3:current_ability_cooldown()

	var_16_2.content.ability_cooldown = UIUtils.format_time(var_16_5)

	arg_16_0:_smudge()
end

function AbilityUI._update_ability_charges_widgets(arg_17_0, arg_17_1, arg_17_2)
	local var_17_0 = false
	local var_17_1, var_17_2 = arg_17_0:_get_player_unit()

	if not var_17_2 then
		return var_17_0
	end

	local var_17_3 = ScriptUnit.extension(var_17_2, "career_system")
	local var_17_4 = var_17_3:get_number_of_ability_cooldowns()

	if arg_17_0._ability_cooldowns ~= var_17_4 then
		if not arg_17_0._ability_cooldowns then
			for iter_17_0 = 1, var_17_4 do
				if not arg_17_0._ability_charge_widgets[iter_17_0] then
					local var_17_5 = {
						0,
						(iter_17_0 - 1) * 22,
						1
					}
					local var_17_6 = UIWidgets.create_ability_charges_widget("ability_charges", nil, var_17_5)
					local var_17_7 = UIWidget.init(var_17_6)

					arg_17_0._ability_charge_widgets[#arg_17_0._ability_charge_widgets + 1] = var_17_7
				end
			end
		elseif arg_17_0._ability_cooldowns and var_17_4 < arg_17_0._ability_cooldowns then
			arg_17_0._ability_charge_widgets[#arg_17_0._ability_charge_widgets] = nil
		elseif arg_17_0._ability_cooldowns and var_17_4 > arg_17_0._ability_cooldowns then
			local var_17_8 = var_17_4 - arg_17_0._ability_cooldowns

			for iter_17_1 = 1, var_17_8 do
				local var_17_9 = {
					0,
					(arg_17_0._ability_cooldowns + (iter_17_1 - 1)) * 22,
					1
				}
				local var_17_10 = UIWidgets.create_ability_charges_widget("ability_charges", nil, var_17_9)
				local var_17_11 = UIWidget.init(var_17_10)

				arg_17_0._ability_charge_widgets[#arg_17_0._ability_charge_widgets + 1] = var_17_11
			end
		end

		arg_17_0._ability_cooldowns = var_17_4
		var_17_0 = true
	end

	local var_17_12 = var_17_3:num_charges_ready()

	if arg_17_0._charges_ready ~= var_17_12 then
		for iter_17_2 = arg_17_0._ability_cooldowns, 1, -1 do
			arg_17_0._ability_charge_widgets[iter_17_2].content.ready = var_17_12 ~= 0 and iter_17_2 <= var_17_12
		end

		arg_17_0._charges_ready = var_17_12
		var_17_0 = true
	end

	return var_17_0
end
