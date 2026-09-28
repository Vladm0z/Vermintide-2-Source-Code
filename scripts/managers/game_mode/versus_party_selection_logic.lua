-- chunkname: @scripts/managers/game_mode/versus_party_selection_logic.lua

local DRAW_DEBUG = false

VersusPartySelectionLogicUtility = {}

VersusPartySelectionLogicUtility.picker_index_is_bot = function (party_data, picker_index)
	-- function 1
	local is_bot = party_data.picker_list[picker_index].status.is_bot

	return is_bot ~= false
end

local RPCS = {
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
		enter = function (parent, party_data, party)
			-- function 2
			local picking_settings = parent._picking_settings

			parent:set_timer(picking_settings.startup_time)
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 3
			if timer <= 0 then
				local picker_list = party_data.picker_list

				for i = 1, #picker_list do
					parent:set_player_state("player_waiting_to_pick", party.party_id, i)
				end

				return "player_picking_character"
			end
		end
	},
	player_picking_character = {
		enter = function (parent, party_data, party)
			-- function 4
			local current_picker_index = party_data.current_picker_index

			current_picker_index = current_picker_index + 1
			party_data.current_picker_index = current_picker_index

			parent:_ensure_picker_has_character(party_data, current_picker_index, true)

			local picking_settings = parent._picking_settings
			local player_pick_time = picking_settings.player_pick_time

			parent:set_timer(player_pick_time)
			parent:set_party_current_picker(party.party_id, current_picker_index)
			parent:set_player_state("player_picking_character", party.party_id, current_picker_index)
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 5
			local current_picker_index = party_data.current_picker_index

			parent:_ensure_picker_has_character(party_data, current_picker_index)

			if timer <= 0 then
				return "player_has_picked_character"
			end
		end
	},
	player_has_picked_character = {
		enter = function (parent, party_data, party)
			-- function 6
			local current_picker_index = party_data.current_picker_index

			parent:set_player_state("player_has_picked_character", party.party_id, current_picker_index)
			parent:_ensure_picker_has_character(party_data, current_picker_index)
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 7
			if party_data.current_picker_index >= #party_data.picker_list then
				return "parading"
			end

			return "player_picking_character"
		end
	},
	parading = {
		enter = function (parent, party_data, party)
			-- function 8
			local duration = Managers.state.game_mode:setting("character_picking_settings").parading_duration

			parent:set_timer(duration)

			for i = 1, #party_data.picker_list do
				parent:set_player_state("parading", party.party_id, i)
			end
		end,
		run = function (parent, party_data, party, timer, t, dt, party_selection_logic)
			-- function 9
			if timer <= 0 then
				return "closing"
			end
		end
	},
	closing = {
		enter = function (parent, party_data, party)
			-- function 10
			local picking_settings = parent._picking_settings

			parent:set_timer(picking_settings.closing_time)

			for i = 1, #party_data.picker_list do
				parent:set_player_state("closing", party.party_id, i)
			end
		end,
		run = function (parent, party_data, party, timer, t, dt, party_selection_logic)
			-- function 11
			if not parent._character_selection_completed then
				local all_parties_done = parent:_all_parties_have_picked()

				if all_parties_done then
					Managers.state.event:unregister("on_player_left_party", party_selection_logic)
					Managers.state.game_mode:game_mode():server_character_selection_completed()

					parent._character_selection_completed = true
				end
			end
		end
	}
}
VersusPartySelectionLogic.client_states = {
	startup = {
		enter = function (parent, party_data, party)
			-- function 12
			parent:set_party_timer(party_data)
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 13
			return
		end
	},
	player_waiting_to_pick = {
		enter = function (parent, party_data, party)
			-- function 14
			return
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 15
			local prev_picker_index = party_data.prev_picker_index
			local current_picker_index = party_data.current_picker_index

			if prev_picker_index < current_picker_index then
				parent:set_party_timer(party_data)

				party_data.prev_picker_index = current_picker_index
			end

			party_data.slider_timer = timer
		end
	},
	player_picking_character = {
		enter = function (parent, party_data, party)
			-- function 16
			party_data.prev_picker_index = party_data.current_picker_index

			parent:set_party_timer(party_data)
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 17
			party_data.slider_timer = timer
		end
	},
	player_has_picked_character = {
		enter = function (parent, party_data, party)
			-- function 18
			return
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 19
			local prev_picker_index = party_data.prev_picker_index
			local current_picker_index = party_data.current_picker_index

			if prev_picker_index < current_picker_index then
				parent:set_party_timer(party_data)

				party_data.prev_picker_index = current_picker_index
			end

			party_data.slider_timer = timer
		end
	},
	parading = {
		enter = function (parent, party_data, party)
			-- function 20
			return
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 21
			return
		end
	},
	closing = {
		enter = function (parent, party_data, party)
			-- function 22
			party_data.slider_timer = nil
		end,
		run = function (parent, party_data, party, timer, t, dt)
			-- function 23
			return
		end
	}
}

