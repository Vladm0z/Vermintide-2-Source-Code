-- chunkname: @scripts/unit_extensions/generic/thorn_mutator_extension.lua

ThornMutatorExtension = class(ThornMutatorExtension)

local var_0_0 = 1

function ThornMutatorExtension.init(arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.spawn_time = arg_1_3.spawn_animation_time or 0
	arg_1_0.despawn_time = arg_1_3.despawn_animation_time or 0
	arg_1_0._spawn_timer = 0
	arg_1_0._life_timer = 0
	arg_1_0._is_server = Managers.state.network.is_server
	arg_1_0._unit = arg_1_2

	local var_1_0 = Unit.local_scale(arg_1_2, 0)

	arg_1_0._scale_x = var_1_0.x
	arg_1_0._scale_y = var_1_0.y
	arg_1_0._scale_z = var_1_0.z

	local var_1_1 = ScriptUnit.extension(arg_1_2, "area_damage_system")

	arg_1_0._area_damage_extension = var_1_1
	arg_1_0._life_time = var_1_1.life_time
	arg_1_0._despawning = false
end

function ThornMutatorExtension.current_progress(arg_2_0)
	return arg_2_0._spawn_timer
end

function ThornMutatorExtension.get_spawn_time(arg_3_0)
	return arg_3_0.spawn_time
end

function ThornMutatorExtension.setup_rpc_sync(arg_4_0, arg_4_1, arg_4_2)
	arg_4_0.spawn_time = arg_4_1
	arg_4_0._spawn_timer = arg_4_2
end

function ThornMutatorExtension.update(arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
	local var_5_0 = arg_5_0.spawn_time
	local var_5_1 = arg_5_0._spawn_timer

	if var_5_1 < 1 then
		local var_5_2 = math.clamp(var_5_1 + arg_5_3 / var_5_0, 0, 1)

		if var_5_2 == 1 and arg_5_0._is_server then
			local var_5_3 = Managers.state.network
			local var_5_4 = var_5_3:unit_game_object_id(arg_5_0._unit)

			var_5_3.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_area_damage", var_5_4)
			arg_5_0:trigger_area_damage()
		end

		arg_5_0._spawn_timer = var_5_2
	end

	if arg_5_0._spawn_timer == 1 and arg_5_0._life_timer < 1 then
		local var_5_5 = arg_5_0._life_time - arg_5_0.despawn_time
		local var_5_6 = arg_5_0._life_timer

		if not arg_5_0._despawning then
			local var_5_7 = math.clamp(var_5_6 + arg_5_3 / var_5_5, 0, 1)

			if var_5_7 == 1 and arg_5_0._is_server then
				local var_5_8 = Managers.state.network
				local var_5_9 = var_5_8:unit_game_object_id(arg_5_0._unit)

				var_5_8.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_despawn", var_5_9)
				arg_5_0:despawn()

				arg_5_0._despawn_done_time = arg_5_5 + var_0_0
			end

			arg_5_0._life_timer = var_5_7
		end
	end

	if arg_5_0._is_server and arg_5_0._area_damage_extension.num_hits > 0 and not arg_5_0._despawning then
		local var_5_10 = Managers.state.network
		local var_5_11 = var_5_10:unit_game_object_id(arg_5_0._unit)

		var_5_10.network_transmit:send_rpc_clients("rpc_thorn_bush_trigger_despawn", var_5_11)
		WwiseUtils.trigger_unit_event(arg_5_4.world, "Play_winds_life_gameplay_thorn_hit_player", arg_5_1, 0)
		arg_5_0:despawn()

		arg_5_0._despawn_done_time = arg_5_5 + var_0_0
	end

	if arg_5_0._is_server then
		arg_5_0:_check_for_deletion(arg_5_5)
	end
end

function ThornMutatorExtension.trigger_area_damage(arg_6_0)
	Unit.flow_event(arg_6_0._unit, "set_static_material")
	ScriptUnit.extension(arg_6_0._unit, "area_damage_system"):enable_area_damage(true)
end

function ThornMutatorExtension.despawn(arg_7_0)
	Unit.flow_event(arg_7_0._unit, "despawn")

	arg_7_0._despawning = true

	ScriptUnit.extension(arg_7_0._unit, "area_damage_system"):enable_area_damage(false)
end

function ThornMutatorExtension._check_for_deletion(arg_8_0, arg_8_1)
	if arg_8_0._despawn_done_time and arg_8_1 > arg_8_0._despawn_done_time then
		Managers.state.unit_spawner:mark_for_deletion(arg_8_0._unit)
	end
end
