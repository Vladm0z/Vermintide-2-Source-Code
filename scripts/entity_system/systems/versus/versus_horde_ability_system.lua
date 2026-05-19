-- chunkname: @scripts/entity_system/systems/versus/versus_horde_ability_system.lua

require("scripts/unit_extensions/default_player_unit/versus_horde_ability_extension")
require("scripts/unit_extensions/default_player_unit/versus_horde_ability_husk_extension")

local var_0_0 = local_require("scripts/settings/versus_horde_ability_settings")

VersusHordeAbilitySystem = class(VersusHordeAbilitySystem, ExtensionSystemBase)

local var_0_1 = {
	"rpc_activate_dark_pact_horde_ability",
	"rpc_client_outline_own_horde_units",
	"rpc_horde_ability_activated"
}
local var_0_2 = {
	"VersusHordeAbilityExtension",
	"VersusHordeAbilityHuskExtension"
}

function VersusHordeAbilitySystem.init(arg_1_0, arg_1_1, arg_1_2)
	VersusHordeAbilitySystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_2)
	arg_1_0:register_rpcs(arg_1_1.network_event_delegate)

	if arg_1_0.is_server then
		arg_1_0._server_player_data = {}
		arg_1_0._next_batch_sync = 0
		arg_1_0._event_manager = Managers.state.event
		arg_1_0._conflict_director = Managers.state.conflict
		arg_1_0._mechanism = Managers.mechanism:game_mechanism()
		arg_1_0._win_conditions = arg_1_0._mechanism:win_conditions()

		arg_1_0._event_manager:register(arg_1_0, "new_player_unit", "on_player_unit_spawned")
		arg_1_0._event_manager:register(arg_1_0, "gm_event_round_started", "on_round_started")
		arg_1_0._event_manager:register(arg_1_0, "on_player_joined_party", "on_player_joined_party")
		arg_1_0._event_manager:register(arg_1_0, "on_player_left_party", "on_player_left_party")

		arg_1_0._num_players_by_party = {
			0,
			0
		}

		if arg_1_0._mechanism:custom_settings_enabled() then
			arg_1_0._custom_settings_modifier = arg_1_0._mechanism:get_custom_game_setting("horde_ability_recharge_rate_percent") / 100
		end
	end

	arg_1_0._extensions = {}
	arg_1_0.unit_storage = arg_1_1.unit_storage
end

function VersusHordeAbilitySystem.destroy(arg_2_0)
	if arg_2_0.is_server then
		arg_2_0._event_manager:unregister("new_player_unit", arg_2_0)
		arg_2_0._event_manager:unregister("gm_event_round_started", arg_2_0)
		arg_2_0._event_manager:unregister("on_player_joined_party", arg_2_0)
		arg_2_0._event_manager:unregister("on_player_left_party", arg_2_0)

		if var_0_0.save_charges_between_rounds then
			arg_2_0._mechanism:cache_horde_ability_charge_data(arg_2_0._server_player_data)
		end
	end

	arg_2_0:unregister_rpcs()
end

function VersusHordeAbilitySystem.register_rpcs(arg_3_0, arg_3_1)
	arg_3_0._network_event_delegate = arg_3_1

	arg_3_1:register(arg_3_0, unpack(var_0_1))
end

function VersusHordeAbilitySystem.unregister_rpcs(arg_4_0)
	if arg_4_0._network_event_delegate then
		arg_4_0._network_event_delegate:unregister(arg_4_0)

		arg_4_0._network_event_delegate = nil
	end
end

function VersusHordeAbilitySystem.update(arg_5_0, arg_5_1, arg_5_2)
	if arg_5_0.is_server then
		arg_5_0:_server_update_ability_charges(arg_5_1.dt)
		arg_5_0:_server_batch_sync_client_horde_units(arg_5_2)
	end

	for iter_5_0, iter_5_1 in pairs(arg_5_0._extensions) do
		iter_5_1:update(arg_5_2)
	end
