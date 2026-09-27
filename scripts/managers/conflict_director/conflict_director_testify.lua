-- chunkname: @scripts/managers/conflict_director/conflict_director_testify.lua

return {
	total_main_path_distance = function ()
		-- function 1
		return EngineOptimized.main_path_total_length()
	end,
	get_all_breeds = function ()
		-- function 2
		local tbl = {}

		for k, v in pairs(Breeds) do
			if not (not v.is_always_spawnable and v.allied == true) then
				tbl[k] = v
			end
		end

		return tbl
	end,
	spawn_unit = function (self, arg_3_1)
		-- function 3
		local var_3_0 = QuaternionBox(Quaternion.identity())

		self:spawn_queued_unit(arg_3_1.breed_data, arg_3_1.boxed_spawn_position, var_3_0)
	end,
	get_unit_of_breed = function (self, arg_4_1)
		-- function 4
		local var_4_0, var_4_1 = next(self:spawned_units_by_breed(arg_4_1))

		return var_4_1
	end,
	destroy_all_units = function (self)
		-- function 5
		self:destroy_all_units()
	end,
	peaks = function (self)
		-- function 6
		return self:get_peaks()
	end,
	reset_terror_event_mixer = function ()
		-- function 7
		TerrorEventMixer.reset()
	end,
	terror_event_finished = function (self, arg_8_1)
		-- function 8
		return self:terror_event_finished(arg_8_1)
	end,
	start_terror_event = function (self, arg_9_1)
		-- function 9
		self:start_terror_event(arg_9_1)
	end,
	kill_nearby_enemies = function (self)
		-- function 10
		self:destroy_close_units(nil, nil, 64)
	end
}
