-- chunkname: @scripts/managers/conflict_director/conflict_director_testify.lua

return {
	total_main_path_distance = function ()
		return EngineOptimized.main_path_total_length()
	end,
	get_all_breeds = function ()
		local var_2_0 = {}

		for iter_2_0, iter_2_1 in pairs(Breeds) do
			if iter_2_1.is_always_spawnable and iter_2_1.allied ~= true then
				var_2_0[iter_2_0] = iter_2_1
			end
		end

		return var_2_0
	end,
	spawn_unit = function (arg_3_0, arg_3_1)
		local var_3_0 = QuaternionBox(Quaternion.identity())

		arg_3_0:spawn_queued_unit(arg_3_1.breed_data, arg_3_1.boxed_spawn_position, var_3_0)
	end,
	get_unit_of_breed = function (arg_4_0, arg_4_1)
		local var_4_0, var_4_1 = next(arg_4_0:spawned_units_by_breed(arg_4_1))

		return var_4_1
	end,
	destroy_all_units = function (arg_5_0)
		arg_5_0:destroy_all_units()
	end,
	peaks = function (arg_6_0)
		return arg_6_0:get_peaks()
	end,
	reset_terror_event_mixer = function ()
		TerrorEventMixer.reset()
	end,
	terror_event_finished = function (arg_8_0, arg_8_1)
		return arg_8_0:terror_event_finished(arg_8_1)
	end,
	start_terror_event = function (arg_9_0, arg_9_1)
		arg_9_0:start_terror_event(arg_9_1)
	end,
	kill_nearby_enemies = function (arg_10_0)
		arg_10_0:destroy_close_units(nil, nil, 64)
	end
}
