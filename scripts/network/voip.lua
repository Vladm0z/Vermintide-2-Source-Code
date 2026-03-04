-- chunkname: @scripts/network/voip.lua

local function var_0_0(...)
	local var_1_0 = true

	if script_data.debug_voip or var_1_0 then
		printf(...)
	end
end

local function var_0_1(...)
	Application.warning(...)
end

Voip = class(Voip)

local var_0_2 = -65
local var_0_3 = rawget(_G, "Steam") and rawget(_G, "Steam").connected() and not Development.parameter("use_lan_backend")
local var_0_4 = Development.parameter("disable_voip")

if var_0_3 and not var_0_4 or DEDICATED_SERVER then
	require("scripts/ui/views/voice_chat_ui")

	Voip.init = function (arg_3_0, arg_3_1, arg_3_2)
		arg_3_0._own_peer_id = Network.peer_id()

		arg_3_0:_ensure_voip_set_up()
		var_0_0("[Voip] Initializing Steam Voip")

		arg_3_0._is_server = arg_3_1

		local var_3_0 = "voip_world"
		local var_3_1
		local var_3_2
		local var_3_3 = Managers.world:create_world(var_3_0, GameSettingsDevelopment.default_environment, var_3_1, var_3_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH, Application.DISABLE_RENDERING)

		arg_3_0._world = var_3_3
		arg_3_0._wwise_world = Wwise.wwise_world(var_3_3)
		arg_3_0._member_buffer = {}
		arg_3_0._voip_rooms = {}
		arg_3_0._voip_room_by_peer = {}
		arg_3_0._added_members = {}
		arg_3_0._muted_peers = {}
		arg_3_0._peer_playing_id = {}
		arg_3_0._push_to_talk = Application.user_setting("voip_push_to_talk")
		arg_3_0._push_to_talk_active = false
		arg_3_0._enabled = Application.user_setting("voip_is_enabled")

		arg_3_0:_create_gui()
		Managers.persistent_event:register(arg_3_0, "on_player_joined_party", "peer_joined_party")
	end

	Voip.set_input_manager = function (arg_4_0, arg_4_1)
		arg_4_0._input_manager = arg_4_1

		if arg_4_0._voice_chat_ui then
			arg_4_0._voice_chat_ui:set_input_manager(arg_4_1)
		end
	end

	Voip._create_gui = function (arg_5_0, arg_5_1)
		local var_5_0 = Managers.world:world("top_ingame_view")

		arg_5_0._ui_top_renderer = UIRenderer.create(var_5_0, "material", "materials/ui/ui_1080p_voice_chat", "material", "materials/fonts/gw_fonts")

		local var_5_1 = {
			player_manager = Managers.player,
			ui_top_renderer = arg_5_0._ui_top_renderer,
			voip = arg_5_0
		}

		arg_5_0._voice_chat_ui = VoiceChatUI:new(var_5_1)

		arg_5_0._voice_chat_ui:set_input_manager(Managers.input)
	end

	local var_0_5 = {}

	Voip.members_in_own_room = function (arg_6_0)
		table.clear(var_0_5)

		if not arg_6_0._own_voip_room_id then
			return var_0_5
		end

		SteamVoipClient.members(arg_6_0._own_voip_client, var_0_5)

		return var_0_5
	end

	Voip.register_rpcs = function (arg_7_0, arg_7_1, arg_7_2)
		arg_7_0._network_transmit = arg_7_2
		arg_7_0._network_event_delegate = arg_7_1

		arg_7_1:register(arg_7_0, "rpc_voip_room_to_join", "rpc_voip_room_request", "room_member_removed")
		arg_7_1:register_with_return(arg_7_0, "room_member_added")
	end

	Voip.unregister_rpcs = function (arg_8_0)
		arg_8_0._network_event_delegate:unregister(arg_8_0)

		arg_8_0._network_event_delegate = nil
		arg_8_0._network_transmit = nil
	end

	Voip.room_member_removed = function (arg_9_0, arg_9_1, arg_9_2, arg_9_3)
		if not arg_9_3 then
			var_0_1("[Voip] Got engine callback to remove peer in room %s but peer was nil", arg_9_2)

			return
		end

		arg_9_0._added_members[arg_9_3] = nil

		local var_9_0 = arg_9_0._peer_playing_id[arg_9_3]

		if var_9_0 ~= nil then
			WwiseWorld.stop_voip_output(arg_9_0._wwise_world, var_9_0)

			arg_9_0._peer_playing_id[arg_9_3] = nil
		end
	end

	Voip.room_member_added = function (arg_10_0, arg_10_1, arg_10_2)
		var_0_0("[Voip] Peer %s joined room %s (my room id %q)", arg_10_2, arg_10_1, arg_10_0._own_voip_room_id)

		arg_10_0._added_members[arg_10_2] = true

		local var_10_0 = WwiseWorld.start_voip_output(arg_10_0._wwise_world, "Play_voip")

		arg_10_0._peer_playing_id[arg_10_2] = var_10_0

		return var_10_0
	end

	Voip.rpc_voip_room_request = function (arg_11_0, arg_11_1, arg_11_2)
		local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]

		assert(arg_11_0._is_server, "[Voip] Got request from %s to %s but is not server", var_11_0, arg_11_2 and "enter" or "leave")

		local var_11_1 = Managers.party:get_party_from_player_id(var_11_0, 1)

		if not var_11_1 or var_11_1.party_id == 0 then
			return
		end

		local var_11_2 = var_11_1.party_id

		if arg_11_0:_is_peer_in_party_room(var_11_0, var_11_2) then
			return
		end

		arg_11_0:_remove_peer_from_room(var_11_0)
		arg_11_0:_ensure_voip_room_set_up(var_11_2)

		if arg_11_2 then
			arg_11_0:_add_peer_to_room(var_11_0, var_11_2)
		end
	end

	Voip.rpc_voip_room_to_join = function (arg_12_0, arg_12_1, arg_12_2)
		local var_12_0 = CHANNEL_TO_PEER_ID[arg_12_1]

		if arg_12_0:_is_in_room() then
			var_0_1("[Voip] Received rpc 'rpc_voip_room_to_join' from host %s but we're already in a room.", var_12_0)

			return
		end

		var_0_0("[Voip] Joining room %s (host %q) as %s.", arg_12_2, var_12_0, var_12_0 == arg_12_0._own_peer_id and "host" or "client")

		arg_12_0._room_host = var_12_0
		arg_12_0._own_voip_room_id = arg_12_2

		local var_12_1 = SteamVoip.join_room(var_12_0, arg_12_2)

		arg_12_0._voip_room_by_peer[arg_12_0._own_peer_id] = arg_12_2
		arg_12_0._own_voip_client = var_12_1

		SteamVoipClient.select_out(var_12_1, true)
		SteamVoipClient.select_in(var_12_1, true)
		arg_12_0:_update_push_to_talk(true)
	end

	Voip.destroy = function (arg_13_0)
		var_0_0("[Voip] Destroying VOIP.")
		arg_13_0:_tear_down()

		arg_13_0.room_member_removed = nil
		arg_13_0.room_member_added = nil

		if arg_13_0._world then
			Managers.world:destroy_world(arg_13_0._world)
		end

		arg_13_0:_destroy_voice_chat_ui()
		Managers.persistent_event:unregister("on_player_joined_party", arg_13_0)
	end

	Voip._destroy_voice_chat_ui = function (arg_14_0)
		arg_14_0._voice_chat_ui:destroy()

		arg_14_0._voice_chat_ui = nil

		local var_14_0 = Managers.world:world("top_ingame_view")

		UIRenderer.destroy(arg_14_0._ui_top_renderer, var_14_0)

		arg_14_0._ui_top_renderer = nil
	end

	Voip.update = function (arg_15_0, arg_15_1, arg_15_2)
		arg_15_0:_debug_voip(arg_15_2)

		if not arg_15_0._voip_set_up then
			return
		end

		if arg_15_0._own_voip_client then
			if SteamVoipClient.broken_host(arg_15_0._own_voip_client) then
				var_0_1("[STEAM VOIP]: Connection to host %q broken. Leaving room.", tostring(arg_15_0._room_host))
				arg_15_0:_ensure_left_voip_room()
			else
				for iter_15_0, iter_15_1 in pairs(arg_15_0._added_members) do
					if not arg_15_0._muted_peers[iter_15_0] then
						arg_15_0:unmute_member(iter_15_0)
					end

					if arg_15_0._push_to_talk and not arg_15_0._push_to_talk_active then
						var_0_0("[Voip] Muting voip out for %q due to push_to_talk", iter_15_0)
						SteamVoipClient.select_out(arg_15_0._own_voip_client, false, iter_15_0)
					end

					arg_15_0._added_members[iter_15_0] = nil
				end

				arg_15_0:_update_push_to_talk(false)
			end
		end

		if arg_15_0._is_server then
			for iter_15_2, iter_15_3 in pairs(arg_15_0._voip_rooms) do
				local var_15_0 = SteamVoipRoom.broken_members(iter_15_3)

				if var_15_0 then
					for iter_15_4, iter_15_5 in pairs(var_15_0) do
						var_0_0("[Voip] Removing broken voip member: %q", tostring(iter_15_5))
						arg_15_0:_remove_peer_from_room(iter_15_5)

						if arg_15_0._own_voip_room_id == iter_15_3 then
							SteamVoipClient.select_out(arg_15_0._own_voip_client, false, iter_15_5)
							SteamVoipClient.select_in(arg_15_0._own_voip_client, false, iter_15_5)
						end
					end
				end
			end

			if arg_15_0:_is_in_room() then
				local var_15_1, var_15_2 = SteamVoipRoom.members(arg_15_0._own_voip_room_id, arg_15_0._member_buffer)

				for iter_15_6 = 1, var_15_2 do
					local var_15_3 = var_15_1[iter_15_6]

					if var_15_3 ~= arg_15_0._own_peer_id and PEER_ID_TO_CHANNEL[var_15_3] == nil then
						var_0_0("[Voip] Removing voip member due to not having a connection to it: %q", tostring(var_15_3))
						arg_15_0:_remove_peer_from_room(var_15_3)
						SteamVoipClient.select_out(arg_15_0._own_voip_client, false, var_15_3)
						SteamVoipClient.select_in(arg_15_0._own_voip_client, false, var_15_3)
					end
				end
			end
		end

		if not DEDICATED_SERVER then
			arg_15_0._voice_chat_ui:update(arg_15_1)
		end
	end

	Voip._debug_voip = function (arg_16_0, arg_16_1)
		if script_data.debug_voip and not DEDICATED_SERVER then
			if arg_16_0._own_voip_client then
				Debug.text("VoIP")
				Debug.text("VoIP - PushToTalk %s (%s)", arg_16_0._push_to_talk and "on" or "off", arg_16_0._push_to_talk_active and "pushing" or "-")
				Debug.text("VoIP - Client members")

				for iter_16_0, iter_16_1 in pairs(SteamVoipClient.members(arg_16_0._own_voip_client)) do
					local var_16_0 = SteamVoipClient.audio_level(arg_16_0._own_voip_client, iter_16_1)

					Debug.text("%s [%s] %s", tostring(iter_16_0), tostring(iter_16_1), var_16_0)
				end

				if arg_16_0._is_server then
					for iter_16_2, iter_16_3 in pairs(arg_16_0._voip_rooms) do
						Debug.text("VoIP - Room members %s", iter_16_3)

						for iter_16_4, iter_16_5 in pairs(SteamVoipRoom.members(iter_16_3)) do
							if iter_16_3 == arg_16_0._own_voip_room_id then
								local var_16_1 = arg_16_0:is_talking(iter_16_5)

								arg_16_0._debug_talking_delay = arg_16_0._debug_talking_delay or {}

								if var_16_1 then
									arg_16_0._debug_talking_delay[iter_16_5] = arg_16_1 + 0.3
								elseif arg_16_1 > (arg_16_0._debug_talking_delay[iter_16_5] or math.huge) then
									arg_16_0._debug_talking_delay[iter_16_5] = nil
								end

								local var_16_2 = (not arg_16_0._push_to_talk or arg_16_0._push_to_talk_active) and not not arg_16_0._debug_talking_delay[iter_16_5]

								Debug.text("[%s] Speaking: %s", iter_16_5, var_16_2 and "Yes" or "No")
							else
								Debug.text("[%s] In another room", iter_16_5)
							end
						end
					end
				end
			else
				Debug.text("VoIP - disabled")
			end
		end
	end

	Voip._update_push_to_talk = function (arg_17_0, arg_17_1)
		local var_17_0 = Managers.input:get_service("chat_input")
		local var_17_1 = arg_17_0._push_to_talk and not not var_17_0 and not not var_17_0:get("voip_push_to_talk")

		var_17_1 = var_17_1 and not Managers.chat:chat_is_focused()

		if var_17_1 ~= arg_17_0._push_to_talk_active or arg_17_1 then
			arg_17_0._push_to_talk_active = var_17_1

			local var_17_2 = not arg_17_0._push_to_talk or var_17_1

			for iter_17_0, iter_17_1 in pairs(SteamVoipClient.members(arg_17_0._own_voip_client)) do
				if not arg_17_0._muted_peers[iter_17_1] then
					SteamVoipClient.select_out(arg_17_0._own_voip_client, var_17_2, iter_17_1)
					var_0_0("[Voip] %s voip out for %s due to %s", var_17_2 and "unmuting" or "muting", iter_17_1, arg_17_0._push_to_talk and "push_to_talk" or "push_to_talk not being active")
				end
			end
		end
	end

	Voip.mute_member = function (arg_18_0, arg_18_1)
		if arg_18_0._own_voip_client == nil then
			return
		end

		arg_18_0._muted_peers[arg_18_1] = true

		local var_18_0 = SteamVoipClient.members(arg_18_0._own_voip_client)

		if table.contains(var_18_0, arg_18_1) then
			var_0_0("[Voip] Muting voip member: %q", tostring(arg_18_1))
			SteamVoipClient.select_out(arg_18_0._own_voip_client, false, arg_18_1)
			SteamVoipClient.select_in(arg_18_0._own_voip_client, false, arg_18_1)
		end
	end

	Voip.unmute_member = function (arg_19_0, arg_19_1)
		if arg_19_0._own_voip_client == nil then
			return
		end

		arg_19_0._muted_peers[arg_19_1] = nil

		local var_19_0 = SteamVoipClient.members(arg_19_0._own_voip_client)

		if table.contains(var_19_0, arg_19_1) then
			var_0_0("[Voip] Unmuting voip member: %q", tostring(arg_19_1))
			SteamVoipClient.select_out(arg_19_0._own_voip_client, true, arg_19_1)
			SteamVoipClient.select_in(arg_19_0._own_voip_client, true, arg_19_1)
		end

		arg_19_0:_update_push_to_talk(true)
	end

	Voip.peer_muted = function (arg_20_0, arg_20_1)
		return arg_20_0._muted_peers[arg_20_1]
	end

	Voip._ensure_left_voip_room = function (arg_21_0, arg_21_1)
		if not arg_21_0:_is_in_room() then
			return
		end

		var_0_0("[Voip] Leaving VOIP room %s", arg_21_0._own_voip_room_id)

		for iter_21_0, iter_21_1 in pairs(arg_21_0._peer_playing_id) do
			WwiseWorld.stop_voip_output(arg_21_0._wwise_world, iter_21_1)
		end

		table.clear(arg_21_0._peer_playing_id)
		SteamVoip.leave_room(arg_21_0._own_voip_client)

		arg_21_0._room_host = nil
		arg_21_0._own_voip_room_id = nil
		arg_21_0._own_voip_client = nil
		arg_21_0._voip_room_by_peer[arg_21_0._own_peer_id] = nil

		if arg_21_0._is_server then
			arg_21_0:rpc_voip_room_request(PEER_ID_TO_CHANNEL[arg_21_0._own_peer_id], false)
		elseif arg_21_0._network_transmit then
			arg_21_0._network_transmit:send_rpc_server("rpc_voip_room_request", false)
		end
	end

	Voip._join_voip_room = function (arg_22_0)
		if arg_22_0:_is_in_room() then
			return
		end

		if arg_22_0._is_server then
			arg_22_0:rpc_voip_room_request(PEER_ID_TO_CHANNEL[arg_22_0._own_peer_id], true)
		elseif arg_22_0._network_transmit then
			var_0_0("[Voip] Asking server to join a voip room")
			arg_22_0._network_transmit:send_rpc_server("rpc_voip_room_request", true)
		end
	end

	Voip.set_volume = function (arg_23_0, arg_23_1)
		assert(arg_23_1 >= 0 and arg_23_1 <= 100)
		WwiseWorld.set_global_parameter(arg_23_0._wwise_world, "voip_bus_volume", arg_23_1)
	end

	Voip.set_enabled = function (arg_24_0, arg_24_1)
		if not arg_24_0._own_peer_id then
			return
		end

		arg_24_0._enabled = arg_24_1

		if arg_24_1 then
			arg_24_0:_join_voip_room()
		else
			arg_24_0:_ensure_left_voip_room()
		end
	end

	Voip.set_push_to_talk = function (arg_25_0, arg_25_1)
		arg_25_0._push_to_talk = arg_25_1

		if arg_25_0._own_voip_client then
			for iter_25_0, iter_25_1 in pairs(SteamVoipClient.members(arg_25_0._own_voip_client)) do
				SteamVoipClient.select_out(arg_25_0._own_voip_client, not arg_25_1, iter_25_1)
			end
		end
	end

	Voip.is_talking = function (arg_26_0, arg_26_1)
		if not arg_26_0._own_voip_client then
			return false
		end

		if arg_26_1 == arg_26_0._own_peer_id then
			return (SteamVoipClient.audio_recording(arg_26_0._own_voip_client))
		else
			return SteamVoipClient.audio_level(arg_26_0._own_voip_client, arg_26_1) > var_0_2
		end
	end

	Voip.is_push_to_talk_active = function (arg_27_0)
		return arg_27_0._push_to_talk and arg_27_0._push_to_talk_active
	end

	Voip.push_to_talk_enabled = function (arg_28_0)
		return arg_28_0._push_to_talk
	end

	Voip.audio_level = function (arg_29_0, arg_29_1)
		return (SteamVoipClient.audio_level(arg_29_0._own_voip_client, arg_29_1))
	end

	Voip._tear_down = function (arg_30_0)
		if not arg_30_0._voip_set_up then
			return
		end

		var_0_0("[Voip] Resetting Voip")
		arg_30_0:_ensure_left_voip_room()

		local var_30_0 = arg_30_0._voip_rooms

		if var_30_0 then
			for iter_30_0, iter_30_1 in pairs(var_30_0) do
				SteamVoip.destroy_room(iter_30_1)
			end

			table.clear(var_30_0)
		end

		arg_30_0._voip_set_up = false

		SteamVoip.shutdown()
	end

	Voip._ensure_voip_set_up = function (arg_31_0)
		if arg_31_0._voip_set_up then
			return
		end

		arg_31_0._voip_set_up = true

		SteamVoip.setup()

		arg_31_0._voip_rooms = {}
		arg_31_0._voip_room_by_peer = {}
	end

	Voip._ensure_voip_room_set_up = function (arg_32_0, arg_32_1)
		if not arg_32_0._is_server or arg_32_0._voip_rooms[arg_32_1] then
			return
		end

		local var_32_0 = SteamVoip.create_room()

		arg_32_0._voip_rooms[arg_32_1] = var_32_0
	end

	Voip._is_in_room = function (arg_33_0)
		return arg_33_0._own_voip_room_id
	end

	local var_0_6 = {}

	Voip._remove_peer_from_room = function (arg_34_0, arg_34_1)
		local var_34_0 = arg_34_0._voip_room_by_peer[arg_34_1]

		if var_34_0 then
			var_0_0("[Voip] Removing voip member %s from room %s", arg_34_1, var_34_0)
			table.clear(var_0_6)
			SteamVoipRoom.members(var_34_0, var_0_6)

			if table.find(var_0_6, arg_34_1) then
				SteamVoipRoom.remove_member(var_34_0, arg_34_1)

				arg_34_0._voip_room_by_peer[arg_34_1] = nil
			end

			SteamVoipRoom.members(var_34_0, var_0_6)

			if table.is_empty(var_0_6) then
				SteamVoip.destroy_room(var_34_0)

				local var_34_1 = table.find(arg_34_0._voip_rooms, var_34_0)

				arg_34_0._voip_rooms[var_34_1] = nil
			end

			if table.is_empty(arg_34_0._voip_rooms) then
				-- Nothing
			end
		end
	end

	Voip._add_peer_to_room = function (arg_35_0, arg_35_1, arg_35_2)
		assert(arg_35_0._is_server, "[Voip] '_add_peer_to_room' is a server only function")

		local var_35_0 = arg_35_0._voip_rooms[arg_35_2]

		var_0_0("[Voip] Adding voip member %s to to room %s", arg_35_1, var_35_0)

		if arg_35_1 == arg_35_0._own_peer_id then
			arg_35_0:rpc_voip_room_to_join(PEER_ID_TO_CHANNEL[arg_35_1], var_35_0)
		else
			local var_35_1 = SteamVoipRoom.members(var_35_0)

			if not table.find(var_35_1, arg_35_1) then
				arg_35_0._voip_room_by_peer[arg_35_1] = var_35_0

				SteamVoipRoom.add_member(var_35_0, arg_35_1)
			end

			arg_35_0._network_transmit:send_rpc("rpc_voip_room_to_join", arg_35_1, tostring(var_35_0))
		end
	end

	Voip.peer_joined_party = function (arg_36_0, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
		if arg_36_3 == 0 or arg_36_5 then
			return
		end

		if arg_36_0:_is_peer_in_party_room(arg_36_1, arg_36_3) then
			return
		end

		if arg_36_0._is_server then
			arg_36_0:_remove_peer_from_room(arg_36_1)
		end

		if arg_36_1 == arg_36_0._own_peer_id then
			arg_36_0:_ensure_left_voip_room(arg_36_1)

			if arg_36_0._enabled then
				arg_36_0:_join_voip_room()
			end
		end
	end

	Voip._is_peer_in_party_room = function (arg_37_0, arg_37_1, arg_37_2)
		local var_37_0 = arg_37_0._voip_room_by_peer[arg_37_1]

		return var_37_0 ~= nil and var_37_0 == arg_37_0._voip_rooms[arg_37_2]
	end

	Voip.peer_disconnected = function (arg_38_0, arg_38_1)
		if arg_38_0._is_server then
			arg_38_0:_remove_peer_from_room(arg_38_1)
		end
	end
else
	Voip.init = function (arg_39_0)
		return
	end

	Voip.set_input_manager = function (arg_40_0, arg_40_1)
		return
	end

	Voip.destroy = function (arg_41_0)
		return
	end

	Voip.register_rpcs = function (arg_42_0)
		return
	end

	Voip.unregister_rpcs = function (arg_43_0)
		return
	end

	Voip.mute_member = function (arg_44_0)
		return
	end

	Voip.unmute_member = function (arg_45_0)
		return
	end

	Voip.update = function (arg_46_0)
		return
	end

	Voip.peer_muted = function (arg_47_0)
		return
	end

	Voip.set_volume = function (arg_48_0)
		return
	end

	Voip.set_enabled = function (arg_49_0)
		return
	end

	Voip.set_push_to_talk = function (arg_50_0)
		return
	end

	Voip.is_talking = function (arg_51_0)
		return
	end

	Voip.audio_level = function (arg_52_0)
		return -96
	end

	Voip.push_to_talk_enabled = function (arg_53_0)
		return
	end

	Voip.is_push_to_talk_active = function (arg_54_0)
		return
	end

	Voip.peer_joined_party = function (arg_55_0)
		return
	end

	local var_0_7 = {}

	Voip.members_in_own_room = function (arg_56_0)
		return var_0_7
	end

	Voip._tear_down = function (arg_57_0)
		return
	end

	Voip.peer_disconnected = function (arg_58_0)
		return
	end
end
