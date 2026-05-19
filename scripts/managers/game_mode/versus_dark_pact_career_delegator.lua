-- chunkname: @scripts/managers/game_mode/versus_dark_pact_career_delegator.lua

VersusDarkPactCareerDelegator = class(VersusDarkPactCareerDelegator)

local var_0_0 = {
	default = {
		[0] = 1,
		0.5,
		0.25,
		0.125
	},
	vs_poison_wind_globadier = {
		[0] = 0.8,
		0.4,
		0.2,
		0.1
	}
}
local var_0_1 = {
	[1] = 0.25
}

function VersusDarkPactCareerDelegator.init(arg_1_0)
	arg_1_0._playable_boss_can_be_picked = false
	arg_1_0._picks_per_career = {}
	arg_1_0._picks_per_player = {}
	arg_1_0._peer_picking_boss = nil
	arg_1_0._rolled_careers_time_stamp = {}
	arg_1_0._last_picked_by_player = {}

	Managers.state.event:register(arg_1_0, "on_player_left_party", "on_player_left_party")
	Managers.state.event:register(arg_1_0, "player_profile_assigned", "on_player_profile_assigned")

	arg_1_0._mechanism = Managers.mechanism:game_mechanism()

	arg_1_0:_override_available_profiles(GameModeSettings.versus)
	arg_1_0:_initialize_custom_settings()
end

function VersusDarkPactCareerDelegator._override_available_profiles(arg_2_0, arg_2_1)
	local var_2_0 = Managers.mechanism:mechanism_setting_for_title("override_career_availability")

	if not arg_2_0._bosses then
		arg_2_0._bosses = table.shallow_copy(arg_2_1.dark_pact_boss_profiles)

		for iter_2_0 = #arg_2_0._bosses, 1, -1 do
			if var_2_0[arg_2_0._bosses[iter_2_0]] == false then
				table.swap_delete(arg_2_0._bosses, iter_2_0)
			end
		end
	end

	if not arg_2_0._all_careers then
		arg_2_0._all_careers = table.shallow_copy(arg_2_1.dark_pact_profile_order)

		for iter_2_1 = #arg_2_0._all_careers, 1, -1 do
			if var_2_0[arg_2_0._all_careers[iter_2_1]] == false then
				table.swap_delete(arg_2_0._all_careers, iter_2_1)
			end
		end
	end
end

function VersusDarkPactCareerDelegator.destroy(arg_3_0)
	Managers.state.event:unregister("on_player_left_party", arg_3_0)
	Managers.state.event:unregister("player_profile_assigned", arg_3_0)
	Managers.state.event:unregister("player_unit_relinquished", arg_3_0)
end

function VersusDarkPactCareerDelegator._roll_career_options(arg_4_0, arg_4_1, arg_4_2, arg_4_3)
	local var_4_0 = {}
	local var_4_1 = FrameTable.alloc_table()

	for iter_4_0 = 1, arg_4_1 do
		var_4_1[iter_4_0] = 0
	end

	local var_4_2 = arg_4_0._picks_per_player[arg_4_3] or {}

	arg_4_0._picks_per_player[arg_4_3] = var_4_2

	for iter_4_1 = 1, #arg_4_2 do
		local var_4_3 = arg_4_2[iter_4_1]

		arg_4_0._picks_per_career[var_4_3] = arg_4_0._picks_per_career[var_4_3] or 0

		local var_4_4 = arg_4_0._picks_per_career[var_4_3]
		local var_4_5 = var_0_0[var_4_3] or var_0_0.default
		local var_4_6 = arg_4_0:_weight_by_repetition(arg_4_3, var_4_3)
		local var_4_7 = 1

		if arg_4_0._custom_settings_spawn_chance_multipliers and not table.is_empty(arg_4_0._custom_settings_spawn_chance_multipliers) then
			var_4_7 = arg_4_0._custom_settings_spawn_chance_multipliers[var_4_3]
		end

		local var_4_8 = math.random() * (var_4_5[var_4_4] or 0) * var_4_6 * var_4_7
		local var_4_9 = table.min(var_4_1)

		if var_4_8 >= var_4_1[var_4_9] then
			var_4_0[var_4_9] = var_4_3
			var_4_1[var_4_9] = var_4_8
		end
	end

	for iter_4_2 = 1, #var_4_0 do
		local var_4_10 = var_4_0[iter_4_2]

		var_4_2[iter_4_2] = var_4_10
		arg_4_0._picks_per_career[var_4_10] = arg_4_0._picks_per_career[var_4_10] + 1
	end

	return var_4_0
end

