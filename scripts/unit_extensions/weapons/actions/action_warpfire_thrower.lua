-- chunkname: @scripts/unit_extensions/weapons/actions/action_warpfire_thrower.lua

ActionWarpfireThrower = class(ActionWarpfireThrower, ActionBase)

ActionWarpfireThrower.init = function (self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)
	-- function 1
	ActionWarpfireThrower.super.init(self, world, item_name, is_server, owner_unit, damage_unit, first_person_unit, weapon_unit, weapon_system)

	self.overcharge_extension = ScriptUnit.extension(owner_unit, "overcharge_system")
	self.buff_extension = ScriptUnit.extension(owner_unit, "buff_system")
	self.first_person_extension = ScriptUnit.extension(owner_unit, "first_person_system")
	self.targets = {}
	self.old_targets = {}
	self.weapon_extension = ScriptUnit.extension(weapon_unit, "weapon_system")
	self.stop_sound_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot"
	self.unit_id = Managers.state.network.unit_storage:go_id(owner_unit)
	self.weapon_unit = weapon_unit
	self.owner_unit = owner_unit
	self.physics_world = World.physics_world(world)
	self._current_flame_time = 0
end

ActionWarpfireThrower.client_owner_start_action = function (self, new_action, t, chain_action_data, power_level)
	-- function 2
	ActionWarpfireThrower.super.client_owner_start_action(self, new_action, t, chain_action_data, power_level)

	self.current_action = new_action
	self.state = "shooting"
	self.overcharge_timer = 0

	local overcharge_amount = PlayerUnitStatusSettings.overcharge_values[self.current_action.overcharge_type]

	self.overcharge_extension:add_charge(overcharge_amount)
end

ActionWarpfireThrower.client_owner_post_update = function (self, dt, t, world, can_damage)
	-- function 3
	local owner_unit = self.owner_unit
	local current_action = self.current_action

	self.overcharge_timer = self.overcharge_timer + dt

	if self.state == "shooting" and self.overcharge_timer >= current_action.overcharge_interval then
		local overcharge_amount = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

		self.overcharge_extension:add_charge(overcharge_amount)

		self.overcharge_timer = 0
	end

	local max_overcharge = self.overcharge_extension.max_value - 1
	local current_overcharge_value = self.overcharge_extension:get_overcharge_value()
	local is_max_overcharge = max_overcharge <= current_overcharge_value

	if self.state == "shooting" and not is_max_overcharge then
		local num = dt + self._current_flame_time

		num = not not num or not not 0
		self._current_flame_time = num

		local next_fire_tick = self.next_fire_tick

		next_fire_tick = not not next_fire_tick or not not 0

		if next_fire_tick < t then
			self:fire(owner_unit, current_action, t)

			self.next_fire_tick = t + current_action.shoot_warpfire_close_attack_cooldown
		end
	elseif is_max_overcharge and self.state == "shooting" then
		self.state = "shot"

		self.weapon_extension:stop_action("action_complete")
	end
end

ActionWarpfireThrower.finish = function (self, reason, data)
	-- function 4
	if self.state ~= "shot" then
		self:_proc_spell_used(self.buff_extension)
	end
end

ActionWarpfireThrower._stop_fx = function (self)
	-- function 5
	local hud_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if hud_extension then
		hud_extension.show_critical_indication = false
	end
end

ActionWarpfireThrower.destroy = function (self)
	-- function 6
	if self._flamethrower_effect then
		World.destroy_particles(self.world, self._flamethrower_effect)

		self._flamethrower_effect = nil
	end
end

ActionWarpfireThrower.fire = function (self, unit, current_action, t)
	-- function 7
	local buff_system = Managers.state.entity:system("buff_system")
	local enemies_in_range = EnemyCharacterStateHelper.get_enemies_in_line_of_sight(unit, self.first_person_unit, self.physics_world)

	if not enemies_in_range then
		return
	end

	for i = 1, #enemies_in_range do
		local enemy_data = enemies_in_range[i]
		local hit_unit = enemy_data.unit

		if DamageUtils.is_enemy(unit, hit_unit) then
			local buff_name_close

			if enemy_data.distance <= current_action.shoot_warpfire_close_attack_range then
				buff_name_close = current_action.buff_name_close

				if not buff_name_close then
					-- Nothing
				end
			end

			buff_name_close = current_action.buff_name_far

			local buff_name = buff_name_close

			::label_7_0::

			buff_system:add_buff(hit_unit, buff_name, unit)
			buff_system:add_buff(hit_unit, "warpfire_thrower_fire_slowdown", unit)
		end
	end
end
