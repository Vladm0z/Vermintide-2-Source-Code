-- chunkname: @scripts/managers/game_mode/versus_party_selection_logic.lua

local flag = false

VersusPartySelectionLogicUtility = {}

VersusPartySelectionLogicUtility.picker_index_is_bot = function (self, arg_1_1)
	-- function 1
	return self.picker_list[arg_1_1].status.is_bot ~= false
end

local tbl = {
	"rpc_set_party_array",
	"rpc_sync_player_loadout",
	"rpc_set_player_state",
	"rpc_set_party_state",
	"rpc_set_party_picking_id",
	"rpc_pre_game_sync_hovered_item",
	"rpc_set_party_selection_logic_timer",
	"rpc_party_select_request_pick_hero"
}

VersusPartySelectionLogic = class(VersusPartySelectionLogic)
VersusPartySelectionLogic.party_states = {
	startup = {
		enter = function (self, arg_2_1, arg_2_2)
			-- function 2
			local _picking_settings = self._picking_settings

			self:set_timer(_picking_settings.startup_time)
		end,
		run = function (self, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
			-- function 3
			if arg_3_3 <= 0 then
				local picker_list = arg_3_1.picker_list

				for i = 1, #picker_list do
					self:set_player_state("player_waiting_to_pick", arg_3_2.party_id, i)
				end

				return "player_picking_character"
			end
		end
	},
	player_picking_character = {
		enter = function (self, arg_4_1, arg_4_2)
			-- function 4
			local num = arg_4_1.current_picker_index + 1

			arg_4_1.current_picker_index = num

			self:_ensure_picker_has_character(arg_4_1, num, true)

			local player_pick_time = self._picking_settings.player_pick_time

			self:set_timer(player_pick_time)
			self:set_party_current_picker(arg_4_2.party_id, num)
			self:set_player_state("player_picking_character", arg_4_2.party_id, num)
		end,
		run = function (self, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
			-- function 5
			local current_picker_index = arg_5_1.current_picker_index

			self:_ensure_picker_has_character(arg_5_1, current_picker_index)

			if arg_5_3 <= 0 then
				return "player_has_picked_character"
			end
		end
	},
	player_has_picked_character = {
		enter = function (self, arg_6_1, arg_6_2)
			-- function 6
			local current_picker_index = arg_6_1.current_picker_index

			self:set_player_state("player_has_picked_character", arg_6_2.party_id, current_picker_index)
			self:_ensure_picker_has_character(arg_6_1, current_picker_index)
		end,
		run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
			-- function 7
			if arg_7_1.current_picker_index >= #arg_7_1.picker_list then
				return "parading"
			end

			return "player_picking_character"
		end
	},
	parading = {
		enter = function (self, arg_8_1, arg_8_2)
			-- function 8
			local parading_duration = Managers.state.game_mode:setting("character_picking_settings").parading_duration

			self:set_timer(parading_duration)

			for i = 1, #arg_8_1.picker_list do
				self:set_player_state("parading", arg_8_2.party_id, i)
			end
		end,
		run = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
			-- function 9
			if arg_9_3 <= 0 then
				return "closing"
			end
		end
	},
	closing = {
		enter = function (self, arg_10_1, arg_10_2)
			-- function 10
			local _picking_settings = self._picking_settings

			self:set_timer(_picking_settings.closing_time)

			for i = 1, #arg_10_1.picker_list do
				self:set_player_state("closing", arg_10_2.party_id, i)
			end
		end,
		run = function (self, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
			-- function 11
			if self._character_selection_completed or not self:_all_parties_have_picked() then
				Managers.state.event:unregister("on_player_left_party", arg_11_6)
				Managers.state.game_mode:game_mode():server_character_selection_completed()

				self._character_selection_completed = true
			end
		end
	}
}
VersusPartySelectionLogic.client_states = {
	startup = {
		enter = function (self, arg_12_1, arg_12_2)
			-- function 12
			self:set_party_timer(arg_12_1)
		end,
		run = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			-- function 13
			return
		end
	},
	player_waiting_to_pick = {
		enter = function (arg_14_0, arg_14_1, arg_14_2)
			-- function 14
			return
		end,
		run = function (self, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			-- function 15
			local prev_picker_index = arg_15_1.prev_picker_index
			local current_picker_index = arg_15_1.current_picker_index

			if prev_picker_index < current_picker_index then
				self:set_party_timer(arg_15_1)

				arg_15_1.prev_picker_index = current_picker_index
			end

			arg_15_1.slider_timer = arg_15_3
		end
	},
	player_picking_character = {
		enter = function (self, arg_16_1, arg_16_2)
			-- function 16
			arg_16_1.prev_picker_index = arg_16_1.current_picker_index

			self:set_party_timer(arg_16_1)
		end,
		run = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			-- function 17
			arg_17_1.slider_timer = arg_17_3
		end
	},
	player_has_picked_character = {
		enter = function (arg_18_0, arg_18_1, arg_18_2)
			-- function 18
			return
		end,
		run = function (self, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			-- function 19
			local prev_picker_index = arg_19_1.prev_picker_index
			local current_picker_index = arg_19_1.current_picker_index

			if prev_picker_index < current_picker_index then
				self:set_party_timer(arg_19_1)

				arg_19_1.prev_picker_index = current_picker_index
			end

			arg_19_1.slider_timer = arg_19_3
		end
	},
	parading = {
		enter = function (arg_20_0, arg_20_1, arg_20_2)
			-- function 20
			return
		end,
		run = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
			-- function 21
			return
		end
	},
	closing = {
		enter = function (arg_22_0, arg_22_1, arg_22_2)
			-- function 22
			arg_22_1.slider_timer = nil
		end,
		run = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			-- function 23
			return
		end
	}
}

local tbl_2 = {
	"startup",
	"player_waiting_to_pick",
	"player_picking_character",
	"player_has_picked_character",
	"parading",
	"closing",
	player_has_picked_character = 4,
	player_picking_character = 3,
	startup = 1,
	closing = 6,
	player_waiting_to_pick = 2,
	parading = 5
}

VersusPartySelectionLogicUtility.ClientStateLookup = tbl_2

VersusPartySelectionLogic.init = function (self, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	-- function 24
	self._timer_paused = false
	self._timer = 0
	self._timer_scale = 1

	local tbl = {}

	for k, v in pairs(VersusPartySelectionLogic.party_states) do
		local num = #tbl + 1

		tbl[num] = k
		tbl[k] = num
	end

	local tbl_2 = {}

	for k_2, v_2 in pairs(VersusPartySelectionLogic.client_states) do
		local num_2 = #tbl_2 + 1

		tbl_2[num_2] = k_2
		tbl_2[k_2] = num_2
	end

	self._party_states_lookup = tbl
	self._client_states_lookup = tbl_2
	self._is_server = arg_24_1
	self._network_server = arg_24_3

	if not arg_24_1 then
		self._profile_requester = arg_24_3:profile_requester()
	end

	self._profile_synchronizer = arg_24_4
	self._settings = arg_24_2
	self._picking_settings = arg_24_2.character_picking_settings
	self._timer = self._picking_settings.startup_time + GameSettings.transition_fade_out_speed
	self._pick_data_per_party = {}
	self._first_update = true
	self._party_data = nil
	self._party = nil

	self:_register_rpcs(arg_24_5, arg_24_6)

	if not arg_24_1 then
		Managers.state.event:register(self, "on_player_left_party", "on_player_left_party")
		self:_setup_picking_order()

		local human_players = Managers.player:human_players()

		for k_3, v_3 in pairs(human_players) do
			local network_id = v_3:network_id()

			self:_sync_party_array(network_id)
		end
	end
end

VersusPartySelectionLogic.pre_update = function (self, arg_25_1, arg_25_2)
	-- function 25
	if not DEDICATED_SERVER then
		self:_client_pre_update(arg_25_1, arg_25_2)
	end

	if not self._is_server then
		self:_server_pre_update(arg_25_1, arg_25_2)
	end
end

VersusPartySelectionLogic._server_pre_update = function (self, arg_26_1, arg_26_2)
	-- function 26
	local game_session = Network.game_session()
	local in_game_session = Managers.state.network:in_game_session()

	if not (not game_session and in_game_session) then
		return
	end

	local party_states = VersusPartySelectionLogic.party_states
	local _pick_data_per_party = self._pick_data_per_party
	local game_participating_parties = Managers.party:game_participating_parties()
	local tbl = {}

	if not self._first_update then
		for i = 1, #_pick_data_per_party do
			local var_26_6 = game_participating_parties[i]
			local var_26_7 = _pick_data_per_party[i]
			local enter = party_states[var_26_7.state].enter

			if not enter then
				enter(self, var_26_7, var_26_6)
			end
		end

		if not DEDICATED_SERVER then
			self._first_update = false
		end
	end

	for j = 1, #_pick_data_per_party do
		local var_26_9 = game_participating_parties[j]
		local var_26_10 = _pick_data_per_party[j]

		tbl[j] = party_states[var_26_10.state].run(self, var_26_10, var_26_9, self._timer, arg_26_1, arg_26_2, self)
	end

	for k, v in pairs(tbl) do
		local var_26_11 = game_participating_parties[k]
		local var_26_12 = _pick_data_per_party[k]
		local var_26_13 = self._party_states_lookup[v]

		self._network_transmit:send_rpc_clients("rpc_set_party_state", k, var_26_13)

		local leave = party_states[var_26_12.state].leave

		if not leave then
			leave(self, var_26_12, var_26_11)
		end

		local enter_2 = party_states[v].enter

		if not enter_2 then
			enter_2(self, var_26_12, var_26_11)
		end

		var_26_12.state = v
	end

	if not self._timer_paused then
		return
	end

	self._timer = math.max(self._timer - arg_26_2, 0)
end

VersusPartySelectionLogic._client_pre_update = function (self, arg_27_1, arg_27_2)
	-- function 27
	if not Network.game_session() then
		return
	end

	local _local_party_data, var_27_1, var_27_2 = self:_local_party_data()

	if not _local_party_data then
		return
	end

	local client_states = VersusPartySelectionLogic.client_states
	local state = _local_party_data.picker_list[var_27_2].state

	if not self._first_update then
		local enter = client_states[state].enter

		if not enter then
			enter(self, _local_party_data, var_27_1)
		end

		self._first_update = false
	end

	client_states[state].run(self, _local_party_data, var_27_1, self._timer, arg_27_1, arg_27_2)

	if not self._is_server then
		return
	end

	if not self._timer_paused then
		return
	end

	self._timer = math.max(self._timer - arg_27_2, 0)
end

VersusPartySelectionLogic._local_party_data = function (self)
	-- function 28
	if not DEDICATED_SERVER then
		return nil, nil, nil
	end

	if not self._party_data then
		local get_num_game_participating_parties = Managers.party:get_num_game_participating_parties()

		if #self._pick_data_per_party ~= get_num_game_participating_parties then
			return
		end

		local party = Managers.party
		local local_player = Managers.player:local_player()
		local unique_id = local_player:unique_id()
		local get_party_from_unique_id = party:get_party_from_unique_id(unique_id)
		local var_28_5 = self._pick_data_per_party[get_party_from_unique_id.party_id]

		if not var_28_5 then
			return
		end

		self._local_player = local_player
		self._party_data = var_28_5
		self._party = get_party_from_unique_id

		local picker_list = self._party_data.picker_list

		for i, v in ipairs(picker_list) do
			v.status = get_party_from_unique_id.slots[v.slot_id]

			local player = v.status.player

			if not player and not player.local_player then
				self._picker_list_id = i

				break
			end
		end
	end

	return self._party_data, self._party, self._picker_list_id
end

VersusPartySelectionLogic.destroy = function (self)
	-- function 29
	table.clear(self._party_states_lookup)
	table.clear(self._client_states_lookup)
	self:_unregister_rpcs()
end

VersusPartySelectionLogic._register_rpcs = function (self, arg_30_1, arg_30_2)
	-- function 30
	arg_30_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_30_1
	self._network_transmit = arg_30_2
end

VersusPartySelectionLogic._unregister_rpcs = function (self)
	-- function 31
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

VersusPartySelectionLogic.set_ingame_ui = function (self, arg_32_1)
	-- function 32
	self._ingame_ui = arg_32_1
end

VersusPartySelectionLogic.hot_join_sync = function (self, arg_33_1)
	-- function 33
	self:_sync_party_array(arg_33_1)

	local _pick_data_per_party = self._pick_data_per_party

	for i = 1, #_pick_data_per_party do
		local var_33_1 = _pick_data_per_party[i]
		local party_id = var_33_1.party_id
		local var_33_3 = self._party_states_lookup[var_33_1.state]
		local picker_list = var_33_1.picker_list

		for j = 1, #picker_list do
			local var_33_5 = picker_list[j]
			local picker_index = var_33_5.picker_index
			local var_33_7 = self._client_states_lookup[var_33_5.state]

			self._network_transmit:send_rpc("rpc_set_party_state", arg_33_1, party_id, var_33_3)

			local var_33_8
			local var_33_9

			if tbl_2[var_33_5.state] >= tbl_2.player_picking_character then
				local slot_id = var_33_5.slot_id

				if not VersusPartySelectionLogicUtility.picker_index_is_bot(var_33_1, slot_id) then
					var_33_8, var_33_9 = self._profile_synchronizer:get_bot_profile(party_id, slot_id)
				elseif not var_33_5.status.peer_id and not var_33_5.status.local_player_id then
					var_33_8, var_33_9 = Managers.mechanism:game_mechanism():update_wanted_hero_character(var_33_5.status.peer_id, var_33_5.status.local_player_id, party_id)
				else
					Crashify.print_exception("VersusPartySelectionLogic", "Supposed human player missing peer_id and local_player_id. Party: %s, pick id: %s", party_id, picker_index)
				end
			end

			if not var_33_8 then
				local var_33_11 = Managers.party:get_party(party_id).slots_data[var_33_5.slot_id]
				local status = picker_list[picker_index].status
				local slot_melee = var_33_11.slot_melee
				local slot_ranged = var_33_11.slot_ranged
				local slot_skin = var_33_11.slot_skin
				local slot_hat = var_33_11.slot_hat
				local slot_frame = var_33_11.slot_frame
				local var_33_18 = NetworkLookup.item_names[slot_melee or "n/a"]
				local var_33_19 = NetworkLookup.item_names[slot_ranged or "n/a"]
				local var_33_20 = NetworkLookup.item_names[slot_skin or "n/a"]
				local var_33_21 = NetworkLookup.item_names[slot_hat or "n/a"]
				local var_33_22 = NetworkLookup.item_names[slot_frame or "n/a"]
				local level = status.level
				local versus_level = status.versus_level

				self._network_transmit:send_rpc("rpc_sync_player_loadout", arg_33_1, party_id, picker_index, var_33_8, var_33_9, var_33_18, var_33_19, var_33_20, var_33_21, var_33_22, level, versus_level)
			end

			self._network_transmit:send_rpc("rpc_set_player_state", arg_33_1, var_33_7, party_id, picker_index)
		end
	end

	if self._timer > 0 then
		local num = Managers.state.network:network_time() + self._timer

		self._network_transmit:send_rpc("rpc_set_party_selection_logic_timer", arg_33_1, self._timer, num)
	end
end

VersusPartySelectionLogic.get_party_data = function (self, arg_34_1)
	-- function 34
	local _pick_data_per_party = self._pick_data_per_party

	return not _pick_data_per_party and _pick_data_per_party[arg_34_1]
end

VersusPartySelectionLogic.set_player_state = function (self, arg_35_1, arg_35_2, arg_35_3)
	-- function 35
	if not self._is_server then
		local var_35_0 = self._client_states_lookup[arg_35_1]

		self._network_transmit:send_rpc_clients("rpc_set_player_state", var_35_0, arg_35_2, arg_35_3)
	end

	local var_35_1 = self._pick_data_per_party[arg_35_2]
	local var_35_2 = var_35_1.picker_list[arg_35_3]

	if not DEDICATED_SERVER then
		local _local_party_data, var_35_4, var_35_5 = self:_local_party_data()

		if not (arg_35_3 ~= var_35_5 or arg_35_2 ~= var_35_4.party_id) then
			local enter = VersusPartySelectionLogic.client_states[arg_35_1].enter

			if not enter then
				enter(self, var_35_1, var_35_4)
			end
		end
	end

	var_35_2.state = arg_35_1

	Managers.state.event:trigger("party_selection_logic_state_set", arg_35_1, arg_35_2, arg_35_3)
end

VersusPartySelectionLogic.set_party_current_picker = function (self, arg_36_1, arg_36_2)
	-- function 36
	self._network_transmit:send_rpc_clients("rpc_set_party_picking_id", arg_36_1, arg_36_2)

	if not DEDICATED_SERVER then
		self._pick_data_per_party[arg_36_1].current_picker_index = arg_36_2
	end
end

VersusPartySelectionLogic.set_timer = function (self, arg_37_1)
	-- function 37
	self._timer = arg_37_1

	if not self._is_server then
		self._current_timer_total = arg_37_1

		local num = Managers.state.network:network_time() + arg_37_1

		self._network_transmit:send_rpc_clients("rpc_set_party_selection_logic_timer", arg_37_1, num)
	end
end

VersusPartySelectionLogic._make_available_profile_lookup = function (arg_38_0, arg_38_1, arg_38_2)
	-- function 38
	local tbl = {}

	for i = 1, #SPProfiles do
		local var_38_1 = SPProfiles[i]

		if not (var_38_1.affiliation ~= arg_38_1 or var_38_1.role ~= arg_38_2) then
			local get_character_level = ExperienceSettings.get_character_level(var_38_1.display_name)
			local tbl_2 = {}

			for j = 1, #var_38_1.careers do
				if not var_38_1.careers[j]:is_unlocked_function(var_38_1.display_name, get_character_level) then
					tbl_2[#tbl_2 + 1] = j
				end
			end

			if #tbl_2 > 0 then
				tbl[var_38_1.index] = tbl_2
			end
		end
	end

	fassert(not table.is_empty(tbl) and arg_38_1 == "spectators", "Failed to find any available profiles for " .. arg_38_1)

	return tbl
end

VersusPartySelectionLogic.get_character_or_random = function (self, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	-- function 39
	if not (not arg_39_1 and not arg_39_2 and self:_is_hero_locked(arg_39_1, arg_39_3)) then
		return arg_39_1, arg_39_2
	end

	return self:get_random_available_character(arg_39_3, arg_39_4)
end

VersusPartySelectionLogic.get_random_available_character = function (self, arg_40_1, arg_40_2)
	-- function 40
	local _random_profile_indices = self._random_profile_indices

	_random_profile_indices = _random_profile_indices or table.select_map(SPProfiles, function (arg_41_0, arg_41_1)
		-- function 41
		if arg_41_1.affiliation == "heroes" then
			return arg_41_1.index
		end
	end)
	self._random_profile_indices = _random_profile_indices

	table.shuffle(_random_profile_indices)

	local _random_career_indices = self._random_career_indices

	_random_career_indices = _random_career_indices or {
		1,
		2,
		3
	}
	self._random_career_indices = _random_career_indices

	table.shuffle(_random_career_indices)

	local var_40_2
	local var_40_3

	for i = 1, #_random_profile_indices do
		for j = 1, #_random_career_indices do
			local var_40_4 = _random_profile_indices[i]
			local var_40_5 = _random_career_indices[j]
			local name = SPProfiles[i].careers[j].name

			if not (not PlayerUtils.get_career_override(name) and self:_is_hero_locked(var_40_4, arg_40_1)) then
				var_40_2, var_40_3 = var_40_4, var_40_5

				break
			end
		end

		if not var_40_2 and not var_40_3 then
			break
		end
	end

	if not (not var_40_2 and var_40_3) then
		var_40_2, var_40_3 = 1, 1

		table.dump(arg_40_1, "party_data", 3)
		Crashify.print_exception("VersusPartySelectionLogic", "Could not find an available profile.")
	end

	return var_40_2, var_40_3
end

VersusPartySelectionLogic._is_hero_locked = function (self, arg_42_1, arg_42_2, arg_42_3)
	-- function 42
	if not self._settings.duplicate_hero_careers_allowed then
		return false
	end

	if not (not arg_42_1 and arg_42_1 ~= 0) then
		return true
	end

	local party_id = arg_42_2.party_id
	local get_profile_index_reservation = self._profile_synchronizer:get_profile_index_reservation(party_id, arg_42_1)

	if not (not get_profile_index_reservation and get_profile_index_reservation == arg_42_3) then
		return true
	end

	local picker_list = arg_42_2.picker_list

	for i = 1, #picker_list do
		local var_42_3 = picker_list[i]

		if not (var_42_3.state ~= "player_has_picked_character" or var_42_3.status.profile_index ~= arg_42_1 or var_42_3.picker_index == arg_42_2.current_picker_index) then
			return true
		end
	end

	return false
end

VersusPartySelectionLogic._ensure_picker_has_character = function (self, arg_43_1, arg_43_2, arg_43_3)
	-- function 43
	local _peer_from_picker_data, var_43_1, var_43_2 = self:_peer_from_picker_data(arg_43_1, arg_43_2)
	local party_id = arg_43_1.party_id
	local var_43_4
	local var_43_5

	if not VersusPartySelectionLogicUtility.picker_index_is_bot(arg_43_1, arg_43_2) then
		var_43_4, var_43_5 = self._profile_synchronizer:get_bot_profile(party_id, var_43_2)
	else
		var_43_4, var_43_5 = Managers.mechanism:game_mechanism():update_wanted_hero_character(_peer_from_picker_data, var_43_1, party_id)
	end

	local _try_pick_hero, var_43_7 = self:_try_pick_hero(arg_43_1, arg_43_2, var_43_4, var_43_5)

	if not arg_43_3 then
		self:sync_player_loadout(_try_pick_hero, var_43_7, party_id, arg_43_2)
	end

	return _try_pick_hero, var_43_7
end

VersusPartySelectionLogic._peer_from_picker_data = function (arg_44_0, arg_44_1, arg_44_2)
	-- function 44
	local var_44_0 = arg_44_1.picker_list[arg_44_2]
	local status = var_44_0.status

	return status.peer_id, status.local_player_id, var_44_0.slot_id
end

VersusPartySelectionLogic._is_hero_party = function (arg_45_0, arg_45_1)
	-- function 45
	return Managers.party:get_party(arg_45_1).name == "heroes"
end

VersusPartySelectionLogic.select_character = function (self, arg_46_1, arg_46_2)
	-- function 46
	assert(not arg_46_1 and arg_46_2, "[VersusPartySelectionLogic] Selecting non-character")

	local _local_party_data = self:_local_party_data()
	local current_picker_index = _local_party_data.current_picker_index

	if _local_party_data.picker_list[current_picker_index].status.peer_id ~= Network.peer_id() then
		return
	end

	self._network_transmit:send_rpc_server("rpc_party_select_request_pick_hero", _local_party_data.party_id, current_picker_index, arg_46_1, arg_46_2)
end

VersusPartySelectionLogic._sync_hovered_item = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	-- function 47
	local get_status_from_unique_id = Managers.party:get_status_from_unique_id(arg_47_1 .. ":" .. arg_47_2)

	if not get_status_from_unique_id then
		get_status_from_unique_id.hovered_profile_index = arg_47_3
		get_status_from_unique_id.hovered_career_index = arg_47_4
	end
end

VersusPartySelectionLogic.sync_hovered_item = function (self, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	-- function 48
	self:_sync_hovered_item(arg_48_1, arg_48_2, arg_48_3, arg_48_4)

	if not (not Managers.state.network and Managers.state.network:game()) then
		return
	end

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_pre_game_sync_hovered_item", arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	else
		self._network_transmit:send_rpc_server("rpc_pre_game_sync_hovered_item", arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	end
end

VersusPartySelectionLogic.set_party_timer = function (self, arg_49_1)
	-- function 49
	local num = self._picking_settings.player_pick_time * arg_49_1.current_picker_index

	arg_49_1.slider_timer = num
	arg_49_1.time_finished = num
end

local function fn(self, arg_50_1)
	-- function 50
	local tbl = {}
	local slots = self.slots
	local slots_data = self.slots_data
	local num = 0

	for i = 1, self.num_slots do
		local var_50_4 = slots[i]

		if not var_50_4.is_player and not var_50_4.peer_id then
			num = num + 1
			tbl[num] = {
				is_connected = true,
				state = "startup",
				is_bot = false,
				slot_id = i,
				status = var_50_4
			}
		end
	end

	if arg_50_1 == "players_first" then
		table.shuffle(tbl)
	end

	for j = 1, self.num_slots do
		local var_50_5 = slots[j]

		if not (var_50_5.is_bot or var_50_5.peer_id) then
			num = num + 1
			tbl[num] = {
				is_connected = true,
				state = "startup",
				is_bot = true,
				slot_id = j,
				status = var_50_5
			}
		end
	end

	if arg_50_1 == "mix_all" then
		table.shuffle(tbl)
	end

	for k = 1, self.num_slots do
		local var_50_6 = tbl[k]

		var_50_6.picker_index = k
		slots_data[var_50_6.slot_id].player_data_id = k
	end

	return tbl
end

VersusPartySelectionLogic._setup_picking_order = function (self)
	-- function 51
	local setting = Managers.state.game_mode:setting("shuffle_character_picking_order")
	local _pick_data_per_party = self._pick_data_per_party
	local game_participating_parties = Managers.party:game_participating_parties()

	for i = 1, #game_participating_parties do
		local var_51_3 = game_participating_parties[i]
		local var_51_4 = fn(var_51_3, setting, true)

		_pick_data_per_party[i] = {
			current_picker_index = 0,
			state = "startup",
			picker_list = var_51_4,
			party_id = i
		}
	end
end

VersusPartySelectionLogic._sync_party_array = function (self, arg_52_1)
	-- function 52
	local _pick_data_per_party = self._pick_data_per_party

	for i, v in ipairs(_pick_data_per_party) do
		local picker_list = v.picker_list
		local tbl = {}

		for k = 1, #picker_list do
			tbl[k] = picker_list[k].slot_id
		end

		local current_picker_index = v.current_picker_index

		self._network_transmit:send_rpc("rpc_set_party_array", arg_52_1, i, tbl, current_picker_index)
	end
end

VersusPartySelectionLogic.sync_player_loadout = function (self, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	-- function 53
	local _local_party_data, var_53_1, var_53_2 = self:_local_party_data()
	local flag = (not var_53_1 and var_53_1.party_id) ~= arg_53_3 or var_53_2 == arg_53_4
	local var_53_4 = self._pick_data_per_party[arg_53_3]
	local picker_index_is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(var_53_4, arg_53_4)
	local var_53_6
	local var_53_7
	local var_53_8
	local var_53_9
	local var_53_10
	local var_53_11
	local var_53_12

	if not arg_53_1 and (not (arg_53_1 > 0) or flag or not self._is_server or not picker_index_is_bot) then
		var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12 = self:_get_loadout(arg_53_1, arg_53_2, picker_index_is_bot)

		local _peer_from_picker_data, var_53_14 = self:_peer_from_picker_data(var_53_4, arg_53_4)
		local _is_hero_party = self:_is_hero_party(arg_53_3)

		_is_hero_party = not _is_hero_party and var_53_14

		if not _is_hero_party then
			local player = Managers.player:player(_peer_from_picker_data, var_53_14)

			CosmeticUtils.sync_local_player_cosmetics(player, arg_53_1, arg_53_2)
		end
	else
		var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12 = 1, 1, 1, 1, 1, 1, 0
	end

	self:_set_loadout(arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)

	if not self._is_server then
		self._network_transmit:send_rpc_clients("rpc_sync_player_loadout", arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)
	else
		self._network_transmit:send_rpc_server("rpc_sync_player_loadout", arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)
	end
end

VersusPartySelectionLogic._set_loadout = function (self, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9, arg_54_10, arg_54_11)
	-- function 54
	local get_party = Managers.party:get_party(arg_54_1)
	local var_54_1 = self._pick_data_per_party[arg_54_1].picker_list[arg_54_2]
	local status = var_54_1.status

	status.selected_profile_index = arg_54_3
	status.selected_career_index = arg_54_4
	status.profile_index = arg_54_3
	status.career_index = arg_54_4
	status.level = arg_54_10
	status.versus_level = arg_54_11

	local var_54_3 = get_party.slots_data[var_54_1.slot_id]

	var_54_3.slot_melee = NetworkLookup.item_names[arg_54_5]
	var_54_3.slot_ranged = NetworkLookup.item_names[arg_54_6]
	var_54_3.slot_skin = NetworkLookup.item_names[arg_54_7]
	var_54_3.slot_hat = NetworkLookup.item_names[arg_54_8]
	var_54_3.slot_frame = NetworkLookup.item_names[arg_54_9]
end

VersusPartySelectionLogic._get_loadout = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	-- function 55
	local var_55_0 = SPProfiles[arg_55_1]
	local display_name = var_55_0.display_name
	local var_55_2 = var_55_0.careers[arg_55_2]
	local display_name_2 = var_55_2.display_name
	local item_slot_types_by_slot_name = var_55_2.item_slot_types_by_slot_name
	local get_loadout_item = BackendUtils.get_loadout_item
	local slot_melee = item_slot_types_by_slot_name.slot_melee

	slot_melee = not slot_melee and get_loadout_item(display_name_2, "slot_melee")

	local slot_ranged = item_slot_types_by_slot_name.slot_ranged

	slot_ranged = not slot_ranged and get_loadout_item(display_name_2, "slot_ranged")

	local slot_skin = item_slot_types_by_slot_name.slot_skin

	slot_skin = not slot_skin and get_loadout_item(display_name_2, "slot_skin")

	local slot_hat = item_slot_types_by_slot_name.slot_hat

	slot_hat = not slot_hat and get_loadout_item(display_name_2, "slot_hat")

	local slot_frame = item_slot_types_by_slot_name.slot_frame

	slot_frame = not slot_frame and get_loadout_item(display_name_2, "slot_frame")

	local var_55_11

	if not slot_melee then
		var_55_11 = NetworkLookup.item_names[slot_melee.key]

		if not var_55_11 then
			-- Nothing
		end
	end

	var_55_11 = 1

	do
		local var_55_12
	end

	::label_55_0::

	if not slot_ranged then
		var_55_12 = NetworkLookup.item_names[slot_ranged.key]

		if not var_55_12 then
			-- Nothing
		end
	end

	var_55_12 = 1

	do
		local var_55_13
	end

	::label_55_1::

	if not slot_skin then
		var_55_13 = NetworkLookup.item_names[slot_skin.key]

		if not var_55_13 then
			-- Nothing
		end
	end

	var_55_13 = 1

	do
		local var_55_14
	end

	::label_55_2::

	if not slot_hat then
		var_55_14 = NetworkLookup.item_names[slot_hat.key]

		if not var_55_14 then
			-- Nothing
		end
	end

	var_55_14 = 1

	do
		local var_55_15
	end

	::label_55_3::

	if not slot_hat then
		var_55_15 = NetworkLookup.item_names[slot_frame.key]

		if not var_55_15 then
			-- Nothing
		end
	end

	var_55_15 = 1

	::label_55_4::

	local get = Managers.backend:get_interface("hero_attributes"):get(display_name, "experience")
	local get_level = ExperienceSettings.get_level(get)
	local flag

	flag = not arg_55_3 and 0 and ExperienceSettings.get_versus_level()

	return var_55_11, var_55_12, var_55_13, var_55_14, var_55_15, get_level, flag
end

VersusPartySelectionLogic.settings = function (self)
	-- function 56
	return self._settings
end

VersusPartySelectionLogic._all_parties_have_picked = function (self)
	-- function 57
	local _pick_data_per_party = self._pick_data_per_party

	for i = 2, #_pick_data_per_party do
		if _pick_data_per_party[i].state ~= "closing" then
			return false
		end
	end

	if not Managers.state.network.profile_synchronizer:all_synced() then
		return false
	end

	return true
end

VersusPartySelectionLogic.player_joined_party = function (self, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	-- function 58
	if arg_58_3 == 0 then
		return
	end

	if not self._pick_data_per_party then
		return
	end

	local get_party = Managers.party:get_party(arg_58_3)
	local var_58_1 = self._pick_data_per_party[arg_58_3]
	local picker_list = var_58_1.picker_list
	local var_58_3

	for i = 1, #picker_list do
		if picker_list[i].slot_id == arg_58_4 then
			var_58_3 = i

			break
		end
	end

	fassert(var_58_3 ~= nil, "Failed to find slot id")

	local var_58_4 = picker_list[var_58_3]

	fassert(var_58_4.is_bot ~= false, "Tried to replace human player. Expected to replace bot")

	local var_58_5 = get_party.slots[arg_58_4]
	local status = var_58_4.status

	var_58_4.status = var_58_5
	var_58_4.is_bot = false

	if not self._is_server then
		return
	end

	printf("[VersusPartySelectionLogic] Peer %s joined party %s with pick order %s (state: %s)", arg_58_1, arg_58_3, var_58_3, var_58_4.state)

	if tbl_2[var_58_4.state] >= tbl_2.player_picking_character then
		local _ensure_picker_has_character, var_58_8 = self:_ensure_picker_has_character(var_58_1, var_58_3, true)

		printf("[VersusPartySelectionLogic] Peer %s in party %s hot joined and was delegated %s", var_58_5.peer_id, arg_58_3, SPProfiles[_ensure_picker_has_character].careers[var_58_8].display_name)
	end
end

VersusPartySelectionLogic.player_left_party = function (self, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5)
	-- function 59
	if arg_59_3 == 0 then
		return
	end

	local get_party = Managers.party:get_party(arg_59_3)
	local var_59_1 = self._pick_data_per_party[arg_59_3]
	local picker_list = var_59_1.picker_list
	local var_59_3

	for i = 1, #picker_list do
		if picker_list[i].slot_id == arg_59_4 then
			var_59_3 = i

			break
		end
	end

	fassert(var_59_3 ~= nil, "Failed to find slot id")

	local var_59_4 = picker_list[var_59_3]

	var_59_4.is_bot = nil
	var_59_4.status = get_party.slots[arg_59_4]

	if not self._is_server then
		return
	end

	if tbl_2[var_59_4.state] >= tbl_2.player_picking_character then
		local _ensure_picker_has_character, var_59_6 = self:_ensure_picker_has_character(var_59_1, var_59_3, true)
		local status = arg_59_5.status

		status = not status and arg_59_5.status.peer_id

		printf("[VersusPartySelectionLogic] %s in party %s and pick id %s left and was replaced by %s", status or "UNKNOWN", get_party.party_id, var_59_3, SPProfiles[_ensure_picker_has_character].careers[var_59_6].display_name)
	end
end

VersusPartySelectionLogic._try_pick_hero = function (self, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
	-- function 60
	local party_id = arg_60_1.party_id
	local picker_index_is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(arg_60_1, arg_60_2)
	local _peer_from_picker_data, var_60_3, var_60_4 = self:_peer_from_picker_data(arg_60_1, arg_60_2)
	local var_60_5
	local var_60_6

	if not picker_index_is_bot then
		var_60_5, var_60_6 = self._profile_synchronizer:get_bot_profile(party_id, var_60_4)
	else
		var_60_5, var_60_6 = Managers.mechanism:get_persistent_profile_index_reservation(_peer_from_picker_data)
	end

	if not self:_is_hero_locked(var_60_5, arg_60_1, _peer_from_picker_data) then
		var_60_5, var_60_6 = nil
	end

	repeat
		if not (not var_60_5 and not var_60_6 and arg_60_3 ~= var_60_5 or arg_60_4 ~= var_60_6) then
			break
		end

		local state = arg_60_1.picker_list[arg_60_2].state
		local flag = tbl_2[state] > tbl_2.player_picking_character

		if not var_60_5 and not flag then
			local printf = printf
			local str = "[VersusPartySelectionLogic] %s %s in party %s and pick id %s tried to pick a hero %s %s after timer ran out. Staying as %s %s"
			local flag_2

			flag_2 = not picker_index_is_bot and "BOT in slot" and "Peer"

			printf(str, flag_2, not picker_index_is_bot and arg_60_2 and _peer_from_picker_data, party_id, arg_60_2, arg_60_3, arg_60_4, var_60_5, var_60_6)

			arg_60_3 = var_60_5
			arg_60_4 = var_60_6

			break
		end

		arg_60_5 = true

		if not (not arg_60_3 and not arg_60_4 and arg_60_3 == 0 or arg_60_4 ~= 0) then
			arg_60_3, arg_60_4 = self:get_character_or_random(arg_60_3, arg_60_4, arg_60_1, picker_index_is_bot)

			local printf_2 = printf
			local str_2 = "[VersusPartySelectionLogic] No profile provided for %s %s. Fallbacking to %s %s."
			local flag_3

			flag_3 = not picker_index_is_bot and "BOT in slot" and "Peer"

			printf_2(str_2, flag_3, not picker_index_is_bot and arg_60_2 and _peer_from_picker_data, arg_60_3, arg_60_4)
		elseif not self:_is_hero_locked(arg_60_3, arg_60_1, _peer_from_picker_data) then
			local var_60_15 = arg_60_3
			local var_60_16 = arg_60_4

			arg_60_3, arg_60_4 = self:get_character_or_random(arg_60_3, arg_60_4, arg_60_1, picker_index_is_bot)

			local printf_3 = printf
			local str_3 = "[VersusPartySelectionLogic] %s %s tried to pick locked hero %s %s. Fallbacking to %s %s."
			local flag_4

			flag_4 = not picker_index_is_bot and "BOT in slot" and "Peer"

			printf_3(str_3, flag_4, not picker_index_is_bot and arg_60_2 and _peer_from_picker_data, var_60_15, var_60_16, arg_60_3, arg_60_4)
		end

		if not picker_index_is_bot then
			self._profile_synchronizer:set_bot_profile(party_id, var_60_4, arg_60_3, arg_60_4)

			break
		end

		if not Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(_peer_from_picker_data, arg_60_3, arg_60_4, true) then
			Crashify.print_exception("VersusPartySelectionLogic", "gave peer %s in party %s hero %s, but could not reserve it", _peer_from_picker_data, party_id, arg_60_3)

			arg_60_3 = var_60_5
			arg_60_4 = var_60_6
		end
	until true

	if not arg_60_5 then
		self:sync_player_loadout(arg_60_3, arg_60_4, party_id, arg_60_2)
	end

	return arg_60_3, arg_60_4
end

VersusPartySelectionLogic.rpc_party_select_request_pick_hero = function (self, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5)
	-- function 61
	local var_61_0 = self._pick_data_per_party[arg_61_2]
	local _try_pick_hero, var_61_2 = self:_try_pick_hero(var_61_0, arg_61_3, arg_61_4, arg_61_5)
	local flag

	flag = _try_pick_hero ~= arg_61_4 or not " and succeeded" or string.format(", but got hero %s %s", _try_pick_hero, var_61_2)

	printf("[VersusPartySelectionLogic] Peer %s in party %s tried to pick hero %s %s%s", CHANNEL_TO_PEER_ID[arg_61_1], arg_61_2, arg_61_4, arg_61_5, flag)
end

VersusPartySelectionLogic.rpc_set_party_array = function (self, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	-- function 62
	local get_party = Managers.party:get_party(arg_62_2)
	local slots = get_party.slots
	local tbl = {}

	for i = 1, #arg_62_3 do
		local var_62_3 = arg_62_3[i]
		local var_62_4 = slots[var_62_3]

		tbl[i] = {
			state = "startup",
			picker_index = i,
			slot_id = var_62_3,
			status = var_62_4
		}
	end

	local var_62_5

	if not self._pick_data_per_party then
		var_62_5 = self._pick_data_per_party[arg_62_2]
	end

	if not var_62_5 then
		var_62_5 = {
			current_picker_index = 0,
			state = "startup",
			picker_list = tbl,
			party_id = arg_62_2
		}
		self._pick_data_per_party[arg_62_2] = var_62_5
	end

	local player_pick_time = GameModeSettings.versus.character_picking_settings.player_pick_time
	local num_slots = get_party.num_slots

	var_62_5.current_picker_index = arg_62_4
	var_62_5.prev_picker_index = arg_62_4 - 1
	var_62_5.total_slider_time = player_pick_time * num_slots
end

VersusPartySelectionLogic.rpc_set_party_state = function (self, arg_63_1, arg_63_2, arg_63_3)
	-- function 63
	self._pick_data_per_party[arg_63_2].state = self._party_states_lookup[arg_63_3]
end

VersusPartySelectionLogic.rpc_sync_player_loadout = function (self, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	-- function 64
	local var_64_0 = CHANNEL_TO_PEER_ID[arg_64_1]

	if not var_64_0 then
		return
	end

	if not self._is_server then
		local var_64_1 = self._pick_data_per_party[arg_64_2]

		if not VersusPartySelectionLogicUtility.picker_index_is_bot(var_64_1, arg_64_3) then
			return
		end

		local var_64_2 = var_64_1.picker_list[arg_64_3]
		local state = var_64_2.state
		local status = var_64_2.status

		if not (not (tbl_2[state] > tbl_2.player_picking_character) or status.selected_profile_index ~= arg_64_4 or status.selected_career_index == arg_64_5) then
			print("[VersusPartySelectionLogic] Client tried to change loadout of a different character after a character has already been picked. Bouncing back request.")

			local get_persistent_profile_index_reservation, var_64_6 = Managers.mechanism:get_persistent_profile_index_reservation(status.peer_id)

			self._network_transmit:send_rpc("rpc_sync_player_loadout", var_64_0, arg_64_2, arg_64_3, get_persistent_profile_index_reservation, var_64_6, 1, 1, 1, 1, 1, 1, 0)

			return
		end

		self._network_transmit:send_rpc_clients_except("rpc_sync_player_loadout", var_64_0, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	end

	local _local_party_data, var_64_8, var_64_9 = self:_local_party_data()
	local flag = not var_64_8 and var_64_8.party_id

	if not (flag ~= arg_64_2 or var_64_9 ~= arg_64_3) then
		print("[VersusPartySelectionLogic] Local player was assigned to", arg_64_4, arg_64_5)
		self:sync_player_loadout(arg_64_4, arg_64_5, flag, var_64_9)
	else
		self:_set_loadout(arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	end
end

VersusPartySelectionLogic.rpc_set_player_state = function (self, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	-- function 65
	fassert(not self._is_server, "Server should never get this")

	local var_65_0 = self._client_states_lookup[arg_65_2]

	self:set_player_state(var_65_0, arg_65_3, arg_65_4)
end

VersusPartySelectionLogic.rpc_set_party_picking_id = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	-- function 66
	arg_66_0._pick_data_per_party[arg_66_2].current_picker_index = arg_66_3
end

VersusPartySelectionLogic.rpc_pre_game_sync_hovered_item = function (self, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	-- function 67
	self:_sync_hovered_item(arg_67_2, arg_67_3, arg_67_4, arg_67_5)

	if not self._is_server then
		local var_67_0 = CHANNEL_TO_PEER_ID[arg_67_1]

		self._network_transmit:send_rpc_clients_except("rpc_pre_game_sync_hovered_item", var_67_0, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	end
end

VersusPartySelectionLogic.timer = function (self)
	-- function 68
	return self._timer
end

VersusPartySelectionLogic.on_player_left_party = function (self, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	-- function 69
	if not self._peers_ready then
		self._peers_ready[arg_69_1] = nil
	end

	local var_69_0 = self._pick_data_per_party[arg_69_3]

	if not var_69_0 then
		local picker_list = var_69_0.picker_list

		for i = 1, #picker_list do
			if picker_list[i].slot_id == arg_69_4 then
				picker_list[i].is_connected = false
			end
		end
	end
end

VersusPartySelectionLogic.rpc_set_party_selection_logic_timer = function (self, arg_70_1, arg_70_2, arg_70_3)
	-- function 70
	local network_time = Managers.state.network:network_time()

	if network_time == 0 then
		network_time = arg_70_3 - arg_70_2
	end

	self._timer_scale = (arg_70_3 - network_time) / arg_70_2
	self._timer = arg_70_2
end
