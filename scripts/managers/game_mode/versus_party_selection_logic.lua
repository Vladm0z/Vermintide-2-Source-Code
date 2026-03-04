-- chunkname: @scripts/managers/game_mode/versus_party_selection_logic.lua

local var_0_0 = false

VersusPartySelectionLogicUtility = {}

VersusPartySelectionLogicUtility.picker_index_is_bot = function (arg_1_0, arg_1_1)
	return arg_1_0.picker_list[arg_1_1].status.is_bot ~= false
end

local var_0_1 = {
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
		enter = function (arg_2_0, arg_2_1, arg_2_2)
			local var_2_0 = arg_2_0._picking_settings

			arg_2_0:set_timer(var_2_0.startup_time)
		end,
		run = function (arg_3_0, arg_3_1, arg_3_2, arg_3_3, arg_3_4, arg_3_5)
			if arg_3_3 <= 0 then
				local var_3_0 = arg_3_1.picker_list

				for iter_3_0 = 1, #var_3_0 do
					arg_3_0:set_player_state("player_waiting_to_pick", arg_3_2.party_id, iter_3_0)
				end

				return "player_picking_character"
			end
		end
	},
	player_picking_character = {
		enter = function (arg_4_0, arg_4_1, arg_4_2)
			local var_4_0 = arg_4_1.current_picker_index + 1

			arg_4_1.current_picker_index = var_4_0

			arg_4_0:_ensure_picker_has_character(arg_4_1, var_4_0, true)

			local var_4_1 = arg_4_0._picking_settings.player_pick_time

			arg_4_0:set_timer(var_4_1)
			arg_4_0:set_party_current_picker(arg_4_2.party_id, var_4_0)
			arg_4_0:set_player_state("player_picking_character", arg_4_2.party_id, var_4_0)
		end,
		run = function (arg_5_0, arg_5_1, arg_5_2, arg_5_3, arg_5_4, arg_5_5)
			local var_5_0 = arg_5_1.current_picker_index

			arg_5_0:_ensure_picker_has_character(arg_5_1, var_5_0)

			if arg_5_3 <= 0 then
				return "player_has_picked_character"
			end
		end
	},
	player_has_picked_character = {
		enter = function (arg_6_0, arg_6_1, arg_6_2)
			local var_6_0 = arg_6_1.current_picker_index

			arg_6_0:set_player_state("player_has_picked_character", arg_6_2.party_id, var_6_0)
			arg_6_0:_ensure_picker_has_character(arg_6_1, var_6_0)
		end,
		run = function (arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4, arg_7_5)
			if arg_7_1.current_picker_index >= #arg_7_1.picker_list then
				return "parading"
			end

			return "player_picking_character"
		end
	},
	parading = {
		enter = function (arg_8_0, arg_8_1, arg_8_2)
			local var_8_0 = Managers.state.game_mode:setting("character_picking_settings").parading_duration

			arg_8_0:set_timer(var_8_0)

			for iter_8_0 = 1, #arg_8_1.picker_list do
				arg_8_0:set_player_state("parading", arg_8_2.party_id, iter_8_0)
			end
		end,
		run = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3, arg_9_4, arg_9_5, arg_9_6)
			if arg_9_3 <= 0 then
				return "closing"
			end
		end
	},
	closing = {
		enter = function (arg_10_0, arg_10_1, arg_10_2)
			local var_10_0 = arg_10_0._picking_settings

			arg_10_0:set_timer(var_10_0.closing_time)

			for iter_10_0 = 1, #arg_10_1.picker_list do
				arg_10_0:set_player_state("closing", arg_10_2.party_id, iter_10_0)
			end
		end,
		run = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6)
			if not arg_11_0._character_selection_completed and arg_11_0:_all_parties_have_picked() then
				Managers.state.event:unregister("on_player_left_party", arg_11_6)
				Managers.state.game_mode:game_mode():server_character_selection_completed()

				arg_11_0._character_selection_completed = true
			end
		end
	}
}
VersusPartySelectionLogic.client_states = {
	startup = {
		enter = function (arg_12_0, arg_12_1, arg_12_2)
			arg_12_0:set_party_timer(arg_12_1)
		end,
		run = function (arg_13_0, arg_13_1, arg_13_2, arg_13_3, arg_13_4, arg_13_5)
			return
		end
	},
	player_waiting_to_pick = {
		enter = function (arg_14_0, arg_14_1, arg_14_2)
			return
		end,
		run = function (arg_15_0, arg_15_1, arg_15_2, arg_15_3, arg_15_4, arg_15_5)
			local var_15_0 = arg_15_1.prev_picker_index
			local var_15_1 = arg_15_1.current_picker_index

			if var_15_0 < var_15_1 then
				arg_15_0:set_party_timer(arg_15_1)

				arg_15_1.prev_picker_index = var_15_1
			end

			arg_15_1.slider_timer = arg_15_3
		end
	},
	player_picking_character = {
		enter = function (arg_16_0, arg_16_1, arg_16_2)
			arg_16_1.prev_picker_index = arg_16_1.current_picker_index

			arg_16_0:set_party_timer(arg_16_1)
		end,
		run = function (arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4, arg_17_5)
			arg_17_1.slider_timer = arg_17_3
		end
	},
	player_has_picked_character = {
		enter = function (arg_18_0, arg_18_1, arg_18_2)
			return
		end,
		run = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4, arg_19_5)
			local var_19_0 = arg_19_1.prev_picker_index
			local var_19_1 = arg_19_1.current_picker_index

			if var_19_0 < var_19_1 then
				arg_19_0:set_party_timer(arg_19_1)

				arg_19_1.prev_picker_index = var_19_1
			end

			arg_19_1.slider_timer = arg_19_3
		end
	},
	parading = {
		enter = function (arg_20_0, arg_20_1, arg_20_2)
			return
		end,
		run = function (arg_21_0, arg_21_1, arg_21_2, arg_21_3, arg_21_4, arg_21_5)
			return
		end
	},
	closing = {
		enter = function (arg_22_0, arg_22_1, arg_22_2)
			arg_22_1.slider_timer = nil
		end,
		run = function (arg_23_0, arg_23_1, arg_23_2, arg_23_3, arg_23_4, arg_23_5)
			return
		end
	}
}

