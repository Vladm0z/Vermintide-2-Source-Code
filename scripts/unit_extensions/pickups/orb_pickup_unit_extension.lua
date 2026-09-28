-- chunkname: @scripts/unit_extensions/pickups/orb_pickup_unit_extension.lua

local HIGHEST_Z_OFFSET = 1
local ANIMATION_DURATION = 1
local DEFAULT_PICKUP_ORB_SOUND = "boon_orb_pickup"

OrbPickupUnitExtension = class(OrbPickupUnitExtension, PickupUnitExtension)

OrbPickupUnitExtension.init = function (self, extension_init_context, unit, extension_init_data)
	-- function 1
	OrbPickupUnitExtension.super.init(self, extension_init_context, unit, extension_init_data)

	self._is_server = Managers.player.is_server
	self._unit = unit

	local side = Managers.state.side:get_side_from_name("heroes")

	self._hero_side = side
	self._pickup_settings = AllPickups[self.pickup_name]

	local orb_flight_target_position

	if extension_init_data.flight_enabled then
		orb_flight_target_position = extension_init_data.orb_flight_target_position

		if not orb_flight_target_position then
			-- Nothing
		end
	end

	orb_flight_target_position = nil

	::label_1_0::

	self._orb_flight_target_position = orb_flight_target_position

	if self._orb_flight_target_position then
		local orb_offset = self._pickup_settings.orb_offset

		if orb_offset then
			local target_pos = self._orb_flight_target_position

			target_pos:store(target_pos:unbox() + Vector3Aux.unbox(orb_offset))
		end
	end

	local custom_color = self._pickup_settings.custom_orb_color

	if custom_color then
		self:_set_custom_orb_color(custom_color.core, custom_color.shell)
	else
		Unit.flow_event(unit, "update_visuals")
	end

	self._hover = self._pickup_settings.hover_settings

	local _orb_flight_target_position = self._orb_flight_target_position

	_orb_flight_target_position = not not _orb_flight_target_position or not not Vector3Box(POSITION_LOOKUP[unit])
	self._hover_from = _orb_flight_target_position
	self._magnetic = self._pickup_settings.magnetic_settings
	self._buff_params = {
		attacker_unit = unit
	}
end

OrbPickupUnitExtension.game_object_initialized = function (self, unit, go_id)
	-- function 2
	return
end

OrbPickupUnitExtension.extensions_ready = function (self, world, unit)
	-- function 3
	return
end

OrbPickupUnitExtension.destroy = function (self)
	-- function 4
	return
end

