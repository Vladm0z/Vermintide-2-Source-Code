-- chunkname: @scripts/settings/mutators/mutator_no_sorcerers.lua

local var_0_0 = 1
local var_0_1 = {
	chaos_vortex_sorcerer = "chaos_warrior",
	chaos_corruptor_sorcerer = "chaos_warrior"
}
local var_0_2 = {
	chaos_warrior = function (arg_1_0, arg_1_1)
		if arg_1_1.spawn_category == "specials_pacing" or arg_1_1.spawn_category == "spawn_one" or arg_1_1.spawn_category == "raw_spawner" then
			return true
		end
	end
}
local var_0_3 = {
	chaos_warrior = function (arg_2_0, arg_2_1)
		if not ALIVE[arg_2_0] then
			return true
		end

		if arg_2_1.target_unit then
			arg_2_1.goal_destination = nil

			return false
		end

		local var_2_0 = PerceptionUtils.pick_closest_target_infinte_range(arg_2_0, arg_2_1, arg_2_1.breed)

		if var_2_0 then
			arg_2_1.goal_destination = Vector3Box(POSITION_LOOKUP[var_2_0])
		end

		return false
	end
}

return {
	hide_from_player_ui = true,
	server_start_function = function (arg_3_0, arg_3_1)
		arg_3_1.check_at = 0
		arg_3_1.processed_units = {}
	end,
	update_conflict_settings = function (arg_4_0, arg_4_1)
		local function var_4_0(arg_5_0)
			local var_5_0 = {}

			for iter_5_0, iter_5_1 in ipairs(arg_5_0) do
				var_5_0[#var_5_0 + 1] = var_0_1[iter_5_1] or iter_5_1
			end

			return var_5_0
		end

		if CurrentSpecialsSettings.breeds then
			CurrentSpecialsSettings.breeds = var_4_0(CurrentSpecialsSettings.breeds)
		end

		if CurrentSpecialsSettings.rush_intervention then
			CurrentSpecialsSettings.rush_intervention.breeds = var_4_0(CurrentSpecialsSettings.rush_intervention.breeds)
		end

		if CurrentSpecialsSettings.speed_running_intervention then
			CurrentSpecialsSettings.speed_running_intervention.breeds = var_4_0(CurrentSpecialsSettings.speed_running_intervention.breeds)
		end
	end,
	post_process_terror_event = function (arg_6_0, arg_6_1, arg_6_2)
		for iter_6_0, iter_6_1 in ipairs(arg_6_2) do
			if iter_6_1.breed_name then
				local var_6_0

				if type(iter_6_1.breed_name) == "string" then
					local var_6_1 = var_0_1[iter_6_1.breed_name]

					if var_6_1 then
						var_6_0 = table.clone(iter_6_1)
						var_6_0.breed_name = var_6_1
					end
				else
					local var_6_2

					for iter_6_2, iter_6_3 in ipairs(iter_6_1.breed_name) do
						local var_6_3 = var_0_1[iter_6_3]

						if var_6_3 then
							var_6_0 = var_6_0 or table.clone(iter_6_1)
							var_6_2 = var_6_2 or table.clone(iter_6_1.breed_name)
							var_6_2[iter_6_2] = var_6_3
						end
					end

					if var_6_2 then
						var_6_0.breed_name = var_6_2
					end
				end

				if var_6_0 then
					arg_6_2[iter_6_0] = var_6_0
				end
			end
		end
	end,
	server_ai_spawned_function = function (arg_7_0, arg_7_1, arg_7_2)
		local var_7_0 = BLACKBOARDS[arg_7_2]
		local var_7_1 = var_7_0 and var_7_0.breed.name

		if var_0_2[var_7_1] and var_0_2[var_7_1](arg_7_2, var_7_0) then
			arg_7_1.processed_units[#arg_7_1.processed_units + 1] = arg_7_2
		end
	end,
	server_update_function = function (arg_8_0, arg_8_1)
		local var_8_0 = Managers.time:time("game")

		if var_8_0 > arg_8_1.check_at then
			for iter_8_0 = #arg_8_1.processed_units, 1, -1 do
				local var_8_1 = arg_8_1.processed_units[iter_8_0]
				local var_8_2 = BLACKBOARDS[var_8_1]
				local var_8_3 = var_8_2 and var_0_3[var_8_2.breed.name](var_8_1, var_8_2)

				if var_8_2 == nil or var_8_3 then
					table.swap_delete(arg_8_1.processed_units, iter_8_0)
				end
			end

			arg_8_1.check_at = var_8_0 + var_0_0
		end
	end,
	get_terror_event_tags = function (arg_9_0, arg_9_1, arg_9_2)
		arg_9_2[#arg_9_2 + 1] = DeusTerrorEventTags.NO_SORCERERS
	end
}
