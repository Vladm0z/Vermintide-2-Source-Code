-- chunkname: @scripts/network/voip.lua

local function fn(...)
	-- function 1
	local flag = true

	if script_data.debug_voip or not flag then
		printf(...)
	end
end

local function fn_2(...)
	-- function 2
	Application.warning(...)
end

Voip = class(Voip)

local num = -65
local var_0_3 = rawget(_G, "Steam")

if not var_0_3 then
	var_0_3 = rawget(_G, "Steam").connected()
	var_0_3 = not var_0_3 and not Development.parameter("use_lan_backend")
end

local parameter = Development.parameter("disable_voip")

if not var_0_3 and parameter and not DEDICATED_SERVER then
	require("scripts/ui/views/voice_chat_ui")

	Voip.init = function (self, arg_3_1, arg_3_2)
		-- function 3
		self._own_peer_id = Network.peer_id()

		self:_ensure_voip_set_up()
		fn("[Voip] Initializing Steam Voip")

		self._is_server = arg_3_1

		local str = "voip_world"
		local var_3_1
		local var_3_2
		local create_world = Managers.world:create_world(str, GameSettingsDevelopment.default_environment, var_3_1, var_3_2, Application.DISABLE_PHYSICS, Application.DISABLE_APEX_CLOTH, Application.DISABLE_RENDERING)

		self._world = create_world
		self._wwise_world = Wwise.wwise_world(create_world)
		self._member_buffer = {}
		self._voip_rooms = {}
		self._voip_room_by_peer = {}
		self._added_members = {}
		self._muted_peers = {}
		self._peer_playing_id = {}
		self._push_to_talk = Application.user_setting("voip_push_to_talk")
		self._push_to_talk_active = false
		self._enabled = Application.user_setting("voip_is_enabled")

		self:_create_gui()
		Managers.persistent_event:register(self, "on_player_joined_party", "peer_joined_party")
	end

	Voip.set_input_manager = function (self, arg_4_1)
		-- function 4
		self._input_manager = arg_4_1

		if not self._voice_chat_ui then
			self._voice_chat_ui:set_input_manager(arg_4_1)
		end
	end

	Voip._create_gui = function (self, arg_5_1)
		-- function 5
		local world = Managers.world:world("top_ingame_view")

		self._ui_top_renderer = UIRenderer.create(world, "material", "materials/ui/ui_1080p_voice_chat", "material", "materials/fonts/gw_fonts")

		local tbl = {
			player_manager = Managers.player,
			ui_top_renderer = self._ui_top_renderer,
			voip = self
		}

		self._voice_chat_ui = VoiceChatUI:new(tbl)

		self._voice_chat_ui:set_input_manager(Managers.input)
	end

	local tbl = {}

	Voip.members_in_own_room = function (self)
		-- function 6
		table.clear(tbl)

		if not self._own_voip_room_id then
			return tbl
		end

		SteamVoipClient.members(self._own_voip_client, tbl)

		return tbl
	end

	Voip.register_rpcs = function (self, arg_7_1, arg_7_2)
		-- function 7
		self._network_transmit = arg_7_2
		self._network_event_delegate = arg_7_1

		arg_7_1:register(self, "rpc_voip_room_to_join", "rpc_voip_room_request", "room_member_removed")
		arg_7_1:register_with_return(self, "room_member_added")
	end

	Voip.unregister_rpcs = function (self)
		-- function 8
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
		self._network_transmit = nil
	end

	Voip.room_member_removed = function (self, arg_9_1, arg_9_2, arg_9_3)
		-- function 9
		if not arg_9_3 then
			fn_2("[Voip] Got engine callback to remove peer in room %s but peer was nil", arg_9_2)

			return
		end

		self._added_members[arg_9_3] = nil

		local var_9_0 = self._peer_playing_id[arg_9_3]

		if var_9_0 ~= nil then
			WwiseWorld.stop_voip_output(self._wwise_world, var_9_0)

			self._peer_playing_id[arg_9_3] = nil
		end
	end

	Voip.room_member_added = function (self, arg_10_1, arg_10_2)
		-- function 10
		fn("[Voip] Peer %s joined room %s (my room id %q)", arg_10_2, arg_10_1, self._own_voip_room_id)

		self._added_members[arg_10_2] = true

		local start_voip_output = WwiseWorld.start_voip_output(self._wwise_world, "Play_voip")

		self._peer_playing_id[arg_10_2] = start_voip_output

		return start_voip_output
	end

	Voip.rpc_voip_room_request = function (self, arg_11_1, arg_11_2)
		-- function 11
		local var_11_0 = CHANNEL_TO_PEER_ID[arg_11_1]
		local assert = assert
		local _is_server = self._is_server
		local str = "[Voip] Got request from %s to %s but is not server"
		local var_11_4 = var_11_0
		local flag

		flag = not arg_11_2 and "enter" and "leave"

		assert(_is_server, str, var_11_4, flag)

		local get_party_from_player_id = Managers.party:get_party_from_player_id(var_11_0, 1)

		if not (not get_party_from_player_id and get_party_from_player_id.party_id ~= 0) then
			return
		end

		local party_id = get_party_from_player_id.party_id

		if not self:_is_peer_in_party_room(var_11_0, party_id) then
			return
		end

		self:_remove_peer_from_room(var_11_0)
		self:_ensure_voip_room_set_up(party_id)

		if not arg_11_2 then
			self:_add_peer_to_room(var_11_0, party_id)
		end
	end

	Voip.rpc_voip_room_to_join = function (self, arg_12_1, arg_12_2)
		-- function 12
		local var_12_0 = CHANNEL_TO_PEER_ID[arg_12_1]

		if not self:_is_in_room() then
			fn_2("[Voip] Received rpc 'rpc_voip_room_to_join' from host %s but we're already in a room.", var_12_0)

			return
		end

		local var_12_1 = fn
		local str = "[Voip] Joining room %s (host %q) as %s."
		local var_12_3 = arg_12_2
		local var_12_4 = var_12_0
		local flag

		flag = var_12_0 ~= self._own_peer_id or not "host" or "client"

		var_12_1(str, var_12_3, var_12_4, flag)

		self._room_host = var_12_0
		self._own_voip_room_id = arg_12_2

		local join_room = SteamVoip.join_room(var_12_0, arg_12_2)

		self._voip_room_by_peer[self._own_peer_id] = arg_12_2
		self._own_voip_client = join_room

		SteamVoipClient.select_out(join_room, true)
		SteamVoipClient.select_in(join_room, true)
		self:_update_push_to_talk(true)
	end

	Voip.destroy = function (self)
		-- function 13
		fn("[Voip] Destroying VOIP.")
		self:_tear_down()

		self.room_member_removed = nil
		self.room_member_added = nil

		if not self._world then
			Managers.world:destroy_world(self._world)
		end

		self:_destroy_voice_chat_ui()
		Managers.persistent_event:unregister("on_player_joined_party", self)
	end

	Voip._destroy_voice_chat_ui = function (self)
		-- function 14
		self._voice_chat_ui:destroy()

		self._voice_chat_ui = nil

		local world = Managers.world:world("top_ingame_view")

		UIRenderer.destroy(self._ui_top_renderer, world)

		self._ui_top_renderer = nil
	end

	Voip.update = function (self, arg_15_1, arg_15_2)
		-- function 15
		self:_debug_voip(arg_15_2)

		if not self._voip_set_up then
			return
		end

		if not self._own_voip_client then
			if not SteamVoipClient.broken_host(self._own_voip_client) then
				fn_2("[STEAM VOIP]: Connection to host %q broken. Leaving room.", tostring(self._room_host))
				self:_ensure_left_voip_room()
			else
				for k, v in pairs(self._added_members) do
					if not self._muted_peers[k] then
						self:unmute_member(k)
					end

					local _push_to_talk = self._push_to_talk

					_push_to_talk = not _push_to_talk and not self._push_to_talk_active

					if not _push_to_talk then
						fn("[Voip] Muting voip out for %q due to push_to_talk", k)
						SteamVoipClient.select_out(self._own_voip_client, false, k)
					end

					self._added_members[k] = nil
				end

				self:_update_push_to_talk(false)
			end
		end

		if not self._is_server then
			for k_2, v_2 in pairs(self._voip_rooms) do
				local broken_members = SteamVoipRoom.broken_members(v_2)

				if not broken_members then
					for k_3, v_3 in pairs(broken_members) do
						fn("[Voip] Removing broken voip member: %q", tostring(v_3))
						self:_remove_peer_from_room(v_3)

						if self._own_voip_room_id == v_2 then
							SteamVoipClient.select_out(self._own_voip_client, false, v_3)
							SteamVoipClient.select_in(self._own_voip_client, false, v_3)
						end
					end
				end
			end

			if not self:_is_in_room() then
				local members, var_15_3 = SteamVoipRoom.members(self._own_voip_room_id, self._member_buffer)

				for i6 = 1, var_15_3 do
					local var_15_4 = members[i6]

					if not (var_15_4 == self._own_peer_id or PEER_ID_TO_CHANNEL[var_15_4] ~= nil) then
						fn("[Voip] Removing voip member due to not having a connection to it: %q", tostring(var_15_4))
						self:_remove_peer_from_room(var_15_4)
						SteamVoipClient.select_out(self._own_voip_client, false, var_15_4)
						SteamVoipClient.select_in(self._own_voip_client, false, var_15_4)
					end
				end
			end
		end

		if not DEDICATED_SERVER then
			self._voice_chat_ui:update(arg_15_1)
		end
	end

	Voip._debug_voip = function (self, arg_16_1)
		-- function 16
		if not (not script_data.debug_voip and DEDICATED_SERVER) then
			if not self._own_voip_client then
				Debug.text("VoIP")

				local text = Debug.text
				local str = "VoIP - PushToTalk %s (%s)"
				local flag

				flag = not self._push_to_talk and "on" and "off"

				local flag_2

				flag_2 = not self._push_to_talk_active and "pushing" and "-"

				text(str, flag, flag_2)
				Debug.text("VoIP - Client members")

				for k, v in pairs(SteamVoipClient.members(self._own_voip_client)) do
					local audio_level = SteamVoipClient.audio_level(self._own_voip_client, v)

					Debug.text("%s [%s] %s", tostring(k), tostring(v), audio_level)
				end

				if not self._is_server then
					for k_2, v_2 in pairs(self._voip_rooms) do
						Debug.text("VoIP - Room members %s", v_2)

						for k_3, v_3 in pairs(SteamVoipRoom.members(v_2)) do
							if v_2 == self._own_voip_room_id then
								local is_talking = self:is_talking(v_3)
								local _debug_talking_delay = self._debug_talking_delay

								_debug_talking_delay = _debug_talking_delay or {}
								self._debug_talking_delay = _debug_talking_delay

								if not is_talking then
									self._debug_talking_delay[v_3] = arg_16_1 + 0.3
								else
									local var_16_7 = self._debug_talking_delay[v_3]

									var_16_7 = var_16_7 or math.huge

									if var_16_7 < arg_16_1 then
										self._debug_talking_delay[v_3] = nil
									end
								end

								local flag_3 = not self._push_to_talk and self._push_to_talk_active and not not self._debug_talking_delay[v_3]
								local text_2 = Debug.text
								local str_2 = "[%s] Speaking: %s"
								local var_16_11 = v_3
								local flag_4

								flag_4 = not flag_3 and "Yes" and "No"

								text_2(str_2, var_16_11, flag_4)
							else
								Debug.text("[%s] In another room", v_3)
							end
						end
					end
				end
			else
				Debug.text("VoIP - disabled")
			end
		end
	end

	Voip._update_push_to_talk = function (self, arg_17_1)
		-- function 17
		local get_service = Managers.input:get_service("chat_input")
		local _push_to_talk = self._push_to_talk

		_push_to_talk = not _push_to_talk and not get_service and not not get_service:get("voip_push_to_talk")
		_push_to_talk = not _push_to_talk and not Managers.chat:chat_is_focused()

		if _push_to_talk ~= self._push_to_talk_active or not arg_17_1 then
			self._push_to_talk_active = _push_to_talk

			local flag = not self._push_to_talk and _push_to_talk

			for k, v in pairs(SteamVoipClient.members(self._own_voip_client)) do
				if not self._muted_peers[v] then
					SteamVoipClient.select_out(self._own_voip_client, flag, v)

					local var_17_3 = fn
					local str = "[Voip] %s voip out for %s due to %s"
					local flag_2

					flag_2 = not flag and "unmuting" and "muting"

					local var_17_6 = v
					local flag_3

					flag_3 = not self._push_to_talk and "push_to_talk" and "push_to_talk not being active"

					var_17_3(str, flag_2, var_17_6, flag_3)
				end
			end
		end
	end

	Voip.mute_member = function (self, arg_18_1)
		-- function 18
		if self._own_voip_client == nil then
			return
		end

		self._muted_peers[arg_18_1] = true

		local members = SteamVoipClient.members(self._own_voip_client)

		if not table.contains(members, arg_18_1) then
			fn("[Voip] Muting voip member: %q", tostring(arg_18_1))
			SteamVoipClient.select_out(self._own_voip_client, false, arg_18_1)
			SteamVoipClient.select_in(self._own_voip_client, false, arg_18_1)
		end
	end

	Voip.unmute_member = function (self, arg_19_1)
		-- function 19
		if self._own_voip_client == nil then
			return
		end

		self._muted_peers[arg_19_1] = nil

		local members = SteamVoipClient.members(self._own_voip_client)

		if not table.contains(members, arg_19_1) then
			fn("[Voip] Unmuting voip member: %q", tostring(arg_19_1))
			SteamVoipClient.select_out(self._own_voip_client, true, arg_19_1)
			SteamVoipClient.select_in(self._own_voip_client, true, arg_19_1)
		end

		self:_update_push_to_talk(true)
	end

	Voip.peer_muted = function (self, arg_20_1)
		-- function 20
		return self._muted_peers[arg_20_1]
	end

	Voip._ensure_left_voip_room = function (self, arg_21_1)
		-- function 21
		if not self:_is_in_room() then
			return
		end

		fn("[Voip] Leaving VOIP room %s", self._own_voip_room_id)

		for k, v in pairs(self._peer_playing_id) do
			WwiseWorld.stop_voip_output(self._wwise_world, v)
		end

		table.clear(self._peer_playing_id)
		SteamVoip.leave_room(self._own_voip_client)

		self._room_host = nil
		self._own_voip_room_id = nil
		self._own_voip_client = nil
		self._voip_room_by_peer[self._own_peer_id] = nil

		if not self._is_server then
			self:rpc_voip_room_request(PEER_ID_TO_CHANNEL[self._own_peer_id], false)
		elseif not self._network_transmit then
			self._network_transmit:send_rpc_server("rpc_voip_room_request", false)
		end
	end

	Voip._join_voip_room = function (self)
		-- function 22
		if not self:_is_in_room() then
			return
		end

		if not self._is_server then
			self:rpc_voip_room_request(PEER_ID_TO_CHANNEL[self._own_peer_id], true)
		elseif not self._network_transmit then
			fn("[Voip] Asking server to join a voip room")
			self._network_transmit:send_rpc_server("rpc_voip_room_request", true)
		end
	end

	Voip.set_volume = function (self, arg_23_1)
		-- function 23
		assert(not (arg_23_1 >= 0) or arg_23_1 <= 100)
		WwiseWorld.set_global_parameter(self._wwise_world, "voip_bus_volume", arg_23_1)
	end

	Voip.set_enabled = function (self, arg_24_1)
		-- function 24
		if not self._own_peer_id then
			return
		end

		self._enabled = arg_24_1

		if not arg_24_1 then
			self:_join_voip_room()
		else
			self:_ensure_left_voip_room()
		end
	end

	Voip.set_push_to_talk = function (self, arg_25_1)
		-- function 25
		self._push_to_talk = arg_25_1

		if not self._own_voip_client then
			for k, v in pairs(SteamVoipClient.members(self._own_voip_client)) do
				SteamVoipClient.select_out(self._own_voip_client, not arg_25_1, v)
			end
		end
	end

	Voip.is_talking = function (self, arg_26_1)
		-- function 26
		if not self._own_voip_client then
			return false
		end

		if arg_26_1 == self._own_peer_id then
			return (SteamVoipClient.audio_recording(self._own_voip_client))
		else
			return SteamVoipClient.audio_level(self._own_voip_client, arg_26_1) > num
		end
	end

	Voip.is_push_to_talk_active = function (self)
		-- function 27
		local _push_to_talk = self._push_to_talk

		_push_to_talk = not _push_to_talk and self._push_to_talk_active

		return _push_to_talk
	end

	Voip.push_to_talk_enabled = function (self)
		-- function 28
		return self._push_to_talk
	end

	Voip.audio_level = function (self, arg_29_1)
		-- function 29
		return (SteamVoipClient.audio_level(self._own_voip_client, arg_29_1))
	end

	Voip._tear_down = function (self)
		-- function 30
		if not self._voip_set_up then
			return
		end

		fn("[Voip] Resetting Voip")
		self:_ensure_left_voip_room()

		local _voip_rooms = self._voip_rooms

		if not _voip_rooms then
			for k, v in pairs(_voip_rooms) do
				SteamVoip.destroy_room(v)
			end

			table.clear(_voip_rooms)
		end

		self._voip_set_up = false

		SteamVoip.shutdown()
	end

	Voip._ensure_voip_set_up = function (self)
		-- function 31
		if not self._voip_set_up then
			return
		end

		self._voip_set_up = true

		SteamVoip.setup()

		self._voip_rooms = {}
		self._voip_room_by_peer = {}
	end

	Voip._ensure_voip_room_set_up = function (self, arg_32_1)
		-- function 32
		if not self._is_server and not self._voip_rooms[arg_32_1] then
			return
		end

		local create_room = SteamVoip.create_room()

		self._voip_rooms[arg_32_1] = create_room
	end

	Voip._is_in_room = function (self)
		-- function 33
		return self._own_voip_room_id
	end

	local tbl_2 = {}

	Voip._remove_peer_from_room = function (self, arg_34_1)
		-- function 34
		local var_34_0 = self._voip_room_by_peer[arg_34_1]

		if not var_34_0 then
			fn("[Voip] Removing voip member %s from room %s", arg_34_1, var_34_0)
			table.clear(tbl_2)
			SteamVoipRoom.members(var_34_0, tbl_2)

			if not table.find(tbl_2, arg_34_1) then
				SteamVoipRoom.remove_member(var_34_0, arg_34_1)

				self._voip_room_by_peer[arg_34_1] = nil
			end

			SteamVoipRoom.members(var_34_0, tbl_2)

			if not table.is_empty(tbl_2) then
				SteamVoip.destroy_room(var_34_0)

				local find = table.find(self._voip_rooms, var_34_0)

				self._voip_rooms[find] = nil
			end

			if not table.is_empty(self._voip_rooms) then
				-- Nothing
			end
		end
	end

	Voip._add_peer_to_room = function (self, arg_35_1, arg_35_2)
		-- function 35
		assert(self._is_server, "[Voip] '_add_peer_to_room' is a server only function")

		local var_35_0 = self._voip_rooms[arg_35_2]

		fn("[Voip] Adding voip member %s to to room %s", arg_35_1, var_35_0)

		if arg_35_1 == self._own_peer_id then
			self:rpc_voip_room_to_join(PEER_ID_TO_CHANNEL[arg_35_1], var_35_0)
		else
			local members = SteamVoipRoom.members(var_35_0)

			if not table.find(members, arg_35_1) then
				self._voip_room_by_peer[arg_35_1] = var_35_0

				SteamVoipRoom.add_member(var_35_0, arg_35_1)
			end

			self._network_transmit:send_rpc("rpc_voip_room_to_join", arg_35_1, tostring(var_35_0))
		end
	end

	Voip.peer_joined_party = function (self, arg_36_1, arg_36_2, arg_36_3, arg_36_4, arg_36_5)
		-- function 36
		if arg_36_3 == 0 or not arg_36_5 then
			return
		end

		if not self:_is_peer_in_party_room(arg_36_1, arg_36_3) then
			return
		end

		if not self._is_server then
			self:_remove_peer_from_room(arg_36_1)
		end

		if not (arg_36_1 == self._own_peer_id) then
			self:_ensure_left_voip_room(arg_36_1)

			if not self._enabled then
				self:_join_voip_room()
			end
		end
	end

	Voip._is_peer_in_party_room = function (self, arg_37_1, arg_37_2)
		-- function 37
		local var_37_0 = self._voip_room_by_peer[arg_37_1]

		return var_37_0 == nil or var_37_0 == self._voip_rooms[arg_37_2]
	end

	Voip.peer_disconnected = function (self, arg_38_1)
		-- function 38
		if not self._is_server then
			self:_remove_peer_from_room(arg_38_1)
		end
	end
