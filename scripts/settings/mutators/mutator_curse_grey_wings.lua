-- chunkname: @scripts/settings/mutators/mutator_curse_grey_wings.lua

local var_0_0 = 20
local var_0_1 = 50
local var_0_2 = printf

local function var_0_3(...)
	local var_1_0 = sprintf(...)

	var_0_2("[MutatorCurseGreyWings] %s", var_1_0)
end

local function var_0_4(...)
	if script_data.belakor_grey_wings_debug then
		local var_2_0 = sprintf(...)

		var_0_2("[MutatorCurseGreyWings] %s", var_2_0)
	end
end

local var_0_5 = 10
local var_0_6 = 20
local var_0_7 = 10

return {
	description = "curse_grey_wings_desc",
	display_name = "curse_grey_wings_name",
	icon = "deus_curse_belakor_01",
	packages = {
		"resource_packages/mutators/mutator_curse_grey_wings"
	},
	server_start_function = function(arg_3_0, arg_3_1)
		arg_3_1.conflict_director = Managers.state.conflict
		arg_3_1.seed = Managers.mechanism:get_level_seed("mutator")
	end,
	server_players_left_safe_zone = function(arg_4_0, arg_4_1)
		arg_4_1.started = true
	end,
	server_pre_update_function = function(arg_5_0, arg_5_1, arg_5_2, arg_5_3)
		if Managers.state.unit_spawner.game_session == nil or global_is_inside_inn then
			return
		end

		if not arg_5_1.started then
			return
		end

		if TerrorEventMixer.is_event_id_active_or_pending(arg_5_1.active_terror_event_id) then
			arg_5_1.next_spawn_t = nil

			return
		end

		local var_5_0 = arg_5_1.conflict_director

		if var_5_0.pacing:horde_population() < 1 or var_5_0.pacing:get_state() == "pacing_frozen" then
			arg_5_1.next_spawn_t = nil

			return
		end

		if not arg_5_1.next_spawn_t then
			local var_5_1 = arg_5_1.seed
			local var_5_2, var_5_3 = Math.next_random(var_5_1, var_0_0, var_0_1)

			arg_5_1.seed = var_5_2
			arg_5_1.next_spawn_t = arg_5_3 + var_5_3
		end

		if arg_5_3 < arg_5_1.next_spawn_t then
			return
		end

		local var_5_4 = PlayerUtils.get_random_alive_hero()

		if var_5_4 then
			local var_5_5 = POSITION_LOOKUP[var_5_4]
			local var_5_6 = {}
			local var_5_7 = Managers.state.side:get_side_from_name("heroes").PLAYER_AND_BOT_UNITS

			for iter_5_0 = 1, #var_5_7 do
				local var_5_8 = var_5_7[iter_5_0]

				var_5_6[#var_5_6 + 1] = POSITION_LOOKUP[var_5_8]
			end

			local var_5_9 = Managers.state.entity:system("ai_system"):nav_world()
			local var_5_10 = {}

			ConflictUtils.find_positions_around_position(var_5_5, var_5_10, var_5_9, var_0_5, var_0_6, 1, var_5_6, var_0_7)

			local var_5_11 = var_5_10[1]

			if var_5_11 then
				local var_5_12 = arg_5_1.seed
				local var_5_13

				arg_5_1.active_terror_event_id = Managers.state.conflict:start_terror_event("grey_wings_spawns", var_5_12, var_5_13, var_5_11)
				arg_5_1.seed = Math.next_random(var_5_12)
				arg_5_1.next_spawn_t = nil
			end
		end
	end,
	server_player_hit_function = function(arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4)
		return
	end
}
