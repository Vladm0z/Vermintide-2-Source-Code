-- chunkname: @scripts/ui/views/crosshair_ui.lua

local var_0_0 = local_require("scripts/ui/views/crosshair_ui_definitions")
local scenegraph_definition = var_0_0.scenegraph_definition
local animations_definitions = var_0_0.animations_definitions
local MAX_SIZE = var_0_0.MAX_SIZE

CrosshairUI = class(CrosshairUI)

local tbl = {
	default = "draw_default_style_crosshair",
	circle = "draw_circle_style_crosshair",
	wh_priest = "draw_wh_priest_style_crosshair",
	shotgun = "draw_shotgun_style_crosshair",
	dot = "draw_dot_style_crosshair",
	arrows = "draw_arrows_style_crosshair",
	projectile = "draw_projectile_style_crosshair"
}
local melee = UISettings.crosshair_styles.melee
local ranged = UISettings.crosshair_styles.ranged
local scripts_ui_views_crosshair_kill_confirm_settings = require("scripts/ui/views/crosshair_kill_confirm_settings")
local kill_confirm_enemy_types = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_enemy_types
local kill_confirm_group_settings = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_group_settings
local kill_confirm_types = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_types
local kill_confirm_type_colors = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_type_colors
local kill_confirm_enemy_prio = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_enemy_prio
local kill_confirm_weakspot_zones = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_weakspot_zones
local kill_confirm_enemy_type_widget_map = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_enemy_type_widget_map
local kill_confirm_styles = scripts_ui_views_crosshair_kill_confirm_settings.kill_confirm_styles
local num = 0.5
local num_2 = 30
local num_3 = 120

CrosshairUI.init = function (self, arg_1_1, arg_1_2)
	-- function 1
	self._parent = arg_1_1
	self.ui_renderer = arg_1_2.ui_renderer
	self.ingame_ui = arg_1_2.ingame_ui
	self.input_manager = arg_1_2.input_manager
	self.render_settings = {
		snap_pixel_positions = false
	}
	self.local_player = Managers.player:local_player()
	self._small_career_portrait = "small_unit_frame_portrait_default"

	Managers.state.event:register(self, "on_set_ability_target_name", "_set_crosshair_target_info")

	self._kill_confirm_enabled = false
	self._kill_confirm_enabled_groups = kill_confirm_group_settings.off

	Managers.state.event:register(self, "on_game_options_changed", "update_game_options")
	self:update_game_options()
	self:create_ui_elements()
	self:update_enabled_crosshair_styles()
end

CrosshairUI.create_ui_elements = function (self)
	-- function 2
	self.ui_scenegraph = UISceneGraph.init_scenegraph(scenegraph_definition)
	self.crosshair_projectile = UIWidget.init(var_0_0.widget_definitions.crosshair_projectile)
	self.crosshair_shotgun = UIWidget.init(var_0_0.widget_definitions.crosshair_shotgun)
	self.crosshair_dot = UIWidget.init(var_0_0.widget_definitions.crosshair_dot)
	self.crosshair_line = UIWidget.init(var_0_0.widget_definitions.crosshair_line)
	self.crosshair_arrow = UIWidget.init(var_0_0.widget_definitions.crosshair_arrow)
	self.crosshair_circle = UIWidget.init(var_0_0.widget_definitions.crosshair_circle)
	self.wh_priest = UIWidget.init(var_0_0.widget_definitions.crosshair_wh_priest)
	self._hit_armored_markers = {
		damage = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_damage),
		no_damage = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_no_damage),
		armor_break = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_break),
		armor_open = UIWidget.init(var_0_0.widget_definitions.crosshair_hit_armored_open)
	}

	local tbl = {}
	local num = 4

	for i = 1, num do
		local str = "crosshair_hit_" .. i

		tbl[i] = UIWidget.init(var_0_0.widget_definitions[str])
	end

	self._ui_animator = UIAnimator:new(scenegraph_definition, animations_definitions)
	self.hit_markers = tbl
	self.hit_markers_n = num
	self.hit_marker_animations = {}

	local tbl_2 = {}

	for k, v in pairs(kill_confirm_styles) do
		var_0_0.widget_definitions.kill_confirm.content.texture_id = v
		tbl_2[k] = UIWidget.init(var_0_0.widget_definitions.kill_confirm)
	end

	self.kill_confirm_widgets = tbl_2
	self._last_kill_confirm_t = 0
