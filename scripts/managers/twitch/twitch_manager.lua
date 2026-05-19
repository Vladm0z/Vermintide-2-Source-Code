-- chunkname: @scripts/managers/twitch/twitch_manager.lua

require("scripts/settings/twitch_settings")

DEBUG_TWITCH = false

local var_0_0 = 15
local var_0_1 = 2
local var_0_2 = 6
local var_0_3 = 5

local function var_0_4(arg_1_0, ...)
	if DEBUG_TWITCH then
		if type(arg_1_0) == "table" then
			table.dump(arg_1_0, "[TwitchManager]")
		else
			print("[TwitchManager] " .. string.format(arg_1_0, ...))
		end
	end
end

local var_0_5 = {
	"rpc_update_twitch_vote"
}

TwitchManager = class(TwitchManager)

function TwitchManager.init(arg_2_0)
	arg_2_0._address = "irc.chat.twitch.tv"
	arg_2_0._port = 6667
	arg_2_0._votes = {}
	arg_2_0._votes_lookup_table = {}
	arg_2_0._vote_key_index = 1
	arg_2_0._connecting = false
	arg_2_0._connected = false
	arg_2_0._sound_bank_loaded = false
	arg_2_0._twitch_user_name = ""
	arg_2_0._game_object_ids = {}
	arg_2_0._vote_key_to_go_id = {}
	arg_2_0.locked_breed_packages = {}

	if not IS_WINDOWS then
		arg_2_0._rest_interface = Managers.rest_transport
	else
		arg_2_0._rest_interface = Managers.curl
	end

	arg_2_0._twitch_settings = Application.settings().twitch

	var_0_4(Application.settings("twitch"))

	TwitchSettings.default_downtime = math.max(1, Application.user_setting("twitch_time_between_votes"))
	TwitchSettings.default_vote_time = math.max(1, Application.user_setting("twitch_vote_time"))
	TwitchSettings.difficulty = Application.user_setting("twitch_difficulty")

	local var_2_0 = Application.user_setting("twitch_disable_positive_votes")

	TwitchSettings.disable_giving_items = var_2_0 == TwitchSettings.positive_vote_options.disable_giving_items or var_2_0 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_positive_votes = var_2_0 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_mutators = Application.user_setting("twitch_disable_mutators")
	TwitchSettings.spawn_amount_multiplier = math.clamp(Application.user_setting("twitch_spawn_amount"), 1, 3)
	TwitchSettings.mutator_duration_multiplier = math.clamp(Application.user_setting("twitch_mutator_duration"), 1, 3)

	if TwitchSettings.default_downtime + TwitchSettings.default_vote_time < 5 then
		TwitchSettings.default_downtime = 1
		TwitchSettings.default_vote_time = 5
	end

	arg_2_0._debug_vote_timer = 0.25
end

local var_0_6 = {
	cataclysm = true,
	cataclysm_3 = true,
	hardest = true,
	cataclysm_2 = true
}

function TwitchManager.game_mode_supported(arg_3_0, arg_3_1, arg_3_2)
	return not not TwitchSettings.supported_game_modes[PLATFORM][arg_3_1] or not not var_0_6[arg_3_2]
end

function TwitchManager.stream_type(arg_4_0)
	return "twitch"
end

function TwitchManager._load_sound_bank(arg_5_0)
	if not arg_5_0._sound_bank_loaded then
		local var_5_0 = "resource_packages/ingame_sounds_twitch_mode"

		var_0_4("Loading twitch mode sound bank resource package %s", var_5_0)
		Managers.package:load(var_5_0, "twitch", nil, true)

		arg_5_0._sound_bank_loaded = true
	end
end

function TwitchManager._unload_sound_bank(arg_6_0)
	if arg_6_0._sound_bank_loaded then
		local var_6_0 = "resource_packages/ingame_sounds_twitch_mode"

		var_0_4("Unloading twitch mode sound bank resource package %s", var_6_0)
		Managers.package:unload(var_6_0, "twitch")

		arg_6_0._sound_bank_loaded = false
	end
end

function TwitchManager.connect(arg_7_0, arg_7_1, arg_7_2, arg_7_3, arg_7_4)
	fassert(arg_7_1, "[TwitchManager] You need to provide a user name to connect")

	local var_7_0 = "https://api.twitch.tv/helix/users?login=" .. arg_7_1
	local var_7_1 = {}

	if IS_WINDOWS then
		var_7_1[Managers.curl._curl.OPT_SSL_OPTIONS] = Managers.curl._curl.SSLOPT_NO_REVOKE
	end

	local var_7_2

	if IS_CONSOLE then
		var_7_2 = {
			"Content-Type",
			"application/json",
			"Client-ID",
			arg_7_0._twitch_settings.client_id,
			"Authorization",
			"Bearer " .. Managers.backend:get_twitch_app_access_token()
		}
	else
		var_7_2 = {
			"Content-Type: application/json",
			"Client-ID: " .. arg_7_0._twitch_settings.client_id,
			"Authorization: Bearer " .. Managers.backend:get_twitch_app_access_token()
		}
	end

	arg_7_0._headers = var_7_2
	arg_7_0._connecting = true
	arg_7_0._connection_failure_callback = arg_7_2
	arg_7_0._connection_success_callback = arg_7_3
	arg_7_0._twitch_user_name = arg_7_1

	if not arg_7_4 then
		arg_7_0._num_retries = 0
	end

	arg_7_0._rest_interface:get(var_7_0, arg_7_0._headers, callback(arg_7_0, "cb_on_user_info_received"), {
		"User Data",
		arg_7_1
	}, var_7_1)
end

