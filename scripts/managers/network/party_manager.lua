-- chunkname: @scripts/managers/network/party_manager.lua

require("scripts/helpers/player_utils")

PartyManager = class(PartyManager)

local var_0_0 = {
	"rpc_request_join_party",
	"rpc_reset_party_data",
	"rpc_peer_assigned_to_party",
	"rpc_remove_peer_from_party",
	"rpc_set_client_friend_party",
	"rpc_sync_friend_party_ids"
}

local function var_0_1(arg_1_0, ...)
	printf("[PartyManager] " .. arg_1_0, ...)
end

PartyManager.init = function (arg_2_0)
	arg_2_0._leader = nil
	arg_2_0._hot_join_synced_peers = {}

	arg_2_0:clear_parties()

	arg_2_0._friend_party_lookup = {}

	if DEDICATED_SERVER then
		arg_2_0:server_init_friend_parties(false)
	else
		arg_2_0._client_friend_party = {}
	end
end

PartyManager.destroy = function (arg_3_0)
	if arg_3_0._gui then
		local var_3_0 = Application.debug_world()

		World.destroy_gui(var_3_0, arg_3_0._gui)

		arg_3_0._gui = nil
	end
end

PartyManager._free_lobby = function (arg_4_0)
	if arg_4_0._party_lobby_or_data ~= nil then
		var_0_1("Party lobby has been freed")

		if type(arg_4_0._party_lobby_or_data) == "userdata" then
			LobbyInternal.leave_lobby(arg_4_0._party_lobby_or_data)
		end

		arg_4_0._party_lobby_or_data = nil
	end
end

PartyManager.reset = function ()
	var_0_1("reset")

	if Managers.party then
		Managers.party:destroy()
	end

	Managers.party = PartyManager:new()
end

PartyManager.set_leader = function (arg_6_0, arg_6_1)
	if arg_6_1 == nil then
		var_0_1("Cleared leader")
	else
		var_0_1("Leader set to %q", arg_6_1)
	end

	arg_6_0._leader = arg_6_1
end

PartyManager.leader = function (arg_7_0)
	return arg_7_0._leader
end

PartyManager.is_leader = function (arg_8_0, arg_8_1)
	return arg_8_1 == arg_8_0._leader
end

PartyManager.has_party_lobby = function (arg_9_0)
	return arg_9_0._party_lobby_or_data ~= nil
end

PartyManager.store_lobby = function (arg_10_0, arg_10_1)
	var_0_1("Party lobby has been stored '%s'", arg_10_1)
	arg_10_0:_free_lobby()

	arg_10_0._party_lobby_or_data = arg_10_1
end

PartyManager.steal_lobby = function (arg_11_0)
	var_0_1("Party lobby has been stolen!")

	local var_11_0 = arg_11_0._party_lobby_or_data

	arg_11_0._party_lobby_or_data = nil

	return var_11_0
end

PartyManager.clear_parties = function (arg_12_0, arg_12_1)
	var_0_1("Clear parties. sync_to_clients: %q", arg_12_1)

	arg_12_0._player_statuses = {}
	arg_12_0._parties = {}
	arg_12_0._game_participating_parties = {}
	arg_12_0._party_by_name = {}
	arg_12_0._num_parties = 0
	arg_12_0._num_game_participating_parties = 0
	arg_12_0._undecided_party = arg_12_0:create_party(arg_12_0:generate_undecided_party())
	arg_12_0._parties[0] = arg_12_0._undecided_party
	arg_12_0._cleared = true

	if arg_12_1 then
		arg_12_0:_send_rpc_to_clients("rpc_reset_party_data")
	end
end

PartyManager.generate_undecided_party = function (arg_13_0)
	return {
		party_id = 0,
		name = "undecided",
		num_open_slots = 0,
		game_participating = false,
		num_slots = 16,
		tags = {}
	}
end

PartyManager.gather_party_members = function (arg_14_0, arg_14_1)
	local var_14_0 = {}
	local var_14_1

	if arg_14_1 then
		var_14_1 = arg_14_0:get_party(arg_14_1)
	else
		var_14_1 = arg_14_0:get_local_player_party()
	end

	if not var_14_1 then
		return var_14_0
	end

	local var_14_2 = var_14_1.occupied_slots

	for iter_14_0, iter_14_1 in ipairs(var_14_2) do
		var_14_0[#var_14_0 + 1] = {
			peer_id = iter_14_1.peer_id,
			local_player_id = iter_14_1.local_player_id
		}
	end

	return var_14_0
end

PartyManager.create_party = function (arg_15_0, arg_15_1)
	var_0_1("Register party. party_id: %q | name: %q | num_slots: %q", arg_15_1.party_id, arg_15_1.name, arg_15_1.num_slots)

	local var_15_0 = arg_15_1.num_slots
	local var_15_1 = {}
	local var_15_2 = {}

	for iter_15_0 = 1, var_15_0 do
		var_15_1[iter_15_0] = {
			game_mode_data = {}
		}
		var_15_2[iter_15_0] = {
			slot_id = iter_15_0
		}
	end

	return {
		num_bots = 0,
		num_used_slots = 0,
		party_id = arg_15_1.party_id,
		name = arg_15_1.name,
		game_participating = arg_15_1.game_participating == nil and true or arg_15_1.game_participating,
		num_open_slots = var_15_0,
		num_slots = var_15_0,
		slots = var_15_1,
		occupied_slots = {},
		bot_add_order = {},
		slots_data = var_15_2
	}
end

PartyManager.max_party_members = function (arg_16_0, arg_16_1)
	local var_16_0 = 0

	for iter_16_0, iter_16_1 in pairs(arg_16_1) do
		local var_16_1 = iter_16_1.num_slots

		if iter_16_1.game_participating ~= false and var_16_0 < var_16_1 then
			var_16_0 = var_16_1
		end
	end

	return var_16_0
end

PartyManager.register_parties = function (arg_17_0, arg_17_1)
	var_0_1("Register parties")

	for iter_17_0, iter_17_1 in pairs(arg_17_1) do
		local var_17_0 = iter_17_1.party_id

		fassert(var_17_0 ~= 0, "This party id is reserved for undecided party.")

		local var_17_1 = arg_17_0:create_party(iter_17_1)

		arg_17_0._parties[var_17_0] = var_17_1
		arg_17_0._party_by_name[iter_17_0] = var_17_1
		arg_17_0._num_parties = arg_17_0._num_parties + 1

		if var_17_1.game_participating then
			arg_17_0._num_game_participating_parties = arg_17_0._num_game_participating_parties + 1
			arg_17_0._game_participating_parties[var_17_0] = var_17_1
		end
	end

	local var_17_2 = true

	for iter_17_2 = 1, arg_17_0._num_parties do
		if arg_17_0._parties[iter_17_2].game_participating then
			assert(var_17_2, "Game participating parties may not be separated by non participating ones.")
		else
			var_17_2 = false
		end
	end

	arg_17_0._cleared = false
