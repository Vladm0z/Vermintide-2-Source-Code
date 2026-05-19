-- chunkname: @scripts/ui/views/level_end/level_end_view_wrapper.lua

require("scripts/ui/views/level_end/level_end_view_v2")

local var_0_0 = {
	"rpc_signal_end_of_level_done",
	"rpc_notify_lobby_joined"
}

for iter_0_0, iter_0_1 in pairs(DLCSettings) do
	local var_0_1 = iter_0_1.end_view

	if var_0_1 then
		table.map(var_0_1, require)
	end
end

LevelEndViewWrapper = class(LevelEndViewWrapper)

function LevelEndViewWrapper.init(arg_1_0, arg_1_1)
	arg_1_0._level_end_view_context = arg_1_1

	arg_1_0:_create_input_service()

	arg_1_0._delayed_calls = {}

	arg_1_0:_load_level_packages()
end

function LevelEndViewWrapper._load_level_packages(arg_2_0)
	arg_2_0._level_packages = arg_2_0._level_end_view_context.level_end_view_packages or {}

	local var_2_0 = true
	local var_2_1 = true
	local var_2_2 = callback(arg_2_0, "cb_package_loaded")

	if not table.is_empty(arg_2_0._level_packages) then
		for iter_2_0, iter_2_1 in ipairs(arg_2_0._level_packages) do
			Managers.package:load(iter_2_1, "end_screen", var_2_2, var_2_0, var_2_1)
		end
	else
		var_2_2()
	end
end

function LevelEndViewWrapper.cb_package_loaded(arg_3_0)
	for iter_3_0, iter_3_1 in ipairs(arg_3_0._level_packages) do
		if not Managers.package:has_loaded(iter_3_1, "end_screen") then
			return
		end
	end

	arg_3_0:_initiate_level_end_view()
end

function LevelEndViewWrapper._unload_level_packages(arg_4_0)
	for iter_4_0, iter_4_1 in ipairs(arg_4_0._level_packages) do
		Managers.package:unload(iter_4_1, "end_screen")
	end
end

function LevelEndViewWrapper.active_input_service(arg_5_0)
	return arg_5_0._level_end_view:active_input_service()
end

function LevelEndViewWrapper.enable_chat(arg_6_0)
	if not arg_6_0._level_end_view then
		return false
	end

	return arg_6_0._level_end_view:enable_chat()
end

function LevelEndViewWrapper._initiate_level_end_view(arg_7_0)
	local var_7_0 = arg_7_0._level_end_view_context.level_end_view

	if var_7_0 then
		arg_7_0._level_end_view = rawget(_G, var_7_0):new(arg_7_0._level_end_view_context)
	else
		arg_7_0._level_end_view = LevelEndView:new(arg_7_0._level_end_view_context)
	end

	for iter_7_0 = 1, #arg_7_0._delayed_calls do
		local var_7_1 = arg_7_0._delayed_calls[iter_7_0]

		arg_7_0._level_end_view[var_7_1.func](arg_7_0._level_end_view, unpack(var_7_1.parameters))
	end

	table.clear(arg_7_0._delayed_calls)
end

function LevelEndViewWrapper._create_input_service(arg_8_0)
	local var_8_0 = Managers.input

	var_8_0:create_input_service("end_of_level", "IngameMenuKeymaps", "EndLevelViewKeymapsFilters")
	var_8_0:map_device_to_service("end_of_level", "keyboard")
	var_8_0:map_device_to_service("end_of_level", "mouse")
	var_8_0:map_device_to_service("end_of_level", "gamepad")
	var_8_0:block_device_except_service("end_of_level", "keyboard", 1)
	var_8_0:block_device_except_service("end_of_level", "mouse", 1)
	var_8_0:block_device_except_service("end_of_level", "gamepad", 1)

	arg_8_0._level_end_view_context.input_manager = var_8_0
end

