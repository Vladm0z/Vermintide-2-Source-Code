-- chunkname: @scripts/ui/views/crosshair_ui.lua

local var_0_0 = local_require("scripts/ui/views/crosshair_ui_definitions")
local var_0_1 = var_0_0.scenegraph_definition
local var_0_2 = var_0_0.animations_definitions
local var_0_3 = var_0_0.MAX_SIZE

CrosshairUI = class(CrosshairUI)

local var_0_4 = {
	default = "draw_default_style_crosshair",
	circle = "draw_circle_style_crosshair",
	wh_priest = "draw_wh_priest_style_crosshair",
	shotgun = "draw_shotgun_style_crosshair",
	dot = "draw_dot_style_crosshair",
	arrows = "draw_arrows_style_crosshair",
	projectile = "draw_projectile_style_crosshair"
}
local var_0_5 = UISettings.crosshair_styles.melee
local var_0_6 = UISettings.crosshair_styles.ranged
local var_0_7 = require("scripts/ui/views/crosshair_kill_confirm_settings")
local var_0_8 = var_0_7.kill_confirm_enemy_types
local var_0_9 = var_0_7.kill_confirm_group_settings
local var_0_10 = var_0_7.kill_confirm_types
local var_0_11 = var_0_7.kill_confirm_type_colors
local var_0_12 = var_0_7.kill_confirm_enemy_prio
local var_0_13 = var_0_7.kill_confirm_weakspot_zones
local var_0_14 = var_0_7.kill_confirm_enemy_type_widget_map
local var_0_15 = var_0_7.kill_confirm_styles
local var_0_16 = 0.5
local var_0_17 = 30
local var_0_18 = 120

CrosshairUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.render_settings = {
		snap_pixel_positions = false
	}
	arg_1_0.local_player = Managers.player:local_player()
	arg_1_0._small_career_portrait = "small_unit_frame_portrait_default"

	Managers.state.event:register(arg_1_0, "on_set_ability_target_name", "_set_crosshair_target_info")

	arg_1_0._kill_confirm_enabled = false
	arg_1_0._kill_confirm_enabled_groups = var_0_9.off

	Managers.state.event:register(arg_1_0, "on_game_options_changed", "update_game_options")
	arg_1_0:update_game_options()
	arg_1_0:create_ui_elements()
	arg_1_0:update_enabled_crosshair_styles()
end

CrosshairUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_1)
	arg_2_0.crosshair_projectile = UIWidget.init(var_0_0.widget_definitions.crosshair_projectile)
	arg_2_0.crosshair_shotgun = UIWidget.init(var_0_0.widget_definitions.crosshair_shotgun)
	arg_2_0.crosshair_dot = UIWidget.init(var_0_0.widget_definitions.crosshair_dot)
	arg_2_0.crosshair_line = UIWidget.init(var_0_0.widget_definitions.crosshair_line)
	arg_2_0.crosshair_arrow = UIWidget.init(var_0_0.widget_definitions.crosshair_arrow)
	arg_2_0.crosshair_circle = UIWidget.init(var_0_0.widget_definitions.crosshair_circle)
	arg_2_0.wh_priest = UIWidget.init(var_0_0.widget_definitions.crosshair_wh_priest)
	arg_2_0._hit_armored_markers = {
		damage = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_damage),
		no_damage = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_no_damage),
		armor_break = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_break),
		armor_open = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_open)
	}

	local var_2_0 = {}
	local var_2_1 = 4

	for iter_2_0 = 1, var_2_1 do
		local var_2_2 = "crosshair_hit_" .. iter_2_0

		var_2_0[iter_2_0] = UIWidget.init(var_0_0.widget_definitions[var_2_2])
	end

	arg_2_0._ui_animator = UIAnimator:new(var_0_1, var_0_2)
	arg_2_0.hit_markers = var_2_0
	arg_2_0.hit_markers_n = var_2_1
	arg_2_0.hit_marker_animations = {}

	local var_2_3 = {}

	for iter_2_1, iter_2_2 in pairs(var_0_15) do
		var_0_0.widget_definitions.kill_confirm.content.texture_id = iter_2_2
		var_2_3[iter_2_1] = UIWidget.init(var_0_0.widget_definitions.kill_confirm)
	end

	arg_2_0.kill_confirm_widgets = var_2_3
	arg_2_0._last_kill_confirm_t = 0
