-- chunkname: @scripts/managers/irc/irc_manager.lua

require("scripts/managers/irc/script_irc_token")
require("scripts/managers/irc/irc_utils")

IRCManager = class(IRCManager)
Irc.LIST_END_MSG = 8
Irc.META_MSG = 9
Irc.TEAM_MSG = 10
Irc.ALL_MSG = 11

local var_0_0 = false
local var_0_1 = 3
local var_0_2 = {}

local function var_0_3(arg_1_0, ...)
	if var_0_0 then
		printf("[IRCManager] " .. arg_1_0, ...)
	end
end

function IRCManager.init(arg_2_0)
	arg_2_0:_reset()
end

function IRCManager._reset(arg_3_0)
	arg_3_0._state = "none"
	arg_3_0._connection_retries = 0
	arg_3_0._user_name = nil
	arg_3_0._port = nil
	arg_3_0._host_address = nil
	arg_3_0._channel_members = {}
	arg_3_0._channels = {}
	arg_3_0._callback_by_type = arg_3_0._callback_by_type or {
		[Irc.PRIVATE_MSG] = {},
		[Irc.CHANNEL_MSG] = {},
		[Irc.SYSTEM_MSG] = {},
		[Irc.JOIN_MSG] = {},
		[Irc.LEAVE_MSG] = {},
		[Irc.NAMES_MSG] = {},
		[Irc.LIST_MSG] = {},
		[Irc.LIST_END_MSG] = {},
		[Irc.META_MSG] = {}
	}
end

