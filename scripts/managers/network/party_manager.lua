-- chunkname: @scripts/managers/network/party_manager.lua

require("scripts/helpers/player_utils")

PartyManager = class(PartyManager)

local tbl = {
	"rpc_request_join_party",
	"rpc_reset_party_data",
	"rpc_peer_assigned_to_party",
	"rpc_remove_peer_from_party",
	"rpc_set_client_friend_party",
	"rpc_sync_friend_party_ids"
}

local function fn(arg_1_0, ...)
	-- function 1
	printf("[PartyManager] " .. arg_1_0, ...)
end

PartyManager.init = function (self)
	-- function 2
	self._leader = nil
	self._hot_join_synced_peers = {}

	self:clear_parties()

	self._friend_party_lookup = {}

	if not DEDICATED_SERVER then
		self:server_init_friend_parties(false)
	else
		self._client_friend_party = {}
	end
end

PartyManager.destroy = function (self)
	-- function 3
	if not self._gui then
		local debug_world = Application.debug_world()

		World.destroy_gui(debug_world, self._gui)

		self._gui = nil
	end
end

PartyManager._free_lobby = function (self)
	-- function 4
	if self._party_lobby_or_data ~= nil then
		fn("Party lobby has been freed")

		if type(self._party_lobby_or_data) == "userdata" then
			LobbyInternal.leave_lobby(self._party_lobby_or_data)
		end

		self._party_lobby_or_data = nil
	end
end

PartyManager.reset = function ()
	-- function 5
	fn("reset")

	if not Managers.party then
		Managers.party:destroy()
	end

	Managers.party = PartyManager:new()
end

PartyManager.set_leader = function (self, arg_6_1)
	-- function 6
	if arg_6_1 == nil then
		fn("Cleared leader")
	else
		fn("Leader set to %q", arg_6_1)
	end

	self._leader = arg_6_1
end

PartyManager.leader = function (self)
	-- function 7
	return self._leader
end

PartyManager.is_leader = function (self, arg_8_1)
	-- function 8
	return arg_8_1 == self._leader
end

PartyManager.has_party_lobby = function (self)
	-- function 9
	return self._party_lobby_or_data ~= nil
end

PartyManager.store_lobby = function (self, arg_10_1)
	-- function 10
	fn("Party lobby has been stored '%s'", arg_10_1)
	self:_free_lobby()

	self._party_lobby_or_data = arg_10_1
end

PartyManager.steal_lobby = function (self)
	-- function 11
	fn("Party lobby has been stolen!")

	local _party_lobby_or_data = self._party_lobby_or_data

	self._party_lobby_or_data = nil

	return _party_lobby_or_data
end

PartyManager.clear_parties = function (self, arg_12_1)
	-- function 12
	fn("Clear parties. sync_to_clients: %q", arg_12_1)

	self._player_statuses = {}
	self._parties = {}
	self._game_participating_parties = {}
	self._party_by_name = {}
	self._num_parties = 0
	self._num_game_participating_parties = 0
	self._undecided_party = self:create_party(self:generate_undecided_party())
	self._parties[0] = self._undecided_party
	self._cleared = true

	if not arg_12_1 then
		self:_send_rpc_to_clients("rpc_reset_party_data")
	end
end

PartyManager.generate_undecided_party = function (arg_13_0)
	-- function 13
	return {
		party_id = 0,
		name = "undecided",
		num_open_slots = 0,
		game_participating = false,
		num_slots = 16,
		tags = {}
	}
end

PartyManager.gather_party_members = function (self, arg_14_1)
	-- function 14
	local tbl = {}
	local var_14_1

	if not arg_14_1 then
		var_14_1 = self:get_party(arg_14_1)
	else
		var_14_1 = self:get_local_player_party()
	end

	if not var_14_1 then
		return tbl
	end

	local occupied_slots = var_14_1.occupied_slots

	for i, v in ipairs(occupied_slots) do
		tbl[#tbl + 1] = {
			peer_id = v.peer_id,
			local_player_id = v.local_player_id
		}
	end

	return tbl
end

PartyManager.create_party = function (arg_15_0, arg_15_1)
	-- function 15
	fn("Register party. party_id: %q | name: %q | num_slots: %q", arg_15_1.party_id, arg_15_1.name, arg_15_1.num_slots)

	local num_slots = arg_15_1.num_slots
	local tbl = {}
	local tbl_2 = {}

	for i = 1, num_slots do
		tbl[i] = {
			game_mode_data = {}
		}
		tbl_2[i] = {
			slot_id = i
		}
	end

	local tbl_3 = {
		num_bots = 0,
		num_used_slots = 0,
		party_id = arg_15_1.party_id,
		name = arg_15_1.name
	}
	local flag

	flag = arg_15_1.game_participating ~= nil or not true or arg_15_1.game_participating
	tbl_3.game_participating = flag
	tbl_3.num_open_slots = num_slots
	tbl_3.num_slots = num_slots
	tbl_3.slots = tbl
	tbl_3.occupied_slots = {}
	tbl_3.bot_add_order = {}
	tbl_3.slots_data = tbl_2

	return tbl_3
end

PartyManager.max_party_members = function (arg_16_0, arg_16_1)
	-- function 16
	local num = 0

	for k, v in pairs(arg_16_1) do
		local num_slots = v.num_slots

		if not (not (v.game_participating ~= false) and not (num < num_slots)) then
			num = num_slots
		end
	end

	return num
end

PartyManager.register_parties = function (self, arg_17_1)
	-- function 17
	fn("Register parties")

	for k, v in pairs(arg_17_1) do
		local party_id = v.party_id

		fassert(party_id ~= 0, "This party id is reserved for undecided party.")

		local create_party = self:create_party(v)

		self._parties[party_id] = create_party
		self._party_by_name[k] = create_party
		self._num_parties = self._num_parties + 1

		if not create_party.game_participating then
			self._num_game_participating_parties = self._num_game_participating_parties + 1
			self._game_participating_parties[party_id] = create_party
		end
	end

	local flag = true

	for k_2 = 1, self._num_parties do
		if not self._parties[k_2].game_participating then
			assert(flag, "Game participating parties may not be separated by non participating ones.")
		else
			flag = false
		end
	end

	self._cleared = false
