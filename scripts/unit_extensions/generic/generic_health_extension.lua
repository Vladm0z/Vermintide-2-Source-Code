-- chunkname: @scripts/unit_extensions/generic/generic_health_extension.lua

DamageDataIndex = {}

local tbl = {
	"DAMAGE_AMOUNT",
	"DAMAGE_TYPE",
	"ATTACKER",
	"HIT_ZONE",
	"POSITION",
	"DIRECTION",
	"DAMAGE_SOURCE_NAME",
	"HIT_RAGDOLL_ACTOR_NAME",
	"SOURCE_ATTACKER_UNIT",
	"HIT_REACT_TYPE",
	"CRITICAL_HIT",
	"FIRST_HIT",
	"TOTAL_HITS",
	"ATTACK_TYPE",
	"BACKSTAB_MULTIPLIER",
	"TARGET_INDEX"
}

for i, v in ipairs(tbl) do
	DamageDataIndex[v] = i
end

DamageDataIndex.STRIDE = #tbl

local DamageDataIndex = DamageDataIndex
local num = 5

GenericHealthExtension = class(GenericHealthExtension)

GenericHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
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
	self._breed = arg_1_3.breed

	local health = arg_1_3.health

	health = health or Unit.get_data(arg_1_2, "health")

	if health == -1 then
		self.is_invincible = true
		health = math.huge
	else
		self.is_invincible = false
	end

	self.dead = false
	self.predicted_dead = false
	self.state = "alive"

	local damage = arg_1_3.damage

	damage = damage or 0
	self.damage = damage
	self.predicted_damage = 0
	self.last_damage_data = {}
	self._health_system = arg_1_1.owning_system
	self._recent_attackers = {}

	local set_max_health = self:set_max_health(health)

	self.unmodified_max_health = set_max_health
	self._min_health_percentage = nil
	self._recent_damage_type = nil
	self._recent_hit_react_type = nil
	self._last_damage_t = nil

	local damage_cap_per_hit = arg_1_3.damage_cap_per_hit

	damage_cap_per_hit = damage_cap_per_hit or Unit.get_data(arg_1_2, "damage_cap_per_hit")
	self._damage_cap = damage_cap_per_hit

	local _damage_cap = self._damage_cap

	_damage_cap = _damage_cap or set_max_health
	self._damage_cap_per_hit = _damage_cap
end

GenericHealthExtension.destroy = function (self)
	-- function 2
	if not self._recent_attackers then
		for k, v in pairs(self._recent_attackers) do
			self._health_system:return_recent_attacker(v)

			self._recent_attackers[k] = nil
		end
	end
end

GenericHealthExtension.freeze = function (self)
	-- function 3
	self:set_dead()
end

GenericHealthExtension.unfreeze = function (self)
	-- function 4
	self:reset()
end

GenericHealthExtension.reset = function (self)
	-- function 5
	self.state = "alive"
	self.dead = false
	self.predicted_dead = false
	self.damage = 0
	self.predicted_damage = 0
	self._recent_damage_type = nil
	self._recent_hit_react_type = nil

	pdArray.set_empty(self.damage_buffers[1])
	pdArray.set_empty(self.damage_buffers[2])
	self:set_max_health(self.unmodified_max_health)
	table.clear(self.last_damage_data)

	HEALTH_ALIVE[self.unit] = true

	if not self._recent_attackers then
		for k, v in pairs(self._recent_attackers) do
			self._health_system:return_recent_attacker(v)

			self._recent_attackers[k] = nil
		end
	end
end

