-- chunkname: @scripts/settings/dlcs/cog/action_charged_sweep.lua

ActionChargedSweep = class(ActionChargedSweep, ActionSweep)

ActionChargedSweep.init = function (self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)
	-- function 1
	ActionChargedSweep.super.init(self, arg_1_1, arg_1_2, arg_1_3, arg_1_4, arg_1_5, arg_1_6, arg_1_7, arg_1_8)

	local extension = ScriptUnit.extension(arg_1_4, "overcharge_system")

	self.overcharge_level_map = {
		extension.overcharge_threshold,
		extension.overcharge_limit,
		extension.overcharge_critical_limit
	}
	self.overcharge_map_size = #self.overcharge_level_map
	self.overcharge_extension = extension
end

ActionChargedSweep.client_owner_start_action = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	arg_2_5 = arg_2_5 or {}
	self._overcharge_type = nil
	self._consume_overcharge = false

	local var_2_0
	local overcharge_extension = self.overcharge_extension

	if not arg_2_1.discharge_attack then
		local get_overcharge_value = overcharge_extension:get_overcharge_value()
		local get_overcharge_level = self:get_overcharge_level(get_overcharge_value)

		var_2_0 = self:get_discharge_effect(arg_2_1, get_overcharge_level)

		if not var_2_0 then
			local overcharge_power_mult = var_2_0.overcharge_power_mult

			overcharge_power_mult = overcharge_power_mult or 1
			arg_2_4 = arg_2_4 * overcharge_power_mult
			self._overcharge_type = var_2_0.consume_overcharge_type
			self._consume_overcharge = true
		end
	else
		self._overcharge_type = arg_2_1.overcharge_type
	end

	self._discharge_effect = var_2_0
	self._overcharge_on_swing = arg_2_1.overcharge_on_swing

	if not arg_2_1.overcharge_on_swing then
		self:_apply_overcharge(self._overcharge_type, self._consume_overcharge)
	end

	ActionChargedSweep.super.client_owner_start_action(self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
end

ActionChargedSweep.client_owner_post_update = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	ActionChargedSweep.super.client_owner_post_update(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
end

ActionChargedSweep.finish = function (arg_4_0, arg_4_1)
	-- function 4
	ActionChargedSweep.super.finish(arg_4_0, arg_4_1)
end

ActionChargedSweep.get_overcharge_level = function (self, arg_5_1)
	-- function 5
	local num = 1
	local overcharge_level_map = self.overcharge_level_map

	for i = self.overcharge_map_size, 1, -1 do
		if arg_5_1 >= overcharge_level_map[i] then
			return i + 1
		end
	end

	return num
end

ActionChargedSweep.get_discharge_effect = function (self, arg_6_1, arg_6_2)
	-- function 6
	local min = math.min(arg_6_2, self.overcharge_map_size)
	local discharge_effects = arg_6_1.discharge_effects

	for i = min, 1, -1 do
		local var_6_2 = discharge_effects[arg_6_2]

		if not var_6_2 then
			return var_6_2
		end
	end

	return nil
end

ActionChargedSweep.apply_overcharge = function (self, arg_7_1, arg_7_2)
	-- function 7
	if not arg_7_1 then
		local overcharge_extension = self.overcharge_extension
		local var_7_1 = PlayerUnitStatusSettings.overcharge_values[arg_7_1]

		if not arg_7_2 then
			overcharge_extension:remove_charge(var_7_1)
		else
			overcharge_extension:add_charge(var_7_1)
		end
	end
end

ActionChargedSweep._send_attack_hit = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, ...)
	-- function 8
	local flag = false
	local var_8_1

	if not (not (arg_8_1 > self._time_to_hit) or self._number_of_hit_enemies ~= 1) then
		var_8_1 = self._network_manager:game_object_or_level_unit(arg_8_4)

		local has_extension = ScriptUnit.has_extension(var_8_1, "health_system")

		flag = not has_extension and has_extension:client_predicted_is_alive()
	end

	ActionChargedSweep.super._send_attack_hit(self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, ...)

	if not flag then
		if not self._overcharge_on_swing then
			self:apply_overcharge(self._overcharge_type, self._consume_overcharge)
		end

		self:_apply_discharge_effect(self._discharge_effect, arg_8_2, var_8_1, arg_8_6)
	end
end

ActionChargedSweep._apply_discharge_effect = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	if not arg_9_1 then
		local explosion_template_name = arg_9_1.explosion_template_name

		if not explosion_template_name then
			local has_node = Unit.has_node(arg_9_3, "c_spine")

			has_node = not has_node and Unit.node(arg_9_3, "c_spine")

			local world_position

			if not has_node then
				world_position = Unit.world_position(arg_9_3, has_node)

				if not world_position then
					-- Nothing
				end
			end

			world_position = arg_9_4

			::label_9_0::

			local world = self.world
			local owner_unit = self.owner_unit
			local unbox = self._stored_rotation:unbox()
			local num = 1
			local item_name = self.item_name
			local _power_level = self._power_level
			local is_server = self.is_server
			local flag = false
			local flag_2 = false
			local weapon_unit = self.weapon_unit
			local network = Managers.state.network
			local network_transmit = network.network_transmit
			local get_template = ExplosionUtils.get_template(explosion_template_name)
			local unit_game_object_id = network:unit_game_object_id(owner_unit)
			local var_9_17 = NetworkLookup.explosion_templates[explosion_template_name]

			if not is_server then
				network_transmit:send_rpc_clients("rpc_create_explosion", unit_game_object_id, false, world_position, unbox, var_9_17, num, arg_9_2, _power_level, flag_2, unit_game_object_id)
			else
				network_transmit:send_rpc_server("rpc_create_explosion", unit_game_object_id, false, world_position, unbox, var_9_17, num, arg_9_2, _power_level, flag_2, unit_game_object_id)
			end

			DamageUtils.create_explosion(world, owner_unit, world_position, unbox, get_template, num, item_name, is_server, flag, weapon_unit, _power_level, flag_2)
		end
	end
end

ActionChargedSweep._get_damage_profile_name = function (self, arg_10_1, arg_10_2)
	-- function 10
	local _discharge_effect = self._discharge_effect

	if not _discharge_effect and not _discharge_effect.damage_profile_name then
		return _discharge_effect.damage_profile_name
	end

	return ActionChargedSweep.super._get_damage_profile_name(self, arg_10_1, arg_10_2)
end
