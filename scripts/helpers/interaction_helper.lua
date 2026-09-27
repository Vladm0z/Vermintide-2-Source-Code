-- chunkname: @scripts/helpers/interaction_helper.lua

local script_data = script_data
local debug_interactions = script_data.debug_interactions

debug_interactions = debug_interactions or Development.parameter("debug_interactions")
script_data.debug_interactions = debug_interactions

local InteractionHelper = InteractionHelper

InteractionHelper = InteractionHelper or {}
InteractionHelper = InteractionHelper
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

DLCUtils.map_list("interactions", function (arg_1_0)
	-- function 1
	InteractionHelper.interactions[arg_1_0] = {}
end)

for k, v in pairs(InteractionHelper.interactions) do
	local request_rpc = v.request_rpc

	request_rpc = request_rpc or "rpc_generic_interaction_request"
	v.request_rpc = request_rpc
end

InteractionHelper.printf = function (...)
	-- function 2
	if not script_data.debug_interactions then
		printf(...)
	end
end

local str = "IS_LOCAL_HOST"

InteractionHelper.request = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
	-- function 3
	if not LEVEL_EDITOR_TEST then
		return
	end

	if not arg_3_5 then
		InteractionHelper:request_approved(arg_3_1, arg_3_2, arg_3_3)

		return
	end

	local go_id = Managers.state.unit_storage:go_id(arg_3_2)
	local game_object_or_level_id, var_3_2 = Managers.state.network:game_object_or_level_id(arg_3_3)

	InteractionHelper.printf("InteractionHelper:request(%s, %s, %s, %s)", arg_3_1, go_id, game_object_or_level_id, var_3_2)

	if not (go_id == nil or game_object_or_level_id ~= nil) then
		InteractionHelper:request_denied(arg_3_2)

		return
	end

	local request_rpc = InteractionHelper.interactions[arg_3_1].request_rpc
	local var_3_4 = NetworkLookup.interactions[arg_3_1]
	local network = Managers.state.network

	if request_rpc == "rpc_generic_interaction_request" then
		if not arg_3_4 then
			network._event_delegate.event_table[request_rpc](Managers.state.network, str, go_id, game_object_or_level_id, var_3_2, var_3_4)
		else
			network.network_transmit:send_rpc_server(request_rpc, go_id, game_object_or_level_id, var_3_2, var_3_4)
		end
	elseif not arg_3_4 then
		network._event_delegate.event_table[request_rpc](Managers.state.network, str, go_id, game_object_or_level_id, var_3_2)
	else
		network.network_transmit:send_rpc_server(request_rpc, go_id, game_object_or_level_id, var_3_2)
	end
end

InteractionHelper.abort_authoritative = function (arg_4_0, arg_4_1)
	-- function 4
	local has_extension = ScriptUnit.has_extension(arg_4_1, "interactor_system")

	if not has_extension and not has_extension:is_interacting() and not has_extension:is_stopping() then
		InteractionHelper.printf("Got abort when interaction had already finished, ignore request")

		return
	end

	local interactable_unit = has_extension:interactable_unit()

	if not Unit.alive(interactable_unit) then
		InteractionHelper:complete_interaction(arg_4_1, interactable_unit, InteractionResult.USER_ENDED)
	end
end

InteractionHelper.abort = function (arg_5_0, arg_5_1, arg_5_2)
	-- function 5
	InteractionHelper.printf("InteractionHelper:abort(%s)", arg_5_1)

	if not ScriptUnit.extension(arg_5_1, "interactor_system"):is_interacting_with_local_only_interact() then
		InteractionHelper:abort_authoritative(arg_5_1)

		return
	end

	if not Managers.state.network:game() then
		return
	end

	local go_id = Managers.state.unit_storage:go_id(arg_5_1)

	if not go_id then
		return
	end

	if arg_5_2 or not LEVEL_EDITOR_TEST then
		Managers.state.network._event_delegate.event_table:rpc_interaction_abort(Network.peer_id(), go_id)
	else
		Managers.state.network.network_transmit:send_rpc_server("rpc_interaction_abort", go_id)
	end
end

InteractionHelper.approve_request = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	-- function 6
	InteractionHelper.printf("InteractionHelper:approve_request(%s, %s, %s)", arg_6_1, tostring(arg_6_2), tostring(arg_6_3))

	if not LEVEL_EDITOR_TEST then
		return
	end

	ScriptUnit.extension(arg_6_3, "interactable_system"):set_is_being_interacted_with(arg_6_2)

	local var_6_0 = NetworkLookup.interactions[arg_6_1]
	local go_id = Managers.state.unit_storage:go_id(arg_6_2)
	local game_object_or_level_id, var_6_3 = Managers.state.network:game_object_or_level_id(arg_6_3)

	Managers.state.network.network_transmit:send_rpc_clients("rpc_interaction_approved", var_6_0, go_id, game_object_or_level_id, var_6_3)