GenericHealthExtension.hot_join_sync = function (self, arg_6_1)
	-- function 6
	local unit = self.unit
	local game_object_or_level_id, var_6_2 = Managers.state.network:game_object_or_level_id(unit)

	if not game_object_or_level_id then
		local var_6_3 = NetworkLookup.health_statuses[self.state]
		local get_damage_taken = self:get_damage_taken()
		local get_network_safe_damage_hotjoin_sync = NetworkUtils.get_network_safe_damage_hotjoin_sync(get_damage_taken)
		local network_transmit = self.network_transmit

		network_transmit:send_rpc("rpc_sync_damage_taken", arg_6_1, game_object_or_level_id, var_6_2, false, get_network_safe_damage_hotjoin_sync, var_6_3)

		if not self.dead then
			local num = 0
			local full = NetworkLookup.hit_zones.full
			local sync_health = NetworkLookup.damage_types.sync_health
			local world_position = Unit.world_position(unit, 0)
			local up = Vector3.up()
			local invalid_game_object_id = NetworkConstants.invalid_game_object_id
			local var_6_13 = NetworkLookup.damage_sources["n/a"]
			local var_6_14 = NetworkLookup.hit_ragdoll_actors["n/a"]
			local light = NetworkLookup.hit_react_types.light
			local var_6_16 = NetworkLookup.buff_attack_types["n/a"]
			local flag = true
			local flag_2 = false
			local flag_3 = false
			local flag_4 = false
			local num_2 = 0
			local num_3 = 1
			local num_4 = 0

			num_4 = num_4 or 1

			network_transmit:send_rpc("rpc_add_damage", arg_6_1, game_object_or_level_id, var_6_2, game_object_or_level_id, var_6_2, invalid_game_object_id, num, full, sync_health, world_position, up, var_6_13, var_6_14, light, flag, flag_2, flag_3, flag_4, num_2, var_6_16, num_3, num_4)
		end
	end
end

GenericHealthExtension.set_server_damage_taken = function (self, arg_7_1)
	-- function 7
	fassert(self.is_server, "[GenericHealthExtension] Only server is allowed to call this function")

	local unit = self.unit
	local game_object_or_level_id, var_7_2 = Managers.state.network:game_object_or_level_id(unit)

	if not game_object_or_level_id then
		local var_7_3 = NetworkLookup.health_statuses[self.state]

		self.network_transmit:send_rpc_clients("rpc_sync_damage_taken", game_object_or_level_id, var_7_2, false, arg_7_1, var_7_3)
	end

	self.damage = arg_7_1
end

GenericHealthExtension.is_alive = function (self)
	-- function 8
	return not self.dead
end

GenericHealthExtension.client_predicted_is_alive = function (self)
	-- function 9
	return not not self.dead or not self.predicted_dead
end

GenericHealthExtension.current_health_percent = function (self)
	-- function 10
	return 1 - self.damage / self.health
end

GenericHealthExtension.current_health = function (self)
	-- function 11
	return self.health - self.damage
end

GenericHealthExtension.get_damage_taken = function (self)
	-- function 12
	return self.damage
end

GenericHealthExtension.set_current_damage = function (self, arg_13_1)
	-- function 13
	self.damage = arg_13_1
end

GenericHealthExtension.set_min_health_percentage = function (self, arg_14_1)
	-- function 14
	self._min_health_percentage = arg_14_1
end

GenericHealthExtension.get_max_health = function (self)
	-- function 15
	return self.health
end

GenericHealthExtension.is_dead = function (self)
	-- function 16
	return self.dead
end

GenericHealthExtension.current_max_health_percent = function (arg_17_0)
	-- function 17
	return 1
end

GenericHealthExtension.set_max_health = function (self, arg_18_1)
	-- function 18
	local health = NetworkConstants.health
	local clamp = math.clamp(arg_18_1, health.min, health.max)
	local num = clamp % 1
	local num_2 = math.round(num * 4) * 0.25
	local num_3 = math.floor(clamp) + num_2

	num_3 = not (num_3 <= 0) or not 1 or num_3
	self.health = num_3

	local _damage_cap = self._damage_cap

	_damage_cap = _damage_cap or self.health
	self._damage_cap_per_hit = _damage_cap

	local game_object_or_level_id, var_18_7 = Managers.state.network:game_object_or_level_id(self.unit)

	if not self.is_server and not game_object_or_level_id then
		local var_18_8 = NetworkLookup.health_statuses[self.state]

		self.network_transmit:send_rpc_clients("rpc_sync_damage_taken", game_object_or_level_id, var_18_7, true, num_3, var_18_8)
	end

	return num_3
