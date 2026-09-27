-- chunkname: @scripts/unit_extensions/pickups/orb_pickup_unit_extension.lua

local num = 1
local num_2 = 1
local str = "boon_orb_pickup"

OrbPickupUnitExtension = class(OrbPickupUnitExtension, PickupUnitExtension)

OrbPickupUnitExtension.init = function (self, arg_1_1, arg_1_2, arg_1_3)
	-- function 1
	OrbPickupUnitExtension.super.init(self, arg_1_1, arg_1_2, arg_1_3)

	self._is_server = Managers.player.is_server
	self._unit = arg_1_2
	self._hero_side = Managers.state.side:get_side_from_name("heroes")
	self._pickup_settings = AllPickups[self.pickup_name]

	local orb_flight_target_position

	if not arg_1_3.flight_enabled then
		orb_flight_target_position = arg_1_3.orb_flight_target_position

		if not orb_flight_target_position then
			-- Nothing
		end
	end

	orb_flight_target_position = nil

	::label_1_0::

	self._orb_flight_target_position = orb_flight_target_position

	if not self._orb_flight_target_position then
		local orb_offset = self._pickup_settings.orb_offset

		if not orb_offset then
			local _orb_flight_target_position = self._orb_flight_target_position

			_orb_flight_target_position:store(_orb_flight_target_position:unbox() + Vector3Aux.unbox(orb_offset))
		end
	end

	local custom_orb_color = self._pickup_settings.custom_orb_color

	if not custom_orb_color then
		self:_set_custom_orb_color(custom_orb_color.core, custom_orb_color.shell)
	else
		Unit.flow_event(arg_1_2, "update_visuals")
	end

	self._hover = self._pickup_settings.hover_settings

	local _orb_flight_target_position_2 = self._orb_flight_target_position

	_orb_flight_target_position_2 = _orb_flight_target_position_2 or Vector3Box(POSITION_LOOKUP[arg_1_2])
	self._hover_from = _orb_flight_target_position_2
	self._magnetic = self._pickup_settings.magnetic_settings
	self._buff_params = {
		attacker_unit = arg_1_2
	}
end

OrbPickupUnitExtension.game_object_initialized = function (arg_2_0, arg_2_1, arg_2_2)
	-- function 2
	return
end

OrbPickupUnitExtension.extensions_ready = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return
end

OrbPickupUnitExtension.destroy = function (arg_4_0)
	-- function 4
	return
end