end

CrosshairUI.update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = arg_3_3.player_unit

	if not var_3_0 then
		return
	end

	local var_3_1 = ScriptUnit.extension(var_3_0, "inventory_system"):equipment()
	local var_3_2, var_3_3 = arg_3_0._parent:get_crosshair_position()

	arg_3_0:_apply_crosshair_position(var_3_2, var_3_3)
	arg_3_0:update_enabled_crosshair_styles()
	arg_3_0:update_crosshair_style(var_3_1)
	arg_3_0:update_hit_markers(arg_3_1)
	arg_3_0:update_spread(arg_3_1, arg_3_2, var_3_1)
	arg_3_0:_update_self_to_ally_transition()
	arg_3_0:_update_animations(arg_3_1)
end

local var_0_19 = {}

CrosshairUI.update_enabled_crosshair_styles = function (arg_4_0)
	local var_4_0 = Application.user_setting("enabled_crosshairs")

	if arg_4_0._enabled_style ~= var_4_0 then
		table.clear(var_0_19)

		if var_4_0 == "melee" then
			for iter_4_0, iter_4_1 in pairs(var_0_5) do
				var_0_19[iter_4_0] = iter_4_1.enabled
			end
		elseif var_4_0 == "ranged" then
			for iter_4_2, iter_4_3 in pairs(var_0_6) do
				var_0_19[iter_4_2] = iter_4_3.enabled
			end
		elseif var_4_0 == "all" then
			for iter_4_4, iter_4_5 in pairs(var_0_5) do
				var_0_19[iter_4_4] = iter_4_5.enabled
			end

			for iter_4_6, iter_4_7 in pairs(var_0_6) do
				var_0_19[iter_4_6] = iter_4_7.enabled
			end
		end

		arg_4_0._enabled_style = var_4_0
		arg_4_0._enabled_crosshair_styles = var_0_19
	end
end

CrosshairUI.update_crosshair_style = function (arg_5_0, arg_5_1)
	local var_5_0 = Managers.state.game_mode

	if var_5_0 and var_5_0:has_activated_mutator("realism") then
		arg_5_0.crosshair_style = "dot"

		return
	end

	local var_5_1 = arg_5_1.wielded
	local var_5_2 = BackendUtils.get_item_template(var_5_1)
	local var_5_3 = var_5_2.crosshair_style
	local var_5_4 = arg_5_1.right_hand_wielded_unit or arg_5_1.left_hand_wielded_unit
	local var_5_5 = var_5_2.fire_at_gaze_setting

	if Unit.alive(var_5_4) then
		local var_5_6 = ScriptUnit.extension(var_5_4, "weapon_system")

		if var_5_6:has_current_action() then
			local var_5_7 = var_5_6:get_current_action_settings()
			local var_5_8 = var_5_6:get_current_action()

			if var_5_8 and var_5_8.crosshair_style then
				var_5_3 = var_5_8.crosshair_style
			elseif var_5_7.crosshair_style then
				var_5_3 = var_5_7.crosshair_style
			end

			if var_5_7.fire_at_gaze_setting then
				var_5_5 = var_5_7.fire_at_gaze_setting
			end
		end
	end

	if rawget(_G, "Tobii") then
		local var_5_9 = Tobii.get_is_connected()
		local var_5_10 = Application.user_setting("tobii_eyetracking")
		local var_5_11 = Application.user_setting("tobii_fire_at_gaze")

		if var_5_9 and var_5_10 and var_5_11 and var_5_5 then
			var_5_3 = "dot"
		end
	end

	arg_5_0.crosshair_style = var_5_3
end

CrosshairUI._apply_crosshair_position = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.ui_scenegraph.pivot.local_position

	var_6_0[1] = arg_6_1
	var_6_0[2] = arg_6_2
end