end

GenericHealthExtension._add_to_damage_history_buffer = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5, arg_19_6, arg_19_7, arg_19_8, arg_19_9, arg_19_10, arg_19_11, arg_19_12, arg_19_13, arg_19_14, arg_19_15, arg_19_16, arg_19_17)
	-- function 19
	local tbl

	if not arg_19_6 then
		tbl = {
			arg_19_6.x,
			arg_19_6.y,
			arg_19_6.z
		}

		if not tbl then
			-- Nothing
		end
	end

	tbl = nil

	do
		local tbl_2
	end

	::label_19_0::

	if not arg_19_7 then
		tbl_2 = {
			arg_19_7.x,
			arg_19_7.y,
			arg_19_7.z
		}

		if not tbl_2 then
			-- Nothing
		end
	end

	tbl_2 = nil

	::label_19_1::

	local var_19_2 = self.damage_buffers[self.system_data.active_damage_buffer_index]
	local alloc_table = FrameTable.alloc_table()

	alloc_table[DamageDataIndex.DAMAGE_AMOUNT] = arg_19_3
	alloc_table[DamageDataIndex.DAMAGE_TYPE] = arg_19_5
	alloc_table[DamageDataIndex.ATTACKER] = arg_19_2
	alloc_table[DamageDataIndex.HIT_ZONE] = arg_19_4
	alloc_table[DamageDataIndex.POSITION] = tbl
	alloc_table[DamageDataIndex.DIRECTION] = tbl_2
	alloc_table[DamageDataIndex.DAMAGE_SOURCE_NAME] = arg_19_8 or "n/a"
	alloc_table[DamageDataIndex.HIT_RAGDOLL_ACTOR_NAME] = arg_19_9 or "n/a"
	alloc_table[DamageDataIndex.SOURCE_ATTACKER_UNIT] = arg_19_10 or arg_19_2
	alloc_table[DamageDataIndex.HIT_REACT_TYPE] = arg_19_11 or "light"
	alloc_table[DamageDataIndex.CRITICAL_HIT] = arg_19_12 or false
	alloc_table[DamageDataIndex.FIRST_HIT] = arg_19_13 or false
	alloc_table[DamageDataIndex.TOTAL_HITS] = arg_19_14 or 0
	alloc_table[DamageDataIndex.ATTACK_TYPE] = arg_19_15 or "n/a"
	alloc_table[DamageDataIndex.BACKSTAB_MULTIPLIER] = arg_19_16 or false
	alloc_table[DamageDataIndex.TARGET_INDEX] = arg_19_17 or 1

	pdArray.push_back16(var_19_2, unpack(alloc_table))

	return alloc_table
end

GenericHealthExtension._should_die = function (self)
	-- function 20
	return self.damage >= self.health
end

GenericHealthExtension.apply_client_predicted_damage = function (self, arg_21_1)
	-- function 21
	fassert(not self.is_server, "This should only be used for the clients!")

	if not self:get_is_invincible() then
		local min = math.min(arg_21_1, self._damage_cap_per_hit)

		self.predicted_damage = self.predicted_damage + min
		self.predicted_dead = self.damage + self.predicted_damage >= self.health
	else
		self.predicted_dead = false
	end
end

