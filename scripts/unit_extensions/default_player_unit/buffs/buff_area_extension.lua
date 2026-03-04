-- chunkname: @scripts/unit_extensions/default_player_unit/buffs/buff_area_extension.lua

BuffAreaExtension = class(BuffAreaExtension)

BuffAreaExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	local var_1_0 = arg_1_1.world

	arg_1_0._unit_spawner = Managers.state.unit_spawner
	arg_1_0._world = var_1_0
	arg_1_0._unit = arg_1_2

	Unit.set_unit_visibility(arg_1_0._unit, false)

	local var_1_1 = Managers.time:time("game")
	local var_1_2 = arg_1_3.sub_buff_template

	arg_1_0._end_t = var_1_1 + (var_1_2.duration or math.huge)
	arg_1_0.sub_buff_id = arg_1_3.sub_buff_id
	arg_1_0.template = var_1_2

	local var_1_3 = arg_1_3.radius

	arg_1_0.owner_unit = arg_1_3.owner_unit
	arg_1_0.source_unit = arg_1_3.source_unit
	arg_1_0.radius = var_1_3
	arg_1_0.radius_squared = var_1_3 * var_1_3
	arg_1_0._buff_area_system = arg_1_1.owning_system
	arg_1_0._unlimited = arg_1_0.template.unlimited
	arg_1_0.side_id = arg_1_3.side_id
	arg_1_0.side = Managers.state.side:get_side(arg_1_0.side_id)
	arg_1_0._buff_allies = var_1_2.buff_allies
	arg_1_0._buff_enemies = var_1_2.buff_enemies
	arg_1_0._buff_self = var_1_2.buff_self
	arg_1_0._wwise_world = Managers.world:wwise_world(var_1_0)
	arg_1_0._area_start_sfx = var_1_2.area_start_sfx
	arg_1_0._area_end_sfx = var_1_2.area_end_sfx
	arg_1_0._enter_area_sfx = var_1_2.enter_area_sfx
	arg_1_0._leave_area_sfx = var_1_2.leave_area_sfx

	if var_1_2.area_start_sfx then
		arg_1_0:_play_unit_audio()
	end

	arg_1_0:_spawn_particles()

	arg_1_0._is_server = Managers.state.network.is_server

	if arg_1_0._is_server then
		arg_1_0:_spawn_los_blocker()
	end
end