local ClientStateLookup = {
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

VersusPartySelectionLogicUtility.ClientStateLookup = ClientStateLookup

VersusPartySelectionLogic.init = function (self, is_server, settings, network_server, profile_synchronizer, network_event_delegate, network_transmit)
	-- function 24
	self._timer_paused = false
	self._timer = 0
	self._timer_scale = 1

	local party_states_lookup = {}

	for key, _ in pairs(VersusPartySelectionLogic.party_states) do
		local index = #party_states_lookup + 1

		party_states_lookup[index] = key
		party_states_lookup[key] = index
	end

	local client_states_lookup = {}

	for key, _ in pairs(VersusPartySelectionLogic.client_states) do
		local index = #client_states_lookup + 1

		client_states_lookup[index] = key
		client_states_lookup[key] = index
	end

	self._party_states_lookup = party_states_lookup
	self._client_states_lookup = client_states_lookup
	self._is_server = is_server
	self._network_server = network_server

	if is_server then
		self._profile_requester = network_server:profile_requester()
	end

	self._profile_synchronizer = profile_synchronizer
	self._settings = settings
	self._picking_settings = settings.character_picking_settings
	self._timer = self._picking_settings.startup_time + GameSettings.transition_fade_out_speed
	self._pick_data_per_party = {}
	self._first_update = true
	self._party_data = nil
	self._party = nil

	self:_register_rpcs(network_event_delegate, network_transmit)

	if is_server then
		Managers.state.event:register(self, "on_player_left_party", "on_player_left_party")
		self:_setup_picking_order()

		local players = Managers.player:human_players()

		for unique_id, player in pairs(players) do
			local peer_id = player:network_id()

			self:_sync_party_array(peer_id)
		end
	end
end

VersusPartySelectionLogic.pre_update = function (self, t, dt)
	-- function 25
	if not DEDICATED_SERVER then
		self:_client_pre_update(t, dt)
	end

	if self._is_server then
		self:_server_pre_update(t, dt)
	end
end

VersusPartySelectionLogic._server_pre_update = function (self, t, dt)
	-- function 26
	local game = Network.game_session()
	local in_game_session = Managers.state.network:in_game_session()

	if not game or not in_game_session then
		return
	end

	local states = VersusPartySelectionLogic.party_states
	local pick_data_per_party = self._pick_data_per_party
	local parties = Managers.party:game_participating_parties()
	local new_states = {}

	if self._first_update then
		for party_id = 1, #pick_data_per_party do
			local party = parties[party_id]
			local party_data = pick_data_per_party[party_id]
			local current_state = party_data.state
			local enter_func = states[current_state].enter

			if enter_func then
				enter_func(self, party_data, party)
			end
		end

		if DEDICATED_SERVER then
			self._first_update = false
		end
	end

	for party_id = 1, #pick_data_per_party do
		local party = parties[party_id]
		local party_data = pick_data_per_party[party_id]
		local current_state = party_data.state
		local new_state = states[current_state].run(self, party_data, party, self._timer, t, dt, self)

		new_states[party_id] = new_state
	end

	for party_id, new_state in pairs(new_states) do
		local party = parties[party_id]
		local party_data = pick_data_per_party[party_id]
		local state_id = self._party_states_lookup[new_state]

		self._network_transmit:send_rpc_clients("rpc_set_party_state", party_id, state_id)

		local old_state = party_data.state
		local leave_func = states[old_state].leave

		if leave_func then
			leave_func(self, party_data, party)
		end

		local enter_func = states[new_state].enter

		if enter_func then
			enter_func(self, party_data, party)
		end

		party_data.state = new_state
	end

	if self._timer_paused then
		return
	end

	self._timer = math.max(self._timer - dt, 0)
end

VersusPartySelectionLogic._client_pre_update = function (self, t, dt)
	-- function 27
	local game = Network.game_session()

	if not game then
		return
	end

	local party_data, party, picker_list_id = self:_local_party_data()

	if not party_data then
		return
	end

	local states = VersusPartySelectionLogic.client_states
	local current_state = party_data.picker_list[picker_list_id].state

	if self._first_update then
		local enter_func = states[current_state].enter

		if enter_func then
			enter_func(self, party_data, party)
		end

		self._first_update = false
	end

	states[current_state].run(self, party_data, party, self._timer, t, dt)

	if self._is_server then
		return
	end

	if self._timer_paused then
		return
	end

	self._timer = math.max(self._timer - dt, 0)
end

VersusPartySelectionLogic._local_party_data = function (self)
	-- function 28
	if DEDICATED_SERVER then
		return nil, nil, nil
	end

	if not self._party_data then
		local num_parties = Managers.party:get_num_game_participating_parties()

		if #self._pick_data_per_party ~= num_parties then
			return
		end

		local party_manager = Managers.party
		local player_manager = Managers.player
		local local_player = player_manager:local_player()
		local unique_id = local_player:unique_id()
		local player_party = party_manager:get_party_from_unique_id(unique_id)
		local pick_data_per_party = self._pick_data_per_party
		local party_data = pick_data_per_party[player_party.party_id]

		if not party_data then
			return
		end

		self._local_player = local_player
		self._party_data = party_data
		self._party = player_party

		local picker_list = self._party_data.picker_list

		for id, picker_data in ipairs(picker_list) do
			picker_data.status = player_party.slots[picker_data.slot_id]

			local player = picker_data.status.player

			if player and player.local_player then
				self._picker_list_id = id

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

VersusPartySelectionLogic._register_rpcs = function (self, network_event_delegate, network_transmit)
	-- function 30
	network_event_delegate:register(self, unpack(RPCS))

	self._network_event_delegate = network_event_delegate
	self._network_transmit = network_transmit
end

VersusPartySelectionLogic._unregister_rpcs = function (self)
	-- function 31
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._network_transmit = nil
end

VersusPartySelectionLogic.set_ingame_ui = function (self, ingame_ui)
	-- function 32
	self._ingame_ui = ingame_ui
end

VersusPartySelectionLogic.hot_join_sync = function (self, peer_id)
	-- function 33
	self:_sync_party_array(peer_id)

	local pick_data_per_party = self._pick_data_per_party

	for i = 1, #pick_data_per_party do
		local party_data = pick_data_per_party[i]
		local party_id = party_data.party_id
		local party_state_id = self._party_states_lookup[party_data.state]
		local picker_list = party_data.picker_list

		for j = 1, #picker_list do
			local player_data = picker_list[j]
			local picker_id = player_data.picker_index
			local player_state_id = self._client_states_lookup[player_data.state]

			self._network_transmit:send_rpc("rpc_set_party_state", peer_id, party_id, party_state_id)

			local profile_index, career_index

			if ClientStateLookup[player_data.state] >= ClientStateLookup.player_picking_character then
				local slot_id = player_data.slot_id
				local is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(party_data, slot_id)

				if is_bot then
					profile_index, career_index = self._profile_synchronizer:get_bot_profile(party_id, slot_id)
				elseif player_data.status.peer_id and player_data.status.local_player_id then
					local mechanism = Managers.mechanism:game_mechanism()

					profile_index, career_index = mechanism:update_wanted_hero_character(player_data.status.peer_id, player_data.status.local_player_id, party_id)
				else
					Crashify.print_exception("VersusPartySelectionLogic", "Supposed human player missing peer_id and local_player_id. Party: %s, pick id: %s", party_id, picker_id)
				end
			end

			if profile_index then
				local party = Managers.party:get_party(party_id)
				local slots_data = party.slots_data
				local slot_data = slots_data[player_data.slot_id]
				local picker_data = picker_list[picker_id]
				local status = picker_data.status
				local melee_name, ranged_name, skin_name, hat_name, frame_name = slot_data.slot_melee, slot_data.slot_ranged, slot_data.slot_skin, slot_data.slot_hat, slot_data.slot_frame
				local melee_id = NetworkLookup.item_names[not not melee_name or not not "n/a"]
				local ranged_id = NetworkLookup.item_names[not not ranged_name or not not "n/a"]
				local skin_id = NetworkLookup.item_names[not not skin_name or not not "n/a"]
				local hat_id = NetworkLookup.item_names[not not hat_name or not not "n/a"]
				local frame_id = NetworkLookup.item_names[not not frame_name or not not "n/a"]
				local level = status.level
				local versus_level = status.versus_level

				self._network_transmit:send_rpc("rpc_sync_player_loadout", peer_id, party_id, picker_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
			end

			self._network_transmit:send_rpc("rpc_set_player_state", peer_id, player_state_id, party_id, picker_id)
		end
	end

	if self._timer > 0 then
		local network_time_done = Managers.state.network:network_time() + self._timer

		self._network_transmit:send_rpc("rpc_set_party_selection_logic_timer", peer_id, self._timer, network_time_done)
	end
end

VersusPartySelectionLogic.get_party_data = function (self, party_id)
	-- function 34
	local pick_data_per_party = self._pick_data_per_party

	return not not pick_data_per_party and not not pick_data_per_party[party_id]
end

VersusPartySelectionLogic.set_player_state = function (self, new_state, party_id, picker_id)
	-- function 35
	if self._is_server then
		local new_state_id = self._client_states_lookup[new_state]

		self._network_transmit:send_rpc_clients("rpc_set_player_state", new_state_id, party_id, picker_id)
	end

	local pick_data_per_party = self._pick_data_per_party
	local party_data = pick_data_per_party[party_id]
	local picker_list = party_data.picker_list
	local picker_data = picker_list[picker_id]

	if not DEDICATED_SERVER then
		local _, local_party, local_picker_list_id = self:_local_party_data()

		if picker_id == local_picker_list_id and party_id == local_party.party_id then
			local states = VersusPartySelectionLogic.client_states
			local enter_func = states[new_state].enter

			if enter_func then
				enter_func(self, party_data, local_party)
			end
		end
	end

	picker_data.state = new_state

	Managers.state.event:trigger("party_selection_logic_state_set", new_state, party_id, picker_id)
end

VersusPartySelectionLogic.set_party_current_picker = function (self, party_id, picker_id)
	-- function 36
	self._network_transmit:send_rpc_clients("rpc_set_party_picking_id", party_id, picker_id)

	if not DEDICATED_SERVER then
		local pick_data_per_party = self._pick_data_per_party
		local party_data = pick_data_per_party[party_id]

		party_data.current_picker_index = picker_id
	end
end

VersusPartySelectionLogic.set_timer = function (self, value)
	-- function 37
	self._timer = value

	if self._is_server then
		self._current_timer_total = value

		local network_time_done = Managers.state.network:network_time() + value

		self._network_transmit:send_rpc_clients("rpc_set_party_selection_logic_timer", value, network_time_done)
	end
end

VersusPartySelectionLogic._make_available_profile_lookup = function (self, affilation, role)
	-- function 38
	local profile_lookup = {}

	for i = 1, #SPProfiles do
		local profile = SPProfiles[i]

		if profile.affiliation == affilation and profile.role == role then
			local character_level = ExperienceSettings.get_character_level(profile.display_name)
			local careers = {}

			for i = 1, #profile.careers do
				local career = profile.careers[i]

				if career:is_unlocked_function(profile.display_name, character_level) then
					careers[#careers + 1] = i
				end
			end

			if #careers > 0 then
				profile_lookup[profile.index] = careers
			end
		end
	end

	fassert(not table.is_empty(profile_lookup) or affilation == "spectators", "Failed to find any available profiles for " .. affilation)

	return profile_lookup
end

VersusPartySelectionLogic.get_character_or_random = function (self, profile_index, career_index, party_data, is_bot)
	-- function 39
	if profile_index and career_index and not self:_is_hero_locked(profile_index, party_data) then
		return profile_index, career_index
	end

	return self:get_random_available_character(party_data, is_bot)
end

VersusPartySelectionLogic.get_random_available_character = function (self, party_data, is_bot)
	-- function 40
	local _random_profile_indices = self._random_profile_indices

	if not _random_profile_indices then
		-- Nothing
	end

	_random_profile_indices = table.select_map(SPProfiles, function (_, profile)
		-- function 41
		if profile.affiliation == "heroes" then
			return profile.index
		end
	end)

	local random_profile_indices = _random_profile_indices

	::label_40_0::

	self._random_profile_indices = random_profile_indices

	table.shuffle(random_profile_indices)

	local _random_career_indices = self._random_career_indices

	if not _random_career_indices then
		-- Nothing
	end

	_random_career_indices = {
		1,
		2,
		3
	}

	local random_career_indices = _random_career_indices

	::label_40_1::

	self._random_career_indices = random_career_indices

	table.shuffle(random_career_indices)

	local profile_index, career_index

	for p_i = 1, #random_profile_indices do
		for c_i = 1, #random_career_indices do
			local p_idx, c_idx = random_profile_indices[p_i], random_career_indices[c_i]
			local career_name = SPProfiles[p_i].careers[c_i].name

			if PlayerUtils.get_career_override(career_name) and not self:_is_hero_locked(p_idx, party_data) then
				profile_index, career_index = p_idx, c_idx

				break
			end
		end

		if profile_index and career_index then
			break
		end
	end

	if not profile_index or not career_index then
		profile_index, career_index = 1, 1

		table.dump(party_data, "party_data", 3)
		Crashify.print_exception("VersusPartySelectionLogic", "Could not find an available profile.")
	end

	return profile_index, career_index
end

VersusPartySelectionLogic._is_hero_locked = function (self, profile_index, party_data, except_peer_id)
	-- function 42
	if self._settings.duplicate_hero_careers_allowed then
		return false
	end

	if not profile_index or profile_index == 0 then
		return true
	end

	local party_id = party_data.party_id
	local reserver_peer = self._profile_synchronizer:get_profile_index_reservation(party_id, profile_index)

	if reserver_peer and reserver_peer ~= except_peer_id then
		return true
	end

	local picker_list = party_data.picker_list

	for slot_id = 1, #picker_list do
		local picker_data = picker_list[slot_id]

		if picker_data.state == "player_has_picked_character" and picker_data.status.profile_index == profile_index and picker_data.picker_index ~= party_data.current_picker_index then
			return true
		end
	end

	return false
end

VersusPartySelectionLogic._ensure_picker_has_character = function (self, party_data, picker_index, force_sync)
	-- function 43
	local peer_id, local_player_id, slot_id = self:_peer_from_picker_data(party_data, picker_index)
	local party_id = party_data.party_id
	local profile_index, career_index
	local is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(party_data, picker_index)

	if is_bot then
		profile_index, career_index = self._profile_synchronizer:get_bot_profile(party_id, slot_id)
	else
		local mechanism = Managers.mechanism:game_mechanism()

		profile_index, career_index = mechanism:update_wanted_hero_character(peer_id, local_player_id, party_id)
	end

	profile_index, career_index = self:_try_pick_hero(party_data, picker_index, profile_index, career_index)

	if force_sync then
		self:sync_player_loadout(profile_index, career_index, party_id, picker_index)
	end

	return profile_index, career_index
end

VersusPartySelectionLogic._peer_from_picker_data = function (self, party_data, picker_index)
	-- function 44
	local picker_data = party_data.picker_list[picker_index]
	local status = picker_data.status

	return status.peer_id, status.local_player_id, picker_data.slot_id
end

VersusPartySelectionLogic._is_hero_party = function (self, party_id)
	-- function 45
	return Managers.party:get_party(party_id).name == "heroes"
end

VersusPartySelectionLogic.select_character = function (self, profile_index, career_index)
	-- function 46
	assert(not not profile_index and not not career_index, "[VersusPartySelectionLogic] Selecting non-character")

	local local_party_data = self:_local_party_data()
	local picker_index = local_party_data.current_picker_index
	local picker_data = local_party_data.picker_list[picker_index]
	local status = picker_data.status
	local peer_id = status.peer_id

	if peer_id ~= Network.peer_id() then
		return
	end

	self._network_transmit:send_rpc_server("rpc_party_select_request_pick_hero", local_party_data.party_id, picker_index, profile_index, career_index)
end

VersusPartySelectionLogic._sync_hovered_item = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 47
	local player_party_status = Managers.party:get_status_from_unique_id(peer_id .. ":" .. local_player_id)

	if player_party_status then
		player_party_status.hovered_profile_index = profile_index
		player_party_status.hovered_career_index = career_index
	end
end

VersusPartySelectionLogic.sync_hovered_item = function (self, peer_id, local_player_id, profile_index, career_index)
	-- function 48
	self:_sync_hovered_item(peer_id, local_player_id, profile_index, career_index)

	if not Managers.state.network or not Managers.state.network:game() then
		return
	end

	if self._is_server then
		self._network_transmit:send_rpc_clients("rpc_pre_game_sync_hovered_item", peer_id, local_player_id, profile_index, career_index)
	else
		self._network_transmit:send_rpc_server("rpc_pre_game_sync_hovered_item", peer_id, local_player_id, profile_index, career_index)
	end
end

VersusPartySelectionLogic.set_party_timer = function (self, party_data)
	-- function 49
	local picking_settings = self._picking_settings
	local player_pick_time = picking_settings.player_pick_time
	local current_picker_index = party_data.current_picker_index
	local timer = player_pick_time * current_picker_index

	party_data.slider_timer = timer
	party_data.time_finished = timer
end

local function make_index_array(party, shuffle_order)
	-- function 50
	local array = {}
	local slots = party.slots
	local slots_data = party.slots_data
	local k = 0

	for i = 1, party.num_slots do
		local status = slots[i]

		if status.is_player and status.peer_id then
			k = k + 1
			array[k] = {
				is_connected = true,
				state = "startup",
				is_bot = false,
				slot_id = i,
				status = status
			}
		end
	end

	if shuffle_order == "players_first" then
		table.shuffle(array)
	end

	for i = 1, party.num_slots do
		local status = slots[i]

		if status.is_bot or not status.peer_id then
			k = k + 1
			array[k] = {
				is_connected = true,
				state = "startup",
				is_bot = true,
				slot_id = i,
				status = status
			}
		end
	end

	if shuffle_order == "mix_all" then
		table.shuffle(array)
	end

	for i = 1, party.num_slots do
		local player_data = array[i]

		player_data.picker_index = i

		local slot_data = slots_data[player_data.slot_id]

		slot_data.player_data_id = i
	end

	return array
end

VersusPartySelectionLogic._setup_picking_order = function (self)
	-- function 51
	local shuffle_order = Managers.state.game_mode:setting("shuffle_character_picking_order")
	local pick_data_per_party = self._pick_data_per_party
	local parties = Managers.party:game_participating_parties()

	for i = 1, #parties do
		local party = parties[i]
		local picker_list = make_index_array(party, shuffle_order, true)

		pick_data_per_party[i] = {
			current_picker_index = 0,
			state = "startup",
			picker_list = picker_list,
			party_id = i
		}
	end
end

VersusPartySelectionLogic._sync_party_array = function (self, peer_id)
	-- function 52
	local pick_data_per_party = self._pick_data_per_party

	for party_id, party_data in ipairs(pick_data_per_party) do
		local picker_list = party_data.picker_list
		local party_array = {}

		for j = 1, #picker_list do
			party_array[j] = picker_list[j].slot_id
		end

		local current_picker_index = party_data.current_picker_index

		self._network_transmit:send_rpc("rpc_set_party_array", peer_id, party_id, party_array, current_picker_index)
	end
end

VersusPartySelectionLogic.sync_player_loadout = function (self, profile_index, career_index, party_id, picker_list_id)
	-- function 53
	local _, local_party, local_picker_list_id = self:_local_party_data()
	local syncing_own_loadout = (not not local_party and not not local_party.party_id) == party_id and local_picker_list_id == picker_list_id
	local party_data = self._pick_data_per_party[party_id]
	local is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(party_data, picker_list_id)
	local melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level

	if profile_index and profile_index > 0 and (syncing_own_loadout or self._is_server and is_bot) then
		melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level = self:_get_loadout(profile_index, career_index, is_bot)

		local peer_id, local_player_id = self:_peer_from_picker_data(party_data, picker_list_id)
		local _is_hero_party = self:_is_hero_party(party_id)

		if _is_hero_party then
			-- Nothing
		end

		_is_hero_party = local_player_id

		local sync_cosmetics = _is_hero_party

		::label_53_0::

		if sync_cosmetics then
			local player = Managers.player:player(peer_id, local_player_id)

			CosmeticUtils.sync_local_player_cosmetics(player, profile_index, career_index)
		end
	else
		melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level = 1, 1, 1, 1, 1, 1, 0
	end

	self:_set_loadout(party_id, picker_list_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)

	if self._is_server then
		self._network_transmit:send_rpc_clients("rpc_sync_player_loadout", party_id, picker_list_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	else
		self._network_transmit:send_rpc_server("rpc_sync_player_loadout", party_id, picker_list_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	end
end

VersusPartySelectionLogic._set_loadout = function (self, party_id, pick_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	-- function 54
	local party = Managers.party:get_party(party_id)
	local party_data = self._pick_data_per_party[party_id]
	local picker_list = party_data.picker_list
	local picker_data = picker_list[pick_id]
	local status = picker_data.status

	status.selected_profile_index = profile_index
	status.selected_career_index = career_index
	status.profile_index = profile_index
	status.career_index = career_index
	status.level = level
	status.versus_level = versus_level

	local slots_data = party.slots_data
	local slot_data = slots_data[picker_data.slot_id]

	slot_data.slot_melee = NetworkLookup.item_names[melee_id]
	slot_data.slot_ranged = NetworkLookup.item_names[ranged_id]
	slot_data.slot_skin = NetworkLookup.item_names[skin_id]
	slot_data.slot_hat = NetworkLookup.item_names[hat_id]
	slot_data.slot_frame = NetworkLookup.item_names[frame_id]
end

VersusPartySelectionLogic._get_loadout = function (self, profile_index, career_index, is_bot)
	-- function 55
	local profile = SPProfiles[profile_index]
	local hero_name = profile.display_name
	local career = profile.careers[career_index]
	local career_name = career.display_name
	local item_slot_types_by_slot_name = career.item_slot_types_by_slot_name
	local get_loadout_item = BackendUtils.get_loadout_item
	local slot_melee = item_slot_types_by_slot_name.slot_melee

	if slot_melee then
		-- Nothing
	end

	slot_melee = get_loadout_item(career_name, "slot_melee")

	local melee = slot_melee

	::label_55_0::

	local slot_ranged = item_slot_types_by_slot_name.slot_ranged

	if slot_ranged then
		-- Nothing
	end

	slot_ranged = get_loadout_item(career_name, "slot_ranged")

	local ranged = slot_ranged

	::label_55_1::

	local slot_skin = item_slot_types_by_slot_name.slot_skin

	if slot_skin then
		-- Nothing
	end

	slot_skin = get_loadout_item(career_name, "slot_skin")

	local skin = slot_skin

	::label_55_2::

	local slot_hat = item_slot_types_by_slot_name.slot_hat

	if slot_hat then
		-- Nothing
	end

	slot_hat = get_loadout_item(career_name, "slot_hat")

	local hat = slot_hat

	::label_55_3::

	local slot_frame = item_slot_types_by_slot_name.slot_frame

	if slot_frame then
		-- Nothing
	end

	slot_frame = get_loadout_item(career_name, "slot_frame")

	local portrait_frame = slot_frame

	do
		local var_55_5
	end

	::label_55_4::

	if melee then
		var_55_5 = NetworkLookup.item_names[melee.key]

		if not var_55_5 then
			-- Nothing
		end
	end

	var_55_5 = 1

	local melee_id = var_55_5

	do
		local var_55_6
	end

	::label_55_5::

	if ranged then
		var_55_6 = NetworkLookup.item_names[ranged.key]

		if not var_55_6 then
			-- Nothing
		end
	end

	var_55_6 = 1

	local ranged_id = var_55_6

	do
		local var_55_7
	end

	::label_55_6::

	if skin then
		var_55_7 = NetworkLookup.item_names[skin.key]

		if not var_55_7 then
			-- Nothing
		end
	end

	var_55_7 = 1

	local skin_id = var_55_7

	do
		local var_55_8
	end

	::label_55_7::

	if hat then
		var_55_8 = NetworkLookup.item_names[hat.key]

		if not var_55_8 then
			-- Nothing
		end
	end

	var_55_8 = 1

	local hat_id = var_55_8

	do
		local var_55_9
	end

	::label_55_8::

	if hat then
		var_55_9 = NetworkLookup.item_names[portrait_frame.key]

		if not var_55_9 then
			-- Nothing
		end
	end

	var_55_9 = 1

	local frame_id = var_55_9

	::label_55_9::

	local hero_attributes = Managers.backend:get_interface("hero_attributes")
	local experience = hero_attributes:get(hero_name, "experience")
	local level = ExperienceSettings.get_level(experience)
	local num

	if is_bot then
		num = 0

		goto label_55_10
	end

	num = ExperienceSettings.get_versus_level()

	local versus_level = num

	::label_55_10::

	return melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level
end

VersusPartySelectionLogic.settings = function (self)
	-- function 56
	return self._settings
end

VersusPartySelectionLogic._all_parties_have_picked = function (self)
	-- function 57
	local pick_data_per_party = self._pick_data_per_party

	for i = 2, #pick_data_per_party do
		local party_data = pick_data_per_party[i]

		if party_data.state ~= "closing" then
			return false
		end
	end

	local profile_synchronizer = Managers.state.network.profile_synchronizer

	if not profile_synchronizer:all_synced() then
		return false
	end

	return true
end

VersusPartySelectionLogic.player_joined_party = function (self, peer_id, local_player_id, new_party_id, slot_id)
	-- function 58
	if new_party_id == 0 then
		return
	end

	if not self._pick_data_per_party then
		return
	end

	local party = Managers.party:get_party(new_party_id)
	local party_data = self._pick_data_per_party[new_party_id]
	local picker_list = party_data.picker_list
	local pick_id

	for i = 1, #picker_list do
		if picker_list[i].slot_id == slot_id then
			pick_id = i

			break
		end
	end

	fassert(pick_id ~= nil, "Failed to find slot id")

	local picker_data = picker_list[pick_id]

	fassert(picker_data.is_bot ~= false, "Tried to replace human player. Expected to replace bot")

	local status = party.slots[slot_id]
	local old_status = picker_data.status

	picker_data.status = status
	picker_data.is_bot = false

	if not self._is_server then
		return
	end

	printf("[VersusPartySelectionLogic] Peer %s joined party %s with pick order %s (state: %s)", peer_id, new_party_id, pick_id, picker_data.state)

	if ClientStateLookup[picker_data.state] >= ClientStateLookup.player_picking_character then
		local profile_index, career_index = self:_ensure_picker_has_character(party_data, pick_id, true)

		printf("[VersusPartySelectionLogic] Peer %s in party %s hot joined and was delegated %s", status.peer_id, new_party_id, SPProfiles[profile_index].careers[career_index].display_name)
	end
end

VersusPartySelectionLogic.player_left_party = function (self, peer_id, local_player_id, party_id, slot_id, old_slot_data)
	-- function 59
	if party_id == 0 then
		return
	end

	local party = Managers.party:get_party(party_id)
	local party_data = self._pick_data_per_party[party_id]
	local picker_list = party_data.picker_list
	local index

	for i = 1, #picker_list do
		if picker_list[i].slot_id == slot_id then
			index = i

			break
		end
	end

	fassert(index ~= nil, "Failed to find slot id")

	local picker_data = picker_list[index]

	picker_data.is_bot = nil
	picker_data.status = party.slots[slot_id]

	if not self._is_server then
		return
	end

	if ClientStateLookup[picker_data.state] >= ClientStateLookup.player_picking_character then
		local new_profile_index, new_career_index = self:_ensure_picker_has_character(party_data, index, true)
		local status = old_slot_data.status

		if status then
			-- Nothing
		end

		status = old_slot_data.status.peer_id

		local old_peer_id = status

		::label_59_0::

		printf("[VersusPartySelectionLogic] %s in party %s and pick id %s left and was replaced by %s", not not old_peer_id or not not "UNKNOWN", party.party_id, index, SPProfiles[new_profile_index].careers[new_career_index].display_name)
	end
end

VersusPartySelectionLogic._try_pick_hero = function (self, party_data, picker_index, profile_index, career_index, force_sync)
	-- function 60
	local party_id = party_data.party_id
	local is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(party_data, picker_index)
	local peer_id, _, slot_id = self:_peer_from_picker_data(party_data, picker_index)
	local current_profile_idx, current_career_idx

	if is_bot then
		current_profile_idx, current_career_idx = self._profile_synchronizer:get_bot_profile(party_id, slot_id)
	else
		current_profile_idx, current_career_idx = Managers.mechanism:get_persistent_profile_index_reservation(peer_id)
	end

	if self:_is_hero_locked(current_profile_idx, party_data, peer_id) then
		current_profile_idx, current_career_idx = nil
	end

	repeat
		if current_profile_idx and current_career_idx and profile_index == current_profile_idx and career_index == current_career_idx then
			break
		end

		local picker_list = party_data.picker_list
		local picker_data = picker_list[picker_index]
		local state = picker_data.state
		local slot_already_picked = ClientStateLookup[state] > ClientStateLookup.player_picking_character

		if current_profile_idx and slot_already_picked then
			local printf = printf
			local str = "[VersusPartySelectionLogic] %s %s in party %s and pick id %s tried to pick a hero %s %s after timer ran out. Staying as %s %s"
			local flag

			flag = (not is_bot or not "BOT in slot") and not not "Peer"

			printf(str, flag, (not is_bot or not picker_index) and not not peer_id, party_id, picker_index, profile_index, career_index, current_profile_idx, current_career_idx)

			profile_index = current_profile_idx
			career_index = current_career_idx

			break
		end

		force_sync = true

		if not profile_index or not career_index or profile_index == 0 or career_index == 0 then
			profile_index, career_index = self:get_character_or_random(profile_index, career_index, party_data, is_bot)

			local printf_2 = printf
			local str_2 = "[VersusPartySelectionLogic] No profile provided for %s %s. Fallbacking to %s %s."
			local flag_2

			flag_2 = (not is_bot or not "BOT in slot") and not not "Peer"

			printf_2(str_2, flag_2, (not is_bot or not picker_index) and not not peer_id, profile_index, career_index)
		elseif self:_is_hero_locked(profile_index, party_data, peer_id) then
			local failed_profile_index, failed_career_index = profile_index, career_index

			profile_index, career_index = self:get_character_or_random(profile_index, career_index, party_data, is_bot)

			local printf_3 = printf
			local str_3 = "[VersusPartySelectionLogic] %s %s tried to pick locked hero %s %s. Fallbacking to %s %s."
			local flag_3

			flag_3 = (not is_bot or not "BOT in slot") and not not "Peer"

			printf_3(str_3, flag_3, (not is_bot or not picker_index) and not not peer_id, failed_profile_index, failed_career_index, profile_index, career_index)
		end

		if is_bot then
			self._profile_synchronizer:set_bot_profile(party_id, slot_id, profile_index, career_index)

			break
		end

		local success = Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(peer_id, profile_index, career_index, true)

		if not success then
			Crashify.print_exception("VersusPartySelectionLogic", "gave peer %s in party %s hero %s, but could not reserve it", peer_id, party_id, profile_index)

			profile_index = current_profile_idx
			career_index = current_career_idx
		end
	until true

	if force_sync then
		self:sync_player_loadout(profile_index, career_index, party_id, picker_index)
	end

	return profile_index, career_index
end

VersusPartySelectionLogic.rpc_party_select_request_pick_hero = function (self, channel_id, party_id, picker_index, profile_index, career_index)
	-- function 61
	local pick_data_per_party = self._pick_data_per_party
	local party_data = pick_data_per_party[party_id]
	local got_profile, got_career = self:_try_pick_hero(party_data, picker_index, profile_index, career_index)
	local str

	if got_profile == profile_index then
		str = " and succeeded"

		goto label_61_0
	end

	str = string.format(", but got hero %s %s", got_profile, got_career)

	local fail_context = str

	::label_61_0::

	printf("[VersusPartySelectionLogic] Peer %s in party %s tried to pick hero %s %s%s", CHANNEL_TO_PEER_ID[channel_id], party_id, profile_index, career_index, fail_context)
end

VersusPartySelectionLogic.rpc_set_party_array = function (self, channel_id, party_id, party_array, current_picker_index)
	-- function 62
	local party = Managers.party:get_party(party_id)
	local slots = party.slots
	local picker_list = {}

	for i = 1, #party_array do
		local slot_id = party_array[i]
		local status = slots[slot_id]

		picker_list[i] = {
			state = "startup",
			picker_index = i,
			slot_id = slot_id,
			status = status
		}
	end

	local pick_data

	if self._pick_data_per_party then
		pick_data = self._pick_data_per_party[party_id]
	end

	if not pick_data then
		pick_data = {
			current_picker_index = 0,
			state = "startup",
			picker_list = picker_list,
			party_id = party_id
		}
		self._pick_data_per_party[party_id] = pick_data
	end

	local individual_player_pick_time = GameModeSettings.versus.character_picking_settings.player_pick_time
	local party_size = party.num_slots

	pick_data.current_picker_index = current_picker_index
	pick_data.prev_picker_index = current_picker_index - 1
	pick_data.total_slider_time = individual_player_pick_time * party_size
end

VersusPartySelectionLogic.rpc_set_party_state = function (self, channel_id, party_id, new_state_id)
	-- function 63
	local pick_data = self._pick_data_per_party[party_id]

	pick_data.state = self._party_states_lookup[new_state_id]
end

VersusPartySelectionLogic.rpc_sync_player_loadout = function (self, channel_id, party_id, pick_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	-- function 64
	local peer_id = CHANNEL_TO_PEER_ID[channel_id]

	if not peer_id then
		return
	end

	if self._is_server then
		local pick_data = self._pick_data_per_party[party_id]
		local is_bot = VersusPartySelectionLogicUtility.picker_index_is_bot(pick_data, pick_id)

		if is_bot then
			return
		end

		local picker_list = pick_data.picker_list
		local picker_data = picker_list[pick_id]
		local state = picker_data.state
		local status = picker_data.status

		if ClientStateLookup[state] > ClientStateLookup.player_picking_character and (status.selected_profile_index ~= profile_index or status.selected_career_index ~= career_index) then
			print("[VersusPartySelectionLogic] Client tried to change loadout of a different character after a character has already been picked. Bouncing back request.")

			local real_profile_idx, real_career_idx = Managers.mechanism:get_persistent_profile_index_reservation(status.peer_id)

			self._network_transmit:send_rpc("rpc_sync_player_loadout", peer_id, party_id, pick_id, real_profile_idx, real_career_idx, 1, 1, 1, 1, 1, 1, 0)

			return
		end

		self._network_transmit:send_rpc_clients_except("rpc_sync_player_loadout", peer_id, party_id, pick_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	end

	local _, local_party, local_picker_list_id = self:_local_party_data()
	local local_party_id = not not local_party and not not local_party.party_id

	if local_party_id == party_id and local_picker_list_id == pick_id then
		print("[VersusPartySelectionLogic] Local player was assigned to", profile_index, career_index)
		self:sync_player_loadout(profile_index, career_index, local_party_id, local_picker_list_id)
	else
		self:_set_loadout(party_id, pick_id, profile_index, career_index, melee_id, ranged_id, skin_id, hat_id, frame_id, level, versus_level)
	end
end

VersusPartySelectionLogic.rpc_set_player_state = function (self, channel_id, new_state_id, party_id, picker_id)
	-- function 65
	fassert(not self._is_server, "Server should never get this")

	local new_state = self._client_states_lookup[new_state_id]

	self:set_player_state(new_state, party_id, picker_id)
end

VersusPartySelectionLogic.rpc_set_party_picking_id = function (self, channel_id, party_id, picker_id)
	-- function 66
	local pick_data_per_party = self._pick_data_per_party
	local party_data = pick_data_per_party[party_id]

	party_data.current_picker_index = picker_id
end

VersusPartySelectionLogic.rpc_pre_game_sync_hovered_item = function (self, channel_id, peer_id, local_player_id, profile_index, career_index)
	-- function 67
	self:_sync_hovered_item(peer_id, local_player_id, profile_index, career_index)

	if self._is_server then
		local sender_peer_id = CHANNEL_TO_PEER_ID[channel_id]

		self._network_transmit:send_rpc_clients_except("rpc_pre_game_sync_hovered_item", sender_peer_id, peer_id, local_player_id, profile_index, career_index)
	end
end

VersusPartySelectionLogic.timer = function (self)
	-- function 68
	return self._timer
end

VersusPartySelectionLogic.on_player_left_party = function (self, peer_id, local_player_id, party_id, slot_id_player)
	-- function 69
	if self._peers_ready then
		self._peers_ready[peer_id] = nil
	end

	local pick_data = self._pick_data_per_party[party_id]

	if pick_data then
		local picker_list = pick_data.picker_list

		for i = 1, #picker_list do
			if picker_list[i].slot_id == slot_id_player then
				picker_list[i].is_connected = false
			end
		end
	end
end

VersusPartySelectionLogic.rpc_set_party_selection_logic_timer = function (self, peer_id, real_time_left, end_network_time)
	-- function 70
	local current_network_time = Managers.state.network:network_time()

	if current_network_time == 0 then
		current_network_time = end_network_time - real_time_left
	end

	local time_left = end_network_time - current_network_time

	self._timer_scale = time_left / real_time_left
	self._timer = real_time_left
end