CrosshairUI.update_hit_markers = function (arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0.hit_markers
	local var_7_1 = arg_7_0.hit_markers_n
	local var_7_2 = arg_7_0.hit_marker_animations
	local var_7_3 = arg_7_0.local_player.player_unit
	local var_7_4 = ScriptUnit.extension(var_7_3, "hud_system").hit_marker_data

	if var_7_4.hit_enemy then
		local var_7_5 = true

		if var_7_4.friendly_fire and not Application.user_setting("friendly_fire_crosshair") then
			var_7_5 = false
		end

		if var_7_5 then
			arg_7_0:set_hit_marker_animation(var_7_0, var_7_1, var_7_2, var_7_4)
		end

		var_7_4.hit_enemy = nil
	end

	if var_7_2[1] then
		arg_7_0:update_hit_marker_animation(var_7_0, var_7_1, var_7_2, var_7_4, arg_7_1)
	end
end

CrosshairUI.set_hit_marker_animation = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	for iter_8_0 = 1, arg_8_2 do
		local var_8_0 = arg_8_1[iter_8_0]
		local var_8_1 = arg_8_0:configure_hit_marker_color_and_size(var_8_0, arg_8_4)

		arg_8_3[iter_8_0] = UIAnimation.init(UIAnimation.function_by_time, var_8_0.style.rotating_texture.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)

		if iter_8_0 == arg_8_2 and var_8_1 then
			arg_8_3[5] = UIAnimation.init(UIAnimation.function_by_time, var_8_1.style.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)
			arg_8_0.hit_marker_armored = var_8_1
		end
	end
end

local var_0_20 = 0.1

CrosshairUI.configure_hit_marker_color_and_size = function (arg_9_0, arg_9_1, arg_9_2)
	local var_9_0 = arg_9_2.damage_amount
	local var_9_1 = arg_9_2.damage_type
	local var_9_2 = arg_9_2.hit_zone
	local var_9_3 = arg_9_2.hit_critical
	local var_9_4 = arg_9_2.has_armor
	local var_9_5 = arg_9_2.friendly_fire
	local var_9_6 = arg_9_2.added_dot
	local var_9_7 = arg_9_2.shield_break
	local var_9_8 = arg_9_2.shield_open
	local var_9_9 = arg_9_2.invulnerable
	local var_9_10 = false
	local var_9_11 = false
	local var_9_12
	local var_9_13 = arg_9_0._hit_armored_markers
	local var_9_14 = var_0_0.hit_marker_configurations

	if var_9_9 or var_9_0 <= 0 and var_9_4 and not var_9_6 then
		var_9_11 = true
	elseif var_9_3 then
		var_9_10 = true
	end

	local var_9_15
	local var_9_16

	if var_9_7 then
		var_9_12 = var_9_13.armor_break
	elseif var_9_8 then
		var_9_12 = var_9_13.armor_open
	elseif var_9_11 and var_9_0 == 0 then
		var_9_12 = var_9_13.no_damage
	end

	if var_9_10 then
		var_9_15 = var_9_14.critical.color

		local var_9_17 = var_9_14.critical.size
	elseif var_9_5 then
		local var_9_18 = var_9_14.friendly.size

		var_9_15 = var_9_14.friendly.color
	elseif var_9_11 then
		local var_9_19 = var_9_14.armored.size

		var_9_15 = var_9_14.armored.color
	else
		local var_9_20 = var_9_14.normal.size

		var_9_15 = var_9_14.normal.color
	end

	if var_9_15 then
		local var_9_21 = arg_9_1.style.rotating_texture.color
		local var_9_22 = arg_9_1.style.rotating_texture.size

		var_9_21[2] = var_9_15[2]
		var_9_21[3] = var_9_15[3]
		var_9_21[4] = var_9_15[4]
	end

	return var_9_12
end

CrosshairUI.update_hit_marker_animation = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	for iter_10_0 = 1, arg_10_2 do
		local var_10_0 = arg_10_3[iter_10_0]

		UIAnimation.update(var_10_0, arg_10_5)
	end

	if arg_10_3[5] then
		local var_10_1 = arg_10_3[5]

		UIAnimation.update(var_10_1, arg_10_5)
	end

	if UIAnimation.completed(arg_10_3[1]) then
		for iter_10_1 = 1, arg_10_2 do
			arg_10_3[iter_10_1] = nil
		end

		arg_10_3[5] = nil
	end
end

CrosshairUI.update_spread = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	local var_11_0 = arg_11_3.wielded
	local var_11_1 = BackendUtils.get_item_template(var_11_0)
	local var_11_2 = 0
	local var_11_3 = 0

	if var_11_1.default_spread_template then
		local var_11_4 = arg_11_3.right_hand_wielded_unit or arg_11_3.left_hand_wielded_unit

		if var_11_4 and ScriptUnit.has_extension(var_11_4, "spread_system") then
			var_11_2, var_11_3 = ScriptUnit.extension(var_11_4, "spread_system"):get_current_pitch_and_yaw()
		end
	end

	local var_11_5 = SpreadTemplates.maximum_pitch
	local var_11_6 = SpreadTemplates.maximum_yaw
	local var_11_7 = var_11_2 / var_11_5
	local var_11_8 = var_11_3 / var_11_6
	local var_11_9 = math.lerp(0, var_0_0.max_spread_pitch, var_11_7)
	local var_11_10 = math.lerp(0, var_0_0.max_spread_yaw, var_11_8)

	arg_11_0:draw(arg_11_1, arg_11_2, var_11_7, var_11_8)
end

CrosshairUI.draw = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	local var_12_0 = arg_12_0.ui_renderer
	local var_12_1 = arg_12_0.ui_scenegraph
	local var_12_2 = arg_12_0.input_manager:get_service("ingame_menu")
	local var_12_3 = arg_12_0.render_settings

	UIRenderer.begin_pass(var_12_0, var_12_1, var_12_2, arg_12_1, nil, var_12_3)

	local var_12_4 = arg_12_0.crosshair_style

	if arg_12_0._enabled_crosshair_styles[var_12_4] then
		arg_12_0[var_0_4[var_12_4]](arg_12_0, var_12_0, arg_12_3, arg_12_4)
	end

	local var_12_5 = arg_12_0.hit_markers
	local var_12_6 = arg_12_0.hit_markers_n

	for iter_12_0 = 1, var_12_6 do
		local var_12_7 = var_12_5[iter_12_0]

		UIRenderer.draw_widget(var_12_0, var_12_7)
	end

	if arg_12_0.hit_marker_armored then
		UIRenderer.draw_widget(var_12_0, arg_12_0.hit_marker_armored)
	end

	arg_12_0:_draw_kill_confirm(arg_12_1, arg_12_2, var_12_0)
	UIRenderer.end_pass(var_12_0)
end

CrosshairUI.draw_default_style_crosshair = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	UIRenderer.draw_widget(arg_13_1, arg_13_0.crosshair_dot)

	local var_13_0 = 4
	local var_13_1 = 45
	local var_13_2 = 5
	local var_13_3 = 5

	arg_13_2 = math.max(0.0001, arg_13_2)
	arg_13_3 = math.max(0.0001, arg_13_3)

	for iter_13_0 = 1, var_13_0 do
		arg_13_0:_set_widget_point_offset(arg_13_0.crosshair_line, iter_13_0, var_13_0, arg_13_2, arg_13_3, var_13_1, var_13_2, var_13_3)
		UIRenderer.draw_widget(arg_13_1, arg_13_0.crosshair_line)
	end
end

CrosshairUI.draw_arrows_style_crosshair = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	UIRenderer.draw_widget(arg_14_1, arg_14_0.crosshair_dot)

	local var_14_0 = 4
	local var_14_1 = 45
	local var_14_2 = 5
	local var_14_3 = 5

	arg_14_2 = math.max(0.0001, arg_14_2)
	arg_14_3 = math.max(0.0001, arg_14_3)

	for iter_14_0 = 1, var_14_0 do
		arg_14_0:_set_widget_point_offset(arg_14_0.crosshair_arrow, iter_14_0, var_14_0, arg_14_2, arg_14_3, var_14_1, var_14_2, var_14_3)
		UIRenderer.draw_widget(arg_14_1, arg_14_0.crosshair_arrow)
	end
end

CrosshairUI.draw_shotgun_style_crosshair = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3)
	UIRenderer.draw_widget(arg_15_1, arg_15_0.crosshair_dot)

	local var_15_0 = 4
	local var_15_1 = 45
	local var_15_2 = 0
	local var_15_3 = 0

	arg_15_2 = math.max(0.0001, arg_15_2)
	arg_15_3 = math.max(0.0001, arg_15_3)

	for iter_15_0 = 1, var_15_0 do
		arg_15_0:_set_widget_point_offset(arg_15_0.crosshair_shotgun, iter_15_0, var_15_0, arg_15_2, arg_15_3, var_15_1, var_15_2, var_15_3)
		UIRenderer.draw_widget(arg_15_1, arg_15_0.crosshair_shotgun)
	end
