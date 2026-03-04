-- chunkname: @scripts/unit_extensions/generic/training_dummy_health_extension.lua

TrainingDummyHealthExtension = class(TrainingDummyHealthExtension, GenericHealthExtension)

TrainingDummyHealthExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0.unit = arg_1_2
	arg_1_0.is_server = Managers.player.is_server
	arg_1_0.system_data = arg_1_1.system_data
	arg_1_0.statistics_db = arg_1_1.statistics_db
	arg_1_0.damage_buffers = {
		pdArray.new(),
		pdArray.new()
	}
	arg_1_0.network_transmit = arg_1_1.network_transmit
	arg_1_0.is_invincible = false
	arg_1_0.health = 300
	arg_1_0.unmodified_max_health = arg_1_0.health
	arg_1_0.damage = 0
	arg_1_0.state = "alive"
	arg_1_0._next_regen_tick = -math.huge
	arg_1_0._side_name = "neutral"
end

TrainingDummyHealthExtension.extensions_ready = function (arg_2_0, arg_2_1, arg_2_2)
	local var_2_0 = Managers.state.side
	local var_2_1 = var_2_0:get_side_from_name(arg_2_0._side_name).side_id

	var_2_0:add_unit_to_side(arg_2_0.unit, var_2_1)
end

TrainingDummyHealthExtension.freeze = function (arg_3_0)
	arg_3_0:set_dead()
end

TrainingDummyHealthExtension.unfreeze = function (arg_4_0)
	arg_4_0:reset()
end

TrainingDummyHealthExtension.reset = function (arg_5_0)
	return
end

TrainingDummyHealthExtension.hot_join_sync = function (arg_6_0, arg_6_1)
	return
end

TrainingDummyHealthExtension.is_alive = function (arg_7_0)
	return true
end

TrainingDummyHealthExtension.apply_client_predicted_damage = function (arg_8_0, arg_8_1)
	return
end

TrainingDummyHealthExtension.add_damage = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, arg_9_12, arg_9_13, arg_9_14, arg_9_15, arg_9_16, arg_9_17)
	local var_9_0 = arg_9_0.unit
	local var_9_1 = Managers.state.network
	local var_9_2, var_9_3 = var_9_1:game_object_or_level_id(var_9_0)

	DamageUtils.handle_hit_indication(arg_9_1, var_9_0, arg_9_2, arg_9_3, arg_9_12)
	arg_9_0:_add_to_damage_history_buffer(var_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6, arg_9_7, arg_9_8, arg_9_9, arg_9_10, arg_9_11, nil, nil, nil, nil, arg_9_17)

	arg_9_0._recent_damage_type = arg_9_4
	arg_9_0._recent_hit_react_type = arg_9_10
	arg_9_0.damage = math.min(arg_9_0.damage + arg_9_2, arg_9_0.health - 1)
	arg_9_0._next_regen_tick = Managers.time:time("game") + 3

	if not DEDICATED_SERVER then
		DamageUtils.add_unit_floating_damage_numbers(var_9_0, arg_9_4, arg_9_2, arg_9_11)
	end

	if arg_9_0.is_server and var_9_2 then
		local var_9_4, var_9_5 = var_9_1:game_object_or_level_id(arg_9_1)
		local var_9_6 = NetworkLookup.hit_zones[arg_9_3]
		local var_9_7 = NetworkLookup.damage_types[arg_9_4]
		local var_9_8 = NetworkLookup.damage_sources[arg_9_7 or "n/a"]
		local var_9_9 = NetworkLookup.hit_ragdoll_actors[arg_9_8 or "n/a"]
		local var_9_10 = NetworkLookup.hit_react_types[arg_9_10 or "light"]
		local var_9_11 = NetworkLookup.buff_attack_types[arg_9_15 or "n/a"]
		local var_9_12 = NetworkConstants.invalid_game_object_id
		local var_9_13 = arg_9_0.network_transmit
		local var_9_14 = arg_9_0.dead or false

		arg_9_11 = arg_9_11 or false
		arg_9_12 = arg_9_12 or false
		arg_9_13 = arg_9_13 or false
		arg_9_14 = arg_9_14 or 0
		arg_9_16 = arg_9_16 or 1
		arg_9_17 = arg_9_17 or 1

		var_9_13:send_rpc_clients("rpc_add_damage", var_9_2, var_9_3, var_9_4, var_9_5, var_9_12, arg_9_2, var_9_6, var_9_7, arg_9_5, arg_9_6, var_9_8, var_9_9, var_9_10, var_9_14, arg_9_11, arg_9_12, arg_9_13, arg_9_14, var_9_11, arg_9_16, arg_9_17)
	end
end

TrainingDummyHealthExtension.update = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	if arg_10_3 > arg_10_0._next_regen_tick and arg_10_0.damage > 0 then
		arg_10_0._next_regen_tick = math.huge
		arg_10_0.damage = 0
	end
end

TrainingDummyHealthExtension.set_max_health = function (arg_11_0, arg_11_1, arg_11_2)
	return arg_11_0.health
end

TrainingDummyHealthExtension.set_current_damage = function (arg_12_0, arg_12_1)
	return
end

TrainingDummyHealthExtension.die = function (arg_13_0, arg_13_1)
	return
end

TrainingDummyHealthExtension.set_dead = function (arg_14_0)
	return
end

TrainingDummyHealthExtension.recently_damaged = function (arg_15_0)
	return arg_15_0._recent_damage_type, arg_15_0._recent_hit_react_type
end