local var_0_2 = {
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

VersusPartySelectionLogicUtility.ClientStateLookup = var_0_2

VersusPartySelectionLogic.init = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4, arg_24_5, arg_24_6)
	arg_24_0._timer_paused = false
	arg_24_0._timer = 0
	arg_24_0._timer_scale = 1

	local var_24_0 = {}

	for iter_24_0, iter_24_1 in pairs(VersusPartySelectionLogic.party_states) do
		local var_24_1 = #var_24_0 + 1

		var_24_0[var_24_1] = iter_24_0
		var_24_0[iter_24_0] = var_24_1
	end

	local var_24_2 = {}

	for iter_24_2, iter_24_3 in pairs(VersusPartySelectionLogic.client_states) do
		local var_24_3 = #var_24_2 + 1

		var_24_2[var_24_3] = iter_24_2
		var_24_2[iter_24_2] = var_24_3
	end

	arg_24_0._party_states_lookup = var_24_0
	arg_24_0._client_states_lookup = var_24_2
	arg_24_0._is_server = arg_24_1
	arg_24_0._network_server = arg_24_3

	if arg_24_1 then
		arg_24_0._profile_requester = arg_24_3:profile_requester()
	end

	arg_24_0._profile_synchronizer = arg_24_4
	arg_24_0._settings = arg_24_2
	arg_24_0._picking_settings = arg_24_2.character_picking_settings
	arg_24_0._timer = arg_24_0._picking_settings.startup_time + GameSettings.transition_fade_out_speed
	arg_24_0._pick_data_per_party = {}
	arg_24_0._first_update = true
	arg_24_0._party_data = nil
	arg_24_0._party = nil

	arg_24_0:_register_rpcs(arg_24_5, arg_24_6)

	if arg_24_1 then
		Managers.state.event:register(arg_24_0, "on_player_left_party", "on_player_left_party")
		arg_24_0:_setup_picking_order()

		local var_24_4 = Managers.player:human_players()

		for iter_24_4, iter_24_5 in pairs(var_24_4) do
			local var_24_5 = iter_24_5:network_id()

			arg_24_0:_sync_party_array(var_24_5)
		end
	end
end

VersusPartySelectionLogic.pre_update = function (arg_25_0, arg_25_1, arg_25_2)
	if not DEDICATED_SERVER then
		arg_25_0:_client_pre_update(arg_25_1, arg_25_2)
	end

	if arg_25_0._is_server then
		arg_25_0:_server_pre_update(arg_25_1, arg_25_2)
	end
end

VersusPartySelectionLogic._server_pre_update = function (arg_26_0, arg_26_1, arg_26_2)
	local var_26_0 = Network.game_session()
	local var_26_1 = Managers.state.network:in_game_session()

	if not var_26_0 or not var_26_1 then
		return
	end

	local var_26_2 = VersusPartySelectionLogic.party_states
	local var_26_3 = arg_26_0._pick_data_per_party
	local var_26_4 = Managers.party:game_participating_parties()
	local var_26_5 = {}

	if arg_26_0._first_update then
		for iter_26_0 = 1, #var_26_3 do
			local var_26_6 = var_26_4[iter_26_0]
			local var_26_7 = var_26_3[iter_26_0]
			local var_26_8 = var_26_2[var_26_7.state].enter

			if var_26_8 then
				var_26_8(arg_26_0, var_26_7, var_26_6)
			end
		end

		if DEDICATED_SERVER then
			arg_26_0._first_update = false
		end
	end

	for iter_26_1 = 1, #var_26_3 do
		local var_26_9 = var_26_4[iter_26_1]
		local var_26_10 = var_26_3[iter_26_1]

		var_26_5[iter_26_1] = var_26_2[var_26_10.state].run(arg_26_0, var_26_10, var_26_9, arg_26_0._timer, arg_26_1, arg_26_2, arg_26_0)
	end

	for iter_26_2, iter_26_3 in pairs(var_26_5) do
		local var_26_11 = var_26_4[iter_26_2]
		local var_26_12 = var_26_3[iter_26_2]
		local var_26_13 = arg_26_0._party_states_lookup[iter_26_3]

		arg_26_0._network_transmit:send_rpc_clients("rpc_set_party_state", iter_26_2, var_26_13)

		local var_26_14 = var_26_2[var_26_12.state].leave

		if var_26_14 then
			var_26_14(arg_26_0, var_26_12, var_26_11)
		end

		local var_26_15 = var_26_2[iter_26_3].enter

		if var_26_15 then
			var_26_15(arg_26_0, var_26_12, var_26_11)
		end

		var_26_12.state = iter_26_3
	end

	if arg_26_0._timer_paused then
		return
	end

	arg_26_0._timer = math.max(arg_26_0._timer - arg_26_2, 0)
end

VersusPartySelectionLogic._client_pre_update = function (arg_27_0, arg_27_1, arg_27_2)
	if not Network.game_session() then
		return
	end

	local var_27_0, var_27_1, var_27_2 = arg_27_0:_local_party_data()

	if not var_27_0 then
		return
	end

	local var_27_3 = VersusPartySelectionLogic.client_states
	local var_27_4 = var_27_0.picker_list[var_27_2].state

	if arg_27_0._first_update then
		local var_27_5 = var_27_3[var_27_4].enter

		if var_27_5 then
			var_27_5(arg_27_0, var_27_0, var_27_1)
		end

		arg_27_0._first_update = false
	end

	var_27_3[var_27_4].run(arg_27_0, var_27_0, var_27_1, arg_27_0._timer, arg_27_1, arg_27_2)

	if arg_27_0._is_server then
		return
	end

	if arg_27_0._timer_paused then
		return
	end

	arg_27_0._timer = math.max(arg_27_0._timer - arg_27_2, 0)
end

