-- chunkname: @scripts/ui/hud_ui/observer_ui.lua

local var_0_0 = local_require("scripts/ui/hud_ui/observer_ui_definitions")
local var_0_1 = true
local var_0_2 = 0
local var_0_3 = 10

ObserverUI = class(ObserverUI)

ObserverUI.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._parent = arg_1_1
	arg_1_0.ui_renderer = arg_1_2.ui_renderer
	arg_1_0.ingame_ui = arg_1_2.ingame_ui
	arg_1_0.input_manager = arg_1_2.input_manager
	arg_1_0.profile_synchronizer = arg_1_2.profile_synchronizer
	arg_1_0.player_manager = arg_1_2.player_manager
	arg_1_0.peer_id = arg_1_2.peer_id
	arg_1_0.local_player = Managers.player:local_player()
	arg_1_0.player_shielded = false
	arg_1_0._is_visible = false

	arg_1_0:create_ui_elements()
end

ObserverUI.create_ui_elements = function (arg_2_0)
	arg_2_0.ui_scenegraph = UISceneGraph.init_scenegraph(var_0_0.scenegraph_definition)
	arg_2_0.divider_widget = UIWidget.init(var_0_0.widget_definitions.divider)
	arg_2_0.player_name_widget = UIWidget.init(var_0_0.widget_definitions.player_name)
	arg_2_0.hero_name_widget = UIWidget.init(var_0_0.widget_definitions.hero_name)
	arg_2_0.hp_bar_widget = UIWidget.init(var_0_0.widget_definitions.hp_bar)
	arg_2_0.player_name_widget.style.text.localize = false
	var_0_1 = false

	arg_2_0:set_visible(false)
	arg_2_0:draw()
end

ObserverUI.get_player_camera_extension = function (arg_3_0)
	local var_3_0 = arg_3_0.peer_id
	local var_3_1 = arg_3_0.player_manager:player_from_peer_id(var_3_0).camera_follow_unit

	if var_3_1 and ScriptUnit.has_extension(var_3_1, "camera_system") then
		return ScriptUnit.extension(var_3_1, "camera_system")
	end
end

ObserverUI.handle_observer_player_changed = function (arg_4_0)
	if not arg_4_0:get_player_camera_extension() then
		return
	end

	local var_4_0 = arg_4_0.peer_id
	local var_4_1 = arg_4_0.player_manager:player_from_peer_id(var_4_0)
	local var_4_2 = var_4_1:observed_unit()

	if not ALIVE[var_4_2] then
		var_4_2 = var_4_1.player_unit
	end

	if Unit.alive(var_4_2) then
		local var_4_3 = arg_4_0._observed_unit

		if var_4_3 ~= var_4_2 then
			arg_4_0:_set_observed_unit(var_4_3)
		end
	else
		arg_4_0:stop_draw_observer_ui()
	end
end

ObserverUI._set_observed_unit = function (arg_5_0, arg_5_1)
	local var_5_0 = SPProfiles
	local var_5_1 = arg_5_0.profile_synchronizer
	local var_5_2 = Managers.player:players()
	local var_5_3 = false
	local var_5_4 = ""
	local var_5_5 = Managers.player:owner(arg_5_1)
	local var_5_6 = ""

	if var_5_5 then
		var_5_3 = var_5_5:is_player_controlled()
		var_5_4 = var_5_5:name()

		local var_5_7 = var_5_5:local_player_id()
		local var_5_8 = var_5_1:profile_by_peer(var_5_5.peer_id, var_5_7)

		var_5_6 = var_5_0[var_5_8] and var_5_0[var_5_8].display_name
	end

	arg_5_0.player_name_widget.content.text = var_5_3 and var_5_4 or var_5_4 .. " (BOT)"
	arg_5_0.hero_name_widget.content.text = var_5_6
	arg_5_0._observed_unit = arg_5_1
	arg_5_0._skip_bar_animation = true
	arg_5_0.player_name_widget.element.dirty = true
	arg_5_0.hero_name_widget.element.dirty = true
	arg_5_0._dirty = true
