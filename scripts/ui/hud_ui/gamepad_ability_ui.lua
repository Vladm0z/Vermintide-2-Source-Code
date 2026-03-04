-- chunkname: @scripts/ui/hud_ui/gamepad_ability_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/gamepad_ability_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.create_ability_charges_widget

GamePadAbilityUI = class(GamePadAbilityUI)

function GamePadAbilityUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._player = arg_1_2.player
	arg_1_0._render_settings = {
		snap_pixel_positions = true
	}

	arg_1_0:_create_ui_elements()

	arg_1_0._ability_charge_widgets = {}

	Managers.state.event:register(arg_1_0, "input_changed", "event_input_changed")
end

function GamePadAbilityUI._create_ui_elements(arg_2_0)
	arg_2_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0._widgets, arg_2_0._widgets_by_name = UIUtils.create_widgets(var_0_0.widget_definitions)

	UIRenderer.clear_scenegraph_queue(arg_2_0._ui_renderer)
	arg_2_0:event_input_changed()
end

function GamePadAbilityUI._setup_activated_ability(arg_3_0)
	local var_3_0 = arg_3_0._player.player_unit

	if not var_3_0 then
		return
	end

	local var_3_1 = ScriptUnit.extension(var_3_0, "career_system")
	local var_3_2 = var_3_1:get_activated_ability_data()
	local var_3_3 = var_3_1:career_index()

	if not var_3_2 or not var_3_3 then
		return
	end

	arg_3_0._career_index = var_3_3
	arg_3_0._initialized = true
end

function GamePadAbilityUI._sync_ability_cooldown(arg_4_0)
	local var_4_0 = arg_4_0._player.player_unit

	if not var_4_0 then
		return
	end

	local var_4_1 = ScriptUnit.extension(var_4_0, "career_system")
	local var_4_2, var_4_3 = var_4_1:current_ability_cooldown()
	local var_4_4 = var_4_1:career_index()

	if arg_4_0._career_index ~= var_4_4 then
		arg_4_0._initialized = false

		return
	end

	arg_4_0._ability_usable = var_4_1:can_use_activated_ability()

	if var_4_2 then
		local var_4_5 = var_4_2 / var_4_3

		if var_4_5 ~= arg_4_0._current_cooldown_fraction then
			arg_4_0:_set_ability_cooldown_state(var_4_5, not arg_4_0._current_cooldown_fraction)
		end
	end
end

function GamePadAbilityUI._update_thornsister_passive(arg_5_0)
	local var_5_0 = arg_5_0._player.player_unit

	if not var_5_0 then
		return
	end

	local var_5_1 = ScriptUnit.extension(var_5_0, "career_system")
	local var_5_2 = arg_5_0._widgets_by_name
	local var_5_3 = var_5_2.thornsister_passive
	local var_5_4 = var_5_3.content
	local var_5_5, var_5_6 = var_5_1:get_extra_ability_uses()
	local var_5_7 = var_5_5 > 0

	if var_5_4.is_active ~= var_5_7 then
		var_5_4.is_active = var_5_7

		arg_5_0:_set_widget_dirty(var_5_3)

		local var_5_8 = var_5_2.ability

		var_5_8.content.hide_effect = var_5_7

		arg_5_0:_set_widget_dirty(var_5_8)

		return true
	end
end

function GamePadAbilityUI._set_ability_activated(arg_6_0, arg_6_1)
	local var_6_0 = arg_6_0._widgets_by_name.ability
	local var_6_1 = var_6_0.content
	local var_6_2 = var_6_0.style

	var_6_0.content.activated = arg_6_1
	arg_6_0._ability_activated = arg_6_1
end

function GamePadAbilityUI._set_ability_cooldown_state(arg_7_0, arg_7_1, arg_7_2)
	arg_7_0._current_cooldown_fraction = arg_7_1

	local var_7_0 = arg_7_1 ~= 0
	local var_7_1 = arg_7_0._ability_usable
	local var_7_2 = arg_7_0._widgets_by_name.ability

	if var_7_2.content.on_cooldown and not var_7_0 and not var_7_1 then
		local var_7_3 = var_7_2.style

		var_7_3.input_text.text_color[1] = 0
		var_7_3.input_text_shadow.text_color[1] = 0
	end

	var_7_2.content.on_cooldown = var_7_0
	var_7_2.content.usable = var_7_1

	arg_7_0:_set_widget_dirty(var_7_2)
	arg_7_0:set_dirty()
