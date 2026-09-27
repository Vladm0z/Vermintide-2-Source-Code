-- chunkname: @scripts/settings/mutators/mutator_deus_pacing_tweak.lua

local tbl = {
	deus_skaven_chaos = {
		breed2 = "deus_chaos",
		breed1 = "deus_skaven"
	},
	deus_skaven_beastmen = {
		breed2 = "deus_beastmen",
		breed1 = "deus_skaven"
	}
}
local num = 45
local tbl_2 = {
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
local tbl_3 = {
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
local num_2 = 40

local function fn(arg_1_0, arg_1_1)
	-- function 1
	local num = 0

	for k, v in pairs(arg_1_1) do
		num = num + v
	end

	local next_random, var_1_2 = Math.next_random(arg_1_0, 0, num * 100)
	local num_2 = 0

	for k_2, v_2 in pairs(arg_1_1) do
		num_2 = num_2 + v_2 * 100

		if var_1_2 <= num_2 then
			return k_2
		end
	end

	return nil
end

local tbl_4 = {
	apply_travel_dist_to_sequence_with_peaks_and_events = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4, arg_2_5)
		-- function 2
		local clone = table.clone(arg_2_0)
		local num_3 = arg_2_1 / (#arg_2_0 + 1)
		local num_4 = 0

		for i, v in ipairs(clone) do
			v.travel_dist = num_4
			num_4 = num_4 + num_3
		end

		for i_2, v_2 in ipairs(arg_2_2) do
			local var_2_3

			for i_3, v_3 in ipairs(clone) do
				if not v_3.peak then
					if not var_2_3 then
						var_2_3 = v_3
					elseif math.abs(v_3.travel_dist - v_2) < math.abs(var_2_3.travel_dist - v_2) then
						var_2_3 = v_3
					end
				end
			end

			var_2_3.travel_dist = v_2
			var_2_3.fixed_peak = true
		end

		local var_2_4
		local var_2_5
		local var_2_6

		for i_4, v_4 in ipairs(clone) do
			if not (not v_4.peak and v_4.fixed_peak) then
				for i_5, v_5 in ipairs(arg_2_3) do
					local abs = math.abs(v_5.travel_dist - num - v_4.travel_dist)

					if not var_2_6 then
						var_2_4 = {
							v_5
						}
						var_2_5 = v_4
						var_2_6 = abs
					elseif math.abs(abs - var_2_6) < num_2 then
						var_2_4[#var_2_4 + 1] = v_5
					elseif abs < var_2_6 then
						var_2_4 = {
							v_5
						}
						var_2_5 = v_4
						var_2_6 = abs
					end
				end
			end
		end

		local var_2_8

		if not var_2_4 then
			local tbl = {}

			for i_6, v_6 in ipairs(var_2_4) do
				tbl[v_6.kind] = arg_2_4[v_6.kind]
			end

			tbl.nothing = arg_2_4.nothing

			local var_2_10 = fn(arg_2_5, tbl)

			if var_2_10 ~= "nothing" then
				for i_7, v_7 in ipairs(var_2_4) do
					if v_7.kind == var_2_10 then
						var_2_8 = v_7

						break
					end
				end

				var_2_5.travel_dist = var_2_8.travel_dist - num
			end
		end

		local function fn_2(arg_3_0, arg_3_1)
			-- function 3
			local num = arg_3_1 - arg_3_0
			local travel_dist = clone[arg_3_0].travel_dist
			local travel_dist_2 = clone[arg_3_1].travel_dist

			for i = arg_3_0 + 1, arg_3_1 - 1 do
				local num_2 = (i - arg_3_0) / num

				clone[i].travel_dist = math.lerp(travel_dist, travel_dist_2, num_2)
			end
		end

		local num_5 = 1

		for i14 = 1, #clone do
			if not clone[i14].peak then
				fn_2(num_5, i14)

				num_5 = i14
			end
		end

		fn_2(num_5, #clone)

		return clone, var_2_8
	end,
	tweak_zones_with_sequence = function (arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4, arg_4_5)
		-- function 4
		local num = 1

		for i, v in ipairs(arg_4_5) do
			local mutators = v.mutators

			for k = num, arg_4_4 do
				local var_4_2 = arg_4_3[k]
				local tbl = {}

				if not var_4_2.mutators then
					for iter_4_3 in string.gmatch(var_4_2.mutators, "([^[%s,]+)%s*,?%s*") do
						tbl[#tbl + 1] = iter_4_3
					end
				end

				for i_2, v_2 in ipairs(mutators) do
					if table.index_of(tbl, v_2) == -1 then
						tbl[#tbl + 1] = v_2
					end
				end

				var_4_2.peak = v.peak

				if #tbl > 0 then
					var_4_2.mutators = table.concat(tbl, ",")
				end

				if var_4_2.travel_dist > v.travel_dist then
					if not var_4_2.roaming_set then
						var_4_2.roaming_set = (v.breeds ~= "a" or not arg_4_0 or v.breeds ~= "b") and (not arg_4_1 or arg_4_2)
					end

					num = k

					break
				end
			end
		end
	end
}

return {
	hide_from_player_ui = true,
	tweak_zones = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4)
		-- function 5
		local game_mechanism = Managers.mechanism:game_mechanism()
		local get_deus_run_controller = game_mechanism.get_deus_run_controller

		get_deus_run_controller = not get_deus_run_controller and game_mechanism:get_deus_run_controller()

		if not (not tbl[arg_5_2] and get_deus_run_controller) then
			return
		end

		local get_current_node = get_deus_run_controller:get_current_node()
		local var_5_3 = tbl_3[get_current_node.level_type]

		if not var_5_3 then
			return
		end

		local get_level_seed = Managers.mechanism:get_level_seed("mutator")
		local var_5_5
		local next_random, var_5_7 = Math.next_random(get_level_seed, 1, #var_5_3)
		local var_5_8 = var_5_3[var_5_7]
		local travel_dist = arg_5_3[arg_5_4].travel_dist
		local conflict = Managers.state.conflict
		local get_peaks = conflict:get_peaks()
		local get_possible_events = conflict.level_analysis:get_possible_events()
		local run_progress = get_current_node.run_progress
		local clone = table.clone(tbl_2)
		local weights = clone[1].weights

		for i, v in ipairs(clone) do
			if run_progress >= v.run_progress then
				weights = v.weights
			else
				break
			end
		end

		local game_mode = Managers.state.game_mode

		if not game_mode:has_mutator("deus_more_monsters") then
			weights.event_boss = 100
			weights.event_patrol = 0
			weights.nothing = 0
		end

		if not game_mode:has_mutator("deus_less_monsters") then
			weights.event_boss = 0
		end

		if not game_mode:has_mutator("deus_more_elites") then
			weights.event_boss = 0
			weights.nothing = 0
			weights.event_patrol = 100
		end

		if not game_mode:has_mutator("deus_less_elites") then
			weights.event_patrol = 0
		end

		local apply_travel_dist_to_sequence_with_peaks_and_events, var_5_18 = tbl_4.apply_travel_dist_to_sequence_with_peaks_and_events(var_5_8, travel_dist, get_peaks, get_possible_events, weights, next_random)

		arg_5_1.event = var_5_18

		local next_random_2, var_5_20 = Math.next_random(next_random, 1, 2)
		local var_5_21 = tbl[arg_5_2]
		local breed1

		if var_5_20 == 1 then
			breed1 = var_5_21.breed1

			if not breed1 then
				-- Nothing
			end
		end

		breed1 = var_5_21.breed2

		do
			local breed2
		end

		::label_5_0::

		if var_5_20 == 1 then
			breed2 = var_5_21.breed2

			if not breed2 then
				-- Nothing
			end
		end

		breed2 = var_5_21.breed1

		::label_5_1::

		tbl_4.tweak_zones_with_sequence(breed1, breed2, arg_5_2, arg_5_3, arg_5_4, apply_travel_dist_to_sequence_with_peaks_and_events)

		local tbl_5 = {}

		for i_2, v_2 in ipairs(apply_travel_dist_to_sequence_with_peaks_and_events) do
			if not v_2.peak then
				tbl_5[#tbl_5 + 1] = v_2.travel_dist
			end
		end

		conflict:set_peaks(tbl_5)
	end,
	server_start_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
		-- function 6
		if not arg_6_1.event then
			return
		end

		local conflict = Managers.state.conflict

		if arg_6_1.event.kind == "event_boss" then
			local spawner = arg_6_1.event.spawner
			local local_position = Unit.local_position(spawner[1], 0)
			local var_6_3 = Vector3Box(local_position)
			local tbl = {
				event_kind = "event_boss"
			}
			local event_boss = CurrentBossSettings.boss_events.event_lookup.event_boss
			local get_level_seed = Managers.mechanism:get_level_seed("mutator")
			local next_random, var_6_8 = Math.next_random(get_level_seed, 1, #event_boss)
			local var_6_9 = event_boss[var_6_8]

			conflict.enemy_recycler:add_main_path_terror_event(var_6_3, var_6_9, num, tbl)
		elseif arg_6_1.event.kind == "event_patrol" then
			local waypoints_table = arg_6_1.event.waypoints_table
			local boxify_waypoint_table = conflict.level_analysis:boxify_waypoint_table(waypoints_table.waypoints)
			local tbl_2 = {
				spline_type = "patrol",
				event_kind = "event_spline_patrol",
				spline_id = waypoints_table.id,
				spline_way_points = boxify_waypoint_table,
				one_directional = waypoints_table.one_directional
			}
			local event_patrol = CurrentBossSettings.boss_events.event_lookup.event_patrol
			local get_level_seed_2 = Managers.mechanism:get_level_seed("mutator")
			local next_random_2, var_6_16 = Math.next_random(get_level_seed_2, 1, #event_patrol)
			local var_6_17 = event_patrol[var_6_16]
			local num_2 = conflict.level_analysis:get_boss_spline_travel_distance(waypoints_table) - num

			conflict.enemy_recycler:add_main_path_terror_event(boxify_waypoint_table[1], var_6_17, num, tbl_2, num_2)
		end
	end,
	server_update_function = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3)
		-- function 7
		if not arg_7_1.peak_delayer_data then
			return
		end

		local time = Managers.time:time("game")
		local conflict = Managers.state.conflict
		local main_path_info = conflict.main_path_info
		local var_7_3

		if not main_path_info.ahead_unit then
			return
		end

		local travel_dist = conflict.main_path_player_info[main_path_info.ahead_unit].travel_dist
		local max = math.max
		local highest_travel_dist = arg_7_1.highest_travel_dist

		highest_travel_dist = highest_travel_dist or 0
		arg_7_1.highest_travel_dist = max(highest_travel_dist, travel_dist)
	end
}
