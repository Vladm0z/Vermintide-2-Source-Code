-- chunkname: @scripts/settings/mutators/mutator_curse_grey_wings.lua

local num = 20
local num_2 = 50
local printf = printf

local function fn(...)
	-- function 1
	local var_1_0 = sprintf(...)

	printf("[MutatorCurseGreyWings] %s", var_1_0)
end

local function fn_2(...)
	-- function 2
	if not script_data.belakor_grey_wings_debug then
		local var_2_0 = sprintf(...)

		printf("[MutatorCurseGreyWings] %s", var_2_0)
	end
end

local num_3 = 10
local num_4 = 20
local num_5 = 10

return {
	description = "curse_grey_wings_desc",
	display_name = "curse_grey_wings_name",
	icon = "deus_curse_belakor_01",
	packages = {
		"resource_packages/mutators/mutator_curse_grey_wings"
	},
	server_start_function = function (arg_3_0, arg_3_1)
		-- function 3
		arg_3_1.conflict_director = Managers.state.conflict
		arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")
	end,
	server_players_left_safe_zone = function (arg_4_0, arg_4_1)
		-- function 4
		arg_4_1.started = true
	end,
	server_pre_update_function = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		-- function 5
		if Managers.state.unit_spawner.game_session == nil or not global_is_inside_inn then
			return
		end

		if not arg_5_1.started then
			return
		end

		if not TerrorEventMixer.is_event_id_active_or_pending(arg_5_1.active_terror_event_id) then
			arg_5_1.next_spawn_t = nil

			return
		end

		local conflict_director = arg_5_1.conflict_director

		if not (conflict_director.pacing:horde_population() < 1 or conflict_director.pacing:get_state() ~= "pacing_frozen") then
			arg_5_1.next_spawn_t = nil

			return
		end

		if not arg_5_1.next_spawn_t then
			local seed = arg_5_1.seed
			local next_random, var_5_3 = Math.next_random(seed, num, num_2)

			arg_5_1.seed = next_random
			arg_5_1.next_spawn_t = arg_5_3 + var_5_3
		end

		if arg_5_3 < arg_5_1.next_spawn_t then
			return
		end

		local get_random_alive_hero = PlayerUtils.get_random_alive_hero()

		if not get_random_alive_hero then
			local var_5_5 = POSITION_LOOKUP[get_random_alive_hero]
			local tbl = {}
			local PLAYER_AND_BOT_UNITS = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for i = 1, #PLAYER_AND_BOT_UNITS do
				local var_5_8 = PLAYER_AND_BOT_UNITS[i]

				tbl[#tbl + 1] = POSITION_LOOKUP[var_5_8]
			end

			local nav_world = Managers.state.entity:system("ai_system"):nav_world()
			local tbl_2 = {}

			ConflictUtils.find_positions_around_position(var_5_5, tbl_2, nav_world, num_3, num_4, 1, tbl, num_5)

			local var_5_11 = tbl_2[1]

			if not var_5_11 then
				local seed_2 = arg_5_1.seed
				local var_5_13

				arg_5_1.active_terror_event_id = Managers.state.conflict:start_terror_event("grey_wings_spawns", seed_2, var_5_13, var_5_11)
				arg_5_1.seed = Math.next_random(seed_2)
				arg_5_1.next_spawn_t = nil
			end
		end
	end,
	server_player_hit_function = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		-- function 6
		return
	end
}
