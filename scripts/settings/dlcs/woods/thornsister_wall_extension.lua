-- chunkname: @scripts/settings/dlcs/woods/thornsister_wall_extension.lua

ThornSisterWallExtension = class(ThornSisterWallExtension)

local num = 1

ThornSisterWallExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	self._is_server = Managers.state.network.is_server
	self._unit = arg_1_2
	self._life_time = arg_1_3.life_time
	self._owner_peer = arg_1_3.owner
	self._owner_unit = arg_1_3.owner_unit
	self._despawn_sound_event = arg_1_3.despawn_sound_event
	self.wall_index = arg_1_3.wall_index
	self.group_spawn_index = arg_1_3.group_spawn_index
	self._despawning = false
	self._initialized = false
	self.world = arg_1_1.world
	self._area_damage_extension = ScriptUnit.extension(self._unit, "area_damage_system")

	local has_extension = ScriptUnit.has_extension(self._owner_unit, "talent_system")

	if not has_extension and not has_extension:has_talent("kerillian_thorn_sister_debuff_wall") then
		self._is_explosive_wall = true

		local has_extension_2 = ScriptUnit.has_extension(self._owner_unit, "career_system")
		local get_career_power_level

		if not has_extension_2 then
			get_career_power_level = has_extension_2:get_career_power_level()

			if not get_career_power_level then
				-- Nothing
			end
		end

		get_career_power_level = 100

		::label_1_0::

		self._owner_career_power_level = get_career_power_level
	end

	local side = Managers.state.side
	local var_1_4 = side.side_by_unit[self._owner_unit]

	var_1_4 = var_1_4 or Managers.state.side:get_side_from_name("heroes")

	local side_id = var_1_4.side_id

	side:add_unit_to_side(arg_1_2, side_id)

	if not (Managers.mechanism:current_mechanism_name() == "versus") then
		local num = 1.25
		local box, var_1_8 = Unit.box(arg_1_2, false)
		local var_1_9

		if var_1_8[1] > var_1_8[2] then
			var_1_9 = var_1_8[1]

			if not var_1_9 then
				-- Nothing
			end
		end

		var_1_9 = var_1_8[2]

		::label_1_1::

		self._player_boss_trample_radius = var_1_9 * num
	end
end

ThornSisterWallExtension.game_object_initialized = function (self)
	-- function 2
	Managers.state.event:trigger("sister_wall_spawned", self._unit)
end

ThornSisterWallExtension.update = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not self._initialized then
		local _life_time = self._life_time

		self._despawn_t = arg_3_5 + _life_time
		self._despawn_anim_start_t = arg_3_5 + math.max(_life_time - num, 0)
		self._initialized = true

		self:trigger_area_damage()
	end

	self:_update_local_player_pactsworn_collision()
	self:_check_player_boss_trample()

	if not (self._despawning or not (arg_3_5 >= self._despawn_anim_start_t)) then
		self:despawn()
	end

	if not (not self._is_server and not (arg_3_5 >= self._despawn_t)) then
		Managers.state.side:remove_unit_from_side(self._unit)
		Managers.state.unit_spawner:mark_for_deletion(self._unit)
	end
end

ThornSisterWallExtension.trigger_area_damage = function (self)
	-- function 4
	self._area_damage_extension:enable_area_damage(true)

	if not self._is_server then
		local network = Managers.state.network
		local unit_game_object_id = network:unit_game_object_id(self._unit)

		network.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_area_damage", unit_game_object_id)
	end
end

local tbl = {}

ThornSisterWallExtension._despawn_single = function (self, arg_5_1, arg_5_2)
	-- function 5
	if not self._despawning then
		return
	end

	Managers.state.entity:system("death_system"):kill_unit(self._unit, tbl)

	if not self._versus_blocker_unit then
		World.destroy_unit(self.world, self._versus_blocker_unit)

		self._versus_blocker_unit = nil
	end

	if not self._is_server then
		self._area_damage_extension:enable_area_damage(false)
	end

	Unit.flow_event(self._unit, "despawn")

	self._despawning = true

	if not (not self._is_server and not self._despawn_sound_event and arg_5_1) then
		self:_trigger_despawn_sound(arg_5_2)
	end

	local min = math.min
	local _despawn_t = self._despawn_t

	_despawn_t = _despawn_t or math.huge
	self._despawn_t = min(_despawn_t, Managers.time:time("game") + num)
end

