-- chunkname: @scripts/managers/twitch/twitch_manager.lua

require("scripts/settings/twitch_settings")

DEBUG_TWITCH = false

local num = 15
local num_2 = 2
local num_3 = 6
local num_4 = 5

local function fn(arg_1_0, ...)
	-- function 1
	if not DEBUG_TWITCH then
		if type(arg_1_0) == "table" then
			table.dump(arg_1_0, "[TwitchManager]")
		else
			print("[TwitchManager] " .. string.format(arg_1_0, ...))
		end
	end
end

local tbl = {
	"rpc_update_twitch_vote"
}

TwitchManager = class(TwitchManager)

TwitchManager.init = function (self)
	-- function 2
	self._address = "irc.chat.twitch.tv"
	self._port = 6667
	self._votes = {}
	self._votes_lookup_table = {}
	self._vote_key_index = 1
	self._connecting = false
	self._connected = false
	self._sound_bank_loaded = false
	self._twitch_user_name = ""
	self._game_object_ids = {}
	self._vote_key_to_go_id = {}
	self.locked_breed_packages = {}

	if not IS_WINDOWS then
		self._rest_interface = Managers.rest_transport
	else
		self._rest_interface = Managers.curl
	end

	self._twitch_settings = Application.settings().twitch

	fn(Application.settings("twitch"))

	TwitchSettings.default_downtime = math.max(1, Application.user_setting("twitch_time_between_votes"))
	TwitchSettings.default_vote_time = math.max(1, Application.user_setting("twitch_vote_time"))
	TwitchSettings.difficulty = Application.user_setting("twitch_difficulty")

	local user_setting = Application.user_setting("twitch_disable_positive_votes")

	TwitchSettings.disable_giving_items = user_setting == TwitchSettings.positive_vote_options.disable_giving_items or user_setting == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_positive_votes = user_setting == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_mutators = Application.user_setting("twitch_disable_mutators")
	TwitchSettings.spawn_amount_multiplier = math.clamp(Application.user_setting("twitch_spawn_amount"), 1, 3)
	TwitchSettings.mutator_duration_multiplier = math.clamp(Application.user_setting("twitch_mutator_duration"), 1, 3)

	if TwitchSettings.default_downtime + TwitchSettings.default_vote_time < 5 then
		TwitchSettings.default_downtime = 1
		TwitchSettings.default_vote_time = 5
	end

	self._debug_vote_timer = 0.25
end

local tbl_2 = {
	cataclysm = true,
	cataclysm_3 = true,
	hardest = true,
	cataclysm_2 = true
}

TwitchManager.game_mode_supported = function (arg_3_0, arg_3_1, arg_3_2)
	-- function 3
	return not not TwitchSettings.supported_game_modes[PLATFORM][arg_3_1] or not not tbl_2[arg_3_2]
end

TwitchManager.stream_type = function (arg_4_0)
	-- function 4
	return "twitch"
end

TwitchManager._load_sound_bank = function (self)
	-- function 5
	if not self._sound_bank_loaded then
		local str = "resource_packages/ingame_sounds_twitch_mode"

		fn("Loading twitch mode sound bank resource package %s", str)
		Managers.package:load(str, "twitch", nil, true)

		self._sound_bank_loaded = true
	end
end

TwitchManager._unload_sound_bank = function (self)
	-- function 6
	if not self._sound_bank_loaded then
		local str = "resource_packages/ingame_sounds_twitch_mode"

		fn("Unloading twitch mode sound bank resource package %s", str)
		Managers.package:unload(str, "twitch")

		self._sound_bank_loaded = false
	end
end

