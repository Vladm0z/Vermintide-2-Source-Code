-- chunkname: @scripts/unit_extensions/generic/chaos_troll_husk_health_extension.lua

ChaosTrollHuskHealthExtension = class(ChaosTrollHuskHealthExtension, GenericHealthExtension)

local set_material_property = AiUtils.set_material_property

ChaosTrollHuskHealthExtension.init = function (self, arg_1_1, arg_1_2, ...)
	-- function 1
	ChaosTrollHuskHealthExtension.super.init(self, arg_1_1, arg_1_2, ...)

	self._regen_time = Managers.time:time("game") + 1
	self.pulse_time = 0
	self.state = "unhurt"

	local flag = true

	self:_setup_initial_health_variables(self.health, flag)

	self.network_event_delegate = arg_1_1.system_data.network_event_delegate

	self.network_event_delegate:register(self, "rpc_sync_current_max_health")

	self.skin_unit = nil

	local has_extension = ScriptUnit.has_extension(self.unit, "ai_inventory_system")

	if not has_extension then
		self.skin_unit = has_extension:get_skin_unit()
	end
end

ChaosTrollHuskHealthExtension.set_max_health = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not arg_2_2 then
		arg_2_1 = DamageUtils.networkify_health(arg_2_1)
		self.current_max_health = arg_2_1
	else
		arg_2_1 = ChaosTrollHuskHealthExtension.super.set_max_health(self, arg_2_1)

		self:_setup_initial_health_variables(arg_2_1)
	end

	return arg_2_1
end

ChaosTrollHuskHealthExtension._setup_initial_health_variables = function (self, arg_3_1, arg_3_2)
	-- function 3
	local _breed = self._breed
	local downed = BreedActions[_breed.name].downed

	self.regen_pulse_interval = _breed.regen_pulse_interval
	self.downed_pulse_interval = _breed.downed_pulse_interval
	self.regen_pulse_intensity = _breed.regen_pulse_intensity
	self.downed_pulse_intensity = _breed.downed_pulse_intensity
	self.action = downed
	self.respawn_hp_max = arg_3_1
	self.go_down_health = self:respawn_thresholds(arg_3_1, arg_3_1)
end

ChaosTrollHuskHealthExtension.current_max_health_percent = function (self)
	-- function 4
	return self.health / self.current_max_health
end

local num = 0.0001

ChaosTrollHuskHealthExtension.respawn_thresholds = function (self, arg_5_1, arg_5_2)
	-- function 5
	local action = self.action
	local flag = arg_5_1 or self.current_max_health
	local flag_2 = arg_5_2 or self.health
	local var_5_3
	local var_5_4
	local var_5_5

	if not action.fixed_hp_chunks then
		local num_2 = flag / action.fixed_hp_chunks

		if num_2 % 1 ~= 0 then
			flag_2 = math.round_to_closest_multiple(flag_2, num_2 % 1)
		end

		local ceil = math.ceil(math.round_to_closest_multiple(flag_2 / num_2, num))

		var_5_3 = math.clamp(ceil - 1, 0, action.fixed_hp_chunks) * num_2
		var_5_4 = var_5_3 + num_2 * action.respawn_hp_chunk_percent
		var_5_5 = action.fixed_hp_chunks - ceil + 1
	else
		var_5_3 = flag_2 * action.become_downed_hp_percent
		var_5_4 = flag_2 * action.respawn_hp_min_percent
	end

	return var_5_3, var_5_4, var_5_3 / flag, var_5_4 / flag, var_5_5
end

