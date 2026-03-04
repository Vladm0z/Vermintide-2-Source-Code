-- chunkname: @scripts/managers/game_mode/mechanisms/game_mode_custom_settings_handler.lua

GameModeCustomSettingsHandlerUtility = GameModeCustomSettingsHandlerUtility or {}

function GameModeCustomSettingsHandlerUtility.parse_packed_custom_settings(arg_1_0, arg_1_1)
	local var_1_0 = FrameTable.alloc_table()
	local var_1_1 = string.split(arg_1_0, ";")
	local var_1_2 = GameModeSettings[arg_1_1].custom_game_settings_templates

	for iter_1_0 = 1, #var_1_1, 2 do
		local var_1_3 = tonumber(var_1_1[iter_1_0])
		local var_1_4 = tonumber(var_1_1[iter_1_0 + 1])

		if not var_1_3 or not var_1_4 then
			break
		end

		local var_1_5 = var_1_2[var_1_3]
		local var_1_6 = var_1_5.setting_name
		local var_1_7 = var_1_5.values[var_1_4]

		var_1_0[#var_1_0 + 1] = {
			name = var_1_6,
			value = var_1_7,
			template = var_1_5
		}
	end

	return var_1_0
end

GameModeCustomSettingsHandler = class(GameModeCustomSettingsHandler)

local var_0_0 = {
	"rpc_game_mode_custom_settings_full_sync",
	"rpc_game_mode_custom_settings_request_full_sync",
	"rpc_game_mode_custom_settings_handler_set_enabled"
}

function GameModeCustomSettingsHandler.init(arg_2_0, arg_2_1, arg_2_2)
	arg_2_0._game_mode_settings = GameModeSettings[arg_2_1]
	arg_2_0._settings_template = arg_2_0._game_mode_settings.custom_game_settings_templates
	arg_2_0._settings = {}

	arg_2_0:set_enabled(false)
end

function GameModeCustomSettingsHandler.server_set_setting(arg_3_0, arg_3_1, arg_3_2)
	fassert(arg_3_0._enabled, "GameModeCustomSettingsHandler is disabled, cannot set setting %s", tostring(arg_3_1))

	local var_3_0 = arg_3_0._settings_template[arg_3_1]

	arg_3_0._settings[var_3_0.id] = arg_3_2

	arg_3_0:_print_settings()

	local var_3_1 = Managers.mechanism:network_handler():get_match_handler()
	local var_3_2 = arg_3_0:pack_settings(arg_3_0._settings, arg_3_0._settings_template)

	var_3_1:send_rpc_others("rpc_game_mode_custom_settings_full_sync", var_3_2, arg_3_0._enabled)
end

function GameModeCustomSettingsHandler.pack_settings(arg_4_0, arg_4_1, arg_4_2)
	local var_4_0 = FrameTable.alloc_table()

	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		var_4_0[iter_4_0] = arg_4_2[iter_4_0].values_reverse_lookup[iter_4_1]
	end

	return var_4_0
end

function GameModeCustomSettingsHandler.get_packed_custom_settings(arg_5_0)
	local var_5_0 = ""
	local var_5_1 = arg_5_0._settings
	local var_5_2 = false
	local var_5_3 = arg_5_0._settings_template

	for iter_5_0, iter_5_1 in ipairs(var_5_1) do
		if iter_5_1 ~= var_5_3[iter_5_0].default then
			local var_5_4 = iter_5_0
			local var_5_5 = var_5_3[iter_5_0].values_reverse_lookup[iter_5_1]

			var_5_0 = var_5_0 .. string.format("%s;%s;", var_5_4, var_5_5)
			var_5_2 = true
		end
	end

	return var_5_2 and var_5_0 or "n/a"
end