end

CrosshairUI.update = function (self, arg_3_1, arg_3_2, arg_3_3)
	-- function 3
	local player_unit = arg_3_3.player_unit

	if not player_unit then
		return
	end

	local equipment = ScriptUnit.extension(player_unit, "inventory_system"):equipment()
	local get_crosshair_position, var_3_3 = self._parent:get_crosshair_position()

	self:_apply_crosshair_position(get_crosshair_position, var_3_3)
	self:update_enabled_crosshair_styles()
	self:update_crosshair_style(equipment)
	self:update_hit_markers(arg_3_1)
	self:update_spread(arg_3_1, arg_3_2, equipment)
	self:_update_self_to_ally_transition()
	self:_update_animations(arg_3_1)
end

local tbl_2 = {}

CrosshairUI.update_enabled_crosshair_styles = function (self)
	-- function 4
	local user_setting = Application.user_setting("enabled_crosshairs")

	if self._enabled_style ~= user_setting then
		table.clear(tbl_2)

		if user_setting == "melee" then
			for k, v in pairs(melee) do
				tbl_2[k] = v.enabled
			end
		elseif user_setting == "ranged" then
			for k_2, v_2 in pairs(ranged) do
				tbl_2[k_2] = v_2.enabled
			end
		elseif user_setting == "all" then
			for k_3, v_3 in pairs(melee) do
				tbl_2[k_3] = v_3.enabled
			end

			for k_4, v_4 in pairs(ranged) do
				tbl_2[k_4] = v_4.enabled
			end
		end

		self._enabled_style = user_setting
		self._enabled_crosshair_styles = tbl_2
	end
end

CrosshairUI.update_crosshair_style = function (self, arg_5_1)
	-- function 5
	local game_mode = Managers.state.game_mode

	if not (not game_mode and game_mode:has_activated_mutator("realism")) then
		self.crosshair_style = "dot"

		return
	end

	local wielded = arg_5_1.wielded
	local get_item_template = BackendUtils.get_item_template(wielded)
	local crosshair_style = get_item_template.crosshair_style
	local right_hand_wielded_unit = arg_5_1.right_hand_wielded_unit

	right_hand_wielded_unit = right_hand_wielded_unit or arg_5_1.left_hand_wielded_unit

	local fire_at_gaze_setting = get_item_template.fire_at_gaze_setting

	if not Unit.alive(right_hand_wielded_unit) then
		local extension = ScriptUnit.extension(right_hand_wielded_unit, "weapon_system")

		if not extension:has_current_action() then
			local get_current_action_settings = extension:get_current_action_settings()
			local get_current_action = extension:get_current_action()

			if not get_current_action and not get_current_action.crosshair_style then
				crosshair_style = get_current_action.crosshair_style
			elseif not get_current_action_settings.crosshair_style then
				crosshair_style = get_current_action_settings.crosshair_style
			end

			if not get_current_action_settings.fire_at_gaze_setting then
				fire_at_gaze_setting = get_current_action_settings.fire_at_gaze_setting
			end
		end
	end

	if not rawget(_G, "Tobii") then
		local get_is_connected = Tobii.get_is_connected()
		local user_setting = Application.user_setting("tobii_eyetracking")
		local user_setting_2 = Application.user_setting("tobii_fire_at_gaze")

		if not get_is_connected and not user_setting and not user_setting_2 and not fire_at_gaze_setting then
			crosshair_style = "dot"
		end
	end

	self.crosshair_style = crosshair_style
end

CrosshairUI._apply_crosshair_position = function (self, arg_6_1, arg_6_2)
	-- function 6
	local local_position = self.ui_scenegraph.pivot.local_position

	local_position[1] = arg_6_1
	local_position[2] = arg_6_2
end

