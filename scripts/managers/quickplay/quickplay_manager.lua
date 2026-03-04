-- chunkname: @scripts/managers/quickplay/quickplay_manager.lua

local var_0_0 = {
	"rpc_set_has_pending_quick_game"
}

QuickplayManager = class(QuickplayManager)

QuickplayManager.init = function (arg_1_0, arg_1_1, arg_1_2)
	arg_1_0._is_server = arg_1_2
	arg_1_0._has_pending_quick_game = false
	arg_1_0._is_quick_game = not not arg_1_1.quickplay_bonus
	arg_1_1.quickplay_bonus = nil

	if not arg_1_2 then
		arg_1_0._joined_via_quickplay = arg_1_0._is_quick_game

		if LevelSettings[Managers.level_transition_handler:get_current_level_key()].hub_level then
			arg_1_0:set_has_pending_quick_game(arg_1_0._is_quick_game)
		end
	end
end

QuickplayManager.is_quick_game = function (arg_2_0)
	return arg_2_0._is_quick_game
end

QuickplayManager.set_is_weave_quick_game = function (arg_3_0)
	arg_3_0._is_quick_game = true
end

QuickplayManager.set_has_pending_quick_game = function (arg_4_0, arg_4_1)
	if arg_4_0._has_pending_quick_game ~= arg_4_1 and arg_4_0._is_server and arg_4_0._network_transmit then
		arg_4_0._network_transmit:send_rpc_clients("rpc_set_has_pending_quick_game", arg_4_1)
	end

	arg_4_0._has_pending_quick_game = arg_4_1
end

QuickplayManager.has_pending_quick_game = function (arg_5_0)
	return arg_5_0._has_pending_quick_game
end

QuickplayManager.on_round_start = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3)
	arg_6_0:_register_rpcs(arg_6_1, arg_6_3)
end

QuickplayManager.on_round_end = function (arg_7_0)
	arg_7_0:_unregister_rpcs()
end

QuickplayManager._register_rpcs = function (arg_8_0, arg_8_1, arg_8_2)
	if not arg_8_0._network_event_delegate then
		arg_8_0._network_event_delegate = arg_8_1

		arg_8_1:register(arg_8_0, unpack(var_0_0))

		arg_8_0._network_transmit = arg_8_2
	end
end

QuickplayManager._unregister_rpcs = function (arg_9_0)
	if arg_9_0._network_event_delegate then
		arg_9_0._network_event_delegate:unregister(arg_9_0)

		arg_9_0._network_event_delegate = nil
		arg_9_0._network_transmit = nil
	end
end

QuickplayManager.hot_join_sync = function (arg_10_0, arg_10_1)
	if arg_10_0._has_pending_quick_game then
		arg_10_0._network_transmit:send_rpc("rpc_set_has_pending_quick_game", arg_10_1, true)
	end
end

QuickplayManager.rpc_set_has_pending_quick_game = function (arg_11_0, arg_11_1, arg_11_2)
	if not arg_11_0._joined_via_quickplay then
		arg_11_0:set_has_pending_quick_game(arg_11_2)
	end
end
