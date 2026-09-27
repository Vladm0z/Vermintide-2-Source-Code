-- chunkname: @scripts/unit_extensions/weapons/actions/action_charged_projectile.lua

ActionChargedProjectileUtility = {}

ActionChargedProjectileUtility.prepare_charged_projectile = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5)
	-- function 1
	local extension = ScriptUnit.extension(arg_1_1, "overcharge_system")
	local extension_2 = ScriptUnit.extension(arg_1_1, "buff_system")
	local has_extension = ScriptUnit.has_extension(arg_1_2, "ammo_system")
	local var_1_3 = has_extension

	if not self.forced_charge_level then
		arg_1_4 = self.forced_charge_level
	end

	local tbl = {
		first_shot = true,
		overcharge_extension = extension,
		buff_extension = extension_2,
		ammo_extension = has_extension,
		item_name = arg_1_3,
		power_level = arg_1_5,
		owner_unit = arg_1_1,
		weapon_unit = arg_1_2,
		action_data = self,
		charge_level = arg_1_4,
		is_grenade = var_1_3
	}

	if not var_1_3 then
		tbl.extra_grenades = extension_2:apply_buffs_to_value(0, "grenade_extra_shot")
		tbl.grenade_thrown = false
		tbl.free_grenade = false
		tbl.rewield_grenade = false
	end

	return tbl
end

