-- chunkname: @scripts/settings/mutators/mutator_deus_pacing_tweak.lua

local var_0_0 = {
	deus_skaven_chaos = {
		breed2 = "deus_chaos",
		breed1 = "deus_skaven"
	},
	deus_skaven_beastmen = {
		breed2 = "deus_beastmen",
		breed1 = "deus_skaven"
	}
}
local var_0_1 = 45
local var_0_2 = {
	{
		run_progress = 0,
		weights = {
			event_boss = 0,
			nothing = 30,
			event_patrol = 70
		}
	},
	{
		run_progress = 0.4,
		weights = {
			event_boss = 20,
			nothing = 10,
			event_patrol = 70
		}
	}
}
local var_0_3 = {
	SIGNATURE = {
		{
			{
				breeds = "a",
				mutators = {
					"no_roamers"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				peak = true,
				breeds = "a",
				mutators = {}
			},
			{
				breeds = "a",
				mutators = {
					"no_roamers"
				}
			},
			{
				breeds = "b",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "b",
				mutators = {
					"easier_packs"
				}
			},
			{
				peak = true,
				breeds = "b",
				mutators = {}
			},
			{
				breeds = "both",
				mutators = {}
			},
			{
				breeds = "both",
				mutators = {}
			}
		}
	},
	TRAVEL = {
		{
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {}
			},
			{
				peak = true,
				breeds = "a",
				mutators = {}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "b",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "b",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "b",
				mutators = {}
			},
			{
				peak = true,
				breeds = "both",
				mutators = {}
			},
			{
				breeds = "both",
				mutators = {
					"easier_packs"
				}
			}
		},
		{
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {}
			},
			{
				peak = true,
				breeds = "a",
				mutators = {}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			},
			{
				breeds = "a",
				mutators = {}
			},
			{
				peak = true,
				breeds = "a",
				mutators = {}
			},
			{
				breeds = "a",
				mutators = {
					"easier_packs"
				}
			}
		}
	}
}
local var_0_4 = 40

local function var_0_5(arg_1_0, arg_1_1)
	local var_1_0 = 0

	for iter_1_0, iter_1_1 in pairs(arg_1_1) do
		var_1_0 = var_1_0 + iter_1_1
	end

	local var_1_1, var_1_2 = Math.next_random(arg_1_0, 0, var_1_0 * 100)
	local var_1_3 = 0

	for iter_1_2, iter_1_3 in pairs(arg_1_1) do
		var_1_3 = var_1_3 + iter_1_3 * 100

		if var_1_2 <= var_1_3 then
			return iter_1_2
		end
	end

	return nil
end