end

function GamePadAbilityUI.destroy(arg_8_0)
	Managers.state.event:unregister("input_changed", arg_8_0)
	arg_8_0:set_visible(false)
	print("[GamePadAbilityUI] - Destroy")
end

function GamePadAbilityUI.set_visible(arg_9_0, arg_9_1)
	arg_9_0._is_visible = arg_9_1

	arg_9_0:_set_elements_visible(arg_9_1)
end

function GamePadAbilityUI._set_elements_visible(arg_10_0, arg_10_1)
	local var_10_0 = arg_10_0._ui_renderer

	for iter_10_0, iter_10_1 in ipairs(arg_10_0._widgets) do
		UIRenderer.set_element_visible(var_10_0, iter_10_1.element, arg_10_1)
	end

	arg_10_0._retained_elements_visible = arg_10_1

	arg_10_0:set_dirty()
end

function GamePadAbilityUI._handle_gamepad_activity(arg_11_0)
	local var_11_0 = Managers.input:is_device_active("gamepad")
	local var_11_1 = Managers.input:get_most_recent_device()
	local var_11_2 = arg_11_0.gamepad_active_last_frame == nil or var_11_0 and var_11_1 ~= arg_11_0._most_recent_device

	if var_11_0 then
		if not arg_11_0.gamepad_active_last_frame or var_11_2 then
			arg_11_0.gamepad_active_last_frame = true

			arg_11_0:event_input_changed()
		end
	elseif arg_11_0.gamepad_active_last_frame or var_11_2 then
		arg_11_0.gamepad_active_last_frame = false

		arg_11_0:event_input_changed()
	end

	arg_11_0._most_recent_device = var_11_1
end

function GamePadAbilityUI._handle_gamepad(arg_12_0)
	local var_12_0 = arg_12_0:_handle_active_ability()

	if (not (Managers.input:is_device_active("gamepad") or IS_XB1) or UISettings.use_gamepad_hud_layout == "never") and UISettings.use_gamepad_hud_layout ~= "always" or var_12_0 then
		if arg_12_0._retained_elements_visible then
			arg_12_0:_set_elements_visible(false)
		end

		return false
	else
		if not arg_12_0._retained_elements_visible then
			arg_12_0:_set_elements_visible(true)
			arg_12_0:event_input_changed()
		end

		return true
	end
end

function GamePadAbilityUI.update(arg_13_0, arg_13_1, arg_13_2)
	if not arg_13_0:_handle_gamepad() then
		return
	end

	arg_13_0:_handle_gamepad_activity()

	if not arg_13_0._initialized then
		arg_13_0:_setup_activated_ability()
	else
		local var_13_0 = false

		if arg_13_0:_update_thornsister_passive() then
			var_13_0 = true
		end

		if arg_13_0._current_cooldown_fraction == 0 or arg_13_0._ability_usable then
			var_13_0 = arg_13_0:_update_ability_animations(arg_13_1, arg_13_2)
		end

		if arg_13_0:_update_ability_charges_widgets(arg_13_1, arg_13_2) then
			var_13_0 = true
		end

		if var_13_0 then
			arg_13_0:set_dirty()
		end

		arg_13_0:_sync_ability_cooldown()
		arg_13_0:_handle_resolution_modified()
		arg_13_0:_update_muneric_ui_ability_cooldown()
		arg_13_0:draw(arg_13_1)
	end
end

function GamePadAbilityUI._handle_active_ability(arg_14_0)
	local var_14_0 = Managers.player:local_player()

	if not var_14_0 then
		return false
	end

	local var_14_1 = var_14_0.player_unit

	if not Unit.alive(var_14_1) then
		return false
	end

	local var_14_2 = ScriptUnit.extension(var_14_1, "inventory_system")

	return var_14_2 and var_14_2:get_wielded_slot_name() == "slot_career_skill_weapon"
end

function GamePadAbilityUI._handle_resolution_modified(arg_15_0)
	if RESOLUTION_LOOKUP.modified then
		UIUtils.mark_dirty(arg_15_0._widgets)

		if not table.is_empty(arg_15_0._ability_charge_widgets) then
			UIUtils.mark_dirty(arg_15_0._ability_charge_widgets)
		end

		arg_15_0:set_dirty()
	end
end

