-- chunkname: @scripts/unit_extensions/level/rotating_hazard_extension.lua

RotatingHazardExtension = class(RotatingHazardExtension)

local var_0_0 = math.pi
local var_0_1 = var_0_0 * 2
local var_0_2 = 1
local var_0_3 = 2
local var_0_4 = 3
local var_0_5 = {
	damage_entry = 40,
	random_direction = true,
	anticipation_delay = 5,
	random_start_rotation = true,
	damage_tick = 15,
	rotation_speed = 10,
	damage_tick_rate = 0.5,
	buffs_on_entry = {
		"wall_slow_debuff"
	},
	buffs_on_tick = {
		"wall_slow_debuff"
	},
	starting_state = var_0_4,
	areas = {
		{
			angle_offset = 0,
			height_min = -1,
			length = 35,
			height_max = 5,
			flow_name = "first",
			width = 10,
			length_offset = 1
		},
		{
			height_min = -1,
			length = 35,
			height_max = 5,
			flow_name = "second",
			width = 10,
			length_offset = 1,
			angle_offset = var_0_0
		}
	},
	init_func = function()
		return
	end,
	update_func = function(arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5, arg_2_6, arg_2_7, arg_2_8, arg_2_9)
		if arg_2_4 == true then
			return
		end

		local var_2_0 = 7
		local var_2_1 = 0.3
		local var_2_2 = 0.55
		local var_2_3 = 2
		local var_2_4 = 2
		local var_2_5 = 0
		local var_2_6 = 0.3
		local var_2_7 = 0.4
		local var_2_8 = var_0_0 / 15
		local var_2_9 = arg_2_3 == var_0_2 and 1 or 0
		local var_2_10 = Quaternion.axis_angle(Vector3.up(), arg_2_7 + arg_2_5.angle_offset + math.rad(arg_2_2.rotation_speed) * var_2_9 * arg_2_8)
		local var_2_11 = Quaternion.forward(var_2_10)
		local var_2_12 = Unit.local_position(arg_2_1, 0)
		local var_2_13 = arg_2_5.width / 2
		local var_2_14 = Managers.state.side:get_side_from_name("heroes").PLAYER_UNITS
		local var_2_15 = arg_2_6.last_index or 1
		local var_2_16 = arg_2_6.hand_units_by_player or {}

		arg_2_6.hand_units_by_player = var_2_16

		local var_2_17 = #var_2_14
		local var_2_18 = var_2_17 <= var_2_15 and 0 or var_2_15

		for iter_2_0 = 0, var_2_17 - 1 do
			local var_2_19 = (iter_2_0 + var_2_18) % var_2_17 + 1
			local var_2_20 = var_2_14[var_2_19]
			local var_2_21 = arg_2_6[var_2_20]

			if ALIVE[var_2_20] and (not var_2_21 or var_2_21 <= arg_2_9) then
				local var_2_22 = POSITION_LOOKUP[var_2_20]
				local var_2_23 = Vector3.length(var_2_22 - var_2_12)
				local var_2_24 = math.min(var_2_23 / arg_2_5.length, 1)
				local var_2_25 = var_2_13 * var_2_24
				local var_2_26 = Geometry.closest_point_on_line(var_2_22, var_2_12 + var_2_11 * arg_2_5.length_offset, var_2_12 + var_2_11 * arg_2_5.length)
				local var_2_27 = var_2_22 - var_2_26
				local var_2_28 = Vector3.normalize(var_2_27)
				local var_2_29 = Vector3.length(var_2_27)

				if var_2_29 <= var_2_25 + var_2_0 then
					local var_2_30 = var_2_29 <= var_2_25 and var_2_22 or var_2_26 + var_2_28 * var_2_25
					local var_2_31 = Vector3.normalize(var_2_12 - var_2_30)
					local var_2_32 = Vector3.length(var_2_12 - var_2_30)

					if var_2_32 > arg_2_5.length then
						var_2_30 = var_2_30 + var_2_31 * (var_2_32 - arg_2_5.length)
					end

					local var_2_33 = math.clamp(1 - var_2_29 / var_2_25, 0, 1)
					local var_2_34 = math.min(math.lerp(var_2_2, var_2_3, var_2_33), math.max(var_2_25, var_2_1))
					local var_2_35 = math.min(math.max(var_2_32 - arg_2_5.length_offset, 0), math.max(arg_2_5.length - var_2_32, 0))
					local var_2_36 = math.min(math.lerp(var_2_4, var_2_5, var_2_33), var_2_35)
					local var_2_37 = var_2_30 + var_2_31 * ((math.random() - 0.5) * 2 * var_2_36)
					local var_2_38 = Managers.state.entity:system("ai_system"):nav_world()
					local var_2_39 = ConflictUtils.get_spawn_pos_on_circle(var_2_38, var_2_37, 0.1, var_2_34 * 2, 1, false, nil, nil, 5, 5)

					if var_2_39 then
						local var_2_40 = Vector3.up()
						local var_2_41 = Quaternion.multiply(Quaternion.look(var_2_22 - var_2_39, var_2_40), Quaternion.axis_angle(var_2_40, (math.random() - 0.5) * var_2_8))
						local var_2_42 = World.spawn_unit(arg_2_0, "units/beings/enemies/undead_skeleton_hand/chr_undead_skeleton_hand", var_2_39, var_2_41)
						local var_2_43 = 1.75

						Unit.set_local_scale(var_2_42, 0, Vector3(var_2_43, var_2_43, var_2_43))

						arg_2_6[var_2_20] = arg_2_9 + math.max((0.3 - var_2_24) / 0.3, 0) * var_2_7 + var_2_6

						local var_2_44 = var_2_16[var_2_20] or {}

						var_2_16[var_2_20] = var_2_44
						var_2_44[var_2_42] = Unit.animation_find_constraint_target(var_2_42, "look_at")
						arg_2_6.last_index = var_2_19

						break
					end
				end
			end
		end

		for iter_2_1, iter_2_2 in pairs(var_2_16) do
			local var_2_45 = POSITION_LOOKUP[iter_2_1]

			if var_2_45 then
				for iter_2_3, iter_2_4 in pairs(iter_2_2) do
					if not Unit.alive(iter_2_3) then
						iter_2_2[iter_2_3] = nil
					else
						Unit.animation_set_constraint_target(iter_2_3, iter_2_4, var_2_45)
					end
				end
			else
				var_2_16[iter_2_1] = nil
			end
		end
	end
}

