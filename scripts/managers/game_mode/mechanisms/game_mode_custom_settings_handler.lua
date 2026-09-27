-- chunkname: @scripts/managers/game_mode/mechanisms/game_mode_custom_settings_handler.lua

local GameModeCustomSettingsHandlerUtility = GameModeCustomSettingsHandlerUtility

GameModeCustomSettingsHandlerUtility = GameModeCustomSettingsHandlerUtility or {}
GameModeCustomSettingsHandlerUtility = GameModeCustomSettingsHandlerUtility

GameModeCustomSettingsHandlerUtility.parse_packed_custom_settings = function (arg_1_0, arg_1_1)
	-- function 1
	local alloc_table = FrameTable.alloc_table()
	local split = string.split(arg_1_0, ";")
	local custom_game_settings_templates = GameModeSettings[arg_1_1].custom_game_settings_templates

	for i = 1, #split, 2 do
		local var_1_3 = tonumber(split[i])
		local var_1_4 = tonumber(split[i + 1])

		if not (not var_1_3 and var_1_4) then
			break
		end

		local var_1_5 = custom_game_settings_templates[var_1_3]
		local setting_name = var_1_5.setting_name
		local var_1_7 = var_1_5.values[var_1_4]

		alloc_table[#alloc_table + 1] = {
			name = setting_name,
			value = var_1_7,
			template = var_1_5
		}
	end

	return alloc_table
end

GameModeCustomSettingsHandler = class(GameModeCustomSettingsHandler)

local tbl = {
	"rpc_game_mode_custom_settings_full_sync",
	"rpc_game_mode_custom_settings_request_full_sync",
	"rpc_game_mode_custom_settings_handler_set_enabled"
}

GameModeCustomSettingsHandler.init = function (self, arg_2_1, arg_2_2)
	-- function 2
	self._game_mode_settings = GameModeSettings[arg_2_1]
	self._settings_template = self._game_mode_settings.custom_game_settings_templates
	self._settings = {}

	self:set_enabled(false)
end

GameModeCustomSettingsHandler.server_set_setting = function (self, arg_3_1, arg_3_2)
	-- function 3
	fassert(self._enabled, "GameModeCustomSettingsHandler is disabled, cannot set setting %s", tostring(arg_3_1))

	local var_3_0 = self._settings_template[arg_3_1]

	self._settings[var_3_0.id] = arg_3_2

	self:_print_settings()

	local get_match_handler = Managers.mechanism:network_handler():get_match_handler()
	local pack_settings = self:pack_settings(self._settings, self._settings_template)

	get_match_handler:send_rpc_others("rpc_game_mode_custom_settings_full_sync", pack_settings, self._enabled)
end

GameModeCustomSettingsHandler.pack_settings = function (arg_4_0, arg_4_1, arg_4_2)
	-- function 4
	local alloc_table = FrameTable.alloc_table()

	for i, v in ipairs(arg_4_1) do
		alloc_table[i] = arg_4_2[i].values_reverse_lookup[v]
	end

	return alloc_table
end

GameModeCustomSettingsHandler.get_packed_custom_settings = function (self)
	-- function 5
	local str = ""
	local _settings = self._settings
	local flag = false
	local _settings_template = self._settings_template

	for i, v in ipairs(_settings) do
		if v ~= _settings_template[i].default then
			local var_5_4 = i
			local var_5_5 = _settings_template[i].values_reverse_lookup[v]

			str = str .. string.format("%s;%s;", var_5_4, var_5_5)
			flag = true
		end
	end

	return not flag and str and "n/a"
end

GameModeCustomSettingsHandler.unpack_settings = function (arg_6_0, arg_6_1, arg_6_2)
	-- function 6
	local tbl = {}

	for i, v in ipairs(arg_6_1) do
		tbl[i] = arg_6_2[i].values[v]
	end

	return tbl
end

GameModeCustomSettingsHandler.request_full_sync = function (arg_7_0)
	-- function 7
	local get_match_handler = Managers.mechanism:network_handler():get_match_handler()

	if not get_match_handler:is_leader() then
		get_match_handler:send_rpc_up("rpc_game_mode_custom_settings_request_full_sync")
	end
end

GameModeCustomSettingsHandler.get_setting = function (self, arg_8_1)
	-- function 8
	local var_8_0 = self._settings_template[arg_8_1]
	local var_8_1

	if not var_8_0 then
		var_8_1 = self._settings[var_8_0.id]
	end

	return var_8_1, self._enabled
end

