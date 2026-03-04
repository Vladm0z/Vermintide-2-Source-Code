-- chunkname: @scripts/ui/hud_ui/career_ability_bar_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/career_ability_bar_ui_definitions")

CareerAbilityBarUI = class(CareerAbilityBarUI)

local var_0_1 = true

function CareerAbilityBarUI.init(arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0._platform = PLATFORM
	arg_1_0._ui_renderer = arg_1_2.ui_renderer
	arg_1_0._input_manager = arg_1_2.input_manager
	arg_1_0._slot_equip_animations = {}
	arg_1_0._slot_animations = {}
	arg_1_0._ui_animations = {}

	arg_1_0:_create_ui_elements()

	arg_1_0._peer_id = arg_1_2.peer_id
	arg_1_0._player_manager = arg_1_2.player_manager
	arg_1_0._render_settings = {
		alpha_multiplier = 1,
		snap_pixel_positions = true
	}
	arg_1_0._is_spectator = false
	arg_1_0._spectated_player = nil
	arg_1_0._spectated_player_unit = nil
	arg_1_0._game_options_dirty = true

	local var_1_0 = Managers.state.event

	var_1_0:register(arg_1_0, "on_spectator_target_changed", "on_spectator_target_changed")
	var_1_0:register(arg_1_0, "on_game_options_changed", "_set_game_options_dirty")
	arg_1_0:_update_game_options()
end

function CareerAbilityBarUI._get_ability_amount(arg_2_0, arg_2_1)
	local var_2_0, var_2_1 = ScriptUnit.extension(arg_2_1, "career_system"):current_ability_cooldown()
	local var_2_2 = 1 - var_2_0 / var_2_1
	local var_2_3 = 0.25
	local var_2_4 = 0.8
	local var_2_5 = 0.3

	return var_2_2, var_2_3, var_2_4, var_2_5
end

function CareerAbilityBarUI.on_spectator_target_changed(arg_3_0, arg_3_1)
	arg_3_0._spectated_player_unit = arg_3_1
	arg_3_0._spectated_player = Managers.player:owner(arg_3_1)
	arg_3_0._is_spectator = true
end

function CareerAbilityBarUI._set_player_extensions(arg_4_0, arg_4_1)
	arg_4_0._inventory_extension = ScriptUnit.extension(arg_4_1, "inventory_system")
	arg_4_0._initialize_ability_bar = true
end

function CareerAbilityBarUI._update_career_ability(arg_5_0, arg_5_1, arg_5_2)
	if not arg_5_1 then
		return
	end

	local var_5_0 = arg_5_1.player_unit

	if not Unit.alive(var_5_0) then
		return
	end

	local var_5_1 = ScriptUnit.extension(var_5_0, "inventory_system")

	if not var_5_1:equipment() then
		return
	end

	if not (var_5_1:get_wielded_slot_name() == "slot_career_skill_weapon") then
		return
	end

	local var_5_2 = ScriptUnit.extension(var_5_0, "career_system")
	local var_5_3 = var_5_2:career_name()
	local var_5_4 = var_5_2:profile_index()
	local var_5_5 = var_5_2:career_index()

	if CareerUtils.get_ability_data(var_5_4, var_5_5, 1).show_gamepad_ability_bar then
		local var_5_6, var_5_7, var_5_8, var_5_9 = arg_5_0:_get_ability_amount(var_5_0)

		arg_5_0:_set_ability_bar_fraction(var_5_6, var_5_7, var_5_8, var_5_9)

		return true
	end
end

function CareerAbilityBarUI._create_ui_elements(arg_6_0)
	UIRenderer.clear_scenegraph_queue(arg_6_0._ui_renderer)

	arg_6_0._ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)

	local var_6_0 = var_0_0.inventory_entry_definitions

	arg_6_0._ability_bar = UIWidget.init(var_0_0.widget_definitions.ability_bar)
	var_0_1 = false
end

