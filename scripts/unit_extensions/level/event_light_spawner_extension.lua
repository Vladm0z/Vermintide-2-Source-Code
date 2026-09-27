-- chunkname: @scripts/unit_extensions/level/event_light_spawner_extension.lua

EventLightSpawnerExtension = class(EventLightSpawnerExtension)

local num = 1

EventLightSpawnerExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self.world = arg_1_1.world
	self.unit = arg_1_2
	self.is_server = Managers.player.is_server
	self.unit_spawner = Managers.state.unit_spawner
	self._units = {}
	self._spawn_pool = {}
	self._spawn_pool_timer = 0
	self._spawn_pool_spawn_index = 1
	self._spawn_pool_add_index = 1
	self._num_raycasts = 0

	local speed = arg_1_3.speed

	if not speed then
		speed = Unit.get_data(arg_1_2, "speed")
		speed = speed or 1
	end

	self._speed = speed

	local respawn_timer = arg_1_3.respawn_timer

	if not respawn_timer then
		respawn_timer = Unit.get_data(arg_1_2, "respawn_timer")
		respawn_timer = respawn_timer or 10
	end

	self._respawn_timer = respawn_timer

	local first_spawn_delay = arg_1_3.first_spawn_delay

	if not first_spawn_delay then
		first_spawn_delay = Unit.get_data(arg_1_2, "first_spawn_delay")
		first_spawn_delay = first_spawn_delay or 0
	end

	self._first_spawn_delay = first_spawn_delay

	local unit_to_spawn = arg_1_3.unit_to_spawn

	unit_to_spawn = unit_to_spawn or Unit.get_data(arg_1_2, "unit_to_spawn")
	self._unit_to_spawn = unit_to_spawn

	local get_data = Unit.get_data(arg_1_2, "light_intensity")

	get_data = get_data or 1
	self._light_intensity = get_data
	self._active = false

	Unit.set_unit_visibility(self.unit, false)

	if not self.is_server then
		for i = 1, 4 do
			local tbl = {
				speed = self._speed,
				id = i,
				respawn_time = self._respawn_timer - self._first_spawn_delay
			}

			self._units[i] = tbl
		end
	end
end