GameModeCustomSettingsHandler.reset_custom_settings = function (self)
	-- function 9
	for i, v in ipairs(self._settings_template) do
		self._settings[i] = v.default
	end
end

GameModeCustomSettingsHandler.set_enabled = function (self, arg_10_1, arg_10_2)
	-- function 10
	self._enabled = arg_10_1

	if not arg_10_1 then
		self:reset_custom_settings()
	end

	if not DEDICATED_SERVER then
		return
	end

	if not arg_10_2 then
		local network_handler = Managers.mechanism:network_handler()
		local flag = not network_handler and network_handler:get_match_handler()

		if not flag and not flag:is_match_owner() then
			printf("GameModeCustomSettingsHandler: match_owner called set_enabled(%s)", tostring(arg_10_1))
			flag:send_rpc_others("rpc_game_mode_custom_settings_handler_set_enabled", arg_10_1)
		end
	end
end

GameModeCustomSettingsHandler.is_enabled = function (self)
	-- function 11
	return self._enabled
end

GameModeCustomSettingsHandler.register_rpcs = function (arg_12_0, arg_12_1)
	-- function 12
	arg_12_1:register(arg_12_0, unpack(tbl))
end

GameModeCustomSettingsHandler.unregister_rpcs = function (arg_13_0, arg_13_1)
	-- function 13
	arg_13_1:unregister(arg_13_0)
end

GameModeCustomSettingsHandler.get_settings = function (self)
	-- function 14
	return self._settings, self._enabled
end

GameModeCustomSettingsHandler.get_settings_template = function (self)
	-- function 15
	return self._settings_template
end

GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_full_sync = function (self, arg_16_1, arg_16_2, arg_16_3)
	-- function 16
	self:set_enabled(arg_16_3)

	self._settings = self:unpack_settings(arg_16_2, self._settings_template)

	self:_print_settings()
	Managers.mechanism:network_handler():get_match_handler():propagate_rpc("rpc_game_mode_custom_settings_full_sync", CHANNEL_TO_PEER_ID[arg_16_1], arg_16_2, arg_16_3)
end

GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_request_full_sync = function (self, arg_17_1)
	-- function 17
	local var_17_0 = CHANNEL_TO_PEER_ID[arg_17_1]

	if not var_17_0 then
		local get_match_handler = Managers.mechanism:network_handler():get_match_handler()
		local pack_settings = self:pack_settings(self._settings, self._settings_template)

		get_match_handler:send_rpc("rpc_game_mode_custom_settings_full_sync", var_17_0, pack_settings, self._enabled)
	end
end

GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_handler_set_enabled = function (self, arg_18_1, arg_18_2)
	-- function 18
	printf("GameModeCustomSettingsHandler: rpc_game_mode_custom_settings_handler_set_enabled, enabled = %s", tostring(arg_18_2))
	self:set_enabled(arg_18_2)

	local event = Managers.state.event

	if not event then
		event:trigger("lobby_member_game_mode_custom_settings_handler_enabled", arg_18_2)
	end

	local network_handler = Managers.mechanism:network_handler()
	local flag = not network_handler and network_handler:get_match_handler()

	if not flag then
		flag:propagate_rpc("rpc_game_mode_custom_settings_handler_set_enabled", CHANNEL_TO_PEER_ID[arg_18_1], arg_18_2)
	end
end

GameModeCustomSettingsHandler._print_settings = function (self)
	-- function 19
	local format = string.format("GameModeCustomSettingsHandler: settings updated: \n Custom Settings Enabled = %s \n", self._enabled)

	for i = 1, #self._settings_template do
		local setting_name = self._settings_template[i].setting_name
		local get_setting = self:get_setting(setting_name)
		local format_2 = string.format("\n %s: %s", setting_name, get_setting)

		format = format .. format_2
	end

	print(format)
end

GameModeCustomSettingsHandler.get_telemetry_data = function (self)
	-- function 20
	local tbl = {}
	local tbl_2 = {}

	for i = 1, #self._settings_template do
		local var_20_2 = self._settings_template[i]
		local setting_name = var_20_2.setting_name
		local get_setting = self:get_setting(setting_name)

		tbl[setting_name] = get_setting

		if get_setting ~= var_20_2.default then
			tbl_2[#tbl_2 + 1] = setting_name
		end
	end

	local flag

	flag = #tbl_2 ~= 0 or not true or false

	return tbl, flag, tbl_2
end

GameModeCustomSettingsHandler.destroy = function (self)
	-- function 21
	self._game_mode_settings = nil
	self._settings_template = nil
	self._settings = nil
	self._enabled = nil
end
