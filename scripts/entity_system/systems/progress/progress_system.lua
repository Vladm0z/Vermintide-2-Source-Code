-- chunkname: @scripts/entity_system/systems/progress/progress_system.lua

ProgressSystem = class(ProgressSystem, ExtensionSystemBase)

local var_0_0 = {
	"PlayerInZoneExtension"
}
local var_0_1 = {
	"rpc_player_in_zone_set_active",
	"rpc_player_in_zone_end_event"
}

ProgressSystem.init = function (arg_1_0, arg_1_1, arg_1_2)
	ProgressSystem.super.init(arg_1_0, arg_1_1, arg_1_2, var_0_0)

	arg_1_0._world = arg_1_1.world
	arg_1_0._network_event_delegate = arg_1_1.network_event_delegate

	arg_1_0._network_event_delegate:register(arg_1_0, unpack(var_0_1))

	arg_1_0._existing_units = {}
end

ProgressSystem.on_add_extension = function (arg_2_0, arg_2_1, arg_2_2, arg_2_3, arg_2_4)
	local var_2_0 = ProgressSystem.super.on_add_extension(arg_2_0, arg_2_1, arg_2_2, arg_2_3)

	arg_2_0._existing_units[arg_2_2] = var_2_0

	return var_2_0
end

ProgressSystem.on_remove_extension = function (arg_3_0, arg_3_1, arg_3_2)
	arg_3_0._existing_units[arg_3_1] = nil

	ProgressSystem.super.on_remove_extension(arg_3_0, arg_3_1, arg_3_2)
end

ProgressSystem.destroy = function (arg_4_0)
	arg_4_0._network_event_delegate:unregister(arg_4_0)
end

ProgressSystem.rpc_player_in_zone_end_event = function (arg_5_0, arg_5_1, arg_5_2)
	local var_5_0 = LevelHelper:unit_by_index(arg_5_0._world, arg_5_2)

	if arg_5_0._existing_units[var_5_0] then
		arg_5_0._existing_units[var_5_0]:end_event()
	end
end

ProgressSystem.rpc_player_in_zone_set_active = function (arg_6_0, arg_6_1, arg_6_2)
	if arg_6_0._is_server then
		local var_6_0 = Managers.state.network
		local var_6_1 = CHANNEL_TO_PEER_ID[arg_6_1]

		var_6_0.network_transmit:send_rpc_clients_except("rpc_player_in_zone_set_active", var_6_1, arg_6_2)
	end

	local var_6_2 = LevelHelper:unit_by_index(arg_6_0._world, arg_6_2)

	if arg_6_0._existing_units[var_6_2] then
		arg_6_0._existing_units[var_6_2]:set_active_rpc()
	end
end
