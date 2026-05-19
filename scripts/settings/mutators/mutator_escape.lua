-- chunkname: @scripts/settings/mutators/mutator_escape.lua

local var_0_0 = 10
local var_0_1 = {
	chaos = {
		"event_large_chaos",
		"event_large"
	},
	beastmen = {
		"event_large_beastmen",
		"event_large"
	},
	skaven = {
		"event_large"
	}
}

local function var_0_2(arg_1_0)
	local var_1_0

	for iter_1_0, iter_1_1 in ipairs(arg_1_0) do
		if var_0_1[iter_1_1] then
			var_1_0 = iter_1_1
		end
	end

	return var_1_0
end

local function var_0_3(arg_2_0, arg_2_1)
	local var_2_0 = var_0_1[arg_2_0]
	local var_2_1
	local var_2_2

	arg_2_1, var_2_2 = Math.next_random(arg_2_1, 1, #var_2_0)

	local var_2_3 = var_2_0[var_2_2]

	return arg_2_1, var_2_3
end

return {
	hide_from_player_ui = true,
	server_update_function = function(arg_3_0, arg_3_1)
		local var_3_0 = Managers.state.conflict

		if not var_3_0 then
			return
		end

		if not arg_3_1.setup_done then
			var_3_0.pacing:disable()
			var_3_0.pacing:disable_roamers()

			arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")

			Managers.state.entity:system("mission_system"):request_mission("mutator_escape")

			arg_3_1.setup_done = true
		end

		local var_3_1 = Managers.time:time("game")

		if not arg_3_1.check_at or var_3_1 > arg_3_1.check_at then
			if Managers.state.performance:num_active_enemies() < var_0_0 then
				local var_3_2 = ConflictDirectors[var_3_0.current_conflict_settings].factions
				local var_3_3 = var_3_2 and var_0_2(var_3_2)

				if var_3_3 then
					local var_3_4 = Managers.state.side:get_side_from_name("dark_pact").side_id
					local var_3_5
					local var_3_6

					arg_3_1.seed, var_3_6 = var_0_3(var_3_3, arg_3_1.seed)

					local var_3_7 = {
						start_delay = 0,
						only_behind = true,
						silent = true,
						override_composition_type = var_3_6
					}

					var_3_0.horde_spawner:horde("vector", var_3_7, var_3_4)
				end
			end

			arg_3_1.check_at = var_3_1 + 5
		end
	end
}