VersusPartySelectionLogic._local_party_data = function (arg_28_0)
	if DEDICATED_SERVER then
		return nil, nil, nil
	end

	if not arg_28_0._party_data then
		local var_28_0 = Managers.party:get_num_game_participating_parties()

		if #arg_28_0._pick_data_per_party ~= var_28_0 then
			return
		end

		local var_28_1 = Managers.party
		local var_28_2 = Managers.player:local_player()
		local var_28_3 = var_28_2:unique_id()
		local var_28_4 = var_28_1:get_party_from_unique_id(var_28_3)
		local var_28_5 = arg_28_0._pick_data_per_party[var_28_4.party_id]

		if not var_28_5 then
			return
		end

		arg_28_0._local_player = var_28_2
		arg_28_0._party_data = var_28_5
		arg_28_0._party = var_28_4

		local var_28_6 = arg_28_0._party_data.picker_list

		for iter_28_0, iter_28_1 in ipairs(var_28_6) do
			iter_28_1.status = var_28_4.slots[iter_28_1.slot_id]

			local var_28_7 = iter_28_1.status.player

			if var_28_7 and var_28_7.local_player then
				arg_28_0._picker_list_id = iter_28_0

				break
			end
		end
	end

	return arg_28_0._party_data, arg_28_0._party, arg_28_0._picker_list_id
end

VersusPartySelectionLogic.destroy = function (arg_29_0)
	table.clear(arg_29_0._party_states_lookup)
	table.clear(arg_29_0._client_states_lookup)
	arg_29_0:_unregister_rpcs()
end

VersusPartySelectionLogic._register_rpcs = function (arg_30_0, arg_30_1, arg_30_2)
	arg_30_1:register(arg_30_0, unpack(var_0_1))

	arg_30_0._network_event_delegate = arg_30_1
	arg_30_0._network_transmit = arg_30_2
end

VersusPartySelectionLogic._unregister_rpcs = function (arg_31_0)
	arg_31_0._network_event_delegate:unregister(arg_31_0)

	arg_31_0._network_event_delegate = nil
	arg_31_0._network_transmit = nil
end

VersusPartySelectionLogic.set_ingame_ui = function (arg_32_0, arg_32_1)
	arg_32_0._ingame_ui = arg_32_1
end

VersusPartySelectionLogic.hot_join_sync = function (arg_33_0, arg_33_1)
	arg_33_0:_sync_party_array(arg_33_1)

	local var_33_0 = arg_33_0._pick_data_per_party

	for iter_33_0 = 1, #var_33_0 do
		local var_33_1 = var_33_0[iter_33_0]
		local var_33_2 = var_33_1.party_id
		local var_33_3 = arg_33_0._party_states_lookup[var_33_1.state]
		local var_33_4 = var_33_1.picker_list

		for iter_33_1 = 1, #var_33_4 do
			local var_33_5 = var_33_4[iter_33_1]
			local var_33_6 = var_33_5.picker_index
			local var_33_7 = arg_33_0._client_states_lookup[var_33_5.state]

			arg_33_0._network_transmit:send_rpc("rpc_set_party_state", arg_33_1, var_33_2, var_33_3)

			local var_33_8
			local var_33_9

			if var_0_2[var_33_5.state] >= var_0_2.player_picking_character then
				local var_33_10 = var_33_5.slot_id

				if VersusPartySelectionLogicUtility.picker_index_is_bot(var_33_1, var_33_10) then
					var_33_8, var_33_9 = arg_33_0._profile_synchronizer:get_bot_profile(var_33_2, var_33_10)
				elseif var_33_5.status.peer_id and var_33_5.status.local_player_id then
					var_33_8, var_33_9 = Managers.mechanism:game_mechanism():update_wanted_hero_character(var_33_5.status.peer_id, var_33_5.status.local_player_id, var_33_2)
				else
					Crashify.print_exception("VersusPartySelectionLogic", "Supposed human player missing peer_id and local_player_id. Party: %s, pick id: %s", var_33_2, var_33_6)
				end
			end

			if var_33_8 then
				local var_33_11 = Managers.party:get_party(var_33_2).slots_data[var_33_5.slot_id]
				local var_33_12 = var_33_4[var_33_6].status
				local var_33_13 = var_33_11.slot_melee
				local var_33_14 = var_33_11.slot_ranged
				local var_33_15 = var_33_11.slot_skin
				local var_33_16 = var_33_11.slot_hat
				local var_33_17 = var_33_11.slot_frame
				local var_33_18 = NetworkLookup.item_names[var_33_13 or "n/a"]
				local var_33_19 = NetworkLookup.item_names[var_33_14 or "n/a"]
				local var_33_20 = NetworkLookup.item_names[var_33_15 or "n/a"]
				local var_33_21 = NetworkLookup.item_names[var_33_16 or "n/a"]
				local var_33_22 = NetworkLookup.item_names[var_33_17 or "n/a"]
				local var_33_23 = var_33_12.level
				local var_33_24 = var_33_12.versus_level

				arg_33_0._network_transmit:send_rpc("rpc_sync_player_loadout", arg_33_1, var_33_2, var_33_6, var_33_8, var_33_9, var_33_18, var_33_19, var_33_20, var_33_21, var_33_22, var_33_23, var_33_24)
			end

			arg_33_0._network_transmit:send_rpc("rpc_set_player_state", arg_33_1, var_33_7, var_33_2, var_33_6)
		end
	end

	if arg_33_0._timer > 0 then
		local var_33_25 = Managers.state.network:network_time() + arg_33_0._timer

		arg_33_0._network_transmit:send_rpc("rpc_set_party_selection_logic_timer", arg_33_1, arg_33_0._timer, var_33_25)
	end
end

VersusPartySelectionLogic.get_party_data = function (arg_34_0, arg_34_1)
	local var_34_0 = arg_34_0._pick_data_per_party

	return var_34_0 and var_34_0[arg_34_1]
end

VersusPartySelectionLogic.set_player_state = function (arg_35_0, arg_35_1, arg_35_2, arg_35_3)
	if arg_35_0._is_server then
		local var_35_0 = arg_35_0._client_states_lookup[arg_35_1]

		arg_35_0._network_transmit:send_rpc_clients("rpc_set_player_state", var_35_0, arg_35_2, arg_35_3)
	end

	local var_35_1 = arg_35_0._pick_data_per_party[arg_35_2]
	local var_35_2 = var_35_1.picker_list[arg_35_3]

	if not DEDICATED_SERVER then
		local var_35_3, var_35_4, var_35_5 = arg_35_0:_local_party_data()

		if arg_35_3 == var_35_5 and arg_35_2 == var_35_4.party_id then
			local var_35_6 = VersusPartySelectionLogic.client_states[arg_35_1].enter

			if var_35_6 then
				var_35_6(arg_35_0, var_35_1, var_35_4)
			end
		end
	end

	var_35_2.state = arg_35_1

	Managers.state.event:trigger("party_selection_logic_state_set", arg_35_1, arg_35_2, arg_35_3)