end

ObserverUI.stop_draw_observer_ui = function (arg_6_0)
	arg_6_0._observed_unit = nil
	arg_6_0.divider_widget.element.dirty = true
	arg_6_0.player_name_widget.element.dirty = true
	arg_6_0.hero_name_widget.element.dirty = true
	arg_6_0.hp_bar_widget.element.dirty = true
	arg_6_0._dirty = true
end

ObserverUI.update = function (arg_7_0, arg_7_1, arg_7_2)
	if var_0_1 then
		arg_7_0:create_ui_elements()
	end

	if not arg_7_0._is_visible then
		return
	end

	arg_7_0:handle_observer_player_changed()

	if arg_7_0._observed_unit then
		arg_7_0:_update_follow_unit_health_bar(arg_7_0._observed_unit)
		arg_7_0:update_health_animations(arg_7_1)

		arg_7_0._skip_bar_animation = nil
	end

	arg_7_0:draw(arg_7_1)
end

ObserverUI.draw = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0.ui_renderer
	local var_8_1 = arg_8_0.ui_scenegraph
	local var_8_2 = arg_8_0.input_manager:get_service("Player")

	UIRenderer.begin_pass(var_8_0, var_8_1, var_8_2, arg_8_1)

	if arg_8_0._dirty then
		UIRenderer.draw_widget(var_8_0, arg_8_0.divider_widget)
		UIRenderer.draw_widget(var_8_0, arg_8_0.player_name_widget)
		UIRenderer.draw_widget(var_8_0, arg_8_0.hero_name_widget)

		arg_8_0._dirty = false
	end

	UIRenderer.draw_widget(var_8_0, arg_8_0.hp_bar_widget)
	UIRenderer.end_pass(var_8_0)
end

ObserverUI.destroy = function (arg_9_0)
	return
end

ObserverUI.set_visible = function (arg_10_0, arg_10_1)
	if arg_10_0._is_visible ~= arg_10_1 then
		local var_10_0 = arg_10_0.divider_widget

		UIRenderer.set_element_visible(arg_10_0.ui_renderer, var_10_0.element, arg_10_1)

		var_10_0.content.visible = arg_10_1
		var_10_0.element.dirty = true

		local var_10_1 = arg_10_0.player_name_widget

		UIRenderer.set_element_visible(arg_10_0.ui_renderer, var_10_1.element, arg_10_1)

		var_10_0.content.visible = arg_10_1
		var_10_1.element.dirty = true

		local var_10_2 = arg_10_0.hero_name_widget

		UIRenderer.set_element_visible(arg_10_0.ui_renderer, var_10_2.element, arg_10_1)

		var_10_0.content.visible = arg_10_1
		var_10_2.element.dirty = true

		local var_10_3 = arg_10_0.hp_bar_widget

		UIRenderer.set_element_visible(arg_10_0.ui_renderer, var_10_3.element, arg_10_1)

		var_10_0.content.visible = arg_10_1
		var_10_3.element.dirty = true
		arg_10_0._dirty = true
		arg_10_0._is_visible = arg_10_1
	end
end

ObserverUI.is_visible = function (arg_11_0)
	return arg_11_0._is_visible
end

