-- chunkname: @scripts/unit_extensions/pickups/orb_pickup_unit_extension.lua

local var_0_0 = 1
local var_0_1 = 1
local var_0_2 = "boon_orb_pickup"

OrbPickupUnitExtension = class(OrbPickupUnitExtension, PickupUnitExtension)

function OrbPickupUnitExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	OrbPickupUnitExtension.super.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)

	arg_1_0._is_server = Managers.player.is_server
	arg_1_0._unit = arg_1_2
	arg_1_0._hero_side = Managers.state.side:get_side_from_name("heroes")
	arg_1_0._pickup_settings = AllPickups[arg_1_0.pickup_name]
	arg_1_0._orb_flight_target_position = arg_1_3.flight_enabled and arg_1_3.orb_flight_target_position or nil

	if arg_1_0._orb_flight_target_position then
		local var_1_0 = arg_1_0._pickup_settings.orb_offset

		if var_1_0 then
			local var_1_1 = arg_1_0._orb_flight_target_position

			var_1_1:store(var_1_1:unbox() + Vector3Aux.unbox(var_1_0))
		end
	end

	local var_1_2 = arg_1_0._pickup_settings.custom_orb_color

	if var_1_2 then
		arg_1_0:_set_custom_orb_color(var_1_2.core, var_1_2.shell)
	else
		Unit.flow_event(arg_1_2, "update_visuals")
	end

	arg_1_0._hover = arg_1_0._pickup_settings.hover_settings
	arg_1_0._hover_from = arg_1_0._orb_flight_target_position or Vector3Box(POSITION_LOOKUP[arg_1_2])
	arg_1_0._magnetic = arg_1_0._pickup_settings.magnetic_settings
	arg_1_0._buff_params = {
		attacker_unit = arg_1_2
	}
end

function OrbPickupUnitExtension.game_object_initialized(arg_2_0, arg_2_1, arg_2_2)
	return
end

function OrbPickupUnitExtension.extensions_ready(arg_3_0, arg_3_1, arg_3_2)
	return
end

function OrbPickupUnitExtension.destroy(arg_4_0)
	return
end

function OrbPickupUnitExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_0._done then
		return
	end

	local var_5_0 = arg_5_0._hero_side.PLAYER_AND_BOT_UNITS
	local var_5_1 = #var_5_0
	local var_5_2 = POSITION_LOOKUP
	local var_5_3 = Unit.world_position(arg_5_1, 0)
	local var_5_4 = arg_5_0._pickup_settings
	local var_5_5 = var_5_4.local_only

	if arg_5_0._is_server or var_5_5 then
		for iter_5_0 = 1, var_5_1 do
			local var_5_6 = var_5_0[iter_5_0]

			if Unit.alive(var_5_6) then
				local var_5_7 = var_5_2[var_5_6] - var_5_3

				if math.abs(var_5_7.z) < 2 then
					var_5_7.z = 0
				end

				local var_5_8 = Vector3.length(var_5_7)

				if not ScriptUnit.extension(var_5_6, "status_system"):is_disabled() and (not var_5_4.can_pickup_orb or var_5_4.can_pickup_orb(var_5_4, var_5_6)) then
					if var_5_8 < (var_5_4.pickup_radius or 1) then
						if var_5_4.granted_buff then
							local var_5_9 = Managers.state.entity:system("buff_system")

							if var_5_9 then
								local var_5_10 = var_5_4.buff_sync_type or BuffSyncType.All

								var_5_9:add_buff_synced(var_5_6, var_5_4.granted_buff, var_5_10, arg_5_0._buff_params)
							end
						end

						local var_5_11 = Managers.state.entity:system("audio_system")

						if var_5_11 then
							local var_5_12 = Managers.player:owner(var_5_6):network_id()
							local var_5_13 = var_5_4.pickup_sound or var_0_2

							var_5_11:play_2d_audio_unit_event_for_peer(var_5_13, var_5_12)
						end

						if var_5_4.on_orb_pickup then
							var_5_4.on_orb_pickup(arg_5_1)
						end

						Managers.state.unit_spawner:mark_for_deletion(arg_5_1)

						arg_5_0._done = true

						break
					elseif arg_5_0._magnetic and var_5_8 < arg_5_0._magnetic.radius and not arg_5_0._magnetic_target then
						arg_5_0:ensure_magnetic_target(var_5_6)
					end
				end
			end
		end
	elseif arg_5_0._magnetic and not arg_5_0._magnetic_target then
		local var_5_14 = Managers.state.network:game()
		local var_5_15 = Managers.state.unit_storage:go_id(arg_5_1)
		local var_5_16 = GameSession.game_object_field(var_5_14, var_5_15, "magnetic_target_id")

		arg_5_0._magnetic_target = Managers.state.unit_storage:unit(var_5_16)
	end

	if not arg_5_0._flight_done and arg_5_0._orb_flight_target_position then
		if not arg_5_0._start_time then
			arg_5_0._start_time = arg_5_5
			arg_5_0._orb_starting_position = Vector3Box(Unit.local_position(arg_5_1, 0))
		end

		local var_5_17 = (arg_5_5 - arg_5_0._start_time) / var_0_1

		if var_5_17 > 1 then
			var_5_17 = 1
			arg_5_0._flight_done = true
		end

		local var_5_18 = arg_5_0._orb_starting_position:unbox()
		local var_5_19 = arg_5_0._orb_flight_target_position:unbox()
		local var_5_20 = Vector3.lerp(var_5_18, var_5_19, var_5_17)
		local var_5_21 = math.sin(math.pi * math.pow(var_5_17, 0.8)) * var_0_0

		var_5_20.z = var_5_20.z + var_5_21

		Unit.set_local_position(arg_5_1, 0, var_5_20)
	elseif ALIVE[arg_5_0._magnetic_target] then
		local var_5_22 = arg_5_0._magnetic
		local var_5_23 = var_5_22.max_speed
		local var_5_24 = var_5_22.time_to_max_speed

		arg_5_0._magnetic_start_t = arg_5_0._magnetic_start_t or arg_5_5

		local var_5_25

		if var_5_24 < math.epsilon then
			var_5_25 = var_5_23
		else
			var_5_25 = math.lerp_clamped(0, var_5_23, (arg_5_5 - arg_5_0._magnetic_start_t) / var_5_24)
		end

		local var_5_26 = POSITION_LOOKUP[arg_5_0._magnetic_target] + Vector3.up()
		local var_5_27, var_5_28 = Vector3.direction_length(var_5_26 - POSITION_LOOKUP[arg_5_1])
		local var_5_29 = math.min(var_5_28, var_5_25 * arg_5_3)
		local var_5_30 = POSITION_LOOKUP[arg_5_1] + var_5_27 * var_5_29

		Unit.set_local_position(arg_5_1, 0, var_5_30)
	elseif arg_5_0._hover then
		local var_5_31 = arg_5_0._hover.frequency
		local var_5_32 = arg_5_0._hover.amplitude

		arg_5_0._hover_t_start = arg_5_0._hover_t_start or arg_5_5

		local var_5_33 = arg_5_5 - arg_5_0._hover_t_start
		local var_5_34 = arg_5_0._hover_from:unbox()
		local var_5_35 = var_5_34 + Vector3(0, 0, var_5_32)
		local var_5_36 = (math.cos(var_5_33 * math.tau * var_5_31 + math.pi) + 1) * 0.5 * var_5_32
		local var_5_37 = Vector3.lerp(var_5_34, var_5_35, var_5_36)

		Unit.set_local_position(arg_5_1, 0, var_5_37)
	end
end

function OrbPickupUnitExtension.get_orb_flight_target_position(arg_6_0)
	return arg_6_0._orb_flight_target_position
end

function OrbPickupUnitExtension._set_custom_orb_color(arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = Color(arg_7_1[1], arg_7_1[2], arg_7_1[3], arg_7_1[4] or 1)
	local var_7_1 = Vector3(arg_7_2[1], arg_7_2[2], arg_7_2[3])
	local var_7_2 = arg_7_0._unit

	for iter_7_0 = 0, Unit.num_meshes(var_7_2) - 1 do
		local var_7_3 = Unit.mesh(var_7_2, iter_7_0)

		if Mesh.has_material(var_7_3, "deus_orb_core_01") then
			local var_7_4 = Mesh.material(var_7_3, "deus_orb_core_01")

			Material.set_vector3(var_7_4, "material_variable", var_7_0)
		end

		if Mesh.has_material(var_7_3, "deus_orb_shell_01") then
			local var_7_5 = Mesh.material(var_7_3, "deus_orb_shell_01")

			Material.set_vector3(var_7_5, "emissive_color", var_7_1)
		end
	end
end

function OrbPickupUnitExtension.ensure_magnetic_target(arg_8_0, arg_8_1)
	arg_8_0._magnetic_target = arg_8_1

	if not arg_8_0._pickup_settings.local_only then
		local var_8_0 = Managers.state.unit_storage:go_id(arg_8_1)

		if var_8_0 then
			local var_8_1 = Managers.state.network:game()
			local var_8_2 = Managers.state.unit_storage:go_id(arg_8_0._unit)

			GameSession.set_game_object_field(var_8_1, var_8_2, "magnetic_target_id", var_8_0)
		end
	end
end