CrosshairUI.update_hit_markers = function (self, arg_7_1)
	-- function 7
	local hit_markers = self.hit_markers
	local hit_markers_n = self.hit_markers_n
	local hit_marker_animations = self.hit_marker_animations
	local player_unit = self.local_player.player_unit
	local hit_marker_data = ScriptUnit.extension(player_unit, "hud_system").hit_marker_data

	if not hit_marker_data.hit_enemy then
		local flag = true

		if not (not hit_marker_data.friendly_fire and Application.user_setting("friendly_fire_crosshair")) then
			flag = false
		end

		if not flag then
			self:set_hit_marker_animation(hit_markers, hit_markers_n, hit_marker_animations, hit_marker_data)
		end

		hit_marker_data.hit_enemy = nil
	end

	if not hit_marker_animations[1] then
		self:update_hit_marker_animation(hit_markers, hit_markers_n, hit_marker_animations, hit_marker_data, arg_7_1)
	end
end

CrosshairUI.set_hit_marker_animation = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	-- function 8
	for i = 1, arg_8_2 do
		local var_8_0 = arg_8_1[i]
		local configure_hit_marker_color_and_size = self:configure_hit_marker_color_and_size(var_8_0, arg_8_4)

		arg_8_3[i] = UIAnimation.init(UIAnimation.function_by_time, var_8_0.style.rotating_texture.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)

		if i ~= arg_8_2 or not configure_hit_marker_color_and_size then
			arg_8_3[5] = UIAnimation.init(UIAnimation.function_by_time, configure_hit_marker_color_and_size.style.color, 1, 255, 0, UISettings.crosshair.hit_marker_fade, math.easeInCubic)
			self.hit_marker_armored = configure_hit_marker_color_and_size
		end
	end
end

local num_4 = 0.1

CrosshairUI.configure_hit_marker_color_and_size = function (self, arg_9_1, arg_9_2)
	-- function 9
	local damage_amount = arg_9_2.damage_amount
	local damage_type = arg_9_2.damage_type
	local hit_zone = arg_9_2.hit_zone
	local hit_critical = arg_9_2.hit_critical
	local has_armor = arg_9_2.has_armor
	local friendly_fire = arg_9_2.friendly_fire
	local added_dot = arg_9_2.added_dot
	local shield_break = arg_9_2.shield_break
	local shield_open = arg_9_2.shield_open
	local invulnerable = arg_9_2.invulnerable
	local flag = false
	local flag_2 = false
	local var_9_12
	local _hit_armored_markers = self._hit_armored_markers
	local hit_marker_configurations = var_0_0.hit_marker_configurations

	if not ((invulnerable or not (damage_amount <= 0) or not has_armor) and added_dot) then
		flag_2 = true
	elseif not hit_critical then
		flag = true
	end

	local var_9_15
	local var_9_16

	if not shield_break then
		var_9_12 = _hit_armored_markers.armor_break
	elseif not shield_open then
		var_9_12 = _hit_armored_markers.armor_open
	elseif not (not flag_2 and damage_amount ~= 0) then
		var_9_12 = _hit_armored_markers.no_damage
	end

	if not flag then
		var_9_15 = hit_marker_configurations.critical.color

		local size = hit_marker_configurations.critical.size
	elseif not friendly_fire then
		local size_2 = hit_marker_configurations.friendly.size

		var_9_15 = hit_marker_configurations.friendly.color
	elseif not flag_2 then
		local size_3 = hit_marker_configurations.armored.size

		var_9_15 = hit_marker_configurations.armored.color
	else
		local size_4 = hit_marker_configurations.normal.size

		var_9_15 = hit_marker_configurations.normal.color
	end

	if not var_9_15 then
		local color = arg_9_1.style.rotating_texture.color
		local size_5 = arg_9_1.style.rotating_texture.size

		color[2] = var_9_15[2]
		color[3] = var_9_15[3]
		color[4] = var_9_15[4]
	end

	return var_9_12
end