end

InteractionHelper.deny_request = function (arg_7_0, arg_7_1, arg_7_2)
	-- function 7
	InteractionHelper.printf("InteractionHelper:deny_request(%s, %s)", tostring(arg_7_1), tostring(arg_7_2))

	if Network.peer_id() == arg_7_1 then
		local unit = Managers.state.unit_storage:unit(arg_7_2)

		InteractionHelper:request_denied(unit)
	else
		local var_7_1 = PEER_ID_TO_CHANNEL[arg_7_1]

		RPC.rpc_interaction_denied(var_7_1, arg_7_2)
	end
end

InteractionHelper.request_approved = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	-- function 8
	InteractionHelper.printf("InteractionHelper:request_approved(%s, %s, %s)", arg_8_1, tostring(arg_8_2), tostring(arg_8_3))
	ScriptUnit.extension(arg_8_2, "interactor_system"):interaction_approved(arg_8_1, arg_8_3)
	ScriptUnit.extension(arg_8_3, "interactable_system"):set_is_being_interacted_with(arg_8_2)
end

InteractionHelper.request_denied = function (arg_9_0, arg_9_1)
	-- function 9
	InteractionHelper.printf("InteractionHelper:request_denied(%s)", tostring(arg_9_1))
	ScriptUnit.extension(arg_9_1, "interactor_system"):interaction_denied()
end

InteractionHelper.complete_interaction = function (arg_10_0, arg_10_1, arg_10_2, arg_10_3)
	-- function 10
	InteractionHelper.printf("InteractionHelper:complete_interaction(%s, %s, %s)", tostring(arg_10_1), tostring(arg_10_2), InteractionResult[arg_10_3])
	InteractionHelper:interaction_completed(arg_10_1, arg_10_2, arg_10_3)

	if not ScriptUnit.extension(arg_10_2, "interactable_system"):local_only() then
		local go_id = Managers.state.unit_storage:go_id(arg_10_1)

		if not go_id then
			Managers.state.network.network_transmit:send_rpc_clients("rpc_interaction_completed", go_id, arg_10_3)
		end
	end
end

InteractionHelper.interaction_completed = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3)
	-- function 11
	InteractionHelper.printf("InteractionHelper:interaction_completed(%s, %s, %s)", tostring(arg_11_1), tostring(arg_11_2), InteractionResult[arg_11_3])

	local has_extension = ScriptUnit.has_extension(arg_11_1, "interactor_system")

	if not has_extension then
		has_extension:interaction_completed(arg_11_3)
	end

	if not Unit.alive(arg_11_2) then
		ScriptUnit.extension(arg_11_2, "interactable_system"):set_is_being_interacted_with(nil, arg_11_3)
	end
end

InteractionHelper.choose_player_interaction = function (arg_12_0, arg_12_1)
	-- function 12
	if not InteractionDefinitions.release_from_hook.client.can_interact(arg_12_0, arg_12_1) then
		return "release_from_hook"
	elseif not InteractionDefinitions.revive.client.can_interact(arg_12_0, arg_12_1) then
		return "revive"
	elseif not InteractionDefinitions.pull_up.client.can_interact(arg_12_0, arg_12_1) then
		return "pull_up"
	elseif not InteractionDefinitions.assisted_respawn.client.can_interact(arg_12_0, arg_12_1) then
		return "assisted_respawn"
	elseif not InteractionDefinitions.heal.client.can_interact(arg_12_0, arg_12_1) then
		return "heal"
	elseif not InteractionDefinitions.give_item.client.can_interact(arg_12_0, arg_12_1) then
		return "give_item"
	else
		return nil
	end
end

InteractionHelper.player_modify_interaction_type = function (arg_13_0, arg_13_1, arg_13_2)
	-- function 13
	if arg_13_2 == "player_generic" then
		local choose_player_interaction = InteractionHelper.choose_player_interaction(arg_13_0, arg_13_1)

		if not choose_player_interaction then
			return choose_player_interaction
		end
	end

	return arg_13_2
end

InteractionHelper.interaction_action_names = function (arg_14_0, arg_14_1)
	-- function 14
	local has_extension = ScriptUnit.has_extension(arg_14_1, "interactable_system")

	if not has_extension then
		local override_interactable_action = has_extension:override_interactable_action()

		if not override_interactable_action then
			return override_interactable_action
		end
	end

	local has_extension_2 = ScriptUnit.has_extension(arg_14_0, "career_system")

	if not has_extension_2 then
		local var_14_3 = SPProfiles[has_extension_2:profile_index()]

		if not (not var_14_3 and var_14_3.affiliation ~= "dark_pact") then
			return "dark_pact_interact", "dark_pact_interacting"
		end
	end

	return "interact", "interacting"
end