GenericHealthExtension.add_damage = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)
	-- function 22
	local unit = self.unit
	local game_object_or_level_id, var_22_2 = Managers.state.network:game_object_or_level_id(unit)

	if not self._min_health_percentage then
		local current_health = self:current_health()
		local max = math.max(self._min_health_percentage * self.health, 0.25)
		local num = current_health - arg_22_2
		local max_2 = math.max(num, max)
		local max_3 = math.max(current_health - max_2, 0)

		arg_22_2 = DamageUtils.networkify_damage(max_3)
	end

	local get_actual_attacker_player = AiUtils.get_actual_attacker_player(arg_22_1, unit, arg_22_7)

	if not arg_22_9 then
		if not get_actual_attacker_player and not ALIVE[get_actual_attacker_player.player_unit] then
			arg_22_9 = get_actual_attacker_player.player_unit
		end

		if not arg_22_9 then
			local attacker_unit_id = self.last_damage_data.attacker_unit_id

			arg_22_9 = not attacker_unit_id and Managers.state.unit_storage:unit(attacker_unit_id)
		end

		arg_22_9 = AiUtils.get_actual_attacker_unit(arg_22_9 or arg_22_1)
	end

	if not get_actual_attacker_player then
		local var_22_10 = BLACKBOARDS[arg_22_9]
		local get_data

		if not ALIVE[arg_22_9] then
			get_data = Unit.get_data(arg_22_9, "breed")

			if not get_data then
				-- Nothing
			end
		end

		if not var_22_10 then
			get_data = var_22_10.breed

			if not get_data then
				-- Nothing
			end
		end

		get_data = ALIVE[arg_22_1]
		get_data = not get_data and Unit.get_data(arg_22_1, "breed")

		::label_22_0::

		local unique_id = get_actual_attacker_player:unique_id()
		local owner = Managers.player:owner(unit)

		if (unique_id == (not owner and owner:unique_id()) or not get_data) and not get_data.is_player then
			local time = Managers.time:time("game")

			self:_register_attacker(unique_id, get_data, time)
		end
	end

	local _add_to_damage_history_buffer = self:_add_to_damage_history_buffer(unit, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_9, arg_22_10, arg_22_11, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)

	fassert(arg_22_4, "No damage_type!")

	self._recent_damage_type = arg_22_4
	self._recent_hit_react_type = arg_22_10
	self._recent_damage_source_name = arg_22_7
	self._last_damage_t = Managers.time:time("game")

	StatisticsUtil.register_damage(unit, _add_to_damage_history_buffer, self.statistics_db)
	self:save_kill_feed_data(arg_22_1, _add_to_damage_history_buffer, arg_22_3, arg_22_4, arg_22_7, arg_22_9)
	DamageUtils.handle_hit_indication(arg_22_1, unit, arg_22_2, arg_22_3, arg_22_12)

	local num_2 = 0
	local has_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not has_extension then
		num_2 = not has_extension:has_buff_perk("ignore_death") and 1 and 0
	end

	if not (self:get_is_invincible() or self.dead) then
		local min = math.min(arg_22_2, self._damage_cap_per_hit)

		if num_2 > 0 then
			local current_health_2 = self:current_health()

			min = not (current_health_2 <= min) or not (current_health_2 - num_2) or min
		end

		self.damage = self.damage + min
		self.predicted_damage = math.max(self.predicted_damage - min, 0)

		if not (not self:_should_die() and self.is_server or game_object_or_level_id) then
			local get_data_2 = Unit.get_data(unit, "breed")

			if not (not get_data_2 and get_data_2.name ~= "skaven_poison_wind_globadier") then
				printf("[HON-43348] Globadier (%s) died. damage_table:\n\t%s", Unit.get_data(unit, "globadier_43348"), table.tostring(_add_to_damage_history_buffer))
			end

			Managers.state.entity:system("death_system"):kill_unit(unit, _add_to_damage_history_buffer)
		end
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_22_9, "buff_system")

	if not (not has_extension_2 and arg_22_7 ~= "dot_debuff") then
		has_extension_2:trigger_procs("on_dot_damage_dealt", unit, arg_22_9, arg_22_4, arg_22_7)
	end

	if not (not has_extension and not (arg_22_2 > 0) or arg_22_7 == "temporary_health_degen") then
		has_extension:trigger_procs("on_damage_taken", arg_22_1, arg_22_2, arg_22_4, arg_22_15)
	end

	self:_sync_out_damage(arg_22_1, game_object_or_level_id, var_22_2, arg_22_9, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6, arg_22_7, arg_22_8, arg_22_10, arg_22_11, arg_22_12, arg_22_13, arg_22_14, arg_22_15, arg_22_16, arg_22_17)