end

function VersusHordeAbilitySystem.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)
	arg_6_0._extensions[arg_6_1] = nil

	VersusHordeAbilitySystem.super.on_remove_extension(arg_6_0, arg_6_1, arg_6_2)
end

function VersusHordeAbilitySystem.on_add_extension(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	local var_7_0 = VersusHordeAbilitySystem.super.on_add_extension(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)

	arg_7_0._extensions[arg_7_2] = var_7_0

	return var_7_0
end

function VersusHordeAbilitySystem.cooldown(arg_8_0)
	return var_0_0.cooldown
end

function VersusHordeAbilitySystem.on_round_started(arg_9_0)
	arg_9_0._round_started = true
end

function VersusHordeAbilitySystem.is_activation_allowed(arg_10_0, arg_10_1)
	return (var_0_0.enable_activation_in_ghost_mode or not arg_10_1) and arg_10_0._round_started
end

function VersusHordeAbilitySystem.activate_dark_pact_horde_ability(arg_11_0)
	if arg_11_0.is_server then
		local var_11_0 = Managers.player:local_player():network_id()

		arg_11_0:server_spawn_horde(var_11_0)
	else
		arg_11_0.network_transmit:send_rpc_server("rpc_activate_dark_pact_horde_ability")
	end
end

function VersusHordeAbilitySystem.rpc_client_outline_own_horde_units(arg_12_0, arg_12_1, arg_12_2)
	for iter_12_0 = 1, #arg_12_2 do
		local var_12_0 = arg_12_0.unit_storage:unit(arg_12_2[iter_12_0])

		if var_12_0 then
			ScriptUnit.extension(var_12_0, "outline_system"):add_outline(OutlineSettingsVS.templates.horde_ability)
		end
	end
end

function VersusHordeAbilitySystem.server_register_horde_unit(arg_13_0, arg_13_1, arg_13_2)
	local var_13_0 = arg_13_0._server_player_data[arg_13_2]

	var_13_0.ability_horde_units_to_sync[#var_13_0.ability_horde_units_to_sync + 1] = arg_13_1
end

function VersusHordeAbilitySystem._server_update_ability_charges(arg_14_0, arg_14_1)
	local var_14_0 = var_0_0.cooldown
	local var_14_1

	for iter_14_0, iter_14_1 in pairs(arg_14_0._server_player_data) do
		if iter_14_1.ability_charge then
			local var_14_2 = arg_14_0:_recharge_modifier(iter_14_0)
			local var_14_3 = var_14_2.cooldown
			local var_14_4 = arg_14_0._custom_settings_modifier or 1
			local var_14_5 = not arg_14_0._round_started and 0 or arg_14_1 * var_14_3 * var_14_4

			if script_data.short_ability_cooldowns then
				var_14_5 = var_14_5 * 100
			end

			iter_14_1.ability_charge = math.clamp(iter_14_1.ability_charge + var_14_5, 0, var_14_0)

			if iter_14_1.extension then
				local var_14_6 = var_14_2.boost

				iter_14_1.extension:server_set_ability_charge(math.floor(iter_14_1.ability_charge), var_14_3, var_14_6)
			end
		end
	end
end

function VersusHordeAbilitySystem.server_spawn_horde(arg_15_0, arg_15_1)
	local var_15_0 = Managers.state.conflict
	local var_15_1 = Managers.state.side:get_side_from_name("dark_pact").side_id
	local var_15_2 = arg_15_0._server_player_data[arg_15_1]

	if var_0_0.cooldown > var_15_2.ability_charge then
		return
	end

	local var_15_3 = arg_15_0:get_composition()
	local var_15_4 = {
		override_composition_type = var_15_3
	}
	local var_15_5 = {
		horde_ability_caller_peer_id = arg_15_1
	}
	local var_15_6 = var_15_2.extension and POSITION_LOOKUP[var_15_2.extension:unit()] or nil

	var_15_0.horde_spawner:execute_ambush_horde(var_15_4, var_15_1, false, var_15_6, var_15_5)

	var_15_2.ability_charge = 0

	local var_15_7 = Managers.player:player(arg_15_1, 1)

	if var_15_7 then
		local var_15_8 = var_15_7.player_unit

		if ALIVE[var_15_8] then
			ScriptUnit.extension_input(var_15_8, "dialogue_system"):trigger_dialogue_event("vs_ability_horde")
		end

		Managers.state.network.network_transmit:send_rpc_all("rpc_horde_ability_activated", arg_15_1)
	end
end

function VersusHordeAbilitySystem.server_register_peer(arg_16_0, arg_16_1)
	local var_16_0 = var_0_0.save_charges_between_rounds and arg_16_0._mechanism:get_cached_horde_ability_charges(arg_16_1)

	if not arg_16_0._server_player_data[arg_16_1] then
		arg_16_0._server_player_data[arg_16_1] = {
			ability_charge = var_16_0 or 0,
			ability_horde_units_to_sync = {}
		}
	end
end

function VersusHordeAbilitySystem.server_ability_recharge_boost(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
	if arg_17_5 and not var_0_0.recharge_boosts_on_downed_units then
		return
	end

	local var_17_0 = arg_17_0._server_player_data[arg_17_1]

	if not var_17_0 then
		return
	end

	local var_17_1 = var_0_0.recharge_boosts.actions
	local var_17_2 = var_0_0.recharge_boosts.damage_sources
	local var_17_3 = var_17_1[arg_17_2] or var_17_2[arg_17_3] or var_17_2[arg_17_4]

	if var_17_3 then
		local var_17_4 = var_17_3 * arg_17_0:_recharge_modifier(arg_17_1).boost
		local var_17_5 = var_0_0.cooldown / 100 * var_17_4

		var_17_0.ability_charge = var_17_0.ability_charge + var_17_5
	end
end

function VersusHordeAbilitySystem.on_player_unit_spawned(arg_18_0, arg_18_1, arg_18_2, arg_18_3)
	if not arg_18_0._extensions[arg_18_2] then
		return
	end

	local var_18_0 = arg_18_1.peer_id
	local var_18_1 = arg_18_0._server_player_data[var_18_0] or {}
	local var_18_2 = var_18_1 and var_18_1.ability_charge or arg_18_0._mechanism:get_cached_horde_ability_charges(var_18_0) or 0

	var_18_1.player_unit = arg_18_2
	var_18_1.extension = arg_18_0._extensions[arg_18_2]
	var_18_1.ability_charge = var_18_2
	arg_18_0._server_player_data[var_18_0] = var_18_1
end

function VersusHordeAbilitySystem.rpc_activate_dark_pact_horde_ability(arg_19_0, arg_19_1)
	local var_19_0 = CHANNEL_TO_PEER_ID[arg_19_1]

	arg_19_0:server_spawn_horde(var_19_0)
end

function VersusHordeAbilitySystem._server_batch_sync_client_horde_units(arg_20_0, arg_20_1)
	if arg_20_1 < arg_20_0._next_batch_sync then
		return
	end

	arg_20_0._next_batch_sync = arg_20_1 + var_0_0.horde_units_batch_sync_interval

	for iter_20_0, iter_20_1 in pairs(arg_20_0._server_player_data) do
		local var_20_0 = iter_20_1.ability_horde_units_to_sync

		if var_20_0 and not table.is_empty(var_20_0) then
			local var_20_1 = Script.new_array(var_0_0.max_num_horde_units_per_player)

			for iter_20_2 = 1, #var_20_0 do
				var_20_1[iter_20_2] = var_20_0[iter_20_2]
			end

			table.clear(var_20_0)

			if PEER_ID_TO_CHANNEL[iter_20_0] then
				arg_20_0.network_transmit:send_rpc("rpc_client_outline_own_horde_units", iter_20_0, var_20_1)
			end
		end
	end
end

function VersusHordeAbilitySystem.get_composition(arg_21_0)
	local var_21_0 = ConflictDirectors[arg_21_0._conflict_director.current_conflict_settings].factions
	local var_21_1 = var_0_0.compositions_per_faction
	local var_21_2 = var_21_1.skaven

	if var_21_0 and not table.is_empty(var_21_0) then
		local var_21_3 = #var_21_0
		local var_21_4 = math.random(1, var_21_3)

		for iter_21_0 = 0, var_21_3 - 1 do
			local var_21_5 = var_21_0[math.index_wrapper(var_21_4 + iter_21_0, var_21_3)]

			if var_21_1[var_21_5] then
				var_21_2 = var_21_1[var_21_5]

				break
			end
		end
	end

	return var_21_2
end

function VersusHordeAbilitySystem.on_player_joined_party(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5)
	if arg_22_5 then
		return
	end

	if arg_22_0._num_players_by_party[arg_22_3] then
		arg_22_0._num_players_by_party[arg_22_3] = arg_22_0._num_players_by_party[arg_22_3] + 1
	end
end

function VersusHordeAbilitySystem.on_player_left_party(arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4)
	if arg_23_0._num_players_by_party[arg_23_3] then
		arg_23_0._num_players_by_party[arg_23_3] = arg_23_0._num_players_by_party[arg_23_3] - 1
	end
end

function VersusHordeAbilitySystem._recharge_modifier(arg_24_0)
	arg_24_0._pactsworn_party_id = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	arg_24_0._hero_party_id = Managers.state.side:get_side_from_name("heroes").party.party_id

	local var_24_0 = Managers.state.side:get_side_from_name("dark_pact").party.party_id
	local var_24_1 = Managers.state.side:get_side_from_name("heroes").party.party_id
	local var_24_2 = math.clamp(arg_24_0._num_players_by_party[var_24_1] - arg_24_0._num_players_by_party[var_24_0], 0, 3)
	local var_24_3 = var_0_0.team_size_difference_recharge_modifier[var_24_2]
	local var_24_4 = arg_24_0._win_conditions:get_total_score(var_24_0)
	local var_24_5 = arg_24_0._win_conditions:get_total_score(var_24_1)
	local var_24_6 = 10
	local var_24_7 = var_24_4 - var_24_5
	local var_24_8 = math.sign(var_24_7)
	local var_24_9 = math.floor(math.abs(var_24_7 / var_24_6)) * var_24_6 * var_24_8
	local var_24_10 = var_0_0.max_score_difference_modifier
	local var_24_11 = var_0_0.score_difference_recharge_modifier[var_24_9] or var_0_0.score_difference_recharge_modifier[var_24_10 * var_24_8]
	local var_24_12 = var_0_0.team_size_difference_recharge_modifier[3]
	local var_24_13 = {
		cooldown = math.min(var_24_11.cooldown_mod * var_24_3, var_24_12),
		boost = math.min(var_24_11.boost_mod * var_24_3, var_24_12)
	}

	if arg_24_0._mechanism:get_current_set() == 1 then
		var_24_13 = {
			cooldown = var_24_3,
			boost = var_24_3
		}
	end

	return var_24_13 or 1
end

function VersusHordeAbilitySystem.settings(arg_25_0)
	return var_0_0
end

function VersusHordeAbilitySystem.rpc_horde_ability_activated(arg_26_0, arg_26_1, arg_26_2)
	if Managers.chat and Managers.chat:has_channel(1) then
		local var_26_0 = Managers.player:player(arg_26_2, 1)
		local var_26_1 = var_26_0 and var_26_0:name()

		if var_26_1 then
			Managers.chat:add_local_system_message(1, string.format(Localize("vs_chat_message_horde_ability"), var_26_1), true)
		end
	end
end
