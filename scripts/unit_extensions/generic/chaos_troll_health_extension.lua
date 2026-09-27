-- chunkname: @scripts/unit_extensions/generic/chaos_troll_health_extension.lua

ChaosTrollHealthExtension = class(ChaosTrollHealthExtension, GenericHealthExtension)

local set_material_property = AiUtils.set_material_property

ChaosTrollHealthExtension.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	ChaosTrollHealthExtension.super.init(self, arg_1_1, arg_1_2, ...)

	local time = Managers.time:time("game")

	self._regen_time = time + 1
	self._regen_paused_time = time
	self.pulse_time = 0
	self.state = "unhurt"
	self.skin_unit = nil

	local has_extension = ScriptUnit.has_extension(self.unit, "ai_inventory_system")

	if not has_extension then
		self.skin_unit = has_extension:get_skin_unit()
	end
end

ChaosTrollHealthExtension.extensions_ready = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local var_2_0 = BLACKBOARDS[arg_2_2]
	local var_2_1 = Breeds[var_2_0.breed.name]

	self.action, self.breed = BreedActions[var_2_0.breed.name].downed, var_2_1

	self:_setup_initial_health_variables(self.health)
end

ChaosTrollHealthExtension.current_max_health_percent = function (self)
	-- function 3
	return self.health / self.current_max_health
end

local num = 0.0001

ChaosTrollHealthExtension.respawn_thresholds = function (self, arg_4_1, arg_4_2)
	-- function 4
	local action = self.action
	local flag = arg_4_1 or self.current_max_health
	local flag_2 = arg_4_2 or self.health
	local var_4_3
	local var_4_4
	local var_4_5

	if not action.fixed_hp_chunks then
		local num_2 = flag / action.fixed_hp_chunks

		if num_2 % 1 ~= 0 then
			flag_2 = math.round_to_closest_multiple(flag_2, num_2 % 1)
		end

		local ceil = math.ceil(math.round_to_closest_multiple(flag_2 / num_2, num) - num)

		var_4_3 = math.clamp(ceil - 1, 0, action.fixed_hp_chunks) * num_2
		var_4_4 = var_4_3 + num_2 * action.respawn_hp_chunk_percent
		var_4_5 = action.fixed_hp_chunks - ceil + 1
	else
		var_4_3 = flag_2 * action.become_downed_hp_percent
		var_4_4 = flag_2 * action.respawn_hp_min_percent
	end

	return var_4_3, var_4_4, var_4_3 / flag, var_4_4 / flag, var_4_5
end

ChaosTrollHealthExtension.chunk_size = function (self)
	-- function 5
	return self.current_max_health / self.action.fixed_hp_chunks
end

ChaosTrollHealthExtension.set_max_health = function (self, arg_6_1)
	-- function 6
	arg_6_1 = ChaosTrollHealthExtension.super.set_max_health(self, arg_6_1)

	self:_setup_initial_health_variables(arg_6_1)

	local _game_object_id = self._game_object_id

	_game_object_id = _game_object_id or Managers.state.unit_storage:go_id(self.unit)

	if not _game_object_id then
		local current_max_health = self.current_max_health

		self.network_transmit:send_rpc_clients("rpc_sync_current_max_health", _game_object_id, current_max_health)
	end

	return arg_6_1
end

ChaosTrollHealthExtension._setup_initial_health_variables = function (self, arg_7_1)
	-- function 7
	if not self.action then
		return
	end

	local respawn_thresholds, var_7_1 = self:respawn_thresholds(arg_7_1)

	self.go_down_health = respawn_thresholds
	self.respawn_hp_min = var_7_1
	self.respawn_hp_max = arg_7_1
	self.regen_pulse_interval = self.breed.regen_pulse_interval
	self.downed_pulse_interval = self.breed.downed_pulse_interval
	self.regen_pulse_intensity = self.breed.regen_pulse_intensity
	self.downed_pulse_intensity = self.breed.downed_pulse_intensity
	self.regen_taken_damage_pause_time = self.breed.regen_taken_damage_pause_time
	self.current_max_health = DamageUtils.networkify_health(arg_7_1)
	self._initial_sync = false
end