ObserverUI._update_follow_unit_health_bar = function (arg_12_0, arg_12_1)
	local var_12_0 = arg_12_0.profile_synchronizer
	local var_12_1 = Managers.player:owner(arg_12_1)
	local var_12_2
	local var_12_3
	local var_12_4
	local var_12_5
	local var_12_6
	local var_12_7 = 0
	local var_12_8 = 1
	local var_12_9 = false
	local var_12_10 = arg_12_0.hp_bar_widget
	local var_12_11 = var_12_10.content
	local var_12_12 = var_12_10.style

	if var_12_1 then
		local var_12_13 = ScriptUnit.extension(arg_12_1, "health_system")
		local var_12_14 = ScriptUnit.extension(arg_12_1, "status_system")

		var_12_2 = var_12_13:current_health_percent()

		local var_12_15 = var_12_13:get_max_health()
		local var_12_16, var_12_17 = var_12_13:has_assist_shield()

		if var_12_16 then
			var_12_7 = var_12_17 / var_12_15

			if not arg_12_0.player_shielded then
				local var_12_18 = var_12_12.hp_bar_highlight

				var_12_18.color[1] = 255
				var_12_18.color[2] = 140
				var_12_18.color[3] = 180
				var_12_18.color[4] = 255
				var_12_10.element.dirty = true
				arg_12_0._dirty = true
				arg_12_0.player_shielded = true
			end
		elseif arg_12_0.player_shielded then
			local var_12_19 = var_12_12.hp_bar_highlight

			var_12_19.color[1] = 0
			var_12_19.color[2] = 0
			var_12_19.color[3] = 0
			var_12_19.color[4] = 0
			var_12_10.element.dirty = true
			arg_12_0._dirty = true
			arg_12_0.player_shielded = false
		end

		var_12_5 = var_12_14:is_wounded()
		var_12_3 = var_12_14:is_knocked_down() and var_12_2 > 0
		var_12_6 = var_12_14:is_ready_for_assisted_respawn()

		local var_12_20 = ScriptUnit.extension(arg_12_1, "buff_system")
		local var_12_21 = var_12_20:num_buff_perk("skaven_grimoire")
		local var_12_22 = var_12_20:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local var_12_23 = var_12_20:num_buff_perk("twitch_grimoire")
		local var_12_24 = var_12_20:apply_buffs_to_value(PlayerUnitDamageSettings.GRIMOIRE_HEALTH_DEBUFF, "curse_protection")
		local var_12_25 = var_12_20:num_buff_perk("slayer_curse")
		local var_12_26 = var_12_20:apply_buffs_to_value(PlayerUnitDamageSettings.SLAYER_CURSE_HEALTH_DEBUFF, "curse_protection")
		local var_12_27 = Managers.state.difficulty:get_difficulty()
		local var_12_28 = var_12_20:num_buff_perk("mutator_curse")
		local var_12_29 = var_12_20:apply_buffs_to_value(WindSettings.light.curse_settings.value[var_12_27], "curse_protection")
		local var_12_30 = var_12_20:apply_buffs_to_value(0, "health_curse")
		local var_12_31 = var_12_20:apply_buffs_to_value(var_12_30, "curse_protection")

		var_12_8 = 1 + var_12_21 * var_12_22 + var_12_23 * var_12_24 + var_12_25 * var_12_26 + var_12_28 * var_12_29 + var_12_31
	else
		var_12_2 = 0
		var_12_3 = false
	end

	var_12_11.hp_bar.draw_health_bar = not var_12_6

	local var_12_32 = var_12_2 <= 0
	local var_12_33 = var_0_2
	local var_12_34 = not var_12_32 and not var_12_3 and var_12_2 < UISettings.unit_frames.low_health_threshold or nil
	local var_12_35 = arg_12_0:on_player_health_changed("my_player", var_12_10, var_12_2 * var_12_8)
	local var_12_36 = arg_12_0:on_num_grimoires_changed("my_player_grimoires", var_12_10, 1 - var_12_8)

	var_12_9 = var_12_9 or var_12_35 or var_12_36

	local var_12_37 = var_12_10.content.hp_bar.bar_value
	local var_12_38 = var_12_10.content.hp_bar_grimoire_debuff.bar_value

	var_12_11.hp_bar_shield.bar_value_position = var_12_37
	var_12_11.hp_bar_shield.bar_value_offset = var_12_38
	var_12_11.hp_bar_shield.bar_value_size = var_12_7

	local var_12_39 = var_12_11.hp_bar_max_health_divider

	var_12_39.active = false

	local var_12_40 = var_12_11.hp_bar_grimoire_icon

	var_12_40.active = false

	if var_12_8 < 1 then
		var_12_39.active = true

		local var_12_41 = var_0_0.scenegraph_definition.hp_bar_grimoire_debuff_fill.size[1]
		local var_12_42 = var_12_11.hp_bar_grimoire_debuff.bar_value * var_12_41
		local var_12_43 = var_12_10.style.hp_bar_grimoire_icon

		var_12_40.active = true

		local var_12_44 = var_12_43.offset[1]
		local var_12_45 = -var_12_42 / 2

		if var_12_44 ~= var_12_45 then
			var_12_43.offset[1] = var_12_45
			var_12_9 = true
			var_12_10.style.hp_bar_max_health_divider.offset[1] = -var_12_42
		end
	end

	if var_12_1 then
		local var_12_46 = var_12_1:local_player_id()

		if var_12_0:profile_by_peer(var_12_1.peer_id, var_12_46) then
			if var_12_3 or var_12_32 then
				var_12_33 = var_0_2
			else
				var_12_33 = var_0_3
			end

			var_12_11.hp_bar.low_health = var_12_34
			var_12_11.hp_bar.is_knocked_down = var_12_3
			var_12_11.hp_bar.is_wounded = var_12_5
			var_12_12.hp_bar_divider.texture_amount = var_12_33
		end
	end

	local var_12_47 = RESOLUTION_LOOKUP.modified

	if var_12_9 or var_12_47 then
		var_12_10.element.dirty = true
		arg_12_0._dirty = true
	end
