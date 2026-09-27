-- chunkname: @scripts/unit_extensions/weapons/actions/action_grenade_thrower.lua

ActionGrenadeThrower = class(ActionGrenadeThrower, ActionBase)

ActionGrenadeThrower.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionGrenadeThrower.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	if not ScriptUnit.has_extension(arg_1_7, "ammo_system") then
		self.ammo_extension = ScriptUnit.extension(arg_1_7, "ammo_system")
	end

	self.spread_extension = ScriptUnit.extension(arg_1_7, "spread_system")
end

ActionGrenadeThrower.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionGrenadeThrower.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	local owner_unit = self.owner_unit
	local is_critical_strike = ActionUtils.is_critical_strike(owner_unit, arg_2_1, arg_2_2)
	local extension = ScriptUnit.extension(owner_unit, "buff_system")

	self.power_level = arg_2_4
	self.owner_buff_extension = extension
	self.current_action = arg_2_1
	self.extra_buff_shot = false
	self.num_projectiles = arg_2_1.num_projectiles

	local multi_projectile_spread = arg_2_1.multi_projectile_spread

	multi_projectile_spread = multi_projectile_spread or 0.075
	self.multi_projectile_spread = multi_projectile_spread

	if not self.ammo_extension and not self.num_projectiles then
		self.num_projectiles = math.min(self.num_projectiles, self.ammo_extension:current_ammo())
	end

	self.num_projectiles_shot = 1
	self.state = "waiting_to_shoot"

	local fire_time = arg_2_1.fire_time

	fire_time = fire_time or 0
	self.time_to_shoot = arg_2_2 + fire_time

	local active_reload_time = arg_2_1.active_reload_time

	active_reload_time = not active_reload_time and arg_2_2 + arg_2_1.active_reload_time
	self.active_reload_time = active_reload_time

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	self:_handle_critical_strike(is_critical_strike, extension, has_extension, nil, "on_critical_shot", nil)

	self._is_critical_strike = is_critical_strike
end

ActionGrenadeThrower.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	if not (self.state ~= "waiting_to_shoot" or not (arg_3_2 >= self.time_to_shoot)) then
		self.state = "shooting"
	end

	if self.state == "shooting" then
		local owner_unit = self.owner_unit

		if not Managers.player:owner(self.owner_unit).bot_player then
			Managers.state.controller_features:add_effect("rumble", {
				rumble_effect = "crossbow_fire"
			})
		end

		local extension = ScriptUnit.extension(owner_unit, "first_person_system")
		local get_projectile_start_position_rotation, var_3_3 = extension:get_projectile_start_position_rotation()
		local spread_extension = self.spread_extension
		local current_action = self.current_action

		if not spread_extension then
			var_3_3 = spread_extension:get_randomised_spread(var_3_3)

			spread_extension:set_shooting()
		end

		local pitch_from_rotation = ActionUtils.pitch_from_rotation(var_3_3)
		local speed = current_action.speed
		local normalize = Vector3.normalize(Vector3.flat(Quaternion.forward(var_3_3)))
		local lookup_data = current_action.lookup_data

		ActionUtils.spawn_player_projectile(owner_unit, get_projectile_start_position_rotation, var_3_3, 0, pitch_from_rotation, normalize, speed, self.item_name, lookup_data.item_template_name, lookup_data.action_name, lookup_data.sub_action_name, self._is_critical_strike, self.power_level)

		local fire_sound_event = self.current_action.fire_sound_event

		if not fire_sound_event then
			extension:play_hud_sound_event(fire_sound_event)
		end

		if not (not self.ammo_extension and self.extra_buff_shot) then
			local ammo_usage = current_action.ammo_usage
			local flag = ItemMasterList[self.item_name].item_type == "grenade"
			local apply_buffs_to_value, var_3_14 = self.owner_buff_extension:apply_buffs_to_value(0, "not_consume_grenade")

			if not var_3_14 and not flag then
				self.ammo_extension:add_ammo_to_reserve(ammo_usage)
			end

			self.ammo_extension:use_ammo(ammo_usage)
		end

		local flag_2 = not self.extra_buff_shot

		if not self:_update_extra_shots(self.owner_buff_extension, 1) then
			self.state = "waiting_to_shoot"
			self.time_to_shoot = arg_3_2 + 0.1
			self.extra_buff_shot = true
		else
			self.state = "shot"
		end

		extension:reset_aim_assist_multiplier()
	end

	if self.state ~= "shot" or not self.active_reload_time then
		local owner_unit_2 = self.owner_unit
		local extension_2 = ScriptUnit.extension(owner_unit_2, "input_system")

		if arg_3_2 > self.active_reload_time then
			local ammo_extension = self.ammo_extension

			if extension_2:get("weapon_reload") or not extension_2:get_buffer("weapon_reload") or not ammo_extension:can_reload() then
				ScriptUnit.extension(self.owner_unit, "status_system"):set_zooming(false)
				ScriptUnit.extension(self.weapon_unit, "weapon_system"):stop_action("reload")
			end
		elseif not extension_2:get("weapon_reload") then
			extension_2:add_buffer("weapon_reload", 0)
		end
	end
end

ActionGrenadeThrower.finish = function (self, arg_4_1)
	-- function 4
	local ammo_extension = self.ammo_extension
	local current_action = self.current_action
	local owner_unit = self.owner_unit

	if arg_4_1 ~= "new_interupting_action" then
		ScriptUnit.extension(owner_unit, "status_system"):set_zooming(false)

		local reload_when_out_of_ammo_condition_func = current_action.reload_when_out_of_ammo_condition_func
		local flag

		flag = reload_when_out_of_ammo_condition_func or not true or reload_when_out_of_ammo_condition_func(owner_unit, arg_4_1)

		if not ammo_extension and not current_action.reload_when_out_of_ammo and not flag and ammo_extension:ammo_count() ~= 0 or not ammo_extension:can_reload() then
			local flag_2 = true

			ammo_extension:start_reload(flag_2)
		end
	end

	local has_extension = ScriptUnit.has_extension(owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end