end

PartyManager.cleared = function (arg_18_0)
	return arg_18_0._cleared
end

PartyManager._create_player_status = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3)
	local var_19_0 = PlayerUtils.unique_player_id(arg_19_1, arg_19_2)
	local var_19_1 = arg_19_0._player_statuses
	local var_19_2 = {
		score = 0,
		peer_id = arg_19_1,
		local_player_id = arg_19_2,
		unique_id = var_19_0,
		is_bot = arg_19_3,
		is_player = not arg_19_3,
		game_mode_data = {}
	}

	fassert(not var_19_1[var_19_0], "Player already connected peer_id=%s local_player_id%s", arg_19_1, arg_19_2)

	var_19_1[var_19_0] = var_19_2

	return var_19_2
end

PartyManager.register_player = function (arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = arg_20_0._player_statuses[arg_20_2]

	if not var_20_0 then
		local var_20_1 = arg_20_1:network_id()
		local var_20_2 = arg_20_1:local_player_id()

		var_20_0 = arg_20_0:_create_player_status(var_20_1, var_20_2, false)
	end

	var_20_0.player = arg_20_1
end

PartyManager.set_selected_profile = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	local var_21_0 = arg_21_0:get_player_status(arg_21_1, arg_21_2)

	var_21_0.selected_profile_index = arg_21_3
	var_21_0.selected_career_index = arg_21_4
	var_21_0.profile_index = arg_21_3
	var_21_0.career_index = arg_21_4
end

PartyManager.cleanup_game_mode_data = function (arg_22_0)
	for iter_22_0, iter_22_1 in pairs(arg_22_0._player_statuses) do
		iter_22_1.game_mode_data = {}
	end
end

PartyManager.register_rpcs = function (arg_23_0, arg_23_1)
	arg_23_0._network_event_delegate = arg_23_1

	arg_23_1:register(arg_23_0, unpack(var_0_0))
end

PartyManager.unregister_rpcs = function (arg_24_0)
	arg_24_0._network_event_delegate:unregister(arg_24_0)

	arg_24_0._network_event_delegate = nil
end

PartyManager.update = function (arg_25_0, arg_25_1, arg_25_2)
	return
end

PartyManager.get_local_player_party = function (arg_26_0)
	local var_26_0 = Managers.player:local_player()

	if var_26_0 then
		return arg_26_0:get_party_from_unique_id(var_26_0:unique_id())
	end
end

PartyManager.get_party = function (arg_27_0, arg_27_1)
	return arg_27_0._parties[arg_27_1]
end

PartyManager.parties = function (arg_28_0)
	return arg_28_0._parties
end

PartyManager.game_participating_parties = function (arg_29_0)
	return arg_29_0._game_participating_parties
end

PartyManager.is_game_participating_party = function (arg_30_0, arg_30_1)
	return arg_30_0._game_participating_parties[arg_30_1] ~= nil
end

PartyManager.get_party_composition = function (arg_31_0)
	local var_31_0 = {}

	for iter_31_0, iter_31_1 in ipairs(arg_31_0._parties) do
		local var_31_1 = iter_31_1.occupied_slots

		for iter_31_2, iter_31_3 in ipairs(var_31_1) do
			var_31_0[iter_31_3.unique_id] = iter_31_1.party_id
		end
	end

	return var_31_0
end

PartyManager._slot_empty_in_party = function (arg_32_0, arg_32_1, arg_32_2)
	return arg_32_0._parties[arg_32_1].slots[arg_32_2].peer_id == nil
end

PartyManager.request_join_party = function (arg_33_0, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	if arg_33_0._is_server then
		local var_33_0 = arg_33_0._parties[arg_33_3]
		local var_33_1 = true

		if arg_33_4 then
			var_33_1 = arg_33_0:_slot_empty_in_party(arg_33_3, arg_33_4)
		end

		if var_33_1 then
			local var_33_2 = Managers.mechanism:preferred_slot_id(arg_33_3, arg_33_1, arg_33_2)

			if var_33_2 then
				if arg_33_0:is_slot_bot(var_33_0, var_33_2) then
					local var_33_3, var_33_4 = arg_33_0:slot_peer_id(var_33_0, var_33_2)
					local var_33_5 = Managers.party:get_player_status(var_33_3, var_33_4)

					arg_33_0:remove_peer_from_party(var_33_5.peer_id, var_33_5.local_player_id, var_33_5.party_id)

					arg_33_4 = var_33_2
				elseif arg_33_0:is_slot_empty(var_33_0, var_33_2) then
					arg_33_4 = var_33_2
				end
			end

			local var_33_6 = false

			if var_33_0.num_used_slots < var_33_0.num_slots then
				arg_33_0:assign_peer_to_party(arg_33_1, arg_33_2, arg_33_3, arg_33_4, var_33_6)
			elseif var_33_0.num_bots > 0 then
				local var_33_7

				if arg_33_5 then
					local var_33_8 = arg_33_5:network_id()
					local var_33_9 = arg_33_5:local_player_id()

					var_33_7 = Managers.party:get_player_status(var_33_8, var_33_9)
				else
					var_33_7 = arg_33_0:get_last_added_bot_for_party(arg_33_3)
				end

				arg_33_0:remove_peer_from_party(var_33_7.peer_id, var_33_7.local_player_id, var_33_7.party_id)
				arg_33_0:assign_peer_to_party(arg_33_1, arg_33_2, arg_33_3, arg_33_4, var_33_6)
			end
		end
	else
		var_0_1("Sending request join party")

		arg_33_4 = arg_33_4 or NetworkConstants.INVALID_PARTY_SLOT_ID

		local var_33_10 = PEER_ID_TO_CHANNEL[arg_33_0._server_peer_id]

		RPC.rpc_request_join_party(var_33_10, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	end
end

PartyManager.get_player_status = function (arg_34_0, arg_34_1, arg_34_2)
	local var_34_0 = PlayerUtils.unique_player_id(arg_34_1, arg_34_2)

	return arg_34_0._player_statuses[var_34_0]
end

PartyManager.get_status_from_unique_id = function (arg_35_0, arg_35_1)
	return arg_35_0._player_statuses[arg_35_1]
end

PartyManager.get_party_from_player_id = function (arg_36_0, arg_36_1, arg_36_2)
	local var_36_0 = PlayerUtils.unique_player_id(arg_36_1, arg_36_2)
	local var_36_1 = arg_36_0._player_statuses[var_36_0]

	if var_36_1 then
		local var_36_2 = var_36_1.party_id

		return arg_36_0._parties[var_36_2], var_36_2
	end
end

PartyManager.get_party_from_unique_id = function (arg_37_0, arg_37_1)
	local var_37_0 = arg_37_0._player_statuses[arg_37_1]

	if var_37_0 then
		local var_37_1 = var_37_0.party_id

		return arg_37_0._parties[var_37_1], var_37_1
	end
end

PartyManager.get_party_from_name = function (arg_38_0, arg_38_1)
	local var_38_0 = arg_38_0._parties

	for iter_38_0 = 0, #var_38_0 do
		local var_38_1 = var_38_0[iter_38_0]

		if var_38_1.name == arg_38_1 then
			return var_38_1
		end
	end
end

function update_status_profile_index(arg_39_0)
	local var_39_0 = Managers.state

	if not var_39_0 then
		return
	end

	local var_39_1 = var_39_0.network

	if not var_39_1 then
		return
	end

	local var_39_2 = var_39_1.profile_synchronizer

	if not var_39_2 then
		return
	end

	local var_39_3, var_39_4 = var_39_2:profile_by_peer(arg_39_0.peer_id, arg_39_0.local_player_id)

	arg_39_0.profile_index = var_39_3
	arg_39_0.career_index = var_39_4
	arg_39_0.profile_id = var_39_3 and SPProfiles[var_39_3].display_name
end

PartyManager.get_num_parties = function (arg_40_0)
	return arg_40_0._num_parties
end

PartyManager.get_num_game_participating_parties = function (arg_41_0)
	return arg_41_0._num_game_participating_parties
end

PartyManager.is_game_participating = function (arg_42_0, arg_42_1)
	return arg_42_0._parties[arg_42_1].game_participating
end

PartyManager.assign_peer_to_party = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	arg_43_5 = not not arg_43_5

	local var_43_0 = PlayerUtils.unique_player_id(arg_43_1, arg_43_2)
	local var_43_1 = true
	local var_43_2 = arg_43_0._player_statuses[var_43_0]

	if not var_43_2 then
		var_43_2 = arg_43_0:_create_player_status(arg_43_1, arg_43_2, arg_43_5)
		var_43_1 = false
	end

	local var_43_3

	if var_43_1 and var_43_2.party_id then
		var_43_3 = var_43_2.party_id

		local var_43_4 = arg_43_0._parties[var_43_3]
		local var_43_5 = var_43_2.slot_id
		local var_43_6 = var_43_2.is_bot

		arg_43_0:_clear_slot_in_party(var_43_4, var_43_5, var_43_6)
	end

	update_status_profile_index(var_43_2)

	local var_43_7 = arg_43_3 and arg_43_0._parties[arg_43_3] or arg_43_0._undecided_party
	local var_43_8 = arg_43_3 or 0

	var_0_1("Player (%s:%d) was put into party %s (%d)", arg_43_1, arg_43_2, var_43_7.name, var_43_8)

	local var_43_9 = arg_43_4 or arg_43_0:find_first_empty_slot_id(var_43_7)

	if PartyManager._find_slot_index(var_43_7, var_43_9) then
		var_43_9 = nil
	end

	var_43_7.slots[var_43_9] = var_43_2
	var_43_7.occupied_slots[#var_43_7.occupied_slots + 1] = var_43_2
	var_43_2.party_id = var_43_8
	var_43_2.slot_id = var_43_9
	var_43_7.num_used_slots = var_43_7.num_used_slots + 1
	var_43_7.num_open_slots = var_43_7.num_slots - var_43_7.num_used_slots

	if arg_43_5 then
		var_43_7.num_bots = var_43_7.num_bots + 1
		var_43_7.bot_add_order[var_43_7.num_bots] = var_43_9
	end

	if arg_43_0._is_server then
		var_0_1("Sending 'rpc_peer_assigned_to_party'")
		arg_43_0:_send_rpc_to_clients("rpc_peer_assigned_to_party", arg_43_1, arg_43_2, var_43_8, var_43_9, arg_43_5)
	end

	local var_43_10 = Managers.player:player(arg_43_1, arg_43_2)
	local var_43_11 = var_43_10 and var_43_10.local_player

	if Managers.state.event then
		Managers.state.event:trigger("player_party_changed", var_43_10, var_43_11, var_43_3, var_43_8)
	end

	if Managers.state.game_mode then
		Managers.state.game_mode:player_joined_party(arg_43_1, arg_43_2, var_43_8, var_43_9, var_43_3)
	end

	if Managers.state.event then
		Managers.state.event:trigger("on_player_joined_party", arg_43_1, arg_43_2, var_43_8, var_43_9, arg_43_5)
	end

	if Managers.venture.challenge then
		Managers.venture.challenge:on_player_joined_party(arg_43_1, arg_43_2, var_43_8, var_43_9, arg_43_5)
	end

	Managers.mechanism:player_joined_party(arg_43_1, arg_43_2, var_43_8, var_43_9, arg_43_5)

	return var_43_2
end

PartyManager.remove_peer_from_party = function (arg_44_0, arg_44_1, arg_44_2, arg_44_3)
	local var_44_0 = arg_44_0:get_player_status(arg_44_1, arg_44_2)

	if not var_44_0 then
		return
	end

	local var_44_1 = arg_44_0._parties[arg_44_3]
	local var_44_2 = var_44_0.slot_id
	local var_44_3 = var_44_1.slots[var_44_2]

	if arg_44_0._is_server then
		arg_44_0:_send_rpc_to_clients("rpc_remove_peer_from_party", arg_44_1, arg_44_2, arg_44_3)
	end

	arg_44_0:_clear_slot_in_party(var_44_1, var_44_0.slot_id, var_44_0.is_bot)

	if Managers.state.game_mode then
		Managers.state.game_mode:player_left_party(arg_44_1, arg_44_2, arg_44_3, var_44_2, var_44_3)
	end

	if Managers.state.event then
		Managers.state.event:trigger("on_player_left_party", arg_44_1, arg_44_2, arg_44_3, var_44_2)
	end

	if Managers.venture.challenge then
		local var_44_4 = var_44_0.is_bot

		Managers.venture.challenge:on_player_left_party(arg_44_1, arg_44_2, arg_44_3, var_44_2, var_44_4)
	end

	if not DEDICATED_SERVER then
		Managers.account:update_presence()
	end

	var_44_0.party_id = nil
	var_44_0.slot_id = nil
end

local var_0_2 = {}

PartyManager.get_players_in_party = function (arg_45_0, arg_45_1)
	table.clear(var_0_2)

	local var_45_0 = 0

	for iter_45_0, iter_45_1 in pairs(arg_45_0._player_statuses) do
		if iter_45_1.party_id == arg_45_1 then
			var_45_0 = var_45_0 + 1
			var_0_2[var_45_0] = iter_45_1
		end
	end

	return var_0_2, var_45_0
end

PartyManager._find_slot_index = function (arg_46_0, arg_46_1)
	local var_46_0
	local var_46_1 = arg_46_0.occupied_slots

	for iter_46_0 = 1, #var_46_1 do
		if var_46_1[iter_46_0].slot_id == arg_46_1 then
			var_46_0 = iter_46_0

			break
		end
	end

	return var_46_0
end

PartyManager._clear_slot_in_party = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	arg_47_1.slots[arg_47_2] = {}

	local var_47_0 = PartyManager._find_slot_index(arg_47_1, arg_47_2)

	fassert(var_47_0 ~= nil, "could not find player status in occupied_slots")

	local var_47_1 = arg_47_1.occupied_slots
	local var_47_2 = arg_47_1.num_used_slots

	var_47_1[var_47_0] = var_47_1[var_47_2]
	var_47_1[var_47_2] = nil
	arg_47_1.num_used_slots = var_47_2 - 1
	arg_47_1.num_open_slots = arg_47_1.num_slots - arg_47_1.num_used_slots

	if arg_47_3 then
		arg_47_1.num_bots = arg_47_1.num_bots - 1

		local var_47_3 = table.find(arg_47_1.bot_add_order, arg_47_2)

		table.remove(arg_47_1.bot_add_order, var_47_3)
	end
end

PartyManager.is_slot_empty = function (arg_48_0, arg_48_1, arg_48_2)
	local var_48_0 = arg_48_1.slots

	return var_48_0[arg_48_2] == nil or var_48_0[arg_48_2].peer_id == nil
end

PartyManager.is_slot_bot = function (arg_49_0, arg_49_1, arg_49_2)
	local var_49_0 = arg_49_1.slots[arg_49_2]

	return var_49_0 and var_49_0.is_bot
end

PartyManager.slot_peer_id = function (arg_50_0, arg_50_1, arg_50_2)
	local var_50_0 = arg_50_1.slots[arg_50_2]

	if var_50_0 then
		return var_50_0.peer_id, var_50_0.local_player_id
	end

	return nil, nil
end

PartyManager.find_first_empty_slot_id = function (arg_51_0, arg_51_1)
	local var_51_0 = arg_51_1.num_slots

	for iter_51_0 = 1, var_51_0 do
		if arg_51_0:is_slot_empty(arg_51_1, iter_51_0) then
			return iter_51_0
		end
	end

	ferror("No empty slot in party %s", arg_51_1.name)
end

PartyManager.get_least_filled_party = function (arg_52_0, arg_52_1, arg_52_2)
	local var_52_0 = arg_52_0._parties

	fassert(#var_52_0 > 1, "parties has not been initialized yet")

	local var_52_1 = 0
	local var_52_2 = math.huge

	for iter_52_0 = 1, #var_52_0 do
		local var_52_3 = var_52_0[iter_52_0]

		if not arg_52_2 or var_52_3.game_participating then
			local var_52_4 = var_52_3.num_used_slots

			if arg_52_1 then
				var_52_4 = var_52_4 - var_52_3.num_bots
			end

			if var_52_4 < var_52_2 then
				var_52_1 = iter_52_0
				var_52_2 = var_52_4
			end
		end
	end

	return var_52_0[var_52_1], var_52_1
end

PartyManager.is_party_full = function (arg_53_0, arg_53_1)
	local var_53_0 = arg_53_0._parties[arg_53_1]

	return var_53_0.num_open_slots + var_53_0.num_bots == 0
end

PartyManager.is_player_in_party = function (arg_54_0, arg_54_1, arg_54_2)
	local var_54_0 = arg_54_0._parties[arg_54_2]

	return arg_54_2 == arg_54_0._player_statuses[arg_54_1].party_id
end

PartyManager.get_last_added_bot_for_party = function (arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0._parties[arg_55_1]
	local var_55_1 = var_55_0.bot_add_order[var_55_0.num_bots]

	return var_55_0.slots[var_55_1]
end

PartyManager.hot_join_sync = function (arg_56_0, arg_56_1)
	local var_56_0 = arg_56_0._parties
	local var_56_1 = PEER_ID_TO_CHANNEL[arg_56_1]

	for iter_56_0 = 0, #var_56_0 do
		local var_56_2 = var_56_0[iter_56_0].occupied_slots

		for iter_56_1 = 1, #var_56_2 do
			local var_56_3 = var_56_2[iter_56_1]
			local var_56_4 = var_56_3.peer_id
			local var_56_5 = var_56_3.local_player_id
			local var_56_6 = var_56_3.is_bot
			local var_56_7 = var_56_3.slot_id

			RPC.rpc_peer_assigned_to_party(var_56_1, var_56_4, var_56_5, iter_56_0, var_56_7, var_56_6)
		end
	end
end

PartyManager._send_rpc_to_clients = function (arg_57_0, arg_57_1, ...)
	local var_57_0 = RPC[arg_57_1]
	local var_57_1 = arg_57_0._server_peer_id

	for iter_57_0, iter_57_1 in pairs(arg_57_0._hot_join_synced_peers) do
		if iter_57_0 ~= var_57_1 and iter_57_1 then
			local var_57_2 = PEER_ID_TO_CHANNEL[iter_57_0]

			var_57_0(var_57_2, ...)
		end
	end
end

PartyManager.network_context_created = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3)
	var_0_1("network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_58_2, arg_58_3)

	arg_58_0._lobby = arg_58_1
	arg_58_0._server_peer_id = arg_58_2
	arg_58_0._peer_id = arg_58_3
	arg_58_0._is_server = arg_58_2 == arg_58_3
end

PartyManager.parties_by_name = function (arg_59_0)
	return arg_59_0._party_by_name
end

PartyManager.network_context_destroyed = function (arg_60_0)
	var_0_1("network_context_created")

	arg_60_0._lobby = nil
	arg_60_0._server_peer_id = nil
	arg_60_0._peer_id = nil
	arg_60_0._is_server = nil
	arg_60_0._hot_join_synced_peers = {}

	arg_60_0:clear_parties()
end

PartyManager.server_peer_hot_join_synced = function (arg_61_0, arg_61_1)
	arg_61_0._hot_join_synced_peers[arg_61_1] = true
end

PartyManager.server_peer_left_session = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3)
	arg_62_0._hot_join_synced_peers[arg_62_1] = false

	local var_62_0 = arg_62_0._parties

	for iter_62_0 = 0, #var_62_0 do
		local var_62_1 = var_62_0[iter_62_0]
		local var_62_2 = var_62_1.slots
		local var_62_3 = var_62_1.num_slots

		for iter_62_1 = 1, var_62_3 do
			local var_62_4 = var_62_2[iter_62_1]

			if var_62_4.peer_id == arg_62_1 then
				arg_62_0:remove_peer_from_party(var_62_4.peer_id, var_62_4.local_player_id, iter_62_0)
			end
		end
	end

	Managers.state.event:trigger("friend_party_peer_left", arg_62_1, arg_62_2, arg_62_3)
end

PartyManager.rpc_request_join_party = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5)
	printf("Recieved join party request from %s - %s party_id(%s)", arg_63_2, arg_63_3, arg_63_4)

	if arg_63_5 == NetworkConstants.INVALID_PARTY_SLOT_ID then
		arg_63_5 = nil
	end

	arg_63_0:request_join_party(arg_63_2, arg_63_3, arg_63_4, arg_63_5)
end

PartyManager.rpc_peer_assigned_to_party = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
	var_0_1("rpc_peer_assigned_to_party. channel_id: %q | peer_id: %q | local_player_id: %q | party_id: %q | slot_id: %q | is_bot: %q", arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
	arg_64_0:assign_peer_to_party(arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
end

PartyManager.rpc_remove_peer_from_party = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	var_0_1("rpc_remove_peer_from_party. channel_id: %q | peer_id: %q | local_player_id: %q | party_id: %q", arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	arg_65_0:remove_peer_from_party(arg_65_2, arg_65_3, arg_65_4)
end

PartyManager.rpc_set_client_friend_party = function (arg_66_0, arg_66_1, arg_66_2)
	arg_66_0:_client_set_friend_party(arg_66_2)
end

PartyManager.rpc_reset_party_data = function (arg_67_0)
	arg_67_0:clear_parties()
	Managers.mechanism:setup_mechanism_parties()
end

PartyManager._draw_debug = function (arg_68_0, arg_68_1)
	local var_68_0 = "materials/fonts/arial"
	local var_68_1 = "arial"
	local var_68_2 = 20
	local var_68_3 = 20
	local var_68_4 = 32
	local var_68_5 = 180
	local var_68_6 = 160
	local var_68_7 = 90
	local var_68_8 = 2 * var_68_4 + var_68_5 + var_68_6 + var_68_7
	local var_68_9 = Managers.player.is_server
	local var_68_10 = Color(128, 0, 0, 0)
	local var_68_11 = Color(255, 255, 255, 255)
	local var_68_12 = Color(255, 128, 255, 255)
	local var_68_13 = Color(255, 155, 155, 255)
	local var_68_14 = Color(255, 155, 255, 155)
	local var_68_15 = Color(255, 55, 155, 156)
	local var_68_16 = var_68_9 and Color(255, 255, 255, 0) or Color(255, 55, 126, 255)
	local var_68_17, var_68_18 = Gui.resolution()
	local var_68_19 = var_68_18 - var_68_4 - var_68_2
	local var_68_20 = var_68_17 - var_68_8

	if arg_68_0._gui == nil then
		local var_68_21 = Application.debug_world()

		arg_68_0._gui = World.create_screen_gui(var_68_21, "immediate", "material", "materials/fonts/gw_fonts")
	end

	Gui.rect(arg_68_0._gui, Vector2(var_68_20, 0), Vector2(var_68_8, var_68_18), var_68_10)

	local var_68_22 = var_68_9 and "(Server)" or "(Client)"

	Gui.text(arg_68_0._gui, var_68_22, var_68_0, var_68_2, var_68_1, Vector3(var_68_20 + var_68_8 - 80, var_68_19, 0), var_68_16)

	local var_68_23 = Managers.mechanism:current_mechanism_name()
	local var_68_24 = Managers.mechanism:game_mechanism():get_state()
	local var_68_25 = string.format("Mechanism:'%s', state:'%s'", var_68_23, var_68_24)

	Gui.text(arg_68_0._gui, var_68_25, var_68_0, var_68_2, var_68_1, Vector3(var_68_20 + var_68_4, var_68_19, 0), var_68_15)

	local var_68_26 = var_68_19 - var_68_3
	local var_68_27 = Managers.state.game_mode:game_mode()
	local var_68_28 = var_68_27 and var_68_27:settings().key or "none"
	local var_68_29 = Managers.mechanism:get_level_seed()
	local var_68_30 = string.format("Game mode: '%s', seed: %s", var_68_28, tostring(var_68_29))

	Gui.text(arg_68_0._gui, var_68_30, var_68_0, var_68_2, var_68_1, Vector3(var_68_20 + var_68_4, var_68_26, 0), var_68_14)

	local var_68_31 = var_68_26 - var_68_3
	local var_68_32 = string.format("    state: '%s' max: %s", var_68_27:game_mode_state(), LobbySetup._network_options.max_members)

	Gui.text(arg_68_0._gui, var_68_32, var_68_0, var_68_2, var_68_1, Vector3(var_68_20 + var_68_4, var_68_31, 0), var_68_14)

	local var_68_33 = var_68_31 - var_68_3 * 2
	local var_68_34 = Managers.mechanism:game_mechanism()

	if var_68_34.win_conditions then
		local var_68_35 = Managers.state.game_mode:game_mode()

		if var_68_35.round_id then
			local var_68_36 = var_68_34:win_conditions()
			local var_68_37 = var_68_34:get_current_set()
			local var_68_38 = var_68_34:num_sets()
			local var_68_39 = var_68_34:total_rounds_started()
			local var_68_40 = string.format("Set: %s/%s --> round: %d/2, round_id: %d", var_68_37, var_68_38, tostring(var_68_35:round_id() or -1), var_68_39)

			Gui.text(arg_68_0._gui, var_68_40, var_68_0, var_68_2, var_68_1, Vector3(var_68_20 + var_68_4, var_68_33, 0), var_68_14)

			var_68_33 = var_68_33 - var_68_3

			local var_68_41 = 14

			for iter_68_0 = 1, var_68_38 do
				var_68_33 = var_68_33 - var_68_41 / 2

				local var_68_42 = iter_68_0 == var_68_37 and "(current set)" or ""
				local var_68_43 = string.format("Set %s  %s", iter_68_0, var_68_42)

				Gui.text(arg_68_0._gui, var_68_43, var_68_0, var_68_41, var_68_1, Vector3(var_68_20 + var_68_4, var_68_33, 0), Color(255, 220, 200, 0))

				var_68_33 = var_68_33 - var_68_41 - 4

				for iter_68_1 = 1, 2 do
					local var_68_44 = var_68_36:set_data(iter_68_1)[iter_68_0]

					if var_68_44 then
						local var_68_45 = ""

						if var_68_44.distance_traveled > 0 then
							var_68_45 = string.format("dist: %.1f%%", var_68_44.distance_traveled * 100)
						end

						local var_68_46 = string.format("Party %s -> Score: %s/%s(%s) %s", iter_68_1, var_68_44.claimed_points, tostring(var_68_44.max_points), var_68_44.max_points - var_68_44.claimed_points, var_68_45)

						Gui.text(arg_68_0._gui, var_68_46, var_68_0, var_68_41, var_68_1, Vector3(var_68_20 + var_68_4, var_68_33, 0), var_68_14)
					end

					var_68_33 = var_68_33 - var_68_41 - 4
				end
			end

			var_68_33 = var_68_33 - var_68_41 - 4
		end
	end

	local var_68_47 = arg_68_0._parties

	for iter_68_2 = 0, #var_68_47 do
		local var_68_48 = var_68_47[iter_68_2]
		local var_68_49 = var_68_20 + var_68_4

		Gui.text(arg_68_0._gui, "Party " .. tostring(var_68_48.party_id), var_68_0, var_68_2, var_68_1, Vector3(var_68_49, var_68_33, 0), var_68_13)

		local var_68_50 = var_68_49 + var_68_5
		local var_68_51 = Managers.state.side.side_by_party[var_68_48]
		local var_68_52 = var_68_51 and var_68_51._num_units or 0
		local var_68_53 = var_68_51 and var_68_51._num_enemy_units or 0

		Gui.text(arg_68_0._gui, string.format("(%d/%d) units(%d) enemies(%d)", var_68_48.num_used_slots, var_68_48.num_slots, var_68_52, var_68_53), var_68_0, var_68_2, var_68_1, Vector3(var_68_50, var_68_33, 0), var_68_13)

		var_68_33 = var_68_33 - var_68_3

		local var_68_54 = var_68_20 + var_68_4

		Gui.text(arg_68_0._gui, "Peer", var_68_0, var_68_2, var_68_1, Vector3(var_68_54, var_68_33, 0), var_68_11)

		local var_68_55 = var_68_54 + var_68_5

		Gui.text(arg_68_0._gui, "State", var_68_0, var_68_2, var_68_1, Vector3(var_68_55, var_68_33, 0), var_68_11)

		local var_68_56 = var_68_55 + var_68_6

		Gui.text(arg_68_0._gui, "Info", var_68_0, var_68_2, var_68_1, Vector3(var_68_56, var_68_33, 0), var_68_11)

		var_68_33 = var_68_33 - 4

		Gui.rect(arg_68_0._gui, Vector2(var_68_20 + var_68_4, var_68_33), Vector2(var_68_5 + var_68_6 + var_68_7, 1), var_68_11)

		var_68_33 = var_68_33 - var_68_3

		local var_68_57 = var_68_48.occupied_slots

		for iter_68_3 = 1, #var_68_57 do
			local var_68_58 = var_68_57[iter_68_3]
			local var_68_59 = var_68_58.game_mode_data.spawn_state == "w8_to_spawn" and var_68_58.game_mode_data.spawn_timer and string.format("%.1f", var_68_58.game_mode_data.spawn_timer - arg_68_1) or ""
			local var_68_60 = string.format("%s %s", var_68_58.game_mode_data.spawn_state or "?", var_68_59)
			local var_68_61 = var_68_58.peer_id
			local var_68_62 = var_68_58.profile_id
			local var_68_63 = var_68_58.profile_index
			local var_68_64 = var_68_58.career_index
			local var_68_65 = string.format("P/C: %s-%s/%s", tostring(var_68_62), tostring(var_68_63), tostring(var_68_64))
			local var_68_66 = "-"
			local var_68_67 = "?"
			local var_68_68 = var_68_58.player

			if var_68_68 then
				var_68_67 = var_68_68:is_player_controlled() and "P" or "B"
				var_68_66 = "1"

				local var_68_69 = var_68_68.player_unit
				local var_68_70

				if var_68_69 then
					local var_68_71 = Unit.get_data(var_68_69, "breed")

					var_68_66 = var_68_71 and var_68_71.hit_zones_lookup ~= nil and "L" or "2"
				else
					var_68_66 = next(var_68_68.owned_units) and "P" or "?"
				end
			end

			local var_68_72 = var_68_67 .. var_68_66
			local var_68_73 = var_68_20 + var_68_4

			Gui.text(arg_68_0._gui, var_68_61, var_68_0, var_68_2, var_68_1, Vector3(var_68_73, var_68_33, 0), var_68_11)

			local var_68_74 = var_68_73 + var_68_5

			Gui.text(arg_68_0._gui, tostring(var_68_60), var_68_0, var_68_2, var_68_1, Vector3(var_68_74, var_68_33, 0), var_68_11)

			local var_68_75 = var_68_74 + var_68_6

			Gui.text(arg_68_0._gui, var_68_72, var_68_0, var_68_2, var_68_1, Vector3(var_68_75, var_68_33, 0), var_68_11)

			var_68_33 = var_68_33 - var_68_3

			local var_68_76 = var_68_20 + var_68_4

			Gui.text(arg_68_0._gui, tostring(var_68_65), var_68_0, var_68_2, var_68_1, Vector3(var_68_76, var_68_33, 0), var_68_12)

			var_68_33 = var_68_33 - var_68_3
		end

		var_68_33 = var_68_33 - var_68_3 * 2
	end
end

PartyManager.any_party_has_free_slots = function (arg_69_0, arg_69_1)
	arg_69_1 = arg_69_1 or 1

	local var_69_0 = arg_69_0._parties

	for iter_69_0 = 1, #var_69_0 do
		local var_69_1 = var_69_0[iter_69_0]

		if arg_69_1 <= var_69_1.num_open_slots + var_69_1.num_bots then
			return true
		end
	end

	return false
end

PartyManager.server_init_friend_parties = function (arg_70_0, arg_70_1)
	arg_70_0._is_hosting_vs_custom_game = true
	arg_70_0._friend_parties = {}
	arg_70_0._friend_party_lookup = {}
	arg_70_0._num_friend_party_ids = 0

	if arg_70_1 then
		local var_70_0 = Managers.player:local_player()
		local var_70_1 = var_70_0:get_party()
		local var_70_2 = {}

		for iter_70_0, iter_70_1 in pairs(var_70_1.slots) do
			if iter_70_1.peer_id then
				var_70_2[#var_70_2 + 1] = iter_70_1.peer_id
			end
		end

		arg_70_0:server_create_friend_party(var_70_2, var_70_0.peer_id)
	end
end

PartyManager.server_clear_friend_parties = function (arg_71_0)
	if arg_71_0._is_hosting_vs_custom_game then
		arg_71_0._is_hosting_vs_custom_game = nil
	end

	table.clear(arg_71_0._friend_parties)
	table.clear(arg_71_0._friend_party_lookup)
end

PartyManager.server_update_all_client_friend_parties = function (arg_72_0)
	for iter_72_0, iter_72_1 in pairs(arg_72_0._friend_parties) do
		arg_72_0:_server_set_client_friend_party(iter_72_0)
	end
end

PartyManager.server_create_friend_party = function (arg_73_0, arg_73_1, arg_73_2, arg_73_3)
	if arg_73_1[1] ~= arg_73_2 then
		for iter_73_0 = 1, #arg_73_1 do
			if arg_73_1[iter_73_0] == arg_73_2 then
				arg_73_1[iter_73_0] = arg_73_1[1]
				arg_73_1[1] = arg_73_2

				break
			end
		end
	end

	local var_73_0 = arg_73_3 or arg_73_0:_server_generate_friend_party_id()

	arg_73_0._friend_parties[var_73_0] = {
		leader = arg_73_2,
		peers = arg_73_1,
		num_peers = #arg_73_1
	}

	for iter_73_1 = 1, #arg_73_1 do
		arg_73_0._friend_party_lookup[arg_73_1[iter_73_1]] = var_73_0
	end

	arg_73_0:_server_set_client_friend_party(var_73_0)
end

PartyManager.server_remove_friend_party_peer = function (arg_74_0, arg_74_1)
	local var_74_0 = arg_74_0._friend_party_lookup[arg_74_1]

	arg_74_0._friend_party_lookup[arg_74_1] = nil

	if not var_74_0 then
		return
	end

	local var_74_1 = arg_74_0._friend_parties[var_74_0]

	assert(var_74_1, "[Party Manager: server_remove_friend_party_peer] tried to remove friend party peer " .. arg_74_1 .. " from non-existant party with id " .. var_74_0)

	if var_74_1.num_peers == 1 then
		arg_74_0:_server_remove_friend_party(var_74_0)

		return
	end

	for iter_74_0 = 1, var_74_1.num_peers do
		if var_74_1.peers[iter_74_0] == arg_74_1 then
			table.swap_delete(var_74_1.peers, iter_74_0)

			break
		end
	end

	var_74_1.num_peers = var_74_1.num_peers - 1
	var_74_1.leader = var_74_1.peers[1]
	arg_74_0._friend_party_lookup[arg_74_1] = nil

	arg_74_0:_server_set_client_friend_party(var_74_0)
end

PartyManager.server_add_friend_party_peer = function (arg_75_0, arg_75_1, arg_75_2)
	local var_75_0 = arg_75_0._friend_parties[arg_75_1]

	var_75_0.num_peers = var_75_0.num_peers + 1
	var_75_0.peers[var_75_0.num_peers] = arg_75_2
	arg_75_0._friend_party_lookup[arg_75_2] = arg_75_1

	arg_75_0:_server_set_client_friend_party(arg_75_1)
end

PartyManager.server_add_friend_party_peer_from_invitee = function (arg_76_0, arg_76_1, arg_76_2)
	local var_76_0 = arg_76_0._friend_party_lookup[arg_76_2]

	if var_76_0 then
		arg_76_0:server_add_friend_party_peer(var_76_0, arg_76_1)
	end
end

PartyManager.server_get_friend_party_from_peer = function (arg_77_0, arg_77_1)
	local var_77_0 = arg_77_0:get_friend_party_id_from_peer(arg_77_1)

	if var_77_0 then
		return arg_77_0:server_get_friend_party(var_77_0)
	end
end

PartyManager.server_get_friend_party = function (arg_78_0, arg_78_1)
	return arg_78_0._friend_parties[arg_78_1]
end

PartyManager.server_get_friend_parties_sorted = function (arg_79_0)
	local var_79_0 = {}
	local var_79_1 = 1

	for iter_79_0, iter_79_1 in pairs(arg_79_0._friend_parties) do
		var_79_0[var_79_1] = iter_79_1
		var_79_1 = var_79_1 + 1
	end

	table.sort(var_79_0, function (arg_80_0, arg_80_1)
		return arg_80_0.num_peers > arg_80_1.num_peers
	end)

	return var_79_0
end

PartyManager.server_has_room_for_friend_party = function (arg_81_0, arg_81_1, arg_81_2)
	local var_81_0 = #arg_81_0:parties()
	local var_81_1 = FrameTable.alloc_table()

	var_81_1.num_peers = arg_81_2

	local var_81_2 = table.values(arg_81_0._friend_parties, FrameTable.alloc_table())

	var_81_2[#var_81_2 + 1] = var_81_1

	table.sort(var_81_2, function (arg_82_0, arg_82_1)
		return arg_82_0.num_peers > arg_82_1.num_peers
	end)

	local var_81_3 = Script.new_array(var_81_0)

	table.fill(var_81_3, var_81_0, 0)

	for iter_81_0 = 1, #var_81_2 do
		local var_81_4 = var_81_2[iter_81_0]
		local var_81_5
		local var_81_6 = 0

		for iter_81_1 = 1, var_81_0 do
			if arg_81_0:is_game_participating(iter_81_1) then
				local var_81_7 = #arg_81_1[iter_81_1] - var_81_3[iter_81_1]

				if var_81_6 < var_81_7 then
					var_81_5 = iter_81_1
					var_81_6 = var_81_7
				end
			end
		end

		if not var_81_5 then
			return false
		end

		var_81_3[var_81_5] = var_81_3[var_81_5] + var_81_4.num_peers

		if var_81_3[var_81_5] > #arg_81_1[var_81_5] then
			return false
		end
	end

	return true
end

PartyManager.can_kick_to_fill_server = function (arg_83_0, arg_83_1, arg_83_2)
	local var_83_0 = #arg_83_0:parties()
	local var_83_1 = FrameTable.alloc_table()

	var_83_1.num_peers = arg_83_2

	local var_83_2 = table.values(arg_83_0._friend_parties, FrameTable.alloc_table())

	var_83_2[#var_83_2 + 1] = var_83_1

	table.sort(var_83_2, function (arg_84_0, arg_84_1)
		return arg_84_0.num_peers > arg_84_1.num_peers
	end)

	local var_83_3 = Script.new_array(var_83_0)

	table.fill(var_83_3, var_83_0, 0)

	local var_83_4 = FrameTable.alloc_table()

	for iter_83_0 = 1, #var_83_2 do
		local var_83_5
		local var_83_6 = 0

		for iter_83_1 = 1, var_83_0 do
			if arg_83_0:is_game_participating(iter_83_1) then
				local var_83_7 = #arg_83_1[iter_83_1] - var_83_3[iter_83_1]

				if var_83_6 < var_83_7 then
					var_83_5 = iter_83_1
					var_83_6 = var_83_7
				end
			end
		end

		local var_83_8 = var_83_2[iter_83_0]
		local var_83_9 = var_83_8.num_peers

		if var_83_6 < var_83_9 then
			if var_83_8 == var_83_1 then
				return false
			end

			var_83_4[#var_83_4 + 1] = var_83_8
		else
			var_83_3[var_83_5] = var_83_3[var_83_5] + var_83_9
		end
	end

	for iter_83_2 = 1, var_83_0 do
		if arg_83_0:is_game_participating(iter_83_2) and var_83_3[iter_83_2] ~= #arg_83_1[iter_83_2] then
			return false
		end
	end

	return var_83_4
end

PartyManager._server_generate_friend_party_id = function (arg_85_0)
	if not arg_85_0._num_friend_party_ids then
		arg_85_0._num_friend_party_ids = 0
	end

	arg_85_0._num_friend_party_ids = arg_85_0._num_friend_party_ids + 1

	return arg_85_0._num_friend_party_ids
end

PartyManager._server_remove_friend_party = function (arg_86_0, arg_86_1)
	local var_86_0 = arg_86_0._friend_parties[arg_86_1]

	for iter_86_0, iter_86_1 in pairs(var_86_0.peers) do
		arg_86_0._friend_party_lookup[iter_86_1] = nil
	end

	arg_86_0._friend_parties[arg_86_1] = nil
end

PartyManager._collect_peers_from_friend_party = function (arg_87_0, arg_87_1)
	assert(DEDICATED_SERVER or arg_87_0._is_hosting_vs_custom_game)

	local var_87_0 = arg_87_0._friend_parties[arg_87_1]

	assert(var_87_0, "[Party Manager:server_update_client_friend_parties()] tried to update client friend parties of nonexistant friend party id " .. arg_87_1)

	local var_87_1 = 4
	local var_87_2 = Script.new_array(var_87_1)
	local var_87_3 = var_87_0.peers
	local var_87_4 = #var_87_3

	if var_87_1 < var_87_4 then
		table.dump(var_87_3, "friend party peers")
		Crashify.print_exception("[PartyManager]", "Friend party stragglers found. Party size: %s", var_87_4)
	end

	for iter_87_0 = 1, var_87_4 do
		local var_87_5 = var_87_3[iter_87_0]
		local var_87_6 = #var_87_2 + 1

		if var_87_1 < var_87_6 then
			print("Too many peers in the same party:", var_87_5)
		else
			var_87_2[var_87_6] = var_87_3[iter_87_0]
		end
	end

	return var_87_2
end

PartyManager.sync_friend_party_for_player = function (arg_88_0, arg_88_1)
	assert(DEDICATED_SERVER or arg_88_0._is_hosting_vs_custom_game)

	local var_88_0 = PEER_ID_TO_CHANNEL[arg_88_1]

	if var_88_0 then
		local var_88_1 = arg_88_0:get_friend_party_id_from_peer(arg_88_1)
		local var_88_2 = arg_88_0:_collect_peers_from_friend_party(var_88_1)

		RPC.rpc_set_client_friend_party(var_88_0, var_88_2)
	end
end

PartyManager._server_set_client_friend_party = function (arg_89_0, arg_89_1)
	local var_89_0 = arg_89_0:_collect_peers_from_friend_party(arg_89_1)

	arg_89_0:_server_send_rpc_to_friend_party("rpc_set_client_friend_party", arg_89_1, var_89_0)
end

PartyManager.server_get_friend_party_leaders = function (arg_90_0, arg_90_1)
	local var_90_0 = {}
	local var_90_1 = Network.peer_id()

	if not arg_90_0._friend_parties then
		return var_90_0
	end

	for iter_90_0, iter_90_1 in pairs(arg_90_0._friend_parties) do
		if not arg_90_1 or iter_90_1.leader ~= var_90_1 then
			var_90_0[#var_90_0 + 1] = iter_90_1.leader
		end
	end

	return var_90_0
end

PartyManager._server_send_rpc_to_friend_party = function (arg_91_0, arg_91_1, arg_91_2, ...)
	local var_91_0 = arg_91_0._friend_parties[arg_91_2]

	if not var_91_0 then
		return
	end

	for iter_91_0, iter_91_1 in pairs(var_91_0.peers) do
		local var_91_1 = PEER_ID_TO_CHANNEL[iter_91_1]

		if var_91_1 then
			RPC[arg_91_1](var_91_1, ...)
		end
	end
end

PartyManager.sync_friend_party_ids = function (arg_92_0)
	local var_92_0 = {}
	local var_92_1 = {}
	local var_92_2 = 0

	for iter_92_0, iter_92_1 in pairs(arg_92_0._friend_party_lookup) do
		var_92_2 = var_92_2 + 1
		var_92_0[var_92_2] = iter_92_0
		var_92_1[var_92_2] = iter_92_1
	end

	for iter_92_2 = 1, arg_92_0._num_friend_party_ids do
		if arg_92_0._friend_parties[iter_92_2] then
			arg_92_0:_server_send_rpc_to_friend_party("rpc_sync_friend_party_ids", iter_92_2, var_92_0, var_92_1)
		end
	end
end

PartyManager.get_friend_party_id_from_peer = function (arg_93_0, arg_93_1)
	return arg_93_0._friend_party_lookup[arg_93_1]
end

PartyManager._client_set_friend_party = function (arg_94_0, arg_94_1)
	arg_94_0._client_friend_party = arg_94_1
end

PartyManager.rpc_sync_friend_party_ids = function (arg_95_0, arg_95_1, arg_95_2, arg_95_3)
	for iter_95_0 = 1, #arg_95_2 do
		arg_95_0._friend_party_lookup[arg_95_2[iter_95_0]] = arg_95_3[iter_95_0]
	end

	local var_95_0 = Managers.mechanism:game_mechanism()

	if not (var_95_0.is_hosting_versus_custom_game and var_95_0:is_hosting_versus_custom_game()) and arg_95_0._is_server then
		arg_95_0:_send_rpc_to_clients("rpc_sync_friend_party_ids", arg_95_2, arg_95_3)
	end
end

PartyManager.client_get_friend_party = function (arg_96_0)
	return arg_96_0._client_friend_party
end

PartyManager.client_is_friend_party_leader = function (arg_97_0, arg_97_1)
	return arg_97_0._client_friend_party and arg_97_0._client_friend_party[1] == arg_97_1
end