TwitchManager.connect = function (self, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	-- function 7
	fassert(arg_7_1, "[TwitchManager] You need to provide a user name to connect")

	local str = "https://api.twitch.tv/helix/users?login=" .. arg_7_1
	local tbl = {}

	if not IS_WINDOWS then
		tbl[Managers.curl._curl.OPT_SSL_OPTIONS] = Managers.curl._curl.SSLOPT_NO_REVOKE
	end

	local var_7_2

	if not IS_CONSOLE then
		var_7_2 = {
			"Content-Type",
			"application/json",
			"Client-ID",
			self._twitch_settings.client_id,
			"Authorization",
			"Bearer " .. Managers.backend:get_twitch_app_access_token()
		}
	else
		var_7_2 = {
			"Content-Type: application/json",
			"Client-ID: " .. self._twitch_settings.client_id,
			"Authorization: Bearer " .. Managers.backend:get_twitch_app_access_token()
		}
	end

	self._headers = var_7_2
	self._connecting = true
	self._connection_failure_callback = arg_7_2
	self._connection_success_callback = arg_7_3
	self._twitch_user_name = arg_7_1

	if not arg_7_4 then
		self._num_retries = 0
	end

	self._rest_interface:get(str, self._headers, callback(self, "cb_on_user_info_received"), {
		"User Data",
		arg_7_1
	}, tbl)
end

TwitchManager.cb_on_user_info_received = function (self, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	-- function 8
	self:_show_result_info(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)

	if not arg_8_1 then
		local flag = not arg_8_4 and cjson.decode(arg_8_4)

		if not flag then
			if not (flag.status ~= 401 or not (self._num_retries < num_3)) then
				self._should_retry = true
				self._next_retry_time = Managers.time:time("main") + num_4
			elseif not flag.error then
				local format = string.format(Localize("start_game_window_twitch_error_connection"), flag.message, flag.error, arg_8_2)

				Application.error("[TwitchManager] " .. format)

				if not self._connection_failure_callback then
					self._connection_failure_callback(format)
				end
			elseif not (not flag.data and not (#flag.data > 0)) then
				local var_8_2 = flag.data[1]
				local id = var_8_2.id
				local login = var_8_2.login

				if not self._connection_success_callback then
					self._connection_success_callback(var_8_2)
				end

				local str = "https://api.twitch.tv/helix/streams?user_id=" .. id
				local tbl = {}

				self._rest_interface:get(str, self._headers, callback(self, "cb_on_user_streams_received"), {
					"User Data",
					login
				}, tbl)

				return
			else
				local format_2 = string.format(Localize("start_game_window_twitch_error_no_user"), arg_8_5[2])

				Application.error("[TwitchManager] " .. format_2)

				if not self._connection_failure_callback then
					self._connection_failure_callback(format_2)
				end
			end
		else
			local var_8_8 = Localize("start_game_window_twitch_error_parsing_results")

			Application.error("[TwitchManager] " .. var_8_8)

			if not self._connection_failure_callback then
				self._connection_failure_callback(var_8_8)
			end
		end
	elseif self._num_retries < num_3 then
		self._should_retry = true
		self._next_retry_time = Managers.time:time("main") + num_4
	else
		local var_8_9 = Localize("start_game_window_twitch_error_generic")

		Application.error("[TwitchManager] " .. var_8_9)

		if not self._connection_failure_callback then
			self._connection_failure_callback(var_8_9)
		end
	end

	if not self._should_retry then
		self._connecting = false
		self._connection_failure_callback = nil
	end
end

TwitchManager.cb_request_twitch_access_token = function (self, arg_9_1)
	-- function 9
	self._num_retries = self._num_retries + 1

	if not arg_9_1 then
		self:connect(self._twitch_user_name, self._connection_failure_callback, self._connection_success_callback, true)
	else
		local var_9_0 = Localize("start_game_window_twitch_error_generic")

		Application.error("[TwitchManager] " .. var_9_0)

		if not self._connection_failure_callback then
			self._connection_failure_callback(var_9_0)
		end

		self._connecting = false
		self._connection_failure_callback = nil
	end
end

TwitchManager.cb_on_user_streams_received = function (self, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	-- function 10
	self:_show_result_info(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)

	if not arg_10_1 then
		local decode = cjson.decode(arg_10_4)

		if not decode then
			local var_10_1 = decode.data[1]

			if not (not var_10_1 and type(var_10_1) ~= "table") then
				local user_login = var_10_1.user_login

				if not user_login then
					local str = "#" .. user_login
					local tbl = {
						port = 6667,
						allow_send = false,
						address = "irc.chat.twitch.tv",
						channel_name = str
					}

					Managers.irc:connect(nil, nil, tbl, callback(self, "cb_on_notify_connected"))

					return
				end
			end
		end
	end

	local format = string.format(Localize("start_game_window_twitch_error_no_active_streams"), arg_10_5[2], arg_10_2)

	Application.error("[TwitchManager] " .. format)

	if not self._connection_failure_callback then
		self._connection_failure_callback(format)
	end

	self._connecting = false
	self._connection_failure_callback = nil
end

TwitchManager.cb_on_notify_connected = function (self, arg_11_1)
	-- function 11
	self._connected = arg_11_1
	self._connecting = false

	if self._connected or not self._twitch_game_mode then
		self._twitch_game_mode:destroy(true)

		self._twitch_game_mode = nil
	end

	local error = Application.error
	local format = string.format
	local str = "[TwitchManager] %s %s Twitch!"
	local flag

	flag = not arg_11_1 and "Connected" and "Disconnected"

	local flag_2

	flag_2 = not arg_11_1 and "to" and "from"

	error(format(str, flag, flag_2))

	local network = Managers.state.network

	network = not network and Managers.state.network.is_server

	if (arg_11_1 or not self._activated) and not network then
		self._popup_id = Managers.popup:queue_popup(Localize("popup_disconnected_from_twitch"), Localize("popup_header_error_twitch"), "return_to_inn", Localize("button_ok"))

		local network_2 = Managers.state.network

		if not network_2 then
			local num = 0
			local num_2 = 0
			local num_3 = 1
			local str_2 = ""

			network_2.network_transmit:send_rpc_clients("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_disconnected_from_twitch, num, str_2, num_2, num_3)
		end

		self._activated = false
	end
end

TwitchManager._show_result_info = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	-- function 12
	if not DEBUG_TWITCH then
		return
	end

	if not arg_12_1 then
		fn("")
		fn("RECEIVED: %s", arg_12_5[1])

		local decode = cjson.decode(arg_12_4)

		table.dump(decode, "DATA", 3, fn)
	else
		fn("")
		fn("FAILED RECEIVING: %s", arg_12_5[1])
		fn("Error code: %s", arg_12_2)
	end
end

TwitchManager.is_connected = function (self)
	-- function 13
	return self._connected
end

TwitchManager.is_connecting = function (self)
	-- function 14
	return self._connecting
end

TwitchManager.user_name = function (self)
	-- function 15
	return self._twitch_user_name
end

TwitchManager.cb_game_session_disconnect = function (arg_16_0)
	-- function 16
	return
end

TwitchManager.cb_connection_error_callback = function (self, arg_17_1)
	-- function 17
	if not self._error_popup_id then
		self._error_popup_id = Managers.popup:queue_popup(arg_17_1, Localize("popup_header_error_twitch"), "ok", Localize("popup_choice_ok"))
	end
end

TwitchManager.add_game_object_id = function (self, arg_18_1)
	-- function 18
	local network = Managers.state.network

	network = not network and Managers.state.network:game()

	if not network then
		local game_object_field = GameSession.game_object_field(network, arg_18_1, "vote_key")

		self._game_object_ids[game_object_field] = arg_18_1
		self._vote_key_to_go_id[arg_18_1] = game_object_field

		self:_register_networked_vote(arg_18_1)
	end
end

TwitchManager.remove_game_object_id = function (self, arg_19_1)
	-- function 19
	local network = Managers.state.network

	network = not network and Managers.state.network:game()

	if not network then
		local var_19_1 = self._vote_key_to_go_id[arg_19_1]

		self._game_object_ids[var_19_1] = nil
		self._vote_key_to_go_id[arg_19_1] = nil

		self:unregister_vote(var_19_1)
	end
end

TwitchManager._update_game_object = function (self, arg_20_1, arg_20_2)
	-- function 20
	local network = Managers.state.network

	network = not network and Managers.state.network:game()

	if not network then
		local var_20_1 = self._game_object_ids[arg_20_1]

		if not var_20_1 then
			GameSession.set_game_object_field(network, var_20_1, "options", arg_20_2.options)
			GameSession.set_game_object_field(network, var_20_1, "time", math.max(math.ceil(arg_20_2.timer), 0))
		end
	end
end

TwitchManager._register_networked_vote = function (self, arg_21_1)
	-- function 21
	local network = Managers.state.network

	network = not network and Managers.state.network:game()

	fassert(network, "[TwitchManager] You need to have an active game session to be able to register votes")

	local game_object_field = GameSession.game_object_field(network, arg_21_1, "vote_key")
	local var_21_2 = NetworkLookup.twitch_vote_types[GameSession.game_object_field(network, arg_21_1, "vote_type")]
	local tbl = {
		TwitchSettings[var_21_2].default_vote_a_str,
		TwitchSettings[var_21_2].default_vote_b_str,
		TwitchSettings[var_21_2].default_vote_c_str,
		TwitchSettings[var_21_2].default_vote_d_str,
		TwitchSettings[var_21_2].default_vote_e_str
	}
	local game_object_field_2 = GameSession.game_object_field(network, arg_21_1, "options")
	local game_object_field_3 = GameSession.game_object_field(network, arg_21_1, "vote_templates")
	local tbl_2 = {}

	for i, v in ipairs(game_object_field_3) do
		local var_21_7 = rawget(NetworkLookup.twitch_vote_templates, v)

		var_21_7 = var_21_7 or "none"
		tbl_2[i] = var_21_7
	end

	local game_object_field_4 = GameSession.game_object_field(network, arg_21_1, "time")
	local game_object_field_5 = GameSession.game_object_field(network, arg_21_1, "show_vote_ui")

	self._votes[#self._votes + 1] = {
		activated = true,
		timer = game_object_field_4,
		option_strings = tbl,
		options = game_object_field_2,
		vote_templates = tbl_2,
		vote_key = game_object_field,
		vote_type = var_21_2,
		show_vote_ui = game_object_field_5
	}
	self._votes_lookup_table[game_object_field] = self._votes[#self._votes]

	Managers.irc:register_message_callback(game_object_field, Irc.CHANNEL_MSG, callback(self, "on_client_message_received"))

	if not self._votes[#self._votes].show_vote_ui then
		Managers.state.event:trigger("add_vote_ui", game_object_field)
	end
end

TwitchManager.register_vote = function (self, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	-- function 22
	local network = Managers.state.network

	fassert(self._connected, "[TwitchManager] You need to be connected to be able to trigger twitch votes")
	fassert(not network and network:game(), "[TwitchManager] You need to have an active game session to be able to register votes")

	local tbl = {
		TwitchSettings[arg_22_2].default_vote_a_str,
		TwitchSettings[arg_22_2].default_vote_b_str,
		TwitchSettings[arg_22_2].default_vote_c_str,
		TwitchSettings[arg_22_2].default_vote_d_str,
		TwitchSettings[arg_22_2].default_vote_e_str
	}
	local tbl_2 = {
		0,
		0,
		0,
		0
	}

	for i, v in ipairs(arg_22_4) do
		tbl_2[i] = v
	end

	local _vote_key_index = self._vote_key_index

	self._votes[#self._votes + 1] = {
		activated = false,
		timer = arg_22_1,
		option_strings = tbl,
		validation_func = arg_22_3,
		vote_templates = tbl_2,
		options = {
			0,
			0,
			0,
			0,
			0
		},
		user_names = {},
		cb = arg_22_6,
		vote_key = _vote_key_index,
		vote_type = arg_22_2,
		show_vote_ui = arg_22_5
	}
	self._votes_lookup_table[_vote_key_index] = self._votes[#self._votes]

	Managers.irc:register_message_callback(_vote_key_index, Irc.CHANNEL_MSG, callback(self, "on_message_received"))

	if not self._current_vote then
		self:_activate_next_vote()
	end

	self._vote_key_index = 1 + self._vote_key_index % 255

	return _vote_key_index
end

TwitchManager.unregister_vote = function (self, arg_23_1)
	-- function 23
	local network = Managers.state.network
	local flag = not network and network.is_server

	Managers.irc:unregister_message_callback(arg_23_1)

	self._votes_lookup_table[arg_23_1] = nil

	for i, v in ipairs(self._votes) do
		if v.vote_key == arg_23_1 then
			table.remove(self._votes, i)

			break
		end
	end

	if not flag then
		local var_23_2 = self._game_object_ids[arg_23_1]

		if not var_23_2 then
			local game = network:game()

			if not game then
				GameSession.destroy_game_object(game, var_23_2)
			end

			self._game_object_ids[arg_23_1] = nil
		end

		if not (not self._current_vote and self._current_vote.vote_key ~= arg_23_1) then
			self._current_vote = nil

			self:_activate_next_vote()
		end
	end
end

TwitchManager._activate_next_vote = function (self)
	-- function 24
	self._current_vote = self._votes[1]

	if not self._current_vote then
		if not self._current_vote.show_vote_ui then
			Managers.state.event:trigger("add_vote_ui", self._current_vote.vote_key)
		end

		self._current_vote.activated = true

		local network = Managers.state.network

		if not network and not network.is_server and not network:game() then
			local tbl = {}

			for i, v in ipairs(self._current_vote.vote_templates) do
				local var_24_2 = rawget(NetworkLookup.twitch_vote_templates, v)

				var_24_2 = var_24_2 or 0
				tbl[i] = var_24_2
			end

			local tbl_2 = {
				go_type = NetworkLookup.go_types.twitch_vote,
				vote_key = self._current_vote.vote_key,
				options = self._current_vote.options,
				vote_type = NetworkLookup.twitch_vote_types[self._current_vote.vote_type],
				vote_templates = tbl,
				time = self._current_vote.timer,
				show_vote_ui = self._current_vote.show_vote_ui
			}
			local var_24_4 = callback(self, "cb_game_session_disconnect")

			self._game_object_ids[self._current_vote.vote_key] = network:create_game_object("twitch_vote", tbl_2, var_24_4)
		end
	end
end

TwitchManager.get_vote_data = function (self, arg_25_1)
	-- function 25
	return self._votes_lookup_table[arg_25_1]
end

TwitchManager.on_client_message_received = function (self, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	-- function 26
	if not string.find(arg_26_4, "@") then
		return
	end

	local var_26_0 = self._votes_lookup_table[arg_26_1]

	if not var_26_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_26_1))
		self:unregister_vote(arg_26_1)

		return
	elseif not var_26_0.activated then
		return
	end

	local lower = string.lower(arg_26_4)

	if not Development.parameter("twitch_randomize_votes") then
		lower = var_26_0.option_strings[Math.random(#var_26_0.option_strings)]
	end

	for i, v in ipairs(var_26_0.option_strings) do
		if not string.find(lower, v) then
			local num = 1

			Managers.state.network.network_transmit:send_rpc_server("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_add_client_twitch_vote, arg_26_1, arg_26_3, i, num)

			break
		end
	end
end

TwitchManager.rpc_update_twitch_vote = function (self, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	-- function 27
	self[NetworkLookup.twitch_rpc_types[arg_27_2]](self, arg_27_1, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
end

TwitchManager.rpc_add_client_twitch_vote = function (self, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	-- function 28
	local var_28_0 = self._votes_lookup_table[arg_28_2]

	if not var_28_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_28_2))
		self:unregister_vote(arg_28_2)

		return
	elseif not var_28_0.activated then
		return
	end

	if not Development.parameter("twitch_allow_multiple_votes") then
		if not var_28_0.user_names[arg_28_3] then
			return
		end

		var_28_0.user_names[arg_28_3] = true
	end

	if not Development.parameter("twitch_randomize_votes") then
		local random = Math.random(#var_28_0.option_strings)

		var_28_0.options[random] = var_28_0.options[random] + 1
	else
		var_28_0.options[arg_28_4] = var_28_0.options[arg_28_4] + 1
	end

	self:_update_game_object(arg_28_2, var_28_0)
end

TwitchManager.rpc_finish_twitch_vote = function (self, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	-- function 29
	local network = Managers.state.network

	network = not network and Managers.state.network.is_server

	local var_29_1 = NetworkLookup.twitch_vote_templates[arg_29_5]

	fn("Vote results:", arg_29_4, var_29_1)

	local var_29_2 = self._votes_lookup_table[arg_29_2]

	if not var_29_2 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_29_2))
		self:unregister_vote(arg_29_2)

		return
	end

	local var_29_3 = TwitchVoteTemplates[var_29_1]

	if not var_29_3 then
		var_29_3.on_success(network, arg_29_4, var_29_3)
	end

	if not var_29_2.show_vote_ui then
		Managers.state.event:trigger("finish_vote_ui", arg_29_2, arg_29_4)
	end

	Managers.irc:unregister_message_callback(arg_29_2)

	self._votes_lookup_table[arg_29_2] = nil

	for i, v in ipairs(self._votes) do
		if v.vote_key == arg_29_2 then
			table.remove(self._votes, i)

			break
		end
	end
end

TwitchManager.rpc_disconnected_from_twitch = function (self, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	-- function 30
	self._loading_popup_message = "twitch_connection_failed"
end

TwitchManager.get_twitch_popup_message = function (self)
	-- function 31
	local _loading_popup_message = self._loading_popup_message

	self._loading_popup_message = nil

	return _loading_popup_message
end

TwitchManager.on_message_received = function (self, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	-- function 32
	if not string.find(arg_32_4, "@") then
		return
	end

	local var_32_0 = self._votes_lookup_table[arg_32_1]

	if not var_32_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_32_1))
		self:unregister_vote(arg_32_1)

		return
	elseif not var_32_0.activated then
		return
	end

	if Development.parameter("twitch_allow_multiple_votes") or not var_32_0.user_names[arg_32_3] then
		return
	end

	if not Development.parameter("twitch_randomize_votes") then
		arg_32_4 = var_32_0.option_strings[Math.random(#var_32_0.option_strings)]
	end

	local lower = string.lower(arg_32_4)
	local options = var_32_0.options

	for i, v in ipairs(var_32_0.option_strings) do
		if not string.find(lower, v) then
			options[i] = options[i] + 1

			if not Development.parameter("twitch_allow_multiple_votes") then
				var_32_0.user_names[arg_32_3] = true
			end

			break
		end
	end

	self:_update_game_object(arg_32_1, var_32_0)
end

TwitchManager.disconnect = function (self)
	-- function 33
	if not self._connected then
		Managers.irc:force_disconnect()

		if not self._twitch_game_mode then
			self._twitch_game_mode:destroy()

			self._twitch_game_mode = nil
		end
	end

	self._activated = false
	self._connecting = false
end

TwitchManager.update = function (self, arg_34_1, arg_34_2)
	-- function 34
	self:_handle_disconnect_popup()
	self:_handle_popup()
	self:_validate_data(arg_34_1, arg_34_2)
	self:_update_vote_data(arg_34_1, arg_34_2)
	self:_update_twitch_game_mode(arg_34_1, arg_34_2)

	if not (not self._should_retry and not (arg_34_2 >= self._next_retry_time)) then
		self._should_retry = false

		Managers.backend:get_interface("live_events"):request_twitch_app_access_token(callback(self, "cb_request_twitch_access_token"))
	end
end

TwitchManager._handle_popup = function (self)
	-- function 35
	if not self._popup_id then
		local query_result = Managers.popup:query_result(self._popup_id)

		if not query_result then
			if query_result == "return_to_inn" then
				local get_hub_level_key = Managers.mechanism:game_mechanism():get_hub_level_key()

				Managers.state.game_mode:start_specific_level(get_hub_level_key)
			else
				Application.error(string.format("[TwitchManager] Unknown result: %s", query_result))
			end

			self._popup_id = nil
		end
	end
end

TwitchManager._handle_disconnect_popup = function (self)
	-- function 36
	if not self._error_popup_id then
		local query_result = Managers.popup:query_result(self._error_popup_id)

		if not query_result then
			if query_result == "ok" then
				self._error_popup_id = nil
			elseif not query_result then
				fassert(false, "[TwitchManager] The popup result doesn't exist (%s)", query_result)
			end
		end
	end
end

TwitchManager._update_vote_data = function (self, arg_37_1, arg_37_2)
	-- function 37
	local network = Managers.state.network

	if not (not network and network.is_server) then
		if not self._connected then
			return
		end

		local _current_vote = self._current_vote

		if not _current_vote then
			_current_vote.timer = _current_vote.timer - arg_37_1

			self:_update_game_object(_current_vote.vote_key, _current_vote)

			if _current_vote.timer <= 0 then
				self:_handle_results(_current_vote)

				local cb = _current_vote.cb

				if not cb then
					cb(_current_vote)
				end

				self:unregister_vote(_current_vote.vote_key)
			end
		end
	else
		for k, v in pairs(self._game_object_ids) do
			local var_37_3 = self._votes_lookup_table[k]

			if not var_37_3 then
				local network_2 = Managers.state.network

				network_2 = not network_2 and Managers.state.network:game()

				if not network_2 then
					local game_object_field = GameSession.game_object_field(network_2, v, "options")

					var_37_3.timer, var_37_3.options = GameSession.game_object_field(network_2, v, "time"), game_object_field
				end
			end
		end
	end
end

TwitchManager._handle_results = function (self, arg_38_1)
	-- function 38
	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader
	local is_server = Managers.state.network.is_server
	local num = -1
	local num_2 = 0
	local vote_type = self._current_vote.vote_type
	local var_38_5 = TwitchSettings[vote_type]
	local size = table.size(var_38_5)
	local options = arg_38_1.options

	for i = 1, size do
		repeat
			if not (vote_type ~= "multiple_choice" or self:_valid_player_index(i)) then
				break
			end

			local var_38_8 = options[i]

			if num < var_38_8 then
				num_2 = i
				num = var_38_8

				break
			end

			if not (var_38_8 ~= num or math.random(2) ~= 1) then
				num_2 = i
				num = var_38_8
			end
		until true
	end

	for j = 1, size do
		local var_38_9 = arg_38_1.vote_templates[j]
		local breed_name = TwitchVoteTemplates[var_38_9].breed_name

		if not breed_name and not self.locked_breed_packages[breed_name] then
			enemy_package_loader:unlock_breed_package(breed_name)

			self.locked_breed_packages[breed_name] = nil
		end
	end

	local var_38_11
	local flag = var_38_11 or arg_38_1.vote_templates[num_2]

	arg_38_1.winning_template_name = flag

	local var_38_13 = TwitchVoteTemplates[flag]

	if not Development.parameter("twitch_disable_result") then
		var_38_13.on_success(is_server, num_2, var_38_13)
	else
		flag = "none"
	end

	if not arg_38_1.show_vote_ui then
		Managers.state.event:trigger("finish_vote_ui", arg_38_1.vote_key, num_2)
	end

	local str = ""

	Managers.state.network.network_transmit:send_rpc_clients("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_finish_twitch_vote, arg_38_1.vote_key, str, num_2, NetworkLookup.twitch_vote_templates[flag])
end

TwitchManager._valid_player_index = function (arg_39_0, arg_39_1)
	-- function 39
	local human_and_bot_players = Managers.player:human_and_bot_players()

	for k, v in pairs(human_and_bot_players) do
		if arg_39_1 == v:profile_index() then
			return true
		end
	end

	return false
end

TwitchManager._validate_data = function (self, arg_40_1, arg_40_2)
	-- function 40
	local _current_vote = self._current_vote

	if not _current_vote then
		local validation_func = _current_vote.validation_func

		if not validation_func then
			validation_func(_current_vote)
		end
	end
end

TwitchManager.is_activated = function (self)
	-- function 41
	return self._activated
end

TwitchManager.reset = function (self)
	-- function 42
	self:destroy()
end

TwitchManager.destroy = function (self)
	-- function 43
	if not Managers.state and not Managers.state.event then
		Managers.state.event:trigger("reset_vote_ui")
	end

	self:disconnect()
end

TwitchManager.activate_twitch_game_mode = function (self, arg_44_1, arg_44_2)
	-- function 44
	if not Development.parameter("twitch_debug_voting") then
		self._connected = true
	end

	local TwitchSettings = TwitchSettings
	local user_setting = Application.user_setting("twitch_time_between_votes")

	user_setting = user_setting or TwitchSettings.default_downtime
	TwitchSettings.default_downtime = user_setting

	local TwitchSettings_2 = TwitchSettings
	local user_setting_2 = Application.user_setting("twitch_vote_time")

	user_setting_2 = user_setting_2 or TwitchSettings.default_vote_time
	TwitchSettings_2.default_vote_time = user_setting_2

	local TwitchSettings_3 = TwitchSettings
	local user_setting_3 = Application.user_setting("twitch_difficulty")

	user_setting_3 = user_setting_3 or TwitchSettings.difficulty
	TwitchSettings_3.difficulty = user_setting_3

	local user_setting_4 = Application.user_setting("twitch_disable_positive_votes")

	TwitchSettings.disable_giving_items = user_setting_4 == TwitchSettings.positive_vote_options.disable_giving_items or user_setting_4 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_positive_votes = user_setting_4 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_mutators = Application.user_setting("twitch_disable_mutators")
	TwitchSettings.spawn_amount_multiplier = math.clamp(Application.user_setting("twitch_spawn_amount"), 1, 3)
	TwitchSettings.mutator_duration_multiplier = math.clamp(Application.user_setting("twitch_mutator_duration"), 1, 3)

	local network = Managers.state.network

	network = not network and Managers.state.network

	local flag = not network and network.is_server

	if not self:game_mode_supported(arg_44_2) then
		Managers.state.event:trigger("activate_twitch_game_mode")

		self._network_event_delegate = arg_44_1

		arg_44_1:register(self, unpack(tbl))

		if not self._connected then
			if not flag then
				self._twitch_game_mode = TwitchGameMode:new(self)
			end

			self:_load_sound_bank()
		end

		local flag_2

		flag_2 = network:lobby():lobby_data("twitch_enabled") ~= "true" or not true or false
		self._activated = flag_2

		if not Development.parameter("twitch_debug_voting") then
			self._activated = true
		end

		if not self._activated then
			Managers.telemetry_events:twitch_mode_activated()
		end
	end
end

TwitchManager.debug_activate_twitch_game_mode = function (self)
	-- function 45
	if not Development.parameter("twitch_debug_voting") then
		Managers.state.event:trigger("activate_twitch_game_mode")
		Managers.telemetry_events:twitch_mode_activated()

		self._twitch_game_mode = TwitchGameMode:new(self)

		self:_load_sound_bank()

		self._activated = true
		self._connected = true
	else
		self:deactivate_twitch_game_mode()
	end
end

TwitchManager.deactivate_twitch_game_mode = function (self)
	-- function 46
	if not self._current_vote then
		self:unregister_vote(self._current_vote.vote_key)
	end

	if not self._network_event_delegate then
		self._network_event_delegate:unregister(self)

		self._network_event_delegate = nil
	end

	if not self._twitch_game_mode then
		self._twitch_game_mode:destroy()

		self._twitch_game_mode = nil
	end

	self._activated = false

	self:_unload_sound_bank()
end

TwitchManager._update_twitch_game_mode = function (self, arg_47_1, arg_47_2)
	-- function 47
	if not (not self._twitch_game_mode and self._connected) then
		return
	end

	self._twitch_game_mode:update(arg_47_1, arg_47_2)

	if not Development.parameter("twitch_debug_voting") then
		self:_update_debug_voting(arg_47_1)
	end
end

local tbl_3 = {
	"default_vote_a_str",
	"default_vote_b_str",
	"default_vote_c_str",
	"default_vote_d_str",
	"default_vote_e_str"
}

TwitchManager._update_debug_voting = function (self, arg_48_1)
	-- function 48
	self._debug_vote_timer = self._debug_vote_timer - arg_48_1

	if self._debug_vote_timer > 0 then
		return
	end

	local _current_vote = self._current_vote

	if not _current_vote then
		return
	end

	local var_48_1

	if _current_vote.vote_type == "standard_vote" then
		local flag

		flag = not script_data.twitch_mode_force_vote_template and 1 and math.random(2)
		var_48_1 = tbl_3[flag]
	else
		local random = math.random(5)

		if not self:_valid_player_index(random) then
			return
		end

		var_48_1 = tbl_3[random]
	end

	local var_48_4 = TwitchSettings.multiple_choice[var_48_1]
	local options = _current_vote.options
	local option_strings = _current_vote.option_strings

	for i, v in ipairs(option_strings) do
		if not string.find(var_48_4, v) then
			options[i] = options[i] + 1

			break
		end
	end

	local vote_key = _current_vote.vote_key

	self:_update_game_object(vote_key, _current_vote)

	self._debug_vote_timer = 0.25
end

TwitchGameMode = class(TwitchGameMode)

TwitchGameMode.init = function (self, arg_49_1)
	-- function 49
	self._timer = TwitchSettings.initial_downtime
	self._funds = TwitchSettings.starting_funds
	self._parent = arg_49_1
	self._vote_keys = {}
	self._used_vote_templates = {}

	Debug.text("Activating Twitch Game Mode")
end

TwitchGameMode.update = function (self, arg_50_1, arg_50_2)
	-- function 50
	self._timer = self._timer - arg_50_1

	if self._timer > 0 then
		return
	end

	local network = Managers.state.network

	network = not network and Managers.state.network:game()

	if not network then
		self:_trigger_new_vote()
	end
end

TwitchGameMode._update_used_votes = function (self)
	-- function 51
	local _used_vote_templates = self._used_vote_templates

	for k, v in pairs(_used_vote_templates) do
		if v - 1 == 0 then
			_used_vote_templates[k] = nil
		else
			_used_vote_templates[k] = v - 1
		end
	end

	self:_clear_used_votes()
end

TwitchGameMode._clear_used_votes = function (self, arg_52_1)
	-- function 52
	local _used_vote_templates = self._used_vote_templates
	local _get_game_mode_whitelist = self:_get_game_mode_whitelist()
	local count

	if not _get_game_mode_whitelist then
		count = #_get_game_mode_whitelist

		if not count then
			-- Nothing
		end
	end

	count = #TwitchVoteTemplatesLookup

	::label_52_0::

	if not (arg_52_1 or not (count - table.size(_used_vote_templates) <= num_2)) then
		table.clear(_used_vote_templates)
	end
end

TwitchGameMode._check_breed_package_loading = function (self, arg_53_1, arg_53_2)
	-- function 53
	local breed_name = arg_53_1.breed_name

	if not breed_name then
		return arg_53_1
	end

	local boss = arg_53_1.boss
	local special = arg_53_1.special

	if not (boss or special) then
		return arg_53_1
	end

	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader
	local flag = true
	local var_53_5

	if not enemy_package_loader:is_breed_processed(breed_name) then
		flag = enemy_package_loader:request_breed(breed_name)
	end

	if not flag then
		enemy_package_loader:lock_breed_package(breed_name)

		self._parent.locked_breed_packages[breed_name] = true

		return arg_53_1
	else
		local tbl = {}

		for k, v in pairs(enemy_package_loader:processed_breeds()) do
			tbl[#tbl + 1] = k
		end

		table.shuffle(tbl)

		local TwitchBossesSpawnBreedNamesLookup

		if not boss then
			TwitchBossesSpawnBreedNamesLookup = TwitchBossesSpawnBreedNamesLookup

			if not TwitchBossesSpawnBreedNamesLookup then
				-- Nothing
			end
		end

		TwitchBossesSpawnBreedNamesLookup = not special and TwitchSpecialsSpawnBreedNamesLookup

		::label_53_0::

		for k_2 = 1, #tbl do
			local var_53_8 = tbl[k_2]

			if not TwitchBossesSpawnBreedNamesLookup[var_53_8] then
				var_53_5 = var_53_8

				break
			end
		end
	end

	local flag_2 = not boss and not arg_53_2 and arg_53_2.breed_name == var_53_5
	local var_53_10
	local _used_vote_templates = self._used_vote_templates

	if not flag_2 then
		local huge = math.huge
		local TwitchBossEquivalentSpawnTemplatesLookup = TwitchBossEquivalentSpawnTemplatesLookup

		table.shuffle(TwitchBossEquivalentSpawnTemplatesLookup)

		for l = 1, #TwitchBossEquivalentSpawnTemplatesLookup do
			local var_53_14 = TwitchBossEquivalentSpawnTemplatesLookup[l]

			if not _used_vote_templates[var_53_14] then
				local var_53_15 = TwitchVoteTemplates[var_53_14]

				if arg_53_1.name ~= var_53_15.name then
					local abs = math.abs(math.abs(arg_53_1.cost) - math.abs(var_53_15.cost))

					if abs < huge then
						var_53_10 = var_53_15
						huge = abs
					end
				end
			end
		end
	elseif not boss then
		var_53_10 = TwitchBossesSpawnBreedNamesLookup[var_53_5]
	elseif not special then
		local var_53_17 = TwitchSpecialsSpawnBreedNamesLookup[var_53_5]

		if not ((_used_vote_templates[var_53_17.name] or arg_53_2 == nil or not arg_53_2 or arg_53_2.name ~= var_53_17.name) and arg_53_1.name == var_53_17.name) then
			var_53_10 = var_53_17
		end
	end

	if not var_53_10 then
		self:_clear_used_votes(true)
		print("BREED PACKAGE LOADING FAILED")

		return self:_check_breed_package_loading(arg_53_1, arg_53_2)
	end

	return var_53_10
end

TwitchGameMode._get_game_mode_whitelist = function (arg_54_0)
	-- function 54
	local game_mode_key = Managers.state.game_mode:game_mode_key()

	return TwitchVoteWhitelists[game_mode_key]
end

TwitchGameMode._in_whitelist = function (self, arg_55_1)
	-- function 55
	local _get_game_mode_whitelist = self:_get_game_mode_whitelist()

	if _get_game_mode_whitelist == nil then
		return true
	else
		return table.contains(_get_game_mode_whitelist, arg_55_1)
	end
end

TwitchGameMode._get_next_vote = function (self)
	-- function 56
	self:_update_used_votes()

	local _funds = self._funds
	local _used_vote_templates = self._used_vote_templates
	local var_56_2

	if not (not (_funds >= TwitchSettings.cutoff_for_guaranteed_positive_vote) or TwitchSettings.disable_positive_votes) then
		local clone = table.clone(TwitchPositiveVoteTemplatesLookup)

		table.shuffle(clone)

		local num = -math.huge

		for i = 1, #clone do
			local var_56_5 = clone[i]

			if not _used_vote_templates[var_56_5] then
				local var_56_6 = TwitchVoteTemplates[var_56_5]

				if not (not self:_in_whitelist(var_56_5) and not var_56_6.condition_func and var_56_6.condition_func()) then
					local num_2 = _funds - var_56_6.cost

					if num < num_2 then
						var_56_2 = var_56_6
						num = num_2
					end
				end
			end
		end
	elseif _funds <= TwitchSettings.cutoff_for_guaranteed_negative_vote then
		local clone_2 = table.clone(TwitchNegativeVoteTemplatesLookup)

		table.shuffle(clone_2)

		local huge = math.huge

		for j = 1, #clone_2 do
			local var_56_10 = clone_2[j]

			if not _used_vote_templates[var_56_10] then
				local var_56_11 = TwitchVoteTemplates[var_56_10]

				if not (not self:_in_whitelist(var_56_10) and not var_56_11.condition_func and var_56_11.condition_func()) then
					local num_3 = _funds + var_56_11.cost

					if num_3 < huge then
						var_56_2 = var_56_11
						huge = num_3
					end
				end
			end
		end
	end

	if var_56_2 == nil then
		local clone_3 = table.clone(TwitchVoteTemplatesLookup)

		table.shuffle(clone_3)

		for k = 1, #clone_3 do
			local var_56_14 = clone_3[k]

			if not _used_vote_templates[var_56_14] then
				local var_56_15 = TwitchVoteTemplates[var_56_14]

				if not (not self:_in_whitelist(var_56_14) and not var_56_15.condition_func and var_56_15.condition_func()) then
					var_56_2 = var_56_15

					break
				end
			end
		end
	end

	if var_56_2 == nil then
		return nil
	end

	if not var_56_2.multiple_choice then
		return self:_next_multiple_choice_vote(var_56_2)
	else
		return self:_next_standard_vote(var_56_2)
	end
end

TwitchGameMode._next_multiple_choice_vote = function (arg_57_0, arg_57_1)
	-- function 57
	local tbl = {}

	for i = 1, 5 do
		tbl[i] = arg_57_1.name
	end

	local validation_func = arg_57_1.validation_func

	return "multiple_choice", tbl, validation_func
end

TwitchGameMode._next_standard_vote = function (self, arg_58_1)
	-- function 58
	local _used_vote_templates = self._used_vote_templates
	local name = arg_58_1.name
	local cost = arg_58_1.cost
	local clone = table.clone(TwitchStandardVoteTemplatesLookup)

	table.shuffle(clone)

	local var_58_4
	local huge = math.huge

	for i = 1, #clone do
		local var_58_6 = clone[i]

		if not (name == var_58_6 or _used_vote_templates[var_58_6]) then
			local var_58_7 = TwitchVoteTemplates[var_58_6]

			if not (not var_58_7.condition_func and var_58_7.condition_func()) then
				local boss = arg_58_1.boss

				boss = not boss and not not var_58_7.boss or not var_58_7.boss_equivalent

				if not boss then
					local cost_2 = var_58_7.cost
					local abs = math.abs(cost - cost_2)

					if not (not (abs <= TwitchSettings.max_a_b_vote_cost_diff) or not (abs < huge)) then
						var_58_4 = var_58_7
						huge = abs
					end
				end
			end
		end
	end

	if not var_58_4 then
		self:_clear_used_votes(true)

		return self:_next_standard_vote(arg_58_1)
	end

	arg_58_1 = self:_check_breed_package_loading(arg_58_1)

	local _check_breed_package_loading = self:_check_breed_package_loading(var_58_4, arg_58_1)
	local tbl = {
		arg_58_1.name,
		_check_breed_package_loading.name
	}

	return "standard_vote", tbl, nil
end

TwitchGameMode._trigger_new_vote = function (self)
	-- function 59
	local _get_next_vote, var_59_1, var_59_2 = self:_get_next_vote()
	local user_setting = Application.user_setting("twitch_vote_time")

	user_setting = user_setting or TwitchSettings.default_vote_time

	if not _get_next_vote then
		local register_vote = self._parent:register_vote(user_setting, _get_next_vote, var_59_2, var_59_1, true, callback(self, "cb_on_vote_complete"))

		self._vote_keys[register_vote] = true
	end

	local user_setting_2 = Application.user_setting("twitch_time_between_votes")

	user_setting_2 = user_setting_2 or TwitchSettings.default_downtime
	self._timer = user_setting_2 + user_setting
end

TwitchGameMode.cb_on_vote_complete = function (self, arg_60_1)
	-- function 60
	Managers.telemetry_events:twitch_poll_completed(arg_60_1)

	local var_60_0 = TwitchVoteTemplates[arg_60_1.winning_template_name]

	self._funds = self._funds + var_60_0.cost
	self._used_vote_templates[var_60_0.name] = num
	self._vote_keys[arg_60_1.vote_key] = nil
end

TwitchGameMode.destroy = function (self)
	-- function 61
	fn("Destroying Twitch Game mode")

	for k, v in pairs(self._vote_keys) do
		if not Managers.state and not Managers.state.event then
			Managers.state.event:trigger("reset_vote_ui", k)
		end

		self._parent:unregister_vote(k)
		fn("Destroying Twitch Vote %s", k)
	end

	local enemy_package_loader = Managers.level_transition_handler.enemy_package_loader

	for k_2, v_2 in pairs(self._parent.locked_breed_packages) do
		enemy_package_loader:unlock_breed_package(k_2)

		self._parent.locked_breed_packages[k_2] = nil
	end

	if not Managers.state and not Managers.state.event then
		Managers.state.event:trigger("reset_vote_ui")
	end
end