function CareerAbilityBarUI.update(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	if var_0_1 then
		arg_7_0:_create_ui_elements()
	end

	local var_7_0 = arg_7_0._input_manager

	if not ((var_7_0:is_device_active("gamepad") or UISettings.use_gamepad_hud_layout == "always") and UISettings.use_gamepad_hud_layout ~= "never") then
		return
	end

	arg_7_0:_update_game_options()

	local var_7_1 = arg_7_0._is_spectator and arg_7_0._spectated_player or arg_7_3
	local var_7_2 = arg_7_0:_update_career_ability(var_7_1, arg_7_1)
	local var_7_3 = Managers.twitch:is_activated()

	if var_7_3 ~= arg_7_0._has_twitch then
		arg_7_0._ability_bar.offset[2] = var_7_3 and 140 or 0
		arg_7_0._has_twitch = var_7_3
		var_7_2 = true
	end

	if var_7_2 then
		local var_7_4 = arg_7_0._ui_scenegraph
		local var_7_5 = var_7_0:get_service("ingame_menu")
		local var_7_6, var_7_7 = arg_7_0._parent:get_crosshair_position()

		arg_7_0:_apply_crosshair_position(var_7_6, var_7_7)

		local var_7_8 = arg_7_0._ui_renderer

		UIRenderer.begin_pass(var_7_8, var_7_4, var_7_5, arg_7_1, nil, arg_7_0._render_settings)
		UIRenderer.draw_widget(var_7_8, arg_7_0._ability_bar)
		UIRenderer.end_pass(var_7_8)
	end
end

local var_0_2 = {
	normal = {
		255,
		223,
		133,
		228
	},
	medium = {
		255,
		223,
		133,
		228
	},
	high = {
		255,
		223,
		133,
		228
	}
}

function CareerAbilityBarUI._set_ability_bar_fraction(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = arg_8_0._ability_bar
	local var_8_1 = var_8_0.style
	local var_8_2 = var_8_0.content
	local var_8_3 = var_8_2.size

	arg_8_1 = math.lerp(var_8_2.internal_gradient_threshold or 0, math.min(arg_8_1, 1), 0.3)
	var_8_2.internal_gradient_threshold = arg_8_1

	local var_8_4 = 0
	local var_8_5 = 1
	local var_8_6 = math.min(arg_8_1, arg_8_2) * var_8_5
	local var_8_7 = math.min(arg_8_1, arg_8_3) * var_8_5
	local var_8_8 = arg_8_1 * var_8_5

	var_8_1.bar_1.gradient_threshold = var_8_8

	local var_8_9 = 1
	local var_8_10
	local var_8_11 = var_8_1.icon.color
	local var_8_12 = var_8_1.bar_1.color

	if arg_8_1 <= arg_8_2 then
		var_8_10 = var_0_2.normal
	elseif arg_8_1 <= arg_8_3 then
		var_8_10 = var_0_2.medium
	else
		var_8_10 = var_0_2.high
	end

	var_8_12[1] = var_8_10[1]
	var_8_12[2] = var_8_10[2]
	var_8_12[3] = var_8_10[3]
	var_8_12[4] = var_8_10[4]

	local var_8_13 = 10
	local var_8_14 = 1 - arg_8_1
	local var_8_15 = math.min(math.max(var_8_14 - arg_8_3, 0) / (1 - arg_8_3) * 1.3, 1)
	local var_8_16 = math.min(math.max(var_8_14 - arg_8_4, 0) / (1 - arg_8_4) * 1.3, 1)
	local var_8_17 = 100 + (0.5 + math.sin(Managers.time:time("ui") * var_8_13) * 0.5) * 155

	var_8_1.frame.color[1] = var_8_17 * var_8_15
	var_8_11[1] = var_8_17 * var_8_16
	var_8_11[2] = 255
	var_8_11[3] = 255
	var_8_11[4] = 255
	var_8_1.input_text.text_color[1] = var_8_17 * var_8_16
	var_8_1.input_text_shadow.text_color[1] = var_8_17 * var_8_16 * var_8_16
	var_8_1.ability_bar_highlight.texture_size[1] = 250 * arg_8_1

	local var_8_18 = Managers.time:time("main") * 0.25

	var_8_2.ability_bar_highlight.uvs[1][1] = var_8_18 % 1
	var_8_2.ability_bar_highlight.uvs[2][1] = (0.5 + var_8_18) % 1
end

function CareerAbilityBarUI.destroy(arg_9_0)
	local var_9_0 = Managers.state.event

	var_9_0:unregister("on_spectator_target_changed", arg_9_0)
	var_9_0:unregister("on_game_options_changed", arg_9_0)
end

function CareerAbilityBarUI.set_alpha(arg_10_0, arg_10_1)
	arg_10_0._render_settings.alpha_multiplier = arg_10_1
end

function CareerAbilityBarUI._apply_crosshair_position(arg_11_0, arg_11_1, arg_11_2)
	local var_11_0 = "screen_bottom_pivot"
	local var_11_1 = arg_11_0._ui_scenegraph[var_11_0].local_position

	var_11_1[1] = arg_11_1
	var_11_1[2] = arg_11_2
end

function CareerAbilityBarUI._set_game_options_dirty(arg_12_0)
	arg_12_0._game_options_dirty = true
end

function CareerAbilityBarUI._update_game_options(arg_13_0)
	if not arg_13_0._game_options_dirty then
		return
	end

	arg_13_0:_update_gamepad_input_button()

	arg_13_0._game_options_dirty = false
end

function CareerAbilityBarUI._update_gamepad_input_button(arg_14_0)
	local var_14_0 = Managers.input:get_service("Player")
	local var_14_1 = "weapon_reload_input"
	local var_14_2 = true
	local var_14_3, var_14_4, var_14_5, var_14_6 = UISettings.get_gamepad_input_texture_data(var_14_0, var_14_1, var_14_2)
	local var_14_7 = arg_14_0._ability_bar
	local var_14_8 = var_14_7.style
	local var_14_9 = var_14_7.content

	if var_14_3 then
		var_14_9.icon = var_14_3.texture
		var_14_9.input_text = ""

		local var_14_10 = var_14_8.icon.texture_size
		local var_14_11 = var_14_8.icon_shadow.texture_size
		local var_14_12 = var_14_3.size

		var_14_10[1] = var_14_12[1]
		var_14_10[2] = var_14_12[2]
		var_14_11[1] = var_14_12[1]
		var_14_11[2] = var_14_12[2]
	end
end