end

CrosshairUI.draw_projectile_style_crosshair = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	UIRenderer.draw_widget(arg_16_1, arg_16_0.crosshair_dot)
	UIRenderer.draw_widget(arg_16_1, arg_16_0.crosshair_projectile)

	local var_16_0 = 2
	local var_16_1 = 0
	local var_16_2 = 6
	local var_16_3 = 0

	arg_16_2 = math.max(0.0001, arg_16_2)
	arg_16_3 = math.max(0.0001, arg_16_3)

	for iter_16_0 = 1, var_16_0 do
		arg_16_0:_set_widget_point_offset(arg_16_0.crosshair_line, iter_16_0, var_16_0, arg_16_2, arg_16_3, var_16_1, var_16_2, var_16_3)
		UIRenderer.draw_widget(arg_16_1, arg_16_0.crosshair_line)
	end
end

CrosshairUI.draw_dot_style_crosshair = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	UIRenderer.draw_widget(arg_17_1, arg_17_0.crosshair_dot)
end

CrosshairUI.draw_circle_style_crosshair = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	UIRenderer.draw_widget(arg_18_1, arg_18_0.crosshair_circle)
end

CrosshairUI.draw_wh_priest_style_crosshair = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	UIRenderer.draw_widget(arg_19_1, arg_19_0.wh_priest)
end