end

GenericHealthExtension._sync_out_damage = function (self, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5, arg_23_6, arg_23_7, arg_23_8, arg_23_9, arg_23_10, arg_23_11, arg_23_12, arg_23_13, arg_23_14, arg_23_15, arg_23_16, arg_23_17, arg_23_18, arg_23_19)
	-- function 23
	if not self.is_server and not arg_23_2 then
		local network = Managers.state.network
		local game_object_or_level_id, var_23_2 = network:game_object_or_level_id(arg_23_1)
		local unit_game_object_id = network:unit_game_object_id(arg_23_4)

		unit_game_object_id = unit_game_object_id or NetworkConstants.invalid_game_object_id

		local var_23_4 = NetworkLookup.hit_zones[arg_23_6]
		local var_23_5 = NetworkLookup.damage_types[arg_23_7]
		local var_23_6 = NetworkLookup.damage_sources[arg_23_10 or "n/a"]
		local var_23_7 = NetworkLookup.hit_ragdoll_actors[arg_23_11 or "n/a"]
		local var_23_8 = NetworkLookup.hit_react_types[arg_23_12 or "light"]
		local var_23_9 = NetworkLookup.buff_attack_types[arg_23_17 or "n/a"]
		local network_transmit = self.network_transmit
		local dead = self.dead

		dead = dead or false
		arg_23_13 = arg_23_13 or false
		arg_23_14 = arg_23_14 or false
		arg_23_15 = arg_23_15 or false
		arg_23_16 = arg_23_16 or 0
		arg_23_18 = arg_23_18 or 1
		arg_23_19 = arg_23_19 or 1

		network_transmit:send_rpc_clients("rpc_add_damage", arg_23_2, arg_23_3, game_object_or_level_id, var_23_2, unit_game_object_id, arg_23_5, var_23_4, var_23_5, arg_23_8, arg_23_9, var_23_6, var_23_7, var_23_8, dead, arg_23_13, arg_23_14, arg_23_15, arg_23_16, var_23_9, arg_23_18, arg_23_19)
	end
end

GenericHealthExtension.add_heal = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local unit = self.unit
	local has_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not has_extension and not has_extension:has_buff_perk("healing_immune") then
		return
	end

	self:_add_to_damage_history_buffer(unit, arg_24_1, -arg_24_2, nil, "heal", nil, nil, arg_24_3, nil, nil, nil, nil, nil, nil, nil, nil, nil)

	if not self.dead then
		self.damage = math.max(0, self.damage - arg_24_2)

		local game_object_or_level_id, var_24_3 = Managers.state.network:game_object_or_level_id(unit)

		if not game_object_or_level_id and not self.is_server then
			local game_object_or_level_id_2, var_24_5 = Managers.state.network:game_object_or_level_id(arg_24_1)
			local var_24_6 = NetworkLookup.heal_types[arg_24_4]

			self.network_transmit:send_rpc_clients("rpc_heal", game_object_or_level_id, var_24_3, game_object_or_level_id_2, var_24_5, arg_24_2, var_24_6)
		end
	end
end

GenericHealthExtension.die = function (self, arg_25_1)
	-- function 25
	if not self.is_server then
		local unit = self.unit

		if not ScriptUnit.has_extension(unit, "ai_system") then
			arg_25_1 = arg_25_1 or "undefined"

			AiUtils.kill_unit(unit, nil, nil, arg_25_1, nil)
		end
	end
end

GenericHealthExtension.entered_kill_volume = function (self, arg_26_1)
	-- function 26
	self:die("volume_insta_kill")
end

GenericHealthExtension.set_dead = function (self)
	-- function 27
	self.damage = self.health
	self.dead = true
	HEALTH_ALIVE[self.unit] = nil
end

GenericHealthExtension.has_assist_shield = function (arg_28_0)
	-- function 28
	return false
end