function RotatingHazardExtension.init(arg_3_0, arg_3_1, arg_3_2, arg_3_3)
	local var_3_0 = var_0_5

	arg_3_0._settings = var_3_0
	arg_3_0._unit = arg_3_2
	arg_3_0._world = arg_3_1.world
	arg_3_0._is_server = arg_3_1.is_server
	arg_3_0._state = arg_3_3.state or var_3_0.starting_state
	arg_3_0._start_t = arg_3_3.start_network_time or Managers.state.network:network_time()
	arg_3_0._pause_t = arg_3_0._start_t
	arg_3_0._next_damage_t = 0
	arg_3_0._last_update_idx = 0
	arg_3_0._num_areas = #var_3_0.areas
	arg_3_0._rotation_speed_rad = math.rad(var_3_0.rotation_speed)
	arg_3_0._start_rotation_offset = 0
	arg_3_0._rotation_direction = 1
	arg_3_0._current_seed = Managers.mechanism:get_level_seed()
	arg_3_0._next_seed = arg_3_0._current_seed
	arg_3_0._area_data = {}

	for iter_3_0 = 1, arg_3_0._num_areas do
		local var_3_1 = var_3_0.areas[iter_3_0]

		var_3_1.angular_half_size = var_3_1.angular_half_size or math.atan2(var_3_1.width / 2, var_3_1.length)
		arg_3_0._area_data[iter_3_0] = {
			overlapping_units = {}
		}
	end
end

function RotatingHazardExtension.hot_join_sync(arg_4_0, arg_4_1)
	local var_4_0 = Managers.state.network
	local var_4_1, var_4_2 = var_4_0:game_object_or_level_id(arg_4_0._unit)

	if var_4_1 then
		var_4_0.network_transmit:send_rpc("rpc_sync_rotating_hazard", arg_4_1, var_4_1, var_4_2, arg_4_0._start_t, arg_4_0._pause_t, arg_4_0._state, arg_4_0._current_seed)
	end
end

