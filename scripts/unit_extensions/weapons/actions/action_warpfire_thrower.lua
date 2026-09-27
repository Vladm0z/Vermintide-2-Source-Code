-- chunkname: @scripts/unit_extensions/weapons/actions/action_warpfire_thrower.lua

ActionWarpfireThrower = class(ActionWarpfireThrower, ActionBase)

ActionWarpfireThrower.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionWarpfireThrower.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	self.overcharge_extension = ScriptUnit.extension(arg_1_4, "overcharge_system")
	self.buff_extension = ScriptUnit.extension(arg_1_4, "buff_system")
	self.first_person_extension = ScriptUnit.extension(arg_1_4, "first_person_system")
	self.targets = {}
	self.old_targets = {}
	self.weapon_extension = ScriptUnit.extension(arg_1_7, "weapon_system")
	self.stop_sound_event = "Stop_player_combat_weapon_drakegun_flamethrower_shoot"
	self.unit_id = Managers.state.network.unit_storage:go_id(arg_1_4)
	self.weapon_unit = arg_1_7
	self.owner_unit = arg_1_4
	self.physics_world = World.physics_world(arg_1_1)
	self._current_flame_time = 0
end

ActionWarpfireThrower.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	-- function 2
	ActionWarpfireThrower.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4)

	self.current_action = arg_2_1
	self.state = "shooting"
	self.overcharge_timer = 0

	local var_2_0 = PlayerUnitStatusSettings.overcharge_values[self.current_action.overcharge_type]

	self.overcharge_extension:add_charge(var_2_0)
end

ActionWarpfireThrower.client_owner_post_update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4)
	-- function 3
	local owner_unit = self.owner_unit
	local current_action = self.current_action

	self.overcharge_timer = self.overcharge_timer + arg_3_1

	if not (self.state ~= "shooting" or not (self.overcharge_timer >= current_action.overcharge_interval)) then
		local var_3_2 = PlayerUnitStatusSettings.overcharge_values[current_action.overcharge_type]

		self.overcharge_extension:add_charge(var_3_2)

		self.overcharge_timer = 0
	end

	local flag = self.overcharge_extension.max_value - 1 <= self.overcharge_extension:get_overcharge_value()

	if not (self.state ~= "shooting" or flag) then
		local num = arg_3_1 + self._current_flame_time

		num = num or 0
		self._current_flame_time = num

		local next_fire_tick = self.next_fire_tick

		next_fire_tick = next_fire_tick or 0

		if next_fire_tick < arg_3_2 then
			self:fire(owner_unit, current_action, arg_3_2)

			self.next_fire_tick = arg_3_2 + current_action.shoot_warpfire_close_attack_cooldown
		end
	elseif not (not flag and self.state ~= "shooting") then
		self.state = "shot"

		self.weapon_extension:stop_action("action_complete")
	end
end

ActionWarpfireThrower.finish = function (self, arg_4_1, arg_4_2)
	-- function 4
	if self.state ~= "shot" then
		self:_proc_spell_used(self.buff_extension)
	end
end

ActionWarpfireThrower._stop_fx = function (self)
	-- function 5
	local has_extension = ScriptUnit.has_extension(self.owner_unit, "hud_system")

	if not has_extension then
		has_extension.show_critical_indication = false
	end
end

ActionWarpfireThrower.destroy = function (self)
	-- function 6
	if not self._flamethrower_effect then
		World.destroy_particles(self.world, self._flamethrower_effect)

		self._flamethrower_effect = nil
	end
end

ActionWarpfireThrower.fire = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	local system = Managers.state.entity:system("buff_system")
	local get_enemies_in_line_of_sight = EnemyCharacterStateHelper.get_enemies_in_line_of_sight(arg_7_1, self.first_person_unit, self.physics_world)

	if not get_enemies_in_line_of_sight then
		return
	end

	for i = 1, #get_enemies_in_line_of_sight do
		local var_7_2 = get_enemies_in_line_of_sight[i]
		local unit = var_7_2.unit

		if not DamageUtils.is_enemy(arg_7_1, unit) then
			local buff_name_close

			if var_7_2.distance <= arg_7_2.shoot_warpfire_close_attack_range then
				buff_name_close = arg_7_2.buff_name_close

				if not buff_name_close then
					-- Nothing
				end
			end

			buff_name_close = arg_7_2.buff_name_far

			::label_7_0::

			system:add_buff(unit, buff_name_close, arg_7_1)
			system:add_buff(unit, "warpfire_thrower_fire_slowdown", arg_7_1)
		end
	end
end
