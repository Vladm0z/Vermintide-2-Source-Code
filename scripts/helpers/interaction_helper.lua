-- chunkname: @scripts/helpers/interaction_helper.lua

script_data.debug_interactions = script_data.debug_interactions or Development.parameter("debug_interactions")
InteractionHelper = InteractionHelper or {}
InteractionHelper.interactions = {
	player_generic = {},
	revive = {},
	pull_up = {},
	assisted_respawn = {},
	heal = {},
	linker_transportation_unit = {},
	release_from_hook = {},
	give_item = {},
	smartobject = {},
	control_panel = {},
	pickup_object = {},
	chest = {},
	inventory_access = {},
	prestige_access = {},
	unlock_key_access = {},
	forge_access = {},
	altar_access = {},
	quest_access = {},
	journal_access = {},
	door = {},
	map_access = {},
	cosmetics_access = {},
	loot_access = {},
	characters_access = {},
	talents_access = {},
	pictureframe = {},
	trophy = {},
	decoration = {},
	achievement_access = {},
	luckstone_access = {},
	difficulty_selection_access = {},
	weave_level_select_access = {},
	weave_magic_forge_access = {},
	weave_leaderboard_access = {},
	inn_door_transition = {},
	deus_door_transition = {},
	carousel_door_transition = {},
	loadout_access = {},
	handbook_access = {},
	active_event = {}
}

DLCUtils.map_list("interactions", function(arg_1_0)
	InteractionHelper.interactions[arg_1_0] = {}
end)

for iter_0_0, iter_0_1 in pairs(InteractionHelper.interactions) do
	iter_0_1.request_rpc = iter_0_1.request_rpc or "rpc_generic_interaction_request"
end

function InteractionHelper.printf(...)
	if script_data.debug_interactions then
		printf(...)
	end
end

local var_0_0 = "IS_LOCAL_HOST"