function GamePadAbilityUI.draw(arg_16_0, arg_16_1)
	if not arg_16_0._is_visible then
		return
	end

	if not arg_16_0._dirty then
		return
	end

	local var_16_0 = arg_16_0._ui_renderer
	local var_16_1 = arg_16_0._ui_scenegraph
	local var_16_2 = arg_16_0._render_settings

	UIRenderer.begin_pass(var_16_0, var_16_1, FAKE_INPUT_SERVICE, arg_16_1, nil, arg_16_0._render_settings)

	for iter_16_0, iter_16_1 in ipairs(arg_16_0._widgets) do
		UIRenderer.draw_widget(var_16_0, iter_16_1)
	end

	if arg_16_0._ability_charge_widgets and not table.is_empty(arg_16_0._ability_charge_widgets) and arg_16_0._ability_cooldowns > 1 then
		UIRenderer.draw_all_widgets(var_16_0, arg_16_0._ability_charge_widgets)
	end

	UIRenderer.end_pass(var_16_0)

	arg_16_0._dirty = false
end

function GamePadAbilityUI.set_dirty(arg_17_0)
	arg_17_0._dirty = true
end

function GamePadAbilityUI._set_widget_dirty(arg_18_0, arg_18_1)
	arg_18_1.element.dirty = true
end

function GamePadAbilityUI.event_input_changed(arg_19_0)
	local var_19_0 = #InventorySettings.slots
	local var_19_1 = arg_19_0._input_manager:is_device_active("gamepad") and "ability" or "action_career"
	local var_19_2 = arg_19_0._widgets_by_name.ability

	arg_19_0:_set_input(var_19_2, var_19_1)
	arg_19_0:_set_widget_dirty(var_19_2)
	arg_19_0:set_dirty()
end