CrosshairUI._set_widget_point_offset = function (arg_20_0, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8)
	local var_20_0, var_20_1, var_20_2 = arg_20_0:_get_point_offset(arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local var_20_3 = arg_20_1.style
	local var_20_4 = var_20_3.offset
	local var_20_5 = var_20_3.pivot

	arg_20_7 = arg_20_7 or 0
	arg_20_8 = arg_20_8 or 0
	var_20_4[1] = var_20_0 + arg_20_7 * math.sign(var_20_0)
	var_20_4[2] = var_20_1 + arg_20_8 * math.sign(var_20_1)
	var_20_3.angle = -var_20_2
end

CrosshairUI._get_point_offset = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	local var_21_0 = var_0_3
	local var_21_1 = 0
	local var_21_2 = 0
	local var_21_3 = var_21_0 * arg_21_3
	local var_21_4 = var_21_0 * arg_21_4
	local var_21_5 = -(((arg_21_5 or 0) / 360 % 1 + (arg_21_1 - 1) / arg_21_2) % 1 * 360 * math.pi / 180)
	local var_21_6 = var_21_2 + var_21_3 * math.sin(var_21_5)

	return var_21_1 + var_21_4 * math.cos(var_21_5), var_21_6, var_21_5
end

CrosshairUI._set_crosshair_target_info = function (arg_22_0, arg_22_1, arg_22_2)
	local var_22_0 = arg_22_0.wh_priest.content

	var_22_0.state = arg_22_2
	var_22_0.career_portrait = arg_22_1 and arg_22_1 or arg_22_0._small_career_portrait
	var_22_0.text_id = "$KEY;Player__action_one:"
	arg_22_0._small_career_portrait = arg_22_1 and arg_22_1 or arg_22_0._small_career_portrait
end

CrosshairUI._update_self_to_ally_transition = function (arg_23_0)
	local var_23_0 = arg_23_0.wh_priest.content

	if var_23_0.state ~= arg_23_0.state then
		local var_23_1 = var_23_0.state == "wh_priest_self" and "ally_to_self" or "self_to_ally"

		arg_23_0.wh_crosshair_anim = arg_23_0._ui_animator:start_animation(var_23_1, arg_23_0.wh_priest, var_0_1)
	end

	arg_23_0.state = var_23_0.state
end

CrosshairUI._update_animations = function (arg_24_0, arg_24_1)
	arg_24_0._ui_animator:update(arg_24_1)
end

CrosshairUI.destroy = function (arg_25_0)
	Managers.state.event:unregister("on_set_ability_target_name", arg_25_0)
	Managers.state.event:unregister("on_game_options_changed", arg_25_0)
end

CrosshairUI.update_game_options = function (arg_26_0)
	local var_26_0 = Application.user_setting("crosshair_kill_confirm")
	local var_26_1 = var_26_0 ~= CrosshairKillConfirmSettingsGroups.off

	arg_26_0._kill_confirm_enabled_groups = var_0_9[var_26_0]

	if var_26_1 and not arg_26_0._kill_confirm_enabled then
		arg_26_0._kill_confirm_enabled = true

		Managers.state.event:register(arg_26_0, "on_player_killed_enemy", "_register_kill_confirm")
	elseif not var_26_1 and arg_26_0._kill_confirm_enabled then
		arg_26_0._kill_confirm_enabled = false

		Managers.state.event:unregister("on_player_killed_enemy", arg_26_0)

		arg_26_0._current_kill_confirm_widget = nil
	end
end

CrosshairUI._register_kill_confirm = function (arg_27_0, arg_27_1, arg_27_2, arg_27_3)
	if not arg_27_0._kill_confirm_enabled_groups or arg_27_0._kill_confirm_enabled_groups == var_0_9.off then
		return
	end

	local var_27_0 = arg_27_0.local_player.player_unit
	local var_27_1

	if arg_27_1[DamageDataIndex.ATTACKER] == var_27_0 or arg_27_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] == var_27_0 then
		if arg_27_1[DamageDataIndex.DAMAGE_SOURCE_NAME] == "dot_debuff" then
			var_27_1 = var_0_10.kill_dot
		elseif var_0_13[arg_27_1[DamageDataIndex.HIT_ZONE]] then
			var_27_1 = var_0_10.kill_weakpoint
		else
			var_27_1 = var_0_10.kill
		end
	end

	if var_27_1 then
		local var_27_2 = var_0_8.infantry

		if arg_27_2.elite then
			var_27_2 = var_0_8.elite
		elseif arg_27_2.special then
			var_27_2 = var_0_8.special
		elseif arg_27_2.boss then
			var_27_2 = var_0_8.boss
		end

		if arg_27_0._kill_confirm_enabled_groups[var_27_2] and (not arg_27_0._current_kill_confirm_type or not arg_27_0._current_kill_confirm_widget or var_0_12[arg_27_0._current_kill_confirm_type] <= var_0_12[var_27_2] or arg_27_0._current_kill_confirm_widget.style.color[1] <= var_0_18) then
			local var_27_3 = var_0_14[var_27_2]
			local var_27_4 = arg_27_0.kill_confirm_widgets[var_27_3]

			if var_27_4 then
				var_27_4.style.color = var_0_11[var_27_1]
			end

			arg_27_0._current_kill_confirm_widget = var_27_4
			arg_27_0._current_kill_confirm_type = var_27_2
			arg_27_0._last_kill_confirm_t = Managers.time:time("ui")
		end
	end
end

CrosshairUI._draw_kill_confirm = function (arg_28_0, arg_28_1, arg_28_2, arg_28_3)
	if not arg_28_0._current_kill_confirm_widget then
		return
	end

	local var_28_0 = arg_28_2 - arg_28_0._last_kill_confirm_t

	if var_28_0 > var_0_16 then
		arg_28_0._current_kill_confirm_widget = nil
		arg_28_0._current_kill_confirm_type = nil

		return
	end

	local var_28_1 = (1 - math.easeInCubic(var_28_0 / var_0_16)) * 255
	local var_28_2 = arg_28_0._current_kill_confirm_widget

	var_28_2.style.color[1] = var_28_1

	UIRenderer.draw_widget(arg_28_3, var_28_2)
end