end

PartyManager.cleared = function (self)
	-- function 18
	return self._cleared
end

PartyManager._create_player_status = function (self, arg_19_1, arg_19_2, arg_19_3)
	-- function 19
	local unique_player_id = PlayerUtils.unique_player_id(arg_19_1, arg_19_2)
	local _player_statuses = self._player_statuses
	local tbl = {
		score = 0,
		peer_id = arg_19_1,
		local_player_id = arg_19_2,
		unique_id = unique_player_id,
		is_bot = arg_19_3,
		is_player = not arg_19_3,
		game_mode_data = {}
	}

	fassert(not _player_statuses[unique_player_id], "Player already connected peer_id=%s local_player_id%s", arg_19_1, arg_19_2)

	_player_statuses[unique_player_id] = tbl

	return tbl
end

PartyManager.register_player = function (self, arg_20_1, arg_20_2)
	-- function 20
	local var_20_0 = self._player_statuses[arg_20_2]

	if not var_20_0 then
		local network_id = arg_20_1:network_id()
		local local_player_id = arg_20_1:local_player_id()

		var_20_0 = self:_create_player_status(network_id, local_player_id, false)
	end

	var_20_0.player = arg_20_1
end

PartyManager.set_selected_profile = function (self, arg_21_1, arg_21_2, arg_21_3, arg_21_4)
	-- function 21
	local get_player_status = self:get_player_status(arg_21_1, arg_21_2)

	get_player_status.selected_profile_index = arg_21_3
	get_player_status.selected_career_index = arg_21_4
	get_player_status.profile_index = arg_21_3
	get_player_status.career_index = arg_21_4
end

PartyManager.cleanup_game_mode_data = function (self)
	-- function 22
	for k, v in pairs(self._player_statuses) do
		v.game_mode_data = {}
	end
end

PartyManager.register_rpcs = function (self, arg_23_1)
	-- function 23
	self._network_event_delegate = arg_23_1

	arg_23_1:register(self, unpack(tbl))
end

PartyManager.unregister_rpcs = function (self)
	-- function 24
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
end

PartyManager.update = function (arg_25_0, arg_25_1, arg_25_2)
	-- function 25
	return
end

PartyManager.get_local_player_party = function (self)
	-- function 26
	local local_player = Managers.player:local_player()

	if not local_player then
		return self:get_party_from_unique_id(local_player:unique_id())
	end
end

PartyManager.get_party = function (self, arg_27_1)
	-- function 27
	return self._parties[arg_27_1]
end

PartyManager.parties = function (self)
	-- function 28
	return self._parties
end

PartyManager.game_participating_parties = function (self)
	-- function 29
	return self._game_participating_parties
end

PartyManager.is_game_participating_party = function (self, arg_30_1)
	-- function 30
	return self._game_participating_parties[arg_30_1] ~= nil
end

PartyManager.get_party_composition = function (self)
	-- function 31
	local tbl = {}

	for i, v in ipairs(self._parties) do
		local occupied_slots = v.occupied_slots

		for i_2, v_2 in ipairs(occupied_slots) do
			tbl[v_2.unique_id] = v.party_id
		end
	end

	return tbl
end

PartyManager._slot_empty_in_party = function (self, arg_32_1, arg_32_2)
	-- function 32
	return self._parties[arg_32_1].slots[arg_32_2].peer_id == nil
end

PartyManager.request_join_party = function (self, arg_33_1, arg_33_2, arg_33_3, arg_33_4, arg_33_5)
	-- function 33
	if not self._is_server then
		local var_33_0 = self._parties[arg_33_3]
		local flag = true

		if not arg_33_4 then
			flag = self:_slot_empty_in_party(arg_33_3, arg_33_4)
		end

		if not flag then
			local preferred_slot_id = Managers.mechanism:preferred_slot_id(arg_33_3, arg_33_1, arg_33_2)

			if not preferred_slot_id then
				if not self:is_slot_bot(var_33_0, preferred_slot_id) then
					local slot_peer_id, var_33_4 = self:slot_peer_id(var_33_0, preferred_slot_id)
					local get_player_status = Managers.party:get_player_status(slot_peer_id, var_33_4)

					self:remove_peer_from_party(get_player_status.peer_id, get_player_status.local_player_id, get_player_status.party_id)

					arg_33_4 = preferred_slot_id
				elseif not self:is_slot_empty(var_33_0, preferred_slot_id) then
					arg_33_4 = preferred_slot_id
				end
			end

			local flag_2 = false

			if var_33_0.num_used_slots < var_33_0.num_slots then
				self:assign_peer_to_party(arg_33_1, arg_33_2, arg_33_3, arg_33_4, flag_2)
			elseif var_33_0.num_bots > 0 then
				local var_33_7

				if not arg_33_5 then
					local network_id = arg_33_5:network_id()
					local local_player_id = arg_33_5:local_player_id()

					var_33_7 = Managers.party:get_player_status(network_id, local_player_id)
				else
					var_33_7 = self:get_last_added_bot_for_party(arg_33_3)
				end

				self:remove_peer_from_party(var_33_7.peer_id, var_33_7.local_player_id, var_33_7.party_id)
				self:assign_peer_to_party(arg_33_1, arg_33_2, arg_33_3, arg_33_4, flag_2)
			end
		end
	else
		fn("Sending request join party")

		arg_33_4 = arg_33_4 or NetworkConstants.INVALID_PARTY_SLOT_ID

		local var_33_10 = PEER_ID_TO_CHANNEL[self._server_peer_id]

		RPC.rpc_request_join_party(var_33_10, arg_33_1, arg_33_2, arg_33_3, arg_33_4)
	end
end

PartyManager.get_player_status = function (self, arg_34_1, arg_34_2)
	-- function 34
	local unique_player_id = PlayerUtils.unique_player_id(arg_34_1, arg_34_2)

	return self._player_statuses[unique_player_id]
end

PartyManager.get_status_from_unique_id = function (self, arg_35_1)
	-- function 35
	return self._player_statuses[arg_35_1]
end

