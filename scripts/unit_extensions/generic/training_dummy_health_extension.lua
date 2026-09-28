-- chunkname: @scripts/unit_extensions/generic/training_dummy_health_extension.lua

TrainingDummyHealthExtension = class(TrainingDummyHealthExtension, GenericHealthExtension)

TrainingDummyHealthExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	self.unit = unit
	self.is_server = Managers.player.is_server
	self.system_data = extension_init_context.system_data
	self.statistics_db = extension_init_context.statistics_db
	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	self.network_transmit = extension_init_context.network_transmit
	self.is_invincible = false
	self.health = 300
	self.unmodified_max_health = self.health
	self.damage = 0
	self.state = "alive"
	self._next_regen_tick = -math.huge
	self._side_name = "neutral"
end

TrainingDummyHealthExtension.extensions_ready = function (self, world, unit)
	-- function 2
	local side_manager = Managers.state.side
	local side = side_manager:get_side_from_name(self._side_name)
	local side_id = side.side_id

	side_manager:add_unit_to_side(self.unit, side_id)
end

TrainingDummyHealthExtension.freeze = function (self)
	-- function 3
	self:set_dead()
end

TrainingDummyHealthExtension.unfreeze = function (self)
	-- function 4
	self:reset()
end

TrainingDummyHealthExtension.reset = function (self)
	-- function 5
	return
end

TrainingDummyHealthExtension.hot_join_sync = function (self, sender)
	-- function 6
	return
end

TrainingDummyHealthExtension.is_alive = function (self)
	-- function 7
	return true
end

TrainingDummyHealthExtension.apply_client_predicted_damage = function (self, predicted_damage)
	-- function 8
	return
end

TrainingDummyHealthExtension.add_damage = function (self, attacker_unit, damage_amount, hit_zone_name, damage_type, hit_position, damage_direction, damage_source_name, hit_ragdoll_actor, source_attacker_unit, hit_react_type, is_critical_strike, added_dot, first_hit, total_hits, attack_type, backstab_multiplier, target_index)
	-- function 9
	local unit = self.unit
	local network_manager = Managers.state.network
	local unit_id, is_level_unit = network_manager:game_object_or_level_id(unit)

	DamageUtils.handle_hit_indication(attacker_unit, unit, damage_amount, hit_zone_name, added_dot)
	self:_add_to_damage_history_buffer(unit, attacker_unit, damage_amount, hit_zone_name, damage_type, hit_position, damage_direction, damage_source_name, hit_ragdoll_actor, source_attacker_unit, hit_react_type, is_critical_strike, nil, nil, nil, nil, target_index)

	self._recent_damage_type = damage_type
	self._recent_hit_react_type = hit_react_type
	self.damage = math.min(self.damage + damage_amount, self.health - 1)
	self._next_regen_tick = Managers.time:time("game") + 3

	if not DEDICATED_SERVER then
		DamageUtils.add_unit_floating_damage_numbers(unit, damage_type, damage_amount, is_critical_strike)
	end

	if self.is_server and unit_id then
		local attacker_unit_id, attacker_is_level_unit = network_manager:game_object_or_level_id(attacker_unit)
		local hit_zone_id = NetworkLookup.hit_zones[hit_zone_name]
		local damage_type_id = NetworkLookup.damage_types[damage_type]
		local damage_source_id = NetworkLookup.damage_sources[not not damage_source_name or not not "n/a"]
		local hit_ragdoll_actor_id = NetworkLookup.hit_ragdoll_actors[not not hit_ragdoll_actor or not not "n/a"]
		local hit_react_type_id = NetworkLookup.hit_react_types[not not hit_react_type or not not "light"]
		local attack_type_id = NetworkLookup.buff_attack_types[not not attack_type or not not "n/a"]
		local source_attacker_unit_id = NetworkConstants.invalid_game_object_id
		local network_transmit = self.network_transmit
		local dead = self.dead

		if not dead then
			-- Nothing
		end

		dead = false

		local is_dead = dead

		::label_9_0::

		is_critical_strike = not not is_critical_strike or not not false
		added_dot = not not added_dot or not not false
		first_hit = not not first_hit or not not false
		total_hits = not not total_hits or not not 0
		backstab_multiplier = not not backstab_multiplier or not not 1
		target_index = not not target_index or not not 1

		network_transmit:send_rpc_clients("rpc_add_damage", unit_id, is_level_unit, attacker_unit_id, attacker_is_level_unit, source_attacker_unit_id, damage_amount, hit_zone_id, damage_type_id, hit_position, damage_direction, damage_source_id, hit_ragdoll_actor_id, hit_react_type_id, is_dead, is_critical_strike, added_dot, first_hit, total_hits, attack_type_id, backstab_multiplier, target_index)
	end
end

TrainingDummyHealthExtension.update = function (self, dt, context, t)
	-- function 10
	if t > self._next_regen_tick and self.damage > 0 then
		self._next_regen_tick = math.huge
		self.damage = 0
	end
end

TrainingDummyHealthExtension.set_max_health = function (self, health, update_unmodfied)
	-- function 11
	return self.health
end

TrainingDummyHealthExtension.set_current_damage = function (self, damage)
	-- function 12
	return
end

TrainingDummyHealthExtension.die = function (self, damage_type)
	-- function 13
	return
end

TrainingDummyHealthExtension.set_dead = function (self)
	-- function 14
	return
end

TrainingDummyHealthExtension.recently_damaged = function (self)
	-- function 15
	return self._recent_damage_type, self._recent_hit_react_type
end
