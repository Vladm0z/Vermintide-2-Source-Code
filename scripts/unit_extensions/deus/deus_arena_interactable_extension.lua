-- chunkname: @scripts/unit_extensions/deus/deus_arena_interactable_extension.lua

DeusArenaInteractableExtension = class(DeusArenaInteractableExtension)

local var_0_0 = {
	INTERACTED = 2,
	WAITING = 1
}
local var_0_1 = {
	"rpc_deus_set_arena_interactable_state"
}

DeusArenaInteractableExtension.init = function (arg_1_0, arg_1_1, arg_1_2, arg_1_3)
	arg_1_0._unit = arg_1_2
	arg_1_0._is_server = arg_1_1.is_server
	arg_1_0._world = arg_1_1.world
	arg_1_0._state = var_0_0.WAITING
	arg_1_0._override_interactable_action = Unit.get_data(arg_1_2, "override_interactable_action")
	arg_1_0._level_unit_id = Level.unit_index(LevelHelper:current_level(arg_1_0._world), arg_1_2)

	arg_1_0:register_rpcs(arg_1_1.network_transmit.network_event_delegate)
end

DeusArenaInteractableExtension.register_rpcs = function (arg_2_0, arg_2_1)
	arg_2_0._network_event_delegate = arg_2_1

	arg_2_1:register(arg_2_0, unpack(var_0_1))
end

DeusArenaInteractableExtension.unregister_rpcs = function (arg_3_0)
	if arg_3_0._network_event_delegate then
		arg_3_0._network_event_delegate:unregister(arg_3_0)
	end

	arg_3_0._network_event_delegate = nil
end

DeusArenaInteractableExtension.destroy = function (arg_4_0)
	arg_4_0:unregister_rpcs()
end

DeusArenaInteractableExtension.hot_join_sync = function (arg_5_0, arg_5_1)
	local var_5_0 = arg_5_0:_get_state()

	Managers.state.network.network_transmit:send_rpc("rpc_deus_set_arena_interactable_state", arg_5_1, arg_5_0._level_unit_id, var_5_0)
end

DeusArenaInteractableExtension.update = function (arg_6_0, arg_6_1, arg_6_2, arg_6_3, arg_6_4, arg_6_5)
	local var_6_0 = arg_6_0._prev_state
	local var_6_1 = arg_6_0:_get_state()

	if var_6_0 ~= var_6_1 then
		arg_6_0:_on_state_changed(var_6_0, var_6_1)

		arg_6_0._prev_state = var_6_1
	end

	local var_6_2 = arg_6_0._timer

	if var_6_2 and var_6_2 < arg_6_5 then
		var_6_2 = nil

		if Unit.get_data(arg_6_0._unit, "arena_interactable_data", "end_game") then
			Managers.state.game_mode:complete_level()
		end

		if Unit.get_data(arg_6_0._unit, "arena_interactable_data", "activate_end_zone") then
			local var_6_3 = Unit.get_data(arg_6_0._unit, "arena_interactable_data", "end_zone_name")

			assert(var_6_3, "[DeusArenaInteractableExtension] - [end_zone_name] is not set while [activate_end_zone]")
			Managers.state.entity:system("end_zone_system"):activate_end_zone_by_name(var_6_3)
		end
	end

	arg_6_0._timer = var_6_2
end

DeusArenaInteractableExtension._on_state_changed = function (arg_7_0, arg_7_1, arg_7_2)
	local var_7_0 = arg_7_0._unit

	if arg_7_2 == var_0_0.WAITING then
		Unit.flow_event(var_7_0, "state_WAITING")
	elseif arg_7_2 == var_0_0.INTERACTED then
		Unit.flow_event(var_7_0, "state_INTERACTED")

		local var_7_1 = Unit.get_data(var_7_0, "arena_interactable_data", "interact_level_event_name")

		if var_7_1 ~= "default" then
			LevelHelper:flow_event(arg_7_0._world, var_7_1)
		end
	end
end

DeusArenaInteractableExtension.rpc_deus_set_arena_interactable_state = function (arg_8_0, arg_8_1, arg_8_2, arg_8_3)
	if arg_8_0._level_unit_id == arg_8_2 then
		arg_8_0._state = arg_8_3
	end
end

DeusArenaInteractableExtension.can_interact = function (arg_9_0)
	return arg_9_0:_get_state() == var_0_0.WAITING
end

DeusArenaInteractableExtension.get_interact_hud_description = function (arg_10_0)
	if Managers.mechanism:game_mechanism():get_deus_run_controller():get_current_node().base_level == DEUS_LEVEL_SETTINGS.arena_citadel.base_level_name then
		return "deus_altar_hud_desc"
	else
		return "interaction_action_take"
	end
end

DeusArenaInteractableExtension.on_server_interact = function (arg_11_0, arg_11_1, arg_11_2, arg_11_3, arg_11_4, arg_11_5, arg_11_6, arg_11_7)
	if arg_11_0:_get_state() == var_0_0.WAITING then
		if HEALTH_ALIVE[arg_11_2] then
			local var_11_0 = ScriptUnit.extension_input(arg_11_2, "dialogue_system")
			local var_11_1 = FrameTable.alloc_table()
			local var_11_2 = Unit.get_data(arg_11_0._unit, "arena_interactable_data", "interactor_vo_line")

			var_11_0:trigger_dialogue_event(var_11_2, var_11_1)
		end

		arg_11_0._timer = arg_11_6 + Unit.get_data(arg_11_0._unit, "arena_interactable_data", "delay")

		LevelHelper:flow_event(arg_11_0._world, "on_arena_end_triggered")
		arg_11_0:_set_state(var_0_0.INTERACTED)
	end
end

DeusArenaInteractableExtension.on_client_interact = function (arg_12_0, arg_12_1, arg_12_2, arg_12_3, arg_12_4, arg_12_5, arg_12_6, arg_12_7)
	if not arg_12_0._is_server then
		arg_12_0._state = var_0_0.INTERACTED
	end
end

DeusArenaInteractableExtension._get_state = function (arg_13_0)
	return arg_13_0._state
end

DeusArenaInteractableExtension._set_state = function (arg_14_0, arg_14_1)
	Managers.state.network.network_transmit:send_rpc_clients("rpc_deus_set_arena_interactable_state", arg_14_0._level_unit_id, arg_14_1)

	arg_14_0._state = arg_14_1
end

DeusArenaInteractableExtension.override_interactable_action = function (arg_15_0)
	return arg_15_0._override_interactable_action
end