function GameModeCustomSettingsHandler.unpack_settings(arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = {}

	for iter_6_0, iter_6_1 in ipairs(arg_6_1) do
		var_6_0[iter_6_0] = arg_6_2[iter_6_0].values[iter_6_1]
	end

	return var_6_0
end

function GameModeCustomSettingsHandler.request_full_sync(arg_7_0)
	local var_7_0 = Managers.mechanism:network_handler():get_match_handler()

	if var_7_0:is_leader() then
		var_7_0:send_rpc_up("rpc_game_mode_custom_settings_request_full_sync")
	end
end

function GameModeCustomSettingsHandler.get_setting(arg_8_0, arg_8_1)
	local var_8_0 = arg_8_0._settings_template[arg_8_1]
	local var_8_1

	if var_8_0 then
		var_8_1 = arg_8_0._settings[var_8_0.id]
	end

	return var_8_1, arg_8_0._enabled
end

function GameModeCustomSettingsHandler.reset_custom_settings(arg_9_0)
	for iter_9_0, iter_9_1 in ipairs(arg_9_0._settings_template) do
		arg_9_0._settings[iter_9_0] = iter_9_1.default
	end
end

function GameModeCustomSettingsHandler.set_enabled(arg_10_0, arg_10_1, arg_10_2)
	arg_10_0._enabled = arg_10_1

	if not arg_10_1 then
		arg_10_0:reset_custom_settings()
	end

	if DEDICATED_SERVER then
		return
	end

	if arg_10_2 then
		local var_10_0 = Managers.mechanism:network_handler()
		local var_10_1 = var_10_0 and var_10_0:get_match_handler()

		if var_10_1 and var_10_1:is_match_owner() then
			printf("GameModeCustomSettingsHandler: match_owner called set_enabled(%s)", tostring(arg_10_1))
			var_10_1:send_rpc_others("rpc_game_mode_custom_settings_handler_set_enabled", arg_10_1)
		end
	end
end

function GameModeCustomSettingsHandler.is_enabled(arg_11_0)
	return arg_11_0._enabled
end

function GameModeCustomSettingsHandler.register_rpcs(arg_12_0, arg_12_1)
	arg_12_1:register(arg_12_0, unpack(var_0_0))
end

function GameModeCustomSettingsHandler.unregister_rpcs(arg_13_0, arg_13_1)
	arg_13_1:unregister(arg_13_0)
end

function GameModeCustomSettingsHandler.get_settings(arg_14_0)
	return arg_14_0._settings, arg_14_0._enabled
end

function GameModeCustomSettingsHandler.get_settings_template(arg_15_0)
	return arg_15_0._settings_template
end

function GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_full_sync(arg_16_0, arg_16_1, arg_16_2, arg_16_3)
	arg_16_0:set_enabled(arg_16_3)

	arg_16_0._settings = arg_16_0:unpack_settings(arg_16_2, arg_16_0._settings_template)

	arg_16_0:_print_settings()
	Managers.mechanism:network_handler():get_match_handler():propagate_rpc("rpc_game_mode_custom_settings_full_sync", CHANNEL_TO_PEER_ID[arg_16_1], arg_16_2, arg_16_3)
end

function GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_request_full_sync(arg_17_0, arg_17_1)
	local var_17_0 = CHANNEL_TO_PEER_ID[arg_17_1]

	if var_17_0 then
		local var_17_1 = Managers.mechanism:network_handler():get_match_handler()
		local var_17_2 = arg_17_0:pack_settings(arg_17_0._settings, arg_17_0._settings_template)

		var_17_1:send_rpc("rpc_game_mode_custom_settings_full_sync", var_17_0, var_17_2, arg_17_0._enabled)
	end
end

function GameModeCustomSettingsHandler.rpc_game_mode_custom_settings_handler_set_enabled(arg_18_0, arg_18_1, arg_18_2)
	printf("GameModeCustomSettingsHandler: rpc_game_mode_custom_settings_handler_set_enabled, enabled = %s", tostring(arg_18_2))
	arg_18_0:set_enabled(arg_18_2)

	local var_18_0 = Managers.state.event

	if var_18_0 then
		var_18_0:trigger("lobby_member_game_mode_custom_settings_handler_enabled", arg_18_2)
	end

	local var_18_1 = Managers.mechanism:network_handler()
	local var_18_2 = var_18_1 and var_18_1:get_match_handler()

	if var_18_2 then
		var_18_2:propagate_rpc("rpc_game_mode_custom_settings_handler_set_enabled", CHANNEL_TO_PEER_ID[arg_18_1], arg_18_2)
	end
end

function GameModeCustomSettingsHandler._print_settings(arg_19_0)
	local var_19_0 = string.format("GameModeCustomSettingsHandler: settings updated: \n Custom Settings Enabled = %s \n", arg_19_0._enabled)

	for iter_19_0 = 1, #arg_19_0._settings_template do
		local var_19_1 = arg_19_0._settings_template[iter_19_0].setting_name
		local var_19_2 = arg_19_0:get_setting(var_19_1)
		local var_19_3 = string.format("\n %s: %s", var_19_1, var_19_2)

		var_19_0 = var_19_0 .. var_19_3
	end

	print(var_19_0)
end

function GameModeCustomSettingsHandler.get_telemetry_data(arg_20_0)
	local var_20_0 = {}
	local var_20_1 = {}

	for iter_20_0 = 1, #arg_20_0._settings_template do
		local var_20_2 = arg_20_0._settings_template[iter_20_0]
		local var_20_3 = var_20_2.setting_name
		local var_20_4 = arg_20_0:get_setting(var_20_3)

		var_20_0[var_20_3] = var_20_4

		if var_20_4 ~= var_20_2.default then
			var_20_1[#var_20_1 + 1] = var_20_3
		end
	end

	local var_20_5 = #var_20_1 == 0 and true or false

	return var_20_0, var_20_5, var_20_1
end

function GameModeCustomSettingsHandler.destroy(arg_21_0)
	arg_21_0._game_mode_settings = nil
	arg_21_0._settings_template = nil
	arg_21_0._settings = nil
	arg_21_0._enabled = nil
end