ChaosTrollHealthExtension.hot_join_sync = function (self, arg_8_1)
	-- function 8
	local _game_object_id = self._game_object_id

	_game_object_id = _game_object_id or Managers.state.unit_storage:go_id(self.unit)

	if not _game_object_id then
		local var_8_1 = NetworkLookup.health_statuses[self.state]
		local flag = false
		local flag_2 = true

		self.network_transmit:send_rpc("rpc_sync_damage_taken", arg_8_1, _game_object_id, flag, flag_2, self.current_max_health, var_8_1)
		self.network_transmit:send_rpc("rpc_sync_damage_taken", arg_8_1, _game_object_id, flag, flag_2, self.health, var_8_1)
	end

	ChaosTrollHealthExtension.super.hot_join_sync(self, arg_8_1)
end

ChaosTrollHealthExtension.update_regen_effect = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	self.pulse_time = self.pulse_time + arg_9_2

	local num = (self._regen_time - arg_9_1) / arg_9_3
	local num_2 = math.sin(num * math.pi) * arg_9_4

	if self.skin_unit ~= nil then
		set_material_property(self.skin_unit, "regen_value", "mtr_skin", num_2, true)
	else
		set_material_property(self.unit, "regen_value", "mtr_skin", num_2, true)
	end
end

local num_2 = 0

ChaosTrollHealthExtension.update = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if self.state == "dead" then
		return
	end

	if not self._initial_sync then
		self._initial_sync = true

		self:sync_health_to_clients(true)
	end

	if self.state == "down" then
		self:update_regen_effect(arg_10_3, arg_10_1, self.downed_pulse_interval, self.downed_pulse_intensity)

		if arg_10_3 > self.start_reset_time then
			self.down_reset_timer = self.down_reset_timer + arg_10_1

			local num

			if self.action.reset_duration > 0 then
				num = self.down_reset_timer / self.action.reset_duration

				if not num then
					-- Nothing
				end
			end

			num = 0

			::label_10_0::

			local num_2 = 1 - num

			if self.skin_unit ~= nil then
				set_material_property(self.skin_unit, "damage_value", "mtr_skin", num_2, true)
			else
				set_material_property(self.unit, "damage_value", "mtr_skin", num_2, true)
			end
		end
	elseif not (self.state == "unhurt" or self.state ~= "wounded") then
		self:update_regen_effect(arg_10_3, arg_10_1, self.regen_pulse_interval, self.regen_pulse_intensity)

		if not (not (arg_10_3 > self._regen_time) or not (arg_10_3 > self._regen_paused_time)) then
			local var_10_2 = BLACKBOARDS[self.unit]
			local num_3 = arg_10_3 - self._regen_paused_time
			local max_health_regen_time = var_10_2.max_health_regen_time
			local min = math.min(num_3 / max_health_regen_time, 1)
			local num_4 = var_10_2.max_health_regen_per_sec * min
			local networkify_health = DamageUtils.networkify_health(num_4)

			if not (not (networkify_health > 0) or not (self.damage > 0)) then
				self:add_heal(self.unit, networkify_health * self.regen_pulse_interval, nil, "buff")
			end

			self._regen_time = arg_10_3 + self.regen_pulse_interval
			self.pulse_time = 0
		end
	end
end

ChaosTrollHealthExtension._should_die = function (self)
	-- function 11
	return self.state ~= "wounded" or self.damage >= self.health
end

ChaosTrollHealthExtension.apply_client_predicted_damage = function (arg_12_0, arg_12_1)
	-- function 12
	return
end

ChaosTrollHealthExtension.add_damage = function (self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13, arg_13_14, arg_13_15, arg_13_16, arg_13_17)
	-- function 13
	ChaosTrollHealthExtension.super.add_damage(self, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5, arg_13_6, arg_13_7, arg_13_8, arg_13_9, arg_13_10, arg_13_11, arg_13_12, arg_13_13, arg_13_14, arg_13_15, arg_13_16, arg_13_17)

	self._first_damage_occured = true

	if self.state == "dead" then
		return
	end

	local time = Managers.time:time("game")

	if self.state == "unhurt" then
		local num = 1

		if self.health - self.damage < self.go_down_health then
			local var_13_2 = BLACKBOARDS[self.unit]

			self.damage = 0
			self.state = "down"
			var_13_2.downed_state = "downed"
			self.start_reset_time = time + (AiUtils.downed_duration(self.action) + self.action.standup_anim_duration - self.action.reset_duration)
			self.down_reset_timer = 0
		else
			local num_2 = self.health - self.go_down_health

			num = num_2 == 0 or not (self.damage / num_2) or 0
		end

		if self.skin_unit ~= nil then
			set_material_property(self.skin_unit, "damage_value", "mtr_skin", num, true)
		else
			set_material_property(self.unit, "damage_value", "mtr_skin", num, true)
		end
	elseif self.state == "down" then
		if self.health - self.damage < self.respawn_hp_min then
			self.damage = self.health - self.respawn_hp_min

			if not self.action.fixed_hp_chunks then
				self.wounded = true
			end
		end
	elseif self.state == "wounded" then
		if self.damage >= self.health then
			self.state = "dead"

			if self.skin_unit ~= nil then
				set_material_property(self.skin_unit, "regen_value", "mtr_skin", 0, true)
			else
				set_material_property(self.unit, "regen_value", "mtr_skin", 0, true)
			end
		else
			local num_3 = self.damage / (self.health - self.damage)

			if self.skin_unit ~= nil then
				set_material_property(self.skin_unit, "damage_value", "mtr_skin", num_3, true)
			else
				set_material_property(self.unit, "damage_value", "mtr_skin", num_3, true)
			end
		end
	end

	self._regen_paused_time = time + self.regen_taken_damage_pause_time

	self:sync_health_to_clients(nil)