function IRCManager.connect(arg_4_0, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	local var_4_0 = arg_4_3.address
	local var_4_1 = arg_4_3.port or 6667
	local var_4_2 = arg_4_3.channel_name
	local var_4_3 = arg_4_3.allow_send

	fassert(var_4_0 and var_4_1, "[IRCManager] You need to provide both address and port when connecting to IRC")

	arg_4_0._host_address = var_4_0
	arg_4_0._port = var_4_1

	local var_4_4 = "justinfan" .. Math.random(99999)

	arg_4_0._user_name = arg_4_1 or arg_4_0._user_name or var_4_4
	arg_4_0._user_name = string.gsub(arg_4_0._user_name, " ", "_")
	arg_4_0._password = arg_4_2 or nil
	arg_4_0._auto_join_channel = var_4_2
	arg_4_0._home_channel = var_4_2 or ""

	arg_4_0:_change_state("initialize")

	arg_4_0._callback = arg_4_4
	arg_4_0._allow_send = var_4_3
end

function IRCManager.home_channel(arg_5_0)
	return arg_5_0._home_channel
end

function IRCManager.set_user_name(arg_6_0, arg_6_1)
	fassert(arg_6_0._state == "none", "[IRCManager] You can't change user name after you've connected")

	arg_6_0._user_name = string.gsub(arg_6_1, " ", "_")
end

function IRCManager.register_message_callback(arg_7_0, arg_7_1, arg_7_2, arg_7_3)
	fassert(arg_7_0._callback_by_type[arg_7_2], "[IRCManager] There is no message type called %s", arg_7_2)

	arg_7_0._callback_by_type[arg_7_2][arg_7_1] = arg_7_3
end

function IRCManager.unregister_message_callback(arg_8_0, arg_8_1, arg_8_2)
	if arg_8_2 then
		arg_8_0._callback_by_type[arg_8_2][arg_8_1] = nil
	else
		for iter_8_0, iter_8_1 in pairs(arg_8_0._callback_by_type) do
			arg_8_0._callback_by_type[iter_8_0][arg_8_1] = nil
		end
	end
end

function IRCManager.user_name(arg_9_0)
	return arg_9_0._user_name
end

function IRCManager.force_disconnect(arg_10_0)
	Irc.disconnect()
end

function IRCManager.send_message(arg_11_0, arg_11_1, arg_11_2)
	if arg_11_0._allow_send then
		local var_11_0 = arg_11_2

		if var_11_0 == arg_11_0._user_name then
			Application.error("[IRCManager] You cannot message yourself")
		else
			var_0_3("message: %s - channel or user: %s", arg_11_1, tostring(var_11_0))

			var_0_2[#var_0_2 + 1] = {
				message = arg_11_1,
				channel_or_user = var_11_0
			}

			return true
		end
	else
		Application.error("[IRCManager] You're not allowed to send messages")
	end

	return false
end

function IRCManager.join_channel(arg_12_0, arg_12_1)
	var_0_3("Joining Channel: %s", tostring(arg_12_1))
	Irc.join_channel(arg_12_1)
end

function IRCManager.leave_channel(arg_13_0, arg_13_1)
	var_0_3("Leaving Channel: %s", tostring(arg_13_1))
	Irc.leave_channel(arg_13_1)
end

function IRCManager.who(arg_14_0, arg_14_1)
	Irc.who(arg_14_1)
end

function IRCManager.destroy(arg_15_0)
	Irc.disconnect()
end

function IRCManager._handle_irc_message(arg_16_0, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	var_0_3("Message: %s %s %s %s", arg_16_1, arg_16_2, arg_16_3, arg_16_4)

	if arg_16_0:_handle_meta(arg_16_1, arg_16_2, arg_16_3, arg_16_4) then
		return
	end

	arg_16_1 = arg_16_0:_handle_connections(arg_16_1, arg_16_2, arg_16_3, arg_16_4)

	local var_16_0 = arg_16_0._callback_by_type[arg_16_1]

	if var_16_0 then
		local var_16_1 = string.gsub(arg_16_3, "%c", "")

		for iter_16_0, iter_16_1 in pairs(var_16_0) do
			iter_16_1(iter_16_0, arg_16_1, arg_16_2, var_16_1, arg_16_4)
		end
	end
end

function IRCManager._handle_connections(arg_17_0, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	arg_17_0._channels = arg_17_0._channels or {}
	arg_17_0._channel_members = arg_17_0._channel_members or {}

	if arg_17_1 == Irc.NAMES_MSG then
		local var_17_0 = arg_17_4
		local var_17_1 = string.split_deprecated(arg_17_3, " ")

		arg_17_0._channels[var_17_0] = true
		arg_17_0._channel_members[var_17_0] = arg_17_0._channel_members[var_17_0] or {}

		local var_17_2 = arg_17_0._channel_members[var_17_0]

		for iter_17_0, iter_17_1 in ipairs(var_17_1) do
			if not var_17_2[iter_17_1] then
				var_17_2[iter_17_1] = {
					icon_id = 0,
					info = "",
					level = "n/a",
					name = iter_17_1,
					time = Managers.time:time("main")
				}
			end
		end
	elseif arg_17_1 == Irc.LEAVE_MSG then
		if arg_17_2 == arg_17_0._user_name then
			local var_17_3 = arg_17_4

			arg_17_0._channel_members[var_17_3] = nil
			arg_17_0._channels[var_17_3] = nil
		else
			local var_17_4 = arg_17_4

			arg_17_0._channel_members[var_17_4] = arg_17_0._channel_members[var_17_4] or {}
			arg_17_0._channel_members[var_17_4][arg_17_2] = nil
		end
	elseif arg_17_1 == Irc.JOIN_MSG then
		local var_17_5 = arg_17_4

		arg_17_0._channel_members[var_17_5] = arg_17_0._channel_members[var_17_5] or {}

		local var_17_6
		local var_17_7
		local var_17_8
		local var_17_9

		if arg_17_2 == arg_17_0._user_name then
			var_17_7 = 1
			var_17_9 = "vermintide owns"

			local var_17_10 = ExperienceSettings.get_highest_character_level()

			var_17_6 = {
				name = arg_17_2,
				time = Managers.time:time("main"),
				icon_id = var_17_7,
				level = var_17_10,
				info = var_17_9
			}

			local var_17_11 = arg_17_0:_create_metadata_table(arg_17_2, var_17_7, var_17_10, var_17_9)

			Irc.send_message(var_17_11, arg_17_4)
			arg_17_0:_update_meta_data(arg_17_2, var_17_5, var_17_6)
		else
			var_17_6 = {
				name = arg_17_2,
				time = Managers.time:time("main"),
				icon_id = var_17_7,
				level = var_17_8,
				info = var_17_9
			}
		end

		arg_17_0._channel_members[var_17_5][arg_17_2] = var_17_6
		arg_17_0._channels[var_17_5] = true

		Managers.chat:add_message_target(var_17_5, Irc.CHANNEL_MSG)
	elseif arg_17_1 == Irc.LIST_MSG and arg_17_3 == "CHANNELS_END" then
		arg_17_1 = Irc.LIST_END_MSG
	end

	return arg_17_1
end

function IRCManager._handle_meta(arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	if arg_18_1 == Irc.CHANNEL_MSG then
		local var_18_0, var_18_1 = string.find(arg_18_3, "$META;")

		if var_18_1 then
			local var_18_2 = string.sub(arg_18_3, var_18_1 + 1)

			Managers.irc:parse_metadata(var_18_2, arg_18_2, arg_18_4)

			return true
		end
	end

	return false
end

function IRCManager._create_metadata_table(arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	return "$META;" .. arg_19_1 .. ";" .. arg_19_2 .. ";" .. arg_19_3 .. ";" .. arg_19_4
end

function IRCManager.parse_metadata(arg_20_0, arg_20_1, arg_20_2, arg_20_3)
	local var_20_0 = string.split_deprecated(arg_20_1, ";")
	local var_20_1 = arg_20_0._channel_members[arg_20_3][arg_20_2]

	if var_20_1 then
		var_20_1.icon_id = var_20_0[2] and tonumber(var_20_0[2])
		var_20_1.level = var_20_0[3]
		var_20_1.info = var_20_0[4]

		arg_20_0:_update_meta_data(arg_20_2, arg_20_3, var_20_1)
	else
		print("\tMissing user data")
	end
end

function IRCManager._update_meta_data(arg_21_0, arg_21_1, arg_21_2, arg_21_3)
	local var_21_0 = Irc.META_MSG
	local var_21_1 = arg_21_0._callback_by_type[var_21_0]

	if var_21_1 then
		for iter_21_0, iter_21_1 in pairs(var_21_1) do
			iter_21_1(iter_21_0, var_21_0, arg_21_1, arg_21_2, arg_21_3)
		end
	end
end

function IRCManager.get_channel_members(arg_22_0, arg_22_1)
	if arg_22_1 and arg_22_0._channel_members[arg_22_1] then
		return arg_22_0._channel_members[arg_22_1]
	else
		return {}
	end
end

function IRCManager.get_channels(arg_23_0)
	return arg_23_0._channels
end

function IRCManager._parse_names_list(arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	local var_24_0, var_24_1 = string.find(arg_24_4, arg_24_1 .. " :")
	local var_24_2 = string.sub(arg_24_4, var_24_1)
	local var_24_3 = string.split_deprecated(var_24_2, " ")

	for iter_24_0, iter_24_1 in ipairs(var_24_3) do
		print(iter_24_1)
	end
end

function IRCManager.update(arg_25_0, arg_25_1)
	IRCStates[arg_25_0._state](arg_25_0, arg_25_1)
end

function IRCManager.cb_connect_token_received(arg_26_0, arg_26_1)
	print("[IrcManager:cb_connect_token_received] Result: " .. tostring(arg_26_1.result))
	arg_26_0:_change_state("verify_connection")
end

function IRCManager._change_state(arg_27_0, arg_27_1)
	fassert(IRCStates[arg_27_1], "[IRCManager] There is no state called %s", arg_27_1)
	var_0_3("Leaving state: %s", arg_27_0._state)

	arg_27_0._state = arg_27_1

	var_0_3("Entering state: %s", arg_27_0._state)
end

function IRCManager._notify_connected(arg_28_0, arg_28_1)
	if arg_28_0._callback then
		arg_28_0._callback(arg_28_1)
	end
end

IRCStates = IRCStates or {}

function IRCStates.none(arg_29_0, arg_29_1)
	return
end

function IRCStates.initialize(arg_30_0, arg_30_1)
	if IS_PS4 then
		arg_30_0._initialized = true

		arg_30_0:_change_state("connect")

		return
	end

	if Irc.is_initialized() then
		Application.error("[IRCManager] Failed initializing IRC")
		arg_30_0:_change_state("disconnect")

		return
	end

	arg_30_0._initialized = Irc.initialize()

	if arg_30_0._initialized then
		arg_30_0:_change_state("connect")
	else
		Application.error("[IRCManager] Failed initializing IRC")
		arg_30_0:_change_state("disconnect")
	end
end

function IRCStates.connect(arg_31_0, arg_31_1)
	local var_31_0 = arg_31_0._host_address
	local var_31_1 = arg_31_0._port
	local var_31_2 = "justinfan" .. Math.random(9999)
	local var_31_3 = arg_31_0._user_name or var_31_2
	local var_31_4 = arg_31_0._password or nil
	local var_31_5 = Irc.connect_async_token(var_31_0, var_31_1, var_31_3, var_31_4)
	local var_31_6 = ScriptIrcToken:new(var_31_5)

	Managers.token:register_token(var_31_6, callback(arg_31_0, "cb_connect_token_received"))
	arg_31_0:_change_state("wait_for_connection")

	arg_31_0._connection_retries = arg_31_0._connection_retries + 1
end

function IRCStates.join_channel(arg_32_0, arg_32_1)
	if Irc.is_connected() then
		arg_32_0:join_channel(arg_32_0._auto_join_channel)

		arg_32_0._auto_join_channel = false

		arg_32_0:_change_state("connected")
		arg_32_0:_notify_connected(true)
	else
		Application.error("[IRCManager] Disconnected from server")
		arg_32_0:_change_state("disconnect")
	end
end

function IRCStates.connected(arg_33_0, arg_33_1)
	if Irc.is_connected() then
		for iter_33_0, iter_33_1 in ipairs(var_0_2) do
			Irc.send_message(iter_33_1.message, iter_33_1.channel_or_user)
		end

		table.clear(var_0_2)

		local var_33_0, var_33_1, var_33_2, var_33_3 = Irc.poll_message()

		if var_33_2 then
			arg_33_0:_handle_irc_message(var_33_0, var_33_1, var_33_2, var_33_3)
		end
	else
		Application.error("[IRCManager] Disconnected from server")
		arg_33_0:_change_state("disconnect")
	end
end

function IRCStates.disconnect(arg_34_0, arg_34_1)
	if Irc.is_connected() then
		Irc.disconnect()
	end

	arg_34_0:_notify_connected(false)
	arg_34_0:_reset()
	arg_34_0:_change_state("none")
end

function IRCStates.verify_connection(arg_35_0, arg_35_1)
	if Irc.is_connected() then
		if arg_35_0._auto_join_channel then
			arg_35_0:_change_state("join_channel")
		else
			arg_35_0:_change_state("connected")
			arg_35_0:_notify_connected(true)
		end
	elseif arg_35_0._connection_retries > var_0_1 then
		local var_35_0 = arg_35_0._host_address
		local var_35_1 = arg_35_0._port
		local var_35_2 = "justinfan" .. Math.random(9999)
		local var_35_3 = arg_35_0._user_name or var_35_2

		Application.error("[IRCManager] Failed connecting to " .. var_35_0 .. ":" .. var_35_1 .. " with user_name: " .. var_35_3)
		arg_35_0:_change_state("disconnect")
	end
end

function IRCStates.wait_for_connection(arg_36_0, arg_36_1)
	return
end