BuffAreaExtension.game_object_initialized = function (arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._is_owner = GameSession.game_object_owned(Managers.state.network:game(), arg_2_2)
end

BuffAreaExtension.destroy = function (arg_3_0)
	if arg_3_0._is_server and Unit.alive(arg_3_0._los_blocker_unit) then
		arg_3_0._unit_spawner:mark_for_deletion(arg_3_0._los_blocker_unit)

		arg_3_0._los_blocker_unit = nil
	end

	if arg_3_0._is_owner and Managers.state.network:game() then
		arg_3_0:_cleanup_inside_units()
	end

	if arg_3_0._leave_area_sfx then
		arg_3_0:play_leave_buff_zone_sfx()
	end

	if arg_3_0._area_end_sfx then
		arg_3_0:_stop_unit_audio()
	end

	arg_3_0:_destroy_particles()
end

BuffAreaExtension._cleanup_inside_units = function (arg_4_0)
	local var_4_0 = arg_4_0._buff_area_system:inside_by_area(arg_4_0)
	local var_4_1 = var_4_0.by_position

	for iter_4_0 in pairs(var_4_1) do
		arg_4_0:_set_not_inside(var_4_1, iter_4_0)
	end

	local var_4_2 = var_4_0.by_broadphase

	for iter_4_1 in pairs(var_4_2) do
		arg_4_0:_set_not_inside(var_4_2, iter_4_1)
	end
end

BuffAreaExtension.update = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	if arg_5_0._particle_state and arg_5_0._particle_state.update_fx then
		BuffUtils.update_attached_particles(arg_5_0._world, arg_5_0._particle_state, arg_5_5)
	end

	if not arg_5_0._is_owner then
		return
	end

	if arg_5_0._end_t and arg_5_5 > arg_5_0._end_t then
		arg_5_0:_remove_unit()
		arg_5_0:_cleanup_inside_units()

		return
	end

	local var_5_0 = POSITION_LOOKUP[arg_5_1]
	local var_5_1 = arg_5_0.radius

	if arg_5_0._buff_allies or arg_5_0._buff_enemies then
		arg_5_0:_check_ai(var_5_0, var_5_1)
	end

	arg_5_0:_check_players(var_5_0, var_5_1)
end

BuffAreaExtension._check_ai = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0.source_unit or arg_6_0.owner_unit
	local var_6_1 = arg_6_0._buff_area_system:inside_by_area(arg_6_0).by_broadphase
	local var_6_2 = arg_6_0._buff_allies
	local var_6_3 = arg_6_0._buff_enemies
	local var_6_4 = Managers.state.side
	local var_6_5 = FrameTable.alloc_table()
	local var_6_6 = FrameTable.alloc_table()
	local var_6_7 = AiUtils.broadphase_query(arg_6_1, arg_6_2, var_6_5)

	for iter_6_0 = 1, var_6_7 do
		local var_6_8 = var_6_5[iter_6_0]

		var_6_6[var_6_8] = true

		if not var_6_1[var_6_8] and (var_6_2 and var_6_4:is_ally(var_6_0, var_6_8) or var_6_3 and var_6_4:is_enemy(var_6_0, var_6_8)) then
			arg_6_0:_set_inside(var_6_1, var_6_8)
		end
	end

	for iter_6_1 in pairs(var_6_1) do
		if not var_6_6[iter_6_1] then
			arg_6_0:_set_not_inside(var_6_1, iter_6_1)
		end
	end
end

BuffAreaExtension._check_players = function (arg_7_0, arg_7_1)
	local var_7_0 = FrameTable.alloc_table()

	if arg_7_0._buff_self then
		local var_7_1 = arg_7_0.source_unit or arg_7_0.owner_unit

		var_7_0[var_7_1] = arg_7_0:_update_by_position(var_7_1)
	end

	local var_7_2 = arg_7_0.side

	if arg_7_0._buff_allies then
		local var_7_3 = var_7_2.PLAYER_AND_BOT_UNITS

		for iter_7_0 = 1, #var_7_3 do
			local var_7_4 = var_7_3[iter_7_0]

			var_7_0[var_7_4] = arg_7_0:_update_by_position(var_7_4)
		end
	end

	if arg_7_0._buff_enemies then
		local var_7_5 = var_7_2.ENEMY_PLAYER_AND_BOT_UNITS

		for iter_7_1 = 1, #var_7_5 do
			local var_7_6 = var_7_5[iter_7_1]

			var_7_0[var_7_6] = arg_7_0:_update_by_position(var_7_6)
		end
	end

	local var_7_7 = arg_7_0._buff_area_system:inside_by_area(arg_7_0).by_position

	for iter_7_2 in pairs(var_7_7) do
		if not var_7_0[iter_7_2] then
			arg_7_0:_set_not_inside(var_7_7, iter_7_2)
		end
	end
end

BuffAreaExtension._update_by_position = function (arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._buff_area_system:inside_by_area(arg_8_0).by_position
	local var_8_1 = false
	local var_8_2 = POSITION_LOOKUP[arg_8_1]

	if var_8_2 then
		local var_8_3 = POSITION_LOOKUP[arg_8_0._unit]

		var_8_1 = Vector3.length_squared(var_8_3 - var_8_2) <= arg_8_0.radius_squared
	end

	if var_8_1 then
		arg_8_0:_set_inside(var_8_0, arg_8_1)
	else
		arg_8_0:_set_not_inside(var_8_0, arg_8_1)
	end

	return var_8_1
end

BuffAreaExtension.set_unit_position = function (arg_9_0, arg_9_1)
	Unit.set_local_position(arg_9_0._unit, 0, arg_9_1)
end

BuffAreaExtension.set_duration = function (arg_10_0, arg_10_1)
	arg_10_0._end_t = Managers.time:time("game") + arg_10_1
end

BuffAreaExtension._leave_func = function (arg_11_0, arg_11_1)
	if not arg_11_0._unlimited then
		local var_11_0 = Managers.state.entity:system("buff_system")
		local var_11_1 = arg_11_0._buff_area_system:inside_by_area(arg_11_0).buff_ids
		local var_11_2 = var_11_1[arg_11_1]

		var_11_0:remove_buff_synced(arg_11_1, var_11_2)

		var_11_1[arg_11_1] = nil
	end

	local var_11_3 = Managers.player:owner(arg_11_1)
	local var_11_4 = var_11_3 and var_11_3:network_id()
	local var_11_5 = arg_11_0._unit and Managers.state.unit_storage:go_id(arg_11_0._unit)

	if arg_11_0._leave_area_sfx and var_11_4 and var_11_5 then
		Managers.state.network.network_transmit:send_rpc("rpc_play_leave_buff_zone_sfx", var_11_4, var_11_5)
	end
end

BuffAreaExtension._enter_func = function (arg_12_0, arg_12_1)
	local var_12_0 = Managers.state.entity:system("buff_system")
	local var_12_1 = arg_12_0.template
	local var_12_2 = var_12_1.buff_area_buff
	local var_12_3 = var_12_1.buff_sync_type or BuffSyncType.Local
	local var_12_4 = FrameTable.alloc_table()
	local var_12_5 = arg_12_0.source_unit

	var_12_4.attacker_unit = var_12_5
	var_12_4.source_attacker_unit = var_12_5

	local var_12_6 = Managers.player:owner(arg_12_1)
	local var_12_7 = var_12_6 and var_12_6:network_id()
	local var_12_8 = arg_12_0._unit and Managers.state.unit_storage:go_id(arg_12_0._unit)

	if arg_12_0._leave_area_sfx and var_12_7 and var_12_8 then
		Managers.state.network.network_transmit:send_rpc("rpc_play_enter_buff_zone_sfx", var_12_7, var_12_8)
	end

	if (var_12_3 == BuffSyncType.Client or var_12_3 == BuffSyncType.ClientAndServer) and not var_12_7 then
		return
	end

	arg_12_0._buff_area_system:inside_by_area(arg_12_0).buff_ids[arg_12_1] = var_12_0:add_buff_synced(arg_12_1, var_12_2, var_12_3, var_12_4, var_12_7)
end

BuffAreaExtension._remove_unit = function (arg_13_0)
	if ALIVE[arg_13_0._unit] then
		arg_13_0._unit_spawner:mark_for_deletion(arg_13_0._unit)

		arg_13_0._unit = nil
	end
end

BuffAreaExtension._spawn_los_blocker = function (arg_14_0)
	local var_14_0 = Unit.world_position(arg_14_0._unit, 0)
	local var_14_1 = arg_14_0.radius
	local var_14_2 = "units/gameplay/line_of_sight_blocker/hemisphere_los_blocker"
	local var_14_3 = "network_synched_dummy_unit"
	local var_14_4, var_14_5 = arg_14_0._unit_spawner:spawn_network_unit(var_14_2, var_14_3, nil, var_14_0, Quaternion.identity(), nil)

	Unit.set_local_scale(var_14_4, 0, Vector3(var_14_1, var_14_1, var_14_1))

	arg_14_0._los_blocker_unit = var_14_4
end

BuffAreaExtension._set_inside = function (arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_1[arg_15_2] or {}

	arg_15_1[arg_15_2] = var_15_0

	local var_15_1 = table.is_empty(var_15_0)

	var_15_0[arg_15_0] = true

	if var_15_1 then
		arg_15_0:_enter_func(arg_15_2)
	end
end

BuffAreaExtension._set_not_inside = function (arg_16_0, arg_16_1, arg_16_2)
	local var_16_0 = arg_16_1[arg_16_2]

	if var_16_0 and var_16_0[arg_16_0] then
		var_16_0[arg_16_0] = nil

		if table.is_empty(var_16_0) then
			arg_16_1[arg_16_2] = nil

			arg_16_0:_leave_func(arg_16_2)
		end
	end
end

BuffAreaExtension._spawn_particles = function (arg_17_0)
	local var_17_0 = arg_17_0.template.buff_area_particles

	if not var_17_0 then
		return
	end

	local var_17_1 = false

	arg_17_0._particle_state = BuffUtils.create_attached_particles(arg_17_0._world, var_17_0, arg_17_0._unit, var_17_1, arg_17_0.source_unit, arg_17_0._end_t)
end

BuffAreaExtension._destroy_particles = function (arg_18_0)
	local var_18_0 = arg_18_0._particle_state

	if not var_18_0 then
		return
	end

	BuffUtils.destroy_attached_particles(arg_18_0._world, var_18_0)
end

BuffAreaExtension._play_unit_audio = function (arg_19_0)
	arg_19_0._unit_source_id = WwiseWorld.make_manual_source(arg_19_0._wwise_world, POSITION_LOOKUP[arg_19_0._unit])

	WwiseWorld.trigger_event(arg_19_0._wwise_world, arg_19_0._area_start_sfx, arg_19_0._unit_source_id)
end

BuffAreaExtension._stop_unit_audio = function (arg_20_0)
	if arg_20_0._unit_source_id then
		WwiseWorld.trigger_event(arg_20_0._wwise_world, arg_20_0._area_end_sfx, true, arg_20_0._unit_source_id)
		WwiseWorld.destroy_manual_source(arg_20_0._wwise_world, arg_20_0._unit_source_id)
	end
end

BuffAreaExtension.play_enter_buff_zone_sfx = function (arg_21_0)
	arg_21_0._inside_zone_audio_id = WwiseUtils.make_unit_auto_source(arg_21_0._world, arg_21_0._unit)

	WwiseWorld.trigger_event(arg_21_0._wwise_world, arg_21_0._enter_area_sfx, true, arg_21_0._inside_zone_audio_id)
end

BuffAreaExtension.play_leave_buff_zone_sfx = function (arg_22_0)
	if arg_22_0._inside_zone_audio_id then
		WwiseWorld.trigger_event(arg_22_0._wwise_world, arg_22_0._leave_area_sfx, true, arg_22_0._inside_zone_audio_id)

		arg_22_0._inside_zone_audio_id = nil
	end
end
