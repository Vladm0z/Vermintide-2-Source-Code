-- chunkname: @scripts/managers/perfhud/perfhud_manager.lua

PerfhudManager = class(PerfhudManager)
PerfhudSettings = PerfhudSettings or {}
PerfhudSettings.artist = {
	key = "f1",
	custom_parameters = {}
}
PerfhudSettings.network = {
	key = "f2",
	custom_parameters = {}
}
PerfhudSettings.network_peers = {
	key = "f3",
	custom_parameters = {}
}
PerfhudSettings.network_messages = {
	key = "f4",
	custom_parameters = {}
}
PerfhudSettings.network_qos = {
	key = "f5",
	custom_parameters = {}
}
PerfhudSettings.network_ping = {
	key = "f6",
	custom_parameters = {}
}
PerfhudSettings.lua = {
	key = "f7",
	custom_parameters = {}
}

PerfhudManager.init = function (arg_1_0)
	arg_1_0._active_huds = {}
	arg_1_0._accumulated_index = nil
end

PerfhudManager.update = function (arg_2_0, arg_2_1, arg_2_2)
	if not script_data.perfhud then
		return
	end

	local var_2_0 = Keyboard.button(Keyboard.button_index("left shift")) > 0.5 or Keyboard.button(Keyboard.button_index("right shift")) > 0.5

	for iter_2_0, iter_2_1 in pairs(PerfhudSettings) do
		if Keyboard.pressed(Keyboard.button_index(iter_2_1.key)) then
			arg_2_0:_toggle_hud(iter_2_0, var_2_0)
		end
	end

	arg_2_0:_update_peer_index(arg_2_1, arg_2_2)
end

PerfhudManager._update_peer_index = function (arg_3_0, arg_3_1, arg_3_2)
	local var_3_0 = Keyboard.pressed(Keyboard.button_index("left ctrl")) or Keyboard.pressed(Keyboard.button_index("right ctrl"))

	if var_3_0 and not arg_3_0._accumulated_index then
		arg_3_0._accumulated_index = ""
	elseif var_3_0 then
		arg_3_0:_set_peer_index(arg_3_0._accumulated_index)

		arg_3_0._accumulated_index = nil
	end

	if arg_3_0._accumulated_index then
		arg_3_0:_parse_keystrokes(Keyboard.keystrokes())
	end
end

PerfhudManager._parse_keystrokes = function (arg_4_0, arg_4_1)
	for iter_4_0, iter_4_1 in ipairs(arg_4_1) do
		if iter_4_1 == "1" or iter_4_1 == "2" or iter_4_1 == "3" or iter_4_1 == "4" or iter_4_1 == "5" or iter_4_1 == "6" or iter_4_1 == "7" or iter_4_1 == "8" or iter_4_1 == "9" or iter_4_1 == "0" then
			arg_4_0._accumulated_index = arg_4_0._accumulated_index .. iter_4_1
		end
	end
end

PerfhudManager._set_peer_index = function (arg_5_0, arg_5_1)
	Application.console_command("perfhud", "network_peer", arg_5_1)
end

PerfhudManager._toggle_hud = function (arg_6_0, arg_6_1, arg_6_2)
	local var_6_0 = arg_6_0._active_huds[arg_6_1]

	if not arg_6_2 then
		arg_6_0:_close_all_huds()
	end

	if arg_6_2 and var_6_0 then
		arg_6_0:_close_hud(arg_6_1)
	elseif not var_6_0 then
		arg_6_0:_open_hud(arg_6_1)
	end
end

PerfhudManager._close_all_huds = function (arg_7_0)
	for iter_7_0, iter_7_1 in pairs(arg_7_0._active_huds) do
		arg_7_0:_close_hud(iter_7_0)
	end
end

PerfhudManager._open_hud = function (arg_8_0, arg_8_1)
	arg_8_0._active_huds[arg_8_1] = true

	Application.console_command("perfhud", arg_8_1, unpack(PerfhudSettings[arg_8_1].custom_parameters))
end

PerfhudManager._close_hud = function (arg_9_0, arg_9_1)
	arg_9_0._active_huds[arg_9_1] = nil

	Application.console_command("perfhud", arg_9_1)
end

PerfhudManager.destroy = function (arg_10_0, arg_10_1, arg_10_2)
	arg_10_0:_close_all_huds()
end