function GamePadAbilityUI._set_input(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0, var_20_1, var_20_2 = arg_20_0:_get_input_texture_data(arg_20_2)

	if not var_20_1 or not UTF8Utils.string_length(var_20_1) then
		local var_20_3 = 0
	end

	local var_20_4 = 40
	local var_20_5 = arg_20_1.style
	local var_20_6 = arg_20_1.content
	local var_20_7 = var_20_5.input_text
	local var_20_8 = arg_20_0._ui_renderer

	var_20_6.input_action = arg_20_2

	local var_20_9 = Managers.input:is_device_active("gamepad")

	if var_20_0 and var_20_9 then
		var_20_6.activate_ability_id = var_20_0.texture
		var_20_6.input_text = ""

		local var_20_10 = var_20_5.activate_ability.texture_size
		local var_20_11 = var_20_0.size

		var_20_10[1] = var_20_11[1]
		var_20_10[2] = var_20_11[2]
	elseif var_20_1 then
		var_20_6.input_text = UIRenderer.crop_text_width(var_20_8, var_20_1, var_20_4, var_20_7)
		var_20_6.activate_ability_id = nil
	end
end

function GamePadAbilityUI._get_input_texture_data(arg_21_0, arg_21_1)
	local var_21_0 = arg_21_0._input_manager
	local var_21_1 = var_21_0:get_service("Player")
	local var_21_2 = var_21_0:is_device_active("gamepad")
	local var_21_3 = PLATFORM

	if IS_XB1 and GameSettingsDevelopment.allow_keyboard_mouse and not var_21_2 then
		var_21_3 = "win32"
	elseif IS_WINDOWS and var_21_2 then
		var_21_3 = "xb1"
	end

	local var_21_4 = var_21_1:get_keymapping(arg_21_1, var_21_3)
	local var_21_5 = var_21_4[1]
	local var_21_6 = var_21_4[2]
	local var_21_7 = var_21_4[3]
	local var_21_8

	if var_21_7 == "held" then
		var_21_8 = "matchmaking_prefix_hold"
	end

	if var_21_6 ~= UNASSIGNED_KEY then
		if var_21_5 == "keyboard" then
			if type(var_21_6) == "number" then
				return nil, Keyboard.button_locale_name(var_21_6) or Keyboard.button_name(var_21_6), var_21_8
			else
				return nil, Localize(var_21_6), var_21_8
			end
		elseif var_21_5 == "mouse" then
			return ButtonTextureByName(var_21_5 .. "_" .. var_21_6, var_21_3), Mouse.button_name(var_21_6), var_21_8
		elseif var_21_5 == "gamepad" then
			local var_21_9 = Pad1.button_name(var_21_6)

			return ButtonTextureByName(var_21_9, var_21_3), var_21_9, var_21_8
		end
	end

	return nil, ""
end

function GamePadAbilityUI._update_ability_animations(arg_22_0, arg_22_1, arg_22_2)
	if not arg_22_0._is_visible then
		return false
	end

	local var_22_0 = arg_22_0._widgets_by_name.ability
	local var_22_1 = var_22_0.style
	local var_22_2 = 0.5 + 0.5 * math.sin(arg_22_2 * 5)

	var_22_1.input_text.text_color[1] = 100 + var_22_2 * 155
	var_22_1.input_text_shadow.text_color[1] = 100 + var_22_2 * 155

	arg_22_0:_set_widget_dirty(var_22_0)

	return true
end

function GamePadAbilityUI.set_alpha(arg_23_0, arg_23_1)
	for iter_23_0, iter_23_1 in pairs(arg_23_0._widgets) do
		arg_23_0:_set_widget_dirty(iter_23_1)
	end

	arg_23_0._render_settings.alpha_multiplier = arg_23_1

	arg_23_0:set_dirty()
end

function GamePadAbilityUI._update_muneric_ui_ability_cooldown(arg_24_0)
	local var_24_0 = Managers.player:local_player()

	if not var_24_0 then
		return
	end

	local var_24_1 = var_24_0.player_unit

	if not ALIVE[var_24_1] then
		return
	end

	local var_24_2 = arg_24_0._widgets_by_name.ability

	if not var_24_2 then
		return
	end

	local var_24_3 = ScriptUnit.extension(var_24_1, "career_system")
	local var_24_4 = var_24_3:can_use_activated_ability(1)

	var_24_2.content.can_use_ability = var_24_4

	if var_24_4 then
		return
	end

	local var_24_5, var_24_6 = var_24_3:current_ability_cooldown()

	var_24_2.content.ability_cooldown = UIUtils.format_time(var_24_5)

	arg_24_0:_set_widget_dirty(var_24_2)
end

function GamePadAbilityUI._update_ability_charges_widgets(arg_25_0, arg_25_1, arg_25_2)
	local var_25_0 = false
	local var_25_1 = arg_25_0._player.player_unit

	if not var_25_1 then
		return var_25_0
	end

	local var_25_2 = ScriptUnit.extension(var_25_1, "career_system")
	local var_25_3 = var_25_2:get_number_of_ability_cooldowns()

	if arg_25_0._ability_cooldowns ~= var_25_3 then
		if not arg_25_0._ability_cooldowns then
			for iter_25_0 = 1, var_25_3 do
				if not arg_25_0._ability_charge_widgets[iter_25_0] then
					local var_25_4 = {
						0,
						(iter_25_0 - 1) * 22,
						1
					}
					local var_25_5 = UIWidgets.create_ability_charges_widget("ability_charges", nil, var_25_4)
					local var_25_6 = UIWidget.init(var_25_5)

					arg_25_0._ability_charge_widgets[#arg_25_0._ability_charge_widgets + 1] = var_25_6
				end
			end
		elseif arg_25_0._ability_cooldowns and var_25_3 < arg_25_0._ability_cooldowns then
			arg_25_0._ability_charge_widgets[#arg_25_0._ability_charge_widgets] = nil
		elseif arg_25_0._ability_cooldowns and var_25_3 > arg_25_0._ability_cooldowns then
			local var_25_7 = var_25_3 - arg_25_0._ability_cooldowns

			for iter_25_1 = 1, var_25_7 do
				local var_25_8 = {
					0,
					(arg_25_0._ability_cooldowns + (iter_25_1 - 1)) * 22,
					1
				}
				local var_25_9 = UIWidgets.create_ability_charges_widget("ability_charges", nil, var_25_8)
				local var_25_10 = UIWidget.init(var_25_9)

				arg_25_0._ability_charge_widgets[#arg_25_0._ability_charge_widgets + 1] = var_25_10
			end
		end

		arg_25_0._ability_cooldowns = var_25_3
		var_25_0 = true
	end

	local var_25_11 = var_25_2:num_charges_ready()

	if arg_25_0._charges_ready ~= var_25_11 then
		for iter_25_2 = arg_25_0._ability_cooldowns, 1, -1 do
			arg_25_0._ability_charge_widgets[iter_25_2].content.ready = var_25_11 ~= 0 and iter_25_2 <= var_25_11
		end

		arg_25_0._charges_ready = var_25_11
		var_25_0 = true
	end

	return var_25_0
end