function InteractionHelper.request(arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	if LEVEL_EDITOR_TEST then
		return
	end

	if arg_3_5 then
		InteractionHelper:request_approved(arg_3_1, arg_3_2, arg_3_3)

		return
	end

	local var_3_0 = Managers.state.unit_storage:go_id(arg_3_2)
	local var_3_1, var_3_2 = Managers.state.network:game_object_or_level_id(arg_3_3)

	InteractionHelper.printf("InteractionHelper:request(%s, %s, %s, %s)", arg_3_1, var_3_0, var_3_1, var_3_2)

	if var_3_0 == nil or var_3_1 == nil then
		InteractionHelper:request_denied(arg_3_2)

		return
	end

	local var_3_3 = InteractionHelper.interactions[arg_3_1].request_rpc
	local var_3_4 = NetworkLookup.interactions[arg_3_1]
	local var_3_5 = Managers.state.network

	if var_3_3 == "rpc_generic_interaction_request" then
		if arg_3_4 then
			var_3_5._event_delegate.event_table[var_3_3](Managers.state.network, var_0_0, var_3_0, var_3_1, var_3_2, var_3_4)
		else
			var_3_5.network_transmit:send_rpc_server(var_3_3, var_3_0, var_3_1, var_3_2, var_3_4)
		end
	elseif arg_3_4 then
		var_3_5._event_delegate.event_table[var_3_3](Managers.state.network, var_0_0, var_3_0, var_3_1, var_3_2)
	else
		var_3_5.network_transmit:send_rpc_server(var_3_3, var_3_0, var_3_1, var_3_2)
	end
end

function InteractionHelper.abort_authoritative(arg_4_0, arg_4_1)
	local var_4_0 = ScriptUnit.has_extension(arg_4_1, "interactor_system")

	if var_4_0 and (not var_4_0:is_interacting() or var_4_0:is_stopping()) then
		InteractionHelper.printf("Got abort when interaction had already finished, ignore request")

		return
	end

	local var_4_1 = var_4_0:interactable_unit()

	if Unit.alive(var_4_1) then
		InteractionHelper:complete_interaction(arg_4_1, var_4_1, InteractionResult.USER_ENDED)
	end
end

function InteractionHelper.abort(arg_5_0, arg_5_1, arg_5_2)
	InteractionHelper.printf("InteractionHelper:abort(%s)", arg_5_1)

	if ScriptUnit.extension(arg_5_1, "interactor_system"):is_interacting_with_local_only_interact() then
		InteractionHelper:abort_authoritative(arg_5_1)

		return
	end

	if not Managers.state.network:game() then
		return
	end

	local var_5_0 = Managers.state.unit_storage:go_id(arg_5_1)

	if not var_5_0 then
		return
	end

	if arg_5_2 or LEVEL_EDITOR_TEST then
		Managers.state.network._event_delegate.event_table:rpc_interaction_abort(Network.peer_id(), var_5_0)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_interaction_abort", var_5_0)
	end
end

function InteractionHelper.approve_request(arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	InteractionHelper.printf("InteractionHelper:approve_request(%s, %s, %s)", arg_6_1, tostring(arg_6_2), tostring(arg_6_3))

	if LEVEL_EDITOR_TEST then
		return
	end

	ScriptUnit.extension(arg_6_3, "interactable_system"):set_is_being_interacted_with(arg_6_2)

	local var_6_0 = NetworkLookup.interactions[arg_6_1]
	local var_6_1 = Managers.state.unit_storage:go_id(arg_6_2)
	local var_6_2, var_6_3 = Managers.state.network:game_object_or_level_id(arg_6_3)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_interaction_approved", var_6_0, var_6_1, var_6_2, var_6_3)
end

function InteractionHelper.deny_request(arg_7_0, arg_7_1, arg_7_2)
	InteractionHelper.printf("InteractionHelper:deny_request(%s, %s)", tostring(arg_7_1), tostring(arg_7_2))

	if Network.peer_id() == arg_7_1 then
		local var_7_0 = Managers.state.unit_storage:unit(arg_7_2)

		InteractionHelper:request_denied(var_7_0)
	else
		local var_7_1 = PEER_ID_TO_CHANNEL[arg_7_1]

		RPC.rpc_interaction_denied(var_7_1, arg_7_2)
	end
end

function InteractionHelper.request_approved(arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	InteractionHelper.printf("InteractionHelper:request_approved(%s, %s, %s)", arg_8_1, tostring(arg_8_2), tostring(arg_8_3))
	ScriptUnit.extension(arg_8_2, "interactor_system"):interaction_approved(arg_8_1, arg_8_3)
	ScriptUnit.extension(arg_8_3, "interactable_system"):set_is_being_interacted_with(arg_8_2)
end

function InteractionHelper.request_denied(arg_9_0, arg_9_1)
	InteractionHelper.printf("InteractionHelper:request_denied(%s)", tostring(arg_9_1))
	ScriptUnit.extension(arg_9_1, "interactor_system"):interaction_denied()
end

function InteractionHelper.complete_interaction(arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	InteractionHelper.printf("InteractionHelper:complete_interaction(%s, %s, %s)", tostring(arg_10_1), tostring(arg_10_2), InteractionResult[arg_10_3])
	InteractionHelper:interaction_completed(arg_10_1, arg_10_2, arg_10_3)

	if not ScriptUnit.extension(arg_10_2, "interactable_system"):local_only() then
		local var_10_0 = Managers.state.unit_storage:go_id(arg_10_1)

		if var_10_0 then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_interaction_completed", var_10_0, arg_10_3)
		end
	end
end

function InteractionHelper.interaction_completed(arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	InteractionHelper.printf("InteractionHelper:interaction_completed(%s, %s, %s)", tostring(arg_11_1), tostring(arg_11_2), InteractionResult[arg_11_3])

	local var_11_0 = ScriptUnit.has_extension(arg_11_1, "interactor_system")

	if var_11_0 then
		var_11_0:interaction_completed(arg_11_3)
	end

	if Unit.alive(arg_11_2) then
		ScriptUnit.extension(arg_11_2, "interactable_system"):set_is_being_interacted_with(nil, arg_11_3)
	end
end

function InteractionHelper.choose_player_interaction(arg_12_0, arg_12_1)
	if InteractionDefinitions.release_from_hook.client.can_interact(arg_12_0, arg_12_1) then
		return "release_from_hook"
	elseif InteractionDefinitions.revive.client.can_interact(arg_12_0, arg_12_1) then
		return "revive"
	elseif InteractionDefinitions.pull_up.client.can_interact(arg_12_0, arg_12_1) then
		return "pull_up"
	elseif InteractionDefinitions.assisted_respawn.client.can_interact(arg_12_0, arg_12_1) then
		return "assisted_respawn"
	elseif InteractionDefinitions.heal.client.can_interact(arg_12_0, arg_12_1) then
		return "heal"
	elseif InteractionDefinitions.give_item.client.can_interact(arg_12_0, arg_12_1) then
		return "give_item"
	else
		return nil
	end
end

function InteractionHelper.player_modify_interaction_type(arg_13_0, arg_13_1, arg_13_2)
	if arg_13_2 == "player_generic" then
		local var_13_0 = InteractionHelper.choose_player_interaction(arg_13_0, arg_13_1)

		if var_13_0 then
			return var_13_0
		end
	end

	return arg_13_2
end

function InteractionHelper.interaction_action_names(arg_14_0, arg_14_1)
	local var_14_0 = ScriptUnit.has_extension(arg_14_1, "interactable_system")

	if var_14_0 then
		local var_14_1 = var_14_0:override_interactable_action()

		if var_14_1 then
			return var_14_1
		end
	end

	local var_14_2 = ScriptUnit.has_extension(arg_14_0, "career_system")

	if var_14_2 then
		local var_14_3 = SPProfiles[var_14_2:profile_index()]

		if var_14_3 and var_14_3.affiliation == "dark_pact" then
			return "dark_pact_interact", "dark_pact_interacting"
		end
	end

	return "interact", "interacting"
end