end

ChaosTrollHealthExtension.set_downed_finished = function (self)
	-- function 14
	if self.state == "down" then
		local var_14_0 = BLACKBOARDS[self.unit]
		local running_downed_chunk_events = var_14_0.running_downed_chunk_events

		if not running_downed_chunk_events then
			for k, v in pairs(running_downed_chunk_events) do
				if not v.before_down_end then
					v.before_down_end(self.unit, var_14_0)
				end
			end
		end

		local action = self.action
		local current_health = self:current_health()

		if not (not action.reset_health_on_fail and not (current_health - self.respawn_hp_min > 0.25)) then
			self.damage = 0
		elseif not action.respawn_hp_max_percent then
			self.respawn_hp_max = self.health * action.respawn_hp_max_percent

			if self.health - self.damage > self.respawn_hp_max then
				self.damage = self.health - self.respawn_hp_max
			end
		end

		if not action.reduce_hp_permanently then
			local num = self.health - self.damage
			local respawn_thresholds, var_14_6, var_14_7, var_14_8, var_14_9 = self:respawn_thresholds(nil, num)

			if not (not var_14_9 and var_14_9 ~= action.fixed_hp_chunks) then
				self.wounded = true
			end

			self.respawn_hp_min = var_14_6
			self.go_down_health = respawn_thresholds

			ChaosTrollHealthExtension.super.set_max_health(self, num)
			self:sync_health_to_clients(true)

			self.damage = 0
		end

		if not self.wounded then
			self.state = "wounded"
		else
			self.wounded = false
			self.state = "unhurt"
		end

		self.down_reset_timer = nil

		if self.skin_unit ~= nil then
			set_material_property(self.skin_unit, "damage_value", "mtr_skin", 1, true)
		else
			set_material_property(self.unit, "damage_value", "mtr_skin", 1, true)
		end

		self:sync_health_to_clients(false)
	end
end

ChaosTrollHealthExtension.die = function (self, arg_15_1)
	-- function 15
	local unit = self.unit

	if not ScriptUnit.has_extension(unit, "ai_system") then
		arg_15_1 = arg_15_1 or "undefined"

		self:force_set_wounded()
		AiUtils.kill_unit(unit, nil, nil, arg_15_1, nil)
	end
end

ChaosTrollHealthExtension.sync_health_to_clients = function (self, arg_16_1)
	-- function 16
	local _game_object_id = self._game_object_id

	_game_object_id = _game_object_id or Managers.state.unit_storage:go_id(self.unit)
	self._game_object_id = _game_object_id

	local var_16_1 = NetworkLookup.health_statuses[self.state]
	local flag = false
	local var_16_3

	if not arg_16_1 then
		var_16_3 = self.health
	else
		var_16_3 = math.max(0, self.damage)
	end

	self.network_transmit:send_rpc_clients("rpc_sync_damage_taken", self._game_object_id, flag, arg_16_1 or false, var_16_3, var_16_1)
end

ChaosTrollHealthExtension.min_health_reached = function (self)
	-- function 17
	return self.health - self.damage <= self.respawn_hp_min
end

ChaosTrollHealthExtension.force_set_wounded = function (self)
	-- function 18
	self.wounded = true
	self.state = "wounded"
end

ChaosTrollHealthExtension.add_heal = function (self, ...)
	-- function 19
	ChaosTrollHealthExtension.super.add_heal(self, ...)
	self:sync_health_to_clients(false)
end