end

ObserverUI.on_player_health_changed = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3)
	if not arg_13_0.bar_animations_data then
		arg_13_0.bar_animations_data = {}
	end

	local var_13_0 = UISettings.unit_frames
	local var_13_1 = arg_13_0.bar_animations_data[arg_13_1] or {
		low_health_animation = UIAnimation.init(UIAnimation.pulse_animation, arg_13_2.style.hp_bar.color, 1, var_13_0.low_health_animation_alpha_from, var_13_0.low_health_animation_alpha_to, var_13_0.low_health_animation_time)
	}

	arg_13_0.bar_animations_data[arg_13_1] = var_13_1

	local var_13_2 = var_13_1.current_health

	var_13_1.current_health = arg_13_3

	if arg_13_3 <= 1 and arg_13_3 ~= var_13_2 then
		local var_13_3 = arg_13_2.content.hp_bar.is_knocked_down
		local var_13_4 = arg_13_2.content.hp_bar.bar_value
		local var_13_5 = UISettings.unit_frames.health_bar_lerp_time
		local var_13_6

		if var_13_4 < arg_13_3 then
			var_13_6 = (arg_13_3 - var_13_4) * var_13_5
		else
			var_13_6 = (var_13_4 - arg_13_3) * var_13_5
		end

		var_13_1.animate_highlight = (not var_13_3 and arg_13_3 < (var_13_2 or 1) or false) and 0 or var_13_1.animate_highlight
		var_13_1.animate = true
		var_13_1.new_health = arg_13_3
		var_13_1.previous_health = var_13_4
		var_13_1.time = 0
		var_13_1.total_time = arg_13_0._skip_bar_animation and 0 or var_13_6
		var_13_1.widget = arg_13_2
		var_13_1.bar = arg_13_2.content.hp_bar

		return true
	end
end

