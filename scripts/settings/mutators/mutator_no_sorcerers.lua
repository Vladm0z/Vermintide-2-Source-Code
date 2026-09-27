-- chunkname: @scripts/settings/mutators/mutator_no_sorcerers.lua

local num = 1
local tbl = {
	chaos_vortex_sorcerer = "chaos_warrior",
	chaos_corruptor_sorcerer = "chaos_warrior"
}
local tbl_2 = {
	chaos_warrior = function (arg_1_0, arg_1_1)
		-- function 1
		if not (arg_1_1.spawn_category == "specials_pacing" or arg_1_1.spawn_category == "spawn_one" or arg_1_1.spawn_category ~= "raw_spawner") then
			return true
		end
	end
}
local tbl_3 = {
	chaos_warrior = function (arg_2_0, arg_2_1)
		-- function 2
		if not ALIVE[arg_2_0] then
			return true
		end

		if not arg_2_1.target_unit then
			arg_2_1.goal_destination = nil

			return false
		end

		local pick_closest_target_infinte_range = PerceptionUtils.pick_closest_target_infinte_range(arg_2_0, arg_2_1, arg_2_1.breed)

		if not pick_closest_target_infinte_range then
			arg_2_1.goal_destination = Vector3Box(POSITION_LOOKUP[pick_closest_target_infinte_range])
		end

		return false
	end
}

return {
	hide_from_player_ui = true,
	server_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.check_at = 0
		arg_3_1.processed_units = {}
	end,
	update_conflict_settings = function (arg_4_0, arg_4_1)
		-- function 4
		local function fn(arg_5_0)
			-- function 5
			local tbl_2 = {}

			for i, v in ipairs(arg_5_0) do
				local num = #tbl_2 + 1
				local var_5_2 = tbl[v]

				var_5_2 = var_5_2 or v
				tbl_2[num] = var_5_2
			end

			return tbl_2
		end

		if not CurrentSpecialsSettings.breeds then
			CurrentSpecialsSettings.breeds = fn(CurrentSpecialsSettings.breeds)
		end

		if not CurrentSpecialsSettings.rush_intervention then
			CurrentSpecialsSettings.rush_intervention.breeds = fn(CurrentSpecialsSettings.rush_intervention.breeds)
		end

		if not CurrentSpecialsSettings.speed_running_intervention then
			CurrentSpecialsSettings.speed_running_intervention.breeds = fn(CurrentSpecialsSettings.speed_running_intervention.breeds)
		end
	end,
	post_process_terror_event = function (arg_6_0, arg_6_1, arg_6_2)
		-- function 6
		for i, v in ipairs(arg_6_2) do
			if not v.breed_name then
				local var_6_0

				if type(v.breed_name) == "string" then
					local var_6_1 = tbl[v.breed_name]

					if not var_6_1 then
						var_6_0 = table.clone(v)
						var_6_0.breed_name = var_6_1
					end
				else
					local var_6_2

					for i_2, v_2 in ipairs(v.breed_name) do
						local var_6_3 = tbl[v_2]

						if not var_6_3 then
							var_6_0 = var_6_0 or table.clone(v)
							var_6_2 = var_6_2 or table.clone(v.breed_name)
							var_6_2[i_2] = var_6_3
						end
					end

					if not var_6_2 then
						var_6_0.breed_name = var_6_2
					end
				end

				if not var_6_0 then
					arg_6_2[i] = var_6_0
				end
			end
		end
	end,
	server_ai_spawned_function = function (arg_7_0, arg_7_1, arg_7_2)
		-- function 7
		local var_7_0 = BLACKBOARDS[arg_7_2]
		local flag = not var_7_0 and var_7_0.breed.name

		if not tbl_2[flag] and not tbl_2[flag](arg_7_2, var_7_0) then
			arg_7_1.processed_units[#arg_7_1.processed_units + 1] = arg_7_2
		end
	end,
	server_update_function = function (arg_8_0, arg_8_1)
		-- function 8
		local time = Managers.time:time("game")

		if time > arg_8_1.check_at then
			for i = #arg_8_1.processed_units, 1, -1 do
				local var_8_1 = arg_8_1.processed_units[i]
				local var_8_2 = BLACKBOARDS[var_8_1]
				local flag = not var_8_2 and tbl_3[var_8_2.breed.name](var_8_1, var_8_2)

				if var_8_2 == nil or not flag then
					table.swap_delete(arg_8_1.processed_units, i)
				end
			end

			arg_8_1.check_at = time + num
		end
	end,
	get_terror_event_tags = function (arg_9_0, arg_9_1, arg_9_2)
		-- function 9
		arg_9_2[#arg_9_2 + 1] = DeusTerrorEventTags.NO_SORCERERS
	end
}