function TwitchManager.cb_on_user_info_received(arg_8_0, arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)
	arg_8_0:_show_result_info(arg_8_1, arg_8_2, arg_8_3, arg_8_4, arg_8_5)

	if arg_8_1 then
		local var_8_0 = cjson.decode(arg_8_4)

		if var_8_0 then
			if var_8_0.status == 401 and arg_8_0._num_retries < var_0_2 then
				arg_8_0._should_retry = true
				arg_8_0._next_retry_time = Managers.time:time("main") + var_0_3
			elseif var_8_0.error then
				local var_8_1 = string.format(Localize("start_game_window_twitch_error_connection"), var_8_0.message, var_8_0.error, arg_8_2)

				Application.error("[TwitchManager] " .. var_8_1)

				if arg_8_0._connection_failure_callback then
					arg_8_0._connection_failure_callback(var_8_1)
				end
			elseif var_8_0.data and #var_8_0.data > 0 then
				local var_8_2 = var_8_0.data[1]
				local var_8_3 = var_8_2.id
				local var_8_4 = var_8_2.login

				if arg_8_0._connection_success_callback then
					arg_8_0._connection_success_callback(var_8_2)
				end

				local var_8_5 = "https://api.twitch.tv/helix/streams?user_id=" .. var_8_3
				local var_8_6 = {}

				arg_8_0._rest_interface:get(var_8_5, arg_8_0._headers, callback(arg_8_0, "cb_on_user_streams_received"), {
					"User Data",
					var_8_4
				}, var_8_6)

				return
			else
				local var_8_7 = string.format(Localize("start_game_window_twitch_error_no_user"), arg_8_5[2])

				Application.error("[TwitchManager] " .. var_8_7)

				if arg_8_0._connection_failure_callback then
					arg_8_0._connection_failure_callback(var_8_7)
				end
			end
		else
			local var_8_8 = Localize("start_game_window_twitch_error_parsing_results")

			Application.error("[TwitchManager] " .. var_8_8)

			if arg_8_0._connection_failure_callback then
				arg_8_0._connection_failure_callback(var_8_8)
			end
		end
	elseif arg_8_0._num_retries < var_0_2 then
		arg_8_0._should_retry = true
		arg_8_0._next_retry_time = Managers.time:time("main") + var_0_3
	else
		local var_8_9 = Localize("start_game_window_twitch_error_generic")

		Application.error("[TwitchManager] " .. var_8_9)

		if arg_8_0._connection_failure_callback then
			arg_8_0._connection_failure_callback(var_8_9)
		end
	end

	if not arg_8_0._should_retry then
		arg_8_0._connecting = false
		arg_8_0._connection_failure_callback = nil
	end
end

function TwitchManager.cb_request_twitch_access_token(arg_9_0, arg_9_1)
	arg_9_0._num_retries = arg_9_0._num_retries + 1

	if arg_9_1 then
		arg_9_0:connect(arg_9_0._twitch_user_name, arg_9_0._connection_failure_callback, arg_9_0._connection_success_callback, true)
	else
		local var_9_0 = Localize("start_game_window_twitch_error_generic")

		Application.error("[TwitchManager] " .. var_9_0)

		if arg_9_0._connection_failure_callback then
			arg_9_0._connection_failure_callback(var_9_0)
		end

		arg_9_0._connecting = false
		arg_9_0._connection_failure_callback = nil
	end
end

function TwitchManager.cb_on_user_streams_received(arg_10_0, arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)
	arg_10_0:_show_result_info(arg_10_1, arg_10_2, arg_10_3, arg_10_4, arg_10_5)

	if arg_10_1 then
		local var_10_0 = cjson.decode(arg_10_4)

		if var_10_0 then
			local var_10_1 = var_10_0.data[1]

			if var_10_1 and type(var_10_1) == "table" then
				local var_10_2 = var_10_1.user_login

				if var_10_2 then
					local var_10_3 = "#" .. var_10_2
					local var_10_4 = {
						port = 6667,
						allow_send = false,
						address = "irc.chat.twitch.tv",
						channel_name = var_10_3
					}

					Managers.irc:connect(nil, nil, var_10_4, callback(arg_10_0, "cb_on_notify_connected"))

					return
				end
			end
		end
	end

	local var_10_5 = string.format(Localize("start_game_window_twitch_error_no_active_streams"), arg_10_5[2], arg_10_2)

	Application.error("[TwitchManager] " .. var_10_5)

	if arg_10_0._connection_failure_callback then
		arg_10_0._connection_failure_callback(var_10_5)
	end

	arg_10_0._connecting = false
	arg_10_0._connection_failure_callback = nil
end