PartyManager.get_party_from_player_id = function (self, arg_36_1, arg_36_2)
	-- function 36
	local unique_player_id = PlayerUtils.unique_player_id(arg_36_1, arg_36_2)
	local var_36_1 = self._player_statuses[unique_player_id]

	if not var_36_1 then
		local party_id = var_36_1.party_id

		return self._parties[party_id], party_id
	end
end

PartyManager.get_party_from_unique_id = function (self, arg_37_1)
	-- function 37
	local var_37_0 = self._player_statuses[arg_37_1]

	if not var_37_0 then
		local party_id = var_37_0.party_id

		return self._parties[party_id], party_id
	end
end

PartyManager.get_party_from_name = function (self, arg_38_1)
	-- function 38
	local _parties = self._parties

	for i = 0, #_parties do
		local var_38_1 = _parties[i]

		if var_38_1.name == arg_38_1 then
			return var_38_1
		end
	end
end

function update_status_profile_index(self)
	-- function 39
	local state = Managers.state

	if not state then
		return
	end

	local network = state.network

	if not network then
		return
	end

	local profile_synchronizer = network.profile_synchronizer

	if not profile_synchronizer then
		return
	end

	local profile_by_peer, var_39_4 = profile_synchronizer:profile_by_peer(self.peer_id, self.local_player_id)

	self.profile_index = profile_by_peer
	self.career_index = var_39_4
	self.profile_id = not profile_by_peer and SPProfiles[profile_by_peer].display_name
end

PartyManager.get_num_parties = function (self)
	-- function 40
	return self._num_parties
end

PartyManager.get_num_game_participating_parties = function (self)
	-- function 41
	return self._num_game_participating_parties
end

PartyManager.is_game_participating = function (self, arg_42_1)
	-- function 42
	return self._parties[arg_42_1].game_participating
end

PartyManager.assign_peer_to_party = function (self, arg_43_1, arg_43_2, arg_43_3, arg_43_4, arg_43_5)
	-- function 43
	arg_43_5 = not not arg_43_5

	local unique_player_id = PlayerUtils.unique_player_id(arg_43_1, arg_43_2)
	local flag = true
	local var_43_2 = self._player_statuses[unique_player_id]

	if not var_43_2 then
		var_43_2 = self:_create_player_status(arg_43_1, arg_43_2, arg_43_5)
		flag = false
	end

	local var_43_3

	if not flag and not var_43_2.party_id then
		var_43_3 = var_43_2.party_id

		local var_43_4 = self._parties[var_43_3]
		local slot_id = var_43_2.slot_id
		local is_bot = var_43_2.is_bot

		self:_clear_slot_in_party(var_43_4, slot_id, is_bot)
	end

	update_status_profile_index(var_43_2)

	local var_43_7

	if not arg_43_3 then
		var_43_7 = self._parties[arg_43_3]

		if not var_43_7 then
			-- Nothing
		end
	end

	var_43_7 = self._undecided_party

	::label_43_0::

	local flag_2 = arg_43_3 or 0

	fn("Player (%s:%d) was put into party %s (%d)", arg_43_1, arg_43_2, var_43_7.name, flag_2)

	local flag_3 = arg_43_4 or self:find_first_empty_slot_id(var_43_7)

	if not PartyManager._find_slot_index(var_43_7, flag_3) then
		flag_3 = nil
	end

	var_43_7.slots[flag_3] = var_43_2
	var_43_7.occupied_slots[#var_43_7.occupied_slots + 1] = var_43_2
	var_43_2.party_id = flag_2
	var_43_2.slot_id = flag_3
	var_43_7.num_used_slots = var_43_7.num_used_slots + 1
	var_43_7.num_open_slots = var_43_7.num_slots - var_43_7.num_used_slots

	if not arg_43_5 then
		var_43_7.num_bots = var_43_7.num_bots + 1
		var_43_7.bot_add_order[var_43_7.num_bots] = flag_3
	end

	if not self._is_server then
		fn("Sending 'rpc_peer_assigned_to_party'")
		self:_send_rpc_to_clients("rpc_peer_assigned_to_party", arg_43_1, arg_43_2, flag_2, flag_3, arg_43_5)
	end

	local player = Managers.player:player(arg_43_1, arg_43_2)
	local flag_4 = not player and player.local_player

	if not Managers.state.event then
		Managers.state.event:trigger("player_party_changed", player, flag_4, var_43_3, flag_2)
	end

	if not Managers.state.game_mode then
		Managers.state.game_mode:player_joined_party(arg_43_1, arg_43_2, flag_2, flag_3, var_43_3)
	end

	if not Managers.state.event then
		Managers.state.event:trigger("on_player_joined_party", arg_43_1, arg_43_2, flag_2, flag_3, arg_43_5)
	end

	if not Managers.venture.challenge then
		Managers.venture.challenge:on_player_joined_party(arg_43_1, arg_43_2, flag_2, flag_3, arg_43_5)
	end

	Managers.mechanism:player_joined_party(arg_43_1, arg_43_2, flag_2, flag_3, arg_43_5)

	return var_43_2
end

PartyManager.remove_peer_from_party = function (self, arg_44_1, arg_44_2, arg_44_3)
	-- function 44
	local get_player_status = self:get_player_status(arg_44_1, arg_44_2)

	if not get_player_status then
		return
	end

	local var_44_1 = self._parties[arg_44_3]
	local slot_id = get_player_status.slot_id
	local var_44_3 = var_44_1.slots[slot_id]

	if not self._is_server then
		self:_send_rpc_to_clients("rpc_remove_peer_from_party", arg_44_1, arg_44_2, arg_44_3)
	end

	self:_clear_slot_in_party(var_44_1, get_player_status.slot_id, get_player_status.is_bot)

	if not Managers.state.game_mode then
		Managers.state.game_mode:player_left_party(arg_44_1, arg_44_2, arg_44_3, slot_id, var_44_3)
	end

	if not Managers.state.event then
		Managers.state.event:trigger("on_player_left_party", arg_44_1, arg_44_2, arg_44_3, slot_id)
	end

	if not Managers.venture.challenge then
		local is_bot = get_player_status.is_bot

		Managers.venture.challenge:on_player_left_party(arg_44_1, arg_44_2, arg_44_3, slot_id, is_bot)
	end

	if not DEDICATED_SERVER then
		Managers.account:update_presence()
	end

	get_player_status.party_id = nil
	get_player_status.slot_id = nil
end

local tbl_2 = {}

PartyManager.get_players_in_party = function (self, arg_45_1)
	-- function 45
	table.clear(tbl_2)

	local num = 0

	for k, v in pairs(self._player_statuses) do
		if v.party_id == arg_45_1 then
			num = num + 1
			tbl_2[num] = v
		end
	end

	return tbl_2, num
end

PartyManager._find_slot_index = function (self, arg_46_1)
	-- function 46
	local var_46_0
	local occupied_slots = self.occupied_slots

	for i = 1, #occupied_slots do
		if occupied_slots[i].slot_id == arg_46_1 then
			var_46_0 = i

			break
		end
	end

	return var_46_0
end

PartyManager._clear_slot_in_party = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3)
	-- function 47
	arg_47_1.slots[arg_47_2] = {}

	local _find_slot_index = PartyManager._find_slot_index(arg_47_1, arg_47_2)

	fassert(_find_slot_index ~= nil, "could not find player status in occupied_slots")

	local occupied_slots = arg_47_1.occupied_slots
	local num_used_slots = arg_47_1.num_used_slots

	occupied_slots[_find_slot_index] = occupied_slots[num_used_slots]
	occupied_slots[num_used_slots] = nil
	arg_47_1.num_used_slots = num_used_slots - 1
	arg_47_1.num_open_slots = arg_47_1.num_slots - arg_47_1.num_used_slots

	if not arg_47_3 then
		arg_47_1.num_bots = arg_47_1.num_bots - 1

		local find = table.find(arg_47_1.bot_add_order, arg_47_2)

		table.remove(arg_47_1.bot_add_order, find)
	end