else
	Voip.init = function (arg_39_0)
		-- function 39
		return
	end

	Voip.set_input_manager = function (arg_40_0, arg_40_1)
		-- function 40
		return
	end

	Voip.destroy = function (arg_41_0)
		-- function 41
		return
	end

	Voip.register_rpcs = function (arg_42_0)
		-- function 42
		return
	end

	Voip.unregister_rpcs = function (arg_43_0)
		-- function 43
		return
	end

	Voip.mute_member = function (arg_44_0)
		-- function 44
		return
	end

	Voip.unmute_member = function (arg_45_0)
		-- function 45
		return
	end

	Voip.update = function (arg_46_0)
		-- function 46
		return
	end

	Voip.peer_muted = function (arg_47_0)
		-- function 47
		return
	end

	Voip.set_volume = function (arg_48_0)
		-- function 48
		return
	end

	Voip.set_enabled = function (arg_49_0)
		-- function 49
		return
	end

	Voip.set_push_to_talk = function (arg_50_0)
		-- function 50
		return
	end

	Voip.is_talking = function (arg_51_0)
		-- function 51
		return
	end

	Voip.audio_level = function (arg_52_0)
		-- function 52
		return -96
	end

	Voip.push_to_talk_enabled = function (arg_53_0)
		-- function 53
		return
	end

	Voip.is_push_to_talk_active = function (arg_54_0)
		-- function 54
		return
	end

	Voip.peer_joined_party = function (arg_55_0)
		-- function 55
		return
	end

	local tbl_3 = {}

	Voip.members_in_own_room = function (arg_56_0)
		-- function 56
		return tbl_3
	end

	Voip._tear_down = function (arg_57_0)
		-- function 57
		return
	end

	Voip.peer_disconnected = function (arg_58_0)
		-- function 58
		return
	end
end