CrosshairUI.update_hit_marker_animation = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	for i = 1, arg_10_2 do
		local var_10_0 = arg_10_3[i]

		UIAnimation.update(var_10_0, arg_10_5)
	end

	if not arg_10_3[5] then
		local var_10_1 = arg_10_3[5]

		UIAnimation.update(var_10_1, arg_10_5)
	end

	if not UIAnimation.completed(arg_10_3[1]) then
		for j = 1, arg_10_2 do
			arg_10_3[j] = nil
		end

		arg_10_3[5] = nil
	end
end

CrosshairUI.update_spread = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local wielded = arg_11_3.wielded
	local get_item_template = BackendUtils.get_item_template(wielded)
	local num = 0
	local num_2 = 0

	if not get_item_template.default_spread_template then
		local right_hand_wielded_unit = arg_11_3.right_hand_wielded_unit

		right_hand_wielded_unit = right_hand_wielded_unit or arg_11_3.left_hand_wielded_unit

		if not right_hand_wielded_unit and not ScriptUnit.has_extension(right_hand_wielded_unit, "spread_system") then
			num, num_2 = ScriptUnit.extension(right_hand_wielded_unit, "spread_system"):get_current_pitch_and_yaw()
		end
	end

	local maximum_pitch = SpreadTemplates.maximum_pitch
	local maximum_yaw = SpreadTemplates.maximum_yaw
	local num_3 = num / maximum_pitch
	local num_4 = num_2 / maximum_yaw
	local lerp = math.lerp(0, var_0_0.max_spread_pitch, num_3)
	local lerp_2 = math.lerp(0, var_0_0.max_spread_yaw, num_4)

	self:draw(arg_11_1, arg_11_2, num_3, num_4)
end

CrosshairUI.draw = function (self, arg_12_1, arg_12_2, arg_12_3, arg_12_4)
	-- function 12
	local ui_renderer = self.ui_renderer
	local ui_scenegraph = self.ui_scenegraph
	local get_service = self.input_manager:get_service("ingame_menu")
	local render_settings = self.render_settings

	UIRenderer.begin_pass(ui_renderer, ui_scenegraph, get_service, arg_12_1, nil, render_settings)

	local crosshair_style = self.crosshair_style

	if not self._enabled_crosshair_styles[crosshair_style] then
		self[tbl[crosshair_style]](self, ui_renderer, arg_12_3, arg_12_4)
	end

	local hit_markers = self.hit_markers
	local hit_markers_n = self.hit_markers_n

	for i = 1, hit_markers_n do
		local var_12_7 = hit_markers[i]

		UIRenderer.draw_widget(ui_renderer, var_12_7)
	end

	if not self.hit_marker_armored then
		UIRenderer.draw_widget(ui_renderer, self.hit_marker_armored)
	end

	self:_draw_kill_confirm(arg_12_1, arg_12_2, ui_renderer)
	UIRenderer.end_pass(ui_renderer)
end

CrosshairUI.draw_default_style_crosshair = function (self, arg_13_1, arg_13_2, arg_13_3)
	-- function 13
	UIRenderer.draw_widget(arg_13_1, self.crosshair_dot)

	local num = 4
	local num_2 = 45
	local num_3 = 5
	local num_4 = 5

	arg_13_2 = math.max(0.0001, arg_13_2)
	arg_13_3 = math.max(0.0001, arg_13_3)

	for i = 1, num do
		self:_set_widget_point_offset(self.crosshair_line, i, num, arg_13_2, arg_13_3, num_2, num_3, num_4)
		UIRenderer.draw_widget(arg_13_1, self.crosshair_line)
	end
end

CrosshairUI.draw_arrows_style_crosshair = function (self, arg_14_1, arg_14_2, arg_14_3)
	-- function 14
	UIRenderer.draw_widget(arg_14_1, self.crosshair_dot)

	local num = 4
	local num_2 = 45
	local num_3 = 5
	local num_4 = 5

	arg_14_2 = math.max(0.0001, arg_14_2)
	arg_14_3 = math.max(0.0001, arg_14_3)

	for i = 1, num do
		self:_set_widget_point_offset(self.crosshair_arrow, i, num, arg_14_2, arg_14_3, num_2, num_3, num_4)
		UIRenderer.draw_widget(arg_14_1, self.crosshair_arrow)
	end