ActionChargedProjectileUtility.fire_charged_projectile = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	local action_data = self.action_data
	local overcharge_type = action_data.overcharge_type
	local buff_extension = self.buff_extension

	if not overcharge_type and not self.first_shot then
		local var_2_3 = PlayerUnitStatusSettings.overcharge_values[overcharge_type]

		if not arg_2_1 and not buff_extension:has_buff_perk("no_overcharge_crit") then
			var_2_3 = 0
		end

		local overcharge_extension = self.overcharge_extension

		if not action_data.scale_overcharge then
			local charge_level = self.charge_level

			overcharge_extension:add_charge(var_2_3, charge_level)
		else
			overcharge_extension:add_charge(var_2_3)
		end
	end

	local var_2_6
	local charge_level_2 = self.charge_level
	local var_2_8

	if not action_data.charged_speed then
		var_2_8 = math.lerp(action_data.speed, action_data.charged_speed, math.clamp(charge_level_2, 0, 1))
	else
		var_2_8 = action_data.speed
	end

	local owner_unit = self.owner_unit
	local var_2_10

	if not self.is_grenade then
		var_2_8 = buff_extension:apply_buffs_to_value(var_2_8, "grenade_throw_range")

		local ammo_usage = action_data.ammo_usage

		if not self.grenade_thrown then
			self.grenade_thrown = true

			local apply_buffs_to_value, var_2_13 = buff_extension:apply_buffs_to_value(0, "not_consume_grenade")
			local has_buff_perk = buff_extension:has_buff_perk("free_grenade")

			if var_2_13 or not has_buff_perk then
				self.free_grenade = true

				buff_extension:trigger_procs("on_grenade_use")
			end

			self.rewield_grenade = buff_extension:has_buff_perk("rewield_grenade_on_throw")

			Managers.state.achievement:trigger_event("on_grenade_thrown", owner_unit, action_data)
		end

		if not arg_2_2 then
			if not self.free_grenade then
				self.ammo_extension:use_ammo(ammo_usage)
			end

			var_2_10 = not self.rewield_grenade and "rewield_wielded_weapon" and "wield_previous_weapon"
		end
	end

	local var_2_15
	local weapon_unit = self.weapon_unit
	local projectile_info = action_data.projectile_info

	if not projectile_info.fire_from_muzzle then
		local muzzle_name = projectile_info.muzzle_name

		muzzle_name = muzzle_name or "fx_muzzle"

		local node = Unit.node(weapon_unit, muzzle_name)
		local world_position = Unit.world_position(weapon_unit, node)
		local num = 1

		if not projectile_info.timed_data then
			num = projectile_info.timed_data.life_time
		end

		var_2_6 = ActionUtils.pitch_from_rotation(arg_2_4)
		var_2_15 = Vector3.normalize(Vector3.flat(Quaternion.forward(arg_2_4)))

		local degrees_to_radians = math.degrees_to_radians(var_2_6)
		local var_2_23 = ProjectileGravitySettings[projectile_info.gravity_settings]
		local position_on_trajectory = WeaponHelper:position_on_trajectory(arg_2_3, var_2_15, var_2_8 / 100, degrees_to_radians, var_2_23, num)

		var_2_15 = Vector3.normalize(Vector3.flat(position_on_trajectory - world_position))
		arg_2_3 = world_position
	end

	if not (action_data.flatten_target_vector ~= false) then
		var_2_6 = var_2_6 or ActionUtils.pitch_from_rotation(arg_2_4)
		var_2_15 = var_2_15 or Vector3.normalize(Vector3.flat(Quaternion.forward(arg_2_4)))
	else
		var_2_6 = 0
		var_2_15 = Quaternion.forward(arg_2_4)
	end

	if not action_data.fire_at_gaze_setting and not action_data.throw_up_this_much_in_target_direction and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
		local extension = ScriptUnit.extension(owner_unit, "eyetracking_system")

		if not extension:get_is_feature_enabled("tobii_fire_at_gaze") then
			local get_gaze_rayhit = extension:get_gaze_rayhit()

			if not get_gaze_rayhit then
				local distance = Vector3.distance(Vector3.flat(arg_2_3), Vector3.flat(get_gaze_rayhit))
				local num_2 = arg_2_3[3] - get_gaze_rayhit[3]
				local var_2_29 = ProjectileGravitySettings[projectile_info.gravity_settings]
				local num_3 = Vector3.normalize(Quaternion.forward(arg_2_4)) + Vector3(0, 0, action_data.throw_up_this_much_in_target_direction)
				local num_4 = -Vector3.normalize(num_3)[3]
				local sqrt = math.sqrt(1 - num_4 * num_4)
				local num_5 = 22500
				local clamp = math.clamp(-0.5 * var_2_29 * distance * distance / (num_2 * sqrt * sqrt - distance * num_4 * sqrt), 0.1, num_5)

				var_2_8 = math.sqrt(clamp) * 100
			end
		end
	end

	local owner = Managers.player:owner(owner_unit)
	local flag = not owner and owner.bot_player

	if not (not action_data.throw_up_this_much_in_target_direction and flag) then
		var_2_15 = Vector3.normalize(var_2_15 + Vector3(0, 0, action_data.throw_up_this_much_in_target_direction))
	end

	local lookup_data = action_data.lookup_data
	local item_name = self.item_name
	local item_template_name = lookup_data.item_template_name
	local action_name = lookup_data.action_name
	local sub_action_name = lookup_data.sub_action_name
	local round = math.round(math.max(charge_level_2, 0) * 100)
	local flag_2 = not (action_data.scale_projectile ~= false) and round and 1
	local power_level = self.power_level

	if not (not buff_extension:has_buff_perk("full_charge_boost") and not (charge_level_2 >= 1)) then
		power_level = buff_extension:apply_buffs_to_value(power_level, "full_charge_boost")
	end

	local scale_charged_projectile_power_level = ActionUtils.scale_charged_projectile_power_level(power_level, action_data, charge_level_2)

	ActionUtils.spawn_player_projectile(owner_unit, arg_2_3, arg_2_4, flag_2, var_2_6, var_2_15, var_2_8, item_name, item_template_name, action_name, sub_action_name, arg_2_1, scale_charged_projectile_power_level, arg_2_5, round)

	local fire_sound_event = action_data.fire_sound_event

	if not fire_sound_event then
		local fire_sound_on_husk = action_data.fire_sound_on_husk

		ScriptUnit.extension(owner_unit, "first_person_system"):play_hud_sound_event(fire_sound_event, nil, fire_sound_on_husk)
	end

	if not action_data.alert_sound_range_fire then
		Managers.state.entity:system("ai_system"):alert_enemies_within_range(owner_unit, POSITION_LOOKUP[owner_unit], action_data.alert_sound_range_fire)
	end

	if not action_data.hide_weapon_after_fire then
		Unit.set_unit_visibility(weapon_unit, false)
	end

	if projectile_info.disable_throwing_dialogue or not projectile_info.pickup_name then
		local extension_input = ScriptUnit.extension_input(owner_unit, "dialogue_system")
		local alloc_table = FrameTable.alloc_table()

		alloc_table.item_type = projectile_info.pickup_name

		extension_input:trigger_networked_dialogue_event("throwing_item", alloc_table)
	end

	self.first_shot = false

	return var_2_10
end

ActionChargedProjectile = class(ActionChargedProjectile, ActionBase)

ActionChargedProjectile.init = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)
	-- function 3
	ActionChargedProjectile.super.init(self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5, arg_3_6, arg_3_7, arg_3_8)

	if not ScriptUnit.has_extension(arg_3_7, "spread_system") then
		self.spread_extension = ScriptUnit.extension(arg_3_7, "spread_system")
	end

	self._weapon_unit = arg_3_7
end

