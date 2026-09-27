-- chunkname: @scripts/ui/views/level_end/level_end_view_wrapper.lua

require("scripts/ui/views/level_end/level_end_view_v2")

local tbl = {
	"rpc_signal_end_of_level_done",
	"rpc_notify_lobby_joined"
}

for k, v in pairs(DLCSettings) do
	local end_view = v.end_view

	if not end_view then
		table.map(end_view, require)
	end
end

LevelEndViewWrapper = class(LevelEndViewWrapper)

LevelEndViewWrapper.init = function (self, arg_1_1)
	-- function 1
	self._level_end_view_context = arg_1_1

	self:_create_input_service()

	self._delayed_calls = {}

	self:_load_level_packages()
end

LevelEndViewWrapper._load_level_packages = function (self)
	-- function 2
	local level_end_view_packages = self._level_end_view_context.level_end_view_packages

	level_end_view_packages = level_end_view_packages or {}
	self._level_packages = level_end_view_packages

	local flag = true
	local flag_2 = true
	local var_2_3 = callback(self, "cb_package_loaded")

	if not table.is_empty(self._level_packages) then
		for i, v in ipairs(self._level_packages) do
			Managers.package:load(v, "end_screen", var_2_3, flag, flag_2)
		end
	else
		var_2_3()
	end
end

LevelEndViewWrapper.cb_package_loaded = function (self)
	-- function 3
	for i, v in ipairs(self._level_packages) do
		if not Managers.package:has_loaded(v, "end_screen") then
			return
		end
	end

	self:_initiate_level_end_view()
end

LevelEndViewWrapper._unload_level_packages = function (self)
	-- function 4
	for i, v in ipairs(self._level_packages) do
		Managers.package:unload(v, "end_screen")
	end
end

LevelEndViewWrapper.active_input_service = function (self)
	-- function 5
	return self._level_end_view:active_input_service()
end

LevelEndViewWrapper.enable_chat = function (self)
	-- function 6
	if not self._level_end_view then
		return false
	end

	return self._level_end_view:enable_chat()
end

LevelEndViewWrapper._initiate_level_end_view = function (self)
	-- function 7
	local level_end_view = self._level_end_view_context.level_end_view

	if not level_end_view then
		self._level_end_view = rawget(_G, level_end_view):new(self._level_end_view_context)
	else
		self._level_end_view = LevelEndView:new(self._level_end_view_context)
	end

	for i = 1, #self._delayed_calls do
		local var_7_1 = self._delayed_calls[i]

		self._level_end_view[var_7_1.func](self._level_end_view, unpack(var_7_1.parameters))
	end

	table.clear(self._delayed_calls)
end

LevelEndViewWrapper._create_input_service = function (arg_8_0)
	-- function 8
	local input = Managers.input

	input:create_input_service("end_of_level", "IngameMenuKeymaps", "EndLevelViewKeymapsFilters")
	input:map_device_to_service("end_of_level", "keyboard")
	input:map_device_to_service("end_of_level", "mouse")
	input:map_device_to_service("end_of_level", "gamepad")
	input:block_device_except_service("end_of_level", "keyboard", 1)
	input:block_device_except_service("end_of_level", "mouse", 1)
	input:block_device_except_service("end_of_level", "gamepad", 1)

	arg_8_0._level_end_view_context.input_manager = input
end

LevelEndViewWrapper.destroy = function (self)
	-- function 9
	if not self._registered_rpcs then
		self:unregister_rpcs()
	end

	if not Managers.chat:chat_is_focused() then
		local input = Managers.input

		input:device_unblock_all_services("keyboard")
		input:device_unblock_all_services("mouse")
		input:device_unblock_all_services("gamepad")
	end

	if not self._level_end_view then
		self._level_end_view:delete()

		self._level_end_view = nil
	end

	self._level_end_view_context = nil

	self:_unload_level_packages()
end

LevelEndViewWrapper.game_state_changed = function (self)
	-- function 10
	self:_create_input_service()

	local input = Managers.input

	if not self._level_end_view then
		self._level_end_view:set_input_manager(input)
	else
		self._delayed_calls[#self._delayed_calls + 1] = {
			func = "set_input_manager",
			parameters = {
				input
			}
		}
	end
end

LevelEndViewWrapper.start = function (self, ...)
	-- function 11
	if not self._level_end_view then
		self._level_end_view:start()
	else
		self._delayed_calls[#self._delayed_calls + 1] = {
			func = "start",
			parameters = {
				...
			}
		}
	end
end

LevelEndViewWrapper.done = function (self)
	-- function 12
	if not self._level_end_view then
		return false
	end

	return self._level_end_view:done()
end

LevelEndViewWrapper.do_retry = function (self)
	-- function 13
	if not self._level_end_view then
		return
	end

	return self._level_end_view:do_retry()
end

LevelEndViewWrapper.register_rpcs = function (self, arg_14_1)
	-- function 14
	arg_14_1:register(self, unpack(tbl))

	self._network_event_delegate = arg_14_1
	self._registered_rpcs = true
end

LevelEndViewWrapper.unregister_rpcs = function (self)
	-- function 15
	self._network_event_delegate:unregister(self)

	self._network_event_delegate = nil
	self._registered_rpcs = false
end

LevelEndViewWrapper.rpc_signal_end_of_level_done = function (self, ...)
	-- function 16
	if not self._level_end_view then
		self._level_end_view:rpc_signal_end_of_level_done(...)
	else
		self._delayed_calls[#self._delayed_calls + 1] = {
			func = "rpc_signal_end_of_level_done",
			parameters = {
				...
			}
		}
	end
end

LevelEndViewWrapper.rpc_notify_lobby_joined = function (self, ...)
	-- function 17
	if not self._level_end_view then
		self._level_end_view:rpc_notify_lobby_joined(...)
	else
		self._delayed_calls[#self._delayed_calls + 1] = {
			func = "rpc_notify_lobby_joined",
			parameters = {
				...
			}
		}
	end
end

LevelEndViewWrapper.left_lobby = function (self, ...)
	-- function 18
	if not self._level_end_view then
		self._level_end_view:left_lobby(...)
	else
		self._delayed_calls[#self._delayed_calls + 1] = {
			func = "left_lobby",
			parameters = {
				...
			}
		}
	end
end

LevelEndViewWrapper.update = function (self, arg_19_1, arg_19_2)
	-- function 19
	if not self._level_end_view then
		self._level_end_view:update(arg_19_1, arg_19_2)
	end
end

LevelEndViewWrapper.post_update = function (self, arg_20_1, arg_20_2)
	-- function 20
	if not self._level_end_view then
		self._level_end_view:post_update(arg_20_1, arg_20_2)
	end
end