GenericHealthExtension.recent_damages = function (self)
	-- function 29
	local num = 3 - self.system_data.active_damage_buffer_index
	local var_29_1 = self.damage_buffers[num]

	return pdArray.data(var_29_1)
end

GenericHealthExtension.recent_damage_source = function (self)
	-- function 30
	return self._recent_damage_source_name
end

GenericHealthExtension.recently_damaged = function (self)
	-- function 31
	return self._recent_damage_type, self._recent_hit_react_type
end

GenericHealthExtension.last_damage_t = function (self)
	-- function 32
	return self._last_damage_t
end

GenericHealthExtension.get_is_invincible = function (self)
	-- function 33
	local unit = self.unit
	local flag = false
	local has_extension = ScriptUnit.has_extension(unit, "buff_system")

	if not has_extension then
		flag = has_extension:has_buff_perk("invulnerable")
	end

	local flag_2 = false
	local has_extension_2 = ScriptUnit.has_extension(unit, "ghost_mode_system")

	if not has_extension_2 then
		flag_2 = has_extension_2:is_in_ghost_mode()
	end

	local is_invincible = self.is_invincible

	is_invincible = is_invincible or flag or flag_2

	return is_invincible
end

GenericHealthExtension.save_kill_feed_data = function (self, arg_34_1, arg_34_2, arg_34_3, arg_34_4, arg_34_5, arg_34_6)
	-- function 34
	local unit = self.unit
	local last_damage_data = self.last_damage_data
	local flag = false
	local current_health = self:current_health()

	if not (arg_34_4 == "temporary_health_degen" or arg_34_4 == "knockdown_bleed" or not (current_health > 0)) then
		arg_34_1 = arg_34_6 or AiUtils.get_actual_attacker_unit(arg_34_1)

		if not HEALTH_ALIVE[arg_34_1] then
			local get_data = Unit.get_data(arg_34_1, "breed")

			if (arg_34_1 ~= unit or not get_data) and not get_data.is_player or arg_34_1 ~= unit or arg_34_4 ~= "cutting" or not get_data then
				last_damage_data.breed = get_data
				last_damage_data.damage_type = arg_34_4
				last_damage_data.attacker_unit_id = Managers.state.network:unit_game_object_id(arg_34_1)
				flag = true

				local owner = Managers.player:owner(arg_34_1)

				if not owner then
					last_damage_data.attacker_unique_id = owner:unique_id()
					last_damage_data.attacker_side = Managers.state.side.side_by_unit[arg_34_1]
				else
					last_damage_data.attacker_unique_id = nil
					last_damage_data.attacker_side = nil
				end
			end
		end
	end

	if not flag then
		local has_source_attacker_unit_data = Managers.state.entity:system("area_damage_system"):has_source_attacker_unit_data(arg_34_1)

		if not has_source_attacker_unit_data then
			last_damage_data.breed = has_source_attacker_unit_data.breed
			last_damage_data.attacker_unique_id = has_source_attacker_unit_data.attacker_unique_id
			last_damage_data.attacker_side = has_source_attacker_unit_data.attacker_side
		end
	end
end

GenericHealthExtension._register_attacker = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	local _recent_attackers = self._recent_attackers
	local var_35_1 = _recent_attackers[arg_35_1]
	local num_2 = arg_35_3 + num

	if not var_35_1 then
		self._health_system:refresh_recent_attacker(var_35_1, arg_35_2, num_2)
	else
		_recent_attackers[arg_35_1] = self._health_system:rent_recent_attacker(arg_35_2, num_2)
	end
end

GenericHealthExtension.was_attacked_by = function (self, arg_36_1)
	-- function 36
	local time = Managers.time:time("game")
	local var_36_1 = self._recent_attackers[arg_36_1]

	if not (not var_36_1 and not (time > var_36_1.t)) then
		self._health_system:return_recent_attacker(var_36_1)

		self._recent_attackers[arg_36_1] = nil

		return false
	end

	return var_36_1
end

GenericHealthExtension.recent_attackers = function (self)
	-- function 37
	return self._recent_attackers
end