local var_0_6 = {
	apply_travel_dist_to_sequence_with_peaks_and_events = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		local var_2_0 = table.clone(arg_2_0)
		local var_2_1 = arg_2_1 / (#arg_2_0 + 1)
		local var_2_2 = 0

		for iter_2_0, iter_2_1 in ipairs(var_2_0) do
			iter_2_1.travel_dist = var_2_2
			var_2_2 = var_2_2 + var_2_1
		end

		for iter_2_2, iter_2_3 in ipairs(arg_2_2) do
			local var_2_3

			for iter_2_4, iter_2_5 in ipairs(var_2_0) do
				if iter_2_5.peak then
					if not var_2_3 then
						var_2_3 = iter_2_5
					elseif math.abs(iter_2_5.travel_dist - iter_2_3) < math.abs(var_2_3.travel_dist - iter_2_3) then
						var_2_3 = iter_2_5
					end
				end
			end

			var_2_3.travel_dist = iter_2_3
			var_2_3.fixed_peak = true
		end

		local var_2_4
		local var_2_5
		local var_2_6

		for iter_2_6, iter_2_7 in ipairs(var_2_0) do
			if iter_2_7.peak and not iter_2_7.fixed_peak then
				for iter_2_8, iter_2_9 in ipairs(arg_2_3) do
					local var_2_7 = math.abs(iter_2_9.travel_dist - var_0_1 - iter_2_7.travel_dist)

					if not var_2_6 then
						var_2_4 = {
							iter_2_9
						}
						var_2_5 = iter_2_7
						var_2_6 = var_2_7
					elseif math.abs(var_2_7 - var_2_6) < var_0_4 then
						var_2_4[#var_2_4 + 1] = iter_2_9
					elseif var_2_7 < var_2_6 then
						var_2_4 = {
							iter_2_9
						}
						var_2_5 = iter_2_7
						var_2_6 = var_2_7
					end
				end
			end
		end

		local var_2_8

		if var_2_4 then
			local var_2_9 = {}

			for iter_2_10, iter_2_11 in ipairs(var_2_4) do
				var_2_9[iter_2_11.kind] = arg_2_4[iter_2_11.kind]
			end

			var_2_9.nothing = arg_2_4.nothing

			local var_2_10 = var_0_5(arg_2_5, var_2_9)

			if var_2_10 ~= "nothing" then
				for iter_2_12, iter_2_13 in ipairs(var_2_4) do
					if iter_2_13.kind == var_2_10 then
						var_2_8 = iter_2_13

						break
					end
				end

				var_2_5.travel_dist = var_2_8.travel_dist - var_0_1
			end
		end

		local function var_2_11(arg_3_0, arg_3_1)
			local var_3_0 = arg_3_1 - arg_3_0
			local var_3_1 = var_2_0[arg_3_0].travel_dist
			local var_3_2 = var_2_0[arg_3_1].travel_dist

			for iter_3_0 = arg_3_0 + 1, arg_3_1 - 1 do
				local var_3_3 = (iter_3_0 - arg_3_0) / var_3_0

				var_2_0[iter_3_0].travel_dist = math.lerp(var_3_1, var_3_2, var_3_3)
			end
		end

		local var_2_12 = 1

		for iter_2_14 = 1, #var_2_0 do
			if var_2_0[iter_2_14].peak then
				var_2_11(var_2_12, iter_2_14)

				var_2_12 = iter_2_14
			end
		end

		var_2_11(var_2_12, #var_2_0)

		return var_2_0, var_2_8
	end,
	tweak_zones_with_sequence = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		local var_4_0 = 1

		for iter_4_0, iter_4_1 in ipairs(arg_4_5) do
			local var_4_1 = iter_4_1.mutators

			for iter_4_2 = var_4_0, arg_4_4 do
				local var_4_2 = arg_4_3[iter_4_2]
				local var_4_3 = {}

				if var_4_2.mutators then
					for iter_4_3 in string.gmatch(var_4_2.mutators, "([^[%s,]+)%s*,?%s*") do
						var_4_3[#var_4_3 + 1] = iter_4_3
					end
				end

				for iter_4_4, iter_4_5 in ipairs(var_4_1) do
					if table.index_of(var_4_3, iter_4_5) == -1 then
						var_4_3[#var_4_3 + 1] = iter_4_5
					end
				end

				var_4_2.peak = iter_4_1.peak

				if #var_4_3 > 0 then
					var_4_2.mutators = table.concat(var_4_3, ",")
				end

				if var_4_2.travel_dist > iter_4_1.travel_dist then
					if not var_4_2.roaming_set then
						var_4_2.roaming_set = iter_4_1.breeds == "a" and arg_4_0 or iter_4_1.breeds == "b" and arg_4_1 or arg_4_2
					end

					var_4_0 = iter_4_2

					break
				end
			end
		end
	end
}

return {
	hide_from_player_ui = true,
	tweak_zones = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		local var_5_0 = Managers.mechanism:game_mechanism()
		local var_5_1 = var_5_0.get_deus_run_controller and var_5_0:get_deus_run_controller()

		if not var_0_0[arg_5_2] or not var_5_1 then
			return
		end

		local var_5_2 = var_5_1:get_current_node()
		local var_5_3 = var_0_3[var_5_2.level_type]

		if not var_5_3 then
			return
		end

		local var_5_4 = Managers.mechanism:get_level_seed("mutator")
		local var_5_5
		local var_5_6, var_5_7 = Math.next_random(var_5_4, 1, #var_5_3)
		local var_5_8 = var_5_3[var_5_7]
		local var_5_9 = arg_5_3[arg_5_4].travel_dist
		local var_5_10 = Managers.state.conflict
		local var_5_11 = var_5_10:get_peaks()
		local var_5_12 = var_5_10.level_analysis:get_possible_events()
		local var_5_13 = var_5_2.run_progress
		local var_5_14 = table.clone(var_0_2)
		local var_5_15 = var_5_14[1].weights

		for iter_5_0, iter_5_1 in ipairs(var_5_14) do
			if var_5_13 >= iter_5_1.run_progress then
				var_5_15 = iter_5_1.weights
			else
				break
			end
		end

		local var_5_16 = Managers.state.game_mode

		if var_5_16:has_mutator("deus_more_monsters") then
			var_5_15.event_boss = 100
			var_5_15.event_patrol = 0
			var_5_15.nothing = 0
		end

		if var_5_16:has_mutator("deus_less_monsters") then
			var_5_15.event_boss = 0
		end

		if var_5_16:has_mutator("deus_more_elites") then
			var_5_15.event_boss = 0
			var_5_15.nothing = 0
			var_5_15.event_patrol = 100
		end

		if var_5_16:has_mutator("deus_less_elites") then
			var_5_15.event_patrol = 0
		end

		local var_5_17, var_5_18 = var_0_6.apply_travel_dist_to_sequence_with_peaks_and_events(var_5_8, var_5_9, var_5_11, var_5_12, var_5_15, var_5_6)

		arg_5_1.event = var_5_18

		local var_5_19, var_5_20 = Math.next_random(var_5_6, 1, 2)
		local var_5_21 = var_0_0[arg_5_2]
		local var_5_22 = var_5_20 == 1 and var_5_21.breed1 or var_5_21.breed2
		local var_5_23 = var_5_20 == 1 and var_5_21.breed2 or var_5_21.breed1

		var_0_6.tweak_zones_with_sequence(var_5_22, var_5_23, arg_5_2, arg_5_3, arg_5_4, var_5_17)

		local var_5_24 = {}

		for iter_5_2, iter_5_3 in ipairs(var_5_17) do
			if iter_5_3.peak then
				var_5_24[#var_5_24 + 1] = iter_5_3.travel_dist
			end
		end

		var_5_10:set_peaks(var_5_24)
	end,
	server_start_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		if not arg_6_1.event then
			return
		end

		local var_6_0 = Managers.state.conflict

		if arg_6_1.event.kind == "event_boss" then
			local var_6_1 = arg_6_1.event.spawner
			local var_6_2 = Unit.local_position(var_6_1[1], 0)
			local var_6_3 = Vector3Box(var_6_2)
			local var_6_4 = {
				event_kind = "event_boss"
			}
			local var_6_5 = CurrentBossSettings.boss_events.event_lookup.event_boss
			local var_6_6 = Managers.mechanism:get_level_seed("mutator")
			local var_6_7, var_6_8 = Math.next_random(var_6_6, 1, #var_6_5)
			local var_6_9 = var_6_5[var_6_8]

			var_6_0.enemy_recycler:add_main_path_terror_event(var_6_3, var_6_9, var_0_1, var_6_4)
		elseif arg_6_1.event.kind == "event_patrol" then
			local var_6_10 = arg_6_1.event.waypoints_table
			local var_6_11 = var_6_0.level_analysis:boxify_waypoint_table(var_6_10.waypoints)
			local var_6_12 = {
				spline_type = "patrol",
				event_kind = "event_spline_patrol",
				spline_id = var_6_10.id,
				spline_way_points = var_6_11,
				one_directional = var_6_10.one_directional
			}
			local var_6_13 = CurrentBossSettings.boss_events.event_lookup.event_patrol
			local var_6_14 = Managers.mechanism:get_level_seed("mutator")
			local var_6_15, var_6_16 = Math.next_random(var_6_14, 1, #var_6_13)
			local var_6_17 = var_6_13[var_6_16]
			local var_6_18 = var_6_0.level_analysis:get_boss_spline_travel_distance(var_6_10) - var_0_1

			var_6_0.enemy_recycler:add_main_path_terror_event(var_6_11[1], var_6_17, var_0_1, var_6_12, var_6_18)
		end
	end,
	server_update_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		if not arg_7_1.peak_delayer_data then
			return
		end

		local var_7_0 = Managers.time:time("game")
		local var_7_1 = Managers.state.conflict
		local var_7_2 = var_7_1.main_path_info
		local var_7_3

		if not var_7_2.ahead_unit then
			return
		end

		local var_7_4 = var_7_1.main_path_player_info[var_7_2.ahead_unit].travel_dist

		arg_7_1.highest_travel_dist = math.max(arg_7_1.highest_travel_dist or 0, var_7_4)
	end
}