function RotatingHazardExtension.network_sync(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
	arg_5_0._start_t = arg_5_1
	arg_5_0._pause_t = arg_5_2
	arg_5_0._state = arg_5_3
	arg_5_0._is_activating = nil

	if arg_5_3 == var_0_2 then
		for iter_5_0 = 1, arg_5_0._num_areas do
			arg_5_0._area_data[iter_5_0].last_update_t = nil
		end

		arg_5_0:_update_random_settings_from_seed(arg_5_4)
	end

	if arg_5_3 == var_0_4 then
		Unit.flow_event(arg_5_0._unit, "stop")
	elseif arg_5_3 == var_0_3 then
		Unit.flow_event(arg_5_0._unit, "pause")
	end
end

function RotatingHazardExtension.destroy(arg_6_0)
	return
end

function RotatingHazardExtension.start(arg_7_0, arg_7_1)
	if arg_7_0._is_server and (arg_7_0._state ~= var_0_2 or arg_7_1) then
		arg_7_0._state = var_0_2
		arg_7_0._is_activating = nil

		if arg_7_1 then
			arg_7_0._start_t = Managers.state.network:network_time()
			arg_7_0._pause_t = arg_7_0._start_t

			for iter_7_0 = 1, arg_7_0._num_areas do
				arg_7_0._area_data[iter_7_0].last_update_t = nil
			end

			arg_7_0:_update_random_settings_from_seed(arg_7_0._next_seed)
		else
			arg_7_0._start_t = Managers.state.network:network_time() - (arg_7_0._pause_t - arg_7_0._start_t)
		end

		local var_7_0, var_7_1 = Managers.state.network:game_object_or_level_id(arg_7_0._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", var_7_0, var_7_1, arg_7_0._start_t, arg_7_0._pause_t, arg_7_0._state, arg_7_0._current_seed)
	end
end

function RotatingHazardExtension._update_random_settings_from_seed(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_1
	local var_8_1
	local var_8_2 = arg_8_0._settings

	if var_8_2.random_start_rotation then
		local var_8_3

		var_8_0, var_8_3 = Math.next_random(var_8_0)
		arg_8_0._start_rotation_offset = var_0_1 * var_8_3
	end

	if var_8_2.random_direction then
		local var_8_4

		var_8_0, var_8_4 = Math.next_random(var_8_0)
		arg_8_0._rotation_direction = var_8_4 >= 0.5 and 1 or -1
	end

	arg_8_0._current_seed = arg_8_1
	arg_8_0._next_seed = var_8_0

	Unit.set_data(arg_8_0._unit, "rotation_direction", arg_8_0._rotation_direction)

	for iter_8_0 = 1, arg_8_0._num_areas do
		local var_8_5 = var_8_2.areas[iter_8_0]

		if var_8_5.flow_name then
			local var_8_6 = var_8_5.angular_half_size
			local var_8_7 = var_8_5.angle_offset
			local var_8_8 = Quaternion.axis_angle(Vector3.up(), var_8_7 + arg_8_0._rotation_direction * var_8_6)
			local var_8_9 = Quaternion.axis_angle(Vector3.up(), var_8_7)
			local var_8_10 = Quaternion.axis_angle(Vector3.up(), var_8_7 - arg_8_0._rotation_direction * var_8_6)

			Unit.set_data(arg_8_0._unit, "fx_rotation", "front", var_8_5.flow_name, var_8_8)
			Unit.set_data(arg_8_0._unit, "fx_rotation", "center", var_8_5.flow_name, var_8_9)
			Unit.set_data(arg_8_0._unit, "fx_rotation", "back", var_8_5.flow_name, var_8_10)
		end
	end
end

function RotatingHazardExtension.pause(arg_9_0)
	if arg_9_0._is_server and arg_9_0._state == var_0_2 then
		arg_9_0._state = var_0_3
		arg_9_0._is_activating = nil
		arg_9_0._pause_t = Managers.state.network:network_time()

		local var_9_0, var_9_1 = Managers.state.network:game_object_or_level_id(arg_9_0._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", var_9_0, var_9_1, arg_9_0._start_t, arg_9_0._pause_t, arg_9_0._state, arg_9_0._current_seed)
		Unit.flow_event(arg_9_0._unit, "pause")
	end
end

function RotatingHazardExtension.stop(arg_10_0)
	if arg_10_0._is_server and arg_10_0._state ~= var_0_4 then
		if arg_10_0._state == var_0_2 then
			arg_10_0._pause_t = Managers.state.network:network_time()
		end

		arg_10_0._state = var_0_4
		arg_10_0._is_activating = nil

		local var_10_0, var_10_1 = Managers.state.network:game_object_or_level_id(arg_10_0._unit)

		Managers.state.network.network_transmit:send_rpc_clients("rpc_sync_rotating_hazard", var_10_0, var_10_1, arg_10_0._start_t, arg_10_0._pause_t, arg_10_0._state, arg_10_0._current_seed)
		Unit.flow_event(arg_10_0._unit, "stop")
	end
end

function RotatingHazardExtension.update(arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5)
	local var_11_0 = arg_11_0._state

	if var_11_0 == var_0_4 then
		return
	end

	local var_11_1 = Managers.state.network:network_time()

	if var_11_0 == var_0_3 then
		var_11_1 = arg_11_0._pause_t
	end

	local var_11_2 = arg_11_0._settings
	local var_11_3 = var_11_2.anticipation_delay
	local var_11_4 = var_11_1 < var_11_3 + arg_11_0._start_t
	local var_11_5 = var_11_4 and var_11_1 or var_11_3 + arg_11_0._start_t
	local var_11_6 = (arg_11_0._start_rotation_offset + (var_11_1 - var_11_5) * arg_11_0._rotation_speed_rad * arg_11_0._rotation_direction) % var_0_1

	Unit.set_local_rotation(arg_11_1, 0, Quaternion.axis_angle(Vector3.up(), var_11_6))

	if var_11_0 == var_0_2 and arg_11_0._is_activating ~= var_11_4 then
		arg_11_0._is_activating = var_11_4

		if var_11_4 then
			Unit.flow_event(arg_11_0._unit, "start_anticipation")
		else
			Unit.flow_event(arg_11_0._unit, "start_rotation")
		end
	end

	local var_11_7 = arg_11_0._last_update_idx % arg_11_0._num_areas + 1
	local var_11_8 = arg_11_0._area_data[var_11_7]
	local var_11_9 = var_11_2.areas[var_11_7]

	if arg_11_0._is_server and not var_11_4 then
		arg_11_0:_update_damage(var_11_9, var_11_8, var_11_6, arg_11_3, var_11_1)
	end

	var_11_2.update_func(arg_11_0._world, arg_11_1, var_11_2, var_11_0, var_11_4, var_11_9, var_11_8, var_11_6, arg_11_0._rotation_direction, arg_11_5)

	arg_11_0._last_update_idx = var_11_7
end

local var_0_6 = {}

function RotatingHazardExtension._update_damage(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	local var_12_0 = arg_12_2.last_update_t or arg_12_5
	local var_12_1 = arg_12_1.angle_offset
	local var_12_2 = (arg_12_5 - var_12_0) * arg_12_0._rotation_speed_rad
	local var_12_3 = Quaternion.axis_angle(Vector3.up(), arg_12_3 + var_12_1 - var_12_2 / 2)
	local var_12_4 = Quaternion.forward(var_12_3)
	local var_12_5 = var_12_2 / 2 + arg_12_1.angular_half_size
	local var_12_6 = math.cos(var_12_5)
	local var_12_7 = arg_12_0._settings
	local var_12_8 = arg_12_2.overlapping_units
	local var_12_9 = Managers.player:human_players()
	local var_12_10 = arg_12_0._unit
	local var_12_11 = Unit.local_position(var_12_10, 0)
	local var_12_12 = arg_12_1.length * arg_12_1.length
	local var_12_13 = arg_12_1.length_offset * arg_12_1.length_offset
	local var_12_14 = Managers.state.entity:system("buff_system")

	for iter_12_0, iter_12_1 in pairs(var_12_9) do
		local var_12_15 = iter_12_1.player_unit
		local var_12_16 = POSITION_LOOKUP[var_12_15]

		if var_12_16 then
			local var_12_17 = Vector3.distance_squared(var_12_16, var_12_11)

			if var_12_13 <= var_12_17 and var_12_17 <= var_12_12 then
				local var_12_18 = Vector3.normalize(Vector3.flat(var_12_16 - var_12_11))

				if var_12_6 <= Vector3.dot(var_12_4, var_12_18) then
					var_0_6[var_12_15] = true

					if not var_12_8[var_12_15] then
						local var_12_19 = "kinetic"
						local var_12_20 = "heavy"

						DamageUtils.add_damage_network(var_12_15, var_12_10, var_12_7.damage_entry, "full", var_12_19, nil, var_12_18, nil, nil, var_12_10, nil, var_12_20)

						local var_12_21 = var_12_7.buffs_on_entry

						for iter_12_2 = 1, #var_12_21 do
							var_12_14:add_buff_synced(var_12_15, var_12_21[iter_12_2], BuffSyncType.All)
						end

						var_12_8[var_12_15] = arg_12_5
					else
						local var_12_22 = var_12_8[var_12_15]
						local var_12_23 = var_12_7.damage_tick_rate

						if arg_12_5 >= var_12_22 + var_12_23 then
							local var_12_24 = "kinetic"
							local var_12_25 = "medium"

							DamageUtils.add_damage_network(var_12_15, var_12_10, var_12_7.damage_tick, "full", var_12_24, nil, var_12_18, nil, nil, var_12_10, nil, var_12_25, nil, nil, nil, nil, nil, nil, 1)

							local var_12_26 = var_12_7.buffs_on_tick

							for iter_12_3 = 1, #var_12_26 do
								var_12_14:add_buff_synced(var_12_15, var_12_26[iter_12_3], BuffSyncType.All)
							end

							var_12_8[var_12_15] = var_12_22 + var_12_23
						end
					end
				end
			end
		end
	end

	for iter_12_4 in pairs(var_12_8) do
		if not var_0_6[iter_12_4] then
			var_12_8[iter_12_4] = nil
		end
	end

	table.clear(var_0_6)

	arg_12_2.last_update_t = arg_12_5
end