function LevelEndViewWrapper.destroy(arg_9_0)
	if arg_9_0._registered_rpcs then
		arg_9_0:unregister_rpcs()
	end

	if not Managers.chat:chat_is_focused() then
		local var_9_0 = Managers.input

		var_9_0:device_unblock_all_services("keyboard")
		var_9_0:device_unblock_all_services("mouse")
		var_9_0:device_unblock_all_services("gamepad")
	end

	if arg_9_0._level_end_view then
		arg_9_0._level_end_view:delete()

		arg_9_0._level_end_view = nil
	end

	arg_9_0._level_end_view_context = nil

	arg_9_0:_unload_level_packages()
end

function LevelEndViewWrapper.game_state_changed(arg_10_0)
	arg_10_0:_create_input_service()

	local var_10_0 = Managers.input

	if arg_10_0._level_end_view then
		arg_10_0._level_end_view:set_input_manager(var_10_0)
	else
		arg_10_0._delayed_calls[#arg_10_0._delayed_calls + 1] = {
			func = "set_input_manager",
			parameters = {
				var_10_0
			}
		}
	end
end

function LevelEndViewWrapper.start(arg_11_0, ...)
	if arg_11_0._level_end_view then
		arg_11_0._level_end_view:start()
	else
		arg_11_0._delayed_calls[#arg_11_0._delayed_calls + 1] = {
			func = "start",
			parameters = {
				...
			}
		}
	end
end

function LevelEndViewWrapper.done(arg_12_0)
	if not arg_12_0._level_end_view then
		return false
	end

	return arg_12_0._level_end_view:done()
end

function LevelEndViewWrapper.do_retry(arg_13_0)
	if not arg_13_0._level_end_view then
		return
	end

	return arg_13_0._level_end_view:do_retry()
end

function LevelEndViewWrapper.register_rpcs(arg_14_0, arg_14_1)
	arg_14_1:register(arg_14_0, unpack(var_0_0))

	arg_14_0._network_event_delegate = arg_14_1
	arg_14_0._registered_rpcs = true
end

function LevelEndViewWrapper.unregister_rpcs(arg_15_0)
	arg_15_0._network_event_delegate:unregister(arg_15_0)

	arg_15_0._network_event_delegate = nil
	arg_15_0._registered_rpcs = false
end

function LevelEndViewWrapper.rpc_signal_end_of_level_done(arg_16_0, ...)
	if arg_16_0._level_end_view then
		arg_16_0._level_end_view:rpc_signal_end_of_level_done(...)
	else
		arg_16_0._delayed_calls[#arg_16_0._delayed_calls + 1] = {
			func = "rpc_signal_end_of_level_done",
			parameters = {
				...
			}
		}
	end
end

function LevelEndViewWrapper.rpc_notify_lobby_joined(arg_17_0, ...)
	if arg_17_0._level_end_view then
		arg_17_0._level_end_view:rpc_notify_lobby_joined(...)
	else
		arg_17_0._delayed_calls[#arg_17_0._delayed_calls + 1] = {
			func = "rpc_notify_lobby_joined",
			parameters = {
				...
			}
		}
	end
end

function LevelEndViewWrapper.left_lobby(arg_18_0, ...)
	if arg_18_0._level_end_view then
		arg_18_0._level_end_view:left_lobby(...)
	else
		arg_18_0._delayed_calls[#arg_18_0._delayed_calls + 1] = {
			func = "left_lobby",
			parameters = {
				...
			}
		}
	end
end

function LevelEndViewWrapper.update(arg_19_0, arg_19_1, arg_19_2)
	if arg_19_0._level_end_view then
		arg_19_0._level_end_view:update(arg_19_1, arg_19_2)
	end
end

function LevelEndViewWrapper.post_update(arg_20_0, arg_20_1, arg_20_2)
	if arg_20_0._level_end_view then
		arg_20_0._level_end_view:post_update(arg_20_1, arg_20_2)
	end
end