end

VersusPartySelectionLogic.set_party_current_picker = function (arg_36_0, arg_36_1, arg_36_2)
	arg_36_0._network_transmit:send_rpc_clients("rpc_set_party_picking_id", arg_36_1, arg_36_2)

	if not DEDICATED_SERVER then
		arg_36_0._pick_data_per_party[arg_36_1].current_picker_index = arg_36_2
	end
end

VersusPartySelectionLogic.set_timer = function (arg_37_0, arg_37_1)
	arg_37_0._timer = arg_37_1

	if arg_37_0._is_server then
		arg_37_0._current_timer_total = arg_37_1

		local var_37_0 = Managers.state.network:network_time() + arg_37_1

		arg_37_0._network_transmit:send_rpc_clients("rpc_set_party_selection_logic_timer", arg_37_1, var_37_0)
	end
end

VersusPartySelectionLogic._make_available_profile_lookup = function (arg_38_0, arg_38_1, arg_38_2)
	local var_38_0 = {}

	for iter_38_0 = 1, #SPProfiles do
		local var_38_1 = SPProfiles[iter_38_0]

		if var_38_1.affiliation == arg_38_1 and var_38_1.role == arg_38_2 then
			local var_38_2 = ExperienceSettings.get_character_level(var_38_1.display_name)
			local var_38_3 = {}

			for iter_38_1 = 1, #var_38_1.careers do
				if var_38_1.careers[iter_38_1]:is_unlocked_function(var_38_1.display_name, var_38_2) then
					var_38_3[#var_38_3 + 1] = iter_38_1
				end
			end

			if #var_38_3 > 0 then
				var_38_0[var_38_1.index] = var_38_3
			end
		end
	end

	fassert(not table.is_empty(var_38_0) or arg_38_1 == "spectators", "Failed to find any available profiles for " .. arg_38_1)

	return var_38_0
end

VersusPartySelectionLogic.get_character_or_random = function (arg_39_0, arg_39_1, arg_39_2, arg_39_3, arg_39_4)
	if arg_39_1 and arg_39_2 and not arg_39_0:_is_hero_locked(arg_39_1, arg_39_3) then
		return arg_39_1, arg_39_2
	end

	return arg_39_0:get_random_available_character(arg_39_3, arg_39_4)
end

VersusPartySelectionLogic.get_random_available_character = function (arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._random_profile_indices or table.select_map(SPProfiles, function (arg_41_0, arg_41_1)
		if arg_41_1.affiliation == "heroes" then
			return arg_41_1.index
		end
	end)

	arg_40_0._random_profile_indices = var_40_0

	table.shuffle(var_40_0)

	local var_40_1 = arg_40_0._random_career_indices or {
		1,
		2,
		3
	}

	arg_40_0._random_career_indices = var_40_1

	table.shuffle(var_40_1)

	local var_40_2
	local var_40_3

	for iter_40_0 = 1, #var_40_0 do
		for iter_40_1 = 1, #var_40_1 do
			local var_40_4 = var_40_0[iter_40_0]
			local var_40_5 = var_40_1[iter_40_1]
			local var_40_6 = SPProfiles[iter_40_0].careers[iter_40_1].name

			if PlayerUtils.get_career_override(var_40_6) and not arg_40_0:_is_hero_locked(var_40_4, arg_40_1) then
				var_40_2, var_40_3 = var_40_4, var_40_5

				break
			end
		end

		if var_40_2 and var_40_3 then
			break
		end
	end

	if not var_40_2 or not var_40_3 then
		var_40_2, var_40_3 = 1, 1

		table.dump(arg_40_1, "party_data", 3)
		Crashify.print_exception("VersusPartySelectionLogic", "Could not find an available profile.")
	end

	return var_40_2, var_40_3
end

VersusPartySelectionLogic._is_hero_locked = function (arg_42_0, arg_42_1, arg_42_2, arg_42_3)
	if arg_42_0._settings.duplicate_hero_careers_allowed then
		return false
	end

	if not arg_42_1 or arg_42_1 == 0 then
		return true
	end

	local var_42_0 = arg_42_2.party_id
	local var_42_1 = arg_42_0._profile_synchronizer:get_profile_index_reservation(var_42_0, arg_42_1)

	if var_42_1 and var_42_1 ~= arg_42_3 then
		return true
	end

	local var_42_2 = arg_42_2.picker_list

	for iter_42_0 = 1, #var_42_2 do
		local var_42_3 = var_42_2[iter_42_0]

		if var_42_3.state == "player_has_picked_character" and var_42_3.status.profile_index == arg_42_1 and var_42_3.picker_index ~= arg_42_2.current_picker_index then
			return true
		end
	end

	return false
end

VersusPartySelectionLogic._ensure_picker_has_character = function (arg_43_0, arg_43_1, arg_43_2, arg_43_3)
	local var_43_0, var_43_1, var_43_2 = arg_43_0:_peer_from_picker_data(arg_43_1, arg_43_2)
	local var_43_3 = arg_43_1.party_id
	local var_43_4
	local var_43_5

	if VersusPartySelectionLogicUtility.picker_index_is_bot(arg_43_1, arg_43_2) then
		var_43_4, var_43_5 = arg_43_0._profile_synchronizer:get_bot_profile(var_43_3, var_43_2)
	else
		var_43_4, var_43_5 = Managers.mechanism:game_mechanism():update_wanted_hero_character(var_43_0, var_43_1, var_43_3)
	end

	local var_43_6, var_43_7 = arg_43_0:_try_pick_hero(arg_43_1, arg_43_2, var_43_4, var_43_5)

	if arg_43_3 then
		arg_43_0:sync_player_loadout(var_43_6, var_43_7, var_43_3, arg_43_2)
	end

	return var_43_6, var_43_7
end

VersusPartySelectionLogic._peer_from_picker_data = function (arg_44_0, arg_44_1, arg_44_2)
	local var_44_0 = arg_44_1.picker_list[arg_44_2]
	local var_44_1 = var_44_0.status

	return var_44_1.peer_id, var_44_1.local_player_id, var_44_0.slot_id
end

VersusPartySelectionLogic._is_hero_party = function (arg_45_0, arg_45_1)
	return Managers.party:get_party(arg_45_1).name == "heroes"
end

VersusPartySelectionLogic.select_character = function (arg_46_0, arg_46_1, arg_46_2)
	assert(arg_46_1 and arg_46_2, "[VersusPartySelectionLogic] Selecting non-character")

	local var_46_0 = arg_46_0:_local_party_data()
	local var_46_1 = var_46_0.current_picker_index

	if var_46_0.picker_list[var_46_1].status.peer_id ~= Network.peer_id() then
		return
	end

	arg_46_0._network_transmit:send_rpc_server("rpc_party_select_request_pick_hero", var_46_0.party_id, var_46_1, arg_46_1, arg_46_2)
end

VersusPartySelectionLogic._sync_hovered_item = function (arg_47_0, arg_47_1, arg_47_2, arg_47_3, arg_47_4)
	local var_47_0 = Managers.party:get_status_from_unique_id(arg_47_1 .. ":" .. arg_47_2)

	if var_47_0 then
		var_47_0.hovered_profile_index = arg_47_3
		var_47_0.hovered_career_index = arg_47_4
	end
end

VersusPartySelectionLogic.sync_hovered_item = function (arg_48_0, arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	arg_48_0:_sync_hovered_item(arg_48_1, arg_48_2, arg_48_3, arg_48_4)

	if not Managers.state.network or not Managers.state.network:game() then
		return
	end

	if arg_48_0._is_server then
		arg_48_0._network_transmit:send_rpc_clients("rpc_pre_game_sync_hovered_item", arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	else
		arg_48_0._network_transmit:send_rpc_server("rpc_pre_game_sync_hovered_item", arg_48_1, arg_48_2, arg_48_3, arg_48_4)
	end
end

VersusPartySelectionLogic.set_party_timer = function (arg_49_0, arg_49_1)
	local var_49_0 = arg_49_0._picking_settings.player_pick_time * arg_49_1.current_picker_index

	arg_49_1.slider_timer = var_49_0
	arg_49_1.time_finished = var_49_0
end

local function var_0_3(arg_50_0, arg_50_1)
	local var_50_0 = {}
	local var_50_1 = arg_50_0.slots
	local var_50_2 = arg_50_0.slots_data
	local var_50_3 = 0

	for iter_50_0 = 1, arg_50_0.num_slots do
		local var_50_4 = var_50_1[iter_50_0]

		if var_50_4.is_player and var_50_4.peer_id then
			var_50_3 = var_50_3 + 1
			var_50_0[var_50_3] = {
				is_connected = true,
				state = "startup",
				is_bot = false,
				slot_id = iter_50_0,
				status = var_50_4
			}
		end
	end

	if arg_50_1 == "players_first" then
		table.shuffle(var_50_0)
	end

	for iter_50_1 = 1, arg_50_0.num_slots do
		local var_50_5 = var_50_1[iter_50_1]

		if var_50_5.is_bot or not var_50_5.peer_id then
			var_50_3 = var_50_3 + 1
			var_50_0[var_50_3] = {
				is_connected = true,
				state = "startup",
				is_bot = true,
				slot_id = iter_50_1,
				status = var_50_5
			}
		end
	end

	if arg_50_1 == "mix_all" then
		table.shuffle(var_50_0)
	end

	for iter_50_2 = 1, arg_50_0.num_slots do
		local var_50_6 = var_50_0[iter_50_2]

		var_50_6.picker_index = iter_50_2
		var_50_2[var_50_6.slot_id].player_data_id = iter_50_2
	end

	return var_50_0
end

VersusPartySelectionLogic._setup_picking_order = function (arg_51_0)
	local var_51_0 = Managers.state.game_mode:setting("shuffle_character_picking_order")
	local var_51_1 = arg_51_0._pick_data_per_party
	local var_51_2 = Managers.party:game_participating_parties()

	for iter_51_0 = 1, #var_51_2 do
		local var_51_3 = var_51_2[iter_51_0]
		local var_51_4 = var_0_3(var_51_3, var_51_0, true)

		var_51_1[iter_51_0] = {
			current_picker_index = 0,
			state = "startup",
			picker_list = var_51_4,
			party_id = iter_51_0
		}
	end
end

VersusPartySelectionLogic._sync_party_array = function (arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0._pick_data_per_party

	for iter_52_0, iter_52_1 in ipairs(var_52_0) do
		local var_52_1 = iter_52_1.picker_list
		local var_52_2 = {}

		for iter_52_2 = 1, #var_52_1 do
			var_52_2[iter_52_2] = var_52_1[iter_52_2].slot_id
		end

		local var_52_3 = iter_52_1.current_picker_index

		arg_52_0._network_transmit:send_rpc("rpc_set_party_array", arg_52_1, iter_52_0, var_52_2, var_52_3)
	end
end

VersusPartySelectionLogic.sync_player_loadout = function (arg_53_0, arg_53_1, arg_53_2, arg_53_3, arg_53_4)
	local var_53_0, var_53_1, var_53_2 = arg_53_0:_local_party_data()
	local var_53_3 = (var_53_1 and var_53_1.party_id) == arg_53_3 and var_53_2 == arg_53_4
	local var_53_4 = arg_53_0._pick_data_per_party[arg_53_3]
	local var_53_5 = VersusPartySelectionLogicUtility.picker_index_is_bot(var_53_4, arg_53_4)
	local var_53_6
	local var_53_7
	local var_53_8
	local var_53_9
	local var_53_10
	local var_53_11
	local var_53_12

	if arg_53_1 and arg_53_1 > 0 and (var_53_3 or arg_53_0._is_server and var_53_5) then
		var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12 = arg_53_0:_get_loadout(arg_53_1, arg_53_2, var_53_5)

		local var_53_13, var_53_14 = arg_53_0:_peer_from_picker_data(var_53_4, arg_53_4)

		if arg_53_0:_is_hero_party(arg_53_3) and var_53_14 then
			local var_53_15 = Managers.player:player(var_53_13, var_53_14)

			CosmeticUtils.sync_local_player_cosmetics(var_53_15, arg_53_1, arg_53_2)
		end
	else
		var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12 = 1, 1, 1, 1, 1, 1, 0
	end

	arg_53_0:_set_loadout(arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)

	if arg_53_0._is_server then
		arg_53_0._network_transmit:send_rpc_clients("rpc_sync_player_loadout", arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)
	else
		arg_53_0._network_transmit:send_rpc_server("rpc_sync_player_loadout", arg_53_3, arg_53_4, arg_53_1, arg_53_2, var_53_6, var_53_7, var_53_8, var_53_9, var_53_10, var_53_11, var_53_12)
	end
end

VersusPartySelectionLogic._set_loadout = function (arg_54_0, arg_54_1, arg_54_2, arg_54_3, arg_54_4, arg_54_5, arg_54_6, arg_54_7, arg_54_8, arg_54_9, arg_54_10, arg_54_11)
	local var_54_0 = Managers.party:get_party(arg_54_1)
	local var_54_1 = arg_54_0._pick_data_per_party[arg_54_1].picker_list[arg_54_2]
	local var_54_2 = var_54_1.status

	var_54_2.selected_profile_index = arg_54_3
	var_54_2.selected_career_index = arg_54_4
	var_54_2.profile_index = arg_54_3
	var_54_2.career_index = arg_54_4
	var_54_2.level = arg_54_10
	var_54_2.versus_level = arg_54_11

	local var_54_3 = var_54_0.slots_data[var_54_1.slot_id]

	var_54_3.slot_melee = NetworkLookup.item_names[arg_54_5]
	var_54_3.slot_ranged = NetworkLookup.item_names[arg_54_6]
	var_54_3.slot_skin = NetworkLookup.item_names[arg_54_7]
	var_54_3.slot_hat = NetworkLookup.item_names[arg_54_8]
	var_54_3.slot_frame = NetworkLookup.item_names[arg_54_9]
end

VersusPartySelectionLogic._get_loadout = function (arg_55_0, arg_55_1, arg_55_2, arg_55_3)
	local var_55_0 = SPProfiles[arg_55_1]
	local var_55_1 = var_55_0.display_name
	local var_55_2 = var_55_0.careers[arg_55_2]
	local var_55_3 = var_55_2.display_name
	local var_55_4 = var_55_2.item_slot_types_by_slot_name
	local var_55_5 = BackendUtils.get_loadout_item
	local var_55_6 = var_55_4.slot_melee and var_55_5(var_55_3, "slot_melee")
	local var_55_7 = var_55_4.slot_ranged and var_55_5(var_55_3, "slot_ranged")
	local var_55_8 = var_55_4.slot_skin and var_55_5(var_55_3, "slot_skin")
	local var_55_9 = var_55_4.slot_hat and var_55_5(var_55_3, "slot_hat")
	local var_55_10 = var_55_4.slot_frame and var_55_5(var_55_3, "slot_frame")
	local var_55_11 = var_55_6 and NetworkLookup.item_names[var_55_6.key] or 1
	local var_55_12 = var_55_7 and NetworkLookup.item_names[var_55_7.key] or 1
	local var_55_13 = var_55_8 and NetworkLookup.item_names[var_55_8.key] or 1
	local var_55_14 = var_55_9 and NetworkLookup.item_names[var_55_9.key] or 1
	local var_55_15 = var_55_9 and NetworkLookup.item_names[var_55_10.key] or 1
	local var_55_16 = Managers.backend:get_interface("hero_attributes"):get(var_55_1, "experience")
	local var_55_17 = ExperienceSettings.get_level(var_55_16)
	local var_55_18 = arg_55_3 and 0 or ExperienceSettings.get_versus_level()

	return var_55_11, var_55_12, var_55_13, var_55_14, var_55_15, var_55_17, var_55_18
end

VersusPartySelectionLogic.settings = function (arg_56_0)
	return arg_56_0._settings
end

VersusPartySelectionLogic._all_parties_have_picked = function (arg_57_0)
	local var_57_0 = arg_57_0._pick_data_per_party

	for iter_57_0 = 2, #var_57_0 do
		if var_57_0[iter_57_0].state ~= "closing" then
			return false
		end
	end

	if not Managers.state.network.profile_synchronizer:all_synced() then
		return false
	end

	return true
end

VersusPartySelectionLogic.player_joined_party = function (arg_58_0, arg_58_1, arg_58_2, arg_58_3, arg_58_4)
	if arg_58_3 == 0 then
		return
	end

	if not arg_58_0._pick_data_per_party then
		return
	end

	local var_58_0 = Managers.party:get_party(arg_58_3)
	local var_58_1 = arg_58_0._pick_data_per_party[arg_58_3]
	local var_58_2 = var_58_1.picker_list
	local var_58_3

	for iter_58_0 = 1, #var_58_2 do
		if var_58_2[iter_58_0].slot_id == arg_58_4 then
			var_58_3 = iter_58_0

			break
		end
	end

	fassert(var_58_3 ~= nil, "Failed to find slot id")

	local var_58_4 = var_58_2[var_58_3]

	fassert(var_58_4.is_bot ~= false, "Tried to replace human player. Expected to replace bot")

	local var_58_5 = var_58_0.slots[arg_58_4]
	local var_58_6 = var_58_4.status

	var_58_4.status = var_58_5
	var_58_4.is_bot = false

	if not arg_58_0._is_server then
		return
	end

	printf("[VersusPartySelectionLogic] Peer %s joined party %s with pick order %s (state: %s)", arg_58_1, arg_58_3, var_58_3, var_58_4.state)

	if var_0_2[var_58_4.state] >= var_0_2.player_picking_character then
		local var_58_7, var_58_8 = arg_58_0:_ensure_picker_has_character(var_58_1, var_58_3, true)

		printf("[VersusPartySelectionLogic] Peer %s in party %s hot joined and was delegated %s", var_58_5.peer_id, arg_58_3, SPProfiles[var_58_7].careers[var_58_8].display_name)
	end
end

VersusPartySelectionLogic.player_left_party = function (arg_59_0, arg_59_1, arg_59_2, arg_59_3, arg_59_4, arg_59_5)
	if arg_59_3 == 0 then
		return
	end

	local var_59_0 = Managers.party:get_party(arg_59_3)
	local var_59_1 = arg_59_0._pick_data_per_party[arg_59_3]
	local var_59_2 = var_59_1.picker_list
	local var_59_3

	for iter_59_0 = 1, #var_59_2 do
		if var_59_2[iter_59_0].slot_id == arg_59_4 then
			var_59_3 = iter_59_0

			break
		end
	end

	fassert(var_59_3 ~= nil, "Failed to find slot id")

	local var_59_4 = var_59_2[var_59_3]

	var_59_4.is_bot = nil
	var_59_4.status = var_59_0.slots[arg_59_4]

	if not arg_59_0._is_server then
		return
	end

	if var_0_2[var_59_4.state] >= var_0_2.player_picking_character then
		local var_59_5, var_59_6 = arg_59_0:_ensure_picker_has_character(var_59_1, var_59_3, true)
		local var_59_7 = arg_59_5.status and arg_59_5.status.peer_id

		printf("[VersusPartySelectionLogic] %s in party %s and pick id %s left and was replaced by %s", var_59_7 or "UNKNOWN", var_59_0.party_id, var_59_3, SPProfiles[var_59_5].careers[var_59_6].display_name)
	end
end

VersusPartySelectionLogic._try_pick_hero = function (arg_60_0, arg_60_1, arg_60_2, arg_60_3, arg_60_4, arg_60_5)
	local var_60_0 = arg_60_1.party_id
	local var_60_1 = VersusPartySelectionLogicUtility.picker_index_is_bot(arg_60_1, arg_60_2)
	local var_60_2, var_60_3, var_60_4 = arg_60_0:_peer_from_picker_data(arg_60_1, arg_60_2)
	local var_60_5
	local var_60_6

	if var_60_1 then
		var_60_5, var_60_6 = arg_60_0._profile_synchronizer:get_bot_profile(var_60_0, var_60_4)
	else
		var_60_5, var_60_6 = Managers.mechanism:get_persistent_profile_index_reservation(var_60_2)
	end

	if arg_60_0:_is_hero_locked(var_60_5, arg_60_1, var_60_2) then
		var_60_5, var_60_6 = nil
	end

	repeat
		if var_60_5 and var_60_6 and arg_60_3 == var_60_5 and arg_60_4 == var_60_6 then
			break
		end

		local var_60_7 = arg_60_1.picker_list[arg_60_2].state
		local var_60_8 = var_0_2[var_60_7] > var_0_2.player_picking_character

		if var_60_5 and var_60_8 then
			printf("[VersusPartySelectionLogic] %s %s in party %s and pick id %s tried to pick a hero %s %s after timer ran out. Staying as %s %s", var_60_1 and "BOT in slot" or "Peer", var_60_1 and arg_60_2 or var_60_2, var_60_0, arg_60_2, arg_60_3, arg_60_4, var_60_5, var_60_6)

			arg_60_3 = var_60_5
			arg_60_4 = var_60_6

			break
		end

		arg_60_5 = true

		if not arg_60_3 or not arg_60_4 or arg_60_3 == 0 or arg_60_4 == 0 then
			arg_60_3, arg_60_4 = arg_60_0:get_character_or_random(arg_60_3, arg_60_4, arg_60_1, var_60_1)

			printf("[VersusPartySelectionLogic] No profile provided for %s %s. Fallbacking to %s %s.", var_60_1 and "BOT in slot" or "Peer", var_60_1 and arg_60_2 or var_60_2, arg_60_3, arg_60_4)
		elseif arg_60_0:_is_hero_locked(arg_60_3, arg_60_1, var_60_2) then
			local var_60_9 = arg_60_3
			local var_60_10 = arg_60_4

			arg_60_3, arg_60_4 = arg_60_0:get_character_or_random(arg_60_3, arg_60_4, arg_60_1, var_60_1)

			printf("[VersusPartySelectionLogic] %s %s tried to pick locked hero %s %s. Fallbacking to %s %s.", var_60_1 and "BOT in slot" or "Peer", var_60_1 and arg_60_2 or var_60_2, var_60_9, var_60_10, arg_60_3, arg_60_4)
		end

		if var_60_1 then
			arg_60_0._profile_synchronizer:set_bot_profile(var_60_0, var_60_4, arg_60_3, arg_60_4)

			break
		end

		if not Managers.mechanism:try_reserve_profile_for_peer_by_mechanism(var_60_2, arg_60_3, arg_60_4, true) then
			Crashify.print_exception("VersusPartySelectionLogic", "gave peer %s in party %s hero %s, but could not reserve it", var_60_2, var_60_0, arg_60_3)

			arg_60_3 = var_60_5
			arg_60_4 = var_60_6
		end
	until true

	if arg_60_5 then
		arg_60_0:sync_player_loadout(arg_60_3, arg_60_4, var_60_0, arg_60_2)
	end

	return arg_60_3, arg_60_4
end

VersusPartySelectionLogic.rpc_party_select_request_pick_hero = function (arg_61_0, arg_61_1, arg_61_2, arg_61_3, arg_61_4, arg_61_5)
	local var_61_0 = arg_61_0._pick_data_per_party[arg_61_2]
	local var_61_1, var_61_2 = arg_61_0:_try_pick_hero(var_61_0, arg_61_3, arg_61_4, arg_61_5)
	local var_61_3 = var_61_1 == arg_61_4 and " and succeeded" or string.format(", but got hero %s %s", var_61_1, var_61_2)

	printf("[VersusPartySelectionLogic] Peer %s in party %s tried to pick hero %s %s%s", CHANNEL_TO_PEER_ID[arg_61_1], arg_61_2, arg_61_4, arg_61_5, var_61_3)
end

VersusPartySelectionLogic.rpc_set_party_array = function (arg_62_0, arg_62_1, arg_62_2, arg_62_3, arg_62_4)
	local var_62_0 = Managers.party:get_party(arg_62_2)
	local var_62_1 = var_62_0.slots
	local var_62_2 = {}

	for iter_62_0 = 1, #arg_62_3 do
		local var_62_3 = arg_62_3[iter_62_0]
		local var_62_4 = var_62_1[var_62_3]

		var_62_2[iter_62_0] = {
			state = "startup",
			picker_index = iter_62_0,
			slot_id = var_62_3,
			status = var_62_4
		}
	end

	local var_62_5

	if arg_62_0._pick_data_per_party then
		var_62_5 = arg_62_0._pick_data_per_party[arg_62_2]
	end

	if not var_62_5 then
		var_62_5 = {
			current_picker_index = 0,
			state = "startup",
			picker_list = var_62_2,
			party_id = arg_62_2
		}
		arg_62_0._pick_data_per_party[arg_62_2] = var_62_5
	end

	local var_62_6 = GameModeSettings.versus.character_picking_settings.player_pick_time
	local var_62_7 = var_62_0.num_slots

	var_62_5.current_picker_index = arg_62_4
	var_62_5.prev_picker_index = arg_62_4 - 1
	var_62_5.total_slider_time = var_62_6 * var_62_7
end

VersusPartySelectionLogic.rpc_set_party_state = function (arg_63_0, arg_63_1, arg_63_2, arg_63_3)
	arg_63_0._pick_data_per_party[arg_63_2].state = arg_63_0._party_states_lookup[arg_63_3]
end

VersusPartySelectionLogic.rpc_sync_player_loadout = function (arg_64_0, arg_64_1, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	local var_64_0 = CHANNEL_TO_PEER_ID[arg_64_1]

	if not var_64_0 then
		return
	end

	if arg_64_0._is_server then
		local var_64_1 = arg_64_0._pick_data_per_party[arg_64_2]

		if VersusPartySelectionLogicUtility.picker_index_is_bot(var_64_1, arg_64_3) then
			return
		end

		local var_64_2 = var_64_1.picker_list[arg_64_3]
		local var_64_3 = var_64_2.state
		local var_64_4 = var_64_2.status

		if var_0_2[var_64_3] > var_0_2.player_picking_character and (var_64_4.selected_profile_index ~= arg_64_4 or var_64_4.selected_career_index ~= arg_64_5) then
			print("[VersusPartySelectionLogic] Client tried to change loadout of a different character after a character has already been picked. Bouncing back request.")

			local var_64_5, var_64_6 = Managers.mechanism:get_persistent_profile_index_reservation(var_64_4.peer_id)

			arg_64_0._network_transmit:send_rpc("rpc_sync_player_loadout", var_64_0, arg_64_2, arg_64_3, var_64_5, var_64_6, 1, 1, 1, 1, 1, 1, 0)

			return
		end

		arg_64_0._network_transmit:send_rpc_clients_except("rpc_sync_player_loadout", var_64_0, arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	end

	local var_64_7, var_64_8, var_64_9 = arg_64_0:_local_party_data()
	local var_64_10 = var_64_8 and var_64_8.party_id

	if var_64_10 == arg_64_2 and var_64_9 == arg_64_3 then
		print("[VersusPartySelectionLogic] Local player was assigned to", arg_64_4, arg_64_5)
		arg_64_0:sync_player_loadout(arg_64_4, arg_64_5, var_64_10, var_64_9)
	else
		arg_64_0:_set_loadout(arg_64_2, arg_64_3, arg_64_4, arg_64_5, arg_64_6, arg_64_7, arg_64_8, arg_64_9, arg_64_10, arg_64_11, arg_64_12)
	end
end

VersusPartySelectionLogic.rpc_set_player_state = function (arg_65_0, arg_65_1, arg_65_2, arg_65_3, arg_65_4)
	fassert(not arg_65_0._is_server, "Server should never get this")

	local var_65_0 = arg_65_0._client_states_lookup[arg_65_2]

	arg_65_0:set_player_state(var_65_0, arg_65_3, arg_65_4)
end

VersusPartySelectionLogic.rpc_set_party_picking_id = function (arg_66_0, arg_66_1, arg_66_2, arg_66_3)
	arg_66_0._pick_data_per_party[arg_66_2].current_picker_index = arg_66_3
end

VersusPartySelectionLogic.rpc_pre_game_sync_hovered_item = function (arg_67_0, arg_67_1, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	arg_67_0:_sync_hovered_item(arg_67_2, arg_67_3, arg_67_4, arg_67_5)

	if arg_67_0._is_server then
		local var_67_0 = CHANNEL_TO_PEER_ID[arg_67_1]

		arg_67_0._network_transmit:send_rpc_clients_except("rpc_pre_game_sync_hovered_item", var_67_0, arg_67_2, arg_67_3, arg_67_4, arg_67_5)
	end
end

VersusPartySelectionLogic.timer = function (arg_68_0)
	return arg_68_0._timer
end

VersusPartySelectionLogic.on_player_left_party = function (arg_69_0, arg_69_1, arg_69_2, arg_69_3, arg_69_4)
	if arg_69_0._peers_ready then
		arg_69_0._peers_ready[arg_69_1] = nil
	end

	local var_69_0 = arg_69_0._pick_data_per_party[arg_69_3]

	if var_69_0 then
		local var_69_1 = var_69_0.picker_list

		for iter_69_0 = 1, #var_69_1 do
			if var_69_1[iter_69_0].slot_id == arg_69_4 then
				var_69_1[iter_69_0].is_connected = false
			end
		end
	end
end

VersusPartySelectionLogic.rpc_set_party_selection_logic_timer = function (arg_70_0, arg_70_1, arg_70_2, arg_70_3)
	local var_70_0 = Managers.state.network:network_time()

	if var_70_0 == 0 then
		var_70_0 = arg_70_3 - arg_70_2
	end

	arg_70_0._timer_scale = (arg_70_3 - var_70_0) / arg_70_2
	arg_70_0._timer = arg_70_2
end
