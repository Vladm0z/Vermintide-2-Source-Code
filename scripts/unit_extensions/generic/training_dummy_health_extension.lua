-- chunkname: @scripts/unit_extensions/generic/training_dummy_health_extension.lua

TrainingDummyHealthExtension = class(TrainingDummyHealthExtension, GenericHealthExtension)

TrainingDummyHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.system_data = arg_1_1.system_data
	self.statistics_db = arg_1_1.statistics_db
	self.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	self.network_transmit = arg_1_1.network_transmit
	self.is_invincible = false
	self.health = 300
	self.unmodified_max_health = self.health
	self.damage = 0
	self.state = "alive"
	self._next_regen_tick = -math.huge
	self._side_name = "neutral"
end

TrainingDummyHealthExtension.extensions_ready = function (self, arg_2_1, arg_2_2)
	-- function 2
	local side = Managers.state.side
	local side_id = side:get_side_from_name(self._side_name).side_id

	side:add_unit_to_side(self.unit, side_id)
end

TrainingDummyHealthExtension.freeze = function (self)
	-- function 3
	self:set_dead()
end

TrainingDummyHealthExtension.unfreeze = function (self)
	-- function 4
	self:reset()
end

TrainingDummyHealthExtension.reset = function (arg_5_0)
	-- function 5
	return
end

TrainingDummyHealthExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	-- function 6
	return
end

TrainingDummyHealthExtension.is_alive = function (arg_7_0)
	-- function 7
	return true
end

TrainingDummyHealthExtension.apply_client_predicted_damage = function (arg_8_0, arg_8_1)
	-- function 8
	return
end

TrainingDummyHealthExtension.add_damage = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16, arg_9_17)
	-- function 9
	local unit = self.unit
	local network = Managers.state.network
	local game_object_or_level_id, var_9_3 = network:game_object_or_level_id(unit)

	DamageUtils.handle_hit_indication(arg_9_1, unit, arg_9_2, arg_9_3, arg_9_12)
	self:_add_to_damage_history_buffer(unit, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, nil, nil, nil, nil, arg_9_17)

	self._recent_damage_type = arg_9_4
	self._recent_hit_react_type = arg_9_10
	self.damage = math.min(self.damage + arg_9_2, self.health - 1)
	self._next_regen_tick = Managers.time:time("game") + 3

	if not DEDICATED_SERVER then
		DamageUtils.add_unit_floating_damage_numbers(unit, arg_9_4, arg_9_2, arg_9_11)
	end

	if not self.is_server and not game_object_or_level_id then
		local game_object_or_level_id_2, var_9_5 = network:game_object_or_level_id(arg_9_1)
		local var_9_6 = NetworkLookup.hit_zones[arg_9_3]
		local var_9_7 = NetworkLookup.damage_types[arg_9_4]
		local var_9_8 = NetworkLookup.damage_sources[arg_9_7 or "n/a"]
		local var_9_9 = NetworkLookup.hit_ragdoll_actors[arg_9_8 or "n/a"]
		local var_9_10 = NetworkLookup.hit_react_types[arg_9_10 or "light"]
		local var_9_11 = NetworkLookup.buff_attack_types[arg_9_15 or "n/a"]
		local invalid_game_object_id = NetworkConstants.invalid_game_object_id
		local network_transmit = self.network_transmit
		local dead = self.dead

		dead = dead or false
		arg_9_11 = arg_9_11 or false
		arg_9_12 = arg_9_12 or false
		arg_9_13 = arg_9_13 or false
		arg_9_14 = arg_9_14 or 0
		arg_9_16 = arg_9_16 or 1
		arg_9_17 = arg_9_17 or 1

		network_transmit:send_rpc_clients("rpc_add_damage", game_object_or_level_id, var_9_3, game_object_or_level_id_2, var_9_5, invalid_game_object_id, arg_9_2, var_9_6, var_9_7, arg_9_5, arg_9_6, var_9_8, var_9_9, var_9_10, dead, arg_9_11, arg_9_12, arg_9_13, arg_9_14, var_9_11, arg_9_16, arg_9_17)
	end
end

TrainingDummyHealthExtension.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not (not (arg_10_3 > self._next_regen_tick) or not (self.damage > 0)) then
		self._next_regen_tick = math.huge
		self.damage = 0
	end
end

TrainingDummyHealthExtension.set_max_health = function (self, arg_11_1, arg_11_2)
	-- function 11
	return self.health
end

TrainingDummyHealthExtension.set_current_damage = function (arg_12_0, arg_12_1)
	-- function 12
	return
end

TrainingDummyHealthExtension.die = function (arg_13_0, arg_13_1)
	-- function 13
	return
end

TrainingDummyHealthExtension.set_dead = function (arg_14_0)
	-- function 14
	return
end

TrainingDummyHealthExtension.recently_damaged = function (self)
	-- function 15
	return self._recent_damage_type, self._recent_hit_react_type
end