EventLightSpawnerExtension.update = function (self, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
	-- function 2
	if not self.is_server then
		return
	end

	local get_data = Unit.get_data(arg_2_1, "active")

	if self._active or not get_data then
		self:_activate()
	elseif not (not self._active and get_data) then
		self:_deactivate()
	end

	if not self._active then
		local _units = self._units
		local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

		for k, v in pairs(PLAYER_AND_BOT_UNITS) do
			local var_2_3 = _units[k]

			if not var_2_3.unit then
				var_2_3.respawn_time = var_2_3.respawn_time + arg_2_3

				local chase_target = var_2_3.chase_target

				if (not (var_2_3.respawn_time >= self._respawn_timer) or not chase_target) and not Unit.alive(chase_target) then
					self:_add_to_spawn_pool(var_2_3.id)

					var_2_3.respawn_time = 0
				end
			end
		end

		self:_update_spawn_pool(arg_2_3)
		self:_update_units(arg_2_4, arg_2_3)
	end
end

EventLightSpawnerExtension._update_units = function (self, arg_3_1, arg_3_2)
	-- function 3
	local _units = self._units

	for k, v in pairs(_units) do
		local flag = not v and v.unit
		local chase_target = v.chase_target

		if not chase_target then
			self:_sync_light_units()
		end

		if not chase_target and not Unit.alive(chase_target) and not flag and not Unit.alive(flag) then
			local local_position = Unit.local_position(flag, 0)
			local flag_2 = not chase_target and POSITION_LOOKUP[chase_target] + Vector3.up()
			local physics_world = World.physics_world(arg_3_1.world)
			local num = flag_2 - local_position

			num = Vector3.length(num) ~= 0 or not Vector3.down() or Vector3.normalize(num)

			local num_2 = 1

			PhysicsWorld.prepare_actors_for_raycast(physics_world, local_position, num, 0.1)

			local immediate_raycast = PhysicsWorld.immediate_raycast(physics_world, local_position, num, num_2, "all", "collision_filter", "filter_player_hit_box_and_static_check")

			if not immediate_raycast then
				local count = #immediate_raycast

				for k_2 = 1, count do
					local var_3_10 = immediate_raycast[k_2][4]
					local unit = Actor.unit(var_3_10)

					if not (AiUtils.unit_breed(unit) or k_2 ~= count) then
						self:_explode_spirit(flag)

						v.unit = nil
					elseif unit == chase_target then
						local warpfire_thrower_explosion = DamageProfileTemplates.warpfire_thrower_explosion
						local num_3 = 100
						local num_4 = local_position - flag_2
						local normalize = Vector3.normalize(num_4)
						local owner = Managers.player:owner(chase_target)

						if not (not owner and owner:is_player_controlled()) then
							DamageUtils.add_damage_network_player(warpfire_thrower_explosion, nil, num_3, chase_target, flag, "full", flag_2, normalize, "undefined", nil, 0, false, nil, false, 0, 1)
						end

						self:_explode_spirit(flag)

						v.unit = nil
					end
				end
			end
		end
	end

	for k_3, v_2 in pairs(_units) do
		local unit_2 = v_2.unit

		if not unit_2 then
			local local_position_2 = Unit.local_position(unit_2, 0)
			local chase_target_2 = v_2.chase_target

			if not Unit.alive(chase_target_2) then
				local flag_3 = not chase_target_2 and POSITION_LOOKUP[chase_target_2]
				local owner_2 = Managers.player:owner(chase_target_2)
				local flag_4 = not owner_2 and owner_2:is_player_controlled()

				if not flag_3 and not flag_4 then
					local num_5 = flag_3 + Vector3(0, 0, 1) - local_position_2
					local num_6 = local_position_2 + Vector3.normalize(num_5) * (arg_3_2 * v_2.speed)

					Unit.set_local_position(unit_2, 0, num_6)
				elseif not (not flag_3 and flag_4) then
					local num_7 = flag_3 + Vector3(0, 0, 1) - local_position_2
					local length = Vector3.length(num_7)
					local max

					if length < 3 then
						max = math.max(0, length - 2)

						if not max then
							-- Nothing
						end
					end

					max = 1

					::label_3_0::

					local num_8 = local_position_2 + Vector3.normalize(num_7) * (arg_3_2 * v_2.speed) * max

					Unit.set_local_position(unit_2, 0, num_8)
				end
			else
				v_2.chase_target = nil

				self:_explode_spirit(v_2.unit)

				v_2.unit = nil
			end
		end
	end
end

EventLightSpawnerExtension._update_spawn_pool = function (self, arg_4_1)
	-- function 4
	local _spawn_pool = self._spawn_pool

	if not _spawn_pool[self._spawn_pool_spawn_index] then
		self._spawn_pool_timer = self._spawn_pool_timer + arg_4_1

		if self._spawn_pool_timer > 1 then
			self._spawn_pool_timer = self._spawn_pool_timer - 1

			local spawn_network_unit = self.unit_spawner:spawn_network_unit(self._unit_to_spawn, "position_synched_light_unit", nil, Unit.local_position(self.unit, 0))

			Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_bastion_sorcerer_boss_magic_ball_spawn", spawn_network_unit)

			local var_4_2 = _spawn_pool[self._spawn_pool_spawn_index]

			self._units[var_4_2].unit = spawn_network_unit
			_spawn_pool[self._spawn_pool_spawn_index] = nil
			self._spawn_pool_spawn_index = self._spawn_pool_spawn_index + 1
		end
	end
end

EventLightSpawnerExtension._add_to_spawn_pool = function (self, arg_5_1)
	-- function 5
	self._spawn_pool[self._spawn_pool_add_index] = arg_5_1
	self._spawn_pool_add_index = self._spawn_pool_add_index + 1
end

EventLightSpawnerExtension._activate = function (self)
	-- function 6
	self._active = true

	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for k, v in pairs(PLAYER_AND_BOT_UNITS) do
		self._units[k].chase_target = v
	end
end

EventLightSpawnerExtension._deactivate = function (self)
	-- function 7
	self._active = false

	local _units = self._units

	for i = 1, #_units do
		local unit = _units[i].unit

		if not unit then
			self:_explode_spirit(unit)

			_units[i].chase_target = nil
			_units[i].unit = nil
		end
	end
end

EventLightSpawnerExtension._explode_spirit = function (arg_8_0, arg_8_1)
	-- function 8
	local local_position = Unit.local_position(arg_8_1, 0)
	local world_rotation = Unit.world_rotation(arg_8_1, 0)

	Managers.state.entity:system("area_damage_system"):create_explosion(arg_8_1, local_position, world_rotation, "bastion_light_spirit", 1, "undefined", 0, false)
	Managers.state.entity:system("audio_system"):play_audio_unit_event("Play_bastion_sorcerer_boss_magic_ball_explode", arg_8_1)
	Managers.state.unit_spawner:mark_for_deletion(arg_8_1)
end

EventLightSpawnerExtension._sync_light_units = function (self)
	-- function 9
	if not self.is_server then
		return
	end

	local _units = self._units
	local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

	for i, v in ipairs(_units) do
		if not (not v.chase_target and Unit.alive(v.chase_target)) then
			v.chase_target = nil
		end
	end

	for k, v_2 in pairs(PLAYER_AND_BOT_UNITS) do
		local var_9_2
		local var_9_3

		for i_2, v_3 in ipairs(_units) do
			if not v_3.chase_target then
				if v_3.chase_target == v_2 then
					var_9_3 = true

					break
				end
			else
				var_9_2 = var_9_2 or v_3
			end
		end

		if var_9_3 or not var_9_2 then
			self:_add_to_spawn_pool(var_9_2.id)

			var_9_2.chase_target = v_2

			break
		end
	end
end
