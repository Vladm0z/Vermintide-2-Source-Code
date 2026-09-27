-- chunkname: @scripts/unit_extensions/generic/explosive_barrel_health_extension.lua

ExplosiveBarrelHealthExtension = class(ExplosiveBarrelHealthExtension, GenericHealthExtension)

ExplosiveBarrelHealthExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	ExplosiveBarrelHealthExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self.in_hand = arg_1_3.in_hand
	self.item_name = arg_1_3.item_name

	local health_data = arg_1_3.health_data

	if not health_data then
		self.ignited = true
		self.explode_time = health_data.explode_time
		self.fuse_time = health_data.fuse_time
		self.last_damage_data.attacker_unit_id = health_data.attacker_unit_id
		self.insta_explode = not self.in_hand

		Unit.flow_event(arg_1_2, "exploding_barrel_fuse_init")
	end

	local owner_unit = arg_1_3.owner_unit

	if not owner_unit then
		self.owner_unit = owner_unit
		self.owner_unit_health_extension = ScriptUnit.extension(owner_unit, "health_system")
		self.ignored_damage_types = arg_1_3.ignored_damage_types
	end
end

ExplosiveBarrelHealthExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3)
	-- function 2
	local owner_unit_health_extension = self.owner_unit_health_extension

	if not owner_unit_health_extension then
		local recent_damages, var_2_2 = owner_unit_health_extension:recent_damages()

		for i = 1, var_2_2 / DamageDataIndex.STRIDE do
			local num = (i - 1) * DamageDataIndex.STRIDE
			local var_2_4 = recent_damages[num + DamageDataIndex.ATTACKER]
			local var_2_5 = recent_damages[num + DamageDataIndex.DAMAGE_AMOUNT]
			local var_2_6 = recent_damages[num + DamageDataIndex.DAMAGE_TYPE]
			local var_2_7 = recent_damages[num + DamageDataIndex.SOURCE_ATTACKER_UNIT]

			if not self.ignored_damage_types[var_2_6] then
				if var_2_6 == "heal" then
					self:add_heal(var_2_4, -var_2_5, nil, "n/a")
				else
					local var_2_8 = recent_damages[num + DamageDataIndex.HIT_ZONE]
					local unbox = Vector3Aux.unbox(recent_damages[num + DamageDataIndex.POSITION])
					local unbox_2 = Vector3Aux.unbox(recent_damages[num + DamageDataIndex.DIRECTION])
					local var_2_11 = recent_damages[num + DamageDataIndex.DAMAGE_SOURCE_NAME]

					self:add_damage(var_2_4, var_2_5, var_2_8, var_2_6, unbox, unbox_2, var_2_11, nil, var_2_7, nil, nil, nil, nil, nil, nil, nil, i)
				end
			end
		end
	end

	if not (not self.ignited and self._dead or self.exploded) then
		local network_time = Managers.state.network:network_time()
		local num_2 = (self.explode_time - network_time) / self.fuse_time

		Unit.set_data(self.unit, "fuse_time_percent", num_2)

		if network_time >= self.explode_time then
			self.insta_explode = true

			self:add_damage(self.unit, self.health, "full", "undefined", Unit.world_position(self.unit, 0), Vector3(0, 0, -1), nil, nil, self.last_attacker_unit, nil, nil, nil, nil, nil, nil, nil, 1)
		elseif not (self.in_hand or self.insta_explode or not (network_time >= self.insta_explode_time)) then
			self.insta_explode = true
		elseif not (self.played_fuse_out or not (network_time >= self.explode_time - 1.2)) then
			Unit.flow_event(self.unit, "exploding_barrel_fuse_out")

			self.played_fuse_out = true
		end
	end
end

ExplosiveBarrelHealthExtension.apply_client_predicted_damage = function (arg_3_0, arg_3_1)
	-- function 3
	return
end

ExplosiveBarrelHealthExtension.add_damage = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11, arg_4_12, arg_4_13, arg_4_14, arg_4_15, arg_4_16, arg_4_17)
	-- function 4
	if not (not arg_4_4 and arg_4_4 == "blade_storm" or arg_4_4 ~= "life_tap") then
		return
	end

	self.last_attacker_unit = arg_4_1

	local flag = arg_4_2 > 0
	local unit = self.unit
	local game_object_or_level_id, var_4_3 = Managers.state.network:game_object_or_level_id(unit)
	local _add_to_damage_history_buffer = self:_add_to_damage_history_buffer(unit, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_9, arg_4_10, arg_4_11, nil, nil, nil, nil, arg_4_17)

	StatisticsUtil.register_damage(unit, _add_to_damage_history_buffer, self.statistics_db)
	fassert(arg_4_4, "No damage_type!")

	self._recent_damage_type = arg_4_4
	self._recent_hit_react_type = arg_4_10

	self:save_kill_feed_data(arg_4_1, _add_to_damage_history_buffer, arg_4_3, arg_4_4, arg_4_7, arg_4_9)
	DamageUtils.handle_hit_indication(arg_4_1, unit, arg_4_2, arg_4_3, arg_4_12)

	if not (self:get_is_invincible() or self.dead) then
		local health

		if not flag and not self.insta_explode then
			health = self.health

			if not health then
				-- Nothing
			end
		end

		health = 0

		::label_4_0::

		self.damage = self.damage + health

		if not (not self:_should_die() and self.is_server or game_object_or_level_id) then
			Managers.state.entity:system("death_system"):kill_unit(unit, _add_to_damage_history_buffer)
		end
	end

	self:_sync_out_damage(arg_4_1, game_object_or_level_id, var_4_3, arg_4_9, arg_4_2, arg_4_3, arg_4_4, arg_4_5, arg_4_6, arg_4_7, arg_4_8, arg_4_10, arg_4_11, arg_4_12, arg_4_13, arg_4_14, arg_4_15, arg_4_16, arg_4_17)

	if not (not flag and self.ignited) then
		local network_time = Managers.state.network:network_time()
		local get_data

		if not Unit.has_data(unit, "fuse_time") then
			get_data = Unit.get_data(unit, "fuse_time")

			if not get_data then
				-- Nothing
			end
		end

		get_data = 4

		::label_4_1::

		local num = network_time + 0.2
		local num_2 = network_time + get_data

		Unit.flow_event(unit, "exploding_barrel_fuse_init")

		self.fuse_time = get_data
		self.explode_time = num_2
		self.ignited = true
		self.insta_explode_time = num
	elseif not (not flag and not self.ignited and not self.insta_explode and self.exploded) then
		self.exploded = true

		if not (not self.ignited and self.played_fuse_out) then
			Unit.flow_event(self.unit, "exploding_barrel_remove_fuse")
		end
	end
end

ExplosiveBarrelHealthExtension.health_data = function (self)
	-- function 5
	local last_damage_data = self.last_damage_data

	return {
		fuse_time = self.fuse_time,
		explode_time = self.explode_time,
		attacker_unit_id = last_damage_data.attacker_unit_id
	}
end