ThornSisterWallExtension._trigger_despawn_sound = function (self, arg_6_1)
	-- function 6
	local _owner_unit = self._owner_unit
	local var_6_1 = POSITION_LOOKUP[self._unit]

	if not arg_6_1 then
		local num = 1
		local get_entities = Managers.state.entity:get_entities("ThornSisterWallExtension")

		if not get_entities then
			local wall_index = self.wall_index

			for k, v in pairs(get_entities) do
				if not (k == self._unit or v.wall_index ~= wall_index or v._owner_unit ~= _owner_unit) then
					var_6_1 = var_6_1 + POSITION_LOOKUP[self._unit]
					num = num + 1
				end
			end
		end

		var_6_1 = var_6_1 / num
	end

	Managers.state.entity:system("audio_system"):play_audio_position_event(self._despawn_sound_event, var_6_1)
end

ThornSisterWallExtension.despawn = function (self, arg_7_1)
	-- function 7
	local _owner_unit = self._owner_unit
	local flag = false
	local flag_2 = not arg_7_1

	self:_despawn_single(flag, flag_2)

	if not arg_7_1 then
		return
	end

	local get_entities = Managers.state.entity:get_entities("ThornSisterWallExtension")

	if not get_entities then
		local flag_3 = true
		local var_7_5
		local wall_index = self.wall_index

		for k, v in pairs(get_entities) do
			if not (k == self._unit or v.wall_index ~= wall_index or v._owner_unit ~= _owner_unit) then
				v:_despawn_single(flag_3, var_7_5)
			end
		end
	end
end

ThornSisterWallExtension.die = function (self)
	-- function 8
	if not self._despawning then
		self:despawn()

		self._despawn_t = Managers.time:time("game") + num
	end
end

ThornSisterWallExtension.owner = function (self)
	-- function 9
	return self._owner_unit
end

ThornSisterWallExtension._update_local_player_pactsworn_collision = function (self)
	-- function 10
	if not (Managers.mechanism:current_mechanism_name() == "versus") then
		return
	end

	local local_player = Managers.player:local_player()
	local flag = not local_player and local_player.player_unit

	if not flag then
		return
	end

	local has_extension = ScriptUnit.has_extension(flag, "ghost_mode_system")

	if not has_extension then
		return
	end

	if not self._despawning then
		return
	end

	local is_in_ghost_mode = has_extension:is_in_ghost_mode()
	local flag_2 = self._local_player_in_ghost_mode ~= is_in_ghost_mode

	self._local_player_in_ghost_mode = is_in_ghost_mode

	if not flag_2 then
		if not is_in_ghost_mode then
			if not self._versus_blocker_unit then
				World.destroy_unit(self.world, self._versus_blocker_unit)

				self._versus_blocker_unit = nil
			end
		else
			local _unit = self._unit
			local local_position = Unit.local_position(_unit, 0)
			local local_rotation = Unit.local_rotation(_unit, 0)

			self._versus_blocker_unit = World.spawn_unit(self.world, "units/beings/player/way_watcher_thornsister/abilities/ww_thornsister_thorn_wall_01", local_position, local_rotation)

			Unit.set_unit_visibility(self._versus_blocker_unit, false)

			local actor = Unit.actor(self._versus_blocker_unit, "c_simple")

			Actor.set_collision_filter(actor, "filter_mover_blocker_pactsworn")
		end
	end
end

ThornSisterWallExtension._check_player_boss_trample = function (self)
	-- function 11
	local _player_boss_trample_radius = self._player_boss_trample_radius

	if not _player_boss_trample_radius and not self._despawning then
		return
	end

	local local_position = Unit.local_position(self._unit, 0)
	local ENEMY_PLAYER_AND_BOT_UNITS = Managers.state.side.side_by_unit[self._unit].ENEMY_PLAYER_AND_BOT_UNITS

	for k, v in pairs(ENEMY_PLAYER_AND_BOT_UNITS) do
		if not Unit.get_data(v, "breed").boss then
			local extension = ScriptUnit.extension(v, "ghost_mode_system")

			if not (not extension and extension:is_in_ghost_mode()) then
				local mover = Unit.mover(v)

				if not mover then
					local radius = Mover.radius(mover)
					local var_11_6 = POSITION_LOOKUP[v]
					local num = radius + _player_boss_trample_radius

					if Vector3.distance_squared(local_position, var_11_6) < num * num then
						local flag = true

						self:despawn(flag)

						break
					end
				end
			end
		end
	end
end

ThornSisterWallExtension.move_prop = function (self, arg_12_1)
	-- function 12
	local translation = Matrix4x4.translation(arg_12_1)
	local rotation = Matrix4x4.rotation(arg_12_1)

	Unit.set_local_position(self._unit, 0, translation)
	Unit.set_local_rotation(self._unit, 0, rotation)

	if not self._versus_blocker_unit then
		Unit.set_local_position(self._versus_blocker_unit, 0, translation)
		Unit.set_local_rotation(self._versus_blocker_unit, 0, rotation)
	end
end
