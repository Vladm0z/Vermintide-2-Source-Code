-- chunkname: @scripts/managers/perfhud/perfhud_manager.lua

PerfhudManager = class(PerfhudManager)

local PerfhudSettings = PerfhudSettings

PerfhudSettings = PerfhudSettings or {}
PerfhudSettings = PerfhudSettings
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

PerfhudManager.init = function (self)
	-- function 1
	self._active_huds = {}
	self._accumulated_index = nil
end

PerfhudManager.update = function (self, arg_2_1, arg_2_2)
	-- function 2
	if not script_data.perfhud then
		return
	end

	local flag = Keyboard.button(Keyboard.button_index("left shift")) > 0.5 or Keyboard.button(Keyboard.button_index("right shift")) > 0.5

	for k, v in pairs(PerfhudSettings) do
		if not Keyboard.pressed(Keyboard.button_index(v.key)) then
			self:_toggle_hud(k, flag)
		end
	end

	self:_update_peer_index(arg_2_1, arg_2_2)
end

PerfhudManager._update_peer_index = function (self, arg_3_1, arg_3_2)
	-- function 3
	local pressed = Keyboard.pressed(Keyboard.button_index("left ctrl"))

	pressed = pressed or Keyboard.pressed(Keyboard.button_index("right ctrl"))

	if not (not pressed and self._accumulated_index) then
		self._accumulated_index = ""
	elseif not pressed then
		self:_set_peer_index(self._accumulated_index)

		self._accumulated_index = nil
	end

	if not self._accumulated_index then
		self:_parse_keystrokes(Keyboard.keystrokes())
	end
end

PerfhudManager._parse_keystrokes = function (self, arg_4_1)
	-- function 4
	for i, v in ipairs(arg_4_1) do
		if not (v == "1" or v == "2" or v == "3" or v == "4" or v == "5" or v == "6" or v == "7" or v == "8" or v == "9" or v ~= "0") then
			self._accumulated_index = self._accumulated_index .. v
		end
	end
end

PerfhudManager._set_peer_index = function (arg_5_0, arg_5_1)
	-- function 5
	Application.console_command("perfhud", "network_peer", arg_5_1)
end

PerfhudManager._toggle_hud = function (self, arg_6_1, arg_6_2)
	-- function 6
	local var_6_0 = self._active_huds[arg_6_1]

	if not arg_6_2 then
		self:_close_all_huds()
	end

	if not arg_6_2 and not var_6_0 then
		self:_close_hud(arg_6_1)
	elseif not var_6_0 then
		self:_open_hud(arg_6_1)
	end
end

PerfhudManager._close_all_huds = function (self)
	-- function 7
	for k, v in pairs(self._active_huds) do
		self:_close_hud(k)
	end
end

PerfhudManager._open_hud = function (arg_8_0, arg_8_1)
	-- function 8
	arg_8_0._active_huds[arg_8_1] = true

	Application.console_command("perfhud", arg_8_1, unpack(PerfhudSettings[arg_8_1].custom_parameters))
end

PerfhudManager._close_hud = function (arg_9_0, arg_9_1)
	-- function 9
	arg_9_0._active_huds[arg_9_1] = nil

	Application.console_command("perfhud", arg_9_1)
end

PerfhudManager.destroy = function (self, arg_10_1, arg_10_2)
	-- function 10
	self:_close_all_huds()
end