ChaosTrollHuskHealthExtension.update = function (self, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	if self.state == "dead" then
		return
	end

	if self.state == "down" then
		ChaosTrollHealthExtension.update_regen_effect(self, arg_6_3, arg_6_1, self.downed_pulse_interval, self.downed_pulse_intensity)

		if arg_6_3 > self.start_reset_time then
			self.down_reset_timer = self.down_reset_timer + arg_6_1

			local num

			if self.action.reset_duration > 0 then
				num = self.down_reset_timer / self.action.reset_duration

				if not num then
					-- Nothing
				end
			end

			num = 0

			::label_6_0::

			local num_2 = 1 - num

			if self.skin_unit ~= nil then
				set_material_property(self.skin_unit, "damage_value", "mtr_skin", num_2, true)
			else
				set_material_property(self.unit, "damage_value", "mtr_skin", num_2, true)
			end
		end
	elseif not (self.state == "unhurt" or self.state ~= "wounded") then
		ChaosTrollHealthExtension.update_regen_effect(self, arg_6_3, arg_6_1, self.regen_pulse_interval, self.regen_pulse_intensity)

		if arg_6_3 > self._regen_time then
			self._regen_time = arg_6_3 + self.regen_pulse_interval
			self.pulse_time = 0
		end
	end
end

ChaosTrollHuskHealthExtension.apply_client_predicted_damage = function (arg_7_0, arg_7_1)
	-- function 7
	return
end

ChaosTrollHuskHealthExtension.add_damage = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_16, arg_8_17)
	-- function 8
	local unit = self.unit
	local _add_to_damage_history_buffer = self:_add_to_damage_history_buffer(unit, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5, arg_8_6, arg_8_7, arg_8_8, arg_8_9, arg_8_10, arg_8_11, arg_8_12, arg_8_13, arg_8_14, arg_8_15, arg_8_17)

	StatisticsUtil.register_damage(unit, _add_to_damage_history_buffer, self.statistics_db)
	self:save_kill_feed_data(arg_8_1, _add_to_damage_history_buffer, arg_8_3, arg_8_4, arg_8_7, arg_8_9)
	fassert(arg_8_4, "No damage_type!")

	self._recent_damage_type = arg_8_4
	self._recent_hit_react_type = arg_8_10

	DamageUtils.handle_hit_indication(arg_8_1, unit, arg_8_2, arg_8_3, arg_8_12)
end

ChaosTrollHuskHealthExtension.add_heal = function (self, arg_9_1, arg_9_2, arg_9_3, arg_9_4)
	-- function 9
	local unit = self.unit

	self:_add_to_damage_history_buffer(unit, arg_9_1, -arg_9_2, nil, "heal", nil, nil, arg_9_3, nil, nil, nil, nil, nil, nil, nil, nil, nil)
end

ChaosTrollHuskHealthExtension.sync_damage_taken = function (self, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	if not arg_10_2 then
		if not self._has_got_initial_setup then
			self:set_max_health(arg_10_1, true)

			self._has_got_initial_setup = true
		else
			ChaosTrollHealthExtension.super.set_max_health(self, arg_10_1)
		end

		return
	end

	self.damage = arg_10_1
	self._first_damage_occured = true

	if self.state ~= arg_10_3 then
		if arg_10_3 == "down" then
			set_material_property(self.unit, "damage_value", "mtr_skin", 1, true)

			self.start_reset_time = Managers.time:time("game") + (AiUtils.downed_duration(self.action) + self.action.standup_anim_duration - self.action.reset_duration)
			self.down_reset_timer = 0
		elseif not (arg_10_3 == "wounded" or arg_10_3 ~= "unhurt") then
			set_material_property(self.unit, "damage_value", "mtr_skin", 0, true)
		elseif arg_10_3 == "dead" then
			set_material_property(self.unit, "regen_value", "mtr_skin", 0, true)
		end

		self.state = arg_10_3
	elseif arg_10_3 == "unhurt" then
		local num = self.damage / math.max(self.health - self.go_down_health, 0.01)

		set_material_property(self.unit, "damage_value", "mtr_skin", num, true)
	elseif arg_10_3 == "wounded" then
		local num_2 = self.damage / (self.health - self.damage)

		set_material_property(self.unit, "damage_value", "mtr_skin", num_2, true)
	end
end

ChaosTrollHuskHealthExtension.rpc_sync_current_max_health = function (self, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	local game_object_id = self.game_object_id

	game_object_id = game_object_id or Managers.state.unit_storage:go_id(self.unit)

	if game_object_id ~= arg_11_2 then
		return
	end

	self.current_max_health = DamageUtils.networkify_health(arg_11_3)
end

ChaosTrollHuskHealthExtension.destroy = function (self)
	-- function 12
	ChaosTrollHuskHealthExtension.super:destroy()
	self.network_event_delegate:unregister(self)
end