function VersusDarkPactCareerDelegator.request_careers(arg_5_0, arg_5_1)
	printf("[DELEGATOR] requested careers, peer_id: %s", arg_5_1)
	arg_5_0:_release_career_for_player(arg_5_1)

	local var_5_0 = Managers.state.game_mode:game_mode():settings()
	local var_5_1 = arg_5_0._custom_num_special_pick_options or var_5_0.dark_pact_picking_rules.special_pick_options
	local var_5_2 = arg_5_0:_roll_career_options(var_5_1, arg_5_0._all_careers, arg_5_1)

	if arg_5_0._playable_boss_can_be_picked then
		if DEDICATED_SERVER then
			cprint("[VS BOSS] added boss to picking list")
		elseif Managers.state.network.is_server then
			print("[VS BOSS] added boss to picking list")
		end

		assert(arg_5_0._peer_picking_boss == nil, "Peer_picking_boss needs to be nill, another player is picking the boss")

		arg_5_0._peer_picking_boss = arg_5_1

		for iter_5_0 = 1, #arg_5_0._bosses do
			local var_5_3 = arg_5_0._bosses[iter_5_0]

			var_5_2[#var_5_2 + 1] = var_5_3

			table.insert(arg_5_0._picks_per_player[arg_5_1], var_5_3)

			arg_5_0._picks_per_career[var_5_3] = (arg_5_0._picks_per_career[var_5_3] or 0) + 1

			arg_5_0:set_playable_boss_can_be_picked(false)
		end
	end

	arg_5_0._rolled_careers_time_stamp[arg_5_1] = Managers.time:time("game")

	return var_5_2, "all"
end

function VersusDarkPactCareerDelegator.set_playable_boss_can_be_picked(arg_6_0, arg_6_1)
	if arg_6_0._custom_setting_no_bosses or #arg_6_0._bosses == 0 then
		return
	end

	if DEDICATED_SERVER then
		cprint("[VS BOSS] setting is_playble_boss_next")
	elseif Managers.state.network.is_server then
		printf("[Playable_bosses] setting is_playble_boss_next %s", arg_6_1)
	end

	if arg_6_0._peer_picking_boss == nil and arg_6_1 then
		arg_6_0._playable_boss_can_be_picked = true
	elseif not arg_6_1 then
		arg_6_0._playable_boss_can_be_picked = false
	else
		print("[VS BOSS] self._playable_boss_can_be_picked was not sett")
	end
end

function VersusDarkPactCareerDelegator.get_playable_boss_can_be_picked(arg_7_0)
	return arg_7_0._playable_boss_can_be_picked
end

function VersusDarkPactCareerDelegator.on_player_profile_assigned(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4)
	local var_8_0 = SPProfiles[arg_8_3].careers[arg_8_4].name
	local var_8_1 = Managers.state.game_mode:game_mode():settings()

	if not arg_8_0._picks_per_player[arg_8_1] then
		return
	end

	if not table.contains(var_8_1.dark_pact_profile_order, var_8_0) and not table.contains(GameModeSettings.versus.dark_pact_boss_profiles, var_8_0) then
		return
	end

	arg_8_0:_career_picked(arg_8_1, var_8_0)
end

function VersusDarkPactCareerDelegator.on_player_left_party(arg_9_0, arg_9_1)
	arg_9_0:_release_career_for_player(arg_9_1)

	arg_9_0._picks_per_player[arg_9_1] = nil
end

function VersusDarkPactCareerDelegator._career_picked(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:_picking_telemetry(arg_10_1, arg_10_2)
	arg_10_0:_release_career_for_player(arg_10_1)

	arg_10_0._picks_per_career[arg_10_2] = (arg_10_0._picks_per_career[arg_10_2] or 0) + 1

	local var_10_0 = arg_10_0._picks_per_player[arg_10_1] or {}

	arg_10_0._picks_per_player[arg_10_1] = var_10_0

	if arg_10_0._peer_picking_boss and arg_10_1 == arg_10_0._peer_picking_boss then
		if table.contains(arg_10_0._bosses, arg_10_2) then
			arg_10_0._peer_picking_boss = nil
		else
			arg_10_0._peer_picking_boss = nil

			arg_10_0:set_playable_boss_can_be_picked(true)
		end
	end

	var_10_0[1] = arg_10_2

	arg_10_0:_register_player_career(arg_10_1, arg_10_2)
end

function VersusDarkPactCareerDelegator._release_career_for_player(arg_11_0, arg_11_1)
	local var_11_0 = arg_11_0._picks_per_player[arg_11_1]

	if var_11_0 then
		for iter_11_0 = 1, #var_11_0 do
			local var_11_1 = var_11_0[iter_11_0]

			arg_11_0._picks_per_career[var_11_1] = arg_11_0._picks_per_career[var_11_1] - 1

			printf("[DELEGATOR] releasing career: %s", var_11_0[iter_11_0])

			var_11_0[iter_11_0] = nil
		end
	end
end

function VersusDarkPactCareerDelegator.update(arg_12_0)
	return
end

function VersusDarkPactCareerDelegator._picking_telemetry(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = Managers.state.game_mode:game_mode():settings()

	if not table.contains(var_13_0.dark_pact_profile_order, arg_13_2) and not table.contains(GameModeSettings.versus.dark_pact_boss_profiles, arg_13_2) then
		return
	end

	if not Managers.player:player_from_peer_id(arg_13_1) then
		return
	end

	if not arg_13_0._picks_per_player[arg_13_1] then
		return
	end

	local var_13_1 = arg_13_0._mechanism:get_peer_backend_id(arg_13_1) or "offline backend"
	local var_13_2 = table.shallow_copy(arg_13_0._picks_per_player[arg_13_1])
	local var_13_3 = Managers.mechanism:game_mechanism():match_id()
	local var_13_4 = Managers.time:time("game") - arg_13_0._rolled_careers_time_stamp[arg_13_1]
	local var_13_5 = PLATFORM
	local var_13_6 = BUILD

	Managers.telemetry_events:versus_pactsworn_picking(var_13_3, var_13_1, var_13_2, arg_13_2, var_13_4, var_13_5, var_13_6)
end

function VersusDarkPactCareerDelegator._weight_by_repetition(arg_14_0, arg_14_1, arg_14_2)
	local var_14_0 = arg_14_0._last_picked_by_player[arg_14_1]

	if not var_14_0 then
		return 1
	end

	for iter_14_0 = 1, #var_14_0 do
		if var_14_0[iter_14_0] == arg_14_2 then
			return var_0_1[iter_14_0]
		end
	end

	return 1
end

function VersusDarkPactCareerDelegator._register_player_career(arg_15_0, arg_15_1, arg_15_2)
	local var_15_0 = arg_15_0._last_picked_by_player[arg_15_1] or {}

	arg_15_0._last_picked_by_player[arg_15_1] = var_15_0

	table.insert(var_15_0, 1, arg_15_2)

	for iter_15_0 = #var_0_1 + 1, #var_15_0 do
		var_15_0[iter_15_0] = nil
	end
end

function VersusDarkPactCareerDelegator._initialize_custom_settings(arg_16_0)
	local var_16_0, var_16_1, var_16_2 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", "num_pactsworn_picking_options")

	if not var_16_2 then
		return
	end

	if var_16_1 then
		arg_16_0._custom_num_special_pick_options = var_16_1
	end

	local var_16_3 = arg_16_0._all_careers

	arg_16_0._custom_settings_spawn_chance_multipliers = {}

	local var_16_4 = 0

	for iter_16_0 = 1, #var_16_3 do
		local var_16_5 = var_16_3[iter_16_0]
		local var_16_6 = var_16_5 .. "_spawn_chance_multiplier"
		local var_16_7, var_16_8, var_16_9 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", var_16_6)

		if var_16_0 and var_16_2 and var_16_8 then
			arg_16_0._custom_settings_spawn_chance_multipliers[var_16_5] = var_16_8

			if var_16_8 ~= 0 then
				var_16_4 = var_16_4 + 1
			end
		end
	end

	local var_16_10 = arg_16_0._bosses
	local var_16_11 = {}

	for iter_16_1 = 1, #arg_16_0._bosses do
		local var_16_12 = var_16_10[iter_16_1]
		local var_16_13 = var_16_12 .. "_spawn_chance_multiplier"
		local var_16_14, var_16_15, var_16_16 = Managers.mechanism:mechanism_try_call("get_custom_game_setting", var_16_13)

		if var_16_15 ~= "default" and var_16_15 ~= false then
			arg_16_0._custom_settings_spawn_chance_multipliers[var_16_12] = var_16_15
			arg_16_0._all_careers[#arg_16_0._all_careers + 1] = var_16_12
			var_16_4 = var_16_4 + 1
		elseif var_16_15 == "default" then
			var_16_11[#var_16_11 + 1] = var_16_12
		end
	end

	arg_16_0._bosses = var_16_11
	arg_16_0._custom_setting_no_bosses = #arg_16_0._bosses == 0

	if var_16_4 == 0 then
		table.clear(arg_16_0._custom_settings_spawn_chance_multipliers)
	elseif var_16_4 < arg_16_0._custom_num_special_pick_options then
		arg_16_0._custom_num_special_pick_options = var_16_4
	end
end