OrbPickupUnitExtension.update = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	-- function 5
	if not self._done then
		return
	end

	local PLAYER_AND_BOT_UNITS = self._hero_side.PLAYER_AND_BOT_UNITS
	local count = #PLAYER_AND_BOT_UNITS
	local POSITION_LOOKUP = POSITION_LOOKUP
	local world_position = Unit.world_position(arg_5_1, 0)
	local _pickup_settings = self._pickup_settings
	local local_only = _pickup_settings.local_only

	if self._is_server or not local_only then
		for i = 1, count do
			local var_5_6 = PLAYER_AND_BOT_UNITS[i]

			if not Unit.alive(var_5_6) then
				local num_3 = POSITION_LOOKUP[var_5_6] - world_position

				if math.abs(num_3.z) < 2 then
					num_3.z = 0
				end

				local length = Vector3.length(num_3)

				if not ((not not ScriptUnit.extension(var_5_6, "status_system"):is_disabled() or not _pickup_settings.can_pickup_orb) and _pickup_settings.can_pickup_orb(_pickup_settings, var_5_6)) then
					local pickup_radius = _pickup_settings.pickup_radius

					pickup_radius = pickup_radius or 1

					if length < pickup_radius then
						if not _pickup_settings.granted_buff then
							local system = Managers.state.entity:system("buff_system")

							if not system then
								local buff_sync_type = _pickup_settings.buff_sync_type

								buff_sync_type = buff_sync_type or BuffSyncType.All

								system:add_buff_synced(var_5_6, _pickup_settings.granted_buff, buff_sync_type, self._buff_params)
							end
						end

						local system_2 = Managers.state.entity:system("audio_system")

						if not system_2 then
							local network_id = Managers.player:owner(var_5_6):network_id()
							local pickup_sound = _pickup_settings.pickup_sound

							pickup_sound = pickup_sound or str

							system_2:play_2d_audio_unit_event_for_peer(pickup_sound, network_id)
						end

						if not _pickup_settings.on_orb_pickup then
							_pickup_settings.on_orb_pickup(arg_5_1)
						end

						Managers.state.unit_spawner:mark_for_deletion(arg_5_1)

						self._done = true

						break
					elseif not (not self._magnetic and not (length < self._magnetic.radius) or self._magnetic_target) then
						self:ensure_magnetic_target(var_5_6)
					end
				end
			end
		end
	elseif not (not self._magnetic and self._magnetic_target) then
		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(arg_5_1)
		local game_object_field = GameSession.game_object_field(game, go_id, "magnetic_target_id")

		self._magnetic_target = Managers.state.unit_storage:unit(game_object_field)
	end

	if self._flight_done or not self._orb_flight_target_position then
		if not self._start_time then
			self._start_time = arg_5_5
			self._orb_starting_position = Vector3Box(Unit.local_position(arg_5_1, 0))
		end

		local num_4 = (arg_5_5 - self._start_time) / num_2

		if num_4 > 1 then
			num_4 = 1
			self._flight_done = true
		end

		local unbox = self._orb_starting_position:unbox()
		local unbox_2 = self._orb_flight_target_position:unbox()
		local lerp = Vector3.lerp(unbox, unbox_2, num_4)
		local num_5 = math.sin(math.pi * math.pow(num_4, 0.8)) * num

		lerp.z = lerp.z + num_5

		Unit.set_local_position(arg_5_1, 0, lerp)
	elseif not ALIVE[self._magnetic_target] then
		local _magnetic = self._magnetic
		local max_speed = _magnetic.max_speed
		local time_to_max_speed = _magnetic.time_to_max_speed
		local _magnetic_start_t = self._magnetic_start_t

		_magnetic_start_t = _magnetic_start_t or arg_5_5
		self._magnetic_start_t = _magnetic_start_t

		local var_5_27

		if time_to_max_speed < math.epsilon then
			var_5_27 = max_speed
		else
			var_5_27 = math.lerp_clamped(0, max_speed, (arg_5_5 - self._magnetic_start_t) / time_to_max_speed)
		end

		local num_6 = POSITION_LOOKUP[self._magnetic_target] + Vector3.up()
		local direction_length, var_5_30 = Vector3.direction_length(num_6 - POSITION_LOOKUP[arg_5_1])
		local min = math.min(var_5_30, var_5_27 * arg_5_3)
		local num_7 = POSITION_LOOKUP[arg_5_1] + direction_length * min

		Unit.set_local_position(arg_5_1, 0, num_7)
	elseif not self._hover then
		local frequency = self._hover.frequency
		local amplitude = self._hover.amplitude
		local _hover_t_start = self._hover_t_start

		_hover_t_start = _hover_t_start or arg_5_5
		self._hover_t_start = _hover_t_start

		local num_8 = arg_5_5 - self._hover_t_start
		local unbox_3 = self._hover_from:unbox()
		local num_9 = unbox_3 + Vector3(0, 0, amplitude)
		local num_10 = (math.cos(num_8 * math.tau * frequency + math.pi) + 1) * 0.5 * amplitude
		local lerp_2 = Vector3.lerp(unbox_3, num_9, num_10)

		Unit.set_local_position(arg_5_1, 0, lerp_2)
	end
end

OrbPickupUnitExtension.get_orb_flight_target_position = function (self)
	-- function 6
	return self._orb_flight_target_position
end

OrbPickupUnitExtension._set_custom_orb_color = function (self, arg_7_1, arg_7_2)
	-- function 7
	local Color = Color
	local var_7_1 = arg_7_1[1]
	local var_7_2 = arg_7_1[2]
	local var_7_3 = arg_7_1[3]
	local var_7_4 = arg_7_1[4]

	var_7_4 = var_7_4 or 1

	local var_7_5 = Color(var_7_1, var_7_2, var_7_3, var_7_4)
	local var_7_6 = Vector3(arg_7_2[1], arg_7_2[2], arg_7_2[3])
	local _unit = self._unit

	for i = 0, Unit.num_meshes(_unit) - 1 do
		local mesh = Unit.mesh(_unit, i)

		if not Mesh.has_material(mesh, "deus_orb_core_01") then
			local material = Mesh.material(mesh, "deus_orb_core_01")

			Material.set_vector3(material, "material_variable", var_7_5)
		end

		if not Mesh.has_material(mesh, "deus_orb_shell_01") then
			local material_2 = Mesh.material(mesh, "deus_orb_shell_01")

			Material.set_vector3(material_2, "emissive_color", var_7_6)
		end
	end
end

OrbPickupUnitExtension.ensure_magnetic_target = function (self, arg_8_1)
	-- function 8
	self._magnetic_target = arg_8_1

	if not self._pickup_settings.local_only then
		local go_id = Managers.state.unit_storage:go_id(arg_8_1)

		if not go_id then
			local game = Managers.state.network:game()
			local go_id_2 = Managers.state.unit_storage:go_id(self._unit)

			GameSession.set_game_object_field(game, go_id_2, "magnetic_target_id", go_id)
		end
	end
end