ObserverUI.on_num_grimoires_changed = function (arg_14_0, arg_14_1, arg_14_2, arg_14_3)
	if not arg_14_0.bar_animations_data then
		arg_14_0.bar_animations_data = {}
	end

	local var_14_0 = UISettings.unit_frames
	local var_14_1 = arg_14_0.bar_animations_data[arg_14_1] or {}

	if arg_14_3 ~= var_14_1.current_health_debuff then
		local var_14_2 = arg_14_2.content.hp_bar_grimoire_debuff.bar_value
		local var_14_3 = UISettings.unit_frames.health_bar_lerp_time
		local var_14_4

		if var_14_2 < arg_14_3 then
			var_14_4 = (arg_14_3 - var_14_2) * var_14_3
		else
			var_14_4 = (var_14_2 - arg_14_3) * var_14_3
		end

		var_14_1.animate = true
		var_14_1.new_health = arg_14_3
		var_14_1.previous_health = var_14_2
		var_14_1.time = 0
		var_14_1.total_time = arg_14_0._skip_bar_animation and 0 or var_14_4
		var_14_1.widget = arg_14_2
		var_14_1.bar = arg_14_2.content.hp_bar_grimoire_debuff
	end

	var_14_1.current_health_debuff = arg_14_3
	arg_14_0.bar_animations_data[arg_14_1] = var_14_1
end

ObserverUI.update_health_animations = function (arg_15_0, arg_15_1)
	local var_15_0 = arg_15_0.bar_animations_data

	if var_15_0 then
		for iter_15_0, iter_15_1 in pairs(var_15_0) do
			local var_15_1 = iter_15_1.widget
			local var_15_2 = iter_15_1.bar

			if var_15_2.low_health then
				UIAnimation.update(iter_15_1.low_health_animation, arg_15_1)
			end

			if iter_15_1.animate_highlight and not arg_15_0.player_shielded then
				iter_15_1.animate_highlight = arg_15_0:update_damage_highlight(var_15_1, iter_15_1.animate_highlight, arg_15_1)
			end

			if iter_15_1.animate then
				local var_15_3 = iter_15_1.time
				local var_15_4 = iter_15_1.total_time
				local var_15_5 = iter_15_1.new_health
				local var_15_6 = iter_15_1.previous_health
				local var_15_7 = arg_15_0:update_player_bar_animation(var_15_1, var_15_2, var_15_3, var_15_4, var_15_6, var_15_5, arg_15_1)

				if var_15_7 then
					iter_15_1.time = var_15_7
				else
					iter_15_1.animate = nil
				end
			end
		end
	end
end

ObserverUI.update_player_bar_animation = function (arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4, arg_16_5, arg_16_6, arg_16_7)
	arg_16_3 = arg_16_3 + arg_16_7

	if arg_16_4 > 0 then
		local var_16_0 = arg_16_1.style
		local var_16_1 = math.min(arg_16_3 / arg_16_4, 1)
		local var_16_2 = math.catmullrom(var_16_1, -14, 0, 0, 0)
		local var_16_3 = 7
		local var_16_4 = (var_16_1 * (var_16_3 - 1) + 1) / var_16_3
		local var_16_5

		if arg_16_5 < arg_16_6 then
			var_16_5 = arg_16_5 + (arg_16_6 - arg_16_5) * var_16_4
		else
			var_16_5 = arg_16_5 - (arg_16_5 - arg_16_6) * var_16_4
		end

		arg_16_2.bar_value = var_16_5
		arg_16_1.element.dirty = true
		arg_16_0._dirty = true

		return var_16_1 < 1 and arg_16_3 or nil
	end

	arg_16_2.bar_value = arg_16_6

	return nil
end

ObserverUI.update_damage_highlight = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3)
	local var_17_0 = arg_17_0._skip_bar_animation and 0 or 0.2

	arg_17_2 = arg_17_2 + arg_17_3

	if var_17_0 > 0 then
		local var_17_1 = arg_17_1.style
		local var_17_2 = math.min(arg_17_2 / var_17_0, 1)
		local var_17_3 = 255 * math.catmullrom(var_17_2, -8, 0, 0, -8)

		var_17_1.hp_bar_highlight.color[1] = var_17_3
		arg_17_1.element.dirty = true
		arg_17_0._dirty = true

		return var_17_2 < 1 and arg_17_2 or nil
	end

	return nil
end
