-- chunkname: @scripts/unit_extensions/weapons/actions/action_charged_projectile.lua

ActionChargedProjectileUtility = {}

function ActionChargedProjectileUtility.prepare_charged_projectile(arg_1_0, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	local var_1_0 = ScriptUnit.extension(arg_1_1, "overcharge_system")
	local var_1_1 = ScriptUnit.extension(arg_1_1, "buff_system")
	local var_1_2 = ScriptUnit.has_extension(arg_1_2, "ammo_system")
	local var_1_3 = var_1_2

	if arg_1_0.forced_charge_level then
		arg_1_4 = arg_1_0.forced_charge_level
	end

	local var_1_4 = {
		first_shot = true,
		overcharge_extension = var_1_0,
		buff_extension = var_1_1,
		ammo_extension = var_1_2,
		item_name = arg_1_3,
		power_level = arg_1_5,
		owner_unit = arg_1_1,
		weapon_unit = arg_1_2,
		action_data = arg_1_0,
		charge_level = arg_1_4,
		is_grenade = var_1_3
	}

	if var_1_3 then
		var_1_4.extra_grenades = var_1_1:apply_buffs_to_value(0, "grenade_extra_shot")
		var_1_4.grenade_thrown = false
		var_1_4.free_grenade = false
		var_1_4.rewield_grenade = false
	end

	return var_1_4
end

function ActionChargedProjectileUtility.fire_charged_projectile(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	local var_2_0 = arg_2_0.action_data
	local var_2_1 = var_2_0.overcharge_type
	local var_2_2 = arg_2_0.buff_extension

	if var_2_1 and arg_2_0.first_shot then
		local var_2_3 = PlayerUnitStatusSettings.overcharge_values[var_2_1]

		if arg_2_1 and var_2_2:has_buff_perk("no_overcharge_crit") then
			var_2_3 = 0
		end

		local var_2_4 = arg_2_0.overcharge_extension

		if var_2_0.scale_overcharge then
			local var_2_5 = arg_2_0.charge_level

			var_2_4:add_charge(var_2_3, var_2_5)
		else
			var_2_4:add_charge(var_2_3)
		end
	end

	local var_2_6
	local var_2_7 = arg_2_0.charge_level
	local var_2_8

	if var_2_0.charged_speed then
		var_2_8 = math.lerp(var_2_0.speed, var_2_0.charged_speed, math.clamp(var_2_7, 0, 1))
	else
		var_2_8 = var_2_0.speed
	end

	local var_2_9 = arg_2_0.owner_unit
	local var_2_10

	if arg_2_0.is_grenade then
		var_2_8 = var_2_2:apply_buffs_to_value(var_2_8, "grenade_throw_range")

		local var_2_11 = var_2_0.ammo_usage

		if not arg_2_0.grenade_thrown then
			arg_2_0.grenade_thrown = true

			local var_2_12, var_2_13 = var_2_2:apply_buffs_to_value(0, "not_consume_grenade")
			local var_2_14 = var_2_2:has_buff_perk("free_grenade")

			if var_2_13 or var_2_14 then
				arg_2_0.free_grenade = true

				var_2_2:trigger_procs("on_grenade_use")
			end

			arg_2_0.rewield_grenade = var_2_2:has_buff_perk("rewield_grenade_on_throw")

			Managers.state.achievement:trigger_event("on_grenade_thrown", var_2_9, var_2_0)
		end

		if arg_2_2 then
			if not arg_2_0.free_grenade then
				arg_2_0.ammo_extension:use_ammo(var_2_11)
			end

			var_2_10 = arg_2_0.rewield_grenade and "rewield_wielded_weapon" or "wield_previous_weapon"
		end
	end

	local var_2_15
	local var_2_16 = arg_2_0.weapon_unit
	local var_2_17 = var_2_0.projectile_info

	if var_2_17.fire_from_muzzle then
		local var_2_18 = var_2_17.muzzle_name or "fx_muzzle"
		local var_2_19 = Unit.node(var_2_16, var_2_18)
		local var_2_20 = Unit.world_position(var_2_16, var_2_19)
		local var_2_21 = 1

		if var_2_17.timed_data then
			var_2_21 = var_2_17.timed_data.life_time
		end

		var_2_6 = ActionUtils.pitch_from_rotation(arg_2_4)
		var_2_15 = Vector3.normalize(Vector3.flat(Quaternion.forward(arg_2_4)))

		local var_2_22 = math.degrees_to_radians(var_2_6)
		local var_2_23 = ProjectileGravitySettings[var_2_17.gravity_settings]
		local var_2_24 = WeaponHelper:position_on_trajectory(arg_2_3, var_2_15, var_2_8 / 100, var_2_22, var_2_23, var_2_21)

		var_2_15 = Vector3.normalize(Vector3.flat(var_2_24 - var_2_20))
		arg_2_3 = var_2_20
	end

	if var_2_0.flatten_target_vector ~= false then
		var_2_6 = var_2_6 or ActionUtils.pitch_from_rotation(arg_2_4)
		var_2_15 = var_2_15 or Vector3.normalize(Vector3.flat(Quaternion.forward(arg_2_4)))
	else
		var_2_6 = 0
		var_2_15 = Quaternion.forward(arg_2_4)
	end

	if var_2_0.fire_at_gaze_setting and var_2_0.throw_up_this_much_in_target_direction and ScriptUnit.has_extension(var_2_9, "eyetracking_system") then
		local var_2_25 = ScriptUnit.extension(var_2_9, "eyetracking_system")

		if var_2_25:get_is_feature_enabled("tobii_fire_at_gaze") then
			local var_2_26 = var_2_25:get_gaze_rayhit()

			if var_2_26 then
				local var_2_27 = Vector3.distance(Vector3.flat(arg_2_3), Vector3.flat(var_2_26))
				local var_2_28 = arg_2_3[3] - var_2_26[3]
				local var_2_29 = ProjectileGravitySettings[var_2_17.gravity_settings]
				local var_2_30 = Vector3.normalize(Quaternion.forward(arg_2_4)) + Vector3(0, 0, var_2_0.throw_up_this_much_in_target_direction)
				local var_2_31 = -Vector3.normalize(var_2_30)[3]
				local var_2_32 = math.sqrt(1 - var_2_31 * var_2_31)
				local var_2_33 = 22500
				local var_2_34 = math.clamp(-0.5 * var_2_29 * var_2_27 * var_2_27 / (var_2_28 * var_2_32 * var_2_32 - var_2_27 * var_2_31 * var_2_32), 0.1, var_2_33)

				var_2_8 = math.sqrt(var_2_34) * 100
			end
		end
	end

	local var_2_35 = Managers.player:owner(var_2_9)
	local var_2_36 = var_2_35 and var_2_35.bot_player

	if var_2_0.throw_up_this_much_in_target_direction and not var_2_36 then
		var_2_15 = Vector3.normalize(var_2_15 + Vector3(0, 0, var_2_0.throw_up_this_much_in_target_direction))
	end

	local var_2_37 = var_2_0.lookup_data
	local var_2_38 = arg_2_0.item_name
	local var_2_39 = var_2_37.item_template_name
	local var_2_40 = var_2_37.action_name
	local var_2_41 = var_2_37.sub_action_name
	local var_2_42 = math.round(math.max(var_2_7, 0) * 100)
	local var_2_43 = var_2_0.scale_projectile ~= false and var_2_42 or 1
	local var_2_44 = arg_2_0.power_level

	if var_2_2:has_buff_perk("full_charge_boost") and var_2_7 >= 1 then
		var_2_44 = var_2_2:apply_buffs_to_value(var_2_44, "full_charge_boost")
	end

	local var_2_45 = ActionUtils.scale_charged_projectile_power_level(var_2_44, var_2_0, var_2_7)

	ActionUtils.spawn_player_projectile(var_2_9, arg_2_3, arg_2_4, var_2_43, var_2_6, var_2_15, var_2_8, var_2_38, var_2_39, var_2_40, var_2_41, arg_2_1, var_2_45, arg_2_5, var_2_42)

	local var_2_46 = var_2_0.fire_sound_event

	if var_2_46 then
		local var_2_47 = var_2_0.fire_sound_on_husk

		ScriptUnit.extension(var_2_9, "first_person_system"):play_hud_sound_event(var_2_46, nil, var_2_47)
	end

	if var_2_0.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(var_2_9, POSITION_LOOKUP[var_2_9], var_2_0.alert_sound_range_fire)
	end

	if var_2_0.hide_weapon_after_fire then
		Unit.set_unit_visibility(var_2_16, false)
	end

	if not var_2_17.disable_throwing_dialogue and var_2_17.pickup_name then
		local var_2_48 = ScriptUnit.extension_input(var_2_9, "dialogue_system")
		local var_2_49 = FrameTable.alloc_table()

		var_2_49.item_type = var_2_17.pickup_name

		var_2_48:trigger_networked_dialogue_event("throwing_item", var_2_49)
	end

	arg_2_0.first_shot = false

	return var_2_10
end

ActionChargedProjectile = class(ActionChargedProjectile, ActionBase)

function ActionChargedProjectile.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	ActionChargedProjectile.super.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	if ScriptUnit.has_extension(arg_3_7, "spread_system") then
		arg_3_0.spread_extension = ScriptUnit.extension(arg_3_7, "spread_system")
	end

	arg_3_0._weapon_unit = arg_3_7
end

function ActionChargedProjectile.client_owner_start_action(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	ActionChargedProjectile.super.client_owner_start_action(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	local var_4_0 = arg_4_0.owner_unit
	local var_4_1 = ActionUtils.is_critical_strike(arg_4_0.owner_unit, arg_4_1, arg_4_2)
	local var_4_2 = ScriptUnit.extension(var_4_0, "buff_system")

	arg_4_0.owner_buff_extension = var_4_2
	arg_4_0.current_action = arg_4_1
	arg_4_0.state = "waiting_to_shoot"

	local var_4_3 = arg_4_3 and arg_4_3.charge_level or 0

	arg_4_0._projectile_context = ActionChargedProjectileUtility.prepare_charged_projectile(arg_4_1, var_4_0, arg_4_0._weapon_unit, arg_4_0.item_name, var_4_3, arg_4_4)
	arg_4_0.time_to_shoot = arg_4_2 + arg_4_1.fire_time
	arg_4_0.extra_buff_shot = false

	local var_4_4 = arg_4_1.spread_template_override

	if var_4_4 then
		arg_4_0.spread_extension:override_spread_template(var_4_4)
	end

	local var_4_5 = arg_4_1.loaded_projectile_settings

	if var_4_5 then
		ScriptUnit.extension(arg_4_0.owner_unit, "inventory_system"):set_loaded_projectile_override(var_4_5)
	end

	local var_4_6 = arg_4_1.is_spell
	local var_4_7 = arg_4_0._projectile_context.charge_level

	if var_4_7 and var_4_7 >= 1 and var_4_6 then
		var_4_2:trigger_procs("on_full_charge_action", arg_4_1, arg_4_2, arg_4_3)
	end

	local var_4_8 = ScriptUnit.has_extension(var_4_0, "hud_system")

	arg_4_0:_handle_critical_strike(var_4_1, var_4_2, var_4_8, nil, "on_critical_shot", nil)

	arg_4_0._is_critical_strike = var_4_1
end

function ActionChargedProjectile.client_owner_post_update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	if arg_5_0.state == "waiting_to_shoot" and arg_5_2 >= arg_5_0.time_to_shoot then
		arg_5_0.state = "shooting"
	end

	if arg_5_0.state == "shooting" then
		if arg_5_0:_update_extra_shots(arg_5_0.owner_buff_extension, 1) then
			arg_5_0.state = "waiting_to_shoot"
			arg_5_0.time_to_shoot = arg_5_2 + 0.1
			arg_5_0.extra_buff_shot = true
		else
			arg_5_0.extra_buff_shot = false
			arg_5_0.state = "shot"
		end

		arg_5_0:_shoot(arg_5_2)
		arg_5_0:_proc_spell_used(arg_5_0.owner_buff_extension)
	end
end

function ActionChargedProjectile._update_extra_shots(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._projectile_context

	if var_6_0.is_grenade then
		local var_6_1 = var_6_0.extra_grenades

		if arg_6_2 then
			var_6_0.extra_grenades = var_6_0.extra_grenades - arg_6_2
		end

		return var_6_1 > 0
	end

	return ActionChargedProjectile.super._update_extra_shots(arg_6_0, arg_6_1, arg_6_2)
end

function ActionChargedProjectile._shoot(arg_7_0, arg_7_1)
	local var_7_0 = arg_7_0._projectile_context
	local var_7_1 = var_7_0.action_data
	local var_7_2 = arg_7_0.owner_unit

	if not Managers.player:owner(arg_7_0.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local var_7_3 = false
	local var_7_4 = arg_7_0.first_person_unit
	local var_7_5
	local var_7_6

	if var_7_1.fire_pos_rot then
		var_7_5, var_7_6 = var_7_1.fire_pos_rot(var_7_1, var_7_4, arg_7_0.weapon_unit, var_7_2, arg_7_0.world)
	else
		var_7_5 = Unit.world_position(var_7_4, 0)
		var_7_6 = Unit.local_rotation(var_7_4, 0)

		if var_7_1.fire_at_gaze_setting and ScriptUnit.has_extension(var_7_2, "eyetracking_system") then
			local var_7_7 = ScriptUnit.has_extension(var_7_2, "eyetracking_system")

			if var_7_7 and var_7_7:get_is_feature_enabled("tobii_fire_at_gaze") then
				var_7_6 = var_7_7:gaze_rotation()
				var_7_3 = true
			end
		end

		local var_7_8 = arg_7_0.spread_extension

		if var_7_8 then
			var_7_6 = var_7_8:get_randomised_spread(var_7_6)

			if var_7_0.first_shot then
				var_7_8:set_shooting()
			end
		end
	end

	local var_7_9 = not arg_7_0.extra_buff_shot
	local var_7_10 = ActionChargedProjectileUtility.fire_charged_projectile(var_7_0, arg_7_0._is_critical_strike, var_7_9, var_7_5, var_7_6, var_7_3)
	local var_7_11 = ScriptUnit.extension(var_7_2, "inventory_system")

	if var_7_10 == "wield_previous_weapon" then
		var_7_11:wield_previous_weapon()
	elseif var_7_10 == "rewield_wielded_weapon" then
		var_7_11:rewield_wielded_slot()
	end
end

function ActionChargedProjectile.finish(arg_8_0, arg_8_1)
	if arg_8_0.state == "waiting_to_shoot" then
		arg_8_0.state = "shot"

		local var_8_0 = Managers.time:time("game")
		local var_8_1 = 5

		for iter_8_0 = 1, var_8_1 do
			arg_8_0:_shoot(var_8_0)
			arg_8_0:_proc_spell_used(arg_8_0.owner_buff_extension)

			arg_8_0.extra_buff_shot = true

			if not arg_8_0:_update_extra_shots(arg_8_0.owner_buff_extension, 1) then
				break
			end
		end
	end

	local var_8_2 = arg_8_0._projectile_context.ammo_extension
	local var_8_3 = arg_8_0.current_action
	local var_8_4 = arg_8_0.owner_unit

	if arg_8_1 ~= "new_interupting_action" then
		local var_8_5 = var_8_3.reload_when_out_of_ammo_condition_func
		local var_8_6 = not var_8_5 and true or var_8_5(var_8_4, arg_8_1)

		if var_8_2 and var_8_3.reload_when_out_of_ammo and var_8_6 and var_8_2:ammo_count() == 0 and var_8_2:can_reload() then
			var_8_2:start_reload(true)
		end
	end

	ScriptUnit.extension(var_8_4, "inventory_system"):set_loaded_projectile_override(nil)

	if arg_8_0.spread_extension then
		arg_8_0.spread_extension:reset_spread_template()
	end

	local var_8_7 = ScriptUnit.has_extension(var_8_4, "hud_system")

	if var_8_7 then
		var_8_7.show_critical_indication = false
	end
end