function TwitchManager.cb_on_notify_connected(arg_11_0, arg_11_1)
	arg_11_0._connected = arg_11_1
	arg_11_0._connecting = false

	if not arg_11_0._connected and arg_11_0._twitch_game_mode then
		arg_11_0._twitch_game_mode:destroy(true)

		arg_11_0._twitch_game_mode = nil
	end

	Application.error(string.format("[TwitchManager] %s %s Twitch!", arg_11_1 and "Connected" or "Disconnected", arg_11_1 and "to" or "from"))

	local var_11_0 = Managers.state.network and Managers.state.network.is_server

	if not arg_11_1 and arg_11_0._activated and var_11_0 then
		arg_11_0._popup_id = Managers.popup:queue_popup(Localize("popup_disconnected_from_twitch"), Localize("popup_header_error_twitch"), "return_to_inn", Localize("button_ok"))

		local var_11_1 = Managers.state.network

		if var_11_1 then
			local var_11_2 = 0
			local var_11_3 = 0
			local var_11_4 = 1
			local var_11_5 = ""

			var_11_1.network_transmit:send_rpc_clients("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_disconnected_from_twitch, var_11_2, var_11_5, var_11_3, var_11_4)
		end

		arg_11_0._activated = false
	end
end

function TwitchManager._show_result_info(arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5)
	if not DEBUG_TWITCH then
		return
	end

	if arg_12_1 then
		var_0_4("")
		var_0_4("RECEIVED: %s", arg_12_5[1])

		local var_12_0 = cjson.decode(arg_12_4)

		table.dump(var_12_0, "DATA", 3, var_0_4)
	else
		var_0_4("")
		var_0_4("FAILED RECEIVING: %s", arg_12_5[1])
		var_0_4("Error code: %s", arg_12_2)
	end
end

function TwitchManager.is_connected(arg_13_0)
	return arg_13_0._connected
end

function TwitchManager.is_connecting(arg_14_0)
	return arg_14_0._connecting
end

function TwitchManager.user_name(arg_15_0)
	return arg_15_0._twitch_user_name
end

function TwitchManager.cb_game_session_disconnect(arg_16_0)
	return
end

function TwitchManager.cb_connection_error_callback(arg_17_0, arg_17_1)
	if not arg_17_0._error_popup_id then
		arg_17_0._error_popup_id = Managers.popup:queue_popup(arg_17_1, Localize("popup_header_error_twitch"), "ok", Localize("popup_choice_ok"))
	end
end

function TwitchManager.add_game_object_id(arg_18_0, arg_18_1)
	local var_18_0 = Managers.state.network and Managers.state.network:game()

	if var_18_0 then
		local var_18_1 = GameSession.game_object_field(var_18_0, arg_18_1, "vote_key")

		arg_18_0._game_object_ids[var_18_1] = arg_18_1
		arg_18_0._vote_key_to_go_id[arg_18_1] = var_18_1

		arg_18_0:_register_networked_vote(arg_18_1)
	end
end

function TwitchManager.remove_game_object_id(arg_19_0, arg_19_1)
	if Managers.state.network and Managers.state.network:game() then
		local var_19_0 = arg_19_0._vote_key_to_go_id[arg_19_1]

		arg_19_0._game_object_ids[var_19_0] = nil
		arg_19_0._vote_key_to_go_id[arg_19_1] = nil

		arg_19_0:unregister_vote(var_19_0)
	end
end

function TwitchManager._update_game_object(arg_20_0, arg_20_1, arg_20_2)
	local var_20_0 = Managers.state.network and Managers.state.network:game()

	if var_20_0 then
		local var_20_1 = arg_20_0._game_object_ids[arg_20_1]

		if var_20_1 then
			GameSession.set_game_object_field(var_20_0, var_20_1, "options", arg_20_2.options)
			GameSession.set_game_object_field(var_20_0, var_20_1, "time", math.max(math.ceil(arg_20_2.timer), 0))
		end
	end
end

function TwitchManager._register_networked_vote(arg_21_0, arg_21_1)
	local var_21_0 = Managers.state.network and Managers.state.network:game()

	fassert(var_21_0, "[TwitchManager] You need to have an active game session to be able to register votes")

	local var_21_1 = GameSession.game_object_field(var_21_0, arg_21_1, "vote_key")
	local var_21_2 = NetworkLookup.twitch_vote_types[GameSession.game_object_field(var_21_0, arg_21_1, "vote_type")]
	local var_21_3 = {
		TwitchSettings[var_21_2].default_vote_a_str,
		TwitchSettings[var_21_2].default_vote_b_str,
		TwitchSettings[var_21_2].default_vote_c_str,
		TwitchSettings[var_21_2].default_vote_d_str,
		TwitchSettings[var_21_2].default_vote_e_str
	}
	local var_21_4 = GameSession.game_object_field(var_21_0, arg_21_1, "options")
	local var_21_5 = GameSession.game_object_field(var_21_0, arg_21_1, "vote_templates")
	local var_21_6 = {}

	for iter_21_0, iter_21_1 in ipairs(var_21_5) do
		var_21_6[iter_21_0] = rawget(NetworkLookup.twitch_vote_templates, iter_21_1) or "none"
	end

	local var_21_7 = GameSession.game_object_field(var_21_0, arg_21_1, "time")
	local var_21_8 = GameSession.game_object_field(var_21_0, arg_21_1, "show_vote_ui")

	arg_21_0._votes[#arg_21_0._votes + 1] = {
		activated = true,
		timer = var_21_7,
		option_strings = var_21_3,
		options = var_21_4,
		vote_templates = var_21_6,
		vote_key = var_21_1,
		vote_type = var_21_2,
		show_vote_ui = var_21_8
	}
	arg_21_0._votes_lookup_table[var_21_1] = arg_21_0._votes[#arg_21_0._votes]

	Managers.irc:register_message_callback(var_21_1, Irc.CHANNEL_MSG, callback(arg_21_0, "on_client_message_received"))

	if arg_21_0._votes[#arg_21_0._votes].show_vote_ui then
		Managers.state.event:trigger("add_vote_ui", var_21_1)
	end
end

function TwitchManager.register_vote(arg_22_0, arg_22_1, arg_22_2, arg_22_3, arg_22_4, arg_22_5, arg_22_6)
	local var_22_0 = Managers.state.network

	fassert(arg_22_0._connected, "[TwitchManager] You need to be connected to be able to trigger twitch votes")
	fassert(var_22_0 and var_22_0:game(), "[TwitchManager] You need to have an active game session to be able to register votes")

	local var_22_1 = {
		TwitchSettings[arg_22_2].default_vote_a_str,
		TwitchSettings[arg_22_2].default_vote_b_str,
		TwitchSettings[arg_22_2].default_vote_c_str,
		TwitchSettings[arg_22_2].default_vote_d_str,
		TwitchSettings[arg_22_2].default_vote_e_str
	}
	local var_22_2 = {
		0,
		0,
		0,
		0
	}

	for iter_22_0, iter_22_1 in ipairs(arg_22_4) do
		var_22_2[iter_22_0] = iter_22_1
	end

	local var_22_3 = arg_22_0._vote_key_index

	arg_22_0._votes[#arg_22_0._votes + 1] = {
		activated = false,
		timer = arg_22_1,
		option_strings = var_22_1,
		validation_func = arg_22_3,
		vote_templates = var_22_2,
		options = {
			0,
			0,
			0,
			0,
			0
		},
		user_names = {},
		cb = arg_22_6,
		vote_key = var_22_3,
		vote_type = arg_22_2,
		show_vote_ui = arg_22_5
	}
	arg_22_0._votes_lookup_table[var_22_3] = arg_22_0._votes[#arg_22_0._votes]

	Managers.irc:register_message_callback(var_22_3, Irc.CHANNEL_MSG, callback(arg_22_0, "on_message_received"))

	if not arg_22_0._current_vote then
		arg_22_0:_activate_next_vote()
	end

	arg_22_0._vote_key_index = 1 + arg_22_0._vote_key_index % 255

	return var_22_3
end

function TwitchManager.unregister_vote(arg_23_0, arg_23_1)
	local var_23_0 = Managers.state.network
	local var_23_1 = var_23_0 and var_23_0.is_server

	Managers.irc:unregister_message_callback(arg_23_1)

	arg_23_0._votes_lookup_table[arg_23_1] = nil

	for iter_23_0, iter_23_1 in ipairs(arg_23_0._votes) do
		if iter_23_1.vote_key == arg_23_1 then
			table.remove(arg_23_0._votes, iter_23_0)

			break
		end
	end

	if var_23_1 then
		local var_23_2 = arg_23_0._game_object_ids[arg_23_1]

		if var_23_2 then
			local var_23_3 = var_23_0:game()

			if var_23_3 then
				GameSession.destroy_game_object(var_23_3, var_23_2)
			end

			arg_23_0._game_object_ids[arg_23_1] = nil
		end

		if not arg_23_0._current_vote or arg_23_0._current_vote.vote_key == arg_23_1 then
			arg_23_0._current_vote = nil

			arg_23_0:_activate_next_vote()
		end
	end
end

function TwitchManager._activate_next_vote(arg_24_0)
	arg_24_0._current_vote = arg_24_0._votes[1]

	if arg_24_0._current_vote then
		if arg_24_0._current_vote.show_vote_ui then
			Managers.state.event:trigger("add_vote_ui", arg_24_0._current_vote.vote_key)
		end

		arg_24_0._current_vote.activated = true

		local var_24_0 = Managers.state.network

		if var_24_0 and var_24_0.is_server and var_24_0:game() then
			local var_24_1 = {}

			for iter_24_0, iter_24_1 in ipairs(arg_24_0._current_vote.vote_templates) do
				var_24_1[iter_24_0] = rawget(NetworkLookup.twitch_vote_templates, iter_24_1) or 0
			end

			local var_24_2 = {
				go_type = NetworkLookup.go_types.twitch_vote,
				vote_key = arg_24_0._current_vote.vote_key,
				options = arg_24_0._current_vote.options,
				vote_type = NetworkLookup.twitch_vote_types[arg_24_0._current_vote.vote_type],
				vote_templates = var_24_1,
				time = arg_24_0._current_vote.timer,
				show_vote_ui = arg_24_0._current_vote.show_vote_ui
			}
			local var_24_3 = callback(arg_24_0, "cb_game_session_disconnect")

			arg_24_0._game_object_ids[arg_24_0._current_vote.vote_key] = var_24_0:create_game_object("twitch_vote", var_24_2, var_24_3)
		end
	end
end

function TwitchManager.get_vote_data(arg_25_0, arg_25_1)
	return arg_25_0._votes_lookup_table[arg_25_1]
end

function TwitchManager.on_client_message_received(arg_26_0, arg_26_1, arg_26_2, arg_26_3, arg_26_4, arg_26_5)
	if string.find(arg_26_4, "@") then
		return
	end

	local var_26_0 = arg_26_0._votes_lookup_table[arg_26_1]

	if not var_26_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_26_1))
		arg_26_0:unregister_vote(arg_26_1)

		return
	elseif not var_26_0.activated then
		return
	end

	local var_26_1 = string.lower(arg_26_4)

	if Development.parameter("twitch_randomize_votes") then
		var_26_1 = var_26_0.option_strings[Math.random(#var_26_0.option_strings)]
	end

	for iter_26_0, iter_26_1 in ipairs(var_26_0.option_strings) do
		if string.find(var_26_1, iter_26_1) then
			local var_26_2 = 1

			Managers.state.network.network_transmit:send_rpc_server("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_add_client_twitch_vote, arg_26_1, arg_26_3, iter_26_0, var_26_2)

			break
		end
	end
end

function TwitchManager.rpc_update_twitch_vote(arg_27_0, arg_27_1, arg_27_2, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
	arg_27_0[NetworkLookup.twitch_rpc_types[arg_27_2]](arg_27_0, arg_27_1, arg_27_3, arg_27_4, arg_27_5, arg_27_6)
end

function TwitchManager.rpc_add_client_twitch_vote(arg_28_0, arg_28_1, arg_28_2, arg_28_3, arg_28_4, arg_28_5)
	local var_28_0 = arg_28_0._votes_lookup_table[arg_28_2]

	if not var_28_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_28_2))
		arg_28_0:unregister_vote(arg_28_2)

		return
	elseif not var_28_0.activated then
		return
	end

	if not Development.parameter("twitch_allow_multiple_votes") then
		if var_28_0.user_names[arg_28_3] then
			return
		end

		var_28_0.user_names[arg_28_3] = true
	end

	if Development.parameter("twitch_randomize_votes") then
		local var_28_1 = Math.random(#var_28_0.option_strings)

		var_28_0.options[var_28_1] = var_28_0.options[var_28_1] + 1
	else
		var_28_0.options[arg_28_4] = var_28_0.options[arg_28_4] + 1
	end

	arg_28_0:_update_game_object(arg_28_2, var_28_0)
end

function TwitchManager.rpc_finish_twitch_vote(arg_29_0, arg_29_1, arg_29_2, arg_29_3, arg_29_4, arg_29_5)
	local var_29_0 = Managers.state.network and Managers.state.network.is_server
	local var_29_1 = NetworkLookup.twitch_vote_templates[arg_29_5]

	var_0_4("Vote results:", arg_29_4, var_29_1)

	local var_29_2 = arg_29_0._votes_lookup_table[arg_29_2]

	if not var_29_2 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_29_2))
		arg_29_0:unregister_vote(arg_29_2)

		return
	end

	local var_29_3 = TwitchVoteTemplates[var_29_1]

	if var_29_3 then
		var_29_3.on_success(var_29_0, arg_29_4, var_29_3)
	end

	if var_29_2.show_vote_ui then
		Managers.state.event:trigger("finish_vote_ui", arg_29_2, arg_29_4)
	end

	Managers.irc:unregister_message_callback(arg_29_2)

	arg_29_0._votes_lookup_table[arg_29_2] = nil

	for iter_29_0, iter_29_1 in ipairs(arg_29_0._votes) do
		if iter_29_1.vote_key == arg_29_2 then
			table.remove(arg_29_0._votes, iter_29_0)

			break
		end
	end
end

function TwitchManager.rpc_disconnected_from_twitch(arg_30_0, arg_30_1, arg_30_2, arg_30_3, arg_30_4, arg_30_5)
	arg_30_0._loading_popup_message = "twitch_connection_failed"
end

function TwitchManager.get_twitch_popup_message(arg_31_0)
	local var_31_0 = arg_31_0._loading_popup_message

	arg_31_0._loading_popup_message = nil

	return var_31_0
end

function TwitchManager.on_message_received(arg_32_0, arg_32_1, arg_32_2, arg_32_3, arg_32_4, arg_32_5)
	if string.find(arg_32_4, "@") then
		return
	end

	local var_32_0 = arg_32_0._votes_lookup_table[arg_32_1]

	if not var_32_0 then
		Application.error("TwitchManager] Something went wrong. There is no vote with the vote_key: " .. tostring(arg_32_1))
		arg_32_0:unregister_vote(arg_32_1)

		return
	elseif not var_32_0.activated then
		return
	end

	if not Development.parameter("twitch_allow_multiple_votes") and var_32_0.user_names[arg_32_3] then
		return
	end

	if Development.parameter("twitch_randomize_votes") then
		arg_32_4 = var_32_0.option_strings[Math.random(#var_32_0.option_strings)]
	end

	local var_32_1 = string.lower(arg_32_4)
	local var_32_2 = var_32_0.options

	for iter_32_0, iter_32_1 in ipairs(var_32_0.option_strings) do
		if string.find(var_32_1, iter_32_1) then
			var_32_2[iter_32_0] = var_32_2[iter_32_0] + 1

			if not Development.parameter("twitch_allow_multiple_votes") then
				var_32_0.user_names[arg_32_3] = true
			end

			break
		end
	end

	arg_32_0:_update_game_object(arg_32_1, var_32_0)
end

function TwitchManager.disconnect(arg_33_0)
	if arg_33_0._connected then
		Managers.irc:force_disconnect()

		if arg_33_0._twitch_game_mode then
			arg_33_0._twitch_game_mode:destroy()

			arg_33_0._twitch_game_mode = nil
		end
	end

	arg_33_0._activated = false
	arg_33_0._connecting = false
end

function TwitchManager.update(arg_34_0, arg_34_1, arg_34_2)
	arg_34_0:_handle_disconnect_popup()
	arg_34_0:_handle_popup()
	arg_34_0:_validate_data(arg_34_1, arg_34_2)
	arg_34_0:_update_vote_data(arg_34_1, arg_34_2)
	arg_34_0:_update_twitch_game_mode(arg_34_1, arg_34_2)

	if arg_34_0._should_retry and arg_34_2 >= arg_34_0._next_retry_time then
		arg_34_0._should_retry = false

		Managers.backend:get_interface("live_events"):request_twitch_app_access_token(callback(arg_34_0, "cb_request_twitch_access_token"))
	end
end

function TwitchManager._handle_popup(arg_35_0)
	if arg_35_0._popup_id then
		local var_35_0 = Managers.popup:query_result(arg_35_0._popup_id)

		if var_35_0 then
			if var_35_0 == "return_to_inn" then
				local var_35_1 = Managers.mechanism:game_mechanism():get_hub_level_key()

				Managers.state.game_mode:start_specific_level(var_35_1)
			else
				Application.error(string.format("[TwitchManager] Unknown result: %s", var_35_0))
			end

			arg_35_0._popup_id = nil
		end
	end
end

function TwitchManager._handle_disconnect_popup(arg_36_0)
	if arg_36_0._error_popup_id then
		local var_36_0 = Managers.popup:query_result(arg_36_0._error_popup_id)

		if var_36_0 then
			if var_36_0 == "ok" then
				arg_36_0._error_popup_id = nil
			elseif var_36_0 then
				fassert(false, "[TwitchManager] The popup result doesn't exist (%s)", var_36_0)
			end
		end
	end
end

function TwitchManager._update_vote_data(arg_37_0, arg_37_1, arg_37_2)
	local var_37_0 = Managers.state.network

	if var_37_0 and var_37_0.is_server then
		if not arg_37_0._connected then
			return
		end

		local var_37_1 = arg_37_0._current_vote

		if var_37_1 then
			var_37_1.timer = var_37_1.timer - arg_37_1

			arg_37_0:_update_game_object(var_37_1.vote_key, var_37_1)

			if var_37_1.timer <= 0 then
				arg_37_0:_handle_results(var_37_1)

				local var_37_2 = var_37_1.cb

				if var_37_2 then
					var_37_2(var_37_1)
				end

				arg_37_0:unregister_vote(var_37_1.vote_key)
			end
		end
	else
		for iter_37_0, iter_37_1 in pairs(arg_37_0._game_object_ids) do
			local var_37_3 = arg_37_0._votes_lookup_table[iter_37_0]

			if var_37_3 then
				local var_37_4 = Managers.state.network and Managers.state.network:game()

				if var_37_4 then
					local var_37_5 = GameSession.game_object_field(var_37_4, iter_37_1, "options")

					var_37_3.timer, var_37_3.options = GameSession.game_object_field(var_37_4, iter_37_1, "time"), var_37_5
				end
			end
		end
	end
end

function TwitchManager._handle_results(arg_38_0, arg_38_1)
	local var_38_0 = Managers.level_transition_handler.enemy_package_loader
	local var_38_1 = Managers.state.network.is_server
	local var_38_2 = -1
	local var_38_3 = 0
	local var_38_4 = arg_38_0._current_vote.vote_type
	local var_38_5 = TwitchSettings[var_38_4]
	local var_38_6 = table.size(var_38_5)
	local var_38_7 = arg_38_1.options

	for iter_38_0 = 1, var_38_6 do
		repeat
			if var_38_4 == "multiple_choice" and not arg_38_0:_valid_player_index(iter_38_0) then
				break
			end

			local var_38_8 = var_38_7[iter_38_0]

			if var_38_2 < var_38_8 then
				var_38_3 = iter_38_0
				var_38_2 = var_38_8

				break
			end

			if var_38_8 == var_38_2 and math.random(2) == 1 then
				var_38_3 = iter_38_0
				var_38_2 = var_38_8
			end
		until true
	end

	for iter_38_1 = 1, var_38_6 do
		local var_38_9 = arg_38_1.vote_templates[iter_38_1]
		local var_38_10 = TwitchVoteTemplates[var_38_9].breed_name

		if var_38_10 and arg_38_0.locked_breed_packages[var_38_10] then
			var_38_0:unlock_breed_package(var_38_10)

			arg_38_0.locked_breed_packages[var_38_10] = nil
		end
	end

	local var_38_11
	local var_38_12 = var_38_11 or arg_38_1.vote_templates[var_38_3]

	arg_38_1.winning_template_name = var_38_12

	local var_38_13 = TwitchVoteTemplates[var_38_12]

	if not Development.parameter("twitch_disable_result") then
		var_38_13.on_success(var_38_1, var_38_3, var_38_13)
	else
		var_38_12 = "none"
	end

	if arg_38_1.show_vote_ui then
		Managers.state.event:trigger("finish_vote_ui", arg_38_1.vote_key, var_38_3)
	end

	local var_38_14 = ""

	Managers.state.network.network_transmit:send_rpc_clients("rpc_update_twitch_vote", NetworkLookup.twitch_rpc_types.rpc_finish_twitch_vote, arg_38_1.vote_key, var_38_14, var_38_3, NetworkLookup.twitch_vote_templates[var_38_12])
end

function TwitchManager._valid_player_index(arg_39_0, arg_39_1)
	local var_39_0 = Managers.player:human_and_bot_players()

	for iter_39_0, iter_39_1 in pairs(var_39_0) do
		if arg_39_1 == iter_39_1:profile_index() then
			return true
		end
	end

	return false
end

function TwitchManager._validate_data(arg_40_0, arg_40_1, arg_40_2)
	local var_40_0 = arg_40_0._current_vote

	if var_40_0 then
		local var_40_1 = var_40_0.validation_func

		if var_40_1 then
			var_40_1(var_40_0)
		end
	end
end

function TwitchManager.is_activated(arg_41_0)
	return arg_41_0._activated
end

function TwitchManager.reset(arg_42_0)
	arg_42_0:destroy()
end

function TwitchManager.destroy(arg_43_0)
	if Managers.state and Managers.state.event then
		Managers.state.event:trigger("reset_vote_ui")
	end

	arg_43_0:disconnect()
end

function TwitchManager.activate_twitch_game_mode(arg_44_0, arg_44_1, arg_44_2)
	if Development.parameter("twitch_debug_voting") then
		arg_44_0._connected = true
	end

	TwitchSettings.default_downtime = Application.user_setting("twitch_time_between_votes") or TwitchSettings.default_downtime
	TwitchSettings.default_vote_time = Application.user_setting("twitch_vote_time") or TwitchSettings.default_vote_time
	TwitchSettings.difficulty = Application.user_setting("twitch_difficulty") or TwitchSettings.difficulty

	local var_44_0 = Application.user_setting("twitch_disable_positive_votes")

	TwitchSettings.disable_giving_items = var_44_0 == TwitchSettings.positive_vote_options.disable_giving_items or var_44_0 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_positive_votes = var_44_0 == TwitchSettings.positive_vote_options.disable_positive_votes
	TwitchSettings.disable_mutators = Application.user_setting("twitch_disable_mutators")
	TwitchSettings.spawn_amount_multiplier = math.clamp(Application.user_setting("twitch_spawn_amount"), 1, 3)
	TwitchSettings.mutator_duration_multiplier = math.clamp(Application.user_setting("twitch_mutator_duration"), 1, 3)

	local var_44_1 = Managers.state.network and Managers.state.network
	local var_44_2 = var_44_1 and var_44_1.is_server

	if arg_44_0:game_mode_supported(arg_44_2) then
		Managers.state.event:trigger("activate_twitch_game_mode")

		arg_44_0._network_event_delegate = arg_44_1

		arg_44_1:register(arg_44_0, unpack(var_0_5))

		if arg_44_0._connected then
			if var_44_2 then
				arg_44_0._twitch_game_mode = TwitchGameMode:new(arg_44_0)
			end

			arg_44_0:_load_sound_bank()
		end

		arg_44_0._activated = var_44_1:lobby():lobby_data("twitch_enabled") == "true" and true or false

		if Development.parameter("twitch_debug_voting") then
			arg_44_0._activated = true
		end

		if arg_44_0._activated then
			Managers.telemetry_events:twitch_mode_activated()
		end
	end
end

function TwitchManager.debug_activate_twitch_game_mode(arg_45_0)
	if Development.parameter("twitch_debug_voting") then
		Managers.state.event:trigger("activate_twitch_game_mode")
		Managers.telemetry_events:twitch_mode_activated()

		arg_45_0._twitch_game_mode = TwitchGameMode:new(arg_45_0)

		arg_45_0:_load_sound_bank()

		arg_45_0._activated = true
		arg_45_0._connected = true
	else
		arg_45_0:deactivate_twitch_game_mode()
	end
end

function TwitchManager.deactivate_twitch_game_mode(arg_46_0)
	if arg_46_0._current_vote then
		arg_46_0:unregister_vote(arg_46_0._current_vote.vote_key)
	end

	if arg_46_0._network_event_delegate then
		arg_46_0._network_event_delegate:unregister(arg_46_0)

		arg_46_0._network_event_delegate = nil
	end

	if arg_46_0._twitch_game_mode then
		arg_46_0._twitch_game_mode:destroy()

		arg_46_0._twitch_game_mode = nil
	end

	arg_46_0._activated = false

	arg_46_0:_unload_sound_bank()
end

function TwitchManager._update_twitch_game_mode(arg_47_0, arg_47_1, arg_47_2)
	if not arg_47_0._twitch_game_mode or not arg_47_0._connected then
		return
	end

	arg_47_0._twitch_game_mode:update(arg_47_1, arg_47_2)

	if Development.parameter("twitch_debug_voting") then
		arg_47_0:_update_debug_voting(arg_47_1)
	end
end

local var_0_7 = {
	"default_vote_a_str",
	"default_vote_b_str",
	"default_vote_c_str",
	"default_vote_d_str",
	"default_vote_e_str"
}

function TwitchManager._update_debug_voting(arg_48_0, arg_48_1)
	arg_48_0._debug_vote_timer = arg_48_0._debug_vote_timer - arg_48_1

	if arg_48_0._debug_vote_timer > 0 then
		return
	end

	local var_48_0 = arg_48_0._current_vote

	if not var_48_0 then
		return
	end

	local var_48_1

	if var_48_0.vote_type == "standard_vote" then
		local var_48_2 = script_data.twitch_mode_force_vote_template and 1 or math.random(2)

		var_48_1 = var_0_7[var_48_2]
	else
		local var_48_3 = math.random(5)

		if not arg_48_0:_valid_player_index(var_48_3) then
			return
		end

		var_48_1 = var_0_7[var_48_3]
	end

	local var_48_4 = TwitchSettings.multiple_choice[var_48_1]
	local var_48_5 = var_48_0.options
	local var_48_6 = var_48_0.option_strings

	for iter_48_0, iter_48_1 in ipairs(var_48_6) do
		if string.find(var_48_4, iter_48_1) then
			var_48_5[iter_48_0] = var_48_5[iter_48_0] + 1

			break
		end
	end

	local var_48_7 = var_48_0.vote_key

	arg_48_0:_update_game_object(var_48_7, var_48_0)

	arg_48_0._debug_vote_timer = 0.25
end

TwitchGameMode = class(TwitchGameMode)

function TwitchGameMode.init(arg_49_0, arg_49_1)
	arg_49_0._timer = TwitchSettings.initial_downtime
	arg_49_0._funds = TwitchSettings.starting_funds
	arg_49_0._parent = arg_49_1
	arg_49_0._vote_keys = {}
	arg_49_0._used_vote_templates = {}

	Debug.text("Activating Twitch Game Mode")
end

function TwitchGameMode.update(arg_50_0, arg_50_1, arg_50_2)
	arg_50_0._timer = arg_50_0._timer - arg_50_1

	if arg_50_0._timer > 0 then
		return
	end

	if Managers.state.network and Managers.state.network:game() then
		arg_50_0:_trigger_new_vote()
	end
end

function TwitchGameMode._update_used_votes(arg_51_0)
	local var_51_0 = arg_51_0._used_vote_templates

	for iter_51_0, iter_51_1 in pairs(var_51_0) do
		if iter_51_1 - 1 == 0 then
			var_51_0[iter_51_0] = nil
		else
			var_51_0[iter_51_0] = iter_51_1 - 1
		end
	end

	arg_51_0:_clear_used_votes()
end

function TwitchGameMode._clear_used_votes(arg_52_0, arg_52_1)
	local var_52_0 = arg_52_0._used_vote_templates
	local var_52_1 = arg_52_0:_get_game_mode_whitelist()
	local var_52_2 = var_52_1 and #var_52_1 or #TwitchVoteTemplatesLookup

	if arg_52_1 or var_52_2 - table.size(var_52_0) <= var_0_1 then
		table.clear(var_52_0)
	end
end

function TwitchGameMode._check_breed_package_loading(arg_53_0, arg_53_1, arg_53_2)
	local var_53_0 = arg_53_1.breed_name

	if not var_53_0 then
		return arg_53_1
	end

	local var_53_1 = arg_53_1.boss
	local var_53_2 = arg_53_1.special

	if not var_53_1 and not var_53_2 then
		return arg_53_1
	end

	local var_53_3 = Managers.level_transition_handler.enemy_package_loader
	local var_53_4 = true
	local var_53_5

	if not var_53_3:is_breed_processed(var_53_0) then
		var_53_4 = var_53_3:request_breed(var_53_0)
	end

	if var_53_4 then
		var_53_3:lock_breed_package(var_53_0)

		arg_53_0._parent.locked_breed_packages[var_53_0] = true

		return arg_53_1
	else
		local var_53_6 = {}

		for iter_53_0, iter_53_1 in pairs(var_53_3:processed_breeds()) do
			var_53_6[#var_53_6 + 1] = iter_53_0
		end

		table.shuffle(var_53_6)

		local var_53_7 = var_53_1 and TwitchBossesSpawnBreedNamesLookup or var_53_2 and TwitchSpecialsSpawnBreedNamesLookup

		for iter_53_2 = 1, #var_53_6 do
			local var_53_8 = var_53_6[iter_53_2]

			if var_53_7[var_53_8] then
				var_53_5 = var_53_8

				break
			end
		end
	end

	local var_53_9 = var_53_1 and arg_53_2 and arg_53_2.breed_name == var_53_5
	local var_53_10
	local var_53_11 = arg_53_0._used_vote_templates

	if var_53_9 then
		local var_53_12 = math.huge
		local var_53_13 = TwitchBossEquivalentSpawnTemplatesLookup

		table.shuffle(var_53_13)

		for iter_53_3 = 1, #var_53_13 do
			local var_53_14 = var_53_13[iter_53_3]

			if not var_53_11[var_53_14] then
				local var_53_15 = TwitchVoteTemplates[var_53_14]

				if arg_53_1.name ~= var_53_15.name then
					local var_53_16 = math.abs(math.abs(arg_53_1.cost) - math.abs(var_53_15.cost))

					if var_53_16 < var_53_12 then
						var_53_10 = var_53_15
						var_53_12 = var_53_16
					end
				end
			end
		end
	elseif var_53_1 then
		var_53_10 = TwitchBossesSpawnBreedNamesLookup[var_53_5]
	elseif var_53_2 then
		local var_53_17 = TwitchSpecialsSpawnBreedNamesLookup[var_53_5]

		if not var_53_11[var_53_17.name] and (arg_53_2 == nil or arg_53_2 and arg_53_2.name ~= var_53_17.name) and arg_53_1.name ~= var_53_17.name then
			var_53_10 = var_53_17
		end
	end

	if not var_53_10 then
		arg_53_0:_clear_used_votes(true)
		print("BREED PACKAGE LOADING FAILED")

		return arg_53_0:_check_breed_package_loading(arg_53_1, arg_53_2)
	end

	return var_53_10
end

function TwitchGameMode._get_game_mode_whitelist(arg_54_0)
	local var_54_0 = Managers.state.game_mode:game_mode_key()

	return TwitchVoteWhitelists[var_54_0]
end

function TwitchGameMode._in_whitelist(arg_55_0, arg_55_1)
	local var_55_0 = arg_55_0:_get_game_mode_whitelist()

	if var_55_0 == nil then
		return true
	else
		return table.contains(var_55_0, arg_55_1)
	end
end

function TwitchGameMode._get_next_vote(arg_56_0)
	arg_56_0:_update_used_votes()

	local var_56_0 = arg_56_0._funds
	local var_56_1 = arg_56_0._used_vote_templates
	local var_56_2

	if var_56_0 >= TwitchSettings.cutoff_for_guaranteed_positive_vote and not TwitchSettings.disable_positive_votes then
		local var_56_3 = table.clone(TwitchPositiveVoteTemplatesLookup)

		table.shuffle(var_56_3)

		local var_56_4 = -math.huge

		for iter_56_0 = 1, #var_56_3 do
			local var_56_5 = var_56_3[iter_56_0]

			if not var_56_1[var_56_5] then
				local var_56_6 = TwitchVoteTemplates[var_56_5]

				if arg_56_0:_in_whitelist(var_56_5) and (not var_56_6.condition_func or var_56_6.condition_func()) then
					local var_56_7 = var_56_0 - var_56_6.cost

					if var_56_4 < var_56_7 then
						var_56_2 = var_56_6
						var_56_4 = var_56_7
					end
				end
			end
		end
	elseif var_56_0 <= TwitchSettings.cutoff_for_guaranteed_negative_vote then
		local var_56_8 = table.clone(TwitchNegativeVoteTemplatesLookup)

		table.shuffle(var_56_8)

		local var_56_9 = math.huge

		for iter_56_1 = 1, #var_56_8 do
			local var_56_10 = var_56_8[iter_56_1]

			if not var_56_1[var_56_10] then
				local var_56_11 = TwitchVoteTemplates[var_56_10]

				if arg_56_0:_in_whitelist(var_56_10) and (not var_56_11.condition_func or var_56_11.condition_func()) then
					local var_56_12 = var_56_0 + var_56_11.cost

					if var_56_12 < var_56_9 then
						var_56_2 = var_56_11
						var_56_9 = var_56_12
					end
				end
			end
		end
	end

	if var_56_2 == nil then
		local var_56_13 = table.clone(TwitchVoteTemplatesLookup)

		table.shuffle(var_56_13)

		for iter_56_2 = 1, #var_56_13 do
			local var_56_14 = var_56_13[iter_56_2]

			if not var_56_1[var_56_14] then
				local var_56_15 = TwitchVoteTemplates[var_56_14]

				if arg_56_0:_in_whitelist(var_56_14) and (not var_56_15.condition_func or var_56_15.condition_func()) then
					var_56_2 = var_56_15

					break
				end
			end
		end
	end

	if var_56_2 == nil then
		return nil
	end

	if var_56_2.multiple_choice then
		return arg_56_0:_next_multiple_choice_vote(var_56_2)
	else
		return arg_56_0:_next_standard_vote(var_56_2)
	end
end

function TwitchGameMode._next_multiple_choice_vote(arg_57_0, arg_57_1)
	local var_57_0 = {}

	for iter_57_0 = 1, 5 do
		var_57_0[iter_57_0] = arg_57_1.name
	end

	local var_57_1 = arg_57_1.validation_func

	return "multiple_choice", var_57_0, var_57_1
end

function TwitchGameMode._next_standard_vote(arg_58_0, arg_58_1)
	local var_58_0 = arg_58_0._used_vote_templates
	local var_58_1 = arg_58_1.name
	local var_58_2 = arg_58_1.cost
	local var_58_3 = table.clone(TwitchStandardVoteTemplatesLookup)

	table.shuffle(var_58_3)

	local var_58_4
	local var_58_5 = math.huge

	for iter_58_0 = 1, #var_58_3 do
		local var_58_6 = var_58_3[iter_58_0]

		if var_58_1 ~= var_58_6 and not var_58_0[var_58_6] then
			local var_58_7 = TwitchVoteTemplates[var_58_6]

			if (not var_58_7.condition_func or var_58_7.condition_func()) and not (arg_58_1.boss and not var_58_7.boss and not var_58_7.boss_equivalent) then
				local var_58_8 = var_58_7.cost
				local var_58_9 = math.abs(var_58_2 - var_58_8)

				if var_58_9 <= TwitchSettings.max_a_b_vote_cost_diff and var_58_9 < var_58_5 then
					var_58_4 = var_58_7
					var_58_5 = var_58_9
				end
			end
		end
	end

	if not var_58_4 then
		arg_58_0:_clear_used_votes(true)

		return arg_58_0:_next_standard_vote(arg_58_1)
	end

	arg_58_1 = arg_58_0:_check_breed_package_loading(arg_58_1)

	local var_58_10 = arg_58_0:_check_breed_package_loading(var_58_4, arg_58_1)
	local var_58_11 = {
		arg_58_1.name,
		var_58_10.name
	}

	return "standard_vote", var_58_11, nil
end

function TwitchGameMode._trigger_new_vote(arg_59_0)
	local var_59_0, var_59_1, var_59_2 = arg_59_0:_get_next_vote()
	local var_59_3 = Application.user_setting("twitch_vote_time") or TwitchSettings.default_vote_time

	if var_59_0 then
		local var_59_4 = arg_59_0._parent:register_vote(var_59_3, var_59_0, var_59_2, var_59_1, true, callback(arg_59_0, "cb_on_vote_complete"))

		arg_59_0._vote_keys[var_59_4] = true
	end

	arg_59_0._timer = (Application.user_setting("twitch_time_between_votes") or TwitchSettings.default_downtime) + var_59_3
end

function TwitchGameMode.cb_on_vote_complete(arg_60_0, arg_60_1)
	Managers.telemetry_events:twitch_poll_completed(arg_60_1)

	local var_60_0 = TwitchVoteTemplates[arg_60_1.winning_template_name]

	arg_60_0._funds = arg_60_0._funds + var_60_0.cost
	arg_60_0._used_vote_templates[var_60_0.name] = var_0_0
	arg_60_0._vote_keys[arg_60_1.vote_key] = nil
end

function TwitchGameMode.destroy(arg_61_0)
	var_0_4("Destroying Twitch Game mode")

	for iter_61_0, iter_61_1 in pairs(arg_61_0._vote_keys) do
		if Managers.state and Managers.state.event then
			Managers.state.event:trigger("reset_vote_ui", iter_61_0)
		end

		arg_61_0._parent:unregister_vote(iter_61_0)
		var_0_4("Destroying Twitch Vote %s", iter_61_0)
	end

	local var_61_0 = Managers.level_transition_handler.enemy_package_loader

	for iter_61_2, iter_61_3 in pairs(arg_61_0._parent.locked_breed_packages) do
		var_61_0:unlock_breed_package(iter_61_2)

		arg_61_0._parent.locked_breed_packages[iter_61_2] = nil
	end

	if Managers.state and Managers.state.event then
		Managers.state.event:trigger("reset_vote_ui")
	end
end