OrbPickupUnitExtension.update = function (self, unit, input, dt, context, t)
	-- function 5
	if self._done then
		return
	end

	local side = self._hero_side
	local player_units = side.PLAYER_AND_BOT_UNITS
	local num_player_units = #player_units
	local positions = POSITION_LOOKUP
	local orb_position = Unit.world_position(unit, 0)
	local pickup_settings = self._pickup_settings
	local local_only = pickup_settings.local_only

	if self._is_server or local_only then
		for i = 1, num_player_units do
			local player_unit = player_units[i]

			if Unit.alive(player_unit) then
				local position = positions[player_unit]
				local delta_pos = position - orb_position

				if math.abs(delta_pos.z) < 2 then
					delta_pos.z = 0
				end

				local distance = Vector3.length(delta_pos)
				local status_extension = ScriptUnit.extension(player_unit, "status_system")
				local can_pickup = not status_extension:is_disabled() and not pickup_settings.can_pickup_orb or not not pickup_settings.can_pickup_orb(pickup_settings, player_unit)

				if can_pickup then
					local pickup_radius_2 = pickup_settings.pickup_radius

					if not pickup_radius_2 then
						-- Nothing
					end

					pickup_radius_2 = 1

					local pickup_radius = pickup_radius_2

					::label_5_0::

					if distance < pickup_radius then
						if pickup_settings.granted_buff then
							local buff_system = Managers.state.entity:system("buff_system")

							if buff_system then
								local buff_sync_type = pickup_settings.buff_sync_type

								if not buff_sync_type then
									-- Nothing
								end

								buff_sync_type = BuffSyncType.All

								local sync_type = buff_sync_type

								::label_5_1::

								buff_system:add_buff_synced(player_unit, pickup_settings.granted_buff, sync_type, self._buff_params)
							end
						end

						local audio_system = Managers.state.entity:system("audio_system")

						if audio_system then
							local player = Managers.player:owner(player_unit)
							local peer_id = player:network_id()
							local pickup_sound_2 = pickup_settings.pickup_sound

							if not pickup_sound_2 then
								-- Nothing
							end

							pickup_sound_2 = DEFAULT_PICKUP_ORB_SOUND

							local pickup_sound = pickup_sound_2

							::label_5_2::

							audio_system:play_2d_audio_unit_event_for_peer(pickup_sound, peer_id)
						end

						if pickup_settings.on_orb_pickup then
							pickup_settings.on_orb_pickup(unit)
						end

						Managers.state.unit_spawner:mark_for_deletion(unit)

						self._done = true

						break
					elseif self._magnetic and distance < self._magnetic.radius and not self._magnetic_target then
						self:ensure_magnetic_target(player_unit)
					end
				end
			end
		end
	elseif self._magnetic and not self._magnetic_target then
		local game = Managers.state.network:game()
		local go_id = Managers.state.unit_storage:go_id(unit)
		local target_go_id = GameSession.game_object_field(game, go_id, "magnetic_target_id")

		self._magnetic_target = Managers.state.unit_storage:unit(target_go_id)
	end

	if not self._flight_done and self._orb_flight_target_position then
		if not self._start_time then
			self._start_time = t
			self._orb_starting_position = Vector3Box(Unit.local_position(unit, 0))
		end

		local ratio = (t - self._start_time) / ANIMATION_DURATION

		if ratio > 1 then
			ratio = 1
			self._flight_done = true
		end

		local start = self._orb_starting_position:unbox()
		local destination = self._orb_flight_target_position:unbox()
		local next_position = Vector3.lerp(start, destination, ratio)
		local z_offset = math.sin(math.pi * math.pow(ratio, 0.8)) * HIGHEST_Z_OFFSET

		next_position.z = next_position.z + z_offset

		Unit.set_local_position(unit, 0, next_position)
	elseif ALIVE[self._magnetic_target] then
		local magnetic_settings = self._magnetic
		local max_speed = magnetic_settings.max_speed
		local time_to_max_speed = magnetic_settings.time_to_max_speed
		local _magnetic_start_t = self._magnetic_start_t

		_magnetic_start_t = not not _magnetic_start_t or not not t
		self._magnetic_start_t = _magnetic_start_t

		local speed

		if time_to_max_speed < math.epsilon then
			speed = max_speed
		else
			speed = math.lerp_clamped(0, max_speed, (t - self._magnetic_start_t) / time_to_max_speed)
		end

		local target_pos = POSITION_LOOKUP[self._magnetic_target] + Vector3.up()
		local dir_to_target, dist_to_target = Vector3.direction_length(target_pos - POSITION_LOOKUP[unit])
		local dist_to_travel = math.min(dist_to_target, speed * dt)
		local next_position = POSITION_LOOKUP[unit] + dir_to_target * dist_to_travel

		Unit.set_local_position(unit, 0, next_position)
	elseif self._hover then
		local hover_frequency = self._hover.frequency
		local hover_amplitude = self._hover.amplitude
		local _hover_t_start = self._hover_t_start

		_hover_t_start = not not _hover_t_start or not not t
		self._hover_t_start = _hover_t_start

		local hover_t = t - self._hover_t_start
		local hover_from = self._hover_from:unbox()
		local hover_to = hover_from + Vector3(0, 0, hover_amplitude)
		local z_scale = (math.cos(hover_t * math.tau * hover_frequency + math.pi) + 1) * 0.5 * hover_amplitude
		local next_position = Vector3.lerp(hover_from, hover_to, z_scale)

		Unit.set_local_position(unit, 0, next_position)
	end
end

OrbPickupUnitExtension.get_orb_flight_target_position = function (self)
	-- function 6
	return self._orb_flight_target_position
end

OrbPickupUnitExtension._set_custom_orb_color = function (self, boxed_color_core, boxed_color_shell)
	-- function 7
	local Color = Color
	local var_7_1 = boxed_color_core[1]
	local var_7_2 = boxed_color_core[2]
	local var_7_3 = boxed_color_core[3]
	local var_7_4 = boxed_color_core[4]

	var_7_4 = not not var_7_4 or not not 1

	local color_core = Color(var_7_1, var_7_2, var_7_3, var_7_4)
	local color_shell = Vector3(boxed_color_shell[1], boxed_color_shell[2], boxed_color_shell[3])
	local unit = self._unit

	for i = 0, Unit.num_meshes(unit) - 1 do
		local mesh = Unit.mesh(unit, i)

		if Mesh.has_material(mesh, "deus_orb_core_01") then
			local material = Mesh.material(mesh, "deus_orb_core_01")

			Material.set_vector3(material, "material_variable", color_core)
		end

		if Mesh.has_material(mesh, "deus_orb_shell_01") then
			local material = Mesh.material(mesh, "deus_orb_shell_01")

			Material.set_vector3(material, "emissive_color", color_shell)
		end
	end
end

OrbPickupUnitExtension.ensure_magnetic_target = function (self, target_unit)
	-- function 8
	self._magnetic_target = target_unit

	if not self._pickup_settings.local_only then
		local target_id = Managers.state.unit_storage:go_id(target_unit)

		if target_id then
			local game = Managers.state.network:game()
			local go_id = Managers.state.unit_storage:go_id(self._unit)

			GameSession.set_game_object_field(game, go_id, "magnetic_target_id", target_id)
		end
	end
end