end

CrosshairUI.draw_shotgun_style_crosshair = function (self, arg_15_1, arg_15_2, arg_15_3)
	-- function 15
	UIRenderer.draw_widget(arg_15_1, self.crosshair_dot)

	local num = 4
	local num_2 = 45
	local num_3 = 0
	local num_4 = 0

	arg_15_2 = math.max(0.0001, arg_15_2)
	arg_15_3 = math.max(0.0001, arg_15_3)

	for i = 1, num do
		self:_set_widget_point_offset(self.crosshair_shotgun, i, num, arg_15_2, arg_15_3, num_2, num_3, num_4)
		UIRenderer.draw_widget(arg_15_1, self.crosshair_shotgun)
	end
end

CrosshairUI.draw_projectile_style_crosshair = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	UIRenderer.draw_widget(arg_16_1, self.crosshair_dot)
	UIRenderer.draw_widget(arg_16_1, self.crosshair_projectile)

	local num = 2
	local num_2 = 0
	local num_3 = 6
	local num_4 = 0

	arg_16_2 = math.max(0.0001, arg_16_2)
	arg_16_3 = math.max(0.0001, arg_16_3)

	for i = 1, num do
		self:_set_widget_point_offset(self.crosshair_line, i, num, arg_16_2, arg_16_3, num_2, num_3, num_4)
		UIRenderer.draw_widget(arg_16_1, self.crosshair_line)
	end
end

CrosshairUI.draw_dot_style_crosshair = function (self, arg_17_1, arg_17_2, arg_17_3)
	-- function 17
	UIRenderer.draw_widget(arg_17_1, self.crosshair_dot)
end

CrosshairUI.draw_circle_style_crosshair = function (self, arg_18_1, arg_18_2, arg_18_3)
	-- function 18
	UIRenderer.draw_widget(arg_18_1, self.crosshair_circle)
end

CrosshairUI.draw_wh_priest_style_crosshair = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	UIRenderer.draw_widget(arg_19_1, self.wh_priest)
end

CrosshairUI._set_widget_point_offset = function (self, arg_20_1, arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6, arg_20_7, arg_20_8)
	-- function 20
	local _get_point_offset, var_20_1, var_20_2 = self:_get_point_offset(arg_20_2, arg_20_3, arg_20_4, arg_20_5, arg_20_6)
	local style = arg_20_1.style
	local offset = style.offset
	local pivot = style.pivot

	arg_20_7 = arg_20_7 or 0
	arg_20_8 = arg_20_8 or 0
	offset[1] = _get_point_offset + arg_20_7 * math.sign(_get_point_offset)
	offset[2] = var_20_1 + arg_20_8 * math.sign(var_20_1)
	style.angle = -var_20_2
end

CrosshairUI._get_point_offset = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
	-- function 21
	local var_21_0 = MAX_SIZE
	local num = 0
	local num_2 = 0
	local num_3 = var_21_0 * arg_21_3
	local num_4 = var_21_0 * arg_21_4
	local num_5 = -(((arg_21_5 or 0) / 360 % 1 + (arg_21_1 - 1) / arg_21_2) % 1 * 360 * math.pi / 180)
	local num_6 = num_2 + num_3 * math.sin(num_5)

	return num + num_4 * math.cos(num_5), num_6, num_5
end

CrosshairUI._set_crosshair_target_info = function (self, arg_22_1, arg_22_2)
	-- function 22
	local content = self.wh_priest.content

	content.state = arg_22_2
	content.career_portrait = not arg_22_1 and arg_22_1 and self._small_career_portrait
	content.text_id = "$KEY;Player__action_one:"
	self._small_career_portrait = not arg_22_1 and arg_22_1 and self._small_career_portrait
end

CrosshairUI._update_self_to_ally_transition = function (self)
	-- function 23
	local content = self.wh_priest.content

	if content.state ~= self.state then
		local flag

		flag = content.state ~= "wh_priest_self" or not "ally_to_self" or "self_to_ally"
		self.wh_crosshair_anim = self._ui_animator:start_animation(flag, self.wh_priest, scenegraph_definition)
	end

	self.state = content.state
