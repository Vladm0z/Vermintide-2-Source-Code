-- chunkname: @scripts/managers/irc/irc_manager.lua

require("scripts/managers/irc/script_irc_token")
require("scripts/managers/irc/irc_utils")

IRCManager = class(IRCManager)
Irc.LIST_END_MSG = 8
Irc.META_MSG = 9
Irc.TEAM_MSG = 10
Irc.ALL_MSG = 11

local flag = false
local num = 3
local tbl = {}

local function fn(arg_1_0, ...)
	-- function 1
	if not flag then
		printf("[IRCManager] " .. arg_1_0, ...)
	end
end

IRCManager.init = function (self)
	-- function 2
	self:_reset()
end

IRCManager._reset = function (self)
	-- function 3
	self._state = "none"
	self._connection_retries = 0
	self._user_name = nil
	self._port = nil
	self._host_address = nil
	self._channel_members = {}
	self._channels = {}

	local _callback_by_type = self._callback_by_type

	_callback_by_type = _callback_by_type or {
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
	self._callback_by_type = _callback_by_type
end

IRCManager.connect = function (self, arg_4_1, arg_4_2, arg_4_3, arg_4_4)
	-- function 4
	local address = arg_4_3.address
	local port = arg_4_3.port

	port = port or 6667

	local channel_name = arg_4_3.channel_name
	local allow_send = arg_4_3.allow_send

	fassert(not address and port, "[IRCManager] You need to provide both address and port when connecting to IRC")

	self._host_address = address
	self._port = port

	local str = "justinfan" .. Math.random(99999)

	if not arg_4_1 then
		-- Nothing
	end

	::label_4_0::

	local _user_name = self._user_name

	_user_name = _user_name or str

	::label_4_1::

	self._user_name = _user_name
	self._user_name = string.gsub(self._user_name, " ", "_")
	self._password = arg_4_2 or nil
	self._auto_join_channel = channel_name
	self._home_channel = channel_name or ""

	self:_change_state("initialize")

	self._callback = arg_4_4
	self._allow_send = allow_send
end

IRCManager.home_channel = function (self)
	-- function 5
	return self._home_channel
end

IRCManager.set_user_name = function (self, arg_6_1)
	-- function 6
	fassert(self._state == "none", "[IRCManager] You can't change user name after you've connected")

	self._user_name = string.gsub(arg_6_1, " ", "_")
end

IRCManager.register_message_callback = function (self, arg_7_1, arg_7_2, arg_7_3)
	-- function 7
	fassert(self._callback_by_type[arg_7_2], "[IRCManager] There is no message type called %s", arg_7_2)

	self._callback_by_type[arg_7_2][arg_7_1] = arg_7_3
end

IRCManager.unregister_message_callback = function (self, arg_8_1, arg_8_2)
	-- function 8
	if not arg_8_2 then
		self._callback_by_type[arg_8_2][arg_8_1] = nil
	else
		for k, v in pairs(self._callback_by_type) do
			self._callback_by_type[k][arg_8_1] = nil
		end
	end
end

IRCManager.user_name = function (self)
	-- function 9
	return self._user_name
end

IRCManager.force_disconnect = function (arg_10_0)
	-- function 10
	Irc.disconnect()
end

IRCManager.send_message = function (self, arg_11_1, arg_11_2)
	-- function 11
	if not self._allow_send then
		local var_11_0 = arg_11_2

		if var_11_0 == self._user_name then
			Application.error("[IRCManager] You cannot message yourself")
		else
			fn("message: %s - channel or user: %s", arg_11_1, tostring(var_11_0))

			tbl[#tbl + 1] = {
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

IRCManager.join_channel = function (arg_12_0, arg_12_1)
	-- function 12
	fn("Joining Channel: %s", tostring(arg_12_1))
	Irc.join_channel(arg_12_1)
end

IRCManager.leave_channel = function (arg_13_0, arg_13_1)
	-- function 13
	fn("Leaving Channel: %s", tostring(arg_13_1))
	Irc.leave_channel(arg_13_1)
end

IRCManager.who = function (arg_14_0, arg_14_1)
	-- function 14
	Irc.who(arg_14_1)
end

IRCManager.destroy = function (arg_15_0)
	-- function 15
	Irc.disconnect()
end

IRCManager._handle_irc_message = function (self, arg_16_1, arg_16_2, arg_16_3, arg_16_4)
	-- function 16
	fn("Message: %s %s %s %s", arg_16_1, arg_16_2, arg_16_3, arg_16_4)

	if not self:_handle_meta(arg_16_1, arg_16_2, arg_16_3, arg_16_4) then
		return
	end

	arg_16_1 = self:_handle_connections(arg_16_1, arg_16_2, arg_16_3, arg_16_4)

	local var_16_0 = self._callback_by_type[arg_16_1]

	if not var_16_0 then
		local gsub = string.gsub(arg_16_3, "%c", "")

		for k, v in pairs(var_16_0) do
			v(k, arg_16_1, arg_16_2, gsub, arg_16_4)
		end
	end
end

IRCManager._handle_connections = function (self, arg_17_1, arg_17_2, arg_17_3, arg_17_4)
	-- function 17
	local _channels = self._channels

	_channels = _channels or {}
	self._channels = _channels

	local _channel_members = self._channel_members

	_channel_members = _channel_members or {}
	self._channel_members = _channel_members

	if arg_17_1 == Irc.NAMES_MSG then
		local var_17_2 = arg_17_4
		local split_deprecated = string.split_deprecated(arg_17_3, " ")

		self._channels[var_17_2] = true

		local _channel_members_2 = self._channel_members
		local var_17_5 = self._channel_members[var_17_2]

		var_17_5 = var_17_5 or {}
		_channel_members_2[var_17_2] = var_17_5

		local var_17_6 = self._channel_members[var_17_2]

		for i, v in ipairs(split_deprecated) do
			if not var_17_6[v] then
				var_17_6[v] = {
					icon_id = 0,
					info = "",
					level = "n/a",
					name = v,
					time = Managers.time:time("main")
				}
			end
		end
	elseif arg_17_1 == Irc.LEAVE_MSG then
		if arg_17_2 == self._user_name then
			local var_17_7 = arg_17_4

			self._channel_members[var_17_7] = nil
			self._channels[var_17_7] = nil
		else
			local var_17_8 = arg_17_4
			local _channel_members_3 = self._channel_members
			local var_17_10 = self._channel_members[var_17_8]

			var_17_10 = var_17_10 or {}
			_channel_members_3[var_17_8] = var_17_10
			self._channel_members[var_17_8][arg_17_2] = nil
		end
	elseif arg_17_1 == Irc.JOIN_MSG then
		local var_17_11 = arg_17_4
		local _channel_members_4 = self._channel_members
		local var_17_13 = self._channel_members[var_17_11]

		var_17_13 = var_17_13 or {}
		_channel_members_4[var_17_11] = var_17_13

		local var_17_14
		local var_17_15
		local var_17_16
		local var_17_17

		if arg_17_2 == self._user_name then
			var_17_15 = 1
			var_17_17 = "vermintide owns"

			local get_highest_character_level = ExperienceSettings.get_highest_character_level()

			var_17_14 = {
				name = arg_17_2,
				time = Managers.time:time("main"),
				icon_id = var_17_15,
				level = get_highest_character_level,
				info = var_17_17
			}

			local _create_metadata_table = self:_create_metadata_table(arg_17_2, var_17_15, get_highest_character_level, var_17_17)

			Irc.send_message(_create_metadata_table, arg_17_4)
			self:_update_meta_data(arg_17_2, var_17_11, var_17_14)
		else
			var_17_14 = {
				name = arg_17_2,
				time = Managers.time:time("main"),
				icon_id = var_17_15,
				level = var_17_16,
				info = var_17_17
			}
		end

		self._channel_members[var_17_11][arg_17_2] = var_17_14
		self._channels[var_17_11] = true

		Managers.chat:add_message_target(var_17_11, Irc.CHANNEL_MSG)
	elseif not (arg_17_1 ~= Irc.LIST_MSG or arg_17_3 ~= "CHANNELS_END") then
		arg_17_1 = Irc.LIST_END_MSG
	end

	return arg_17_1
end

IRCManager._handle_meta = function (arg_18_0, arg_18_1, arg_18_2, arg_18_3, arg_18_4)
	-- function 18
	if arg_18_1 == Irc.CHANNEL_MSG then
		local find, var_18_1 = string.find(arg_18_3, "$META;")

		if not var_18_1 then
			local sub = string.sub(arg_18_3, var_18_1 + 1)

			Managers.irc:parse_metadata(sub, arg_18_2, arg_18_4)

			return true
		end
	end

	return false
end

IRCManager._create_metadata_table = function (arg_19_0, arg_19_1, arg_19_2, arg_19_3, arg_19_4)
	-- function 19
	return "$META;" .. arg_19_1 .. ";" .. arg_19_2 .. ";" .. arg_19_3 .. ";" .. arg_19_4
end

IRCManager.parse_metadata = function (self, arg_20_1, arg_20_2, arg_20_3)
	-- function 20
	local split_deprecated = string.split_deprecated(arg_20_1, ";")
	local var_20_1 = self._channel_members[arg_20_3][arg_20_2]

	if not var_20_1 then
		local var_20_2 = split_deprecated[2]

		var_20_2 = not var_20_2 and tonumber(split_deprecated[2])
		var_20_1.icon_id = var_20_2
		var_20_1.level = split_deprecated[3]
		var_20_1.info = split_deprecated[4]

		self:_update_meta_data(arg_20_2, arg_20_3, var_20_1)
	else
		print("\tMissing user data")
	end
end

IRCManager._update_meta_data = function (self, arg_21_1, arg_21_2, arg_21_3)
	-- function 21
	local META_MSG = Irc.META_MSG
	local var_21_1 = self._callback_by_type[META_MSG]

	if not var_21_1 then
		for k, v in pairs(var_21_1) do
			v(k, META_MSG, arg_21_1, arg_21_2, arg_21_3)
		end
	end
end

IRCManager.get_channel_members = function (self, arg_22_1)
	-- function 22
	if not arg_22_1 and not self._channel_members[arg_22_1] then
		return self._channel_members[arg_22_1]
	else
		return {}
	end
end

IRCManager.get_channels = function (self)
	-- function 23
	return self._channels
end

IRCManager._parse_names_list = function (arg_24_0, arg_24_1, arg_24_2, arg_24_3, arg_24_4)
	-- function 24
	local find, var_24_1 = string.find(arg_24_4, arg_24_1 .. " :")
	local sub = string.sub(arg_24_4, var_24_1)
	local split_deprecated = string.split_deprecated(sub, " ")

	for i, v in ipairs(split_deprecated) do
		print(v)
	end
end

IRCManager.update = function (self, arg_25_1)
	-- function 25
	IRCStates[self._state](self, arg_25_1)
end

IRCManager.cb_connect_token_received = function (self, arg_26_1)
	-- function 26
	print("[IrcManager:cb_connect_token_received] Result: " .. tostring(arg_26_1.result))
	self:_change_state("verify_connection")
end

IRCManager._change_state = function (self, arg_27_1)
	-- function 27
	fassert(IRCStates[arg_27_1], "[IRCManager] There is no state called %s", arg_27_1)
	fn("Leaving state: %s", self._state)

	self._state = arg_27_1

	fn("Entering state: %s", self._state)
end

IRCManager._notify_connected = function (self, arg_28_1)
	-- function 28
	if not self._callback then
		self._callback(arg_28_1)
	end
end

local IRCStates = IRCStates

IRCStates = IRCStates or {}
IRCStates = IRCStates

IRCStates.none = function (arg_29_0, arg_29_1)
	-- function 29
	return
end

IRCStates.initialize = function (self, arg_30_1)
	-- function 30
	if not IS_PS4 then
		self._initialized = true

		self:_change_state("connect")

		return
	end

	if not Irc.is_initialized() then
		Application.error("[IRCManager] Failed initializing IRC")
		self:_change_state("disconnect")

		return
	end

	self._initialized = Irc.initialize()

	if not self._initialized then
		self:_change_state("connect")
	else
		Application.error("[IRCManager] Failed initializing IRC")
		self:_change_state("disconnect")
	end
end

IRCStates.connect = function (self, arg_31_1)
	-- function 31
	local _host_address = self._host_address
	local _port = self._port
	local str = "justinfan" .. Math.random(9999)
	local _user_name = self._user_name

	_user_name = _user_name or str

	local _password = self._password

	_password = _password or nil

	local connect_async_token = Irc.connect_async_token(_host_address, _port, _user_name, _password)
	local var_31_6 = ScriptIrcToken:new(connect_async_token)

	Managers.token:register_token(var_31_6, callback(self, "cb_connect_token_received"))
	self:_change_state("wait_for_connection")

	self._connection_retries = self._connection_retries + 1
end

IRCStates.join_channel = function (self, arg_32_1)
	-- function 32
	if not Irc.is_connected() then
		self:join_channel(self._auto_join_channel)

		self._auto_join_channel = false

		self:_change_state("connected")
		self:_notify_connected(true)
	else
		Application.error("[IRCManager] Disconnected from server")
		self:_change_state("disconnect")
	end
end

IRCStates.connected = function (self, arg_33_1)
	-- function 33
	if not Irc.is_connected() then
		for i, v in ipairs(tbl) do
			Irc.send_message(v.message, v.channel_or_user)
		end

		table.clear(tbl)

		local poll_message, var_33_1, var_33_2, var_33_3 = Irc.poll_message()

		if not var_33_2 then
			self:_handle_irc_message(poll_message, var_33_1, var_33_2, var_33_3)
		end
	else
		Application.error("[IRCManager] Disconnected from server")
		self:_change_state("disconnect")
	end
end

IRCStates.disconnect = function (self, arg_34_1)
	-- function 34
	if not Irc.is_connected() then
		Irc.disconnect()
	end

	self:_notify_connected(false)
	self:_reset()
	self:_change_state("none")
end

IRCStates.verify_connection = function (self, arg_35_1)
	-- function 35
	if not Irc.is_connected() then
		if not self._auto_join_channel then
			self:_change_state("join_channel")
		else
			self:_change_state("connected")
			self:_notify_connected(true)
		end
	elseif self._connection_retries > num then
		local _host_address = self._host_address
		local _port = self._port
		local str = "justinfan" .. Math.random(9999)
		local _user_name = self._user_name

		_user_name = _user_name or str

		Application.error("[IRCManager] Failed connecting to " .. _host_address .. ":" .. _port .. " with user_name: " .. _user_name)
		self:_change_state("disconnect")
	end
end

IRCStates.wait_for_connection = function (arg_36_0, arg_36_1)
	-- function 36
	return
end
