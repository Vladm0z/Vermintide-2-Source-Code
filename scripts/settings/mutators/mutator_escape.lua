-- chunkname: @scripts/settings/mutators/mutator_escape.lua

local num = 10
local tbl = {
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

local function fn(arg_1_0)
	-- function 1
	local var_1_0

	for i, v in ipairs(arg_1_0) do
		if not tbl[v] then
			var_1_0 = v
		end
	end

	return var_1_0
end

local function fn_2(arg_2_0, arg_2_1)
	-- function 2
	local var_2_0 = tbl[arg_2_0]
	local var_2_1
	local var_2_2

	arg_2_1, var_2_2 = Math.next_random(arg_2_1, 1, #var_2_0)

	local var_2_3 = var_2_0[var_2_2]

	return arg_2_1, var_2_3
end

return {
	hide_from_player_ui = true,
	server_update_function = function (arg_3_0, arg_3_1)
		-- function 3
		local conflict = Managers.state.conflict

		if not conflict then
			return
		end

		if not arg_3_1.setup_done then
			conflict.pacing:disable()
			conflict.pacing:disable_roamers()

			arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")

			Managers.state.entity:system("mission_system"):request_mission("mutator_escape")

			arg_3_1.setup_done = true
		end

		local time = Managers.time:time("game")

		if not (not arg_3_1.check_at and not (time > arg_3_1.check_at)) then
			if Managers.state.performance:num_active_enemies() < num then
				local factions = ConflictDirectors[conflict.current_conflict_settings].factions
				local flag = not factions and fn(factions)

				if not flag then
					local side_id = Managers.state.side:get_side_from_name("dark_pact").side_id
					local var_3_5
					local var_3_6

					arg_3_1.seed, var_3_6 = fn_2(flag, arg_3_1.seed)

					local tbl = {
						start_delay = 0,
						only_behind = true,
						silent = true,
						override_composition_type = var_3_6
					}

					conflict.horde_spawner:horde("vector", tbl, side_id)
				end
			end

			arg_3_1.check_at = time + 5
		end
	end
}