end

CrosshairUI._update_animations = function (self, arg_24_1)
	-- function 24
	self._ui_animator:update(arg_24_1)
end

CrosshairUI.destroy = function (arg_25_0)
	-- function 25
	Managers.state.event:unregister("on_set_ability_target_name", arg_25_0)
	Managers.state.event:unregister("on_game_options_changed", arg_25_0)
end

CrosshairUI.update_game_options = function (self)
	-- function 26
	local user_setting = Application.user_setting("crosshair_kill_confirm")
	local flag = user_setting ~= CrosshairKillConfirmSettingsGroups.off

	self._kill_confirm_enabled_groups = kill_confirm_group_settings[user_setting]

	if not (not flag and self._kill_confirm_enabled) then
		self._kill_confirm_enabled = true

		Managers.state.event:register(self, "on_player_killed_enemy", "_register_kill_confirm")
	elseif flag or not self._kill_confirm_enabled then
		self._kill_confirm_enabled = false

		Managers.state.event:unregister("on_player_killed_enemy", self)

		self._current_kill_confirm_widget = nil
	end
end

CrosshairUI._register_kill_confirm = function (self, arg_27_1, arg_27_2, arg_27_3)
	-- function 27
	if not (not self._kill_confirm_enabled_groups and self._kill_confirm_enabled_groups ~= kill_confirm_group_settings.off) then
		return
	end

	local player_unit = self.local_player.player_unit
	local var_27_1

	if not (arg_27_1[DamageDataIndex.ATTACKER] == player_unit or arg_27_1[DamageDataIndex.SOURCE_ATTACKER_UNIT] ~= player_unit) then
		if arg_27_1[DamageDataIndex.DAMAGE_SOURCE_NAME] == "dot_debuff" then
			var_27_1 = kill_confirm_types.kill_dot
		elseif not kill_confirm_weakspot_zones[arg_27_1[DamageDataIndex.HIT_ZONE]] then
			var_27_1 = kill_confirm_types.kill_weakpoint
		else
			var_27_1 = kill_confirm_types.kill
		end
	end

	if not var_27_1 then
		local infantry = kill_confirm_enemy_types.infantry

		if not arg_27_2.elite then
			infantry = kill_confirm_enemy_types.elite
		elseif not arg_27_2.special then
			infantry = kill_confirm_enemy_types.special
		elseif not arg_27_2.boss then
			infantry = kill_confirm_enemy_types.boss
		end

		if not (not self._kill_confirm_enabled_groups[infantry] and not self._current_kill_confirm_type and not self._current_kill_confirm_widget and kill_confirm_enemy_prio[self._current_kill_confirm_type] <= kill_confirm_enemy_prio[infantry] or not (self._current_kill_confirm_widget.style.color[1] <= num_3)) then
			local var_27_3 = kill_confirm_enemy_type_widget_map[infantry]
			local var_27_4 = self.kill_confirm_widgets[var_27_3]

			if not var_27_4 then
				var_27_4.style.color = kill_confirm_type_colors[var_27_1]
			end

			self._current_kill_confirm_widget = var_27_4
			self._current_kill_confirm_type = infantry
			self._last_kill_confirm_t = Managers.time:time("ui")
		end
	end
end

CrosshairUI._draw_kill_confirm = function (self, arg_28_1, arg_28_2, arg_28_3)
	-- function 28
	if not self._current_kill_confirm_widget then
		return
	end

	local num_2 = arg_28_2 - self._last_kill_confirm_t

	if num_2 > num then
		self._current_kill_confirm_widget = nil
		self._current_kill_confirm_type = nil

		return
	end

	local num_3 = (1 - math.easeInCubic(num_2 / num)) * 255
	local _current_kill_confirm_widget = self._current_kill_confirm_widget

	_current_kill_confirm_widget.style.color[1] = num_3

	UIRenderer.draw_widget(arg_28_3, _current_kill_confirm_widget)
end