end

PartyManager.is_slot_empty = function (arg_48_0, arg_48_1, arg_48_2)
	-- function 48
	local slots = arg_48_1.slots

	return slots[arg_48_2] == nil or slots[arg_48_2].peer_id == nil
end

PartyManager.is_slot_bot = function (arg_49_0, arg_49_1, arg_49_2)
	-- function 49
	local var_49_0 = arg_49_1.slots[arg_49_2]

	return not var_49_0 and var_49_0.is_bot
end

PartyManager.slot_peer_id = function (arg_50_0, arg_50_1, arg_50_2)
	-- function 50
	local var_50_0 = arg_50_1.slots[arg_50_2]

	if not var_50_0 then
		return var_50_0.peer_id, var_50_0.local_player_id
	end

	return nil, nil
end

PartyManager.find_first_empty_slot_id = function (self, arg_51_1)
	-- function 51
	local num_slots = arg_51_1.num_slots

	for i = 1, num_slots do
		if not self:is_slot_empty(arg_51_1, i) then
			return i
		end
	end

	ferror("No empty slot in party %s", arg_51_1.name)
end

PartyManager.get_least_filled_party = function (self, arg_52_1, arg_52_2)
	-- function 52
	local _parties = self._parties

	fassert(#_parties > 1, "parties has not been initialized yet")

	local num = 0
	local huge = math.huge

	for i = 1, #_parties do
		local var_52_3 = _parties[i]

		if not arg_52_2 and not var_52_3.game_participating then
			local num_used_slots = var_52_3.num_used_slots

			if not arg_52_1 then
				num_used_slots = num_used_slots - var_52_3.num_bots
			end

			if num_used_slots < huge then
				num = i
				huge = num_used_slots
			end
		end
	end

	return _parties[num], num
end

PartyManager.is_party_full = function (self, arg_53_1)
	-- function 53
	local var_53_0 = self._parties[arg_53_1]

	return var_53_0.num_open_slots + var_53_0.num_bots == 0
end

PartyManager.is_player_in_party = function (self, arg_54_1, arg_54_2)
	-- function 54
	local var_54_0 = self._parties[arg_54_2]

	return arg_54_2 == self._player_statuses[arg_54_1].party_id
end

PartyManager.get_last_added_bot_for_party = function (self, arg_55_1)
	-- function 55
	local var_55_0 = self._parties[arg_55_1]
	local var_55_1 = var_55_0.bot_add_order[var_55_0.num_bots]

	return var_55_0.slots[var_55_1]
end

PartyManager.hot_join_sync = function (self, arg_56_1)
	-- function 56
	local _parties = self._parties
	local var_56_1 = PEER_ID_TO_CHANNEL[arg_56_1]

	for i = 0, #_parties do
		local occupied_slots = _parties[i].occupied_slots

		for j = 1, #occupied_slots do
			local var_56_3 = occupied_slots[j]
			local peer_id = var_56_3.peer_id
			local local_player_id = var_56_3.local_player_id
			local is_bot = var_56_3.is_bot
			local slot_id = var_56_3.slot_id

			RPC.rpc_peer_assigned_to_party(var_56_1, peer_id, local_player_id, i, slot_id, is_bot)
		end
	end
end

PartyManager._send_rpc_to_clients = function (self, arg_57_1, ...)
	-- function 57
	local var_57_0 = RPC[arg_57_1]
	local _server_peer_id = self._server_peer_id

	for k, v in pairs(self._hot_join_synced_peers) do
		if k == _server_peer_id or not v then
			local var_57_2 = PEER_ID_TO_CHANNEL[k]

			var_57_0(var_57_2, ...)
		end
	end
end

PartyManager.network_context_created = function (self, arg_58_1, arg_58_2, arg_58_3)
	-- function 58
	fn("network_context_created (server_peer_id=%s, own_peer_id=%s)", arg_58_2, arg_58_3)

	self._lobby = arg_58_1
	self._server_peer_id = arg_58_2
	self._peer_id = arg_58_3
	self._is_server = arg_58_2 == arg_58_3
end

PartyManager.parties_by_name = function (self)
	-- function 59
	return self._party_by_name
end

PartyManager.network_context_destroyed = function (self)
	-- function 60
	fn("network_context_created")

	self._lobby = nil
	self._server_peer_id = nil
	self._peer_id = nil
	self._is_server = nil
	self._hot_join_synced_peers = {}

	self:clear_parties()
end

PartyManager.server_peer_hot_join_synced = function (arg_61_0, arg_61_1)
	-- function 61
	arg_61_0._hot_join_synced_peers[arg_61_1] = true
end

PartyManager.server_peer_left_session = function (self, arg_62_1, arg_62_2, arg_62_3)
	-- function 62
	self._hot_join_synced_peers[arg_62_1] = false

	local _parties = self._parties

	for i = 0, #_parties do
		local var_62_1 = _parties[i]
		local slots = var_62_1.slots
		local num_slots = var_62_1.num_slots

		for j = 1, num_slots do
			local var_62_4 = slots[j]

			if var_62_4.peer_id == arg_62_1 then
				self:remove_peer_from_party(var_62_4.peer_id, var_62_4.local_player_id, i)
			end
		end
	end

	Managers.state.event:trigger("friend_party_peer_left", arg_62_1, arg_62_2, arg_62_3)
end

PartyManager.rpc_request_join_party = function (self, arg_63_1, arg_63_2, arg_63_3, arg_63_4, arg_63_5)
	-- function 63
	printf("Recieved join party request from %s - %s party_id(%s)", arg_63_2, arg_63_3, arg_63_4)

	if arg_63_5 == NetworkConstants.INVALID_PARTY_SLOT_ID then
		arg_63_5 = nil
	end

	self:request_join_party(arg_63_2, arg_63_3, arg_63_4, arg_63_5)
end

PartyManager.rpc_peer_assigned_to_party = function (self, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
	-- function 64
	fn("rpc_peer_assigned_to_party. channel_id: %q | peer_id: %q | local_player_id: %q | party_id: %q | slot_id: %q | is_bot: %q", arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
	self:assign_peer_to_party(arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6)
end

PartyManager.rpc_remove_peer_from_party = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	-- function 65
	fn("rpc_remove_peer_from_party. channel_id: %q | peer_id: %q | local_player_id: %q | party_id: %q", arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	self:remove_peer_from_party(arg_65_2, arg_65_3, arg_65_4)
end

PartyManager.rpc_set_client_friend_party = function (self, arg_66_1, arg_66_2)
	-- function 66
	self:_client_set_friend_party(arg_66_2)
end

PartyManager.rpc_reset_party_data = function (self)
	-- function 67
	self:clear_parties()
	Managers.mechanism:setup_mechanism_parties()
end

PartyManager._draw_debug = function (self, arg_68_1)
	-- function 68
	local str = "materials/fonts/arial"
	local str_2 = "arial"
	local num = 20
	local num_2 = 20
	local num_3 = 32
	local num_4 = 180
	local num_5 = 160
	local num_6 = 90
	local num_7 = 2 * num_3 + num_4 + num_5 + num_6
	local is_server = Managers.player.is_server
	local var_68_10 = Color(128, 0, 0, 0)
	local var_68_11 = Color(255, 255, 255, 255)
	local var_68_12 = Color(255, 128, 255, 255)
	local var_68_13 = Color(255, 155, 155, 255)
	local var_68_14 = Color(255, 155, 255, 155)
	local var_68_15 = Color(255, 55, 155, 156)
	local var_68_16

	if not is_server then
		var_68_16 = Color(255, 255, 255, 0)

		if not var_68_16 then
			-- Nothing
		end
	end

	var_68_16 = Color(255, 55, 126, 255)

	::label_68_0::

	local resolution, var_68_18 = Gui.resolution()
	local num_8 = var_68_18 - num_3 - num
	local num_9 = resolution - num_7

	if self._gui == nil then
		local debug_world = Application.debug_world()

		self._gui = World.create_screen_gui(debug_world, "immediate", "material", "materials/fonts/gw_fonts")
	end

	Gui.rect(self._gui, Vector2(num_9, 0), Vector2(num_7, var_68_18), var_68_10)

	local flag

	flag = not is_server and "(Server)" and "(Client)"

	Gui.text(self._gui, flag, str, num, str_2, Vector3(num_9 + num_7 - 80, num_8, 0), var_68_16)

	local current_mechanism_name = Managers.mechanism:current_mechanism_name()
	local get_state = Managers.mechanism:game_mechanism():get_state()
	local format = string.format("Mechanism:'%s', state:'%s'", current_mechanism_name, get_state)

	Gui.text(self._gui, format, str, num, str_2, Vector3(num_9 + num_3, num_8, 0), var_68_15)

	local num_10 = num_8 - num_2
	local game_mode = Managers.state.game_mode:game_mode()
	local key

	if not game_mode then
		key = game_mode:settings().key

		if not key then
			-- Nothing
		end
	end

	key = "none"

	::label_68_1::

	local get_level_seed = Managers.mechanism:get_level_seed()
	local format_2 = string.format("Game mode: '%s', seed: %s", key, tostring(get_level_seed))

	Gui.text(self._gui, format_2, str, num, str_2, Vector3(num_9 + num_3, num_10, 0), var_68_14)

	local num_11 = num_10 - num_2
	local format_3 = string.format("    state: '%s' max: %s", game_mode:game_mode_state(), LobbySetup._network_options.max_members)

	Gui.text(self._gui, format_3, str, num, str_2, Vector3(num_9 + num_3, num_11, 0), var_68_14)

	local num_12 = num_11 - num_2 * 2
	local game_mechanism = Managers.mechanism:game_mechanism()

	if not game_mechanism.win_conditions then
		local game_mode_2 = Managers.state.game_mode:game_mode()

		if not game_mode_2.round_id then
			local win_conditions = game_mechanism:win_conditions()
			local get_current_set = game_mechanism:get_current_set()
			local num_sets = game_mechanism:num_sets()
			local total_rounds_started = game_mechanism:total_rounds_started()
			local format_4 = string.format
			local str_3 = "Set: %s/%s --> round: %d/2, round_id: %d"
			local var_68_42 = get_current_set
			local var_68_43 = num_sets
			local tostring = tostring
			local round_id = game_mode_2:round_id()

			round_id = round_id or -1

			local var_68_46 = format_4(str_3, var_68_42, var_68_43, tostring(round_id), total_rounds_started)

			Gui.text(self._gui, var_68_46, str, num, str_2, Vector3(num_9 + num_3, num_12, 0), var_68_14)

			num_12 = num_12 - num_2

			local num_13 = 14

			for i = 1, num_sets do
				num_12 = num_12 - num_13 / 2

				local flag_2

				flag_2 = i ~= get_current_set or not "(current set)" or ""

				local format_5 = string.format("Set %s  %s", i, flag_2)

				Gui.text(self._gui, format_5, str, num_13, str_2, Vector3(num_9 + num_3, num_12, 0), Color(255, 220, 200, 0))

				num_12 = num_12 - num_13 - 4

				for j = 1, 2 do
					local var_68_50 = win_conditions:set_data(j)[i]

					if not var_68_50 then
						local str_4 = ""

						if var_68_50.distance_traveled > 0 then
							str_4 = string.format("dist: %.1f%%", var_68_50.distance_traveled * 100)
						end

						local format_6 = string.format("Party %s -> Score: %s/%s(%s) %s", j, var_68_50.claimed_points, tostring(var_68_50.max_points), var_68_50.max_points - var_68_50.claimed_points, str_4)

						Gui.text(self._gui, format_6, str, num_13, str_2, Vector3(num_9 + num_3, num_12, 0), var_68_14)
					end

					num_12 = num_12 - num_13 - 4
				end
			end

			num_12 = num_12 - num_13 - 4
		end
	end

	local _parties = self._parties

	for k = 0, #_parties do
		local var_68_54 = _parties[k]
		local num_14 = num_9 + num_3

		Gui.text(self._gui, "Party " .. tostring(var_68_54.party_id), str, num, str_2, Vector3(num_14, num_12, 0), var_68_13)

		local num_15 = num_14 + num_4
		local var_68_57 = Managers.state.side.side_by_party[var_68_54]
		local _num_units

		if not var_68_57 then
			_num_units = var_68_57._num_units

			if not _num_units then
				-- Nothing
			end
		end

		_num_units = 0

		do
			local _num_enemy_units
		end

		::label_68_2::

		if not var_68_57 then
			_num_enemy_units = var_68_57._num_enemy_units

			if not _num_enemy_units then
				-- Nothing
			end
		end

		_num_enemy_units = 0

		::label_68_3::

		Gui.text(self._gui, string.format("(%d/%d) units(%d) enemies(%d)", var_68_54.num_used_slots, var_68_54.num_slots, _num_units, _num_enemy_units), str, num, str_2, Vector3(num_15, num_12, 0), var_68_13)

		num_12 = num_12 - num_2

		local num_16 = num_9 + num_3

		Gui.text(self._gui, "Peer", str, num, str_2, Vector3(num_16, num_12, 0), var_68_11)

		local num_17 = num_16 + num_4

		Gui.text(self._gui, "State", str, num, str_2, Vector3(num_17, num_12, 0), var_68_11)

		local num_18 = num_17 + num_5

		Gui.text(self._gui, "Info", str, num, str_2, Vector3(num_18, num_12, 0), var_68_11)

		num_12 = num_12 - 4

		Gui.rect(self._gui, Vector2(num_9 + num_3, num_12), Vector2(num_4 + num_5 + num_6, 1), var_68_11)

		num_12 = num_12 - num_2

		local occupied_slots = var_68_54.occupied_slots

		for l = 1, #occupied_slots do
			local var_68_64 = occupied_slots[l]
			local format_7

			if var_68_64.game_mode_data.spawn_state ~= "w8_to_spawn" or not var_68_64.game_mode_data.spawn_timer then
				format_7 = string.format("%.1f", var_68_64.game_mode_data.spawn_timer - arg_68_1)

				if not format_7 then
					-- Nothing
				end
			end

			format_7 = ""

			::label_68_4::

			local format_8 = string.format
			local str_5 = "%s %s"
			local spawn_state = var_68_64.game_mode_data.spawn_state

			spawn_state = spawn_state or "?"

			local var_68_69 = format_8(str_5, spawn_state, format_7)
			local peer_id = var_68_64.peer_id
			local profile_id = var_68_64.profile_id
			local profile_index = var_68_64.profile_index
			local career_index = var_68_64.career_index
			local format_9 = string.format("P/C: %s-%s/%s", tostring(profile_id), tostring(profile_index), tostring(career_index))
			local str_6 = "-"
			local str_7 = "?"
			local player = var_68_64.player

			if not player then
				str_7 = not player:is_player_controlled() and "P" and "B"
				str_6 = "1"

				local player_unit = player.player_unit
				local var_68_79

				if not player_unit then
					local get_data = Unit.get_data(player_unit, "breed")

					str_6 = not get_data and get_data.hit_zones_lookup ~= nil and "L" and "2"
				else
					str_6 = not next(player.owned_units) and "P" and "?"
				end
			end

			local str_8 = str_7 .. str_6
			local num_19 = num_9 + num_3

			Gui.text(self._gui, peer_id, str, num, str_2, Vector3(num_19, num_12, 0), var_68_11)

			local num_20 = num_19 + num_4

			Gui.text(self._gui, tostring(var_68_69), str, num, str_2, Vector3(num_20, num_12, 0), var_68_11)

			local num_21 = num_20 + num_5

			Gui.text(self._gui, str_8, str, num, str_2, Vector3(num_21, num_12, 0), var_68_11)

			num_12 = num_12 - num_2

			local num_22 = num_9 + num_3

			Gui.text(self._gui, tostring(format_9), str, num, str_2, Vector3(num_22, num_12, 0), var_68_12)

			num_12 = num_12 - num_2
		end

		num_12 = num_12 - num_2 * 2
	end
end

PartyManager.any_party_has_free_slots = function (self, arg_69_1)
	-- function 69
	arg_69_1 = arg_69_1 or 1

	local _parties = self._parties

	for i = 1, #_parties do
		local var_69_1 = _parties[i]

		if arg_69_1 <= var_69_1.num_open_slots + var_69_1.num_bots then
			return true
		end
	end

	return false
end

PartyManager.server_init_friend_parties = function (self, arg_70_1)
	-- function 70
	self._is_hosting_vs_custom_game = true
	self._friend_parties = {}
	self._friend_party_lookup = {}
	self._num_friend_party_ids = 0

	if not arg_70_1 then
		local local_player = Managers.player:local_player()
		local get_party = local_player:get_party()
		local tbl = {}

		for k, v in pairs(get_party.slots) do
			if not v.peer_id then
				tbl[#tbl + 1] = v.peer_id
			end
		end

		self:server_create_friend_party(tbl, local_player.peer_id)
	end
end

PartyManager.server_clear_friend_parties = function (self)
	-- function 71
	if not self._is_hosting_vs_custom_game then
		self._is_hosting_vs_custom_game = nil
	end

	table.clear(self._friend_parties)
	table.clear(self._friend_party_lookup)
end

PartyManager.server_update_all_client_friend_parties = function (self)
	-- function 72
	for k, v in pairs(self._friend_parties) do
		self:_server_set_client_friend_party(k)
	end
end

PartyManager.server_create_friend_party = function (self, arg_73_1, arg_73_2, arg_73_3)
	-- function 73
	if arg_73_1[1] ~= arg_73_2 then
		for i = 1, #arg_73_1 do
			if arg_73_1[i] == arg_73_2 then
				arg_73_1[i] = arg_73_1[1]
				arg_73_1[1] = arg_73_2

				break
			end
		end
	end

	local flag = arg_73_3 or self:_server_generate_friend_party_id()

	self._friend_parties[flag] = {
		leader = arg_73_2,
		peers = arg_73_1,
		num_peers = #arg_73_1
	}

	for j = 1, #arg_73_1 do
		self._friend_party_lookup[arg_73_1[j]] = flag
	end

	self:_server_set_client_friend_party(flag)
end

PartyManager.server_remove_friend_party_peer = function (self, arg_74_1)
	-- function 74
	local var_74_0 = self._friend_party_lookup[arg_74_1]

	self._friend_party_lookup[arg_74_1] = nil

	if not var_74_0 then
		return
	end

	local var_74_1 = self._friend_parties[var_74_0]

	assert(var_74_1, "[Party Manager: server_remove_friend_party_peer] tried to remove friend party peer " .. arg_74_1 .. " from non-existant party with id " .. var_74_0)

	if var_74_1.num_peers == 1 then
		self:_server_remove_friend_party(var_74_0)

		return
	end

	for i = 1, var_74_1.num_peers do
		if var_74_1.peers[i] == arg_74_1 then
			table.swap_delete(var_74_1.peers, i)

			break
		end
	end

	var_74_1.num_peers = var_74_1.num_peers - 1
	var_74_1.leader = var_74_1.peers[1]
	self._friend_party_lookup[arg_74_1] = nil

	self:_server_set_client_friend_party(var_74_0)
end

PartyManager.server_add_friend_party_peer = function (self, arg_75_1, arg_75_2)
	-- function 75
	local var_75_0 = self._friend_parties[arg_75_1]

	var_75_0.num_peers = var_75_0.num_peers + 1
	var_75_0.peers[var_75_0.num_peers] = arg_75_2
	self._friend_party_lookup[arg_75_2] = arg_75_1

	self:_server_set_client_friend_party(arg_75_1)
end

PartyManager.server_add_friend_party_peer_from_invitee = function (self, arg_76_1, arg_76_2)
	-- function 76
	local var_76_0 = self._friend_party_lookup[arg_76_2]

	if not var_76_0 then
		self:server_add_friend_party_peer(var_76_0, arg_76_1)
	end
end

PartyManager.server_get_friend_party_from_peer = function (self, arg_77_1)
	-- function 77
	local get_friend_party_id_from_peer = self:get_friend_party_id_from_peer(arg_77_1)

	if not get_friend_party_id_from_peer then
		return self:server_get_friend_party(get_friend_party_id_from_peer)
	end
end

PartyManager.server_get_friend_party = function (self, arg_78_1)
	-- function 78
	return self._friend_parties[arg_78_1]
end

PartyManager.server_get_friend_parties_sorted = function (self)
	-- function 79
	local tbl = {}
	local num = 1

	for k, v in pairs(self._friend_parties) do
		tbl[num] = v
		num = num + 1
	end

	table.sort(tbl, function (self, arg_80_1)
		-- function 80
		return self.num_peers > arg_80_1.num_peers
	end)

	return tbl
end

PartyManager.server_has_room_for_friend_party = function (self, arg_81_1, arg_81_2)
	-- function 81
	local count = #self:parties()
	local alloc_table = FrameTable.alloc_table()

	alloc_table.num_peers = arg_81_2

	local values = table.values(self._friend_parties, FrameTable.alloc_table())

	values[#values + 1] = alloc_table

	table.sort(values, function (self, arg_82_1)
		-- function 82
		return self.num_peers > arg_82_1.num_peers
	end)

	local new_array = Script.new_array(count)

	table.fill(new_array, count, 0)

	for i = 1, #values do
		local var_81_4 = values[i]
		local var_81_5
		local num = 0

		for j = 1, count do
			if not self:is_game_participating(j) then
				local num_2 = #arg_81_1[j] - new_array[j]

				if num < num_2 then
					var_81_5 = j
					num = num_2
				end
			end
		end

		if not var_81_5 then
			return false
		end

		new_array[var_81_5] = new_array[var_81_5] + var_81_4.num_peers

		if new_array[var_81_5] > #arg_81_1[var_81_5] then
			return false
		end
	end

	return true
end

PartyManager.can_kick_to_fill_server = function (self, arg_83_1, arg_83_2)
	-- function 83
	local count = #self:parties()
	local alloc_table = FrameTable.alloc_table()

	alloc_table.num_peers = arg_83_2

	local values = table.values(self._friend_parties, FrameTable.alloc_table())

	values[#values + 1] = alloc_table

	table.sort(values, function (self, arg_84_1)
		-- function 84
		return self.num_peers > arg_84_1.num_peers
	end)

	local new_array = Script.new_array(count)

	table.fill(new_array, count, 0)

	local alloc_table_2 = FrameTable.alloc_table()

	for i = 1, #values do
		local var_83_5
		local num = 0

		for j = 1, count do
			if not self:is_game_participating(j) then
				local num_2 = #arg_83_1[j] - new_array[j]

				if num < num_2 then
					var_83_5 = j
					num = num_2
				end
			end
		end

		local var_83_8 = values[i]
		local num_peers = var_83_8.num_peers

		if num < num_peers then
			if var_83_8 == alloc_table then
				return false
			end

			alloc_table_2[#alloc_table_2 + 1] = var_83_8
		else
			new_array[var_83_5] = new_array[var_83_5] + num_peers
		end
	end

	for k = 1, count do
		if not (not self:is_game_participating(k) and new_array[k] == #arg_83_1[k]) then
			return false
		end
	end

	return alloc_table_2
end

PartyManager._server_generate_friend_party_id = function (self)
	-- function 85
	if not self._num_friend_party_ids then
		self._num_friend_party_ids = 0
	end

	self._num_friend_party_ids = self._num_friend_party_ids + 1

	return self._num_friend_party_ids
end

PartyManager._server_remove_friend_party = function (self, arg_86_1)
	-- function 86
	local var_86_0 = self._friend_parties[arg_86_1]

	for k, v in pairs(var_86_0.peers) do
		self._friend_party_lookup[v] = nil
	end

	self._friend_parties[arg_86_1] = nil
end

PartyManager._collect_peers_from_friend_party = function (self, arg_87_1)
	-- function 87
	local assert = assert
	local DEDICATED_SERVER = DEDICATED_SERVER

	DEDICATED_SERVER = DEDICATED_SERVER or self._is_hosting_vs_custom_game

	assert(DEDICATED_SERVER)

	local var_87_2 = self._friend_parties[arg_87_1]

	assert(var_87_2, "[Party Manager:server_update_client_friend_parties()] tried to update client friend parties of nonexistant friend party id " .. arg_87_1)

	local num = 4
	local new_array = Script.new_array(num)
	local peers = var_87_2.peers
	local count = #peers

	if num < count then
		table.dump(peers, "friend party peers")
		Crashify.print_exception("[PartyManager]", "Friend party stragglers found. Party size: %s", count)
	end

	for i = 1, count do
		local var_87_7 = peers[i]
		local num_2 = #new_array + 1

		if num < num_2 then
			print("Too many peers in the same party:", var_87_7)
		else
			new_array[num_2] = peers[i]
		end
	end

	return new_array
end

PartyManager.sync_friend_party_for_player = function (self, arg_88_1)
	-- function 88
	local assert = assert
	local DEDICATED_SERVER = DEDICATED_SERVER

	DEDICATED_SERVER = DEDICATED_SERVER or self._is_hosting_vs_custom_game

	assert(DEDICATED_SERVER)

	local var_88_2 = PEER_ID_TO_CHANNEL[arg_88_1]

	if not var_88_2 then
		local get_friend_party_id_from_peer = self:get_friend_party_id_from_peer(arg_88_1)
		local _collect_peers_from_friend_party = self:_collect_peers_from_friend_party(get_friend_party_id_from_peer)

		RPC.rpc_set_client_friend_party(var_88_2, _collect_peers_from_friend_party)
	end
end

PartyManager._server_set_client_friend_party = function (self, arg_89_1)
	-- function 89
	local _collect_peers_from_friend_party = self:_collect_peers_from_friend_party(arg_89_1)

	self:_server_send_rpc_to_friend_party("rpc_set_client_friend_party", arg_89_1, _collect_peers_from_friend_party)
end

PartyManager.server_get_friend_party_leaders = function (self, arg_90_1)
	-- function 90
	local tbl = {}
	local peer_id = Network.peer_id()

	if not self._friend_parties then
		return tbl
	end

	for k, v in pairs(self._friend_parties) do
		if not (not arg_90_1 and v.leader == peer_id) then
			tbl[#tbl + 1] = v.leader
		end
	end

	return tbl
end

PartyManager._server_send_rpc_to_friend_party = function (self, arg_91_1, arg_91_2, ...)
	-- function 91
	local var_91_0 = self._friend_parties[arg_91_2]

	if not var_91_0 then
		return
	end

	for k, v in pairs(var_91_0.peers) do
		local var_91_1 = PEER_ID_TO_CHANNEL[v]

		if not var_91_1 then
			RPC[arg_91_1](var_91_1, ...)
		end
	end
end

PartyManager.sync_friend_party_ids = function (self)
	-- function 92
	local tbl = {}
	local tbl_2 = {}
	local num = 0

	for k, v in pairs(self._friend_party_lookup) do
		num = num + 1
		tbl[num] = k
		tbl_2[num] = v
	end

	for k_2 = 1, self._num_friend_party_ids do
		if not self._friend_parties[k_2] then
			self:_server_send_rpc_to_friend_party("rpc_sync_friend_party_ids", k_2, tbl, tbl_2)
		end
	end
end

PartyManager.get_friend_party_id_from_peer = function (self, arg_93_1)
	-- function 93
	return self._friend_party_lookup[arg_93_1]
end

PartyManager._client_set_friend_party = function (self, arg_94_1)
	-- function 94
	self._client_friend_party = arg_94_1
end

PartyManager.rpc_sync_friend_party_ids = function (self, arg_95_1, arg_95_2, arg_95_3)
	-- function 95
	for i = 1, #arg_95_2 do
		self._friend_party_lookup[arg_95_2[i]] = arg_95_3[i]
	end

	local game_mechanism = Managers.mechanism:game_mechanism()
	local is_hosting_versus_custom_game = game_mechanism.is_hosting_versus_custom_game

	is_hosting_versus_custom_game = not is_hosting_versus_custom_game and game_mechanism:is_hosting_versus_custom_game()

	if is_hosting_versus_custom_game or not self._is_server then
		self:_send_rpc_to_clients("rpc_sync_friend_party_ids", arg_95_2, arg_95_3)
	end
end

PartyManager.client_get_friend_party = function (self)
	-- function 96
	return self._client_friend_party
end

PartyManager.client_is_friend_party_leader = function (self, arg_97_1)
	-- function 97
	local _client_friend_party = self._client_friend_party

	_client_friend_party = not _client_friend_party and self._client_friend_party[1] == arg_97_1

	return _client_friend_party
end