ActionChargedProjectile.client_owner_start_action = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	ActionChargedProjectile.super.client_owner_start_action(self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(self.owner_unit, arg_4_1, arg_4_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.owner_buff_extension = extension
	self.current_action = arg_4_1
	self.state = "waiting_to_shoot"

	local charge_level

	if not arg_4_3 then
		charge_level = arg_4_3.charge_level

		if not charge_level then
			-- Nothing
		end
	end

	charge_level = 0

	::label_4_0::

	self._projectile_context = ActionChargedProjectileUtility.prepare_charged_projectile(arg_4_1, owner_unit, self._weapon_unit, self.item_name, charge_level, arg_4_4)
	self.time_to_shoot = arg_4_2 + arg_4_1.fire_time
	self.extra_buff_shot = false

	local spread_template_override = arg_4_1.spread_template_override

	if not spread_template_override then
		self.spread_extension:override_spread_template(spread_template_override)
	end

	local loaded_projectile_settings = arg_4_1.loaded_projectile_settings

	if not loaded_projectile_settings then
		ScriptUnit.extension(self.owner_unit, "inventory_system"):set_loaded_projectile_override(loaded_projectile_settings)
	end

	local is_spell = arg_4_1.is_spell
	local charge_level_2 = self._projectile_context.charge_level

	if not charge_level_2 and not (charge_level_2 >= 1) or not is_spell then
		extension:trigger_procs("on_full_charge_action", arg_4_1, arg_4_2, arg_4_3)
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionChargedProjectile.client_owner_post_update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	-- function 5
	if not (self.state ~= "waiting_to_shoot" or not (arg_5_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		if not self:_update_extra_shots(self.owner_buff_extension, 1) then
			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_5_2 + 0.1
			self.extra_buff_shot = true
		else
			self.extra_buff_shot = false
			self.state = "shot"
		end

		self:_shoot(arg_5_2)
		self:_proc_spell_used(self.owner_buff_extension)
	end
end

ActionChargedProjectile._update_extra_shots = function (self, arg_6_1, arg_6_2)
	-- function 6
	local _projectile_context = self._projectile_context

	if not _projectile_context.is_grenade then
		local extra_grenades = _projectile_context.extra_grenades

		if not arg_6_2 then
			_projectile_context.extra_grenades = _projectile_context.extra_grenades - arg_6_2
		end

		return extra_grenades > 0
	end

	return ActionChargedProjectile.super._update_extra_shots(self, arg_6_1, arg_6_2)
end

ActionChargedProjectile._shoot = function (self, arg_7_1)
	-- function 7
	local _projectile_context = self._projectile_context
	local action_data = _projectile_context.action_data
	local owner_unit = self.owner_unit

	if not Managers.player:owner(self.owner_unit).bot_player then
		Managers.state.controller_features:add_effect("rumble", {
			rumble_effect = "handgun_fire"
		})
	end

	local flag = false
	local first_person_unit = self.first_person_unit
	local var_7_5
	local var_7_6

	if not action_data.fire_pos_rot then
		var_7_5, var_7_6 = action_data.fire_pos_rot(action_data, first_person_unit, self.weapon_unit, owner_unit, self.world)
	else
		var_7_5 = Unit.world_position(first_person_unit, 0)
		var_7_6 = Unit.local_rotation(first_person_unit, 0)

		if not action_data.fire_at_gaze_setting and not ScriptUnit.has_extension(owner_unit, "eyetracking_system") then
			local has_extension = ScriptUnit.has_extension(owner_unit, "eyetracking_system")

			if not has_extension and not has_extension:get_is_feature_enabled("tobii_fire_at_gaze") then
				var_7_6 = has_extension:gaze_rotation()
				flag = true
			end
		end

		local spread_extension = self.spread_extension

		if not spread_extension then
			var_7_6 = spread_extension:get_randomised_spread(var_7_6)

			if not _projectile_context.first_shot then
				spread_extension:set_shooting()
			end
		end
	end

	local flag_2 = not self.extra_buff_shot
	local fire_charged_projectile = ActionChargedProjectileUtility.fire_charged_projectile(_projectile_context, self._is_critical_strike, flag_2, var_7_5, var_7_6, flag)
	local extension = ScriptUnit.extension(owner_unit, "inventory_system")

	if fire_charged_projectile == "wield_previous_weapon" then
		extension:wield_previous_weapon()
	elseif fire_charged_projectile == "rewield_wielded_weapon" then
		extension:rewield_wielded_slot()
	end
end

ActionChargedProjectile.finish = function (self, arg_8_1)
	-- function 8
	if self.state == "waiting_to_shoot" then
		self.state = "shot"

		local time = Managers.time:time("game")
		local num = 5

		for i = 1, num do
			self:_shoot(time)
			self:_proc_spell_used(self.owner_buff_extension)

			self.extra_buff_shot = true

			if not self:_update_extra_shots(self.owner_buff_extension, 1) then
				break
			end
		end
	end

	local ammo_extension = self._projectile_context.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_8_1 ~= "new_interupting_action" then
		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_8_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			ammo_extension:start_reload(true)
		end
	end

	ScriptUnit.extension(owner_unit, "inventory_system"):set_loaded_projectile_override(nil)

	if not self.spread_extension then
		self.spread_extension:reset_spread_template()
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end
